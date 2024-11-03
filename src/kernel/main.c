/*
    main.c: Kernel entry point
*/
#include <stdio.h>
#include <debug.h>
#include <stdint.h>
#include <multiboot2.h>
#include <bitmap.h>
#include <string.h>
#include <memory.h>

struct multiboot_tag_framebuffer* tagfb = NULL;

void initSystem(unsigned long address)
{
    struct multiboot_tag* tag;
    uint32_t size;

    size = *(uint32_t*)address;
    debugf("mbi size: 0x%x\n", size);

    for (tag = (struct multiboot_tag *) (address + 8);
       tag->type != MULTIBOOT_TAG_TYPE_END;
       tag = (struct multiboot_tag *) ((multiboot_uint8_t *) tag 
                                       + ((tag->size + 7) & ~7)))
    {
        switch (tag->type)
        {
        case MULTIBOOT_TAG_TYPE_FRAMEBUFFER:
            tagfb = (struct multiboot_tag_framebuffer *)tag;
            debugf("Framebuffer info\n");
            debugf("Width: %d, height: %d, bpp: %d\n", tagfb->common.framebuffer_width, tagfb->common.framebuffer_height,
            tagfb->common.framebuffer_bpp);
            break;
        }
    }

    tag = (struct multiboot_tag *) ((multiboot_uint8_t *) tag + ((tag->size + 7) & ~7));
    debugf("Total mbi size 0x%x\n", (uint32_t) tag - address);
}

void kernel_start(unsigned long magic, unsigned long address)
{
    if (magic != MULTIBOOT2_BOOTLOADER_MAGIC)
    {
        debugf("Invalid multiboot2 magic number!\n");
        return;
    }

    initSystem(address);

    debugf("System initialize successfully!\n");

    uint64_t totalMemorySize = getMemorySize(address);

    debugf("Total memory size: %llu MB", totalMemorySize / 1024 / 1024);

    while (1)
    {
        __asm__ __volatile__("hlt");
    }
}