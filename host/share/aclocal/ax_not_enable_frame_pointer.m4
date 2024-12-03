# ================================================================================
#  https://www.gnu.org/software/autoconf-archive/ax_not_enable_frame_pointer.html
# ================================================================================
#
# SYNOPSIS
#
#   AX_NOT_ENABLE_FRAME_POINTER ([shellvar])
#
# DESCRIPTION
#
#   add --enable-frame-pointer option, the default will add the gcc
#   -fomit-frame-pointer option to the shellvar (per default CFLAGS) and
#   remove the " -g " debuginfo option from it. In other words, the default
#   is "--disable-frame-pointer"
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

AC_DEFUN([AX_NOT_ENABLE_FRAME_POINTER],[dnl
AS_VAR_PUSHDEF([VAR],[enable_frame_pointer])dnl
AC_MSG_CHECKING([m4_ifval($1,$1,CFLAGS) frame-pointer])
AC_ARG_ENABLE([frame-pointer], AS_HELP_STRING(
  [--enable-frame-pointer],[enable callframe generation for debugging]))
case ".$VAR" in
  .|.no|.no,*) test ".$VAR" = "." && VAR="no"
     m4_ifval($1,$1,CFLAGS)=`echo dnl
  " $m4_ifval($1,$1,CFLAGS) " | sed -e 's/ -g / /'`
     if test ".$GCC" = ".yes" ; then
        m4_ifval($1,$1,CFLAGS)="$m4_ifval($1,$1,CFLAGS) -fomit-frame-pointer"
        AC_MSG_RESULT([$VAR, -fomit-frame-pointer added])
     else
        AC_MSG_RESULT([$VAR, -g removed])
     fi  ;;
   *)  AC_MSG_RESULT([$VAR, kept]) ;;
esac
AS_VAR_POPDEF([VAR])dnl
])
