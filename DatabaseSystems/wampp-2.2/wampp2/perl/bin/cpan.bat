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
#!/usr/bin/perl
#line 15
# $Id: cpan,v 1.1 2003/02/08 17:06:51 k Exp $
use strict;

=head1 NAME

cpan - easily interact with CPAN from the command line

=head1 SYNOPSIS

	# with arguments, installs specified modules
	cpan module_name [ module_name ... ]
	
	# with switches, installs modules with extra behavior
	cpan [-cimt] module_name [ module_name ... ]
	
	# without arguments, starts CPAN shell
	cpan
	
	# without arguments, but some switches
	cpan [-ahrv]

=head1 DESCRIPTION

This script provides a command interface (not a shell) to CPAN.pm.

=head2 Meta Options

These options are mutually exclusive, and the script processes
them in this order: [ahvr].  Once the script finds one, it ignores
the others, and then exits after it finishes the task.  The script
ignores any other command line options.

=over 4

=item -a

Creates the CPAN.pm autobundle with CPAN::Shell->autobundle.  

=item -h

Prints a help message.

=item -r

Recompiles dynamically loaded modules with CPAN::Shell->recompile.

=item -v

Print the script version and CPAN.pm version.

=back

=head2 Module options

These options are mutually exclusive, and the script processes
them in alphabetical order. 

=over 4

=item c

Runs a `make clean` in the specified module's directories.

=item i

Installed the specified modules.

=item m

Makes the specified modules.

=item t

Runs a `make test` on the specified modules.

=back

=head2 Examples

	# print a help message
	cpan -h
	
	# print the version numbers
	cpan -v
	
	# create an autobundle
	cpan -a
	
	# recompile modules
	cpan -r 
	
	# install modules
	cpan -i Netscape::Booksmarks Business::ISBN

=head1 TO DO

* add options for other CPAN::Shell functions
autobundle, clean, make, recompile, test

=head1 BUGS

* none noted

=head1 SEE ALSO

Most behaviour, including environment variables and configuration,
comes directly from CPAN.pm.

=head1 AUTHOR

brian d foy <bdfoy@cpan.org>

=cut

use CPAN ();
use Getopt::Std;

my $VERSION = 
	sprintf "%d.%02d", q$Revision: 1.1 $ =~ m/ (\d+) \. (\d+) /xg;

my $Default = 'default';

my $META_OPTIONS = 'ahvr';

my %CPAN_METHODS = (
	$Default => 'install',
	'c'      => 'clean',
	'i'      => 'install',
	'm'      => 'make',
	't'      => 'test',
	);

my @cpan_options = grep { $_ ne $Default } sort keys %CPAN_METHODS;

my $arg_count = @ARGV;
my %options;

Getopt::Std::getopts( 
	join( '', @cpan_options, $META_OPTIONS ), \%options );
	
if( $options{h} )
	{
	print STDERR "Printing help message -- ignoring other arguments\n"
		if $arg_count > 1;

	print STDERR "Use perldoc to read the documentation\n";
	exit 0;
	}
elsif( $options{v} )
	{
	print STDERR "Printing version message -- ignoring other arguments\n"
	
		if $arg_count > 1;

	my $CPAN_VERSION = CPAN->VERSION;
	print STDERR "cpan script version $VERSION\n" .
		"CPAN.pm version $CPAN_VERSION\n";
	exit 0;
	}
elsif( $options{a} )
	{
	print "Creating autobundle in ", $CPAN::Config->{cpan_home}, 
		"/Bundle\n";
	print STDERR "Creating autobundle -- ignoring other arguments\n"
		if $arg_count > 1;

	CPAN::Shell->autobundle;
	exit 0;
	}
elsif( $options{r} )
	{
	print STDERR "Creating autobundle -- ignoring other arguments\n"
		if $arg_count > 1;
		
	CPAN::Shell->recompile;
	}
else
	{
	my $switch = '';
	
	foreach my $option ( @cpan_options )
		{
		next unless $options{$option};
		$switch = $option;
		last;
		}
	
	   if( not $switch and     @ARGV ) { $switch = $Default;     }
	elsif( not $switch and not @ARGV ) { CPAN::shell(); exit 0;  }	
	elsif(     $switch and not @ARGV ) 
		{ die "Nothing to $CPAN_METHODS{$switch}!\n"; }

	my $method = $CPAN_METHODS{$switch};
	die "CPAN.pm cannot $method!\n" unless CPAN::Shell->can( $method );
	
	foreach my $arg ( @ARGV )
		{
		CPAN::Shell->$method( $arg );
		}
	}
	
1;

__END__
:endofperl
