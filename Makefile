
boot:
	nasm ./src/boot.asm -f bin -o boot.bin

run:
	qemu-system-i386 --nographic boot_sect_simple.bin
