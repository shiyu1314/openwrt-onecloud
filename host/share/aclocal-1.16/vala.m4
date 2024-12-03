# Autoconf support for the Vala compiler

# Copyright (C) 2008-2021 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# Search for a Vala compiler in PATH.  If it is found, the variable VALAC is
# set to point to it.  Otherwise, it is simply set to 'valac'.  This macro
# takes three optional arguments.  The first argument, if present, is the
# minimum version of the Vala API required to compile this package.  For Vala
# releases, this is the same as the major and minor release number; e.g., when
# `valac --version' reports 0.48.7, `valac --api-version' reports 0.48.  If a
# compiler is found and satisfies MINIMUM-VERSION, then ACTION-IF-FOUND is run
# (this defaults to do nothing).  Otherwise, ACTION-IF-NOT-FOUND is run.  If
# ACTION-IF-NOT-FOUND is not specified, the default value is to print a
# warning in case no compiler is found, or if a too-old version of the
# compiler is found.
#
# AM_PROG_VALAC([MINIMUM-VERSION], [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# --------------------------------------------------------------------------
AC_DEFUN([AM_PROG_VALAC],
  [AC_PATH_PROG([VALAC], [valac], [valac])
   AS_IF([test "$VALAC" != valac && test -n "$1"],
      [AC_MSG_CHECKING([whether $VALAC supports at least API version $1])
       am__vala_version=`$VALAC --api-version`
       AS_VERSION_COMPARE([$1], ["$am__vala_version"],
         [AC_MSG_RESULT([yes])],
         [AC_MSG_RESULT([yes])],
         [AC_MSG_RESULT([no])
          VALAC=valac])])
    if test "$VALAC" = valac; then
      m4_default([$3],
        [AC_MSG_WARN([Vala compiler not found or too old])
         AC_MSG_WARN([you will not be able to compile Vala source files])])
    else
      m4_default([$2], [:])
    fi])
