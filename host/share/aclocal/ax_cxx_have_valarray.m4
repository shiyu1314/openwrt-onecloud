# ===========================================================================
#   https://www.gnu.org/software/autoconf-archive/ax_cxx_have_valarray.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_CXX_HAVE_VALARRAY
#
# DESCRIPTION
#
#   If the compiler has valarray<T>, define HAVE_VALARRAY.
#
# LICENSE
#
#   Copyright (c) 2008 Todd Veldhuizen
#   Copyright (c) 2008 Luc Maisonobe <luc@spaceroots.org>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved. This file is offered as-is, without any
#   warranty.

#serial 8

AU_ALIAS([AC_CXX_HAVE_VALARRAY], [AX_CXX_HAVE_VALARRAY])
AC_DEFUN([AX_CXX_HAVE_VALARRAY],
[AC_CACHE_CHECK(whether the compiler has valarray<T>,
ax_cv_cxx_have_valarray,
[AC_REQUIRE([AX_CXX_NAMESPACES])
 AC_LANG_PUSH([C++])
 AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <valarray>
#ifdef HAVE_NAMESPACES
using namespace std;
#endif]], [[valarray<float> x(100); return 0;]])],
 [ax_cv_cxx_have_valarray=yes], [ax_cv_cxx_have_valarray=no])
 AC_LANG_POP([C++])
])
if test "$ax_cv_cxx_have_valarray" = yes; then
  AC_DEFINE(HAVE_VALARRAY,,[define if the compiler has valarray<T>])
fi
])
