#include "memory.h"
#include <multiboot2.h>

uint64_t getMemorySize(unsigned long multibootAddr)
{
    static uint64_t totalMemoryBytes = 0;

    if (totalMemoryBytes > 0) return totalMemoryBytes; // We already calculate

    struct multiboot_tag* tag;
    uint32_t size;

    size = *(uint32_t*)multibootAddr;

    for (tag = (struct multiboot_tag *) (multibootAddr + 8);
       tag->type != MULTIBOOT_TAG_TYPE_END;
       tag = (struct multiboot_tag *) ((multiboot_uint8_t *) tag 
                                       + ((tag->size + 7) & ~7)))
    {
        switch (tag->type)
        {
            case MULTIBOOT_TAG_TYPE_BASIC_MEMINFO:
                struct multiboot_tag_basic_meminfo* mem = (struct multiboot_tag_basic_meminfo*)tag;

                totalMemoryBytes += mem->mem_upper * 1024;
                break;
        }
    }

    return totalMemoryBytes;
}


