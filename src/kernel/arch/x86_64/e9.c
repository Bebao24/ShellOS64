#include "e9.h"
#include "io.h"

#define SERIAL_OUTPUT_PORT 0xE9

void E9_putc(char c)
{
    x64_outb(SERIAL_OUTPUT_PORT, c);
}


