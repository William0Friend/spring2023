#!/usr/bin/perl -s
##
## Crypt::RSA::Debug
##
## Copyright (c) 2001, Vipul Ved Prakash.  All rights reserved.
## This code is free software; you can redistribute it and/or modify
## it under the same terms as Perl itself.
##
## $Id: Debug.pm,v 1.9 2001/04/09 22:21:49 vipul Exp $

package Crypt::RSA::Debug; 
use lib qw(lib);
use strict;
use vars qw(@ISA @EXPORT_OK);
require Exporter;
@ISA = qw(Exporter);

@EXPORT_OK = qw(debug debuglevel); 

my $DEBUG = 0; 

sub debug{
    return undef unless $DEBUG;
    my ($caller, undef) = caller;
    my (undef,undef,$line,$sub) = caller(1); $sub =~ s/.*://;
    $sub = sprintf "%12s()%4d", $sub, $line;
    $sub .= " |  " . (shift);  
    $sub =~ s/\x00/[0]/g; 
    $sub =~ s/\x01/[1]/g; 
    $sub =~ s/\x02/[2]/g; 
    $sub =~ s/\x04/[4]/g; 
    $sub =~ s/\x05/[5]/g; 
    $sub =~ s/\xff/[-]/g; 
    $sub =~ s/[\x00-\x1f]/\./g; 
    $sub =~ s/[\x7f-\xfe]/_/g;
    print "$sub\n";
}


sub debuglevel { 

    my ($level) = shift;
    $DEBUG = $level;

}


=head1 NAME

Crypt::RSA::Debug - Debug routine for Crypt::RSA.

=head1 SYNOPSIS

    use Crypt::RSA::Debug qw(debug);
    debug ("oops!");

=head1 DESCRIPTION

The module provides support for the I<print> method of debugging!

=head1 FUNCTION 

=over 4

=item B<debug> String

Prints B<String> on STDOUT, along with caller's function name and line number.

=back

=head1 AUTHOR

Vipul Ved Prakash, E<lt>mail@vipul.netE<gt>

=cut

1;

