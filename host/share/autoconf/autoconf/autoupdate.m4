# This file is part of Autoconf.                       -*- Autoconf -*-
# Interface with autoupdate.

# Copyright (C) 1992-1996, 1998-2001, 2003-2004, 2006, 2009-2017,
# 2020-2021 Free Software Foundation, Inc.

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


## ---------------------------------- ##
## Macros to define obsolete macros.  ##
## ---------------------------------- ##


# AU_DEFINE(NAME, CODE)
# ---------------------
# Define the macro NAME so that it expands to CODE only when
# autoupdate is running.  This is achieved with traces in
# autoupdate itself, so this macro expands to nothing.
#
m4_define([AU_DEFINE], [])

# AU_DEFUN(NAME, NEW-CODE, [MESSAGE], [SILENT])
# -----------------------------------
# Define NAME as a macro whose expansion is NEW-CODE, just like
# AC_DEFUN, but also declare NAME as obsolete.  When autoupdate
# is run, occurrences of NAME will be replaced with NEW-CODE in
# the updated configure.ac.
#
# If MESSAGE is not empty, it should be instructions for manual edits
# to configure.ac that are required to finish the job of replacing NAME.
# autoupdate will print MESSAGE, and [m4_warn([obsolete], [MESSAGE])]
# will be placed next to NEW-CODE in the updated configure.ac.
#
# SILENT must be either empty or the word "silent".  If it is empty,
# *autoconf* will issue a generic obsolete-category warning when NAME
# is expanded, telling the maintainer to run autoupdate.
#
# This allows sharing the same code for both supporting obsoleted macros,
# and to update a configure.ac.
# See the end of `autoupdate.in' for a longer description.
m4_define([AU_DEFUN],
[# This is what autoupdate's m4 run will expand.  It fires the warning
# (with _au_warn_XXX), outputs it into the updated configure.ac (with
# m4_warn), and then outputs the replacement expansion.  We need extra
# quotation around the m4_warn and dnl so they will be written
# unexpanded into the updated configure.ac.
AU_DEFINE([$1],
[m4_ifval([$3], [_au_warn_$1([$3])[m4_warn([obsolete],
[$3])dnl
]])dnl
$2])

# This is an auxiliary macro that is also run when
# autoupdate runs m4.  It simply calls m4_warning, but
# we need a wrapper so that each warning is emitted only
# once.  We break the quoting in m4_warning's argument in
# order to expand this macro's arguments, not AU_DEFUN's.
AU_DEFINE([_au_warn_$1],
[m4_warning($][@)dnl
m4_define([_au_warn_$1], [])])

# Finally, this is the expansion that is picked up by
# autoconf, causing NAME to expand to NEW-CODE, plus
# (if SILENT is not "silent") a m4_warning telling the
# maintainer to run autoupdate.  We don't issue MESSAGE
# from autoconf, because that's instructions for what
# to do *after* running autoupdate.
m4_case([$4],
  [silent], [AC_DEFUN([$1], [$2])],
  [],       [AC_DEFUN([$1],
	 [m4_warn([obsolete], [The macro `$1' is obsolete.
You should run autoupdate.])dnl
$2])],
  [m4_fatal([SILENT argument to `$0' must be either empty or `silent'])]dnl
)])


# AU_ALIAS(OLD-NAME, NEW-NAME, [SILENT])
# ----------------------------
# The OLD-NAME is no longer used, just use NEW-NAME instead.  There is
# little difference with using AU_DEFUN but the fact there is little
# interest in running the test suite on both OLD-NAME and NEW-NAME.
# This macro makes it possible to distinguish such cases.
# The SILENT argument works the same as for AU_DEFUN.
#
# Do not use `defn' since then autoupdate would replace an old macro
# call with the new macro body instead of the new macro call.
#
# Moreover, we have to take care that calls without parameters are
# expanded to calls without parameters, not with one empty parameter.
# This is not only an aesthetic improvement of autoupdate, it also
# matters with poorly written macros which test for $# = 0.
#
m4_define([AU_ALIAS],
[AU_DEFUN([$1], _AU_ALIAS_BODY([$], [$2]), [], [$4])])

# The body for the AU_DEFUN above should look like:
#	[m4_if($#, 0, [NEW-NAME], [NEW-NAME($@)])]
# Thus the helper macro is:
m4_define([_AU_ALIAS_BODY], [[m4_if($1#, 0, [$2], [$2($1@)])]])
