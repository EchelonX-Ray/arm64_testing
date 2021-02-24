TUPLE   := aarch64-unknown-linux-gnu
CC      := $(TUPLE)-gcc
OBJCPY  := $(TUPLE)-objcopy
STRIP   := $(TUPLE)-strip
CFLAGS  := -Wall -Wextra -std=c99 -O2 -march=armv8-a -mtune=cortex-a53 -mlittle-endian -ffreestanding -nostdlib -nostartfiles -Wno-unused-parameter -fno-stack-check -fno-stack-protector
LDFLAGS := -static
GFILES  := 
KFILES  := 
UFILES  := 

# Global Library
#GFILES  := $(GFILES)

# Kernel
#  - Core (Entry/System Setup/Globals)
KFILES  := $(KFILES) ./src/kernel/base.o
KFILES  := $(KFILES) ./src/kernel/entry.o

# Programs
#  - Init
#UFILES  := $(UFILES)

export TUPLE
export CC
export OBJCPY
export STRIP
export CFLAGS
export LDFLAGS
export GFILES
export KFILES
export UFILES

.PHONY: all rebuild clean

all: prog-metal.elf prog-metal.elf.strip prog-metal.elf.bin prog-metal.elf.hex prog-metal.elf.strip.bin prog-metal.elf.strip.hex

rebuild: clean
	$(MAKE) all

clean:
	rm -f *.elf *.strip *.bin *.hex $(GFILES) $(KFILES) $(UFILES)

%.o: %.c
	$(CC) $(CFLAGS) $^ -c -o $@

%.o: %.s
	$(CC) $(CFLAGS) $^ -c -o $@

prog-metal.elf: $(GFILES) $(KFILES) $(UFILES)
	$(CC) $(CFLAGS) $^ -T ./bare_metal.ld $(LDFLAGS) -o $@

prog-%.elf.strip: prog-%.elf
	$(STRIP) -s -x -R .comment -R .text.startup -R .riscv.attributes $^ -o $@

%.elf.bin: %.elf
	$(OBJCPY) -O binary $^ $@

%.elf.hex: %.elf
	$(OBJCPY) -O ihex $^ $@

%.strip.bin: %.strip
	$(OBJCPY) -O binary $^ $@

%.strip.hex: %.strip
	$(OBJCPY) -O ihex $^ $@

emu: prog-emu.elf.strip.bin
	qemu-system-aarch64 -kernel ./prog-metal.elf.strip.bin -m 1G -cpu cortex-a53 -M raspi3 -serial stdio -display none

emu-debug: prog-emu.elf.strip.bin
	qemu-system-aarch64 -kernel ./prog-metal.elf.strip.bin -m 1G -cpu cortex-a53 -M raspi3 -serial stdio -display none -gdb tcp::1234 -S

debug:
	$(TUPLE)-gdb -ex "target remote localhost:1234" -ex "layout asm" -ex "tui reg general" -ex "break *0x00080000" -ex "break *0x00000000" -ex "set scheduler-locking step"
