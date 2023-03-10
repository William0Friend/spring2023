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

use strict;
# use warnings;
use Getopt::Long qw(:config no_ignore_case);
use PPM::Make;
my %opts = ();
my @files = ();
my %progs = ();
my $result = GetOptions(\%opts, 
			'install|l',
			'zip|z',
			'force|f',
			'ignore|i',
			'binary|b:s',
                        'arch_sub|n',
			'script|s:s',
			'exec|e:s',
			'os|o:s',
			'arch|a:s',
			'version|v',
			'help|h',
			'remove|r',
			'as|A!',
			'vs|V',
			'add|x:s' => \@files,
			'program|p:s' => \%progs,
			'ppd:s',
			'ar:s',
			'host:s',
			'user:s',
			'passwd:s',
		       );
if ($opts{v}) {
  print <<"END";

This is make_ppm, running PPM::Make version $PPM::Make::VERSION.

Copyright 2002, Randy Kobes <randy\@theoryx5.uwinnipeg.ca>.
This program is distributed under the same terms as Perl itself.

END
  exit;
}


if ($opts{h} or not $result) {
  print <<"END";

Usage: $0 [options] [Module | Distribution]

Options:
 [-z | --zip]              : make a zip distribution
 [-f | --force]            : force remaking a distribution
 [-i | --ignore]           : ignore any failing test results
 [-b | --binary] location  : specify the binary location
 [-n | --arch_sub]         : use \$Config{archname} as a subdirectory
 [-s | --script] script    : specify a script in the <INSTALL> field
 [-x | --add] file         : add specified extra files to the archive
 [-e | --exec] exec        : specify the executable to run the <INSTALL> script
 [-x | --add] file         : add file to the archive
 [-o | --os] os            : use os for the <OS> field
 [-a | --arch] arch        : use arch for the <ARCHITECTURE> field
 [-v | --version]          : print version information and exit
 [-h | --help]             : print this help screen
 [-l | --install]          : install the package after building
 [-r | --remove]           : remove the build directory after installation
 [-p | --program]  b=a     : specify "a" to be used for the "b" program
 [-A | --as]               : add Perl version number to ARCHITECTURE (>= 5.8)
 [-V | --ppmv]             : add version string to ppd and archive filenames
 [ --ppd ]  location       : copy the ppd to the specified location
 [ --ar ]   location       : copy the archive file to the specified location
 [ --host]  host           : use the specified host for copying the ppm files
 [ --user]  user           : username to use when trasnferring ppm files
 [ --passwd] password      : password associated with user

Additional Arguments:
   Module       : specify a module to fetch (requires CPAN.pm)
   Distribution : specify a distribution to fetch

With no arguments, make_ppm will build a distribution
inside the current directory. See 'perldoc make_ppm'.

END
  exit;
}

my $dist = shift;
my %upload = ();

for (qw(binary script exec add program ppd ar host user passwd)) {
  die "Please supply an argument to '$_'"
     if ( defined $opts{$_} and $opts{$_} eq "");
}

for (qw(ppd ar host user passwd)) {
  $upload{$_} = delete $opts{$_};
}
$opts{upload} = \%upload if defined $upload{ppd};

my $ppm = PPM::Make->new(%opts);
$ppm->make_ppm();

__END__

=head1 NAME

make_ppm - script to make a PPM distribution

=head1 SYNOPSIS

   make_ppm [options] [Module | Distribution]

   # make a PPM from within an already unpacked source distribution
   C:\.cpan\build\package_src> make_ppm 

   # fetch from CPAN a module distribution and build a PPM
   C:\.cpan\build> make_ppm Net::FTP

   # fetch a distribution and build a PPM
   C:\.cpan\build> make_ppm ftp://wherever.com/package.tar.gz

=head1 DESCRIPTION

C<make_ppm> is an interface to the C<PPM::Make> module,
and is used to build a PPM (Perl Package Manager) distribution
from a CPAN source distribution. See L<PPM::Make> for a
discussion.

Apart from the options described below, without any arguments 
C<make_ppm> will assume it is inside an unpacked source
distribution and make the corresponding PPM distribution.
If it is given an argument of what looks like a module
name (eg, I<Net::FTP>), it will use C<CPAN.pm> to look up the 
corresponding distribution and fetch and build it. Otherwise, 
additional arguments (eg, F<package.tar.gz>, or
I<http://someplace.org/package.tar.gz>) will be interpreted
as distributions to fetch and build.

Options can be read from a configuration file
(see L<PPM::Make>) and/or given as options to I<make_ppm>.
In case of duplicates, the options to I<make_ppm> take
precedence. Available options include:

=over

=item [-z | --zip]

By default, C<make_ppm> will build a C<.tar.gz> distribution
if possible. This option forces a C<.zip> distribution to be made.

=item [-f | --force]

By default, if C<make_ppm> detects a F<blib/> directory,
it will assume the distribution has already been made, and
will not remake it. This option forces remaking the distribution.

=item [-i | --ignore]

By default, C<make_ppm>, if it is building the distribution,
will die if all tests do not pass. Turning on this option
instructs C<make_ppm> to ignore any test failures.

=item [-b | --binary] location

I<location> is used as the value for the C<BINARY_LOCATION>
attribute passed to C<perl Makefile.PL>, and is used in
setting the I<HREF> attribute of the I<CODEBASE> field
in the ppd file.

=item [-n | --arch_sub]

This option will insert the value of C<$Config{archname}>
(or the value of the I<-a> option, if given)
as a relative subdirectory in the I<HREF> attribute of the 
I<CODEBASE> field in the ppd file.

=item  [-o | --os] os

If this option is specified, the value, if present, will be used 
instead of the default for the I<NAME> attribute of the I<OS> field 
of the ppd file. If no value is supplied, the I<OS> field will not 
be included in the ppd file.

=item [-a | --arch] arch

If this option is specified, the value, if present, will be used instead 
of the default for the I<NAME> attribute of the I<ARCHITECTURE> field of 
the ppd file. If no value is specified, the  I<ARCHITECTURE> field 
will not be included in the ppd file.

=item  [-s | --script] script

This will be used in the I<PPM_INSTALL_SCRIPT>
attribute passed to C<perl Makefile.PL>, and arises in
setting the value of the I<INSTALL> field in the ppd file.
If this begins with I<http://> or I<ftp://>, so that the
script is assumed external, this will be
used as the I<HREF> attribute for I<INSTALL>.

=item [-e | -- exec] exec

This will be used in the I<PPM_INSTALL_EXEC>
attribute passed to C<perl Makefile.PL>, and arises in
setting the I<EXEC> attribute of the I<INSTALL> field
in the ppd file.

=item  [-x | --add] file

This option, which can be specified multiple times, can
be used to add additional files outside of the the F<blib>
directory to the archive.

=item [-l | --install]

If specified, the C<ppm> utility will be used to install
the module.

=item [-r | --remove]

If specified, the directory used to build the ppm distribution
given on the command line will be removed after a successful install.

=item [-p | --prog] program=/path/to/program

This option specifies that C</path/to/program> should be used
for C<program>, rather than the one PPM::Make finds. This option
can be specified multiple times, with
C<program> being one of C<tar>, C<gzip>, C<zip>, C<unzip>, or C<make>.

=item ppd $path_to_ppd_files

If given, this will copy the ppd file to the location specified,
and must be given as an absolute pathname. If I<host> is specified,
this copy will be done via ftp, otherwise a local copy is made.

=item ar $path_to_archive_files

This is the location where the archive file should be placed.
This may either be an absolute pathname or a relative one,
in which case it is interpreted to be relative to that
specified by I<ppd>. If this is not given, but I<ppd>
is specified, this will default to the value of I<ppd>.

=item host $hostname

If specified, an ftp transfer to the specified host is
done, with I<ppd> and I<ar> as described above.

=item user $username

This specifies the user name to login as when transferring
via ftp.

=item passwd $passwd

This is the associated password to use for I<user>

=item [-A | --as]

Beginning with Perl-5.8, Activestate adds the Perl version number to
the NAME of the ARCHITECTURE tag in the ppd file. This option,
which is enabled by default, will make a ppd file compatible with this
practice. Specify C<--noas> to disable this option.

=item [-V | --vs]

This option will add a version string (based on the VERSION reported
in the ppd file) to the ppd and archive filenames.

=item [-h | --help]

This prints out a short help screen and exits.

=item [-v | --version]

This prints out some version information and exits.

=back

=head1 COPYRIGHT

This program is copyright, 2002, by Randy Kobes <randy@theoryx5.uwinnipeg.ca>.
It is distributed under the same terms as Perl itself.

=head1 SEE ALSO

L<PPM::Make>, and L<PPM>.

=cut

__END__
:endofperl
