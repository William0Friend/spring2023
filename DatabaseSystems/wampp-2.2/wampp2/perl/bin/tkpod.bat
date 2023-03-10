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

use strict;
use vars qw($VERSION $tk_opt $tree $server $portfile $Mblib @I $debug);

$VERSION = substr(q$Revision: 1.20 $ , 10) + 1 . "";

use IO::Socket;

sub INIT {
    my $home = $ENV{'HOME'} || $ENV{'HOMEDRIVE'}.$ENV{'HOMEPATH'};
    $portfile = "$home/.tkpodsn";
    my $port = $ENV{'TKPODPORT'};
    return if $^C;
    unless (defined $port) {
	if (open(SN,"$portfile")) {
	    $port = <SN>;
	    close(SN);
	}
    }
    if (defined $port) {
	my $sock = IO::Socket::INET->new(PeerAddr => 'localhost',
					 PeerPort => $port, Proto => 'tcp');
	if ($sock) {
	    binmode($sock);
	    $sock->autoflush;
	    foreach my $file (@ARGV) {
		unless (print $sock "$file\n") {
		    die "Cannot print $file to socket: $!";
		}
		print "Requested '$file'\n";
	    }
	    $sock->close || die "Cannot close socket: $!";
	    exit(0);
	} else {
	    warn "Cannot connect to server on $port: $!";
	}
    }
}

use Tk;

# Experimental mousewheel support. This should really be part of Tk.
# XXX <MouseWheel> support for Windows is untested.
BEGIN {
    if ($Tk::VERSION < 804) {
	local $^W = 0;
	require Tk::Listbox;
	my $orig_tk_listbox_classinit = \&Tk::Listbox::ClassInit;
	*Tk::Listbox::ClassInit = sub {
	    my($class,$mw)=@_;
	    $orig_tk_listbox_classinit->(@_);
	    $mw->bind($class, "<4>", ['yview', 'scroll', -5, 'units']);
	    $mw->bind($class, "<5>", ['yview', 'scroll', +5, 'units']);
	    $mw->bind($class, '<MouseWheel>',
		      [ sub { $_[0]->yview('scroll',-($_[1]/120)*3,'units') }, Tk::Ev("D")]);
	};

	require Tk::ROText;
	my $orig_tk_text_classinit = \&Tk::ROText::ClassInit;
	*Tk::ROText::ClassInit = sub {
	    my($class,$mw)=@_;
	    $orig_tk_text_classinit->(@_);
	    $mw->bind($class, "<4>", ['yview', 'scroll', -5, 'units']);
	    $mw->bind($class, "<5>", ['yview', 'scroll', +5, 'units']);
	    $mw->bind($class, '<MouseWheel>',
		      [ sub { $_[0]->yview('scroll',-($_[1]/120)*3,'units') }, Tk::Ev("D")]);
	};

	require Tk::HList;
	my $orig_tk_hlist_classinit = \&Tk::HList::ClassInit;
	*Tk::HList::ClassInit = sub {
	    my($class,$mw)=@_;
	    $orig_tk_hlist_classinit->(@_);
	    $mw->bind($class, "<4>", ['yview', 'scroll', -5, 'units']);
	    $mw->bind($class, "<5>", ['yview', 'scroll', +5, 'units']);
	    $mw->bind($class, '<MouseWheel>',
		      [ sub { $_[0]->yview('scroll',-($_[1]/120)*3,'units') }, Tk::Ev("D")]);
	};
    }
}

### Problems under Windows... do not use it anymore
#BEGIN { eval { require Tk::FcyEntry; }; };
use Tk::Pod 4.18;
use Getopt::Long;
#require Tk::ErrorDialog;

my $mw = MainWindow->new();
eval 'use blib "/home/e/eserte/src/perl/Tk-App";require Tk::App::Debug';
$mw->withdraw;

$tree = 0;
#XXX Getopt::Long::Configure ("bundling");
if (!GetOptions("tk" => \$tk_opt,
		"tree" => \$tree,
		"notree" => sub { $tree = 0 },
		"s|server!" => \$server,
		"Mblib" => \$Mblib,
		"I=s@" => \@I,
		"d|debug!" => \$debug,
	       )) {
    die <<EOT;
Usage:	$0  [-tk] [[-no]tree] [-Mblib] [-I dir] [-d|debug] [-s|server]
            [directory|name [...]]

EOT
}

# Add 'Tk' subdirectories to search path so, e.g.,
# 'Scrolled' will find doc in 'Tk/Scrolled'
if ($tk_opt) {
   my $tkdir;
   foreach (reverse @INC) {
	$tkdir = "$_/Tk";
	unshift @ARGV, $tkdir if -d $tkdir;
   }
}

if ($debug) {
    $ENV{'TKPODDEBUG'} = $debug;
}

start_server() if $server;

# CDE use Font Settings if available
my $ufont = $mw->optionGet('userFont','UserFont');     # fixed width
my $sfont = $mw->optionGet('systemFont','SystemFont'); # proportional
if (defined($ufont) and defined($sfont)) {
    foreach ($ufont, $sfont) { s/:$//; };
    $mw->optionAdd('*Font',       $sfont);
    $mw->optionAdd('*Entry.Font', $ufont);
    $mw->optionAdd('*Text.Font',  $ufont);
}

if (0) { # XXX still decide
    my $lighter = $mw->Darken(Tk::NORMAL_BG, 110);
    foreach my $class (qw(Entry More*ROText Pod*Tree)) {
	$mw->optionAdd("*$class*background", $lighter, "userDefault");
    }
    $mw->optionAdd("*Pod*Pod*Frame*More*ROText*background", $lighter, "interactive");
}

$mw->optionAdd('*Menu.tearOff', $Tk::platform ne 'MSWin32' ? 1 : 0);

my @extra_dirs;
if (defined $Mblib) {
    # XXX better to use Tk::Pod->Dir? blib/scripts => Tk::Pod->ScriptDir?
    require blib;
    blib->import;
}
if (@I) {
    push @extra_dirs, @I;
}
Tk::Pod->Dir(@extra_dirs) if @extra_dirs;

if (!@ARGV)
 {
  if (!$tree)
   {
    push @ARGV, "perl";
   }
  else
   {
    my $tl = $mw->Pod(-tree => 1,
		      -exitbutton => 1);
   }
 }

my $file;
foreach $file (@ARGV)
 {
  if (-d $file)
   {
    Tk::Pod->Dir($file);
   }
  else
   {
    my $tl = $mw->Pod(-tree => $tree,
		      -exitbutton => 1);
    # -file => ... should be called after creating the Pod window,
    # because -title => ... is set implicitly by Pod's new
    $tl->configure(-file => $file);
   }
 }

# xxx dirty but it works. A simple $mw->destroy if $mw->children
# does not work because Tk::ErrorDialogs could be created.
# (they are withdrawn after Ok instead of destory'ed I guess)

if ($mw->children) {
    $mw->repeat(1000, sub {
        if (Tk::Exists($mw)) {
	    # ErrorDialog is withdrawn not deleted :-(
	    foreach ($mw->children) {
		return if "$_" =~ /^Tk::Pod/  # ->isa('Tk::Pod')
	    }
	    $mw->destroy;
	}
    });
} else {
    $mw->destroy;
}
$mw->WidgetDump if $ENV{TKPODDEBUG} && $ENV{TKPODDEBUG} >= 10;
MainLoop;
unlink($portfile);
exit(0);

sub start_server {
    my $sock = IO::Socket::INET->new(Listen => 5, Proto => 'tcp');
    die "Cannot open listen socket: $!" unless defined $sock;
    binmode($sock);

    my $port = $sock->sockport;
    $ENV{'TKPODPORT'} = $port;
    open(SN,">$portfile") || die "Cannot open $portfile: $!";
    print SN $port;
    close(SN);
    print STDERR "Accepting connections on $port\n";
    $mw->fileevent($sock,'readable',
		   sub {
		       print STDERR "accepting $sock\n";
		       my $client = $sock->accept;
		       if (defined $client) {
			   binmode($client);
			   print STDERR "Connection $client\n";
			   $mw->fileevent($client,'readable',[\&PodRequest,$client]);
		       }
		   });
    $SIG{TERM} = \&server_cleanup;
}

sub server_cleanup {
    unlink $portfile if -e $portfile;
}

sub PodRequest {
    my($client) = @_;
    local $_;
    while (<$client>) {
	chomp($_);
	print STDERR "'$_'\n";
	my $pod = $mw->Pod(-tree => $tree,
			   -exitbutton => 1);
	$pod->configure(-file => $_);
    }
    warn "Odd $!" unless eof($client);
    $mw->fileevent($client,'readable','');
    print STDERR "Close $client\n";
    $client->close;
}

__END__

=head1 NAME

tkpod - Perl/Tk Pod browser

=head1 SYNOPSIS

    tkpod  [-tk] [[-no]tree] [-Mblib] [-I dir] [-d|debug] [-s|server]
            [directory|name [...]]


=head1 DESCRIPTION

B<tkpod> is a simple Pod browser with hypertext capabilities.
Pod (L<Plain Old Document|perlpod>) is a simple and readable
markup language that could be mixed with L<perl> code.

Pods are searched by default in C<@INC> and C<$ENV{PATH}>. Directories
listed on the command line or with the B<-I> option are added to the
default search path.

For each C<name> listed on the command line B<tkpod> tries to
to find Pod in C<name, name.pod> and C<name.pm> in the search
path.  For each C<name> a new Pod browser window is opened.

If no C<name> is listed, then the main C<perl> pod is opened instead.

=head1 OPTIONS

=over 4

=item B<-tree>

When specified, C<tkpod> will show a tree window with all available
Pods on the local host. However, this may be slow on startup,
especially first time because there is no cache yet. You can always
turn on the tree view with the menu entry 'View' -E<gt> 'Pod Tree'.

=item B<-tk>

Useful for perl/Tk documentation.  When specified it adds all
C<Tk> subdirectories in C<@INC> to the Pod search path.   This way
when C<Scrolled> is selected in the browser the C<Tk/Scrolled>
documentation is found.

=item B<-s> or B<-server>

Start C<tkpod> in server mode. Subsequent calls to C<tkpod> (without
the B<-s> option) will cause to load the requested Pods into the
server program, thus minimizing startup time and memory usage. Note
that there is no access control, so this might be a security hole!

=item B<-d> or B<-debug>

Turn debugging on.

=item B<-Mblib>

Add the C<blib> directories under the current directory to the Pod
search path.

=item B<-I> I<dir>

Add another directory to the Pod search path. Note that the space is
mandatory.

=back


=head1 USAGE

How to navigate with the Pod browser is described in L<Tk::Pod_usage>.
It's also accessible via the menu 'Help' -> 'Usage...'.


=head1 KNOWN BUGS

see L<Tk::Pod::Text>

=head1 SEE ALSO

L<perlpod|perlpod>
L<pod2man|pod2man>
L<pod2text|pod2text>
L<pod2html|pod2html>
L<Tk::Pod|Tk::Pod>
L<Tk::Pod::Text|Tk::Pod::Text>
L<Tk::Pod::Tree|Tk::Pod::Tree>

=head1 AUTHOR

Nick Ing-Simmons <F<nick@ni-s.u-net.com>>

Former maintainer: Achim Bohnet <F<ach@mpe.mpg.de>>.

Code currently maintained by Slaven Rezic <F<slaven@rezic.de>>.

Copyright (c) 1997-1998 Nick Ing-Simmons.  All rights reserved.  This program
is free software; you can redistribute it and/or modify it under the same
terms as Perl itself.

=cut


__END__
:endofperl
