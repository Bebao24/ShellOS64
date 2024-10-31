include build/config.mk

TARGET_ASMFLAGS += -f elf64
TARGET_CFLAGS += -ffreestanding -nostdlib
TARGET_LIBS += -lgcc
TARGET_LINKFLAGS += -T arch/x86_64/linker.ld -nostdlib

ASM_SOURCES := $(shell find src -name "*.asm")
ASM_OBJECTS := $(patsubst %.asm, bin/i686/asm/%.o, $(ASM_SOURCES))

ASM_HEADERS := $(shell find src -name "*.inc")

.PHONY: all iso_image clean run

all: iso_image

iso_image: dist/x86_64/ShellOS.iso
dist/x86_64/ShellOS.iso: $(ASM_OBJECTS)
	@ mkdir -p dist/x86_64
	$(TARGET_LD) $(TARGET_LINKFLAGS) -o dist/x86_64/kernel.bin $^
	cp dist/x86_64/kernel.bin arch/x86_64/iso/boot/kernel.bin
	grub-mkrescue /usr/lib/grub/i386-pc -o $@ arch/x86_64/iso

$(ASM_OBJECTS): bin/i686/asm/%.o : %.asm $(ASM_HEADERS)
	@ mkdir -p $(dir $@)
	$(TARGET_ASM) $(TARGET_ASMFLAGS) $(patsubst bin/i686/asm/%.o, %.asm, $@) -o $@
	@ echo "Assembly " $<


clean:
	rm -rf bin/
	rm -rf dist/

run:
	qemu-system-x86_64 -cdrom dist/x86_64/ShellOS.iso -display sdl,gl=on



