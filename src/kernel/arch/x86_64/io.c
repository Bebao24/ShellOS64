#include "io.h"

void x64_outb(uint16_t port, uint8_t value)
{
    __asm__ __volatile__("outb %0, %1" : : "a"(value), "Nd"(port));
}

uint8_t x64_inb(uint16_t port)
{
    uint8_t returnValue;
    __asm__ __volatile__("inb %1, %0" : "=a"(returnValue) : "Nd"(port));
    return returnValue;
}

