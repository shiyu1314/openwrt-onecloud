#  -*- Perl -*-
# Copyright (C) 2003-2021 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

package Autom4te::Config;

# This is a stub version of Automake/Config.pm.
# It defines only the variables that are necessary in order to fetch
# Autom4te/ChannelDefs.pm from Automake/ChannelDefs.pm
# (see build-aux/fetch.pl).
# We would like to fetch Automake/Config.pm as well,
# but that file is generated when automake is built,
# and autoconf's build machinery is not prepared to do that.
# Revisit after 2.70.

use 5.006;
use strict;
use warnings FATAL => 'all';

use Exporter;

our @ISA = qw (Exporter);
our @EXPORT = qw ($PACKAGE_BUGREPORT $perl_threads);

# this must be kept in sync with configure.ac
our $PACKAGE_BUGREPORT = 'bug-autoconf@gnu.org';

# autom4te currently has no use for threads
our $perl_threads = 0;

1;
