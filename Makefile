include build/config.mk

TARGET_ASMFLAGS += -f elf64
TARGET_CFLAGS += -ffreestanding -nostdlib -I src/kernel -I src/libc -I src/kernel/debug -I lib/boot -I src/kernel/memory
TARGET_LIBS += -lgcc
TARGET_LINKFLAGS += -T arch/x86_64/linker.ld -nostdlib

ASM_SOURCES := $(shell find src -name "*.asm")
ASM_OBJECTS := $(patsubst %.asm, bin/x86_64/asm/%.o, $(ASM_SOURCES))

C_SOURCES := $(shell find src -name "*.c")
C_OBJECTS := $(patsubst %.c, bin/x86_64/c/%.o, $(C_SOURCES))

ASM_HEADERS := $(shell find src -name "*.inc")
C_HEADERS := $(shell find src -name "*.h")

.PHONY: all iso_image clean run

all: iso_image

iso_image: dist/x86_64/ShellOS.iso
dist/x86_64/ShellOS.iso: $(ASM_OBJECTS) $(C_OBJECTS)
	@ mkdir -p dist/x86_64
	$(TARGET_LD) $(TARGET_LINKFLAGS) -o dist/x86_64/kernel.bin $^ $(TARGET_LIBS)
	cp dist/x86_64/kernel.bin arch/x86_64/iso/boot/kernel.bin
	grub-mkrescue /usr/lib/grub/i386-pc -o $@ arch/x86_64/iso

$(ASM_OBJECTS): bin/x86_64/asm/%.o : %.asm $(ASM_HEADERS)
	@ mkdir -p $(dir $@)
	$(TARGET_ASM) $(TARGET_ASMFLAGS) $(patsubst bin/x86_64/asm/%.o, %.asm, $@) -o $@
	@ echo "Assembly " $<

$(C_OBJECTS): bin/x86_64/c/%.o : %.c $(C_HEADERS)
	@ mkdir -p $(dir $@)
	$(TARGET_CC) $(TARGET_CFLAGS) -c $(patsubst bin/x86_64/c/%.o, %.c, $@) -o $@
	@ echo "Compiled " $<


clean:
	rm -rf bin/
	rm -rf dist/

run:
	qemu-system-x86_64 -debugcon stdio -cdrom dist/x86_64/ShellOS.iso -display sdl,gl=on



