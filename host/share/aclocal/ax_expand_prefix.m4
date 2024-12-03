# ===========================================================================
#     https://www.gnu.org/software/autoconf-archive/ax_expand_prefix.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_EXPAND_PREFIX
#
# DESCRIPTION
#
#   When $prefix and $exec_prefix are still set to NONE then set them to the
#   usual default values - being based on $ac_default_prefix. - this macro
#   can be AC_REQUIREd by other macros that need to compute values for
#   installation directories. It has been observed that it was done wrong
#   over and over again, so this is a bit more safe to do.
#
#   remember - setting exec_prefix='${prefix}' needs you interpolate
#   directories multiple times, it is not sufficient to just say
#   MYVAR="${datadir}/putter" but you do have to run `eval` a few times,
#   sth. like MYVAR=`eval "echo \"$MYVAR\""` done at least two times.
#
#   The implementation of this macro simply picks up the lines that would be
#   run at the start of AC_OUTPUT anyway to set the prefix/exec_prefix
#   defaults. Between AC_INIT and the first command to AC_REQUIRE this macro
#   you can set the two variables to something explicit instead. Probably,
#   any command to compute installation directories should be run _after_
#   AM_INIT_AUTOMAKE
#
# LICENSE
#
#   Copyright (c) 2008 Guido U. Draheim <guidod@gmx.de>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.  This file is offered as-is, without any
#   warranty.

#serial 11

AC_DEFUN([AX_EXPAND_PREFIX],[dnl
  # The prefix default can be set in configure.ac (otherwise it is /usr/local)
  test "x$prefix" = xNONE && prefix=$ac_default_prefix
  # Let make expand exec_prefix. Allows to override the makevar 'prefix' later
  test "x$exec_prefix" = xNONE && exec_prefix='${prefix}'
])
