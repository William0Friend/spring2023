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
use HTTP::GHTTP;
use Getopt::Long;
$|=1;
use strict;
use vars qw/$VERSION/;

$VERSION = '1.0';

my @getopt_args = qw(
        p=s  P   H=s@   u   U
        s    e      d   v
        h    V
        );

my %options;

Getopt::Long::config("noignorecase", "bundling");
unless (GetOptions(\%options, @getopt_args)) {
    usage();
}

if ($options{V}) {
    print <<EOT;
This is g-request version $VERSION

Copyright 2000, AxKit.com Ltd

EOT
}

usage() if $options{h} || !@ARGV;

$options{u} = 1 if $options{U};

unless($options{P}) {
    $options{p} ||= $ENV{http_proxy};
}

my $r = HTTP::GHTTP->new();

$r->set_header(Connection => 'close');

for my $extra_header (@{ $options{H} || [] }) {
    my ($name, $value) = split /:\s*/, $extra_header, 2;
    $r->set_header($name, $value);
}

$r->set_proxy($ENV{http_proxy}) if $ENV{http_proxy} && !$options{P};
$r->set_proxy($options{p}) if $options{p};

my $URI = shift @ARGV;

$r->set_uri($URI);

$r->process_request();

if ($options{e}) {
    eval {
        my @headers = $r->get_headers;
        print join("\n", map { "$_: " . $r->get_header($_) } @headers), "\n\n";
    };
    if ($@) {
        warn $@, "\n", "get_headers (and thus -e) only available in libghttp 1.08 and higher";
    }
}

unless ($options{d}) {
    print $r->get_body();
}

sub usage {
    print <<EOT;
Usage: g-request [-options] <url>
    -p <proxy>    Use this as a proxy server
    -P            Don't pick up proxy settings from environment
    -H <header>   Send this HTTP header (you can specify several)
    -u            Display method and URL before any response
    -U            Display request headers (implies -u)
    -s            Display response status code
    -e            Display response headers
    -d            Do not display content
    -v            Be verbose
    -h            Print this help message
    -V            Show program version
EOT
    exit; #'
}

exit(0);

__END__
:endofperl
