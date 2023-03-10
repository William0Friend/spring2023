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
$perl_version = '5.8.0';


=head1 NAME

ysh - The YAML Test Shell

=head1 SYNOPSIS

 ysh [options]

=head1 DESCRIPTION

This program is designed to let you play with the YAML.pm module in
an interactive way. When you to type in Perl, you get back YAML. And
vice versa.

By default, every line you type is a one line Perl program, the return
value of which will be displayed as YAML.

To enter multi-line Perl code start the first line with ';' and use as
many lines as needed. Terminate with a line containing just ';'.

To enter YAML text, start with a valid YAML separator/header line
which is typically '---'. Use '===' to indicate that there is no YAML
header. Enter as many lines as needed. Terminate with a line
containing just '...'.

To read in and process an external YAML file, enter '< filename'. The
ysh will also work as a standalone filter. It will read anything on
STDIN as a YAML stream and write the Perl output to STDOUT. You can say
(on most Unix systems):

    cat yaml.file | ysh | less

=head1 COMMAND LINE OPTIONS

=over 4

=item -l

Keep a log of all ysh activity in './ysh.log'. If the log file already
exists, new content will be concatenated to it.

=item -L

Keep a log of all ysh activity in './ysh.log'. If the log file already
exists, it will be deleted first.

=item -r

Test roundtripping. Every piece of Perl code entered will be Dumped,
Loaded, and Dumped again. If the two stores do not match, an error
message will be reported.

=item -R

Same as above, except that a B<confirmation> message will be printed
when the roundtrip succeeds.

=item -i<number>

Specify the number of characters to indent each level. This is the same
as setting $YAML::Indent.

=item -ub

Shortcut for setting '$YAML::UseBlock = 1'. Force multiline scalars to
use 'block' style.

=item -uf

Shortcut for setting '$YAML::UseFold = 1'. Force multiline scalars to
use 'folded' style.

=item -uc

Shortcut for setting '$YAML::UseCode = 1'. Allows subroutine references
to be processed.

=item -nh

Shortcut for setting '$YAML::UseHeader = 0'.

=item -nv

Shortcut for setting '$YAML::UseVersion = 0'.

=item -v

Print the versions of ysh and YAML.pm.

=item -V

In addition to the -v info, print the versions of YAML related modules.

=item -h

Print a help message.

=back

=head2 YSH_OPT

If you don't want to enter your favorite options every time you enter
ysh, you can put the options into the C<YSH_OPT> environment variable.
Do something like this:

    export YSH_OPT='-i3 -uc -L'

=head1 SEE ALSO

L<YAML>

=head1 AUTHOR

Brian Ingerson <ingy@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2001, 2002. Brian Ingerson. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut

use strict;

use Term::ReadLine;
sub Term::ReadLine::Perl::Tie::FIRSTKEY {undef}
use YAML;
use Data::Dumper;
$Data::Dumper::Indent = 1;
use vars qw($prompt);
$prompt = 'ysh > ';
my $round_trip = 0;
my $force = 0;
my $log = 0;
$| = 1;
my @env_args = split /\s+/, ($ENV{YSH_OPT} || '');
my @args = (@env_args, @ARGV);
my $stream = -t STDIN ? '' : join('', <STDIN>);

while (my $arg = shift @args) {
    handle_help(), exit if $arg eq '-h';
    handle_version(), exit if $arg eq '-v';
    handle_Version(), exit if $arg eq '-V';
    $YAML::Indent = $1, next if $arg =~ /^-i(\d+)$/;
    $YAML::UseFold = 1, next if $arg eq '-uf';
    $YAML::UseBlock = 1, next if $arg eq '-ub';
    $YAML::UseCode = 1, next if $arg eq '-uc';
    $YAML::UseHeader = 0, next if $arg eq '-nh';
    $YAML::UseVersion = 0, next if $arg eq '-nv';
    $round_trip = 1, next if $arg eq '-r';
    $round_trip = 2, next if $arg eq '-R';
    $log = 1, next if $arg eq '-l';
    $log = 2, next if $arg eq '-L';
    $force = 1, next if $arg eq '-F';
    warn(<<END), exit; 
Unknown YAML Shell argument: '$arg'.
For help, try: perldoc ysh
END
}

check_install() unless $force;

if ($log) {
    if ($log == 2) {
        open LOGFILE, "> ./ysh.log" or die $!;
    }
    else {
        open LOGFILE, ">> ./ysh.log" or die $!;
    }
    print LOGFILE "\nYAML.pm Version $YAML::VERSION\n";
    print LOGFILE "Begin logging at ", scalar localtime, "\n\n";
}

sub Print {
    print @_;
    print LOGFILE @_ if $log;
}
local $SIG{__WARN__} = sub { Print @_ };

if (not length($stream)) {
    Print <<END;
Welcome to the YAML Test Shell. Type ':help' for more information.

END
}

{
    my $sh;
    {
        local @ENV{qw(HOME EDITOR)};
        local $^W;
        $sh = Term::ReadLine::->new('The YAML Shell');
    }

    sub my_readline {
        print LOGFILE $prompt if $log;
	my $input = $sh->readline($prompt);
	if (not defined $input) {
	    $input = ':exit';
	    Print "\n";
	}
	$input .= "\n";
    }
}

if (length($stream)) {
    my @objects;
    eval { @objects = YAML::Load($stream) };
    if ($@) {
        print STDERR $@;
    }
    else {
        print STDOUT Data::Dumper::Dumper(@objects);
    }
    exit 0;
}
 
while ($_ = my_readline()) {
    print LOGFILE $_ if $log;
    next if /^\s*$/;
    exec('ysh', @ARGV) if /^\/$/;
    handle_command($_),next if /^:/;
    handle_file($1),next if /^<\s*(\S+)\s*$/;
    handle_yaml($_),next if /^--\S/;
    handle_yaml(''),next if /^===$/;
    handle_perl($_,1),next if /^;/;
    handle_perl($_,0),next;
    Print "Unknown command. Type ':help' for instructions.\n";
}

sub handle_file {
    my ($file) = @_;
    my @objects;
    eval { @objects = YAML::LoadFile($file) };
    if ($@) {
        Print $@;
    }
    else {
        Print Data::Dumper::Dumper(@objects);
    }
}
    
sub handle_perl {
    my ($perl, $multi) = @_;
    my (@objects, $yaml, $yaml2);
    local $prompt = 'perl> ';
    my $line = '';
    if ($multi) {
        while ($line !~ /^;$/) {
            $line = my_readline();
            print LOGFILE $line if $log;
            $perl .= $line;
        }
    }
    @objects = eval "no strict;$perl";
    Print("Bad Perl expression:\n$@"), return if $@;
    eval { $yaml = Dump(@objects) };
    $@ =~ s/^ at.*\Z//sm if $@;
    Print("Dump failed:\n$@"), return if $@;
    Print $yaml;
    if ($round_trip) {
        {
            local $SIG{__WARN__} = sub {};
            eval { $yaml2 = Dump(Load($yaml)) };
        }
        $@ =~ s/^ at.*\Z//sm if $@;
        Print("Load failed:\n$@"), return if $@;
        if ($yaml eq $yaml2) {
            if ($round_trip > 1) {
                Print "\nData roundtripped OK!!!\n";
            }
        }
        else {
            Print "================\n";
            Print "after roundtrip:\n";
            Print "================\n";
            # $yaml2 =~ s/ /_/g;  #
            # $yaml2 =~ s/\n/+/g; #
            # Print $yaml2, "\n"; #
            Print $yaml2;
            Print "=========================\n";
            Print "Data did NOT roundtrip...\n";
        }
    }
}

sub handle_yaml {
    my $yaml = shift;
    my $line = $yaml;
    my (@objects);
    local $prompt = 'yaml> ';
    $line = my_readline();
    print LOGFILE $line if $log;
    $line = '' unless defined $line;
    while ($line !~ /^\.{3}$/) {
        $yaml .= $line;
        $line = my_readline();
        print LOGFILE $line if $log;
        last unless defined $line;
    }
    $yaml =~ s/\^{2,8}/\t/g;
    eval { @objects = Load($yaml) };
    $@ =~ s/^ at.*\Z//sm if $@;
    $@ =~ s/^/  /gm if $@;
    Print("YAML Load Failed:\n$@"), return if $@;
    Print Data::Dumper::Dumper(@objects);
}

sub handle_command {
    my $line = shift;
    chomp $line;
    my ($cmd, $args);
    if ($line =~ /^:(\w+)\s*(.*)$/) {
        $cmd = $1;
        $args = $2;
        exit if $cmd =~ /^(exit|q(uit)?)$/;
        handle_help(),return if $cmd eq 'help';
        print `clear`,return if $cmd =~ /^c(lear)?$/;
    }
    Print "Invalid command\n";
}

sub handle_help {
    Print <<END;
                      Welcome to the YAML Test Shell.

   When you to type in Perl, you get back YAML. And vice versa.

   By default, every line you type is a one line Perl program, the
   return value of which will be displayed as YAML.

   To enter multi-line Perl code start the first line with ';' and use
   as many lines as needed. Terminate with a line containing just ';'.

   To enter YAML text, start with a valid YAML separator/header line
   which is typically '---'. Use '===' to indicate that there is no YAML
   header. Enter as many lines as needed. Terminate with a line
   containing just '...'.

   Shell Commands:             (Begin with ':')
      :exit or :q(uit) - leave the shell
      :help - get this help screen

END
}

sub check_install {
    if (-f "./YAML.pm" && -f "./pm_to_blib" &&
        -M "./YAML.pm" <  -M "./pm_to_blib"
       ) {
        die "You need to 'make install'!\n";
    }
}

sub handle_version {
    print STDERR <<END;

ysh: '$main::VERSION'
YAML: '$YAML::VERSION'

END
}

sub handle_Version {
    my $TRP = get_version('Term::ReadLine::Perl');
    my $TRG = get_version('Term::ReadLine::Gnu');
    my $POE = get_version('POE');
    my $TO = get_version('Time::Object');

    print STDERR <<END;

ysh: '$main::VERSION'
YAML: '$YAML::VERSION'
perl: '$main::perl_version'
Data::Dumper: '$Data::Dumper::VERSION'
Term::ReadLine::Perl: '$TRP'
Term::ReadLine::Gnu: '$TRG'
POE: '$POE'
Time::Object: '$TO'

END
}

sub get_version {
    my ($module) = @_;
    my $version;
    eval "no strict; use $module; \$version = \$${module}::VERSION";
    #$version = "$@" if $@;
    $version = "not installed" if $@;
    return $version;
}

1;

__END__
:endofperl
