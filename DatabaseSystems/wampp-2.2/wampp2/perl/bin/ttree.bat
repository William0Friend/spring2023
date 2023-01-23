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
#========================================================================
#
# ttree
#
# DESCRIPTION
#   Script for processing all directory trees containing templates.
#   Template files are processed and the output directed to the 
#   relvant file in an output tree.  The timestamps of the source and
#   destination files can then be examined for future invocations 
#   to process only those files that have changed.  In other words,
#   it's a lot like 'make' for templates.
#
# AUTHOR
#   Andy Wardley   <abw@kfs.org>
#
# COPYRIGHT
#   Copyright (C) 1996-2000 Andy Wardley.  All Rights Reserved.
#   Copyright (C) 1998-2000 Canon Research Centre Europe Ltd.
#
#   This module is free software; you can redistribute it and/or
#   modify it under the same terms as Perl itself.
#
#------------------------------------------------------------------------
#
# $Id: ttree,v 2.58 2003/03/17 21:44:35 abw Exp $
#
#========================================================================

use strict;
use Template;
use AppConfig qw( :expand );
use File::Copy;
use File::Path;
use File::Basename;


#------------------------------------------------------------------------
# config
#------------------------------------------------------------------------
my $NAME     = "ttree";
my $VERSION  = sprintf("%d.%02d", q$Revision: 2.58 $ =~ /(\d+)\.(\d+)/);
my $HOME     = $ENV{ HOME } || '';
my $RCFILE   = $ENV{"\U${NAME}rc"} || "$HOME/.${NAME}rc";

# offer create a sample config file if it doesn't exist, unless a '-f'
# has been specified on the command line
unless (-f $RCFILE or grep(/^-f$/, @ARGV) ) {
    print("Do you want me to create a sample '.ttreerc' file for you?\n",
	  "(file: $RCFILE)   [y/n]: ");
    my $y = <STDIN>;
    if ($y =~ /^y(es)?/i) {
	write_config($RCFILE);
	exit(0);
    }
}

# read configuration file and command line arguments - I need to remember 
# to fix varlist() and varhash() in AppConfig to make this nicer...
my $config   = read_config($RCFILE);
my $dryrun   = $config->nothing;
my $verbose  = $config->verbose || $dryrun;
my $recurse  = $config->recurse;
my $preserve = $config->preserve;
my $debug    = $config->debug;
my $all      = $config->all;
my $libdir   = $config->lib;
my $ignore   = $config->ignore;
my $copy     = $config->copy;
my $accept   = $config->accept;
my $srcdir   = $config->src
	       || die "Source directory not set (-s)\n";
my $destdir  = $config->dest
	       || die "Destination directory not set (-d)\n";
die "Source and destination directories may not be the same:\n  $srcdir\n"
    if $srcdir eq $destdir;

# unshift any perl5lib directories onto front of INC
unshift(@INC, @{ $config->perl5lib });

# get all template_* options from the config and fold keys to UPPER CASE
my %ttopts   = $config->varlist('^template_', 1);
my $ucttopts = {
    map { my $v = $ttopts{ $_ }; defined $v ? (uc $_, $v) : () }
    keys %ttopts,
};

# special case  # what special case is that then?
                # I'm commenting this out -- abw 2002/12/05
#$ucttopts->{ RECURSION } = $recurse if defined $recurse;

#@ucttopts{ map { uc } keys %ttopts } = values %ttopts;

#print STDERR("TT config: ", 
#	     join(', ', map { "$_ => $ucttopts->{ $_ }"} keys %$ucttopts), 
#	     "\n") if $debug;

# get all template variable definitions
my $replace = $config->get('define');

#print "replace hash: ", join(', ', map { "$_ => $replace->{ $_ }"} 
#			     keys %$replace), "\n";

# now create complete parameter hash for creating template processor
my $ttopts   = {
    %$ucttopts,
    RELATIVE     => 1,
#    INCLUDE_PATH => [ @$libdir, '.' ],
    INCLUDE_PATH => [ $srcdir, @$libdir ],
    OUTPUT_PATH  => $destdir,
};

#------------------------------------------------------------------------
# pre-amble
#------------------------------------------------------------------------
print "$NAME $VERSION (Template Toolkit version $Template::VERSION)\n\n"
    if $verbose;

if ($verbose) {
    local $" = ', ';
    print(STDERR 
	  "      Source: $srcdir\n",
	  " Destination: $destdir\n",
	  "Include Path: [ @$libdir ]\n",
	  "      Ignore: [ @$ignore ]\n",
	  "        Copy: [ @$copy ]\n",
	  "      Accept: [ ", @$accept ? "@$accept" : "*", " ]\n\n");
    print(STDERR "NOTE: dry run, doing nothing...\n")
	if $dryrun;
}
if ($debug) {
    local $" = ', ';
    print STDERR "Template Toolkit configuration:\n";
    foreach (keys %$ucttopts) {
	my $val = $ucttopts->{$_};
	next unless $val;
	if (ref($val) eq 'ARRAY') {
	    next unless @$val;
	    $val = "[ @$val ]";
	}
	printf STDERR "  %-12s => $val\n", $_;
    }
    print STDERR "\n";
}


#------------------------------------------------------------------------
# main-amble
#------------------------------------------------------------------------

#chdir($srcdir) || die "$srcdir: $!\n";

my $template = Template->new($ttopts);

if (@ARGV) {
    # explicitly process files specified on command lines 
    foreach my $file (@ARGV) {
	print "  + $file\n" if $verbose;
	$template->process($file, $replace, $file)
	    || print "  ! ", $template->error(), "\n";
    }
}
else {
    # implicitly process all file in source directory
    process_tree();
}


#------------------------------------------------------------------------
# process_tree($dir)
#
# Walks the directory tree starting at $dir or the current directory
# if unspecified, processing files as found.
#------------------------------------------------------------------------

sub process_tree {
    my $dir = shift;
    my ($file, $path, $abspath, $check);
    my $target;
    local *DIR;

    my $absdir = join('/', $srcdir ? $srcdir : (), $dir ? $dir : ());
    $absdir ||= '.';

    print STDERR "  * processing tree: $absdir\n" if $debug;

    opendir(DIR, $absdir) || do { warn "$absdir: $!\n"; return undef; };

    FILE: while (defined ($file = readdir(DIR))) {
	next if $file eq '.' || $file eq '..';
	$path = $dir ? "$dir/$file" : $file;
	$abspath = "$absdir/$file";
	
	next unless -e $abspath;

	# check against ignore list
	foreach $check (@$ignore) {
	    if ($path =~ /$check/) {
		printf "  - %-32s (ignored, matches /$check/)\n", $path
		    if $verbose;
		next FILE;
	    }
	}

	if (-d $abspath) {
	    if ($recurse) {
		my ($uid, $gid, $mode);

		(undef, undef, $mode, undef, $uid, $gid, undef, undef,
		 undef, undef, undef, undef, undef)  = stat($abspath);

		# create target directory if required
		$target = "$destdir/$path";
		unless (-d $target || $dryrun) {
		    mkdir $target, $mode || do { 
			warn "mkdir  ($target): $!\n";
			next;
		    };
# commented out by abw on 2000/12/04 - seems to raise a warning?   
#		    chown($uid, $gid, $target) || warn "chown($target): $!\n";
		    printf "  + %-32s (created target directory)\n", $path
			if $verbose;
		}
		# recurse into directory
		process_tree($path);
	    }
	    else {
		printf "  - %-32s (directory, not recursing)\n", $path
		    if $verbose;
	    }
	}
	else {
	    process_file($path, $abspath);
	}
    }
    closedir(DIR);
}
	

#------------------------------------------------------------------------
# process_file()
#
# File filtering and processing sub-routine called by process_tree()
#------------------------------------------------------------------------

sub process_file {
    my ($file, $absfile) = @_;
    my ($dest, $base, $check, $srctime, $desttime, $mode, $uid, $gid);

    $absfile ||= $file;
    $dest = $destdir ? "$destdir/$file" : $file;
    $base = basename($file);
			       
#    print "proc $file => $dest\n";

    # stat the source file unconditionally, so we can preserve
    # mode and ownership
    (undef, undef, $mode, undef, $uid, $gid, undef, undef, undef, $srctime,
     undef, undef, undef)  = stat($absfile);
    
    # test modification time of existing destination file
    if (-f $dest && ! $all) {
	$desttime = ( stat($dest) )[9];

	if ($desttime >= $srctime) {
	    printf "  - %-32s (not modified)\n", $file
		if $verbose;
	    return;
	}
    }
	
    # check against copy list
    foreach $check (@$copy) {
	if ($base =~ /$check/) {
	    printf "  > %-32s (copied, matches /$check/)\n", $file
		if $verbose;

	    unless ($dryrun) {
		copy($absfile, $dest);

		if ($preserve) {
		    chown($uid, $gid, $dest) || warn "chown($dest): $!\n";
		    chmod($mode, $dest) || warn "chmod($dest): $!\n";
		}
	    }
	    return;
	}
    }

    # check against acceptance list
    if (@$accept) {
	unless (grep { $base =~ /$_/ } @$accept) {
	    printf "  - %-32s (not accepted)\n", $file
		if $verbose;
	    return;
	}
    }

    print "  + $file\n" if $verbose;

    # process file
    unless ($dryrun) {
        $template->process($file, $replace, $file)
	    || print("  ! ", $template->error(), "\n");

	if ($preserve) {
	    chown($uid, $gid, $dest) || warn "chown($dest): $!\n";
	    chmod($mode, $dest) || warn "chmod($dest): $!\n";
	}
    }
}


#------------------------------------------------------------------------
# read_config($file)
#
# Handles reading of config file and/or command line arguments.
#------------------------------------------------------------------------

sub read_config {
    my $file = shift;

    my $config = AppConfig->new({ 
	ERROR  => sub { die @_, "\ntry `$NAME --help'\n" }   }, 
	'help|h'      => { ACTION => \&help },
	'src|s=s'     => { EXPAND => EXPAND_ALL },
	'dest|d=s'    => { EXPAND => EXPAND_ALL },
	'lib|l=s@'    => { EXPAND => EXPAND_ALL },
	'cfg|c=s'     => { EXPAND => EXPAND_ALL, DEFAULT => '.' },
	'verbose|v'   => { DEFAULT => 0 },
	'recurse|r'   => { DEFAULT => 0 },
	'nothing|n'   => { DEFAULT => 0 },
	'preserve|p'  => { DEFAULT => 0 },
	'all|a'       => { DEFAULT => 0 },
        'debug|dbg'   => { DEFAULT => 0 },
	'define=s%',
	'ignore=s@',
	'copy=s@',
	'accept=s@',
	'template_anycase|anycase',
	'template_eval_perl|eval_perl',
	'template_load_perl|load_perl',
	'template_interpolate|interpolate',
	'template_pre_chomp|pre_chomp|prechomp',
	'template_post_chomp|post_chomp|postchomp',
	'template_trim|trim',
        'template_pre_process|pre_process|preprocess=s@',
        'template_post_process|post_process|postprocess=s@',
        'template_process|process=s',
        'template_recursion|recursion',
        'template_expose_blocks|expose_blocks',
        'template_default|default=s',
        'template_error|error=s',
        'template_start_tag|start_tag|starttag=s',
        'template_end_tag|end_tag|endtag=s',
        'template_tag_style|tag_style|tagstyle=s',
        'template_compile_ext|compile_ext=s',
        'template_compile_dir|compile_dir=s',
	'template_plugin_base|plugin_base|pluginbase=s@',
	'perl5lib|perllib=s@'
    );

    # add the 'file' option now that we have a $config object that we 
    # can reference in a closure
    $config->define(
	'file|f=s@'   => { EXPAND => EXPAND_ALL, 
			   ACTION => sub { 
			       my ($state, $item, $file) = @_;
			       $file = $state->cfg . "/$file" 
				   unless $file =~ /^[\.\/]|(?:\w:)/;
			       $config->file($file) }  
			   }
    );

    # process main config file, then command line args
    $config->file($file) if -f $file;
    $config->args();

    $config;
}


#------------------------------------------------------------------------
# write_config($file)
#
# Writes a sample configuration file to the filename specified.
#------------------------------------------------------------------------

sub write_config {
    my $file = shift;

    open(CONFIG, ">$file") || die "failed to create $file: $!\n";
    print(CONFIG <<END_OF_CONFIG);
#------------------------------------------------------------------------
# sample .ttreerc file created automatically by $NAME version $VERSION
#
# This file originally written to $file
#
# For more information on the contents of this configuration file, see
# 
#     perldoc ttree
#     ttree -h
#
# NOTE: The directories specified below adopt the UNIX convention of
# specifying a user's home directory with the '~' character.  This
# feature may not be available on other platforms in which case you
# should specify the directory in entirety.
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# General options

# print summary of what's going on (-v)
verbose 

# recurse into any sub-directories and process files (-r)
recurse


#------------------------------------------------------------------------
# The 'cfg' option defines a directory in which other ttree configuration
# files can be found;  you can specify a file using the '-f' option,
# 'ttree -f myconfig' and the script will look for the file in this
# directory.  Alteratively, provide an absolute path as an argument,
# 'ttree -f /tmp/foo'.
# 
# By default, this option is commented out.  You will need to create a 
# directory, uncomment the following line and set the value appropriately.
# Having done that, you can then create files exactly like this in that
# location.

#cfg = ~/.ttree

#------------------------------------------------------------------------
# The remaining options define the default behaviour when you run ttree.
# This file is always processed before any file specified by '-f'.  If
# you define the 'src' and 'dest' options then these will be used by
# default.  Values for these options defined in files loaded with '-f'
# will override these default.  Other options such as 'lib', 'ignore',
# 'copy' and 'accept' are accumulative.

# The 'src' option defines the location of the template files that
# you want to process
src  = ~/websrc/public_html

# The 'dest' option specifies where the output should go.  The script
# compares the modification dates of files in the 'src' and 'dest'
# directories to work out which need to be processed. 
dest = ~/public_html

# 'lib' tells the processor (via INCLUDE_PATH) where to find any
# template files that may be INCLUDE'd.  You can specify many.
lib = ~/websrc/templates
lib = /usr/local/templates/lib

# Things that aren't templates and should be ignored, specified as Perl
# regexen.
ignore = \\b(CVS|RCS)\\b
ignore = ^#

# Things that should be copied rather than processed.
copy = \\.png\$ 
copy = \\.gif\$ 

# By default, everything not ignored or copied is accepted; add 'accept'
# lines if you want to filter further. e.g.
# accept = \\.html\$
# accept = \\.atml\$

END_OF_CONFIG

    close(CONFIG);
    print "$file created.  Please edit accordingly and re-run $NAME\n"; 
}


#------------------------------------------------------------------------
# help()
#
# Prints help message and exits.
#------------------------------------------------------------------------

sub help {
    print<<END_OF_HELP;
$NAME $VERSION (Template Toolkit version $Template::VERSION)

usage: $NAME [options] [files]

Options:
   -a      (--all)          Process all files, regardless of modification
   -r      (--recurse)      Recurse into sub-directories
   -p      (--preserve)     Preserve file ownership and permission
   -n      (--nothing)      Do nothing, just print summary (enables -v)
   -v      (--verbose)      Verbose mode
   -h      (--help)         This help
   -dbg    (--debug)        Debug mode
   -s DIR  (--src=DIR)      Source directory
   -d DIR  (--dest=DIR)     Destination directory
   -c DIR  (--cfg=DIR)      Location of configuration files
   -l DIR  (--lib=DIR)      Library directory (INCLUDE_PATH)  (multiple)
   -f FILE (--file=FILE)    Read named configuration file     (multiple)

File search specifications (all may appear multiple times):
   --ignore=REGEX           Ignore files matching REGEX
   --copy=REGEX             Copy files matching REGEX
   --accept=REGEX           Process only files matching REGEX 

Additional options to set Template Toolkit configuration items:
   --define var=value       Define template variable
   --interpolate            Interpolate '\$var' references in text
   --anycase                Accept directive keywords in any case.
   --pre_chomp              Chomp leading whitespace 
   --post_chomp             Chomp trailing whitespace
   --trim                   Trim blank lines around template blocks
   --eval_perl              Evaluate [% PERL %] ... [% END %] code blocks
   --load_perl              Load regular Perl modules via USE directive
   --pre_process=TEMPLATE   Add TEMPLATE as header for each file
   --post_process=TEMPLATE  Add TEMPLATE as footer for each file
   --process=TEMPLATE       Use TEMPLATE as wrapper around each file
   --default=TEMPLATE       Use TEMPLATE as default
   --error=TEMPLATE         Use TEMPLATE to handle errors
   --start_tag=STRING       STRING defines start of directive tag
   --end_tag=STRING         STRING defined end of directive tag
   --tag_style=STYLE        Use pre-defined tag STYLE    
   --plugin_base=PACKAGE    Base PACKAGE for plugins            
   --compile_ext=STRING     File extension for compiled template files
   --compile_dir=DIR        Directory for compiled template files
   --perl5lib=DIR           Specify additional Perl library directories

See 'perldoc ttree' for further information.  Note that earlier versions
of AppConfig (<1.53) may require options of the form '--name=opt' to be 
specified as '-name opt'.

END_OF_HELP

    exit(0);
}

__END__


#------------------------------------------------------------------------
# IMPORTANT NOTE
#   This documentation is generated automatically from source
#   templates.  Any changes you make here may be lost.
# 
#   The 'docsrc' documentation source bundle is available for download
#   from http://www.template-toolkit.org/docs.html and contains all
#   the source templates, XML files, scripts, etc., from which the
#   documentation for the Template Toolkit is built.
#------------------------------------------------------------------------

=head1 NAME

Template::Tools::ttree - Process entire directory trees of templates

=head1 SYNOPSIS

    ttree [options] [files]

=head1 DESCRIPTION

The F<ttree> script is used to process entire directory trees containing
template files.  The resulting output from processing each file is then 
written to a corresponding file in a destination directory.  The script
compares the modification times of source and destination files (where
they already exist) and processes only those files that have been modified.
In other words, it is the equivalent of 'make' for the Template Toolkit.

It supports a number of options which can be used to configure
behaviour, define locations and set Template Toolkit options.  The
script first reads the F<.ttreerc> configuration file in the HOME
directory, or an alternative file specified in the TTREERC environment
variable.  Then, it processes any command line arguments, including
any additional configuration files specified via the B<-f> (file) option.

A typical F<.ttreerc> file might look like this:

    src    = /home/abw/websrc/doc
    dest   = /home/abw/public_html
    lib    = /home/abw/websrc/lib
    lib    = /usr/local/templates/lib
    cfg    = /home/abw/.ttree
    ignore = \b(CVS|RCS)\b
    ignore = ^#
    copy   = \.(gif|png)$ 
    accept = \.[ah]tml$

The B<src> option indicates a directory containing the template files
to be processed.  A list of files may be specified on the command line
and each will be processed in turn, writing the generated output to a
corresponding file in the B<dest> directory.  If no files are
explicitly named then all files in the B<src> directory will be
processed.  The B<-r> (recurse) option will also cause sub-directories
to be searched for files.  A source file is only processed if it has a
later modification time than any corresponding destination file.
Files will always be processed, regardless of modification times, if
they are named explicitly on the command line, or the B<-a> (all)
option is used.

The B<lib> option may be specified any number of times to indicate
directories in which the Template Toolkit should look for other
template files (INCLUDE_PATH) that it may need to INCLUDE or PROCESS,
but don't represent complete documents that should be processed in
their own right (e.g. headers, footers, menu).  The B<cfg> directory
specifies the location of additional configuration files that may be
loaded via the B<-f> option.  

The B<ignore>, B<copy> and B<accept> options are used to specify Perl
regexen to filter file names.  Files that match any of the B<ignore>
options will not be processed.  Remaining files that match any of the
B<copy> regexen will be copied to the destination directory.  Remaining
files that then match any of the B<accept> criteria are then processed
via the Template Toolkit.  If no B<accept> parameter is specified then 
all files will be accepted for processing if not already copied or
 ignored.

Additional options may be used to set Template Toolkit parameters.
For example:

   interpolate        
   post_chomp         
   pre_process  = header
   post_process = footer
   perl5lib     = /home/abw/lib/perl5

See B<ttree --help> for a summary of options.

=head1 AUTHOR

Andy Wardley E<lt>abw@andywardley.comE<gt>

L<http://www.andywardley.com/|http://www.andywardley.com/>




=head1 VERSION

2.60, distributed as part of the
Template Toolkit version 2.09, released on 23 April 2003.

=head1 COPYRIGHT

  Copyright (C) 1996-2002 Andy Wardley.  All Rights Reserved.
  Copyright (C) 1998-2002 Canon Research Centre Europe Ltd.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<tpage|Template::Tools::tpage>
__END__
:endofperl
