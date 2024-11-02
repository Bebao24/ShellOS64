#include "debug.h"
#include <stdio.h>
#include <stdarg.h>

void debugc(char c)
{
    fputc(c, VFS_FD_DEBUG);
}

void debugs(const char* string)
{
    while (*string)
    {
        debugc(*string);
        string++;
    }
}

void debugf(const char* fmt, ...)
{
    va_list args;
    va_start(args, fmt);
    vfprintf(VFS_FD_DEBUG, fmt, args);
    va_end(args);
}

