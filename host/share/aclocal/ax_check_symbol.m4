# ===========================================================================
#     https://www.gnu.org/software/autoconf-archive/ax_check_symbol.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_CHECK_SYMBOL(SYMBOL, HEADER... [,ACTION-IF-FOUND [,ACTION-IF-NOT-FOUND]])
#
# DESCRIPTION
#
#   A wrapper around AC_EGREP_HEADER. The shellvar $ac_found will hold the
#   HEADER-name that had been containing the symbol. This value is shown to
#   the user.
#
# LICENSE
#
#   Copyright (c) 2008 Guido U. Draheim <guidod@gmx.de>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.  This file is offered as-is, without any
#   warranty.

#serial 7

AU_ALIAS([AC_CHECK_SYMBOL], [AX_CHECK_SYMBOL])
AC_DEFUN([AX_CHECK_SYMBOL],
[AC_MSG_CHECKING([for $1 in $2])
AC_CACHE_VAL(ac_cv_func_$1,
[AC_REQUIRE_CPP()dnl
changequote(, )dnl
symbol="[^a-zA-Z_0-9]$1[^a-zA-Z_0-9]"
changequote([, ])dnl
ac_found=no
for ac_header in $2 ; do
  ac_safe=`echo "$ac_header" | sed 'y%./+-%__p_%' `
  if test $ac_found != "yes" ; then
      if eval "test \"`echo '$ac_cv_header_'$ac_safe`\" = yes"; then
            AC_EGREP_HEADER( $symbol, $ac_header, [ac_found="$ac_header"] )
      fi
  fi
done
if test "$ac_found" != "no" ; then
  AC_MSG_RESULT($ac_found)
  ifelse([$3], , :, [$3])
else
  AC_MSG_RESULT(no)
  ifelse([$4], , , [$4
])dnl
fi
])])

dnl AX_CHECK_SYMBOLS( symbol..., header... [, action-if-found [, action-if-not-found]])
AC_DEFUN([AX_CHECK_SYMBOLS],
[for ac_func in $1
do
P4_CHECK_SYMBOL($ac_func, $2,
[changequote(, )dnl
  ac_tr_func=HAVE_`echo $ac_func | sed -e 'y:abcdefghijklmnopqrstuvwxyz:ABCDEFGHIJKLMNOPQRSTUVWXYZ:' -e 's:[[^A-Z0-9]]:_:'`
changequote([, ])dnl
  AC_DEFINE_UNQUOTED($ac_tr_func) $2], $3)dnl
done
])
