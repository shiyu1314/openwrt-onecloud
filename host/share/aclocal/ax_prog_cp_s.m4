# ===========================================================================
#       https://www.gnu.org/software/autoconf-archive/ax_prog_cp_s.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_PROG_CP_S
#
# DESCRIPTION
#
#   Check how to make a copy by creating a symbolic link to the original -
#   it defines the variable CP_S for further use, which you should in fact
#   treat like it used to be with be LN_S. The actual value is assured to be
#   either LN_S (if the filesystem supports symbolic links) or CP (if the
#   filesystem does not know about symbolic links and you need a copy of
#   original file to have the same text in both places). In a gnu
#   environment it will simply set CP_S="cp -s" since the gnu "cp"-command
#   has the "-s" flag. You shall not try to use this command on directories
#   since it would require a "-r" in the case of a copy that is not
#   supported explicitly here. (I'm not sure if some "cp"-commands out there
#   would barf at usage of "-r" on a normal file).
#
#   Use CP_S to create a copy of read-only data - if your filesystem
#   supports it then a symbolic link is created - a process that is quicker
#   and space-saving. However, if the target fs does not support symbolic
#   links, just copy the data. Unlike ac_prog_ln_s this macro will never
#   fail to set the CP_S ac_subst to something that works.
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

AU_ALIAS([AC_PROG_CP_S], [AX_PROG_CP_S])
AC_DEFUN([AX_PROG_CP_S],
[AC_REQUIRE([AC_PROG_LN_S])dnl
AC_MSG_CHECKING(whether cp -s works)
AC_CACHE_VAL(ac_cv_prog_CP_S,
[rm -f conftestdata
if cp -s X conftestdata 2>/dev/null
then
  rm -f conftestdata
  ac_cv_prog_CP_S="cp -s"
else
  ac_cv_prog_CP_S=cp
fi
if test "$LN_S" = "ln -s" ; then
  ac_cv_prog_CP_S="ln -s"
fi])dnl
CP_S="$ac_cv_prog_CP_S"
if test "$ac_cv_prog_CP_S" = "ln -s"; then
  AC_MSG_RESULT(using ln -s)
elif test "$ac_cv_prog_CP_S" = "cp -s"; then
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no, using cp)
fi
AC_SUBST(CP_S)dnl
])
