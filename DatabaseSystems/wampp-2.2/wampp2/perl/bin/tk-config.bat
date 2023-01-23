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
#!/Perl/bin/perl.exe
#line 15
use Tk;
use CPAN;
use strict;
require Tk::Dialog;
require Tk::ErrorDialog;
use Win32::FileOp;
use Tk::LabEntry;
use Cwd;
use FindBin qw($Bin);
require File::Spec;
use File::Find;
use Win32::Process;
use Win32;
use Win32::Shortcut;
require File::Spec;
use File::Path;
use Tk::Balloon;
#use Pod::HTML;
#use HTML::Parser;
require LWP::Simple; import LWP::Simple qw(getstore);

use vars qw($html $cpan $perl_dir $apache_dir $start
        $title $tmp $user $host $email);

my $error;
my $shell = $ENV{ComSpec};
my $get_nmake = 'get_nmake.bat';
my $cpan_conf = 'cpanconf.bat';
my $make_html = 'make_html.bat';

my ($pv, $av, $phpv, $mpv, $osv) = 
  ('5.8.0', '2.0.45', '4.3.2-RC2', '1.99_10', '0.9.7b');
my $apache = 'Apache2';

my $label = qq{Perl/$pv Apache/$av mod_perl/$mpv openSSL/$osv PHP/$phpv};

my $mw = MainWindow->new;
$mw->title('Configure');
$cpan =  1;
$html =  1;
$start =  1;
my @path_ext = ();
path_ext();

($perl_dir = $Bin) =~ s!/bin!!;;
($apache_dir = $perl_dir) =~ s!Perl!$apache!;
$tmp = $ENV{TEMP} || $ENV{TMP};
$tmp = Win32::GetShortPathName($tmp);

my $is_win95 = Win32::IsWin95();
$user = ($is_win95 ? '' : Win32::LoginName()) || $ENV{USERNAME} 
  || 'Administrator';
$host = ($is_win95 ? '' : Win32::DomainName()) || $ENV{USERDOMAIN}
  || 'localhost';
(my $user_no_spaces = $user) =~ s! !!g;
$email = $user_no_spaces . '@' . $host;

my $title = $mw->Label(-text => "Configure the Perl/$apache Win32 binary")
  ->grid(-row => 0, -columnspan => 4);

my $b = $mw->Balloon();

my $perl_en = $mw->LabEntry(-textvariable => \$perl_dir,
                -label => 'Perl directory: ',
                -width => 22,
                -labelPack => [-side=>'left'])
  ->grid(-padx => 10, -pady => 5, -row => 1, -column => 0,
     -columnspan => 2, -sticky => 'e');
help_msg($perl_en, 'Perl installation directory');

my $perl_br = $mw->Button(-text => 'Browse',
              -command => [\&dir, 'perl'],
             )
  ->grid(-padx => 10, -pady => 5, -row => 1, -column => 2, 
     -columnspan => 2, -sticky => 'w');
help_msg($perl_br, 'Browse for the Perl installation directory');

my $apache_en = $mw->LabEntry(-textvariable => \$apache_dir,
                  -label => "$apache directory: ",
                  -width => 22,
                  -labelPack => [-side=>'left'])
  ->grid(-padx => 10, -pady => 5, -row => 2,  -column => 0,
     -columnspan => 2, -sticky => 'e');
help_msg($apache_en, "$apache installation directory");

my $apache_br = $mw->Button(-text => 'Browse',
                -command => [\&dir, 'apache'],
               )
  ->grid(-padx => 10, -row => 2, 
     -columnspan => 2, -column => 2, -sticky => 'w');
help_msg($apache_br, "Browse for the $apache installation directory");

my $user_en = $mw->LabEntry(-textvariable => \$user,
                -label => 'User name: ',
                -width => 20,
                -labelPack => [-side=>'left'])
  ->grid(-padx => 5, -pady => 5, -row => 3, -column => 0,
     -columnspan => 2, -sticky => 'e');
help_msg($user_en, 'Your user name');

my $host_en = $mw->LabEntry(-textvariable => \$host,
                -label => 'Hostname: ',
                -width => 25,
                -labelPack => [-side=>'left'])
  ->grid(-padx => 5, -pady => 5, -row => 4, -column => 0,
     -columnspan => 2, -sticky => 'e');
help_msg($host_en, 'Your host name');

my $email_en = $mw->LabEntry(-textvariable => \$email,
                 -label => 'email: ',
                 -width => 30,
                 -labelPack => [-side=>'left'])
  ->grid(-padx => 5, -pady => 5, -row => 5, -column => 0,
     -columnspan => 2, -sticky => 'e');
help_msg($email_en, 'Your email address');

my $cb_html = $mw->Checkbutton(-text => 'Build html docs',
                   -variable => \$html,
                   -onvalue => 1,
                   -offvalue => 0,
                  )
  ->grid(-padx => 5, -pady => 5,
     -row => 3, -column => 2, -sticky => 'w');
help_msg($cb_html, 'Build and install available Perl html documentation');

my $cb_cpan = $mw->Checkbutton(-text => 'Configure CPAN.pm',
                   -variable => \$cpan,
                   -onvalue => 1,
                   -offvalue => 0,
                  )
  ->grid(-padx => 5, -pady => 5,
     -row => 4, -column => 2, -sticky => 'w');
help_msg($cb_cpan, 'Configure the CPAN.pm module for building CPAN modules');

my $cb_start = $mw->Checkbutton(-text => 'Add Shortcuts',
                -variable => \$start,
                -onvalue => 1,
                -offvalue => 0,
                   )
  ->grid(-padx => 5, -pady => 5,
     -row => 5, -column => 2, -sticky => 'w');
help_msg($cb_start, 'Add shortcuts to the Start Menu');

my $help_syn = $mw->Button(-text => 'Help',
               -command => [\&help],
              )
  ->grid(-padx => 5, -row => 2, -pady => 5,
     -column => 3, -sticky => 'w');
help_msg($help_syn, 'Display a brief help message');

my $brief = $mw->Button(-text => 'Readme',
            -command => [\&tkreadme, '../install.txt'],
               )
  ->grid(-padx => 5, -row => 3, -pady => 5,
     -column => 3, -sticky => 'w');
help_msg($brief, 'Display the short README file');

my $configure = $mw->Button(-text => 'Configure',
                -command => [\&configure],
               )
  ->grid(-row => 7, -pady => 10,
     -column => 1, -sticky => 'w');
help_msg($configure, 'Start the configuration');

my $exit = $mw->Button(-text => 'Exit',
               -command => [$mw => 'destroy'],
              )
  ->grid(-row => 7, -pady => 10,
     -column => 2, -sticky => 'e');
help_msg($exit, 'Quit Configure');

MainLoop;

sub configure {
  $perl_dir = trim($perl_dir);
  $perl_dir = Win32::GetShortPathName($perl_dir) if ($perl_dir =~ / /);
  unless (-d $perl_dir) {
    dialog_error('Perl configuration failed', 
         qq{Cannot find "$perl_dir": $!.});
    return;
  }
  unless (-d "$perl_dir/bin") {
    dialog_error('Perl configuration failed',
         qq{Please give the top-level Perl directory.});
    return;
  }
  
  $apache_dir = trim($apache_dir);
  $apache_dir = Win32::GetShortPathName($apache_dir) if ($apache_dir =~ / /);
  unless (-d $apache_dir) {
    dialog_error('Apache configuration failed',
         qq{Cannot find "$apache_dir": $!});
    return;
  }
  unless (-d "$apache_dir/bin") {
    dialog_error('Apache configuration failed',
         qq{Please give the top-level $apache directory.});
    return;
  }
  
  $email = trim($email);
  $host = trim($host);
  $user = trim($user);
  
  configure_apache() or do {
    dialog_error("$apache configuration failed",
		 "Failed to configure $apache.");
    return;
  };
  
  configure_perl() or do {
    dialog_error('Perl configuration failed',
		 qq{Failed to configure Perl.});
    return;
  };
  
  unless ($perl_dir eq 'C:/Perl') {
    configure_cgi() or do {
      return unless dialog_proceed('Apache CGI configuration failed',
                   qq{Failed to configure CGI.});
    };
  }
  
  if ($start) {
    add_start() or do {
      return unless dialog_proceed('Adding shortcuts failed', 
                   qq{Failed to add shortcuts.});
    };
  }

  if ($html) {
    install_html() or do {
      return unless dialog_proceed('HTML build error', 
                   qq{The HTML docs were not built.});
    };
  }
  if ($cpan) {
    configure_cpan() or do {
      return unless dialog_proceed('CPAN config error',
                   qq{The CPAN.pm module was not configured.});
    };
  }
  configure_end();
}

sub help {
  my $message = <<"END";

Verify, and change if needed, the top-level Perl and $apache 
installation directories (eg, D:\\Perl and D:\\$apache)

Verify your name, hostname, and email address.

Select whether or not to install the html documentation
and to configure the CPAN.pm module. Also choose whether
or not to add some shortcuts (documentation, and certain
program utilities) to the Start Menu.

If the directories are not yet in their final locations,
exit the configuration script, move the directories, and
run this script again (in the Perl bin/ directory).

Versions:
$label

END
  
  dialog_help('Help', $message);
}

sub configure_apache {
  for my $file (qw(httpd ssl perl)) {
    my $conf = $apache_dir . '/conf/' . $file . '.conf';
    my %subs = ("C:/$apache" => $apache_dir, 'C:/Windows/Temp' => $tmp,
		'@@ServerAdmin@@' => $email, localhost => $host,
		'C:/Perl' => $perl_dir);
    edit($conf, \%subs) or return;
  }
  return 1 if ($apache eq 'Apache');
  my $handler_dir = $perl_dir . '/site/lib/Apache2/Apache';
  for my $file( 'MyHandler.pm', 'MyTTHandler.pm') {
    my $handler = $handler_dir . '/' . $file;
    my %subs = ("C:/$apache" => $apache_dir, 'C:/Windows/Temp' => $tmp);
    edit($handler, \%subs) or return;
  }
  return 1;
}

sub configure_perl {
  my $dir = $perl_dir;
  (my $windir = $dir) =~ s!/!\\!g;
  (my $win2dir = $windir) =~ s!\\!\\\\!g;
  my $ppm = $dir . '/site/lib/ppm.xml';
  my %tmp = ('C:\WINDOWS\Temp' => $tmp, 'C:\Perl' => $windir);
  edit($ppm, \%tmp) or return;

  my $h = $dir . '/lib/CORE/config.h';
  my %h = ('C:\\\\Perl' => $win2dir);
  edit($h, \%h) or return;

  my $conf = $dir . '/lib/Config.pm';
  my %subs = ('C:\Perl' => $windir, 
          'randy\@theoryx5.uwinnipeg.ca' => $email,
          'Randy Kobes' => $user);
  my @progs = qw(awk grep tar gzip zip nmake);
  my %progs;
  foreach (@progs) {
    $progs{$_} = 1 if which($_);
  }
  unless ($progs{nmake}) {
    my $message = <<"END";
I couldn\'t find "nmake" on your system. This program
is needed to build modules from CPAN sources.
  
Do you want me to fetch and install nmake?.
END

    if (dialog_yes_no('Get nmake?', $message)) {
      if (fetch_nmake()) {
    $progs{nmake} = 1;
    dialog_help('Success', 'Installation of "nmake" succeeded');
      }
      else {
    dialog_error('nmake installation failed', 
             qq{Could not get or install "nmake".});
      }
    }
  }
  foreach (@progs) {
    if ($_ eq 'nmake') {
      $subs{"make='nmake'"} = $progs{nmake} ? 
    "make='nmake'" : "make=''";
    }
    else {
      $subs{"$_='$_'"} = $progs{$_} ? 
    "$_='$_'" : "$_=''";
    }
  }
  return edit($conf, \%subs);
}

sub fetch_nmake {
  return launch($get_nmake);
}

sub configure_cgi {
  my $cgi = $apache_dir . '/cgi-bin';
  my $perl_bin = $perl_dir . '/bin/perl.exe';
  my @files = ();
  finddepth(sub {next unless $File::Find::name =~ m!\.cgi$!;
         push @files, $File::Find::name;}, $cgi);
  my %sub = ('C:/Perl/bin/perl' => $perl_bin);
  foreach my $file (@files) {
    edit($file, \%sub) or return;
  }
  return 1;
}

sub add_start {
  (my $perl = $perl_dir) =~ s!/!\\!g;
  (my $apache_start = $apache_dir) =~ s!/!\\!g;
  
  my $start = 'Start Menu/Programs';
  
  my $user_profile = $ENV{USERPROFILE} ?
    $ENV{USERPROFILE} : 'C:\Documents and Settings';
  
  unless (-d $user_profile) {
    $error = qq{Could not determine your profile directory.};
    return;
  }
  
  unless (-d "$user_profile/$start") {
    $error = qq{Could not determine your Programs directory.};
    return;
  }

  my $group = File::Spec->catdir($user_profile, $start, 
				 "Perl $apache binary");

  if (-d $group) {
    rmtree($group) or do {
      $error = qq{Cannot rmtree "$group": $!};
      return;
    };
  }

  mkdir $group or do {
    $error = qq{Cannot mkdir "$group": $!};
    return;
  };

  mkdir "$group/Documentation"  or do {
    $error = qq{Cannot mkdir "$group/Documentation": $!};
    return;
  };
  
  my $manual = $apache eq 'Apache2' ? 'manual' : 'htdocs\manual';
  my $ssl = $apache eq 'Apache2' ? 'manual\ssl' :
    'htdocs\manual\mod\mod_ssl';
  my %docs = (
	      'mod_perl' => 
	      File::Spec->catfile($apache_start, 
				  'modperl\index.html'),
	      'Apache-ASP' => 
	      File::Spec->catfile($apache_start, 
				  'modperl\asp\index.html'),
	      'Embperl' => 
	      File::Spec->catfile($apache_start, 
				  'modperl\embperl\Intro.html'),
	      'HTML-Mason' => 
	      File::Spec->catfile($apache_start, 
				  'modperl\mason\index.html'),
	      'Template-Toolkit' 
	      => File::Spec->catfile($apache_start, 
				     'modperl\tt\index.html'),
	      'Perl' => File::Spec->catfile($perl, 
					    'html\index.html'),
	      "$apache" => File::Spec->catfile($apache_start, 
                                               $manual, 'index.html'),
	      'mod_ssl' => File::Spec->catfile($apache_start, 
					       $ssl, 'index.html'),
	      'PHP' => File::Spec->catfile($apache_start, 
					   'php\index.html'),
	     );
  
  my $apache_group = File::Spec->catdir($group, $apache);
  mkdir $apache_group  or do {
    $error = qq{Cannot mkdir "$apache_group": $!};
    return;
  };

  my $link = new Win32::Shortcut();

  for (keys %docs) {
    $link->Path($docs{$_});
    $link->Arguments("");
    $link->WorkingDirectory("");
    $link->Description($_);
    $link->Save("$group\\Documentation\\$_.lnk");
  }
  
 PERL: {
    $link->Path("$perl\\bin\\ppm.bat");
    $link->Arguments("");
    $link->WorkingDirectory("$perl\\bin");
    $link->Description('Perl Package Manager');
    $link->ShowCmd(SW_SHOWNORMAL);
    $link->Save("$group\\PPM.lnk");
    $link->Path("$perl\\bin\\tk-ppm.bat");
    $link->Arguments("");
    $link->WorkingDirectory("$perl\\bin");
    $link->Description('tk-ppm');
    $link->ShowCmd(SW_SHOWNORMAL);
    $link->Save("$group\\tk-ppm.lnk");
    $link->Path("$perl\\bin\\tkpod.bat");
    $link->Arguments("");
    $link->WorkingDirectory("$perl\\bin");
    $link->Description('tkpod');
    $link->ShowCmd(SW_SHOWNORMAL);
    $link->Save("$group\\tkpod.lnk");
  }
  
 APACHE: {
    
    $link->Path("$apache_start\\conf\\httpd.conf");
    $link->Arguments("");
    $link->WorkingDirectory("$apache_start\\conf");
    $link->Description('Edit httpd.conf');
    $link->Save("$apache_group\\Edit httpd.conf.lnk");
    
    if ($apache eq 'Apache2') {
      $link->Path("$apache_start\\bin\\MyApache.bat");
    }
    else {
          $link->Path("$apache_start\\MyApache.bat");
    }
    my @mp_args = ('-w', '-d', qq{"$apache_start"}, 
           '-f', qq{"$apache_start\\conf\\httpd.conf"});
    my $wd = $apache eq 'Apache2' ?
      File::Spec->catdir($apache_start, 'bin') : $apache_start;
    my $apache_exe = File::Spec->catfile($wd, 'Apache.exe');
    $link->ShowCmd(SW_SHOWNORMAL);
    $link->WorkingDirectory($wd);
    
    my $args = join ' ', @mp_args, '-D', 'SSL', '-t';
    $link->Arguments($args);
    $link->Description("Test syntax of $apache httpd.conf");
    $link->Save("$apache_group\\Test $apache configuration.lnk");
    
  }
  if (-e "$apache_group\\Test $apache configuration.lnk") {
    my $message = <<"END";
Documentation and some program links have been added in the 
"Perl $apache binary" Programs group of your Start Menu.
END
  dialog_help('Shortcuts added', $message);
    return 1;
  }
  else {
    $error = qq{Could not make shortcuts in $group};
    return;
  }
}

sub edit {
  my ($file, $subs) = @_;
  my $copy = $file . '.old';
  unless (-e $copy) {
    rename $file, $copy or do {
      $error = qq{Cannot rename "$file" to "$copy": $!.};
      return;
    };
  }
  my $pat = join '|', keys %$subs;
  $pat = "($pat)";
  $pat =~ s!C:\\\\Perl!C:\\\\\\\\Perl!;
  $pat =~ s!C:\\Perl!C:\\\\Perl!;
  $pat =~ s!C:\\WINDOWS\\Temp!C:\\\\WINDOWS\\\\Temp!;
  open(OLD, $copy) or do {
    $error = qq{Cannot open "$copy": $!.};
    return;
  };
  open(NEW, ">$file")  or do {
    $error = qq{Cannot open "$file": $!.};
    return;
  };
  while (<OLD>) {
    s/$pat/$subs->{$1}/g;
    print NEW $_;
  }
  close OLD;
  close NEW;
  return 1;
}

sub path_ext {
  if ($ENV{PATHEXT}) {
    push @path_ext, split ';', $ENV{PATHEXT};
    for my $ext (@path_ext) {
      $ext =~ s/^\.*(.+)$/$1/;
    }
  }
  else {
    #Win9X: doesn't have PATHEXT
    push @path_ext, qw(com exe bat);
  }
}

sub which {
  my $program = shift;
  return unless $program;
  for my $base (map { File::Spec->catfile($_, $program) } File::Spec->path()) {
    return $base if -x $base;
    
    for my $ext (@path_ext) {
      return "$base.$ext" if -x "$base.$ext";
    }
  }
}

sub install_html {
  my $message = <<"END";
Proceed to build html documents? 
  (this may take a while).

END
  return unless dialog_yes_no('Build html docs?', $message);

  my $perl = $perl_dir . '/bin/perl';
  return launch($make_html);

#  my $podroot = $perl_dir;
#  my $perl = $podroot . '/bin/perl';
#  my @pods = qw(lib site);
#  my $htmldir = $podroot . '/html';
#  my $htmlroot = "file://$htmldir";
#  my $podpath = join ':', @pods;
#  my $libpod = 'perlfunc:perlguts:perlvar:perlrun:perlop';
#  my @args = ($perl,
#         'myinstallhtml',
#         "--podroot=$podroot",
#         "--htmldir=$htmldir",
#         "--htmlroot=$htmlroot",
#         "--podpath=$podpath",
#         "--libpod=$libpod",
#         qq{--backlink="Up to Top"},
#         qq{--css="$htmlroot/style.css"},
#         "--verbose",
#         '--recurse');
##  system(@args);
  
#  my $p = HTML::Parser->new(api_version => 3,
#               start_h => [\&title_handler, 'self'],
#               report_tags => ['title'],
#              );
#  
#  open(INDEX, ">$htmldir/index.html") or do {
#    $error = qq{Cannot open "$htmldir/index.html": $!};
#    return;
#  };
#  print INDEX <<"END";
#<HTML>
#<HEAD><TITLE>Perl Documentation</TITLE></HEAD>
#<BODY>
#END
#  
#  foreach my $pod (@pods) {
#    my $root = $htmldir . '/' . $pod;
#    my $head = ($pod eq 'lib') ?
#      'Core Documentation' : 'Contributed Documentation'; 
#    print INDEX qq{<H3>$head</H3>};
#    my @files = ();
#    finddepth(sub {push @files, $File::Find::name;}, $root);
#    
#    foreach my $file(sort @files) {
#      $p->parse_file($file) || next;
#      next if $title =~ m!$podroot!;
#      print INDEX qq{<A HREF="file://$file">$title</A><BR>\n};
#    }
#    
#  }
#  print INDEX qq{</BODY></HTML>};
#  close INDEX;
#  return 1;
}

sub title_handler {
  my $self = shift;
  $self->handler(text => sub { $title = "@_" }, "dtext");
  $self->handler(end  => "eof", "self");
}

sub configure_cpan {
  my $message = <<"END";
Proceed with configuring CPAN.pm? 
 (used to install CPAN modules for which no ppm packages exist).

END
  return unless dialog_yes_no('Configure CPAN.pm?', $message);
  launch($cpan_conf) or return;
  return 1;
}

sub help_msg {
  my ($widget, $msg) = @_;
#  $widget->bind('<Enter>', [sub {$message = $_[1]; }, $msg]);
#  $widget->bind('<Leave>', [sub {$message = ''; }]);
  $b->attach($widget, -balloonmsg => $msg);
}

sub tkreadme {
  my $file = shift;
  my $tl = $mw->Toplevel;
  $tl->title('README');
  my $scroll = $tl->Scrollbar();
  my $readme = $tl->Text(-yscrollcommand => ['set' => $scroll]);
  open(README, $file) or do {
    dialog_error('File not found', qq{Cannot find "$file"});
    return;
  };
  $readme->insert('end', $_) while (<README>);
  close(README);
  $scroll->configure(-command => ['yview' => $readme]);
  $scroll->pack(-side => 'left', -fill => 'y');
  $readme->pack(-side => 'top', -fill => 'y');
  my $quit = $tl->Button(-text => 'Close',
             -command => sub {$tl->destroy },
            )->pack(-side => 'top');
}

sub dialog_error {
  my ($title, $msg) = @_;
  $msg .= "\n\n$error" if $error;
  Win32::MsgBox($msg, MB_ICONEXCLAMATION, $title);
  undef $error;
}

sub dialog_proceed {
  my ($title, $msg) = @_;
  $msg .= "\n\n$error" if $error;
  $msg .= "\n\nProceed with configuration?";
  my $ans = Win32::MsgBox($msg, 4, $title);
  undef $error;
  return ($ans == 6) ? 1 : 0;
}

sub dialog_help {
  my ($title, $msg) = @_;
  Win32::MsgBox($msg, MB_ICONINFORMATION, $title);
}

sub dialog_yes_no {
  my ($title, $msg) = @_;
  my $ans = Win32::MsgBox($msg, 4, $title);
  return ($ans == 6) ? 1 : 0;
}

sub dir {
  my $type = shift;
  my $dir;
   if ($type eq 'perl') {
     if ($dir = BrowseForFolder('Perl installation directory', 
                CSIDL_DRIVES)) {
       ($perl_dir = $dir) =~ s!\\!/!g;
     }
   }
  else {
    if ($dir = BrowseForFolder('Apache installation directory', 
                   CSIDL_DRIVES)) {
      ($apache_dir = $dir) =~ s!\\!/!g;
    }
  }
}

sub trim {
  local $_ = shift;
  s/^\s+//;
  s/\s+$//;
  return $_;
}

sub launch {
  my $cmd = shift;
  if (ref($cmd) eq 'ARRAY') {
    $cmd = join ' ', @{$cmd};    
  }
  my $ProcessObj;
  $mw->withdraw;
  Win32::Process::Create($ProcessObj,
             "$shell",
             "$shell /c $cmd",
             0,
             NORMAL_PRIORITY_CLASS | CREATE_NEW_CONSOLE,
             ".")
      or do {
    $error = Win32::FormatMessage(Win32::GetLastError());
    $mw->deiconify;
    $mw->raise;
    return;
      };
  $ProcessObj->Wait(INFINITE);
  $mw->deiconify;
  $mw->raise;
  return 1;
}

sub configure_end {
  my $apbin = $apache_dir;
  $apbin .= '/bin' if $apache eq 'Apache2';
  my $end = <<"END";

As described in install.txt under $perl_dir, 
please check the settings in
   $apache_dir/conf/httpd.conf
   $apache_dir/cgi-bin/*.cgi
   $perl_dir/lib/Config.pm
   $perl_dir/lib/CPAN/Config.pm
   $perl_dir/site/lib/ppm.xml
and make sure "$perl_dir/bin" and "$apbin"
are included in your PATH environment variable.

END
  dialog_help('Configuration complete', $end);
  $mw->destroy;
}

__END__
:endofperl
