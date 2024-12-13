# posix_openpt.m4 serial 4
dnl Copyright (C) 2011-2023 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_POSIX_OPENPT],
[
  AC_REQUIRE([gl_STDLIB_H_DEFAULTS])

  dnl Persuade Solaris <stdlib.h> to declare posix_openpt().
  AC_REQUIRE([AC_USE_SYSTEM_EXTENSIONS])

  gl_CHECK_FUNCS_ANDROID([posix_openpt], [[#include <stdlib.h>]])
  if test $ac_cv_func_posix_openpt != yes; then
    dnl The system does not have posix_openpt.
    HAVE_POSIX_OPENPT=0
    case "$gl_cv_onwards_func_posix_openpt" in
      future*) REPLACE_POSIX_OPENPT=1 ;;
    esac
  fi
])
