# This file is part of Autoconf.			-*- Autoconf -*-
# Checking for headers.
#
# Copyright (C) 1988, 1999-2004, 2006, 2008-2017, 2020-2021 Free
# Software Foundation, Inc.

# This file is part of Autoconf.  This program is free
# software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the
# Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Under Section 7 of GPL version 3, you are granted additional
# permissions described in the Autoconf Configure Script Exception,
# version 3.0, as published by the Free Software Foundation.
#
# You should have received a copy of the GNU General Public License
# and a copy of the Autoconf Configure Script Exception along with
# this program; see the files COPYINGv3 and COPYING.EXCEPTION
# respectively.  If not, see <https://www.gnu.org/licenses/>.

# Written by David MacKenzie, with help from
# Franc,ois Pinard, Karl Berry, Richard Pixley, Ian Lance Taylor,
# Roland McGrath, Noah Friedman, david d zuhn, and many others.


# Table of contents
#
# 1. Generic tests for headers
# 2. Default includes
# 3. Headers to tests with AC_CHECK_HEADERS
# 4. Tests for specific headers


## ------------------------------ ##
## 1. Generic tests for headers.  ##
## ------------------------------ ##


# AC_CHECK_HEADER(HEADER-FILE,
#		  [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#		  [INCLUDES])
# ---------------------------------------------------------
# This used to check for headers using the preprocessor only, but we
# have now switched to running a full compilation, so that we learn
# about the usability of a header instead of its mere presence.
# The old behavior is still available by specifying `-' as the
# INCLUDES, but this triggers a deprecation warning.
#
# The m4_indir allows for fewer expansions of $@.
AC_DEFUN([AC_CHECK_HEADER],
[m4_indir(m4_if([$4], [-],
                [[_AC_CHECK_HEADER_PREPROC]],
                [[_AC_CHECK_HEADER_COMPILE]]), $@)])


# _AC_CHECK_HEADER_COMPILE_BODY
# -----------------------------
# Shell function body for _AC_CHECK_HEADER_COMPILE
m4_define([_AC_CHECK_HEADER_COMPILE_BODY],
[  AS_LINENO_PUSH([$[]1])
  AC_CACHE_CHECK([for $[]2], [$[]3],
		 [AC_COMPILE_IFELSE([AC_LANG_SOURCE([$[]4
@%:@include <$[]2>])],
				    [AS_VAR_SET([$[]3], [yes])],
				    [AS_VAR_SET([$[]3], [no])])])
  AS_LINENO_POP
])# _AC_CHECK_HEADER_COMPILE_BODY


m4_define([_AC_CHECK_HEADER_COMPILE_FN],
[AC_REQUIRE_SHELL_FN([ac_fn_]_AC_LANG_ABBREV[_check_header_compile],
  [AS_FUNCTION_DESCRIBE([ac_fn_]_AC_LANG_ABBREV[_check_header_compile],
    [LINENO HEADER VAR INCLUDES],
    [Tests whether HEADER exists and can be compiled using the include files
     in INCLUDES, setting the cache variable VAR accordingly.])],
  [_AC_CHECK_HEADER_COMPILE_BODY])])

# _AC_CHECK_HEADER_COMPILE(HEADER-FILE,
#		       [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#		       [INCLUDES = DEFAULT-INCLUDES])
# --------------------------------------------------------------
# Check the compiler accepts HEADER-FILE.  The INCLUDES are defaulted.
AC_DEFUN([_AC_CHECK_HEADER_COMPILE],
[_AC_CHECK_HEADER_COMPILE_FN()]dnl
[AS_VAR_PUSHDEF([ac_Header], [ac_cv_header_$1])]dnl
[ac_fn_[]_AC_LANG_ABBREV[]_check_header_compile ]dnl
["$LINENO" "$1" "ac_Header" "AS_ESCAPE([AC_INCLUDES_DEFAULT([$4])], [""])"
AS_VAR_IF([ac_Header], [yes], [$2], [$3])
AS_VAR_POPDEF([ac_Header])])# _AC_CHECK_HEADER_COMPILE


# _AC_CHECK_HEADER_PREPROC_BODY
# -----------------------------
# Shell function body for _AC_CHECK_HEADER_PREPROC.
m4_define([_AC_CHECK_HEADER_PREPROC_BODY],
[  AS_LINENO_PUSH([$[]1])
  AC_CACHE_CHECK([for $[]2], [$[]3],
  [AC_PREPROC_IFELSE([AC_LANG_SOURCE([@%:@include <$[]2>])],
		     [AS_VAR_SET([$[]3], [yes])],
		     [AS_VAR_SET([$[]3], [no])])])
  AS_LINENO_POP
])# _AC_CHECK_HEADER_PREPROC_BODY


# _AC_CHECK_HEADER_PREPROC(HEADER-FILE,
#		       [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# --------------------------------------------------------------
# Check the preprocessor accepts HEADER-FILE.
AC_DEFUN([_AC_CHECK_HEADER_PREPROC],
[m4_warn([obsolete], [Checking for headers with the preprocessor is
deprecated. Specify prerequisite code to AC_CHECK_HEADER
instead of using fourth argument `-'. (Many headers need
no prerequisites. If you truly need to test whether
something passes the preprocessor but not the compiler,
use AC_PREPROC_IFELSE.)])]dnl
[AC_REQUIRE_SHELL_FN([ac_fn_]_AC_LANG_ABBREV[_check_header_preproc],
  [AS_FUNCTION_DESCRIBE([ac_fn_]_AC_LANG_ABBREV[_check_header_preproc],
    [LINENO HEADER VAR],
    [Tests whether HEADER exists and can be preprocessed (in isolation),
     setting the cache variable VAR accordingly.])],
  [$0_BODY])]dnl
[AS_VAR_PUSHDEF([ac_Header], [ac_cv_header_$1])]dnl
[ac_fn_[]_AC_LANG_ABBREV[]_check_header_preproc "$LINENO" "$1" "ac_Header"
AS_VAR_IF([ac_Header], [yes], [$2], [$3])
AS_VAR_POPDEF([ac_Header])])# _AC_CHECK_HEADER_PREPROC


# _AC_CHECK_HEADER_OLD(HEADER-FILE, [ACTION-IF-FOUND],
#                      [ACTION-IF-NOT-FOUND])
# _AC_CHECK_HEADER_NEW(HEADER-FILE, [ACTION-IF-FOUND],
#                      [ACTION-IF-NOT-FOUND])
# ----------------------------------------------------
# Some packages used these undocumented macros.  Even worse, gcc
# redefined AC_CHECK_HEADER in terms of _AC_CHECK_HEADER_OLD, so we
# can't do the simpler:
#   AU_DEFUN([_AC_CHECK_HEADER_OLD],
#     [AC_CHECK_HEADER([$1], [$2], [$3], [-])])
AC_DEFUN([_AC_CHECK_HEADER_OLD],
[m4_warn([obsolete], [The macro `$0' is obsolete.
You should use AC_CHECK_HEADER with a fourth argument.])]dnl
[_AC_CHECK_HEADER_PREPROC($@)])

AC_DEFUN([_AC_CHECK_HEADER_NEW],
[m4_warn([obsolete], [The macro `$0' is obsolete.
You should use AC_CHECK_HEADER with a fourth argument.])]dnl
[_AC_CHECK_HEADER_COMPILE($@)])

# _AC_CHECK_HEADER_MONGREL(HEADER-FILE,
#			   [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# ------------------------------------------------------------------
# In case anyone used this undocumented macro.  Map to the _PREPROC
# semantics to minimize the chance of breaking anything.
AU_DEFUN([_AC_CHECK_HEADER_MONGREL],
  [AC_CHECK_HEADER([$1], [$2], [$3], [-])])


# _AH_CHECK_HEADER(HEADER-FILE)
# -----------------------------
# Prepare the autoheader snippet for HEADER-FILE.
m4_define([_AH_CHECK_HEADER],
[AH_TEMPLATE(AS_TR_CPP([HAVE_$1]),
  [Define to 1 if you have the <$1> header file.])])


# AH_CHECK_HEADERS(HEADER-FILE...)
# --------------------------------
m4_define([AH_CHECK_HEADERS],
[m4_foreach_w([AC_Header], [$1], [_AH_CHECK_HEADER(m4_defn([AC_Header]))])])

# _AC_CHECK_HEADERS_ONE_U(HEADER-FILE)
# -------------------------------
# Perform the actions that need to be performed unconditionally
# for every HEADER-FILE that *could* be checked for by AC_CHECK_HEADERS.
m4_define([_AC_CHECK_HEADERS_ONE_U],
[AS_LITERAL_WORD_IF([$1],
  [_AH_CHECK_HEADER([$1])],
  [m4_warn([syntax], [AC_CHECK_HEADERS($1): you should use literals])])])

# _AC_CHECK_HEADERS_ONE_S(HEADER-FILE, [INCLUDES])
# -------------------------------
# If HEADER-FILE exists, define HAVE_HEADER_FILE.  HEADER-FILE must be literal.
# Used by AC_CHECK_HEADERS for its simplest case, when its HEADER-FILE list
# is fully literal and no optional actions were supplied.
# INCLUDES is as for AC_CHECK_HEADER.
m4_define([_AC_CHECK_HEADERS_ONE_S],
[_AH_CHECK_HEADER([$1])]dnl
[AC_CHECK_HEADER([$1],
  [AC_DEFINE(AS_TR_CPP([HAVE_$1]))], [], [$2])])

# _AC_CHECK_HEADERS_ONE_C(HEADER-FILE, [ACTION-IF-FOUND],
#    [ACTION-IF-NOT-FOUND], [INCLUDES])
# -------------------------------------------------------------------------
# If HEADER-FILE exists, define HAVE_HEADER-FILE and execute ACTION-IF-FOUND.
# Otherwise execute ACTION-IF-NOT-FOUND.  HEADER-FILE can be a shell variable.
# Used by AC_CHECK_HEADERS for complex cases.
# INCLUDES is as for AC_CHECK_HEADER.
m4_define([_AC_CHECK_HEADERS_ONE_C],
[AC_CHECK_HEADER([$1],
  [AC_DEFINE_UNQUOTED(AS_TR_CPP([HAVE_]$1)) $2],
  [$3], [$4])])

# AC_CHECK_HEADERS(HEADER-FILE...,
#		   [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],
#		   [INCLUDES])
# ----------------------------------------------------------
# Check for each whitespace-separated HEADER-FILE (omitting the <> or
# ""), and perform ACTION-IF-FOUND or ACTION-IF-NOT-FOUND for each
# header.  INCLUDES is as for AC_CHECK_HEADER.  Additionally, make the
# preprocessor definition HAVE_HEADER_FILE available for each found
# header.  Either ACTION may include `break' to stop the search.
AC_DEFUN([AC_CHECK_HEADERS],
[_$0(m4_validate_w([$1]), [$2], [$3], [$4])])

m4_define([_AC_CHECK_HEADERS],
[m4_if([$2$3]AS_LITERAL_IF([$1], [[yes]], [[no]]), [yes],
       [m4_map_args_w([$1], [_AC_CHECK_HEADERS_ONE_S(], [, [$4])])],
       [m4_map_args_w([$1], [_AC_CHECK_HEADERS_ONE_U(], [)])]dnl
       [AS_FOR([AC_header], [ac_header], [$1],
               [_AC_CHECK_HEADERS_ONE_C(AC_header, [$2], [$3], [$4])])])])


# _AC_CHECK_HEADER_ONCE(HEADER-FILE)
# ----------------------------------
# Check for a single HEADER-FILE once.
m4_define([_AC_CHECK_HEADER_ONCE],
[_AH_CHECK_HEADER([$1])AC_DEFUN([_AC_Header_]m4_translit([[$1]],
    [./-], [___]), [m4_divert_text([INIT_PREPARE],
  [AS_VAR_APPEND([ac_header_]]_AC_LANG_ABBREV[[_list],
  [" $1 ]AS_TR_SH([$1]) AS_TR_CPP([HAVE_$1])["])])]dnl
[_AC_HEADERS_EXPANSION(_AC_LANG_ABBREV)])AC_REQUIRE(
  [_AC_Header_]m4_translit([[$1]], [./-], [___]))])


# AC_CHECK_HEADERS_ONCE(HEADER-FILE...)
# -------------------------------------
# Add each whitespace-separated name in HEADER-FILE to the list of
# headers to check once.
# Note: has intimate knowledge of how AC_INCLUDES_DEFAULT works,
# and vice versa.
AC_DEFUN([AC_CHECK_HEADERS_ONCE],
  [AC_REQUIRE([AC_CHECK_INCLUDES_DEFAULT])]dnl
  [m4_map_args_w(m4_validate_w([$1]), [_AC_CHECK_HEADER_ONCE(], [)])])


# _AC_HEADERS_EXPANSION(LANG)
# ---------------------------
# One-shot code per language LANG for checking all headers registered by
# AC_CHECK_HEADERS_ONCE while that language was active.  We have to inline
# portions of AC_CHECK_HEADER_COMPILE, because although we operate on shell
# variables, we know they represent literals at that point in time,
# where we don't want to trigger normal AS_VAR_PUSHDEF shell code.
m4_define([_AC_HEADERS_EXPANSION],
[m4_ifndef([$0($1)], [m4_define([$0($1)])m4_divert_text([DEFAULTS],
[ac_header_$1_list=])ac_header= ac_cache=
for ac_item in $ac_header_$1_list
do
  if test $ac_cache; then
    _AC_CHECK_HEADER_COMPILE_FN()ac_fn_$1_check_header_compile "$LINENO" ]dnl
[$ac_header ac_cv_header_$ac_cache "$ac_includes_default"
    if eval test \"x\$ac_cv_header_$ac_cache\" = xyes; then
      printf "%s\n" "[#]define $ac_item 1" >> confdefs.h
    fi
    ac_header= ac_cache=
  elif test $ac_header; then
    ac_cache=$ac_item
  else
    ac_header=$ac_item
  fi
done])])



## --------------------- ##
## 2. Default includes.  ##
## --------------------- ##

# Always use the same set of default headers for all the generic
# macros.  It is easier to document, to extend, and to understand than
# having specific defaults for each macro.

# AC_CHECK_INCLUDES_DEFAULT
# -------------------------
# Required when AC_INCLUDES_DEFAULT uses its default branch.
AC_DEFUN_ONCE([AC_CHECK_INCLUDES_DEFAULT],
dnl If ever you change this variable, please keep autoconf.texi in sync.
[m4_divert_text([DEFAULTS],
[# Factoring default headers for most tests.
ac_includes_default="\
#include <stddef.h>
#ifdef HAVE_STDIO_H
# include <stdio.h>
#endif
#ifdef HAVE_STDLIB_H
# include <stdlib.h>
#endif
#ifdef HAVE_STRING_H
# include <string.h>
#endif
#ifdef HAVE_INTTYPES_H
# include <inttypes.h>
#endif
#ifdef HAVE_STDINT_H
# include <stdint.h>
#endif
#ifdef HAVE_STRINGS_H
# include <strings.h>
#endif
#ifdef HAVE_SYS_TYPES_H
# include <sys/types.h>
#endif
#ifdef HAVE_SYS_STAT_H
# include <sys/stat.h>
#endif
#ifdef HAVE_UNISTD_H
# include <unistd.h>
#endif"
])]dnl
[dnl We have to check for all the headers that aren't part of the
dnl C-1990 *freestanding* environment, which is all of them except stddef.h.
m4_map_args([_AC_CHECK_HEADER_ONCE],
  [stdio.h], [stdlib.h], [string.h], [inttypes.h], [stdint.h],
  [strings.h], [sys/stat.h], [sys/types.h], [unistd.h])]dnl
[AS_IF([test $ac_cv_header_stdlib_h = yes && test $ac_cv_header_string_h = yes],
[AC_DEFINE([STDC_HEADERS], [1],
  [Define to 1 if all of the C90 standard headers exist
   (not just the ones required in a freestanding environment).
   This macro is provided for backward compatibility;
   new code need not use it.])])])
# AC_CHECK_INCLUDES_DEFAULT


# AC_INCLUDES_DEFAULT([INCLUDES])
# -------------------------------
# If INCLUDES is empty, expand in default includes, otherwise in
# INCLUDES.
# In most cases INCLUDES is not double quoted as it should, and if
# for instance INCLUDES = `#include <stdio.h>' then unless we force
# a newline, the hash will swallow the closing paren etc. etc.
# The usual failure.
# Take no risk: for the newline.
AC_DEFUN([AC_INCLUDES_DEFAULT],
[m4_ifval([$1], [$1
],
[AC_REQUIRE([AC_CHECK_INCLUDES_DEFAULT])]dnl
[$ac_includes_default])])


## ------------------------------------------- ##
## 3. Headers to check with AC_CHECK_HEADERS.  ##
## ------------------------------------------- ##

# There is no longer any need to check for headers that are part of
# ISO C90 (as amended): assert.h, ctype.h, errno.h, float.h, iso646.h,
# limits.h, locale.h, math.h, setjmp.h, signal.h, stdarg.h, stddef.h,
# stdio.h, stdlib.h, string.h, time.h, wchar.h, wctype.h.

AN_HEADER([OS.h],               [AC_CHECK_HEADERS])
AN_HEADER([argz.h],             [AC_CHECK_HEADERS])
AN_HEADER([arpa/inet.h],        [AC_CHECK_HEADERS])
AN_HEADER([fcntl.h],            [AC_CHECK_HEADERS])
AN_HEADER([fenv.h],             [AC_CHECK_HEADERS])
AN_HEADER([fs_info.h],          [AC_CHECK_HEADERS])
AN_HEADER([inttypes.h],         [AC_CHECK_HEADERS])
AN_HEADER([langinfo.h],         [AC_CHECK_HEADERS])
AN_HEADER([libintl.h],          [AC_CHECK_HEADERS])
AN_HEADER([mach/mach.h],        [AC_CHECK_HEADERS])
AN_HEADER([malloc.h],           [AC_CHECK_HEADERS])
AN_HEADER([mntent.h],           [AC_CHECK_HEADERS])
AN_HEADER([mnttab.h],           [AC_CHECK_HEADERS])
AN_HEADER([netdb.h],            [AC_CHECK_HEADERS])
AN_HEADER([netinet/in.h],       [AC_CHECK_HEADERS])
AN_HEADER([nl_types.h],         [AC_CHECK_HEADERS])
AN_HEADER([nlist.h],            [AC_CHECK_HEADERS])
AN_HEADER([paths.h],            [AC_CHECK_HEADERS])
AN_HEADER([sgtty.h],            [AC_CHECK_HEADERS])
AN_HEADER([shadow.h],           [AC_CHECK_HEADERS])
AN_HEADER([stdint.h],           [AC_CHECK_HEADERS])
AN_HEADER([stdio_ext.h],        [AC_CHECK_HEADERS])
AN_HEADER([strings.h],          [AC_CHECK_HEADERS])
AN_HEADER([sys/acl.h],          [AC_CHECK_HEADERS])
AN_HEADER([sys/file.h],         [AC_CHECK_HEADERS])
AN_HEADER([sys/filsys.h],       [AC_CHECK_HEADERS])
AN_HEADER([sys/fs/s5param.h],   [AC_CHECK_HEADERS])
AN_HEADER([sys/fs_types.h],     [AC_CHECK_HEADERS])
AN_HEADER([sys/fstyp.h],        [AC_CHECK_HEADERS])
AN_HEADER([sys/ioctl.h],        [AC_CHECK_HEADERS])
AN_HEADER([sys/mntent.h],       [AC_CHECK_HEADERS])
AN_HEADER([sys/mount.h],        [AC_CHECK_HEADERS])
AN_HEADER([sys/param.h],        [AC_CHECK_HEADERS])
AN_HEADER([sys/socket.h],       [AC_CHECK_HEADERS])
AN_HEADER([sys/statfs.h],       [AC_CHECK_HEADERS])
AN_HEADER([sys/statvfs.h],      [AC_CHECK_HEADERS])
AN_HEADER([sys/systeminfo.h],   [AC_CHECK_HEADERS])
AN_HEADER([sys/time.h],         [AC_CHECK_HEADERS])
AN_HEADER([sys/timeb.h],        [AC_CHECK_HEADERS])
AN_HEADER([sys/vfs.h],          [AC_CHECK_HEADERS])
AN_HEADER([sys/window.h],       [AC_CHECK_HEADERS])
AN_HEADER([syslog.h],           [AC_CHECK_HEADERS])
AN_HEADER([termio.h],           [AC_CHECK_HEADERS])
AN_HEADER([termios.h],          [AC_CHECK_HEADERS])
AN_HEADER([unistd.h],           [AC_CHECK_HEADERS])
AN_HEADER([utime.h],            [AC_CHECK_HEADERS])
AN_HEADER([utmp.h],             [AC_CHECK_HEADERS])
AN_HEADER([utmpx.h],            [AC_CHECK_HEADERS])
AN_HEADER([values.h],           [AC_CHECK_HEADERS])

## ------------------------------- ##
## 4. Tests for specific headers.  ##
## ------------------------------- ##

# AC_HEADER_ASSERT
# ----------------
# Check whether to enable assertions.
AC_DEFUN_ONCE([AC_HEADER_ASSERT],
[
  AC_MSG_CHECKING([whether to enable assertions])
  AC_ARG_ENABLE([assert],
    [AS_HELP_STRING([--disable-assert], [turn off assertions])],
    [ac_enable_assert=$enableval
     AS_IF(dnl
      [test "x$enableval" = xno],
	[AC_DEFINE([NDEBUG], [1],
	  [Define to 1 if assertions should be disabled.])],
      [test "x$enableval" != xyes],
	[AC_MSG_WARN([invalid argument supplied to --enable-assert])
	ac_enable_assert=yes])],
    [ac_enable_assert=yes])
  AC_MSG_RESULT([$ac_enable_assert])
])


# _AC_CHECK_HEADER_DIRENT(HEADER-FILE,
#			  [ACTION-IF-FOUND], [ACTION-IF-NOT_FOUND])
# -----------------------------------------------------------------
# Like AC_CHECK_HEADER, except also make sure that HEADER-FILE
# defines the type `DIR'.  dirent.h on NextStep 3.2 doesn't.
m4_define([_AC_CHECK_HEADER_DIRENT],
[AS_VAR_PUSHDEF([ac_Header], [ac_cv_header_dirent_$1])dnl
AC_CACHE_CHECK([for $1 that defines DIR], [ac_Header],
[AC_COMPILE_IFELSE([AC_LANG_PROGRAM([#include <sys/types.h>
#include <$1>
],
				    [if ((DIR *) 0)
return 0;])],
		   [AS_VAR_SET([ac_Header], [yes])],
		   [AS_VAR_SET([ac_Header], [no])])])
AS_VAR_IF([ac_Header], [yes], [$2], [$3])
AS_VAR_POPDEF([ac_Header])dnl
])# _AC_CHECK_HEADER_DIRENT


# _AH_CHECK_HEADER_DIRENT(HEADERS)
# --------------------------------
# Like _AH_CHECK_HEADER, but tuned to a dirent provider.
m4_define([_AH_CHECK_HEADER_DIRENT],
[AH_TEMPLATE(AS_TR_CPP([HAVE_$1]),
  [Define to 1 if you have the <$1> header file, and it defines `DIR'.])])


# AC_HEADER_DIRENT
# ----------------
AC_DEFUN([AC_HEADER_DIRENT],
[m4_map_args([_AH_CHECK_HEADER_DIRENT], [dirent.h], [sys/ndir.h],
	     [sys/dir.h], [ndir.h])]dnl
[ac_header_dirent=no
for ac_hdr in dirent.h sys/ndir.h sys/dir.h ndir.h; do
  _AC_CHECK_HEADER_DIRENT($ac_hdr,
			  [AC_DEFINE_UNQUOTED(AS_TR_CPP(HAVE_$ac_hdr), 1)
ac_header_dirent=$ac_hdr; break])
done
# Two versions of opendir et al. are in -ldir and -lx on SCO Xenix.
if test $ac_header_dirent = dirent.h; then
  AC_SEARCH_LIBS(opendir, dir)
else
  AC_SEARCH_LIBS(opendir, x)
fi
])# AC_HEADER_DIRENT


# AC_HEADER_MAJOR
# ---------------
# Thanks to glibc 2.25 deprecating macros in sys/types.h, coupled with
# back-compat to autoconf 2.69, we need the following logic:
# Check whether <sys/types.h> compiles.
# If <sys/mkdev.h> compiles, assume it provides major/minor/makedev.
# Otherwise, if <sys/sysmacros.h> compiles, assume it provides the macros.
# Otherwise, either the macros were provided by <sys/types.h>, or do
# not exist on the platform.  Code trying to use these three macros is
# assumed to not care about platforms that lack the macros.
AN_FUNCTION([major],     [AC_HEADER_MAJOR])
AN_FUNCTION([makedev],   [AC_HEADER_MAJOR])
AN_FUNCTION([minor],     [AC_HEADER_MAJOR])
AN_HEADER([sys/mkdev.h], [AC_HEADER_MAJOR])
AC_DEFUN([AC_HEADER_MAJOR],
[AC_CHECK_HEADERS_ONCE([sys/types.h])
AC_CHECK_HEADER([sys/mkdev.h],
		[AC_DEFINE([MAJOR_IN_MKDEV], [1],
			   [Define to 1 if `major', `minor', and `makedev' are
			    declared in <mkdev.h>.])])
if test $ac_cv_header_sys_mkdev_h = no; then
  AC_CHECK_HEADER([sys/sysmacros.h],
		  [AC_DEFINE([MAJOR_IN_SYSMACROS], [1],
			     [Define to 1 if `major', `minor', and `makedev'
			      are declared in <sysmacros.h>.])])
fi
])# AC_HEADER_MAJOR


# AC_HEADER_RESOLV
# ----------------
# sys/types.h, netinet/in.h and arpa/nameser.h are required on IRIX.
# netinet/in.h is needed on Cygwin, too.
# With Solaris 9, netdb.h is required, to get symbols like HOST_NOT_FOUND.
#
AN_HEADER(resolv.h,	[AC_HEADER_RESOLV])
AC_DEFUN([AC_HEADER_RESOLV],
[AC_CHECK_HEADERS(sys/types.h netinet/in.h arpa/nameser.h netdb.h resolv.h,
		  [], [],
[[#ifdef HAVE_SYS_TYPES_H
#  include <sys/types.h>
#endif
#ifdef HAVE_NETINET_IN_H
#  include <netinet/in.h>   /* inet_ functions / structs */
#endif
#ifdef HAVE_ARPA_NAMESER_H
#  include <arpa/nameser.h> /* DNS HEADER struct */
#endif
#ifdef HAVE_NETDB_H
#  include <netdb.h>
#endif]])
])# AC_HEADER_RESOLV


# AC_HEADER_STAT
# --------------
# FIXME: Shouldn't this be named AC_HEADER_SYS_STAT?
AC_DEFUN([AC_HEADER_STAT],
[AC_CACHE_CHECK(whether stat file-mode macros are broken,
  ac_cv_header_stat_broken,
[AC_COMPILE_IFELSE([AC_LANG_SOURCE([[#include <sys/types.h>
#include <sys/stat.h>

#if defined S_ISBLK && defined S_IFDIR
extern char c1[S_ISBLK (S_IFDIR) ? -1 : 1];
#endif

#if defined S_ISBLK && defined S_IFCHR
extern char c2[S_ISBLK (S_IFCHR) ? -1 : 1];
#endif

#if defined S_ISLNK && defined S_IFREG
extern char c3[S_ISLNK (S_IFREG) ? -1 : 1];
#endif

#if defined S_ISSOCK && defined S_IFREG
extern char c4[S_ISSOCK (S_IFREG) ? -1 : 1];
#endif
]])], ac_cv_header_stat_broken=no, ac_cv_header_stat_broken=yes)])
if test $ac_cv_header_stat_broken = yes; then
  AC_DEFINE(STAT_MACROS_BROKEN, 1,
	    [Define to 1 if the `S_IS*' macros in <sys/stat.h> do not
	     work properly.])
fi
])# AC_HEADER_STAT


# AC_CHECK_HEADER_STDBOOL
# -----------------
# Check for stdbool.h that conforms to C99.
AN_IDENTIFIER([bool], [AC_CHECK_HEADER_STDBOOL])
AN_IDENTIFIER([true], [AC_CHECK_HEADER_STDBOOL])
AN_IDENTIFIER([false],[AC_CHECK_HEADER_STDBOOL])
AC_DEFUN([AC_CHECK_HEADER_STDBOOL],
  [AC_CHECK_TYPES([_Bool])
   AC_CACHE_CHECK([for stdbool.h that conforms to C99],
     [ac_cv_header_stdbool_h],
     [AC_COMPILE_IFELSE(
        [AC_LANG_PROGRAM(
           [[#include <stdbool.h>

             #ifndef __bool_true_false_are_defined
               #error "__bool_true_false_are_defined is not defined"
             #endif
             char a[__bool_true_false_are_defined == 1 ? 1 : -1];

             /* Regardless of whether this is C++ or "_Bool" is a
                valid type name, "true" and "false" should be usable
                in #if expressions and integer constant expressions,
                and "bool" should be a valid type name.  */

             #if !true
               #error "'true' is not true"
             #endif
             #if true != 1
               #error "'true' is not equal to 1"
             #endif
             char b[true == 1 ? 1 : -1];
             char c[true];

             #if false
               #error "'false' is not false"
             #endif
             #if false != 0
               #error "'false' is not equal to 0"
             #endif
             char d[false == 0 ? 1 : -1];

             enum { e = false, f = true, g = false * true, h = true * 256 };

             char i[(bool) 0.5 == true ? 1 : -1];
             char j[(bool) 0.0 == false ? 1 : -1];
             char k[sizeof (bool) > 0 ? 1 : -1];

             struct sb { bool s: 1; bool t; } s;
             char l[sizeof s.t > 0 ? 1 : -1];

             /* The following fails for
                HP aC++/ANSI C B3910B A.05.55 [Dec 04 2003]. */
             bool m[h];
             char n[sizeof m == h * sizeof m[0] ? 1 : -1];
             char o[-1 - (bool) 0 < 0 ? 1 : -1];
             /* Catch a bug in an HP-UX C compiler.  See
         https://gcc.gnu.org/ml/gcc-patches/2003-12/msg02303.html
         https://lists.gnu.org/archive/html/bug-coreutils/2005-11/msg00161.html
              */
             bool p = true;
             bool *pp = &p;

             /* C 1999 specifies that bool, true, and false are to be
                macros, but C++ 2011 and later overrule this.  */
             #if __cplusplus < 201103
              #ifndef bool
               #error "bool is not defined"
              #endif
              #ifndef false
               #error "false is not defined"
              #endif
              #ifndef true
               #error "true is not defined"
              #endif
             #endif

             /* If _Bool is available, repeat with it all the tests
                above that used bool.  */
             #ifdef HAVE__BOOL
               struct sB { _Bool s: 1; _Bool t; } t;

               char q[(_Bool) 0.5 == true ? 1 : -1];
               char r[(_Bool) 0.0 == false ? 1 : -1];
               char u[sizeof (_Bool) > 0 ? 1 : -1];
               char v[sizeof t.t > 0 ? 1 : -1];

               _Bool w[h];
               char x[sizeof m == h * sizeof m[0] ? 1 : -1];
               char y[-1 - (_Bool) 0 < 0 ? 1 : -1];
               _Bool z = true;
               _Bool *pz = &p;
             #endif
           ]],
           [[
             bool ps = &s;
             *pp |= p;
             *pp |= ! p;

             #ifdef HAVE__BOOL
               _Bool pt = &t;
               *pz |= z;
               *pz |= ! z;
             #endif

             /* Refer to every declared value, so they cannot be
                discarded as unused.  */
             return (!a + !b + !c + !d + !e + !f + !g + !h + !i + !j + !k
                     + !l + !m + !n + !o + !p + !pp + !ps
             #ifdef HAVE__BOOL
                     + !q + !r + !u + !v + !w + !x + !y + !z + !pt
             #endif
                    );
           ]])],
        [ac_cv_header_stdbool_h=yes],
        [ac_cv_header_stdbool_h=no])])
])# AC_CHECK_HEADER_STDBOOL


# AC_HEADER_STDBOOL
# -----------------
# Define HAVE_STDBOOL_H if the system provides stdbool.h that conforms to C99.
AC_DEFUN([AC_HEADER_STDBOOL],
[AC_CHECK_HEADER_STDBOOL
if test $ac_cv_header_stdbool_h = yes; then
  AC_DEFINE(HAVE_STDBOOL_H, 1, [Define to 1 if stdbool.h conforms to C99.])
fi
])# AC_HEADER_STDBOOL


# AU::AC_HEADER_STDC
# ------------------
AU_DEFUN([AC_HEADER_STDC],
[# Autoupdate added the next two lines to ensure that your configure
# script's behavior did not change.  They are probably safe to remove.
AC_CHECK_INCLUDES_DEFAULT
AC_PROG_EGREP
],
 [The preprocessor macro `STDC_HEADERS' is obsolete.
  Except in unusual embedded environments, you can safely include all
  ISO C90 headers unconditionally.])

# AC_HEADER_SYS_WAIT
# ------------------
AC_DEFUN([AC_HEADER_SYS_WAIT],
[AC_CACHE_CHECK([for sys/wait.h that is POSIX.1 compatible],
  ac_cv_header_sys_wait_h,
[AC_COMPILE_IFELSE(
[AC_LANG_PROGRAM([#include <sys/types.h>
#include <sys/wait.h>
#ifndef WEXITSTATUS
# define WEXITSTATUS(stat_val) ((unsigned int) (stat_val) >> 8)
#endif
#ifndef WIFEXITED
# define WIFEXITED(stat_val) (((stat_val) & 255) == 0)
#endif
],
[  int s;
  wait (&s);
  s = WIFEXITED (s) ? WEXITSTATUS (s) : 1;])],
		 [ac_cv_header_sys_wait_h=yes],
		 [ac_cv_header_sys_wait_h=no])])
if test $ac_cv_header_sys_wait_h = yes; then
  AC_DEFINE(HAVE_SYS_WAIT_H, 1,
	    [Define to 1 if you have <sys/wait.h> that is POSIX.1 compatible.])
fi
])# AC_HEADER_SYS_WAIT


# AU::AC_HEADER_TIME
# ------------------
AU_DEFUN([AC_HEADER_TIME],
[AC_CHECK_HEADERS_ONCE([sys/time.h])
# Obsolete code to be removed.
if test $ac_cv_header_sys_time_h = yes; then
  AC_DEFINE(TIME_WITH_SYS_TIME, 1,
	    [Define to 1 if you can safely include both <sys/time.h>
	     and <time.h>.  This macro is obsolete.])
fi
# End of obsolete code.
], [Update your code to rely only on HAVE_SYS_TIME_H,
then remove this warning and the obsolete code below it.
All current systems provide time.h; it need not be checked for.
Not all systems provide sys/time.h, but those that do, all allow
you to include it and time.h simultaneously.])
# AC_HEADER_TIME


# _AC_HEADER_TIOCGWINSZ_IN_TERMIOS_H
# ----------------------------------
m4_define([_AC_HEADER_TIOCGWINSZ_IN_TERMIOS_H],
[AC_CACHE_CHECK([whether termios.h defines TIOCGWINSZ],
		ac_cv_sys_tiocgwinsz_in_termios_h,
[AC_EGREP_CPP([yes],
	      [#include <sys/types.h>
#include <termios.h>
#ifdef TIOCGWINSZ
  yes
#endif
],
		ac_cv_sys_tiocgwinsz_in_termios_h=yes,
		ac_cv_sys_tiocgwinsz_in_termios_h=no)])
])# _AC_HEADER_TIOCGWINSZ_IN_TERMIOS_H


# _AC_HEADER_TIOCGWINSZ_IN_SYS_IOCTL
# ----------------------------------
m4_define([_AC_HEADER_TIOCGWINSZ_IN_SYS_IOCTL],
[AC_CACHE_CHECK([whether sys/ioctl.h defines TIOCGWINSZ],
		ac_cv_sys_tiocgwinsz_in_sys_ioctl_h,
[AC_EGREP_CPP([yes],
	      [#include <sys/types.h>
#include <sys/ioctl.h>
#ifdef TIOCGWINSZ
  yes
#endif
],
		ac_cv_sys_tiocgwinsz_in_sys_ioctl_h=yes,
		ac_cv_sys_tiocgwinsz_in_sys_ioctl_h=no)])
])# _AC_HEADER_TIOCGWINSZ_IN_SYS_IOCTL


# AC_HEADER_TIOCGWINSZ
# --------------------
# Look for a header that defines TIOCGWINSZ.
# FIXME: Is this the proper name?  Is this the proper implementation?
# I need more help.
AC_DEFUN([AC_HEADER_TIOCGWINSZ],
[_AC_HEADER_TIOCGWINSZ_IN_TERMIOS_H
if test $ac_cv_sys_tiocgwinsz_in_termios_h != yes; then
  _AC_HEADER_TIOCGWINSZ_IN_SYS_IOCTL
  if test $ac_cv_sys_tiocgwinsz_in_sys_ioctl_h = yes; then
    AC_DEFINE(GWINSZ_IN_SYS_IOCTL,1,
	      [Define to 1 if `TIOCGWINSZ' requires <sys/ioctl.h>.])
  fi
fi
])# AC_HEADER_TIOCGWINSZ


# AU::AC_UNISTD_H
# ---------------
AU_DEFUN([AC_UNISTD_H],
[# Autoupdate added the following line to ensure that your configure
# script's behavior did not change.  It is probably safe to remove.
AC_CHECK_INCLUDES_DEFAULT])


# AU::AC_USG
# ----------
# Define `USG' if string functions are *not* in strings.h.
AU_DEFUN([AC_USG],
[# Obsolete code to be removed.
AC_MSG_CHECKING([for BSD string and memory functions])
AC_LINK_IFELSE([AC_LANG_PROGRAM([[@%:@include <strings.h>]],
				[[rindex("", 0); bzero(0, 0);]])],
	       [AC_MSG_RESULT(yes)],
	       [AC_MSG_RESULT(no)
		AC_DEFINE(USG, 1,
			  [Define to 1 if you do not have <strings.h>, index,
			   bzero, etc... This symbol is obsolete, you should
			   not depend upon it.])])
# End of obsolete code.
],
[Update your code to use string.h, then remove this
warning and the code below it. It is not necessary
to check for string.h.])


# AU::AC_MEMORY_H
# ---------------
# To be precise this macro used to be:
#
#   | AC_MSG_CHECKING(whether string.h declares mem functions)
#   | AC_EGREP_HEADER(memchr, string.h, ac_found=yes, ac_found=no)
#   | AC_MSG_RESULT($ac_found)
#   | if test $ac_found = no; then
#   |	AC_CHECK_HEADER(memory.h, [AC_DEFINE(NEED_MEMORY_H)])
#   | fi
#
# But it is better to check for both headers, and alias NEED_MEMORY_H to
# HAVE_MEMORY_H.
AU_DEFUN([AC_MEMORY_H],
[# Obsolete code to be removed.
AC_CHECK_HEADERS_ONCE([memory.h])
if test $ac_cv_header_memory_h = yes; then
   AC_DEFINE([NEED_MEMORY_H], [1],
             [Same as `HAVE_MEMORY_H', don't depend on me.])
fi
# End of obsolete code.
],
[Update your code to use string.h, then remove this
warning and the code below it.  It is not necessary
to check for string.h.])


# AU::AC_DIR_HEADER
# -----------------
# Like calling `AC_HEADER_DIRENT' and `AC_FUNC_CLOSEDIR_VOID', but
# defines a different set of C preprocessor macros to indicate which
# header file is found.
AU_DEFUN([AC_DIR_HEADER],
[AC_HEADER_DIRENT
AC_FUNC_CLOSEDIR_VOID
test ac_cv_header_dirent_dirent_h &&
  AC_DEFINE([DIRENT], 1, [Same as `HAVE_DIRENT_H', don't depend on me.])
test ac_cv_header_dirent_sys_ndir_h &&
  AC_DEFINE([SYSNDIR], 1, [Same as `HAVE_SYS_NDIR_H', don't depend on me.])
test ac_cv_header_dirent_sys_dir_h &&
  AC_DEFINE([SYSDIR], 1, [Same as `HAVE_SYS_DIR_H', don't depend on me.])
test ac_cv_header_dirent_ndir_h &&
  AC_DEFINE([NDIR], 1, [Same as `HAVE_NDIR_H', don't depend on me.])],
[Remove this warning and the four `AC_DEFINE' when you
adjust your code to use `AC_HEADER_DIRENT'.])
