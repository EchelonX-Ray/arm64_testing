.section .text

.globl my_entry_pt

// This is the Arm64 Kernel Header (64 bytes total)
my_entry_pt:
  b end_of_header // Executable code (64 bits)
  .align 3, 0, 7
  .quad my_entry_pt // text_offset (64 bits)
  .quad 0x0000000000000000 // image_size (64 bits)
  .quad 0x000000000000000A // flags (1010: Anywhere, 4K Pages, LE) (64 bits)
  .quad 0x0000000000000000 // reserved 2 (64 bits)
  .quad 0x0000000000000000 // reserved 3 (64 bits)
  .quad 0x0000000000000000 // reserved 4 (64 bits)
  .int 0x644d5241 // magic (32 bits)
  .int 0x00000000 // reserved 5 (32 bits)

end_of_header:
  // Check What Core This Is
  mrs x0, VMPIDR_EL2
  and x0, x0, #0x3
  cmp x0, #0x0
  // If this is not core 0, go into an infinite loop
  bne loop

  // Setup the Stack Pointer
  mov x2, #0x00030000
  mov sp, x2
  // Get the address of the C main function
  ldr x1, =kmain
  // Call the C main function
  blr x1

loop:
  nop
  b loop

.section section_KHEAP_START

.globl KHEAP_START

KHEAP_START:
