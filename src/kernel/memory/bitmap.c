/*
    bitmap.c: Store boolean in a single bit, which mean that 1 byte will be able to store 8 boolean
*/

#include "bitmap.h"

static uint8_t* g_Buffer;

void initializeBitmap(uint8_t* buffer)
{
    g_Buffer = buffer;
}

bool Bitmap_Get(uint64_t index)
{
    uint64_t byteIndex = index / 8;
    uint8_t bitIndex = index % 8; // The remainder which is store in bit
    uint8_t bitIndexer = 0b10000000 >> bitIndex;
    if ((g_Buffer[byteIndex] & bitIndexer) > 0)
    {
        // The bit is set, return true
        return true;
    }

    return false;
}

void Bitmap_Set(uint64_t index, bool value)
{
    uint64_t byteIndex = index / 8;
    uint8_t bitIndex = index % 8; // The remainder which is store in bit
    uint8_t bitIndexer = 0b10000000 >> bitIndex;
    g_Buffer[byteIndex] &= ~bitIndexer;
    if (value)
    {
        g_Buffer[byteIndex] |= bitIndexer;
    }
}

