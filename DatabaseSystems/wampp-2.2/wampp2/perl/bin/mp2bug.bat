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
#!perl
#line 15

use strict;
use warnings FATAL => 'all';

use FindBin;

use constant IS_MOD_PERL_BUILD => -e "$FindBin::Bin/../lib/mod_perl.pm";

if (IS_MOD_PERL_BUILD) {
    unshift @INC, "$FindBin::Bin/../lib";
}
else {
    eval { require Apache2 };
    if ($@) {
        die "This script requires mod_perl 2.0\n", "$@";
    }
}

require Apache::TestReportPerl;
Apache::TestReportPerl->new(@ARGV)->run;

__END__
:endofperl
