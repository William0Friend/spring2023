@rem = '--*-Perl-*--
@echo off
if "%OS%" == "Windows_NT" goto WinNT
perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
:WinNT
perl -x -S %0 %*
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
if errorlevel 1 goto script_failed_so_exit_with_non_zero_val 2>nul
goto endofperl
@rem ';
#!perl -w
#line 15

$VERSION = '0.35';


=head1 NAME

xyx - convert xml to yaml or vice versa

=head1 USAGE

    xyx foo.xml > foo.yml
    xyx foo.yml > foo.xml

=head1 DESCRIPTION

This program requires the Perl modules XML::Simple and YAML. It will use one of them to Load a document in the respective format, and use the other to Dump the data structure in the other format. Input content type is autodetected.

This is a trivial program and probably only useful for trivial tasks.

=head1 AUTHOR

Brian Ingerson <ingy@cpan.org>

=head1 COPYRIGHT

Copyright 2002, Brian Ingerson - All rights reserved

You may use this hack under the same terms as Perl itself.

=cut

use strict;
use YAML;
use XML::Simple;

my @serieskeys = ();

my $data = join '', <>;
my %opts;

if ($data =~ /^\s*</) {
    my $xml = XMLin(
	$data,
	keeproot=>1,
	noattr=>1,
	keyattr=>[@serieskeys],
	suppressempty=>''
    );
    print Dump($xml);
}
else {
    for my $object (Load($data)) {
	print XMLout($object,
		     keeproot => 1,
		     noattr => 1,
		    );
    }
}

BEGIN {
    my %options = map {("-$_", 1)}
      qw(help);
    my @STDIN = ();
    if (@ARGV and
        $ARGV[-1] !~ /^-/
       ) {
        die "Invalid input file '$ARGV[-1]'\n"
          unless -f $ARGV[-1];
        push @STDIN, pop @ARGV;
    }

    for my $arg (@ARGV) {
        if ($arg =~ /^-s(?:erieskeys)?=(\w.*)$/) {
            for my $key (split ',', $1) {
                push @serieskeys, $key;
            }
        }
        elsif ($options{$arg}) {
            $opts{$arg} = 1;
        }
        else {
            die "Invalid option '$arg'\n";
        }
    }

    @ARGV = @STDIN;
}


__END__
:endofperl
