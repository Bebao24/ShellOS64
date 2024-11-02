#pragma once
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

void initializeBitmap(uint8_t* buffer);

bool Bitmap_Get(uint64_t index);
void Bitmap_Set(uint64_t index, bool value);


