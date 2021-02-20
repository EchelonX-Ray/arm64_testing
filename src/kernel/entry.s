.section .text

.globl my_entry_pt

my_entry_pt:
  // Load 0x80003FF0 into Stack Pointer
  //mov x0, #0x20040000
  mrs x0, VMPIDR_EL2
  and x0, x0, #0x3
  cmp x0, #0x0
  bne loop
  
  ldr x1, =kmain
  //mov x2, #0xC0030000
  mov x2, #0x00030000
  mov sp, x2
  //orr sp, 0x100000
  //slli a0, a0, 4
  //lui sp, 0x80003
  //or sp, sp, a0
  //mv a0, zero
  
  blr x1

loop:
  //wfi
  nop
  b loop

.section section_KHEAP_START

.globl KHEAP_START

KHEAP_START:
