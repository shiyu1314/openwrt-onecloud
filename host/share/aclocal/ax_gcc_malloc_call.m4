# ===========================================================================
#    https://www.gnu.org/software/autoconf-archive/ax_gcc_malloc_call.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_GCC_MALLOC_CALL
#
# DESCRIPTION
#
#   The macro will compile a test program to see whether the compiler does
#   understand the per-function postfix pragma.
#
# LICENSE
#
#   Copyright (c) 2008 Guido U. Draheim <guidod@gmx.de>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.  This file is offered as-is, without any
#   warranty.

#serial 10

AC_DEFUN([AX_GCC_MALLOC_CALL],[dnl
AC_CACHE_CHECK(
 [whether the compiler supports function __attribute__((__malloc__))],
 ax_cv_gcc_malloc_call,[
 AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[__attribute__((__malloc__))
 int f(int i) { return i; }]],
 [])],
 [ax_cv_gcc_malloc_call=yes], [ax_cv_gcc_malloc_call=no])])
 if test "$ax_cv_gcc_malloc_call" = yes; then
   AC_DEFINE([GCC_MALLOC_CALL],[__attribute__((__malloc__))],
    [most gcc compilers know a function __attribute__((__malloc__))])
 fi
])
