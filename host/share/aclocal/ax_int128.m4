# ===========================================================================
#        https://www.gnu.org/software/autoconf-archive/ax_int128.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_HAVE_INT128
#
# DESCRIPTION
#
#   Check whether the compiler provides __int128. If so, define HAVE_INT128.
#
#   Works with GCC >= 4.6.
#
#   TODO: Provide int128[u]_t & work with other compilers.
#
# LICENSE
#
#   Copyright (c) 2019 Reuben Thomas <rrt@sc3d.org>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved. This file is offered as-is, without any
#   warranty.

#serial 2

AC_DEFUN([AX_HAVE_INT128],
[
  dnl First test whether we already found it.
  AC_CACHE_CHECK([for __int128], [ax_cv_int128], [
    ax_cv_int128=
    AC_EGREP_CPP([Found it], [
#ifdef __SIZEOF_INT128__
Found it
#endif
], [ax_cv_int128=yes])
  ])
  if test "$ax_cv_int128" = yes; then
    AC_DEFINE([HAVE_INT128], [1],
      [Define to 1 if you have the type __int128.])
  fi
])
