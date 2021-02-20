void pstr(char* str) {
	volatile unsigned int* AUX_MU_IO_REG = (unsigned int*)(0x3f201000 + 0x00);
	volatile unsigned int* AUX_MU_LSR_REG = (unsigned int*)(0x3f201000 + 0x18);
	while (*str != 0) {
		while (*AUX_MU_LSR_REG & 0x00000020) {
		}
		*AUX_MU_IO_REG = (unsigned int)((unsigned char)*str);
		str++;
	}
	return;
}

signed int kmain(unsigned int argc, char* argv[], char* envp[]) {
	char* text = "Test Output String\n";
	//volatile unsigned int* AUXENB = (unsigned int*)(unsigned int*)(0x20200000 + 0x00);
	//*AUXENB |= 0x00024000;
	//AUXENB = (unsigned int*)(unsigned int*)(0x20200000 + 0x08);
	//*AUXENB |= 0x00000480;
	//AUXENB = (unsigned int*)(unsigned int*)(0x20201000 + 0x30);
	//*AUXENB |= 0x00000100;
	pstr(text);
	return 0;
}
