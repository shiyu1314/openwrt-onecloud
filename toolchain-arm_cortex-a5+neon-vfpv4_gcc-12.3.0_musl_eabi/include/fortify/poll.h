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

#ifndef _FORTIFY_POLL_H
#define _FORTIFY_POLL_H

#ifndef __cplusplus
__extension__
#endif
#include_next <poll.h>

#if defined(_FORTIFY_SOURCE) && _FORTIFY_SOURCE > 0 && defined(__OPTIMIZE__) && __OPTIMIZE__ > 0
#include "fortify-headers.h"

#ifdef __cplusplus
extern "C" {
#endif

#undef poll

_FORTIFY_FN(poll) int poll(struct pollfd *__f, nfds_t __n, int __s)
{
	__typeof__(sizeof 0) __b = __builtin_object_size(__f, 0);

	if (__n > __b / sizeof(struct pollfd))
		__builtin_trap();
	return __orig_poll(__f, __n, __s);
}

#if defined(_GNU_SOURCE) && !(defined(_REDIR_TIME64) && _REDIR_TIME64)
#undef ppoll
_FORTIFY_FN(ppoll) int ppoll(struct pollfd *__f, nfds_t __n, const struct timespec *__s,
                             const sigset_t *__m)
{
	__typeof__(sizeof 0) __b = __builtin_object_size(__f, 0);

	if (__n > __b / sizeof(struct pollfd))
		__builtin_trap();
	return __orig_ppoll(__f, __n, __s, __m);
}
#endif

#ifdef __cplusplus
}
#endif

#endif

#endif
