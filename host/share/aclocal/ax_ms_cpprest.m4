# ===========================================================================
#      https://www.gnu.org/software/autoconf-archive/ax_ms_cpprest.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_MS_CPPREST([MINIMUM-VERSION], [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
#
# DESCRIPTION
#
#   Test for the Microsoft C++ Rest SDK library of a particular version (or
#   newer)
#
#   If no path to the installed cpprest library is given the macro searchs
#   under /usr, /usr/local, /opt and /opt/local and evaluates the
#   $CPPREST_ROOT environment variable.
#
#   This macro calls:
#
#     AC_SUBST(cpprest_CPPFLAGS) / AC_SUBST(cpprest_LDFLAGS) /
#     AC_SUBST(cpprest_LIBS)
#
#   And sets:
#
#     HAVE_MS_CPPREST
#
# LICENSE
#
#   Copyright (c) 2008 Thomas Porschberg <thomas@randspringer.de>
#   Copyright (c) 2009 Peter Adolphs
#   Copyright (c) 2021 Richard Winters <kirvedx@gmail.com>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved. This file is offered as-is, without any
#   warranty.

#serial 2

dnl This supporting method tests for the correct Microsoft C++ Rest SDK
dnl version by comparing the converted version string value as received
dnl against the version value present in the version header.
m4_define([_AX_MS_CPPREST_PROGRAM], [AC_LANG_PROGRAM([[
#include <cpprest/version.h>
]],[[
(void) ((void)sizeof(char[1 - 2*!!((CPPREST_VERSION) < ($1))]));
]])])

dnl The primary method for our macro, Microsoft uses Boost libraries,
dnl and ironically its implementation follows similar rules such that
dnl the AX_BOOST_BASE macro is able to serve as the framework for this
dnl one.
dnl
dnl This method establishes help strings, declares our macros flags,
dnl and initiates a check for the SDK.
AC_DEFUN([AX_MS_CPPREST], [
	AC_ARG_WITH([cpprest], [
		AS_HELP_STRING([--with-cpprest@<:@=ARG@:>@],
            [use the Microsoft C++ Rest SDK library from a standard location (ARG=yes),
            from the specified location (ARG=<path>),
            or disable it (ARG=no)
            @<:@ARG=yes@:>@ ])
        ],
		[
			AS_CASE([$withval],
                [no],[want_cpprest="no";_AX_MS_CPPREST_cpprest_path=""],
                [yes],[want_cpprest="yes";_AX_MS_CPPREST_cpprest_path=""],
                [want_cpprest="yes";_AX_MS_CPPREST_cpprest_path="$withval"]
			)
        ],
		[want_cpprest="yes"]
	)

	AC_ARG_WITH([cpprest-libdir], [
		AS_HELP_STRING([--with-cpprest-libdir=LIB_DIR],
            [Force given directory for cpprest library.
            Note that this will override library path detection,
            so use this parameter only if default library detection fails
            and you know exactly where your cpprest library is located.]
        )],
		[
		AS_IF([test -d "$withval"], [
			_AX_MS_CPPREST_cpprest_lib_path="$withval"],
            [AC_MSG_ERROR([--with-cpprest-libdir expected directory name])]
        )],
		[_AX_MS_CPPREST_cpprest_lib_path=""]
	)

	cpprest_LDFLAGS=""
	cpprest_CPPFLAGS=""
	cpprest_LIBS=""
	AS_IF([test "x$want_cpprest" = "xyes"], [_AX_MS_CPPREST_RUNDETECT([$1],[$2],[$3])])
	AC_SUBST(cpprest_CPPFLAGS)
	AC_SUBST(cpprest_LDFLAGS)
	AC_SUBST(cpprest_LIBS)
])

dnl This supporting method is called by our _RUNDETECT method and it
dnl converts the required version string stored in $2 to a number by the
dnl rules present in the version header for the SDK and stores the
dnl number in polymorphic var $1
AC_DEFUN([_AX_MS_CPPREST_TONUMERICVERSION], [
	AS_IF([test "x$2" = "x"],
		[_AX_MS_CPPREST_TONUMERICVERSION_req="1.0.0"],
		[_AX_MS_CPPREST_TONUMERICVERSION_req="$2"]
	)
	_AX_MS_CPPREST_TONUMERICVERSION_req_shorten=`expr $_AX_MS_CPPREST_TONUMERICVERSION_req : '\([[0-9]]*\.[[0-9]]*\)'`
	_AX_MS_CPPREST_TONUMERICVERSION_req_major=`expr $_AX_MS_CPPREST_TONUMERICVERSION_req : '\([[0-9]]*\)'`
	AS_IF([test "x$_AX_MS_CPPREST_TONUMERICVERSION_req_major" = "x"],
		[AC_MSG_ERROR([You should at least specify libcpprest major version])]
	)
	_AX_MS_CPPREST_TONUMERICVERSION_req_minor=`expr $_AX_MS_CPPREST_TONUMERICVERSION_req : '[[0-9]]*\.\([[0-9]]*\)'`
	AS_IF([test "x$_AX_MS_CPPREST_TONUMERICVERSION_req_minor" = "x"],
		[_AX_MS_CPPREST_TONUMERICVERSION_req_minor="0"]
	)
	_AX_MS_CPPREST_TONUMERICVERSION_req_sub_minor=`expr $_AX_MS_CPPREST_TONUMERICVERSION_req : '[[0-9]]*\.[[0-9]]*\.\([[0-9]]*\)'`
	AS_IF([test "X$_AX_MS_CPPREST_TONUMERICVERSION_req_sub_minor" = "X"],
		[_AX_MS_CPPREST_TONUMERICVERSION_req_sub_minor="0"]
	)
	_AX_MS_CPPREST_TONUMERICVERSION_RET=`expr $_AX_MS_CPPREST_TONUMERICVERSION_req_major \* 100000 \+  $_AX_MS_CPPREST_TONUMERICVERSION_req_minor \* 100 \+ $_AX_MS_CPPREST_TONUMERICVERSION_req_sub_minor`
	AS_VAR_SET($1,$_AX_MS_CPPREST_TONUMERICVERSION_RET)
])

dnl This supporting method is called by the primary method and it seeks
dnl the Microsoft C++ Rest SDK's location, and if found proceeds to
dnl check that its version meets requirements - if provided - before
dnl setting required FLAGS (CPP, LD) and LIBS (cpprest).
dnl
dnl Depending on circumstances it reports to the caller necessary
dnl information.
AC_DEFUN([_AX_MS_CPPREST_RUNDETECT], [
	_AX_MS_CPPREST_TONUMERICVERSION(WANT_CPPREST_VERSION,[$1])
	succeeded=no

	AC_REQUIRE([AC_CANONICAL_HOST])
	dnl On 64-bit systems check for system libraries in both lib64 and lib.
	dnl The former is specified by FHS, but e.g. Debian does not adhere to
	dnl this (as it rises problems for generic multi-arch support).
	dnl The last entry in the list is chosen by default when no libraries
	dnl are found, e.g. when only header-only libraries are installed!
	AS_CASE([${host_cpu}],
		[x86_64],[libsubdirs="lib64 libx32 lib lib64"],
		[mips*64*],[libsubdirs="lib64 lib32 lib lib64"],
		[ppc64|powerpc64|s390x|sparc64|aarch64|ppc64le|powerpc64le|riscv64|e2k|loongarch64],[libsubdirs="lib64 lib lib64"],
		[libsubdirs="lib"]
	)

	dnl allow for real multi-arch paths e.g. /usr/lib/x86_64-linux-gnu. Give
	dnl them priority over the other paths since, if libs are found there, they
	dnl are almost assuredly the ones desired.
	AS_CASE([${host_cpu}],
		[i?86],[multiarch_libsubdir="lib/i386-${host_os}"],
		[armv7l],[multiarch_libsubdir="lib/arm-${host_os}"],
		[multiarch_libsubdir="lib/${host_cpu}-${host_os}"]
	)

    dnl first we check the system location for the cpprest library
    dnl this location is chosen if the cpprest library is installed with the --layout=system option
    dnl or if you install cpprest with RPM
	AS_IF([test "x$_AX_MS_CPPREST_cpprest_path" != "x"], [
		AC_MSG_CHECKING([for cpprestlib >= $1 ($WANT_CPPREST_VERSION) includes in "$_AX_MS_CPPREST_cpprest_path/include"])
		AS_IF([test -d "$_AX_MS_CPPREST_cpprest_path/include" && test -r "$_AX_MS_CPPREST_cpprest_path/include"], [
			AC_MSG_RESULT([yes])
				cpprest_CPPFLAGS="-I$_AX_MS_CPPREST_cpprest_path/include"
				for _AX_MS_CPPREST_cpprest_path_tmp in $multiarch_libsubdir $libsubdirs; do
					AC_MSG_CHECKING([for cpprestlib >= $1 ($WANT_CPPREST_VERSION) lib path in "$_AX_MS_CPPREST_cpprest_path/$_AX_MS_CPPREST_cpprest_path_tmp"])
					AS_IF([test -d "$_AX_MS_CPPREST_cpprest_path/$_AX_MS_CPPREST_cpprest_path_tmp" && test -r "$_AX_MS_CPPREST_cpprest_path/$_AX_MS_CPPREST_cpprest_path_tmp" ], [
						AC_MSG_RESULT([yes])
						cpprest_LDFLAGS="-L$_AX_MS_CPPREST_cpprest_path/$_AX_MS_CPPREST_cpprest_path_tmp";
						break;
					],
					[AC_MSG_RESULT([no])])
		done], [
			AC_MSG_RESULT([no])
		])
	], [
		if test X"$cross_compiling" = Xyes; then
			search_libsubdirs=$multiarch_libsubdir
		else
			search_libsubdirs="$multiarch_libsubdir $libsubdirs"
		fi
		for _AX_MS_CPPREST_cpprest_path_tmp in /usr /usr/local /opt /opt/local ; do
			if test -d "$_AX_MS_CPPREST_cpprest_path_tmp/include/cpprest" && test -r "$_AX_MS_CPPREST_cpprest_path_tmp/include/cpprest" ; then
				for libsubdir in $search_libsubdirs ; do
					if ls "$_AX_MS_CPPREST_cpprest_path_tmp/$libsubdir/libcpprest_"* >/dev/null 2>&1 ; then break; fi
				done
				cpprest_LDFLAGS="-L$_AX_MS_CPPREST_cpprest_path_tmp/$libsubdir"
				cpprest_CPPFLAGS="-I$_AX_MS_CPPREST_cpprest_path_tmp/include"
				break;
			fi
		done
		]
	)

    dnl overwrite ld flags if we have required special directory with
    dnl --with-cpprest-libdir parameter
	AS_IF([test "x$_AX_MS_CPPREST_cpprest_lib_path" != "x"],
          [cpprest_LDFLAGS="-L$_AX_MS_CPPREST_cpprest_lib_path"]
	)

	AC_MSG_CHECKING([for cpprestlib >= $1 ($WANT_CPPREST_VERSION)])
	CPPFLAGS_SAVED="$CPPFLAGS"
	CPPFLAGS="$CPPFLAGS $cpprest_CPPFLAGS"
	export CPPFLAGS

	LDFLAGS_SAVED="$LDFLAGS"
	LDFLAGS="$LDFLAGS $cpprest_LDFLAGS"
	export LDFLAGS

	AC_REQUIRE([AC_PROG_CXX])
	AC_LANG_PUSH(C++)
	AC_COMPILE_IFELSE([_AX_MS_CPPREST_PROGRAM($WANT_CPPREST_VERSION)],[
			AC_MSG_RESULT(yes)
			succeeded=yes
			found_system=yes
		], []
	)
	AC_LANG_POP([C++])

    dnl if we found no cpprest with system layout we search for the cpprest library
    dnl built and installed without the --layout=system option or for a staged(not installed) version
	if test "x$succeeded" != "xyes" ; then
		CPPFLAGS="$CPPFLAGS_SAVED"
		LDFLAGS="$LDFLAGS_SAVED"
		cpprest_CPPFLAGS=
		if test -z "$_AX_MS_CPPREST_cpprest_lib_path" ; then
			cpprest_LDFLAGS=
		fi
		_version=0
		if test -n "$_AX_MS_CPPREST_cpprest_path" ; then
			if test -d "$_AX_MS_CPPREST_cpprest_path" && test -r "$_AX_MS_CPPREST_cpprest_path"; then
				for i in `ls -d $_AX_MS_CPPREST_cpprest_path/include/cpprest-* 2>/dev/null`; do
					_version_tmp=`echo $i | sed "s#$_AX_MS_CPPREST_cpprest_path##" | sed 's/\/include\/cpprest-//' | sed 's/_/./'`
					V_CHECK=`expr $_version_tmp \> $_version`
					if test "x$V_CHECK" = "x1" ; then
						_version=$_version_tmp
					fi
					VERSION_UNDERSCORE=`echo $_version | sed 's/\./_/'`
					cpprest_CPPFLAGS="-I$_AX_MS_CPPREST_cpprest_path/include/cpprest-$VERSION_UNDERSCORE"
				done
                dnl if nothing found search for layout used in Windows distributions
				if test -z "$cpprest_CPPFLAGS"; then
					if test -d "$_AX_MS_CPPREST_cpprest_path/cpprest" && test -r "$_AX_MS_CPPREST_cpprest_path/cpprest"; then
						cpprest_CPPFLAGS="-I$_AX_MS_CPPREST_cpprest_path"
					fi
				fi
                dnl if we found something and cpprest_LDFLAGS was unset before
                dnl (because "$_AX_MS_CPPREST_cpprest_lib_path" = ""), set it here.
				if test -n "$cpprest_CPPFLAGS" && test -z "$cpprest_LDFLAGS"; then
					for libsubdir in $libsubdirs ; do
						if ls "$_AX_MS_CPPREST_cpprest_path/$libsubdir/libcpprest_"* >/dev/null 2>&1 ; then break; fi
					done
					cpprest_LDFLAGS="-L$_AX_MS_CPPREST_cpprest_path/$libsubdir"
				fi
			fi
		else
			if test "x$cross_compiling" != "xyes" ; then
				for _AX_MS_CPPREST_cpprest_path in /usr /usr/local /opt /opt/local ; do
					if test -d "$_AX_MS_CPPREST_cpprest_path" && test -r "$_AX_MS_CPPREST_cpprest_path" ; then
						for i in `ls -d $_AX_MS_CPPREST_cpprest_path/include/cpprest-* 2>/dev/null`; do
							_version_tmp=`echo $i | sed "s#$_AX_MS_CPPREST_cpprest_path##" | sed 's/\/include\/cpprest-//' | sed 's/_/./'`
							V_CHECK=`expr $_version_tmp \> $_version`
							if test "x$V_CHECK" = "x1" ; then
								_version=$_version_tmp
								best_path=$_AX_MS_CPPREST_cpprest_path
							fi
						done
					fi
				done

				VERSION_UNDERSCORE=`echo $_version | sed 's/\./_/'`
				cpprest_CPPFLAGS="-I$best_path/include/cpprest-$VERSION_UNDERSCORE"
				if test -z "$_AX_MS_CPPREST_cpprest_lib_path" ; then
					for libsubdir in $libsubdirs ; do
						if ls "$best_path/$libsubdir/libcpprest_"* >/dev/null 2>&1 ; then break; fi
					done
					cpprest_LDFLAGS="-L$best_path/$libsubdir"
				fi
			fi

			if test -n "$CPPREST_ROOT" ; then
				for libsubdir in $libsubdirs ; do
					if ls "$CPPREST_ROOT/stage/$libsubdir/libcpprest_"* >/dev/null 2>&1 ; then break; fi
				done
				if test -d "$CPPREST_ROOT" && test -r "$CPPREST_ROOT" && test -d "$CPPREST_ROOT/stage/$libsubdir" && test -r "$CPPREST_ROOT/stage/$libsubdir"; then
					version_dir=`expr //$CPPREST_ROOT : '.*/\(.*\)'`
					stage_version=`echo $version_dir | sed 's/cpprest_//' | sed 's/_/./g'`
					stage_version_shorten=`expr $stage_version : '\([[0-9]]*\.[[0-9]]*\)'`
					V_CHECK=`expr $stage_version_shorten \>\= $_version`
					if test "x$V_CHECK" = "x1" && test -z "$_AX_MS_CPPREST_cpprest_lib_path" ; then
						AC_MSG_NOTICE(We will use a staged cpprest library from $CPPREST_ROOT)
						cpprest_CPPFLAGS="-I$CPPREST_ROOT"
						cpprest_LDFLAGS="-L$CPPREST_ROOT/stage/$libsubdir"
					fi
				fi
			fi
		fi

		CPPFLAGS="$CPPFLAGS $cpprest_CPPFLAGS"
		export CPPFLAGS
		LDFLAGS="$LDFLAGS $cpprest_LDFLAGS"
		export LDFLAGS

		AC_LANG_PUSH(C++)
		AC_COMPILE_IFELSE([_AX_MS_CPPREST_PROGRAM($WANT_CPPREST_VERSION)], [
				AC_MSG_RESULT(yes)
				succeeded=yes
				found_system=yes
			], []
		)
		AC_LANG_POP([C++])
	fi

	if test "x$succeeded" != "xyes" ; then
		if test "x$_version" = "x0" ; then
			AC_MSG_NOTICE([[We could not detect the Microsoft C++ Rest SDK library (version $1 or higher). If you have a staged cpprest library (still not installed) please specify \$CPPREST_ROOT in your environment and do not give a PATH to --with-cpprest option.  If you are sure you have cpprest installed, then check your version number looking in <cpprest/version.hpp>.]])
		else
			AC_MSG_NOTICE([Your cpprest library seems too old (version $_version).])
		fi
		# execute ACTION-IF-NOT-FOUND (if present):
		ifelse([$3], , :, [$3])
	else
		AC_DEFINE(HAVE_MS_CPPREST,,[define if the Microsoft C++ Rest SDK library is available])
		cpprest_LIBS="-lcpprest"
		# execute ACTION-IF-FOUND (if present):
		ifelse([$2], , :, [$2])
	fi

	CPPFLAGS="$CPPFLAGS_SAVED"
	LDFLAGS="$LDFLAGS_SAVED"
])
