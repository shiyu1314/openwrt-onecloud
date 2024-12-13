# Copyright (C) 2002-2021 Free Software Foundation, Inc.

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

package Automake::ChannelDefs;

=head1 NAME

Automake::ChannelDefs - channel definitions for Automake and helper functions

=head1 SYNOPSIS

  use Automake::ChannelDefs;

  print Automake::ChannelDefs::usage (), "\n";
  prog_error ($MESSAGE, [%OPTIONS]);
  error ($WHERE, $MESSAGE, [%OPTIONS]);
  error ($MESSAGE);
  fatal ($WHERE, $MESSAGE, [%OPTIONS]);
  fatal ($MESSAGE);
  verb ($MESSAGE, [%OPTIONS]);
  switch_warning ($CATEGORY);
  parse_WARNINGS ();
  parse_warnings ($OPTION, @ARGUMENT);
  Automake::ChannelDefs::set_strictness ($STRICTNESS_NAME);

=head1 DESCRIPTION

This package defines channels that can be used in Automake to
output diagnostics and other messages (via C<msg()>).  It also defines
some helper function to enable or disable these channels, and some
shorthand function to output on specific channels.

=cut

use 5.006;
use strict;
use warnings FATAL => 'all';

use Exporter;

use Automake::Channels;
use Automake::Config;
BEGIN
{
  if ($perl_threads)
    {
      require threads;
      import threads;
    }
}

our @ISA = qw (Exporter);
our @EXPORT = qw (&prog_error &error &fatal &verb
		  &switch_warning &parse_WARNINGS &parse_warnings
		  &merge_WARNINGS);

=head2 CHANNELS

The following channels can be used as the first argument of
C<Automake::Channel::msg>.  For some of them we list a shorthand
function that makes the code more readable.

=over 4

=item C<fatal>

Fatal errors.  Use C<&fatal> to send messages over this channel.

=item C<error>

Common errors.  Use C<&error> to send messages over this channel.

=item C<error-gnu>

Errors related to GNU Standards.

=item C<error-gnu/warn>

Errors related to GNU Standards that should be warnings in 'foreign' mode.

=item C<error-gnits>

Errors related to GNITS Standards (silent by default).

=item C<automake>

Internal errors.  Use C<&prog_error> to send messages over this channel.

=item C<cross>

Constructs compromising the cross-compilation of the package.

=item C<gnu>

Warnings related to GNU Coding Standards.

=item C<obsolete>

Warnings about obsolete features.

=item C<override>

Warnings about user redefinitions of Automake rules or
variables (silent by default).

=item C<portability>

Warnings about non-portable constructs.

=item C<portability-recursive>

Warnings about recursive variable expansions (C<$(foo$(x))>).
These are not universally supported, but are more portable than
the other non-portable constructs diagnosed by C<-Wportability>.
These warnings are turned on by C<-Wportability> but can then be
turned off separately by C<-Wno-portability-recursive>.

=item C<extra-portability>

Extra warnings about non-portable constructs covering obscure tools.

=item C<syntax>

Warnings about weird syntax, unused variables, typos...

=item C<unsupported>

Warnings about unsupported (or mis-supported) features.

=item C<verb>

Messages output in C<--verbose> mode.  Use C<&verb> to send such messages.

=item C<note>

Informative messages.

=back

=cut

# Initialize our list of error/warning channels.
# Do not forget to update &usage and the manual
# if you add or change a warning channel.

register_channel 'fatal', type => 'fatal', uniq_part => UP_NONE, ordered => 0;
register_channel 'error', type => 'error';
register_channel 'error-gnu', type => 'error';
register_channel 'error-gnu/warn', type => 'error';
register_channel 'error-gnits', type => 'error', silent => 1;
register_channel 'automake', type => 'fatal', backtrace => 1,
  header => ("####################\n" .
	     "## Internal Error ##\n" .
	     "####################\n"),
  footer => "\nPlease contact <$PACKAGE_BUGREPORT>.",
  uniq_part => UP_NONE, ordered => 0;

register_channel 'cross', type => 'warning', silent => 1;
register_channel 'gnu', type => 'warning';
register_channel 'obsolete', type => 'warning';
register_channel 'override', type => 'warning', silent => 1;
register_channel 'portability', type => 'warning', silent => 1;
register_channel 'extra-portability', type => 'warning', silent => 1;
register_channel 'portability-recursive', type => 'warning', silent => 1;
register_channel 'syntax', type => 'warning';
register_channel 'unsupported', type => 'warning';

register_channel 'verb', type => 'debug', silent => 1, uniq_part => UP_NONE,
  ordered => 0;
register_channel 'note', type => 'debug', silent => 0;

setup_channel_type 'warning', header => 'warning: ';
setup_channel_type 'error', header => 'error: ';
setup_channel_type 'fatal', header => 'error: ';

=head2 FUNCTIONS

=over 4

=item C<usage ()>

Return the warning category descriptions.

=cut

sub usage ()
{
  return "Warning categories include:
  cross                  cross compilation issues
  gnu                    GNU coding standards (default in gnu and gnits modes)
  obsolete               obsolete features or constructions (default)
  override               user redefinitions of Automake rules or variables
  portability            portability issues (default in gnu and gnits modes)
  portability-recursive  nested Make variables (default with -Wportability)
  extra-portability      extra portability issues related to obscure tools
  syntax                 dubious syntactic constructs (default)
  unsupported            unsupported or incomplete features (default)
  all                    all the warnings
  no-CATEGORY            turn off warnings in CATEGORY
  none                   turn off all the warnings
  error                  treat warnings as errors";
}

=item C<prog_error ($MESSAGE, [%OPTIONS])>

Signal a programming error (on channel C<automake>),
display C<$MESSAGE>, and exit 1.

=cut

sub prog_error ($;%)
{
  my ($msg, %opts) = @_;
  msg 'automake', '', $msg, %opts;
}

=item C<error ($WHERE, $MESSAGE, [%OPTIONS])>

=item C<error ($MESSAGE)>

Uncategorized errors.

=cut

sub error ($;$%)
{
  my ($where, $msg, %opts) = @_;
  msg ('error', $where, $msg, %opts);
}

=item C<fatal ($WHERE, $MESSAGE, [%OPTIONS])>

=item C<fatal ($MESSAGE)>

Fatal errors.

=cut

sub fatal ($;$%)
{
  my ($where, $msg, %opts) = @_;
  msg ('fatal', $where, $msg, %opts);
}

=item C<verb ($MESSAGE, [%OPTIONS])>

C<--verbose> messages.

=cut

sub verb ($;%)
{
  my ($msg, %opts) = @_;
  $msg = "thread " . threads->tid . ": " . $msg
    if $perl_threads;
  msg 'verb', '', $msg, %opts;
}

=item C<switch_warning ($CATEGORY)>

If C<$CATEGORY> is C<mumble>, turn on channel C<mumble>.
If it is C<no-mumble>, turn C<mumble> off.
Else handle C<all> and C<none> for completeness.

=cut

sub switch_warning ($)
{
  my ($cat) = @_;
  my $has_no = 0;

  if ($cat =~ /^no-(.*)$/)
    {
      $cat = $1;
      $has_no = 1;
    }

  if ($cat eq 'all')
    {
      setup_channel_type 'warning', silent => $has_no;
    }
  elsif ($cat eq 'none')
    {
      setup_channel_type 'warning', silent => ! $has_no;
    }
  elsif ($cat eq 'error')
    {
      $warnings_are_errors = ! $has_no;
      # Set exit code if Perl warns about something
      # (like uninitialized variables).
      $SIG{"__WARN__"} =
	$has_no ? 'DEFAULT' : sub { print STDERR @_; $exit_code = 1; };
    }
  elsif (channel_type ($cat) eq 'warning')
    {
      setup_channel $cat, silent => $has_no;
      #
      # Handling of portability warnings is trickier.  For relevant tests,
      # see 'dollarvar2', 'extra-portability' and 'extra-portability3'.
      #
      # -Wportability-recursive and -Wno-portability-recursive should not
      # have any effect on other 'portability' or 'extra-portability'
      # warnings, so there's no need to handle them separately or ad-hoc.
      #
      if ($cat eq 'extra-portability' && ! $has_no) # -Wextra-portability
        {
          # -Wextra-portability must enable 'portability' and
          # 'portability-recursive' warnings.
          setup_channel 'portability', silent => 0;
          setup_channel 'portability-recursive', silent => 0;
        }
      if ($cat eq 'portability') # -Wportability or -Wno-portability
        {
          if ($has_no) # -Wno-portability
            {
              # -Wno-portability must disable 'extra-portability' and
              # 'portability-recursive' warnings.
              setup_channel 'portability-recursive', silent => 1;
              setup_channel 'extra-portability', silent => 1;
            }
          else # -Wportability
            {
              # -Wportability must enable 'portability-recursive'
              # warnings.  But it should have no influence over the
              # 'extra-portability' warnings.
              setup_channel 'portability-recursive', silent => 0;
            }
        }
    }
  else
    {
      return 1;
    }
  return 0;
}

=item C<parse_WARNINGS ()>

Parse the WARNINGS environment variable.

=cut

# Used to communicate from parse_WARNINGS to parse_warnings.
our $_werror = 0;

sub parse_WARNINGS ()
{
  if (exists $ENV{'WARNINGS'})
    {
      # Ignore unknown categories.  This is required because WARNINGS
      # should be honored by many tools.
      # For the same reason, do not turn on -Werror at this point, just
      # record that we saw it; parse_warnings will turn on -Werror after
      # the command line has been processed.
      foreach (split (',', $ENV{'WARNINGS'}))
        {
          if (/^(no-)?error$/)
            {
              $_werror = !defined $1;
            }
          else
            {
              switch_warning $_;
            }
        }
    }
}

=item C<parse_warnings (@CATEGORIES)>

Parse the argument of C<--warning=CATEGORY> or C<-WCATEGORY>.
C<@CATEGORIES> is the accumulated set of warnings categories.
Use like this:

    Automake::GetOpt::parse_options (
        # ...
        'W|warnings=s' => \@warnings,
    )
    # possibly call set_strictness here
    parse_warnings @warnings;

=cut

sub parse_warnings (@)
{
  foreach my $cat (map { split ',' } @_)
    {
      if ($cat =~ /^(no-)?error$/)
        {
          $_werror = !defined $1;
        }
      elsif (switch_warning $cat)
        {
          msg 'unsupported', "unknown warning category '$cat'";
        }
    }

  switch_warning ($_werror ? 'error' : 'no-error');
}

=item C<merge_WARNINGS (@CATEGORIES)>

Merge the warnings categories in the environment variable C<WARNINGS>
with the warnings categories in C<@CATEGORIES>, and return a new
value for C<WARNINGS>.  Values in C<@CATEGORIES> take precedence.
Use like this:

    local $ENV{WARNINGS} = merge_WARNINGS @additional_warnings;

=cut

sub merge_WARNINGS (@)
{
  my $werror = '';
  my $all_or_none = '';
  my %warnings;

  my @categories = split /,/, $ENV{WARNINGS} || '';
  push @categories, @_;

  foreach (@categories)
    {
      if (/^(?:no-)?error$/)
        {
          $werror = $_;
        }
      elsif (/^(?:all|none)$/)
        {
          $all_or_none = $_;
        }
      else
        {
          # The character class in the second match group is ASCII \S minus
          # comma.  We are generous with this because category values may come
          # from WARNINGS and we don't want to assume what other programs'
          # syntaxes for warnings categories are.
          /^(no-|)([\w\[\]\/\\!"#$%&'()*+-.:;<=>?@^`{|}~]+)$/
            or die "Invalid warnings category: $_";
          $warnings{$2} = $1;
        }
    }

  my @final_warnings;
  if ($all_or_none)
    {
      push @final_warnings, $all_or_none;
    }
  else
    {
      foreach (sort keys %warnings)
        {
          push @final_warnings, $warnings{$_} . $_;
        }
    }
  if ($werror)
    {
      push @final_warnings, $werror;
    }

  return join (',', @final_warnings);
}

=item C<set_strictness ($STRICTNESS_NAME)>

Configure channels for strictness C<$STRICTNESS_NAME>.

=cut

sub set_strictness ($)
{
  my ($name) = @_;

  if ($name eq 'gnu')
    {
      setup_channel 'error-gnu', silent => 0;
      setup_channel 'error-gnu/warn', silent => 0, type => 'error';
      setup_channel 'error-gnits', silent => 1;
      setup_channel 'portability', silent => 0;
      setup_channel 'extra-portability', silent => 1;
      setup_channel 'gnu', silent => 0;
    }
  elsif ($name eq 'gnits')
    {
      setup_channel 'error-gnu', silent => 0;
      setup_channel 'error-gnu/warn', silent => 0, type => 'error';
      setup_channel 'error-gnits', silent => 0;
      setup_channel 'portability', silent => 0;
      setup_channel 'extra-portability', silent => 1;
      setup_channel 'gnu', silent => 0;
    }
  elsif ($name eq 'foreign')
    {
      setup_channel 'error-gnu', silent => 1;
      setup_channel 'error-gnu/warn', silent => 0, type => 'warning';
      setup_channel 'error-gnits', silent => 1;
      setup_channel 'portability', silent => 1;
      setup_channel 'extra-portability', silent => 1;
      setup_channel 'gnu', silent => 1;
    }
  else
    {
      prog_error "level '$name' not recognized";
    }
}

=back

=head1 SEE ALSO

L<Automake::Channels>

=head1 HISTORY

Written by Alexandre Duret-Lutz E<lt>F<adl@gnu.org>E<gt>.

=cut

1;

### Setup "GNU" style for perl-mode and cperl-mode.
## Local Variables:
## perl-indent-level: 2
## perl-continued-statement-offset: 2
## perl-continued-brace-offset: 0
## perl-brace-offset: 0
## perl-brace-imaginary-offset: 0
## perl-label-offset: -2
## cperl-indent-level: 2
## cperl-brace-offset: 0
## cperl-continued-brace-offset: 0
## cperl-label-offset: -2
## cperl-extra-newline-before-brace: t
## cperl-merge-trailing-else: nil
## cperl-continued-statement-offset: 2
## End:
