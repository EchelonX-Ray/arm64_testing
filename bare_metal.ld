/*
This is not actually needed (At least not on actual hardware.), but 
it explicitly sets the entry point in the .elf file to be the same 
as the true entry point to the program. The global symbol my_entry_pt
is located at the start of src/kernel/entry.s.  More on this below.
*/
ENTRY(my_entry_pt)

MEMORY
{
	/*
	This is the memory address where this program will reside.
	It is the reset vector.
	*/
	ram (rwx)  : ORIGIN = 0x00080000, LENGTH = 0x0000FFFF
}

SECTIONS
{
	/*
	Force the linker to starting at the start of memory section: ram
	*/
	. = 0x00080000;
	
	.text : {
		/*
		Make sure the .text section from src/kernel/entry.o is 
		linked first.  The .text section of src/kernel/entry.s 
		is the actual entry machine code for the kernel and is 
		first in the file.  This way, at reset, exection starts 
		by jumping to this machine code.
		*/
		src/kernel/entry.o (.text);
		
		/*
		Link the rest of the kernel's .text sections.
		*/
		*.o (.text);
	} > ram
	
	/*
	Put in the .rodata in the flash after the actual machine code.
	*/
	.rodata : {
		*.o (.rodata);
		*.o (.rodata.*);
	} > ram
	
	/*
	END: Read Only Data
	START: Writable Data
	*/
	.sbss : {
		*.o (.sbss);
	} > ram
	.bss : {
		*.o (.bss);
	} > ram
	section_KHEAP_START (NOLOAD) : ALIGN(0x10) {
		/*
		At the very end of the space reserved for global variables 
		in the ram, link in this custom section.  This is used to
		add a symbol called KHEAP_START to the program that will 
		inform the C code where the heap can start.  This allows the 
		heap to start right after the global variables.
		*/
		src/kernel/entry.o (section_KHEAP_START);
	} > ram
	
	/*
	Discard everything that hasn't be explictly linked.  I don't
	want the linker to guess where to put stuff.  If it doesn't know, 
	don't include it.  If this casues a linking error, good.  I want 
	to know that I need to fix something, rather than a silent failure 
	that could cause hard to debug issues later.
	*/
	/DISCARD/ : {
		* (.*);
	}
}
