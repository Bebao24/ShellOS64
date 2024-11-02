#include "vfs.h"
#include <arch/x86_64/e9.h>

int VFS_Write(fd_t file, uint8_t* data, size_t size)
{
    switch (file)
    {
        case VFS_FD_STDIN:
            return 0;
        case VFS_FD_STDOUT:
        case VFS_FD_STDERR:
            return 0; // Can't print to the screen right now :(
        case VFS_FD_DEBUG:
            for (size_t i = 0; i < size; i++)
            {
                E9_putc(data[i]);
            }
            return size;
        default:
            return -1; // Invalid
    }
}


