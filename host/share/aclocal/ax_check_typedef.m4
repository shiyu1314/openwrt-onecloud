# ===========================================================================
#     https://www.gnu.org/software/autoconf-archive/ax_check_typedef.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_CHECK_TYPEDEF(TYPEDEF, HEADER [, ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND ]])
#
# DESCRIPTION
#
#   Check if the given typedef-name is recognized as a type. The trick is to
#   use a sizeof(TYPEDEF) and see if the compiler is happy with that.
#
#   This can be thought of as a mixture of AC_CHECK_TYPE(TYPEDEF,DEFAULT)
#   and AC_CHECK_LIB(LIBRARY,FUNCTION,ACTION-IF-FOUND,ACTION-IF-NOT-FOUND).
#
#   A convenience macro AX_CHECK_TYPEDEF_ is provided that will not emit any
#   message to the user - it just executes one of the actions.
#
# LICENSE
#
#   Copyright (c) 2008 Guido U. Draheim <guidod@gmx.de>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.  This file is offered as-is, without any
#   warranty.

#serial 8

AU_ALIAS([AC_CHECK_TYPEDEF], [AX_CHECK_TYPEDEF])
AC_DEFUN([AX_CHECK_TYPEDEF_],
[dnl
ac_lib_var=`echo $1['_']$2 | sed 'y%./+-%__p_%'`
AC_CACHE_VAL(ac_cv_lib_$ac_lib_var,
[ eval "ac_cv_type_$ac_lib_var='not-found'"
  ac_cv_check_typedef_header=`echo ifelse([$2], , stddef.h, $2)`
  AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <$ac_cv_check_typedef_header>]],
    [[int x = sizeof($1); x = x;]])],
    [eval "ac_cv_type_$ac_lib_var=yes"],
    [eval "ac_cv_type_$ac_lib_var=no"])
  if test `eval echo '$ac_cv_type_'$ac_lib_var` = "no" ; then
     ifelse([$4], , :, $4)
  else
     ifelse([$3], , :, $3)
  fi
])])

dnl AX_CHECK_TYPEDEF(TYPEDEF, HEADER [, ACTION-IF-FOUND,
dnl    [, ACTION-IF-NOT-FOUND ]])
AC_DEFUN([AX_CHECK_TYPEDEF],
[dnl
 AC_MSG_CHECKING([for $1 in $2])
 AX_CHECK_TYPEDEF_($1,$2,AC_MSG_RESULT(yes),AC_MSG_RESULT(no))dnl
])
