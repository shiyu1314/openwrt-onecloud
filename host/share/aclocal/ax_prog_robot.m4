# ===========================================================================
#      https://www.gnu.org/software/autoconf-archive/ax_prog_robot.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_PROG_ROBOT([VERSION],[ACTION-IF-TRUE],[ACTION-IF-FALSE])
#
# DESCRIPTION
#
#   This macro searches for the "robot" command from the Robot Framework and
#   sets the variable "ROBOT" to the name of the application and the
#   "ROBOT_VERSION" variable to the version of the Robot Framework. When
#   robot is found sets the "HAS_ROBOT" to "yes", otherwise to "no".
#
#   Example:
#
#     AX_PROG_ROBOT([3.1.0], [], [])
#
# LICENSE
#
#   Copyright (c) 2020, Adam Chyla <adam@chyla.org>
#
#   Distributed under the terms of the BSD 3-Clause License.

#serial 5

AC_DEFUN([AX_PROG_ROBOT],
[
    AC_REQUIRE([AC_PROG_SED])

    ax_robot_version="$1"

    AC_CHECK_PROGS(ROBOT,[robot])
    AS_IF([test "x$ROBOT" = "x"],
        [
            AC_SUBST([HAS_ROBOT],[no])
            AC_SUBST([ROBOT_VERSION],[])
            $3
        ],
        [
            AC_MSG_CHECKING([for robot version])
            changequote(<<,>>)
            robot_version=`$ROBOT --version | $SED -e 's/^[^0-9]* \([0-9.]*\) .*/\1/'`
            changequote([,])
            AC_MSG_RESULT($robot_version)

            AX_COMPARE_VERSION([$ax_robot_version],[le],[$robot_version],
                [
                    AC_SUBST([HAS_ROBOT],[yes])
                    AC_SUBST([ROBOT_VERSION],[$robot_version])
                    $2
                ],
                [
                    AC_SUBST([HAS_ROBOT],[no])
                    AC_SUBST([ROBOT],[])
                    AC_SUBST([ROBOT_VERSION],[])
                    $3
                ]
            )
        ]
    )
])
