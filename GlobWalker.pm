#
# GlobWalker
#
# $Id: GlobWalker.pm,v 1.1 2000/10/30 15:45:39 dave Exp $
#
# Perl module for listing objects in typeglobs
#
# Copyright (c) 2000, Magnum Solutions Ltd. All rights reserved.
#
# This module is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# $Log: GlobWalker.pm,v $
# Revision 1.1  2000/10/30 15:45:39  dave
# Initial revision
#
#
package Globwalker;

use strict;
use vars qw($VERSION @ISA @EXPORT_OK);

require Exporter;

@ISA = qw(Exporter);
@EXPORT_OK = qw(get_things get_subs get_scalars get_arrays 
                get_hashes get_filehandles);

$VERSION = sprintf "%d.%02d", '$Revision: 1.1 $ ' =~ /(\d+)\.(\d+)/;

sub get_things {
  my $thing = shift;
  my $pkg = shift || caller;
  my @things;

  no strict 'refs'; # WARNING: Deep magic here!
  while (my ($sym_name, $sym_glob) = each %{"${pkg}::"}) {
    if ($thing eq 'SCALAR' ) {
      push @things, $sym_name if defined $ {*$sym_glob{$thing}};
    } else {
      push @things, $sym_name if defined *$sym_glob{$thing};
    }
  }

  @things;
}

sub get_subs { get_things('CODE', shift || scalar caller) };
sub get_scalars { get_things('SCALAR', shift || scalar caller) };
sub get_arrays { get_things('ARRAY', shift || scalar caller) };
sub get_hashes { get_things('HASH', shift || scalar caller) };
sub get_filehandles { get_things('IO', shift || scalar caller) };

1;
__END__

=head1 NAME

Globwalker - Perl module to explore the contents of the Perl 
             symbol table.

=head1 SYNOPSIS

  use Globwalker qw(get_subs get_arrays);

  my @subs = get_subs;          # List of subs in calling package
  @subs = get_subs('Another')   # List of subs in package 'Another'

  my @arrs = get_arrays;        # List of subs in calling package
  @arrs = get_arrays('Another') # List of subs in package 'Another'

=head1 DESCRIPTION

Globwalker is a Perl module which allows you to explore the contents
of a symbol table.

Globwalker exports six subroutines. Of these, five will list the
objects of a particular type (subroutines, scalars, arrays, hashes
and filehandles). These subroutines all take an optional argument
which is the name of the package whose symbol table should be
explored. If this this parameter is omitted then GlobwWalker will
explore the symbol table of the package which it is called from.

The sixth subroutine is called C<get_things> and is more generalised.
It takes a mandatory parameter which is the type of object to look
for (this can be CODE, SCALAR, ARRAY, HASH or IO) followed by the
usual optional package name.

Each of these subroutines returns a list containing the names of the
objects of the given type which are found in the given package.

=head2 A Note About Scalars

Scalars are handled differently than all of the other types that can
live in a typeglob. The difference is that each typeglob automatically
comes with its own built-in scalar for free - even if you don't use it.
Therefore, if you use an array called @x, then there is now way of
knowing whether or not the associated scalar ($x) has been defined.
The situation is actually slightly worse than that becasue it means
that all of the standard filehandles (like STDIN) that exist in the 
main package will have associated scalars (like $STDIN).

In current versions of Perl there is no way to get round this 
restriction, so I've made the decision to only return scalar names
if their value i defined. This means that if you declare a scalar but 
don't assign a value to it, then it won't be listed in the return
value of C<get_scalars> or C<get_things('SCALAR')>.


=head1 AUTHOR

Dave Cross <dave@dave.org.uk>

=head1 SEE ALSO

perl(1).

=cut
