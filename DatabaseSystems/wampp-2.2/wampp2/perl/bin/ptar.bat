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

use Archive::Tar;
use File::Find;

$switches = shift @ARGV;
$tarfile = "./default.tar";
$create=0;
$list=0;
$extract=0;
$debug=0;

if (!$switches) {
    print<<EOF;
usage: tar [xct][v][f][z] [archive_file] [files...]
    x    Extract from archive_file
    c    Make archive_file from files
    t    Print contents of archive_file
    f    First argument is name of archive_file, default is ./default.tar
    v    Print filenames as they are added to archive_file
    z    Read/write gnuzip-compressed archive_file (not always available)
EOF
    exit;
}

foreach (split(//,$switches)) {
    if ($_ eq "x") {
	$extract = 1;
    }
    elsif ($_ eq "t") {
	$list = 1;
    }
    elsif ($_ eq "c") {
	$create = 1;
    }
    elsif ($_ eq "z") {
	$compress = 1;
    }
    elsif ($_ eq "f") {
	$tarfile = shift @ARGV;
    }
    elsif ($_ eq "v") {
	$verbose = 1;
    }
    elsif ($_ eq "d") {
	$debug = 1;
    }
    elsif ($_ eq "-") {
	# Oh, a leading dash! How cute!
    }
    else {
	warn "Unknown switch: $_\n";
    }
}

if ($extract+$list+$create>1) {
    die "More than one of x, c and t doesn't make sense.\n";
}

if ($list) {
    $arc = Archive::Tar->new($tarfile,$compress);
    print join "\n", $arc->list_files,"";
}

if ($extract) {
    $arc = Archive::Tar->new($tarfile,$compress);
    $arc->extract($arc->list_files);
}

if ($create) {
    my @f;
    $arc = Archive::Tar->new();
    finddepth(sub {push (@f,$File::Find::name); print $File::Find::name,"\n" if $verbose},@ARGV);
    $arc->add_files(@f);
    $arc->write($tarfile,$compress);
}

__END__
:endofperl
