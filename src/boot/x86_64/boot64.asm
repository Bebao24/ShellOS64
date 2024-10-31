global long_mode_start

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

    mov byte [0xb8000], 'h' ; Test

    cli
    hlt


