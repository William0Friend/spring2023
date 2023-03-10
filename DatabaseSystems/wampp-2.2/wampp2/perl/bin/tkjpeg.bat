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
#!/usr/local/bin/perl -w
#line 15
use strict;
use Tk;
use Tk::JPEG;
use Getopt::Std;
eval { require Tk::PNG; };

my $mw  = MainWindow->new();
print "vis=",$mw->visual," d=",$mw->depth,"\n";
my ($vis) = grep(!/\b8\b/,grep(/truecolor/,$mw->visualsavailable));
my @args = ();
if ($vis)
 {
  print $vis,"\n";
  $mw->destroy;
  $mw = MainWindow->new(-visual => $vis);
 }
else
 {
  @args = (-palette => '4/4/4');
 }
# print "vis=",$mw->visual," d=",$mw->depth,' "',join('" "',$mw->visualsavailable),"\"\n";
my %opt;
getopts('f:',\%opt);
if ($opt{'f'})
 {
  push(@args,'-format' => $opt{'f'});
 }
unless (@ARGV)
 {
  warn "usage $0 [-f format] <imagefile>\n";
  exit 1;
 }
my $file = shift;
my $image = $mw->Photo(-file => $file, @args);
#print join(' ',$image->formats),"\n";
print "w=",$image->width," h=",$image->height,"\n";
$mw->Label(-image => $image)->pack(-expand => 1, -fill => 'both');
$mw->Button(-text => 'Quit', -command => [destroy => $mw])->pack;
MainLoop;

__END__

=head1 NAME

tkjpeg - simple JPEG viewer using perl/Tk

=head1 SYNOPSIS

  tkjpeg imagefile.jpg

=head1 DESCRIPTION

Very simplistic image viewer that loads JPEG image, and puts it into a
Label for display.

=head1 AUTHOR

Nick Ing-Simmons <nick@ni-s.u-net.com>

=cut



__END__
:endofperl
