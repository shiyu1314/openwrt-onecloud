/*
 * Copyright (C) 2015-2017 Dimitris Papastamos <sin@2f30.org>
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

#ifndef _FORTIFY_WCHAR_H
#define _FORTIFY_WCHAR_H

#ifndef __cplusplus
__extension__
#endif
#include_next <limits.h>
#ifndef __cplusplus
__extension__
#endif
#include_next <stdlib.h>
#ifndef __cplusplus
__extension__
#endif
#include_next <string.h>
#ifndef __cplusplus
__extension__
#endif
#include_next <wchar.h>

#if defined(_FORTIFY_SOURCE) && _FORTIFY_SOURCE > 0 && defined(__OPTIMIZE__) && __OPTIMIZE__ > 0
#include "fortify-headers.h"

#ifdef __cplusplus
extern "C" {
#endif

#undef fgetws
#undef mbsrtowcs
#undef mbstowcs
#undef wcrtomb
#undef wcscat
#undef wcscpy
#undef wcsncat
#undef wcsncpy
#undef wcsrtombs
#undef wcstombs
#undef wctomb
#undef wmemcpy
#undef wmemmove
#undef wmemset

_FORTIFY_FN(fgetws) wchar_t *fgetws(wchar_t *__s, int __n, FILE *__f)
{
	size_t __b = __builtin_object_size(__s, 0);

	if ((size_t)__n > __b / sizeof(wchar_t))
		__builtin_trap();
	return __orig_fgetws(__s, __n, __f);
}

#if defined(_POSIX_SOURCE) || defined(_POSIX_C_SOURCE) \
 || defined(_XOPEN_SOURCE) || defined(_GNU_SOURCE)  || defined(_BSD_SOURCE)
#undef mbsnrtowcs
_FORTIFY_FN(mbsnrtowcs) size_t mbsnrtowcs(wchar_t *__d, const char **__s, size_t __n,
                                          size_t __wn, mbstate_t *__st)
{
	size_t __b = __builtin_object_size(__d, 0);
	size_t __r;

	if (__wn > __n / sizeof(wchar_t)) {
		__b /= sizeof(wchar_t);
		__r = __orig_mbsnrtowcs(__d, __s, __n, __wn > __b ? __b : __wn, __st);
		if (__b < __wn && __d && *__s && __r != (size_t)-1)
			__builtin_trap();
	} else {
		__r = __orig_mbsnrtowcs(__d, __s, __n > __b ? __b : __n, __wn, __st);
		if (__b < __n && __d && *__s && __r != (size_t)-1)
			__builtin_trap();
	}
	return __r;
}
#endif

_FORTIFY_FN(mbsrtowcs) size_t mbsrtowcs(wchar_t *__d, const char **__s, size_t __wn,
                                        mbstate_t *__st)
{
	size_t __b = __builtin_object_size(__d, 0);
	size_t __r;

	__b /= sizeof(wchar_t);
	__r = __orig_mbsrtowcs(__d, __s, __wn > __b ? __b : __wn, __st);
	if (__b < __wn && __d && *__s && __r != (size_t)-1)
		__builtin_trap();
	return __r;
}

_FORTIFY_FN(mbstowcs) size_t mbstowcs(wchar_t *__ws, const char *__s, size_t __wn)
{
	size_t __b = __builtin_object_size(__ws, 0);

	if (__ws && __wn > __b / sizeof(wchar_t))
		__builtin_trap();
	return __orig_mbstowcs(__ws, __s, __wn);
}

_FORTIFY_FN(wcrtomb) size_t wcrtomb(char *__s, wchar_t __w, mbstate_t *__st)
{
	if (__s && MB_LEN_MAX > __builtin_object_size(__s, 2)) {
		char __buf[MB_LEN_MAX];
		size_t __r;

		__r = __orig_wcrtomb(__buf, __w, __st);
		if (__r == (size_t)-1)
			return __r;
		if (__r > __builtin_object_size(__s, 0))
			__builtin_trap();
		__builtin_memcpy(__s, __buf, __r);
		return __r;
	}
	return __orig_wcrtomb(__s, __w, __st);
}

_FORTIFY_FN(wcscat) wchar_t *wcscat(wchar_t *__d, const wchar_t *__s)
{
	size_t __b = __builtin_object_size(__d, 0);

	if (wcslen(__s) + wcslen(__d) + 1 > __b / sizeof(wchar_t))
		__builtin_trap();
	return __orig_wcscat(__d, __s);
}

_FORTIFY_FN(wcscpy) wchar_t *wcscpy(wchar_t *__d, const wchar_t *__s)
{
	size_t __b = __builtin_object_size(__d, 0);

	if (wcslen(__s) + 1 > __b / sizeof(wchar_t))
		__builtin_trap();
	return __orig_wcscpy(__d, __s);
}

_FORTIFY_FN(wcsncat) wchar_t *wcsncat(wchar_t *__d, const wchar_t *__s, size_t __n)
{
	size_t __b = __builtin_object_size(__d, 0);
	size_t __sl, __dl;

	if (__n > __b / sizeof(wchar_t)) {
		__sl = wcslen(__s);
		__dl = wcslen(__d);
		if (__sl > __n)
			__sl = __n;
		if (__sl + __dl + 1 > __b / sizeof(wchar_t))
			__builtin_trap();
	}
	return __orig_wcsncat(__d, __s, __n);
}

_FORTIFY_FN(wcsncpy) wchar_t *wcsncpy(wchar_t *__d, const wchar_t *__s, size_t __n)
{
	size_t __b = __builtin_object_size(__d, 0);

	if (__n > __b / sizeof(wchar_t))
		__builtin_trap();
	return __orig_wcsncpy(__d, __s, __n);
}

#if defined(_POSIX_SOURCE) || defined(_POSIX_C_SOURCE) \
 || defined(_XOPEN_SOURCE) || defined(_GNU_SOURCE)  || defined(_BSD_SOURCE)
#undef wcsnrtombs
_FORTIFY_FN(wcsnrtombs) size_t wcsnrtombs(char *__d, const wchar_t **__s, size_t __wn,
                                          size_t __n, mbstate_t *__st)
{
	size_t __b = __builtin_object_size(__d, 0);
	size_t __r;

	if (__wn > __n / sizeof(wchar_t)) {
		__b /= sizeof(wchar_t);
		__r = __orig_wcsnrtombs(__d, __s, __wn > __b ? __b : __wn, __n, __st);
		if (__b < __wn && __d && *__s && __r != (size_t)-1)
			__builtin_trap();
	} else {
		__r = __orig_wcsnrtombs(__d, __s, __wn, __n > __b ? __b : __n, __st);
		if (__b < __n && __d && *__s && __r != (size_t)-1)
			__builtin_trap();
	}
	return __r;
}
#endif

_FORTIFY_FN(wcsrtombs) size_t wcsrtombs(char *__d, const wchar_t **__s, size_t __n,
                                        mbstate_t *__st)
{
	size_t __b = __builtin_object_size(__d, 0);
	size_t __r;

	__r = __orig_wcsrtombs(__d, __s, __n > __b ? __b : __n, __st);
	if (__b < __n && __d && *__s && __r != (size_t)-1)
		__builtin_trap();
	return __r;
}

_FORTIFY_FN(wcstombs) size_t wcstombs(char *__s, const wchar_t *__ws, size_t __n)
{
	size_t __b = __builtin_object_size(__s, 0);

	if (__s && __n > __b)
		__builtin_trap();
	return __orig_wcstombs(__s, __ws, __n);
}

_FORTIFY_FN(wctomb) int wctomb(char *__s, wchar_t __w)
{
	size_t __b = __builtin_object_size(__s, 0);

	if (__s && MB_LEN_MAX > __b && MB_CUR_MAX > __b)
		__builtin_trap();
	return __orig_wctomb(__s, __w);
}

_FORTIFY_FN(wmemcpy) wchar_t *wmemcpy(wchar_t *__d, const wchar_t *__s, size_t __n)
{
	size_t __b = __builtin_object_size(__d, 0);

	if (__n > __b / sizeof(wchar_t))
		__builtin_trap();
	return __orig_wmemcpy(__d, __s, __n);
}

_FORTIFY_FN(wmemmove) wchar_t *wmemmove(wchar_t *__d, const wchar_t *__s, size_t __n)
{
	size_t __b = __builtin_object_size(__d, 0);

	if (__n > __b / sizeof(wchar_t))
		__builtin_trap();
	return __orig_wmemmove(__d, __s, __n);
}

_FORTIFY_FN(wmemset) wchar_t *wmemset(wchar_t *__s, wchar_t __c, size_t __n)
{
	size_t __b = __builtin_object_size(__s, 0);

	if (__n > __b / sizeof(wchar_t))
		__builtin_trap();
	return __orig_wmemset(__s, __c, __n);
}

#ifdef __cplusplus
}
#endif

#endif

#endif
