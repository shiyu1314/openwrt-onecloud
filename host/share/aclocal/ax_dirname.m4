# ===========================================================================
#        https://www.gnu.org/software/autoconf-archive/ax_dirname.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_DIRNAME(PATHNAME)
#
# DESCRIPTION
#
#   Parts of the implementation have been taken from AS_DIRNAME from the
#   main autoconf package in generation 2.5x. However, we do only use "sed"
#   to cut out the dirname, and we do additionally clean up some dir/..
#   parts in the resulting pattern.
#
#   this macro may be used in autoconf 2.13 scripts as well.
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

AC_DEFUN([AX_DIRNAME],
[echo X[]$1 |
    sed ['s/\/[^\/:][^\/:]*\/..\//\//g
          s/\/[^\/:][^\/:]*\/..\//\//g
          s/\/[^\/:][^\/:]*\/..\//\//g
          s/\/[^\/:][^\/:]*\/..\//\//g
          /^X\(.*[^/]\)\/\/*[^/][^/]*\/*$/{ s//\1/; q; }
          /^X\(\/\/\)[^/].*/{ s//\1/; q; }
          /^X\(\/\/\)$/{ s//\1/; q; }
          /^X\(\/\).*/{ s//\1/; q; }
          s/.*/./; q']])
