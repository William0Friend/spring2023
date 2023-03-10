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
#!/usr/bin/perl -w
#line 15

###############################################
#                                             #
##           for documentation               ##
###               execute:                  ###
####          % perldoc docset_build       ####
###          to get the built-in            ###
##              docs rendered                ##
#                                             #
###############################################

use strict;

require 5.005_03;

use DocSet::5005compat;
use warnings;
require Cwd;
local $| = 1;

use File::Spec::Functions;

my $config_file = pop @ARGV;
my $abs_root    = pop @ARGV;

# must start from the abs root
chdir $abs_root;

# make the config_file path as a true full path with no .. in it
my $cwd = Cwd::cwd();
$abs_root = $cwd;
$config_file = catfile $cwd, $config_file;

die "cannot find the config file ", 
    usage() unless -e $config_file and -r _;

use Getopt::Std;

use DocSet::RunTime ();
use DocSet::DocSet::HTML ();
use DocSet::DocSet::PSPDF ();

######################################
### Init Command Line Arguments
######################################

# set defaults if no options given
my $verbose        = 0;  # verbose?
my $podify_items   = 0;  # podify pseudo-pod (s/^* /=item */)
my $split_html     = 0;  # create the splitted html version
my $make_tgz       = 0;  # create the rel and bin+src archives?
my $generate_ps    = 0;  # generate PS file
my $generate_pdf   = 0;  # generate PDF file
my $rebuild_all    = 0;  # ignore the timestamp of ../src/.last_modified
my $print_anchors  = 0;  # print the available anchors
my $validate_links = 0;  # validate %links_to_check against %valid_anchors
my $makefile_mode  = 0;	 # executed from Makefile (forces rebuild, no
                         # PS/PDF file, no tgz archive created!)
my $slides_mode    = 0;

######################################
### Process Command Line Arguments
######################################

my %opts;
getopts('hvtpdfalmise', \%opts);

usage() if $opts{h};

if (keys %opts) {   # options given
    $verbose        = $opts{v} || 0;
    $podify_items   = $opts{i} || 0;
    $split_html     = $opts{s} || 0;
    $make_tgz       = $opts{t} || 0;
    $generate_ps    = $opts{p} || 0;
    $generate_pdf   = $opts{d} || 0;
    $rebuild_all    = $opts{f} || 0; # force
    $print_anchors  = $opts{a} || 0;
    $validate_links = $opts{l} || 0;
    $slides_mode    = $opts{e} || 0;
    $makefile_mode  = $opts{m} || 0;
}

if ($makefile_mode) {
  $verbose        = 1;
  $make_tgz       = 0;
  $generate_ps    = 0;
  $generate_pdf   = 0;
  $rebuild_all    = 1;
  $print_anchors  = 0;
  $validate_links = 0;
}

# in the slides mode we turn preprocessing automatically to be on
if ($slides_mode) {
    $podify_items = 1;
}

# we need a PS version in order to create a pdf
$generate_ps = 1 if $generate_pdf;

# verify the ability to create PS version
$generate_ps  = DocSet::RunTime::can_create_ps if $generate_ps;

# verify the ability to create PDF version
$generate_pdf = DocSet::RunTime::can_create_pdf if $generate_pdf;

# we cannot create PDF if we cannot generate PS
$generate_pdf = 0 unless $generate_ps;

## if there is no toc_file we cannot produce correct internal links,
## therefore we force this option.
#my $toc_file = $config->get_param('toc_file');
#$rebuild_all = 1,
#  print "!!! No $toc_file was found, forcing a complete rebuild\n"
#    unless -e $toc_file or $rebuild_all;

my %options = (
    verbose        => $verbose,
    podify_items   => $podify_items,
    split_html     => $split_html,
    make_tgz       => $make_tgz,
    generate_ps    => $generate_ps,
    generate_pdf   => $generate_pdf,
    rebuild_all    => $rebuild_all,
    print_anchors  => $print_anchors,
    validate_links => $validate_links,
    makefile_mode  => $makefile_mode,
    slides_mode    => $slides_mode,
);

# make the runtime options available to other packages
DocSet::RunTime::set_opt(\%options);

# absolutize the base url



######################################
### Create the PS/PDF DocSet
######################################
if (DocSet::RunTime::get_opts('generate_ps')) {
    DocSet::RunTime::registers_reset();
    my $docset = DocSet::DocSet::PSPDF->new($config_file);
    $docset->set_dir(abs_root => ".");
    $docset->scan;
    $docset->render;
}

# HTML DocSet is rendered last, since it may need to link to the
# products of previously rendered DocSets, e.g. PDF files.

######################################
### Create the HTML DocSet
######################################
{
    # scan for available configs (books/chapters)
    DocSet::RunTime::registers_reset();
    my $docset = DocSet::DocSet::HTML->new($config_file);
    # must be a relative path to be able to move the generated code from
    # location to location, without adjusting the links
    $docset->set_dir(abs_root => ".");
    $docset->scan;
    $docset->render;
}

  # go back to where you have from
#chdir $orig_dir;

######################################
### Subs
######################################

##########
sub usage{

  print <<USAGE;
    pod2hpp [options] config_file_location

Options:

  -h    this help
  -v    verbose
  -i    podify pseudo-pod items (s/^* /=item */)
  -p    generate PS file
  -d    generate PDF file
  -f    force a complete rebuild
  -l    do hypertext links validation
  -m    executed from Makefile (forces rebuild,
				no PS/PDF file,
				no tgz archive!)

USAGE

# not implemented/ported yet
#  -t    create tar.gz
#  -s    create the splitted html version
#  -a    print available hypertext anchors
#  -e    slides mode (for presentations)

  exit;

} # end of sub usage



__END__

=head1 NAME

docset_build - a script that does documentation projects building in HTML, PS and PDF formats

=head1 SYNOPSIS

  docset_build [options] configuration_file_location

=head1 DESCRIPTION

See C<DocSet>

=head1 AUTHOR

Stas Bekman <stas@stason.org>

=head1 COPYRIGHT

This program is distributed under the Artistic License, like the Perl
itself.

=cut


=cut

__END__
:endofperl
