
boot_sect_simple:
	nasm boot_sect_simple.asm -f bin -o boot_sect_simple.bin

run:
	qemu-system-i386 --nographic boot_sect_simple.bin
