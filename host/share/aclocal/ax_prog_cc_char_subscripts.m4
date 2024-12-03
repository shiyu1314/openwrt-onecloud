# ===============================================================================
#  https://www.gnu.org/software/autoconf-archive/ax_prog_cc_char_subscripts.html
# ===============================================================================
#
# SYNOPSIS
#
#   AX_PROG_CC_CHAR_SUBSCRIPTS(substvar [,hard])
#
# DESCRIPTION
#
#   Try to find a compiler option that enables usage of char-type to index a
#   value-field. This one needs unsigned-chars and it must suppress warnings
#   about usage of chars for subscripting. for gcc -funsigned-char
#   -Wno-char-subscripts
#
#   Currently this macro knows about GCC. hopefully will evolve to use:
#   Solaris C compiler, Digital Unix C compiler, C for AIX Compiler, HP-UX C
#   compiler, and IRIX C compiler.
#
# LICENSE
#
#   Copyright (c) 2008 Guido U. Draheim <guidod@gmx.de>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.  This file is offered as-is, without any
#   warranty.

#serial 9

AU_ALIAS([AC_PROG_CC_CHAR_SUBSCRIPTS], [AX_PROG_CC_CHAR_SUBSCRIPTS])
AC_DEFUN([AX_PROG_CC_CHAR_SUBSCRIPTS], [
  pushdef([CV],ac_cv_prog_cc_char_subscripts)dnl
  hard=$2
  if test -z "$hard"; then
    msg="C to enable char subscripts"
  else
    msg="C to ensure char subscripts"
  fi
  AC_CACHE_CHECK($msg, CV, [
  cat > conftest.c <<EOF
int main (void)
{
   char v = 1;
   int x[[2]] = { 3 , 4 };
   return x[[v]];
}
EOF
  cp conftest.c writetest.c
  dnl GCC
  if test "$GCC" = "yes";
  then
	if test -z "$hard"; then
	   CV="-funsigned-char -Wno-char-subscripts"
	else
	   CV="-funsigned-char -Wno-char-subscripts"
	fi

	if test -n "`${CC-cc} -c $CV conftest.c 2>&1`" ; then
           CV="suppressed: did not work"
	fi

  dnl Solaris C compiler
	# Solaris sunpro has no option for unsignedchar but
	# signedchar is the default for char. Duhh.

  dnl HP-UX C compiler

  dnl Digital Unix C compiler
  elif ! $CC > /dev/null 2>&1 &&
	$CC -c -unsigned conftest.c > /dev/null 2>&1 &&
	test -f conftest.o
  then
	# char :  unsigned char
	CV="-unsigned"

	rm conftest.o
	if test -n "`${CC-cc} -c $CV conftest.c 2>&1`" ; then
           CV="suppressed: did not work"
	fi

  dnl C for AIX Compiler

  dnl IRIX C compiler
	# char is unsigned by default for IRIX C.

  fi
  rm -f conftest.*
  ])
  if test -z "[$]$1" ; then
    if test -n "$CV" ; then
      case "$CV" in
        suppressed*) $1="" ;; # known but suppressed
        *)  $1="$CV" ;;
      esac
    fi
  fi
  AC_SUBST($1)
  popdef([CV])dnl
])
