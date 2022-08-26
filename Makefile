all: os-image
# Run bochs to simulate booting of our code.
#brun.bxrc is conf file
run: all
	env/Bochs/bochs.exe -f bochs-config.bxrc -q  



# This is the actual disk image that the computer loads ,
# which is the combination of our compiled bootsector and kernel
os-image: boot_sect.bin kernel.bin
	copy /b boot_sect.bin+kernel.bin $@


CSRC = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

#TODO: make src depend on header files


OBJ = ${CSRC:.c=.o}


# This builds the binary of our kernel from two object files :
# - the kernel_entry , which jumps to main () in our kernel
# - the compiled C kernel
kernel.bin : kernel/kernel_entry.o ${OBJ}
	ld -T NUL -o kernel.tmp -Ttext 0x1000 $< ${OBJ}
	objcopy -O binary -j .text  kernel.tmp kernel.bin 




kernel/%.o : kernel/%.c ${HEADERS}
	gcc -ffreestanding -c $< -o $@
kernel/%.o : kernel/%.asm
	nasm $< -f elf -o $@
%.bin : kernel/%.asm
	nasm $< -f bin -I '../../16bit/' -o $@

boot/%.o : boot/%.c ${HEADERS}
	gcc -ffreestanding -c $< -o $@
boot/%.o : boot/%.asm
	nasm $< -f elf -o $@
%.bin : boot/%.asm
	nasm $< -f bin -I '../../16bit/' -o $@

drivers/%.o : drivers/%.c ${HEADERS}
	gcc -ffreestanding -c $< -o $@
drivers/%.o : drivers/%.asm
	nasm $< -f elf -o $@
%.bin : drivers/%.asm
	nasm $< -f bin -I '../../16bit/' -o $@



clean:
	del -fr *.bin *.dis *.o *.tmp os-image 
	del kernel\*.o 
	del drivers\*.o 
#del -fr kernel/*.o boot/*.bin drivers/*.o
# Disassemble our kernel - might be useful for debugging.
debug:
	ndisasm -b 32 kernel.bin > kernel.dis
	notepad kernel.dis
	del kernel.dis