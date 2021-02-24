void pstr(char* str) {
	volatile unsigned int* AUX_MU_IO_REG = (unsigned int*)(0x3f201000 + 0x00);
	volatile unsigned int* AUX_MU_LSR_REG = (unsigned int*)(0x3f201000 + 0x18);
	while (*str != 0) {
		while (*AUX_MU_LSR_REG & 0x00000020) {
			// TX FIFO Full
		}
		*AUX_MU_IO_REG = (unsigned int)((unsigned char)*str);
		str++;
	}
	return;
}

signed int kmain(unsigned int argc, char* argv[], char* envp[]) {
	char* text = "Test Output String\n";
	volatile unsigned int* AUXENB = 0;
	//AUXENB = (unsigned int*)(0x20200000 + 0x00);
	//*AUXENB |= 0x00024000;
	//AUXENB = (unsigned int*)(0x20200000 + 0x08);
	//*AUXENB |= 0x00000480;

	// Set Baud Rate
	//AUXENB = (unsigned int*)(0x3f200000 + 0x24);
	//AUXENB = (unsigned int*)(0x3f200000 + 0x28);


	AUXENB = (unsigned int*)(0x3f200000 + 0x04);
	*AUXENB = 0;
	// Set GPIO Pin 14 to Mode: ALT0 (UART0)
	*AUXENB |= (04u << ((14 - 10) * 3));
	// Set GPIO Pin 15 to Mode: ALT0 (UART0)
	*AUXENB |= (04u << ((15 - 10) * 3));

	AUXENB = (unsigned int*)(0x3f200000 + 0x08);
	*AUXENB = 0;
	// Set GPIO Pin 23 to Mode: Output
	*AUXENB |= (01u << ((23 - 20) * 3));
	// Set GPIO Pin 24 to Mode: Output
	*AUXENB |= (01u << ((24 - 20) * 3));
	
	// Turn on pin 23
	AUXENB = (unsigned int*)(0x3f200000 + 0x1C);
	*AUXENB = (1u << 23);
	
	// Turn off pin 24
	AUXENB = (unsigned int*)(0x3f200000 + 0x28);
	*AUXENB = (1u << 24);

	// Enable TX on UART0
	AUXENB = (unsigned int*)(0x3f201000 + 0x30);
	*AUXENB = 0x00000100;

	pstr(text);
	return 0;
}
