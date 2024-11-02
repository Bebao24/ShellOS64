%include "src/boot/x86_64/multiboot2.inc"

global long_mode_start
extern multiboot_framebuffer_data
extern multiboot_mmap_data
extern multiboot_basic_meminfo
extern multiboot_acpi_info
extern multiboot_tag_start
extern multiboot_tag_end

extern page_table_l2
extern page_table_l3
extern page_table_l4

extern kernel_start

[bits 64]

section .text
long_mode_start:
    ; Setup data segments
    mov ax, 0x10
    mov es, ax
    mov ds, ax
    mov gs, ax
    mov fs, ax
    mov ss, ax

    call kernel_start

    cli
    hlt





