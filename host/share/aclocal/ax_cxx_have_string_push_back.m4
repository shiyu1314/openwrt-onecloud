# =================================================================================
#  https://www.gnu.org/software/autoconf-archive/ax_cxx_have_string_push_back.html
# =================================================================================
#
# SYNOPSIS
#
#   AX_CXX_HAVE_STRING_PUSH_BACK
#
# DESCRIPTION
#
#   If the implementation of the C++ library provides the method
#   std::string::push_back (char), define HAVE_STRING_PUSH_BACK.
#
# LICENSE
#
#   Copyright (c) 2008 Jan Langer <jan@langernetz.de>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved. This file is offered as-is, without any
#   warranty.

#serial 8

AU_ALIAS([AC_CXX_HAVE_STRING_PUSH_BACK], [AX_CXX_HAVE_STRING_PUSH_BACK])
AC_DEFUN([AX_CXX_HAVE_STRING_PUSH_BACK],
[AC_CACHE_CHECK([whether the compiler has std::string::push_back (char)],
ax_cv_cxx_have_string_push_back,
[AC_REQUIRE([AX_CXX_NAMESPACES])
 AC_LANG_PUSH([C++])
 AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <string>
#ifdef HAVE_NAMESPACES
using namespace std;
#endif]], [[string message; message.push_back ('a'); return 0;]])],
 [ax_cv_cxx_have_string_push_back=yes], [ax_cv_cxx_have_string_push_back=no])
 AC_LANG_POP([C++])
])
if test "$ax_cv_cxx_have_string_push_back" = yes; then
 AC_DEFINE(HAVE_STRING_PUSH_BACK,,[define if the compiler has the method
std::string::push_back (char)])
fi
])dnl
