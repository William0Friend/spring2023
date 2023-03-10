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
# tpage
#
# DESCRIPTION
#   Script for processing and rendering a template document using the 
#   Perl Template Toolkit. 
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
# $Id: tpage,v 2.54 2002/11/07 15:36:55 darren Exp $
#
#========================================================================

use strict;
use Template;

# look for -h or --help option, print usage and exit
if (grep /^--?h(elp)?/, @ARGV) {
    print "usage: tpage file [ file [...] ]\n";
    exit 0;
}
my $vars = { };
my ($var, $val);

while ($ARGV[0] && $ARGV[0] =~ /^--?d(efine)?/) {
    shift(@ARGV);
    die "--define expect a 'variable=value' argument\n" 
	unless defined ($var = shift(@ARGV));
    ($var, $val) = split(/\s*=\s*/, $var, 2);
    $vars->{ $var } = $val;
}

# read from STDIN if no files specified
push(@ARGV, '-') unless @ARGV;

# create a template processor 
my $template = Template->new({
    ABSOLUTE => 1,
    RELATIVE => 1,
});

# process each input file 
foreach my $file (@ARGV) {
    $file = \*STDIN if $file eq '-';
    $template->process($file, $vars)
	|| die $template->error();
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

Template::Tools::tpage - Process templates from command line

=head1 USAGE

    tpage [ --define var=value ] file(s)

=head1 DESCRIPTION

The B<tpage> script is a simple wrapper around the Template Toolkit processor.
Files specified by name on the command line are processed in turn by the 
template processor and the resulting output is sent to STDOUT and can be 
redirected accordingly.  e.g.

    tpage myfile > myfile.out
    tpage header myfile footer > myfile.html

If no file names are specified on the command line then B<tpage> will read
STDIN for input.

The C<--define> option can be used to set the values of template variables.
e.g.

    tpage --define author="Andy Wardley" skeleton.pm > MyModule.pm

See L<Template> for general information about the Perl Template 
Toolkit and the template language and features.

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

L<ttree|Template::Tools::ttree>
__END__
:endofperl
