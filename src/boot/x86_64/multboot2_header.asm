section .multiboot2_header

header_start:
    ; align 8
    dd 0xe85250d6 ; Magic number (multboot2)
    dd 0 ; i386 protected mode
    dd header_end - header_start ; The size of the header

    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start)) ; Check sum

; framebuffer_tag_start:
;     dw 0x05 ; Type = framebuffer
;     dw 0x01 ; Optional tag

;     dd framebuffer_tag_end - framebuffer_tag_start ; The size of the framebuffer tag
;     dd 1024 ; Width
;     dd 768 ; Height
;     dd 32 ; BPP

; framebuffer_tag_end:
;     align 8
    
    ; End tag
    dw 0
    dw 0
    dd 8
header_end:

