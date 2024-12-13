# ==================================================================================
#  https://www.gnu.org/software/autoconf-archive/ax_warning_default_aclocaldir.html
# ==================================================================================
#
# SYNOPSIS
#
#   AX_WARNING_DEFAULT_ACLOCALDIR [(dirvariable [,[defsetting][,[A][,[N/A]]]])]
#   AX_ENABLE_DEFAULT_ACLOCALDIR [(dirvariable [,defsetting])]
#
# DESCRIPTION
#
#   print a warning message if the $(datadir)/aclocal directory is not in
#   the dirlist searched by the aclocal tool. This macro is useful if some
#   `make install` would target $(datadir)/aclocal to install an autoconf m4
#   file of your project to be picked up by other projects.
#
#    default $1 dirvariable = aclocaldir
#    default $2 defsetting  = ${datadir}/aclocal
#    default $3 action = nothing to do
#    default $4 action = warn the user about mismatch
#
#   In the _WARNING_ variant, the defsetting is not placed in dirvariable
#   nor is it ac_subst'ed in any way. The default fail-action $4 is to send
#   a warning message to the user, and the default accept-action $3 is
#   nothing. It is expected that a Makefile is generated with
#   aclocaldir=${datadir}/aclocal
#
#   The _ENABLE_ variant however will set not only the $aclocaldir shell var
#   of the script, but it is also AC-SUBST'ed on default - and furthermore a
#   configure option "--enable-default-aclocaldir" is provided. Only if that
#   option is set then $2 default is not set to the canonic default in the a
#   $prefix subpath but instead $2 default is set to the primary path where
#   `aclocal` looks for macros. The user may also override the default on
#   the command line.
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

AC_DEFUN([AX_WARNING_DEFAULT_ACLOCALDIR],[dnl
AC_REQUIRE([AX_EXPAND_PREFIX])dnl
AS_VAR_PUSHDEF([DIR],[ax_warning_default_aclocal_dir])dnl
AS_VAR_PUSHDEF([BIN],[ax_warning_default_aclocal_bin])dnl
AS_VAR_PUSHDEF([LOC],[ax_warning_default_aclocal_loc])dnl
LOC='m4_if([$2],,[${datadir}/aclocal],[$2])'
m4_ifval([$1],[test ".$[]$1" != "." && LOC="$[]$1"])
 if test ".$ACLOCAL" = "." ; then
    AC_PATH_PROG([ACLOCAL],[aclocal],[:])
 fi
 BIN="$ACLOCAL"
 test ".$BIN" = "." && BIN="aclocal"
 DIR=`test ".$SHELL" = "." && SHELL="'sh'" ; eval "$BIN --print-ac-dir"`
 test ".$DIR" = "." && test -d "/usr/share/aclocal" && DIR="/usr/share/aclocal"
 test ".$DIR" = "." && DIR="/tmp"
DIR=`eval "echo $DIR"`  # we need to expand
DIR=`eval "echo $DIR"`
LOC=`eval "echo $LOC"`
LOC=`eval "echo $LOC"`
LOC=`eval "echo $LOC"`
LOC=`eval "echo $LOC"`
AC_RUN_LOG([: test "$LOC" = "$DIR"])
if test "$LOC" != "$DIR" ; then
   if test -f "$DIR/dirlist" ; then
      for DIR in `cat $DIR/dirlist` $DIR ; do
          AC_RUN_LOG([: test "$LOC" = "$DIR"])
          test "$LOC" = "$DIR" && break
      done
   fi
   if test "$LOC" != "$DIR" ; then
      m4_ifval([$4],[$4],[dnl
      AC_MSG_NOTICE([warning: m4_if([$1],,[aclocaldir],[$1])=$LOC dnl
(see config.log)])
   AC_MSG_NOTICE([perhaps: make install m4_if([$1],,[aclocaldir],[$1])=$DIR])
   cat m4_ifset([AS_MESSAGE_LOG_FD],[>&AS_MESSAGE_LOG_FD],[>>config.log]) <<EOF
  aclocaldir:   the m4_if([$1],,[default aclocaldir],[$1 value]) of $LOC
  aclocaldir:   is not listed in the dirlist where aclocal will look
  aclocaldir:   for macros - you can override the install-path using
  aclocaldir:   make install aclocaldir=$DIR
  aclocaldir:   or append the directory to aclocal reconfigures later as
  aclocaldir:   aclocal -I $LOC
  aclocaldir:   when an autoconf macro is needed from that directory
EOF
   m4_ifvaln([$5],[$5])])dnl
   m4_ifvaln([$3],[else $3])dnl
   fi
fi
AS_VAR_POPDEF([LOC])dnl
AS_VAR_POPDEF([BIN])dnl
AS_VAR_POPDEF([DIR])dnl
])

AC_DEFUN([AX_ENABLE_DEFAULT_ACLOCALDIR],[dnl
AS_VAR_PUSHDEF([BIN],[ax_warning_default_aclocal_bin])dnl
AS_VAR_PUSHDEF([DIR],[ax_warning_default_aclocal_def])dnl
AS_VAR_PUSHDEF([DEF],[ax_warning_default_aclocal_def])dnl
AC_ARG_ENABLE([default-aclocaldir],
  [AS_HELP_STRING([--enable-default-aclocaldir@<:@=PATH@:>@], [override the datadir/aclocal default])])
test ".$enable_default_aclocaldir" = "." && enable_default_aclocaldir="no"
case ".$enable_default_aclocaldir" in
  .no) DIR='m4_if([$2],,[${datadir}/aclocal],[$2])' ;;
  .yes) # autodetect
 if test ".$ACLOCAL" = "." ; then
    AC_PATH_PROG([ACLOCAL],[aclocal],[:])
 fi
 BIN="$ACLOCAL"
 test ".$BIN" = "." && BIN="aclocal"
 DIR=`test ".$SHELL" = "." && SHELL="'sh'" ; eval "$BIN --print-ac-dir"`
 test ".$DIR" = "." && test -d "/usr/share/aclocal" && DIR="/usr/share/aclocal"
 test ".$DIR" = "." && DIR="/tmp" ;;
  *) DIR="$enable_default_aclocaldir" ;;
esac
AX_WARNING_DEFAULT_ACLOCALDIR([$1],[$DEF],[$3],[$4],[$5])
m4_if([$1],,[aclocaldir],[$1])="$ax_warning_default_aclocal_dir"
AC_SUBST(m4_if([$1],,[aclocaldir],[$1]))
AS_VAR_POPDEF([DEF])dnl
AS_VAR_POPDEF([DIR])dnl
AS_VAR_POPDEF([BIN])dnl
])
