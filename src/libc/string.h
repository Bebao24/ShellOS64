#pragma once
#include <stdint.h>
#include <stddef.h>

void* memcpy(void* dst, const void* src, size_t size);
void* memset(void* ptr, int value, size_t size);
int memcmp(const void* ptr1, const void* ptr2, size_t size);
