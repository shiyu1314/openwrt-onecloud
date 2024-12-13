# ===========================================================================
#     https://www.gnu.org/software/autoconf-archive/ax_cxx_typename.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_CXX_TYPENAME
#
# DESCRIPTION
#
#   If the compiler recognizes the typename keyword, define HAVE_TYPENAME.
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

AU_ALIAS([AC_CXX_TYPENAME], [AX_CXX_TYPENAME])
AC_DEFUN([AX_CXX_TYPENAME],
[AC_CACHE_CHECK(whether the compiler recognizes typename,
ax_cv_cxx_typename,
[AC_LANG_PUSH([C++])
 AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[template<typename T>class X {public:X(){}};]],
 [[X<float> z; return 0;]])],
 [ax_cv_cxx_typename=yes], [ax_cv_cxx_typename=no])
 AC_LANG_POP([C++])
])
if test "$ax_cv_cxx_typename" = yes; then
  AC_DEFINE(HAVE_TYPENAME,,[define if the compiler recognizes typename])
fi
])
