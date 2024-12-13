# =======================================================================================
#  https://www.gnu.org/software/autoconf-archive/ax_patch_libtool_changing_cmds_ifs.html
# =======================================================================================
#
# SYNOPSIS
#
#   AX_PATCH_LIBTOOL_CHANGING_CMDS_IFS
#
# DESCRIPTION
#
#   Do a `grep "^[a-z]*_cmds=" libtool` - these are "subroutines" encoded by
#   libtool.m4 into the generated libtool script. Since libtool assumes that
#   there is no subroutine-facility in the shell invoked, these are not
#   actually subroutines, but actually a "list of commands". This looks
#   correct, but the command separator is not ";" - it is "~", the tilde
#   character.
#
#   Now, grep again, look for `grep 'IFS="~"' libtool` and see that libtool
#   scripting uses a for-loop on the command-list, i.e for cmd in
#   $some_cmds. This works correctly when the IFS was modified, where IFS
#   stands for "input field separator" which is whitespace characters by
#   default.
#
#   The problem: I have some real-world filesystems where there are
#   directories using "~" inside of them, to be more to the point, it is a
#   change control management software that uses source repositories of the
#   form "path/master/project~version/src" and libtool has the tendency to
#   resolve any symlinks so that it will paste such path into the $_cmds
#   script when it gets evaluated a number of times.
#
#   This script is a workaround: I do not know why the ";" was not chosen as
#   the IFS, perhaps it has some weird interactions in some shells since it
#   is also the default record separator being one time bigger in context
#   than the argument separator. I have made good success however with using
#   "?" as the IFS, since there is no path-name that uses a question mark,
#   and there is no _cmds ever around that uses "?" for some thing.
#
#   Oh yes, there are some usages of "*" to match shell-wise at the output
#   file of some tool, so that might have triggered the choice to not use
#   "?" in the first place - but in real life it never occurred that a _cmds
#   script was created that has gone to use "?". And so, this ac-macro
#   exchanges the s/~/?/g in configured _cmds variables and replaces all
#   occurrences of s/IFS="~"/IFS="?"/ - and it all works smooth now.
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

AU_ALIAS([PATCH_LIBTOOL_CHANGING_CMDS_IFS], [AX_PATCH_LIBTOOL_CHANGING_CMDS_IFS])
AC_DEFUN([AX_PATCH_LIBTOOL_CHANGING_CMDS_IFS],
[# patch libtool to change $_cmds IFS from ~ to ? character
if grep "^[[_$as_cr_letters]]_cmds=.*[[?]]" libtool >/dev/null; then
  AC_MSG_WARN(dnl
  [patching libtool skipped - _cmds already contain question marks])
else
 AC_MSG_RESULT([patching libtool to change cmds IFS from ~ to ?])
    test -f libtool.old || (mv libtool libtool.old && cp libtool.old libtool)
    sed -e "/^[[_$as_cr_letters]]*_cmds=/s/~/?/g" -e 's/IFS="~"/IFS="?"/g' \
        -e "s/IFS='~'/IFS='?'/g"    libtool > libtool.new
    (test -s libtool.new || rm libtool.new) 2>/dev/null
    test -f libtool.new && mv libtool.new libtool # not 2>/dev/null !!
    test -f libtool     || mv libtool.old libtool
fi
])
