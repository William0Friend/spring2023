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

=head1 NAME

pfunc - grep for perl functions

=head1 SYNOPSIS

    pfunc subroutine FILES...

=head1 DESCRIPTION

B<pfunc> searches the named FILES for all calls to the given
subroutine.  It will report back the file and line number each call is
found on along with what sort of call it is

    function            foo()
    class method        Class->foo()
    object method       $obj->foo()

=head1 EXAMPLE

    $ pfunc isa /usr/share/perl/5.6.1/*.pm
    Called as function in /usr/share/perl/5.6.1/CGI.pm at line 316
    Called as function in /usr/share/perl/5.6.1/CGI.pm at line 327
    Called as function in /usr/share/perl/5.6.1/CGI.pm at line 397
    Called as function in /usr/share/perl/5.6.1/CGI.pm at line 494
    Called as function in /usr/share/perl/5.6.1/CGI.pm at line 495
    Called as object method in /usr/share/perl/5.6.1/CPAN.pm at line 4957
    Called as function in /usr/share/perl/5.6.1/Dumpvalue.pm at line 191
    Called as function in /usr/share/perl/5.6.1/Dumpvalue.pm at line 218
    Called as function in /usr/share/perl/5.6.1/Dumpvalue.pm at line 248
    Called as function in /usr/share/perl/5.6.1/Dumpvalue.pm at line 251
    Called as function in /usr/share/perl/5.6.1/Dumpvalue.pm at line 254
    Called as object method in /usr/share/perl/5.6.1/Shell.pm at line 28
    Called as object method in /usr/share/perl/5.6.1/base.pm at line 12

=head1 NOTES

Its not fast, but its accurate.

=head1 AUTHOR

Michael G Schwern <schwern@pobox.com>

=head1 SEE ALSO

L<Module::Info>


=cut

$| = 1;

use Module::Info;

my $func = shift;
foreach my $file (@ARGV) {
    my $mod = Module::Info->new_from_file($file);
    unless( $mod ) {
        warn "Can't find $file\n";
        next;
    }
    my @calls = sort { $a->{line} <=> $b->{line} }
                grep { defined $_->{name} and $_->{name} eq $func }
                     $mod->subroutines_called;
    foreach my $call (@calls) {
        my $as = $call->{type} =~ /class method/ 
                     ? "$call->{type} via $call->{class}"
                     : $call->{type};
        printf "Called as %s in %s at line %d\n",
               $as, $file, $call->{line}
    }
}
    

__END__
:endofperl
