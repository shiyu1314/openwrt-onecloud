# ===========================================================================
#      https://www.gnu.org/software/autoconf-archive/ax_subst_with.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_SUBST_WITH([varname])
#
# DESCRIPTION
#
#   a very simple macro but also very helpful - the varname is usually the
#   one from an AC_ARG_ENABLE or AC_ARG_WITH option. it is transliterated
#   into uppercase and a prefix WITH_ and WITHOUT_ that are both _SUBSTed.
#
#   Only one of these is set to "#" while the other is empty. In other words
#   a call like AC_WITHNONE(enable-call) will create two SUBST-symbols as
#   WITH_ENABLE_CALL and WITHOUT_ENABLE_CALL. When the varname had been set
#   to something not "no" or "0" or ":" or "false" then it results in
#
#    WITH_ENABLE_CALL="" ; WITHOUT_ENABLE_CALL="#"
#
#   which you can use in your Makefile quite easily as if using an
#   AM_CONDITIONAL but which can be also parsed by normal make
#
#   USE = @WITH_ENABLE_CALL@ -Denabled USE = @WITHOUT_ENABLE_CALL@
#   -Dnot_enabled
#
# LICENSE
#
#   Copyright (c) 2008 Guido U. Draheim <guidod@gmx.de>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.  This file is offered as-is, without any
#   warranty.

#serial 9

dnl AX_SUBST_WITH_IF(flag,cond) - not unlike AM_CONDITIONAL
AC_DEFUN([AX_SUBST_WITH_IF],[dnl
pushdef([VAR_WITH],    patsubst(translit([with_$1], [a-z], [A-Z]), -, _))dnl
pushdef([VAR_WITHOUT], patsubst(translit([without_$1], [a-z], [A-Z]), -, _))dnl
AC_SUBST(VAR_WITH)
AC_SUBST(VAR_WITHOUT)
if $2; then
    VAR_WITH=""
    VAR_WITHOUT="#"
else
    VAR_WITH="#"
    VAR_WITHOUT=""
fi
popdef([VAR_WITHOUT])dnl
popdef([VAR_WITH])dnl
])

dnl AX_SUBST_WITH(varname [,default]) - not unlike AM_CONDITIONAL
AC_DEFUN([AX_SUBST_WITH],[dnl
pushdef([VAR],         patsubst(translit([with_$1], [A-Z], [a-z]), -, _))dnl
pushdef([VAR_WITH],    patsubst(translit([with_$1], [a-z], [A-Z]), -, _))dnl
pushdef([VAR_WITHOUT], patsubst(translit([without_$1], [a-z], [A-Z]), -, _))dnl
pushdef([VAR_WITHVAL], patsubst(translit([withval_$1], [a-z], [A-Z]), -, _))dnl
AC_SUBST(VAR_WITH)
AC_SUBST(VAR_WITHOUT)
VAR_WITHVAL=`echo "$VAR"`
test ".$VAR_WITHVAL" = "."      && VAR_WITHVAL="m4_ifval([$2],[$2],no)"
test ".$VAR_WITHVAL" = ".:"     && VAR_WITHVAL="no"
test ".$VAR_WITHVAL" = ".0"     && VAR_WITHVAL="no"
test ".$VAR_WITHVAL" = ".no"    && VAR_WITHVAL="no"
test ".$VAR_WITHVAL" = ".false" && VAR_WITHVAL="no"
if test ".$VAR_WITHVAL" != ".no" ; then
    VAR_WITH=""
    VAR_WITHOUT="#"
else
    VAR_WITH="#"
    VAR_WITHOUT=""
fi
popdef([VAR_WITHVAL])dnl
popdef([VAR_WITHOUT])dnl
popdef([VAR_WITH])dnl
popdef([VAR])dnl
])

dnl AX_SUBST_WITH_DEFINE(varname [,default]) - not unlike AM_CONDITIONAL
AC_DEFUN([AX_SUBST_WITH_DEFINE],[dnl
pushdef([VAR],         patsubst(translit([with_$1], [A-Z], [a-z]), -, _))dnl
pushdef([VAR_WITH],    patsubst(translit([with_$1], [a-z], [A-Z]), -, _))dnl
pushdef([VAR_WITHOUT], patsubst(translit([without_$1], [a-z], [A-Z]), -, _))dnl
pushdef([VAR_WITHVAL], patsubst(translit([withval_$1], [a-z], [A-Z]), -, _))dnl
AC_SUBST(VAR_WITH)
AC_SUBST(VAR_WITHOUT)
VAR_WITHVAL=`echo "$VAR"`
test ".$VAR_WITHVAL" = "."      && VAR_WITHVAL="m4_ifval([$2],[$2],no)"
test ".$VAR_WITHVAL" = ".:"     && VAR_WITHVAL="no"
test ".$VAR_WITHVAL" = ".0"     && VAR_WITHVAL="no"
test ".$VAR_WITHVAL" = ".no"    && VAR_WITHVAL="no"
test ".$VAR_WITHVAL" = ".false" && VAR_WITHVAL="no"
if test ".$VAR_WITHVAL" != ".no" ; then
    VAR_WITH=""
    VAR_WITHOUT="#"
    case "$VAR_WITHVAL" in
    [[0123456789]]*)  ;;
    [yes)] VAR_WITHVAL="1" ;;
    [*)]   VAR_WITHVAL=`echo "\"$VAR_WITHVAL\"" | sed -e  's,"",",g'` ;;
  esac
else
    VAR_WITH="#"
    VAR_WITHOUT=""
fi
if test ".$VAR_WITHVAL" != ".no" ; then
      AC_DEFINE_UNQUOTED(VAR_WITH, $VAR_WITHVAL,
	[whether $1 feature is enabled])
fi dnl
popdef([VAR_WITHVAL])dnl
popdef([VAR_WITHOUT])dnl
popdef([VAR_WITH])dnl
popdef([VAR])dnl
])

dnl backward compatibility helpers
AC_DEFUN([AX_SUBST_WITH_ARG],[dnl
pushdef([VAR],    patsubst(translit([with_$1], [A-Z], [a-z]), -, _))dnl
m4_ifvaln([$2],[test ".$VAR" = "." && VAR="$2"])dnl
AX_SUBST_WITH([$1],[$2])
popdef([VAR])dnl
])

AC_DEFUN([AX_SUBST_WITH_DEFINE_ARG],[dnl
pushdef([VAR],    patsubst(translit([with_$1], [A-Z], [a-z]), -, _))dnl
m4_ifvaln([$2],[test ".$VAR" = "." && VAR="$2"])dnl
AX_SUBST_WITH_DEFINE([$1],[$2])
popdef([VAR])dnl
])
