/*
 * Copyright (C) 2015-2016 Dimitris Papastamos <sin@2f30.org>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#ifndef _FORTIFY_STDIO_H
#define _FORTIFY_STDIO_H

#ifndef __cplusplus
__extension__
#endif
#include_next <stdio.h>

#if defined(_FORTIFY_SOURCE) && _FORTIFY_SOURCE > 0 && defined(__OPTIMIZE__) && __OPTIMIZE__ > 0
#include "fortify-headers.h"

#ifdef __cplusplus
extern "C" {
#endif

#undef fgets
#undef fread
#undef fwrite
#undef vsprintf
#undef vsnprintf
#undef snprintf
#undef sprintf

_FORTIFY_FN(fgets) char *fgets(char *__s, int __n, FILE *__f)
{
	size_t __b = __builtin_object_size(__s, 0);

	if ((size_t)__n > __b)
		__builtin_trap();
	return __orig_fgets(__s, __n, __f);
}

_FORTIFY_FN(fread) size_t fread(void *__d, size_t __n, size_t __m, FILE *__f)
{
	size_t __b = __builtin_object_size(__d, 0);

	if (__n != 0 && (__n * __m) / __n != __m)
		__builtin_trap();
	if (__n * __m > __b)
		__builtin_trap();
	return __orig_fread(__d, __n, __m, __f);
}

_FORTIFY_FN(fwrite) size_t fwrite(const void *__d, size_t __n, size_t __m, FILE *__f)
{
	size_t __b = __builtin_object_size(__d, 0);

	if (__n != 0 && (__n * __m) / __n != __m)
		__builtin_trap();
	if (__n * __m > __b)
		__builtin_trap();
	return __orig_fwrite(__d, __n, __m, __f);
}

_FORTIFY_FN(vsnprintf) int vsnprintf(char *__s, size_t __n, const char *__f,
                                     __builtin_va_list __v)
{
	size_t __b = __builtin_object_size(__s, 0);

	if (__n > __b)
		__builtin_trap();
	return __orig_vsnprintf(__s, __n, __f, __v);
}

_FORTIFY_FN(vsprintf) int vsprintf(char *__s, const char *__f, __builtin_va_list __v)
{
	size_t __b = __builtin_object_size(__s, 0);
	int __r;

	if (__b != (size_t)-1) {
		__r = __orig_vsnprintf(__s, __b, __f, __v);
		if (__r != -1 && (size_t)__r >= __b)
			__builtin_trap();
	} else {
		__r = __orig_vsprintf(__s, __f, __v);
	}
	return __r;
}

_FORTIFY_FN(snprintf) int snprintf(char *__s, size_t __n, const char *__f, ...)
{
	size_t __b = __builtin_object_size(__s, 0);

	if (__n > __b)
		__builtin_trap();
	return __orig_snprintf(__s, __n, __f, __builtin_va_arg_pack());
}

_FORTIFY_FN(sprintf) int sprintf(char *__s, const char *__f, ...)
{
	size_t __b = __builtin_object_size(__s, 0);
	int __r;

	if (__b != (size_t)-1) {
		__r = __orig_snprintf(__s, __b, __f, __builtin_va_arg_pack());
		if (__r != -1 && (size_t)__r >= __b)
			__builtin_trap();
	} else {
		__r = __orig_sprintf(__s, __f, __builtin_va_arg_pack());
	}
	return __r;
}

#ifdef __cplusplus
}
#endif

#endif

#endif
