os.image:boot.bin kernel.bin img.bin
	cat boot.bin kernel.bin img.bin > os.img

boot.bin:boot/boot_loader.asm
	nasm -f bin boot/boot_loader.asm -o boot.bin

kernel.bin:kernel.o kernel_entry.o
	ld -melf_i386 -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary

kernel.o:kernel/kernel.c
	gcc -m32 -ffreestanding -c kernel/kernel.c -o kernel.o

kernel_entry.o:kernel/kernel_entry.asm
	nasm kernel/kernel_entry.asm -f elf -o kernel_entry.o

img.bin:boot/img.asm
	nasm -f bin boot/img.asm -o img.bin

clean:
	rm *.bin *.o
run:os.img
	qemu-system-i386 os.img
