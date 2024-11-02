#pragma once

#include <hal/vfs.h>
#include <stdarg.h>

void fputc(char c, fd_t file);
void fputs(const char* string, fd_t file);
void vfprintf(fd_t file, const char* fmt, va_list args);
void fprintf(fd_t file, const char* fmt, ...);



