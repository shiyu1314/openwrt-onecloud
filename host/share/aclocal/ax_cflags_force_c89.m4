# ===========================================================================
#   https://www.gnu.org/software/autoconf-archive/ax_cflags_force_c89.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_CFLAGS_FORCE_C89 [(shellvar [,default, [A/NA]])]
#
# DESCRIPTION
#
#   Try to find a compiler option that enables strict C89 mode.
#
#   For the GNU CC compiler it will be -ansi -pedantic.  The result is added
#   to the shellvar being CFLAGS by default.
#
#   Currently this macro knows about GCC, Solaris C compiler, Digital Unix C
#   compiler, C for AIX Compiler, HP-UX C compiler, IRIX C compiler, NEC
#   SX-5 (Super-UX 10) C compiler, and Cray J90 (Unicos 10.0.0.8) C
#   compiler.
#
#    - $1 shell-variable-to-add-to : CFLAGS
#    - $2 add-value-if-not-found : nothing
#    - $3 action-if-found : add value to shellvariable
#    - $4 action-if-not-found : nothing
#
#   NOTE: These macros depend on AX_APPEND_FLAG.
#
# LICENSE
#
#   Copyright (c) 2009 Guido U. Draheim <guidod@gmx.de>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.  This file is offered as-is, without any
#   warranty.

#serial 12

AC_DEFUN([AX_CFLAGS_FORCE_C89],[dnl
AS_VAR_PUSHDEF([FLAGS],[CFLAGS])dnl
AS_VAR_PUSHDEF([VAR],[ac_cv_cflags_force_c89])dnl
AC_CACHE_CHECK([m4_ifval($1,$1,FLAGS) for C89 mode],
VAR,[VAR="no, unknown"
 AC_LANG_PUSH([C])
 ac_save_[]FLAGS="$[]FLAGS"
for ac_arg dnl
in "-pedantic  % -ansi -pedantic"             dnl GCC
   "-xstrconst % -v -Xc"                      dnl Solaris C
   "-std1      % -std1"                       dnl Digital Unix
   " % -qlanglvl=ansi"                        dnl AIX
   " % -ansi -ansiE"                          dnl IRIX
   "+ESlit     % -Aa"                         dnl HP-UX C
   "-Xc        % -Xc"                         dnl NEC SX-5 (Super-UX 10)
   "-h conform % -h conform"                  dnl Cray C (Unicos)
   #
do FLAGS="$ac_save_[]FLAGS "`echo $ac_arg | sed -e 's,%%.*,,' -e 's,%,,'`
   AC_COMPILE_IFELSE([AC_LANG_PROGRAM([],
   [[return 0;]])],
   [VAR=`echo $ac_arg | sed -e 's,.*% *,,'` ; break],[])
done
 FLAGS="$ac_save_[]FLAGS"
 AC_LANG_POP([C])
])
AS_VAR_POPDEF([FLAGS])dnl
AX_REQUIRE_DEFINED([AX_APPEND_FLAG])
case ".$VAR" in
     .ok|.ok,*) m4_ifvaln($3,$3) ;;
   .|.no|.no,*) m4_default($4,[m4_ifval($2,[AX_APPEND_FLAG([$2], [$1])])]) ;;
   *) m4_default($3,[AX_APPEND_FLAG([$VAR], [$1])]) ;;
esac
AS_VAR_POPDEF([VAR])dnl
])
