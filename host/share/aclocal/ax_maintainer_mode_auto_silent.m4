# ===================================================================================
#  https://www.gnu.org/software/autoconf-archive/ax_maintainer_mode_auto_silent.html
# ===================================================================================
#
# SYNOPSIS
#
#   AX_MAINTAINER_MODE_AUTO_SILENT
#
# DESCRIPTION
#
#   Set autotools to error/sleep settings so that they are not run when
#   being erroneously triggered. Likewise make libtool-silent when libtool
#   has been used.
#
#   I use the macro quite a lot since some automake versions have the
#   tendency to try to rerun some autotools on a mere make even when not
#   quite in --maintainer-mode. That is very annoying. Likewise, a user who
#   installs from source does not want to see doubled compiler messages.
#
#   I did not put an AC_REQUIRE(MAINTAINER_MODE) in here - should I?
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

AC_DEFUN([AX_MAINTAINER_MODE_AUTO_SILENT],[dnl
dnl ac_REQUIRE([am_MAINTAINER_MODE])dn
AC_MSG_CHECKING(auto silent in maintainer mode)
if test "$USE_MAINTAINER_MODE" = "no" ; then
   test ".$TIMEOUT" = "." && TIMEOUT="9"
   AUTOHEADER="sleep $TIMEOUT ; true || autoheader || skipped"
   AUTOMAKE="sleep $TIMEOUT ; true || automake || skipped"
   AUTOCONF="sleep $TIMEOUT ; true || autoconf || skipped"
   if test ".$LIBTOOL" != "." ; then
      LIBTOOL="$LIBTOOL --silent"
      AC_MSG_RESULT([libtool-silent, auto-sleep-9])
   else
      AC_MSG_RESULT([auto-sleep-9])
   fi
else
      AC_MSG_RESULT([no])
fi
])
