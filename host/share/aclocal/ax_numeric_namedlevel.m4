# ===========================================================================
#  https://www.gnu.org/software/autoconf-archive/ax_numeric_namedlevel.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_NUMERIC_NAMEDLEVEL(VARNAME [,FROMVAR [,DEFAULT [,YESLEVEL]]])
#
# DESCRIPTION
#
#   The levelstring FROMVAR is expanded and checked for verbal names that
#   will map on to eight different levels - the VARNAME will receive this
#   numeric level where "all" maps to 7 (lower three bits set) higher levels
#   for 8 and 9 exist too. This macro is a nice helper to convert user input
#   of a --with-opt=level into a numeric form that can be simply pushed as a
#   #define like with AC_DEFINE:
#
#    default YESLEVEL = 2 /* including unknown levelspec */
#    default DEFAULT  = 0 /* when named level is empty */
#    default FROMVAR  = VARNAME
#
#   The DEFAULT value is used if the NAMED levelstring has become empty and
#   it is copied without further conversion - a default of "0" is used if
#   absent - identical to "no". A "yes" will be set to the YESLEVEL - and
#   note that "yes" has "2" as its default value not "1". (which comes from
#   its original use to set a "gcc -O2").
#
#   the mnemonic names are:
#
#     9| insane |ultrasome|experimentalplus
#     8| ultra  |ultra|experimental)
#     7| all    |muchmore|somemanymore|manymoreplus
#     6| most   |manymore|most)
#     5| strict |somemore|almost
#     4| more   |more
#     3| extra  |manyplus|plusmuch|somemany|plusmany
#     2| many   |many|much|(yes)
#     1| some   |some|plus
#
#   note that a level can be constructed of (some|plus) = bit-0, (many|much)
#   = bit-1, (more) = bit-2, (ultra|experimental) = bit-3 at least in a
#   left-to-right order, ie. plusmanymore=7
#
#   Example usage:
#
#     AX_NUMERIC_NAMEDLEVEL(OPTLEVEL,with_optlevel,1,3)
#     AC_DEFINE(OPTLEVEL)
#     test "$GCC" = "yes" && CFLAGS="$CFLAGS -O$OPTLEVEL)
#
# LICENSE
#
#   Copyright (c) 2008 Guido U. Draheim <guidod@gmx.de>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.  This file is offered as-is, without any
#   warranty.

#serial 12

AU_ALIAS([AC_NUMERIC_NAMEDLEVEL], [AX_NUMERIC_NAMEDLEVEL])
AC_DEFUN([AX_NUMERIC_NAMEDLEVEL],
[dnl the names to be defined...
$1="ifelse($1,,[$]$2,[$]$1)" ; $1="[$]$1"
$1="[$]$1" ; $1="[$]$1"
if test "_[$]$1" = "_" ; then
  $1="ifelse([$3],,0,[$3])"
elif test "_[$]$1" = "_yes" ; then
  $1="ifelse([$4],,2,[$4])"
else
  $1=`echo [$]$1 | sed -e 's,some,plus,' -e 's,experimental,ultra,' -e 's,over,ultra,' -e 's,much,many,'`
  case "[$]$1" in
    0*|1*|2*|3*|4*|5*|6*|7*|8*|9*|-*|+*) ;;   # leave as is
    insane|ultraplus|plusultra)                 $1="9" ;;
    ultra)                                      $1="8" ;;
    manymoreplus|manyplusmore|plusmanymore|all) $1="7" ;;
    moremanyplus|moreplusmany|plusmoremany)     $1="7" ;;
    manymore|moremany|most)                     $1="6" ;;
    somemore|moresome|almost)                   $1="5" ;;
    more)                                       $1="4" ;;
    manyplus|plusmany|extra)                    $1="3" ;;
    many)                                       $1="2" ;;
    plus)                                       $1="1" ;;
    no)                                         $1="0" ;;
    yes) $1="ifelse([$4],,2,[$4])" ;;
    *)   $1="ifelse([$3],,1,[$3])" ;; # for other unknown stuff.
  esac
fi
])
