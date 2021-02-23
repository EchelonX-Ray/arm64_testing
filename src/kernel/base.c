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
	// Set GPIO Pin 14 to Mode: ALT0 (UART0)
	*AUXENB |= (0x4 << 12);
	// Set GPIO Pin 15 to Mode: ALT0 (UART0)
	*AUXENB |= (0x4 << 15);
	
	// Enable TX on UART0
	AUXENB = (unsigned int*)(0x3f201000 + 0x30);
	*AUXENB = 0x00000100;
	
	pstr(text);
	return 0;
}
