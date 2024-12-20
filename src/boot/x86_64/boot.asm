extern long_mode_start
global start

global page_table_l4
global page_table_l3
global page_table_l2

[bits 32]

section .text

start:
    mov edi, eax ; magic number
    mov esi, ebx ; multiboot2 struct

    mov esp, stack_top ; Setup stack pointer

    call check_cpuid
    call check_long_mode

    call setup_page_tables
    call enable_paging

    lgdt [gdt64.pointer]
    jmp gdt64.code_segment:long_mode_start

    cli
    hlt

check_cpuid:
    pushfd
    pop eax
    mov ecx, eax
    xor eax, 1 << 21 ; Flip the CPUID bit
    push eax
    popfd
    pushfd
    pop eax
    push ecx
    popfd
    cmp eax, ecx
    je .no_cpuid
    ret

.no_cpuid:
    mov al, 'C'
    jmp error

check_long_mode:
    mov eax, 0x80000000
	cpuid
	cmp eax, 0x80000001
	jb .no_long_mode

	mov eax, 0x80000001
	cpuid
	test edx, 1 << 29
	jz .no_long_mode

    ret

.no_long_mode:
    mov al, 'L'
    jmp error

setup_page_tables:
    mov eax, page_table_l3
    or eax, 0b11 ; Writeable, present
    mov [page_table_l4], eax

    mov eax, page_table_l2
    or eax, 0b11 ; Writeable, present
    mov [page_table_l3], eax

    mov ecx, 0 ; Setup loop counter

.loop:
    mov eax, 0x200000 ; Identity map the first 2 MB
    mul ecx
    or eax, 0b10000011 ; Huge page, writeable and present
    mov [page_table_l2 + ecx * 8], eax

    inc ecx
    cmp ecx, 512 ; Check if the whole table if mapped
    jne .loop

.done:
    ret

enable_paging:
    ; Pass the location of the PML4 to the CPU
    mov eax, page_table_l4
    mov cr3, eax

    ; Enable PAE (required in x86_64)
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; Enable long mode
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ; Enable paging
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    ret


error:
	; print "ERR: X" where X is the error code
	mov dword [0xb8000], 0x4f524f45
	mov dword [0xb8004], 0x4f3a4f52
	mov dword [0xb8008], 0x4f204f20
	mov byte  [0xb800a], al
	cli
    hlt


section .bss
align 4096
stack_bottom:
    resb 4096 * 4
stack_top:

page_table_l4:
    resb 4096
page_table_l3:
    resb 4096
page_table_l2:
    resb 4096

section .rodata
gdt64:
    dq 0 ; NULL entry
.code_segment: equ $ - gdt64
    dq (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53)
.data_segment: equ $ - gdt64
    dq (1 << 44) | (1 << 47) | (1 << 41)
.pointer:
    dw $ - gdt64 - 1
    dq gdt64 ; Address of the GDT


