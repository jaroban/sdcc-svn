/*
   bug2805333.c
*/

#include <testfwk.h>

#ifdef SDCC
#pragma std_sdcc99
#endif

#include <stdbool.h>

#ifndef BOOL
#define BOOL bool
#endif

void g(char c)
{
  c;
}

BOOL b;

void test_bug(void)
{
  g(!b); /* Causes SDCC 2.9.0 to segfault.. */
}
