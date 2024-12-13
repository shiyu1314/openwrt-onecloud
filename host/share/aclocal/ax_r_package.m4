# ===========================================================================
#       https://www.gnu.org/software/autoconf-archive/ax_r_package.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_R_PACKAGE(pkgname[, version, R])
#
# DESCRIPTION
#
#   Checks for an R package.
#
#   Optionally checks for the version when a second argument is given. A
#   different R can be used by providing a third argument.
#
# LICENSE
#
#   Copyright (c) 2017, 2022 Ricardo Wurmus
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved. This file is offered as-is, without any
#   warranty.

#serial 5

AC_DEFUN([AX_R_PACKAGE], [
    pushdef([PKG],$1)
    pushdef([VERSION],$2)

    if test -z $R;
    then
        if test -z "$3";
        then
            R="R"
        else
            R="$3"
        fi
    fi

    AC_MSG_CHECKING([R package PKG VERSION])

    TEST=$( $R --silent --vanilla -e 'if(is.na(packageDescription("PKG"))) stop("not found")' 2>/dev/null )
    AS_IF([test $? -eq 0], [], [
      AC_MSG_RESULT([no])
      AC_MSG_ERROR([R package PKG not found.])
    ])

    if test -n "VERSION"
    then
      TEST=$( $R --silent --vanilla -e 'if(compareVersion(packageDescription("PKG")$Version, "VERSION") < 0) { stop("not found") }' 2>/dev/null )
      AS_IF([test $? -eq 0], [], [
        AC_MSG_RESULT([no])
        AC_MSG_ERROR([You need at least version VERSION of the R package PKG.])
      ])
    fi

    AC_MSG_RESULT(yes)
    popdef([PKG])
    popdef([VERSION])
])
