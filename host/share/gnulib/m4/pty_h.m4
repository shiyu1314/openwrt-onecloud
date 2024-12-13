# pty_h.m4 serial 14
dnl Copyright (C) 2009-2023 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

# gl_PTY_H
# --------
# Set up the GNU-like <pty.h> replacement header.
AC_DEFUN_ONCE([gl_PTY_H],
[
  AC_REQUIRE([gl_PTY_H_DEFAULTS])

  # Make sure that pty.h provides forkpty, or setup the replacement.
  AC_CHECK_HEADERS_ONCE([pty.h])
  if test $ac_cv_header_pty_h != yes; then
    HAVE_PTY_H=0
    AC_CHECK_HEADERS([util.h libutil.h])
    if test $ac_cv_header_util_h = yes; then
      HAVE_UTIL_H=1
    fi
    if test $ac_cv_header_libutil_h = yes; then
      HAVE_LIBUTIL_H=1
    fi
    AC_CHECK_HEADERS_ONCE([termios.h])
  else # Have <pty.h>, assume forkpty is declared there.
    HAVE_PTY_H=1
  fi
  AC_SUBST([HAVE_PTY_H])
  dnl <pty.h> is always overridden, because of GNULIB_POSIXCHECK.
  gl_CHECK_NEXT_HEADERS([pty.h])

  dnl Check for declarations of anything we want to poison if the
  dnl corresponding gnulib module is not in use.
  gl_WARN_ON_USE_PREPARE([[
/* <sys/types.h> is a prerequisite of <libutil.h> on FreeBSD 8.0.  */
#include <sys/types.h>
#if HAVE_PTY_H
# include <pty.h>
#endif
#if HAVE_UTIL_H
# include <util.h>
#endif
#if HAVE_LIBUTIL_H
# include <libutil.h>
#endif
#if HAVE_TERMIOS_H
# include <termios.h>
#endif
    ]], [forkpty openpty])
])

# gl_PTY_MODULE_INDICATOR([modulename])
# sets the shell variable that indicates the presence of the given module
# to a C preprocessor expression that will evaluate to 1.
# This macro invocation must not occur in macros that are AC_REQUIREd.
AC_DEFUN([gl_PTY_MODULE_INDICATOR],
[
  dnl Ensure to expand the default settings once only.
  gl_PTY_H_REQUIRE_DEFAULTS
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
  dnl Define it also as a C macro, for the benefit of the unit tests.
  gl_MODULE_INDICATOR_FOR_TESTS([$1])
])

# Initializes the default values for AC_SUBSTed shell variables.
# This macro must not be AC_REQUIREd.  It must only be invoked, and only
# outside of macros or in macros that are not AC_REQUIREd.
AC_DEFUN([gl_PTY_H_REQUIRE_DEFAULTS],
[
  m4_defun(GL_MODULE_INDICATOR_PREFIX[_PTY_H_MODULE_INDICATOR_DEFAULTS], [
    gl_MODULE_INDICATOR_INIT_VARIABLE([GNULIB_FORKPTY])
    gl_MODULE_INDICATOR_INIT_VARIABLE([GNULIB_OPENPTY])
  ])
  m4_require(GL_MODULE_INDICATOR_PREFIX[_PTY_H_MODULE_INDICATOR_DEFAULTS])
  AC_REQUIRE([gl_PTY_H_DEFAULTS])
])

AC_DEFUN([gl_PTY_H_DEFAULTS],
[
  dnl Assume proper GNU behavior unless another module says otherwise.
  HAVE_UTIL_H=0;        AC_SUBST([HAVE_UTIL_H])
  HAVE_LIBUTIL_H=0;     AC_SUBST([HAVE_LIBUTIL_H])
  HAVE_FORKPTY=1;       AC_SUBST([HAVE_FORKPTY])
  HAVE_OPENPTY=1;       AC_SUBST([HAVE_OPENPTY])
  REPLACE_FORKPTY=0;    AC_SUBST([REPLACE_FORKPTY])
  REPLACE_OPENPTY=0;    AC_SUBST([REPLACE_OPENPTY])
])
