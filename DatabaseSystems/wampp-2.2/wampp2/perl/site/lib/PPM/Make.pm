package PPM::Make;
use strict;
use warnings;
use Config::IniFiles;
use Cwd;
use Pod::Find qw(pod_find contains_pod);
use File::Basename;
use File::Path;
use File::Find;
use File::Copy;
use Config;
use CPAN;
use Net::FTP;
use XML::Parser;
use LWP::Simple qw(getstore is_success);
require File::Spec;
use Pod::Html;
use constant WIN32 => $^O eq 'MSWin32';
use vars qw($VERSION);
$VERSION = '0.49';
my @path_ext = ();

my %Escape = ('&' => 'amp',
	      '>' => 'gt',
	      '<' => 'lt',
	      '"' => 'quot'
	     );

my $ext = qr{\.(tar\.gz|tgz|tar\.Z|zip)};
my $protocol = qr{^(http|ftp)://};

my $has_myconfig = 0;
if ($ENV{HOME}) {
  eval 
    {require File::Spec->catfile($ENV{HOME}, '.cpan', 'CPAN', 'MyConfig.pm');};
  $has_myconfig = 1 unless $@;
}
unless ($has_myconfig) {
  eval {require CPAN::Config;};
}

die "CPAN.pm must be configured first" if $@;

sub new {
  my ($class, %opts) = @_;

  die "\nInvalid option specification" unless check_opts(%opts);
  
  $opts{zip} = 1 if ($opts{binary} and $opts{binary} =~ /\.zip$/);
  $opts{as} = defined $opts{as} ? $opts{as} : 1;

  my $arch;
  if (defined $opts{arch}) {
    $arch = ($opts{arch} eq "") ? undef : $opts{arch};
  }
  else {
    $arch = $Config{archname};
    if ($opts{as}) {
      if (length($^V) && ord(substr($^V, 1)) >= 8) {
	$arch .= sprintf("-%d.%d", ord($^V), ord(substr($^V, 1)));
      }
    }
  }
  my $os;
  if (defined $opts{os}) {
    $os = ($opts{os} eq "") ? undef : $opts{os};
  }
  else {
    $os = $Config{osname};
  }
  my $has = what_have_you($opts{program}, $arch, $os);
  
  my (%cfg, $file);
  if (defined $ENV{PPM_CFG} and my $env = $ENV{PPM_CFG}) {
    if (-e $env) {
      $file = $env;
    }
    else {
      warn qq{Cannot find '$env' from \$ENV{PPM_CFG}};
    }
  }
  else {
    my $home = (WIN32 ? '/.ppmcfg' : "$ENV{HOME}/.ppmcfg");
    $file = $home if (-e $home);
  }
  if ($file) {
    %cfg = read_cfg($file, $arch) or die "\nError reading config file";
  }
  
  my $opts = %cfg ? merge_opts(\%cfg, \%opts) : \%opts;
  my $self = {
	      opts => $opts || {},
	      cwd => '',
	      has => $has,
	      args => {},
	      abstract => '',
	      author => '',
	      ppd => '',
	      archive => '',
	      html => 'blib/html',
	      file => '',
	      version => '',
	      ARCHITECTURE => $arch,
	      OS => $os,
	     };
  path_ext() if WIN32;
  bless $self, $class;
}

sub check_opts {
  my %opts = @_;
  my %legal = 
    map {$_ => 1} qw(force ignore binary zip install clean program
                     dist script exec os arch arch_sub add as vs upload);
  foreach (keys %opts) {
    next if $legal{$_};
    warn "Unknown option '$_'\n";
    return;
  }

  if (defined $opts{add}) {
    unless (ref($opts{add}) eq 'ARRAY') {
      warn "Please supply an ARRAY reference to 'add'";
      return;
    }
  }

  if (defined $opts{program} and my $progs = $opts{program}) {
    unless (ref($progs) eq 'HASH') {
      warn "Please supply an HASH reference to 'program'";
      return;
    }
    my %ok = map {$_ => 1} qw(zip unzip tar gzip make);
    foreach (keys %{$progs}) {
      next if $ok{$_};
      warn "Unknown program option '$_'\n";
      return;
    }
  }
  
  if (defined $opts{upload} and my $upload = $opts{upload}) {
    unless (ref($upload) eq 'HASH') {
      warn "Please supply an HASH reference to 'upload'";
      return;
    }
    my %ok = map {$_ => 1} qw(ppd ar host user passwd);
    foreach (keys %{$upload}) {
      next if $ok{$_};
      warn "Unknown upload option '$_'\n";
      return;
    }
  }
  return 1;
}

sub what_have_you {
  my ($progs, $arch, $os) = @_;
  my %has;
  if (defined $progs->{tar} and defined $progs->{gzip}) {
    $has{tar} = $progs->{tar};
    $has{gzip} = $progs->{gzip};
  }
  elsif ((not WIN32 and 
	  (not $os or $os =~ /Win32/i or not $arch or $arch =~ /Win32/i))) {
    $has{tar} = 
      $Config{tar} || $CPAN::Config->{tar} || which('tar');
    $has{gzip} =
      $Config{gzip} || $CPAN::Config->{gzip} || which('gzip');
  }
  else {
    eval{require Archive::Tar; require Compress::Zlib};
    if ($@) {
      $has{tar} = 
	$Config{tar} || $CPAN::Config->{tar} || which('tar');
      $has{gzip} =
	$Config{gzip} || $CPAN::Config->{gzip} || which('gzip');
    }
    else {
      $has{tar} = 'Archive::Tar';
      $has{gzip} = 'Compress::Zlib';
    }
  }

  if (defined $progs->{zip} and defined $progs->{unzip}) {
    $has{zip} = $progs->{zip};
    $has{unzip} = $progs->{unzip};
  }
  else {
    eval{require Archive::Zip; };
    if ($@) {
      $has{zip} = 
	$Config{zip} || $CPAN::Config->{zip} || which('zip');
      $has{unzip} =
	$Config{unzip} || $CPAN::Config->{unzip} || which('unzip');
    }
    else {
      my $zipv = $Archive::Zip::VERSION + 0;
      if ($zipv >= 1.02) {
	require Archive::Zip; import Archive::Zip qw(:ERROR_CODES);
	$has{zip} = 'Archive::Zip';
	$has{unzip} = 'Archive::Zip';
      }
      else {
	$has{zip} =
	  $Config{zip} || $CPAN::Config->{zip} || which('zip');
	$has{unzip} =
	  $Config{unzip} || $CPAN::Config->{unzip} || which('unzip');
      }
    }
  }
  
  $has{make} = $progs->{make} ||
    $Config{make} || $CPAN::Config->{make} || which('make');

  $has{perl} = 
    $Config{perlpath} || which('perl');

  foreach (qw(tar gzip make perl)) {
    die "Cannot find a '$_' program" unless $has{$_};
    print "Using $has{$_} ....\n";
  }

  eval{require PPM; };
  $has{ppm} = 1 unless $@;

  return \%has;
}

sub read_cfg {
  my ($file, $arch) = @_;
  my $default = 'default';
  my $cfg = Config::IniFiles->new(-file => $file, -default => $default);
  my @p;
  push @p, $cfg->Parameters($default) if ($cfg->SectionExists($default));
  push @p, $cfg->Parameters($arch) if ($cfg->SectionExists($arch));
  unless (@p > 1) {
    warn "No default or section for $arch found";
    return;
  }
  
  my $on = qr!^(on|yes)$!;
  my $off = qr!^(off|no)$!;
  my %legal_progs = map {$_ => 1} qw(tar gzip make perl);
  my %legal_upload = map {$_ => 1} qw(ppd ar host user passwd); 
  my (%cfg, %programs, %upload);
  foreach (@p) {
    my $val = $cfg->val($arch, $_);
    $val = 1 if ($val =~ /$on/i);
    if ($val =~ /$off/i) {
      delete $cfg{$_};
      next;
    }
    if ($_ eq 'add') {
      $cfg{$_} = [split ' ', $val];
      next;
    }
    if ($legal_progs{$_}) {
      $programs{$_} = $val;
    }
    elsif ($legal_upload{$_}) {
      $upload{$_} = $val;
    }
    else {
      $cfg{$_} = $val;
    }
  }
  $cfg{program} = \%programs if %programs;
  $cfg{upload} = \%upload if %upload;
  return check_opts(%cfg) ? %cfg : undef;
}

# merge two hashes, assuming the second one takes precedence 
# over the first in the case of duplicate keys
sub merge_opts {
  my ($h1, $h2) = @_;
  my %opts = (%{$h1}, %{$h2});
  if (defined $h1->{add} or defined $h2->{add}) {
    my @a;
    push @a, @{$h1->{add}} if $h1->{add};
    push @a, @{$h2->{add}} if $h2->{add};
    my %add = map {$_ => 1} @a;
    $opts{add} = [keys %add];
  }
  for (qw(program upload)) {
    next unless (defined $h1->{$_} or defined $h2->{$_});
    my %h = ();
    if (defined $h1->{$_}) {
      if (defined $h2->{$_}) {
	%h = (%{$h1->{$_}}, %{$h2->{$_}});
      }
      else {
	%h = %{$h1->{$_}};
      }
    }
    else {
      %h = %{$h2->{$_}};     
    }
    $opts{$_} = \%h;
  }
  return \%opts;
}

sub make_ppm {
  my $self = shift;
  die 'No software available to make a zip archive'
     if ($self->{opts}->{zip} and not $self->{has}->{zip});
  my $dist = $self->{opts}->{dist};
  if ($dist) {
    $dist = $self->fetch_dist($dist) 
      if ($dist =~ m!$protocol! or $dist !~ m!$ext!);
    print "Extracting files from $dist ....\n";
    my $name = $self->extract_dist($dist);
    chdir $name or die "Cannot chdir to $name: $!";
    $self->{file} = $dist;
  }
  my $force = $self->{opts}->{force};
  $self->{cwd} = cwd;
  $self->check_script() if $self->{opts}->{script};
  $self->check_files() if $self->{opts}->{add};
  $self->adjust_binary() if $self->{opts}->{arch_sub};
  $self->build_dist() 
    unless (-d 'blib' and -f 'Makefile' and not $force);
  my $ret = $self->parse_makepl();
  $self->parse_make() unless $ret;
  $self->abstract();
  $self->author();
  if ($self->{opts}->{vs}) {
    $self->version_from() or warn "Cannot extract version";
  }
  $self->make_html() unless (-d 'blib/html' and not $force);
  $dist = $self->make_dist();
  $self->fix_ppd($dist);
  if ($self->{opts}->{install}) {
    die 'Must have the ppm utility to install' unless $self->{has}->{ppm};
    $self->ppm_install();
  }
  if (defined $self->{opts}->{upload}) {
    die 'Please specify the location to place the ppd file'
      unless $self->{opts}->{upload}->{ppd}; 
    $self->upload_ppm();
  }
}

sub check_script {
  my $self = shift;
  my $script = $self->{opts}->{script};
  return if ($script =~ m!$protocol!);
  my ($name, $path, $suffix) = fileparse($script, '\..*');
  my $file = $name . $suffix;
  $self->{opts}->{script} = $file;
  return if (-e $file);
  copy($script, $file) or die "Copying $script to $self->{cwd} failed: $!";
}

sub check_files {
  my $self = shift;
  my @entries = ();
  foreach my $file (@{$self->{opts}->{add}}) {
    my ($name, $path, $suffix) = fileparse($file, '\..*');
    my $entry = $name . $suffix;
    push @entries, $entry;
    next if (-e $entry);
    copy($file, $entry) or die "Copying $file to $self->{cwd} failed: $!";
  }
  $self->{opts}->{add} = \@entries if @entries;
}

sub fetch_dist {
  my ($self, $dist) = @_;
  unless ($dist =~ m!$ext!) {
    my $mod = $dist;
    $mod =~ s!-!::!g;
    my $module;
    die qq{Cannot get information for $mod}
      unless ($module = CPAN::Shell->expand('Module', $mod));
    die qq{Cannot get distribution name of $mod}
      unless ($dist = $module->cpan_file);
  }
  my $from = ($dist =~ m!$protocol!) ? $dist :
    'http://www.cpan.org/authors/id/' . $dist;
  (my $to = $dist) =~ s!.*/(.*)!$1!;
  print "Fetching $from ....\n";
  die "Failed to get $dist" 
    unless (is_success(getstore($from, $to)));
  return $to;
}

sub extract_dist {
  my ($self, $file) = @_;

  my $has = $self->{has};
  my ($tar, $gzip, $unzip) = @$has{qw(tar gzip unzip)};

  my ($name, $path, $suffix) = fileparse($file, $self->{ext});
 EXTRACT: {
    if ($suffix eq '.zip') {
      ($unzip eq 'Archive::Zip') && do {
	my $arc = Archive::Zip->new();
        die "Read of $file failed" unless $arc->read($file) == AZ_OK();
	$arc->extractTree();
	last EXTRACT;
      };
      ($unzip) && do {
	my @args = ($unzip, $file);
	print "@args\n";
	system(@args) == 0 or die "@args failed: $?";
	last EXTRACT;
      };

    }
    else {
      ($tar eq 'Archive::Tar') && do {
	my $arc = Archive::Tar->new($file, 1);
	$arc->extract($arc->list_files);
	last EXTRACT;
      };
      ($tar and $gzip) && do {
	my @args = ($gzip, '-dc', $file, '|', $tar, 'xvf', '-');
	print "@args\n";
	system(@args) == 0 or die "@args failed: $?";
	last EXTRACT;
      };
    }
    die "Cannot extract $file";
  }
  return $name;
}

sub adjust_binary {
  my $self = shift;
  my $binary = $self->{opts}->{binary};
  my $archname = $self->{ARCHITECTURE};
  return unless $archname;
  if ($binary) {
    if ($binary =~ m!$ext!) {
      if ($binary =~ m!/!) {
	$binary =~ s!(.*?)([\w\-]+)$ext!$1$archname/$2$3!;
      }
      else {
	$binary = $archname . '/' . $binary;
      }
    }
    else {
      $binary =~ s!/$!!;
      $binary .= '/' . $archname . '/';	
    }
  }
  else {
    $binary = $archname . '/';
  }
  $self->{opts}->{binary} = $binary;
}

sub build_dist {
  my $self = shift;
  my $binary = $self->{opts}->{binary};
  my $script = $self->{opts}->{script};
  my $exec = $self->{opts}->{exec};

  my $has = $self->{has};
  my ($make, $perl) = @$has{qw(make perl)};

  my @args;
  @args = ($perl, 'Makefile.PL');
  my $makepl_arg = $CPAN::Config->{makepl_arg};
  if ($binary) {
    if ($makepl_arg =~ /BINARY_LOCATION/) {
      $makepl_arg =~ s!(.*BINARY_LOCATION=)\S+(.*)!$1$binary$2!;
    }
    else {
      $makepl_arg .= ' BINARY_LOCATION=' . $binary;
    }
  }
  if ($script and $script !~ m!$protocol!) {
    if ($makepl_arg =~ /PPM_INSTALL_SCRIPT/) {
      $makepl_arg =~ s!(.*PPM_INSTALL_SCRIPT=)\S+(.*)!$1$script$2!;
    }
    else {
      $makepl_arg .= ' PPM_INSTALL_SCRIPT=' . $script;
    }
  }
  
  if ($exec) {
    if ($makepl_arg =~ /PPM_INSTALL_EXEC/) {
      $makepl_arg =~ s!(.*PPM_INSTALL_EXEC=)\S+(.*)!$1$exec$2!;
    }
    else {
      $makepl_arg .= ' PPM_INSTALL_EXEC=' . $exec;
    }
  }

  if ($makepl_arg) {
    push @args, (split ' ', $makepl_arg);
  }
  print "@args\n";
  system(@args) == 0 or die qq{@args failed: $?};

  @args = ($make);
  push @args, $CPAN::Config->{make_arg} if $CPAN::Config->{make_arg};
  print "@args\n";
  system(@args) == 0 or die "@args failed: $?";
 
  @args = ($make, 'test');
  print "@args\n";
  unless (system(@args) == 0) {
    die "@args failed: $?" unless $self->{opts}->{ignore};
    warn "@args failed: $?";
  }
  return 1;
}

sub parse_makepl {
  my $self = shift;
  
  open(MAKE, 'Makefile.PL') or die "Couldn't open Makefile.PL: $!";
  my @lines = <MAKE>;
  close MAKE;

  my $content = join "\n", @lines;
  $content =~ s!\r!!g;
  $content =~ m!WriteMakefile(\s*\(.*?\bNAME\b.*?\))\s*;!s;
  my $makeargs;
  unless ($makeargs = $1) {
    warn "Couldn't extract WriteMakefile args";
    return;
  }

  my $c = new Safe();
  my %r = $c->reval($makeargs);
  if ($@) {
    warn "Eval of Makefile.PL failed: $@";
    return;
  }
  unless ($r{NAME}) {
    warn "Cannot determine NAME in Makefile.PL";
    return;
  }
  $self->{args} = \%r;
  return 1;
}

sub parse_make {
  my $self = shift;
  my $flag = 0;
  my @wanted = qw(NAME DISTNAME ABSTRACT ABSTRACT_FROM AUTHOR VERSION_FROM);
  my $re = join '|', @wanted;
  my @lines;
  open(MAKE, 'Makefile') or die "Couldn't open Makefile: $!";
  while (<MAKE>) {
    if (not $flag and /MakeMaker Parameters/) {
      $flag = 1;
      next;
    }
    next unless $flag;
    last if /MakeMaker post_initialize/;
    next unless /$re/;
    chomp;
    s/^#*\s+// or next;
    push @lines, $_;
  }
  close(MAKE);
  my $make = join ',', @lines;
  $make = '(' . $make . ')';
  print "$make\n";
  my $c = new Safe();
  my %r = $c->reval($make);
  die "Eval of Makefile failed: $@" if ($@);
  die 'Cannot determine NAME in Makefile' unless $r{NAME};
  for (@wanted) {
    $self->{args}->{$_} = $r{$_} unless $self->{args}->{$_};
  }
  return 1;
}

sub abstract {
  my $self = shift;
  my $args = $self->{args};
  if ($args->{ABSTRACT} or $args->{ABSTRACT_FROM}) {
    $self->{abstract} = 'supplied';
  }
  else {
    if (my $abstract = $self->guess_abstract()) {
      warn "Setting ABSTRACT to '$abstract'\n";
      $self->{abstract} = $abstract;
    }
    else {
      warn "Please check ABSTRACT in the ppd file\n";
    }
  }
}

sub guess_abstract {
  my $self = shift;
  my $args = $self->{args};
  my $cwd = $self->{cwd};
  my $result;
  if (my $version_from = $args->{VERSION_FROM}) {
    print "Trying to get ABSTRACT from $version_from ...\n";
    $result = parse_abstract($args->{NAME}, $version_from);
    return $result if $result;
  }
  my ($hit, $guess);
  for my $ext (qw(pm pod)) {
    if ($args->{NAME} =~ /-|:/) {
      ($guess = $args->{NAME}) =~ s!.*[-:](.*)!$1.$ext!;
    }
    else {
      $guess = $args->{NAME} . ".$ext";
    }
    finddepth(sub{$_ eq $guess && ($hit = $File::Find::name) 
		    && ($hit !~ m!blib/!)}, $cwd);
    next unless (-f $hit);
    print "Trying to get ABSTRACT from $hit ...\n";
    $result = parse_abstract($args->{NAME}, $hit);
    return $result if $result;
  }
  return;
}

sub parse_abstract {
  my ($package, $file) = @_;
  my $basename = basename($file, qr/\.\w+$/);
  (my $stripped = $basename) =~ s!\.\w+$!!;
  (my $trans = $package) =~ s!-!::!g;
  my $result;
  my $inpod = 0;
  open(FILE, $file) or die "Couldn't open $file: $!";
  while (<FILE>) {
    $inpod = /^=(?!cut)/ ? 1 : /^=cut/ ? 0 : $inpod;
    next if !$inpod;
    chop;
    next unless /^\s*($package|$basename|$stripped|$trans)\s+--*\s+(.*)/;
    $result = $2;
    last;
  }
  close(FILE);
  chomp($result);
  return $result;
}

sub author {
  my $self = shift;
  my $args = $self->{args};
  if ($args->{AUTHOR}) {
    $self->{author} = 'supplied';
  }
  else {
    if (my $author = $self->guess_author()) {
      warn "Setting AUTHOR to '$author'\n";
      $self->{author} = $author;
    }
    else {
      warn "Please check AUTHOR in the ppd file\n";
    }
  }
}

sub version_from {
  my $self = shift;
  my $parsefile = $self->{args}->{VERSION_FROM};
  my $result;
  local *FH;
  local $/ = "\n";
  unless (open(FH,$parsefile)) {
    warn "Could not open '$parsefile': $!";
    return;
  }
  my $inpod = 0;
  while (<FH>) {
    $inpod = /^=(?!cut)/ ? 1 : /^=cut/ ? 0 : $inpod;
    next if $inpod;
    chop;
    # next unless /\$(([\w\:\']*)\bVERSION)\b.*\=/;
    next unless /([\$*])(([\w\:\']*)\bVERSION)\b.*\=/;
    my $eval = qq{
	    package ExtUtils::MakeMaker::_version;
	    no strict;

	    local $1$2;
	    \$$2=undef; do {
		$_
	    }; \$$2
	};
    no warnings;
    $result = eval($eval);
    if ($@) {
      warn "Could not eval '$eval' in $parsefile: $@";
      return;
    }
    return undef unless defined $result;
    last;
  }
  close FH;
  $self->{version} = $result;
  return $result;
}

sub guess_author {
  my $self = shift;
  my $args = $self->{args};
  (my $mod = $args->{NAME}) =~ s!-!::!g;
  print "Trying to get AUTHOR from CPAN.pm ...\n";
  my $module = CPAN::Shell->expand('Module', $mod);
  unless ($module) {
    if (my $version_from = $args->{VERSION_FROM}) {
      $version_from =~ s!^lib/!!;
      $version_from =~ s!\.pm$!!;
      $version_from =~ s!/!::!g;
      $module = CPAN::Shell->expand('Module', $version_from)
    }
  }
  return unless $module;
  return unless (my $userid = $module->cpan_userid);
  return unless (my $author = CPAN::Shell->expand('Author', $userid));
  my $auth_string = $author->fullname;
  my $email = $author->email;
  $auth_string .= ' &lt;' . $email . '&gt;' if $email;
  return $auth_string;
}

sub make_html {
  my $self = shift;
  my $args = $self->{args};
  my $cwd = $self->{cwd};
  my $html = $self->{html};
  unless (-d $html) {
    mkpath($html, 1, 0755) or die "Couldn't mkdir $html: $!";
  }
  my %pods = pod_find({-verbose => 1}, "$cwd/blib/");
  if (-d "$cwd/blib/script/") {
    finddepth( sub 
	       {$pods{$File::Find::name} = 
		  "script::" . basename($File::Find::name) 
		    if (-f $_ and not /\.bat$/ and contains_pod($_));
	      }, "$cwd/blib/script");
  }

  foreach my $pod (keys %pods){
    my @dirs = split /::/, $pods{$pod};
    my $isbin = shift @dirs eq 'script';

    (my $infile = File::Spec->abs2rel($pod)) =~ s!^\w+:!!;
    $infile =~ s!\\!/!g;
    my $outfile = (pop @dirs) . '.html';

    my @rootdirs  = $isbin? ('bin') : ('site', 'lib');
    (my $path2root = "../" x (@rootdirs+@dirs)) =~ s|/$||;
    
    (my $fulldir = File::Spec->catfile($html, @rootdirs, @dirs)) =~ s!\\!/!g;
    unless (-d $fulldir){
      mkpath($fulldir, 1, 0755) 
	or die "Couldn't mkdir $fulldir: $!";  
    }
    ($outfile = File::Spec->catfile($fulldir, $outfile)) =~ s!\\!/!g;
    
    my $htmlroot = "$path2root/site/lib";
    my $podroot = "$cwd/blib";
    my $podpath = join ":" => map { $podroot . '/' . $_ }  
      ($isbin ? qw(bin lib) : qw(lib));
    (my $package = $pods{$pod}) =~ s!^(lib|script)::!!;
    my $abstract = parse_abstract($package, $infile);
    my $title =  $abstract ? "$package - $abstract" : $package;
    my @opts = (
		'--header',
		"--title=$title",
		"--infile=$infile",
		"--outfile=$outfile",
		"--podroot=$podroot",
		"--htmlroot=$htmlroot",
		"--css=$path2root/Active.css",
	       );
    print "pod2html @opts\n";
    pod2html(@opts);# or warn "pod2html @opts failed: $!";
  }
  ###################################
}

sub make_dist {
  my $self = shift;
  my $args = $self->{args};
  my $has = $self->{has};
  my ($tar, $gzip, $zip) = @$has{qw(tar gzip zip)};
  my $force_zip = $self->{opts}->{zip};
  my $binary = $self->{opts}->{binary};
  my $name;
  if ($binary and $binary =~ /$ext/) {
    ($name = $binary) =~ s!.*/(.*)$ext!$1!;
  }
  else {
    $name = $args->{DISTNAME} ? $args->{DISTNAME} :
      $args->{NAME};
    $name  =~ s!::!-!g;
  }

  $name .= "-$self->{version}" if $self->{version};

  my $is_Win32 = (not $self->{OS} or $self->{OS} =~ /Win32/i 
		  or not $self->{ARCHITECTURE} or
		  $self->{ARCHITECTURE} =~ /Win32/i);

  my $script = $self->{opts}->{script};
  my $script_is_external = $script ? ($script =~ /$protocol/) : '';
  my @files;
  if ($self->{opts}->{add}) {
    @files = @{$self->{opts}->{add}};
  }

  my $arc = $force_zip ? ($name . '.zip') : ($name . '.tar.gz');
#  unless ($self->{opts}->{force}) {
#    return $arc if (-f $arc);
#  }
  unlink $arc if (-e $arc);

 DIST: {
    ($tar eq 'Archive::Tar' and not $force_zip) && do {
      $name .= '.tar.gz';
      my @f;
      my $arc = Archive::Tar->new();
      if ($is_Win32) {
        finddepth(sub { 
                       push @f, $File::Find::name
                          unless $File::Find::name =~ m!blib/man\d!;
		       print $File::Find::name,"\n"}, 'blib');
      }
      else {
	finddepth(sub {push @f, $File::Find::name; 
		       print $File::Find::name,"\n"}, 'blib');
      }
      if ($script and not $script_is_external) {
	push @f, $script;
	print "$script\n";
      }
      if (@files) {
	push @f, @files;
	print join "\n", @files;
      }
      $arc->add_files(@f);
      $arc->write($name, 1);
      last DIST;
    };
    ($tar and $gzip and not $force_zip) && do {
      $name .= '.tar';
      my @args = ($tar, 'cvf', $name);

      if ($is_Win32) {
	my @f;
        finddepth(sub { 
                       push @f, $File::Find::name
                          unless $File::Find::name =~ m!blib/man\d!;},
                             'blib');
	for (@f) {
	  push @args, "--exclude", $_;
	}
      }

      push @args, 'blib';

      if ($script and not $script_is_external) {
	push @args, $script;
      }
      if (@files) {
	push @args, @files;
      }
      print "@args\n";
      system(@args) == 0 or die "@args failed: $?";
      @args = ($gzip, $name);
      print "@args\n";
      system(@args) == 0 or die "@args failed: $?";
      $name .= '.gz';
      last DIST;
    };
    ($zip eq 'Archive::Zip') && do {
      $name .= '.zip';
      my $arc = Archive::Zip->new();
      if ($is_Win32) {
        die "zip of blib failed" unless $arc->addTree('blib', 'blib',
                     sub{$_ !~ m!blib/man\d/! && print "$_\n";}) == AZ_OK();
      }
      else {
        die "zip of blib failed" unless $arc->addTree('blib', 'blib', 
                              sub{print "$_\n";}) == AZ_OK();
      }
      if ($script and not $script_is_external) {
        die "zip of $script failed"
           unless $arc->addTree($script, $script) == AZ_OK();
	print "$script\n";
      }
      if (@files) {
	for (@files) {
          die "zip of $_ failed" unless $arc->addTree($_, $_) == AZ_OK();
	  print "$_\n";
	}
      }
      die "Writing to $name failed" 
	unless $arc->writeToFileNamed($name) == AZ_OK();
      last DIST;
    };
    ($zip) && do {
      $name .= '.zip';
      my @args = ($zip, '-r', $name, 'blib');
      if ($script and not $script_is_external) {
	push @args, $script;
	print "$script\n";
      }
      if (@files) {
	push @args, @files;
	print join "\n", @files;
      }
      if ($is_Win32) {
	my @f;
        finddepth(sub {
                       push @f, $File::Find::name
                          unless $File::Find::name =~ m!blib/man\d!;},
                             'blib');
	for (@f) {
	  push @args, "-x", $_;
	}
      }
      
      print "@args\n";
      system(@args) == 0 or die "@args failed: $?";
      last DIST;
    };
    die "Cannot make archive for $name";
  }
  return $name;
}

sub fix_ppd {
  my ($self, $dist) = @_;
  my $make = $self->{has}->{make};

  my @args = ($make, 'ppd');
  print "\n@args\n";
  system(@args) == 0 or die "@args failed: $?";

  my $args = $self->{args};
  my $abstract = $self->{abstract};
  my $author = $self->{author};
  my $binary = $self->{opts}->{binary};
  my $edit_binary = ($binary and $binary =~ m!\.(tar\.gz|zip)$!) ? 0 : 1;
  my $os = $self->{OS};
  my $arch = $self->{ARCHITECTURE};

  my $name = $args->{DISTNAME} ? $args->{DISTNAME} : $args->{NAME};
  $name  =~ s!::!-!g;
  if (my $v = $self->{version}) {
    rename("$name.ppd", "$name-$v.ppd") 
      or die "Couldn't rename $name.ppd to $name-$v.ppd: $!";
    $name .= "-$v";
  }
  my $ppd = $name . '.ppd';
  my $copy = $ppd . '.in';
  rename($ppd, $copy) or die "Couldn't rename $ppd to $copy: $!";

  my $d = parse_ppd($copy);

  $d->{OS}->{NAME} = $os if $os;
  $d->{ARCHITECTURE}->{NAME} = $arch if $arch;
  $d->{ABSTRACT} = $abstract 
    if ($abstract and $abstract ne 'supplied');
  $d->{AUTHOR} = $author
    if ($author and $author ne 'supplied');
  if ($binary) {
    unless ($binary =~ /$ext/) {
      $binary .= ($binary =~ m!/$!) ? $dist : '/' . $dist;
    }
  }
  $d->{CODEBASE}->{HREF} = $binary ? $binary : $dist;
  ($self->{archive} = $d->{CODEBASE}->{HREF}) =~ s!.*/(.*)!$1!;

  my $script = $self->{opts}->{script};
  if ($script) {
    my $exec = $self->{opts}->{exec};
    $d->{INSTALL}->{EXEC} = $exec if $exec;
    if ($script =~ m!$protocol!) {
      $d->{INSTALL}->{HREF} = $script;
      (my $name = $script) =~ s!.*/(.*)!$1!;
      $d->{INSTALL}->{SCRIPT} = $name;
    }
    else {
      $d->{INSTALL}->{SCRIPT} = $script;      
    }
  }

  $self->print_ppd($d, $ppd);
  $self->{ppd} = $ppd;
  unlink $copy or warn "Couldn't unlink $copy: $!";
}

sub ppm_install {
  my $self = shift;
#  PPM::InstallPackage(package => $self->{ppd});
  my @args = ('ppm', 'install', $self->{ppd});
  print "@args\n";
  system(@args) == 0 or warn "Can't install $self->{ppd}: $?";
  return unless $self->{opts}->{clean};
  my $file = $self->{file};
  unless ($file) {
    warn "Cannot clean files unless a distribution is specified";
    return;
  }
  chdir('..') or die "Cannot move up one directory: $!";
  print "About to remove $self->{cwd} ...\n";
  rmtree($self->{cwd}) or warn "Cannot remove $self->{cwd}: $!";
  print "About to remove $file ....\n";
  unlink $file or warn "Cannot unlink $file: $!";
}

sub html_escape {
  my $text = shift;
  $text =~ s/([<>\"&])(?!\w+;)/\&$Escape{$1};/mg;
  $text;
}

sub parse_ppd {
  my $file = shift;
  die "$file not found" unless (-e $file);
  my $p = XML::Parser->new(Style => 'Subs',
			   Handlers => {Char => \&char,
					Start => \&start,
					End => \&end,
					Init => \&init,
					Final => \&final,
				       },
			  );
  my $d = $p->parsefile($file);
  return $d;
}

sub print_ppd {
  my ($self, $d, $fn) = @_;
  my $fh = new IO::File ">$fn" or die "Couldn't write to $fn: $!";
  my $title = html_escape($d->{TITLE});
  my $abstract = html_escape($d->{ABSTRACT});
  my $author = html_escape($d->{AUTHOR});
  print $fh <<"END";
<SOFTPKG NAME=\"$d->{SOFTPKG}->{NAME}\" VERSION=\"$d->{SOFTPKG}->{VERSION}\">
\t<TITLE>$title</TITLE>
\t<ABSTRACT>$abstract</ABSTRACT>
\t<AUTHOR>$author</AUTHOR>
\t<IMPLEMENTATION>
END

  if (scalar @{$d->{DEPENDENCY}} > 0) {
    foreach (@{$d->{DEPENDENCY}}) {
      next if is_core($_->{NAME});
      my $dist = mod_to_dist($_->{NAME});
      next if (not $dist or $dist =~ m!^perl$!);
      print $fh qq{\t\t<DEPENDENCY NAME="$dist" VERSION="$_->{VERSION}" />\n};
    }
  }
  foreach (qw(OS ARCHITECTURE)) {
    print $fh qq{\t\t<$_ NAME="$d->{$_}->{NAME}" />\n} if $self->{$_};
  }
  
  my $script = $d->{INSTALL}->{SCRIPT};
  if ($script) {
    my $exec = $d->{INSTALL}->{EXEC};
    my $href = $d->{INSTALL}->{HREF};
    my $install = 'INSTALL';
    $install .= qq{ EXEC="$exec"} if $exec;
    $install .= qq{ HREF="$href"} if $href;
    print $fh qq{\t\t<$install>$script</INSTALL>\n};
  }
  print $fh qq{\t\t<CODEBASE HREF="$d->{CODEBASE}->{HREF}" />\n};
  
  print $fh qq{\t</IMPLEMENTATION>\n</SOFTPKG>\n};
  $fh->close;

}

sub upload_ppm {
  my $self = shift;
  my ($ppd, $archive) = ($self->{ppd}, $self->{archive});
  my $upload = $self->{opts}->{upload};
  my $ppd_loc = $upload->{ppd};
  my $ar_loc = $self->{opts}->{arch_sub} ?
    $self->{ARCHITECTURE} : $upload->{ar} || $ppd_loc;
  if (not File::Spec->file_name_is_absolute($ar_loc)) {
    ($ar_loc = File::Spec->catdir($ppd_loc, $ar_loc)) =~ s!\\!/!g;
  }

  if (my $host = $upload->{host}) {
    my ($user, $passwd) = ($upload->{user}, $upload->{passwd});
    die "Must specify a username and password to log into $host"
      unless ($user and $passwd);
    my $ftp = Net::FTP->new($host) or die "Cannot connect to $host";
    $ftp->login($user, $passwd) or die "Login for user $user failed";
    $ftp->cwd($ppd_loc) or die "cwd to $ppd_loc failed";
    $ftp->ascii;
    $ftp->put($ppd) or die "Cannot upload $ppd";
    $ftp->cwd($ar_loc) or die "cwd to $ar_loc failed";
    $ftp->binary;
    $ftp->put($archive) or die "Cannot upload $archive";
    $ftp->quit;
  }
  else {
    copy($ppd, "$ppd_loc/$ppd") 
      or die "Cannot copy $ppd to $ppd_loc: $!";
    copy($archive, "$ar_loc/$archive") 
      or die "Cannot copy $archive to $ar_loc: $!";
  }
}

sub is_core {
  my $m = shift;
  $m =~ s!::|-!/!g;
  $m = $m . '.pm';
  my $is_core;
  foreach (@INC) {
    if (-f "$_/$m") {
      $is_core++ if ($_ !~ /site/);
      last;
    }
  }
  return $is_core;
}

sub mod_to_dist {
  my $mod = shift;
  $mod =~ s!-!::!g;
  my $module = CPAN::Shell->expand('Module', $mod);
  return unless $module;
  (my $file = $module->cpan_file) =~ s!.*/(.*)$ext!$1!;
  my ($dist, $version) = version($file);
  return ($dist and $version) ? $dist : undef;
}

sub version {
  local ($_) = @_;

  # remove alpha/beta postfix
  s/([-_\d])(a|b|alpha|beta|src)$/$1/;

  # jperl1.3@4.019.tar.gz
  s/@\d.\d+//;

  # oraperl-v2.4-gk.tar.gz
  s/-v(\d)/$1/;

  # lettered versions - shudder
  s/([-_\d\.])([a-z])([\d\._])/sprintf "$1%02d$3", ord(lc $2) - ord('a') /ei;
  s/([-_\d\.])([a-z])$/sprintf "$1%02d", ord(lc $2) - ord('a') /ei;

  # thanks libwww-5b12 ;-)
  s/(\d+)b/($1-1).'.'/e;
  s/(\d+)a/($1-2).'.'/e;

  # replace '-pre' by '0.'
  s/-pre([\.\d])/-0.$1/;
  s/\.\././g;
  s/(\d)_(\d)/$1$2/g;

  # chop '[-.]' and thelike
  s/\W$//;

  # ram's versions Storable-0.4@p
   s/\@/./;

  if (s/[-_]?(\d+)\.(0\d+)\.(\d+)$//) {
    return($_, $1 + "0.$2" + $3 / 1000000);
  } elsif (s/[-_]?(\d+)\.(\d+)\.(\d+)$//) {
    return($_, $1 + $2/1000 + $3 / 1000000);
  } elsif (s/[-_]?(\d+\.[\d_]+)$//) {
    return($_, $1);
  } elsif (s/[-_]?([\d_]+)$//) {
    return($_, $1);
  } elsif (s/-(\d+.\d+)-/-/) {  # perl-4.019-ref-guide
    return($_, $1);
  } else {
    if ($_ =~ /\d/) {           # smells like an unknown scheme
      #warn "Odd version Numbering: $_ \n";
      return($_, undef);
    } else {                    # assume version 0
      #warn "No  version Numbering: $_ \n";
      return($_, 0);
    }

  }
}

sub init {
  my $self = shift;
  $self->{_mydata} = {
		      SOFTPKG => {NAME => '', VERSION => ''},
		      TITLE => '',
		      AUTHOR => '',
		      ABSTRACT => '',
		      OS => {NAME => ''},
		      ARCHITECTURE => {NAME => ''},
		      CODEBASE => {HREF => ''},
		      DEPENDENCY => [],
		      INSTALL => {EXEC => '', SCRIPT => ''},
		      wanted => {TITLE => 1, ABSTRACT => 1, AUTHOR => 1},
		      _current => '',
		     };
}

sub start {
  my ($self, $tag, %attrs) = @_;
  my $internal = $self->{_mydata};
  $internal->{_current} = $tag;
  
 SWITCH: {
    ($tag eq 'SOFTPKG') and do {
      $internal->{SOFTPKG}->{NAME} = $attrs{NAME};
      $internal->{SOFTPKG}->{VERSION} = $attrs{VERSION};
      last SWITCH;
    };
    ($tag eq 'CODEBASE') and do {
      $internal->{CODEBASE}->{HREF} = $attrs{HREF};
      last SWITCH;
    };
    ($tag eq 'OS') and do {
	$internal->{OS}->{NAME} = $attrs{NAME};
	last SWITCH;
      };
    ($tag eq 'ARCHITECTURE') and do {
      $internal->{ARCHITECTURE}->{NAME} = $attrs{NAME};
      last SWITCH;
    };
    ($tag eq 'INSTALL') and do {
     $internal->{INSTALL}->{EXEC} = $attrs{EXEC};
      last SWITCH;
   };
    ($tag eq 'DEPENDENCY') and do {
      push @{$internal->{DEPENDENCY}}, 
	{NAME => $attrs{NAME}, VERSION => $attrs{VERSION}};
      last SWITCH;
    };
    
  }
}

sub char {
  my ($self, $string) = @_;
  
  my $internal = $self->{_mydata};
  my $tag = $internal->{_current};
  
  if ($tag and $internal->{wanted}->{$tag}) {
    $internal->{$tag} .= html_escape($string);
  }
  elsif ($tag and $tag eq 'INSTALL') {
    $internal->{INSTALL}->{SCRIPT} .= $string;
  }
  else {
    
  }
}

sub end {
  my ($self, $tag) = @_;
  delete $self->{_mydata}->{_current};
}

sub final {
  my $self = shift;
  return $self->{_mydata};
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
  return undef unless $program;
  my @results = ();
  for my $base (map { File::Spec->catfile($_, $program) } File::Spec->path()) {
    if ($ENV{HOME} and not WIN32) {
      # only works on Unix, but that's normal:
      # on Win32 the shell doesn't have special treatment of '~'
      $base =~ s/~/$ENV{HOME}/o;
    }
    return $base if -x $base;
    
    if (WIN32) {
      for my $ext (@path_ext) {
	return "$base.$ext" if -x "$base.$ext";
      }
    }
  }
}

1;

__END__

=head1 NAME

PPM::Make - Make a ppm package from a CPAN distribution

=head1 SYNOPSIS

  my $ppm = PPM::Make->new( [options] );
  $ppm->make_ppm();

=head1 DESCRIPTION

See the supplied C<make_ppm> script for a command-line interface.

This module automates somewhat some of the steps needed to make
a I<ppm> (Perl Package Manager) package from a CPAN distribution.
It attempts to fill in the I<ABSTRACT> and I<AUTHOR> attributes of 
F<Makefile.PL>, if these are not supplied, and also uses C<pod2html> 
to generate a set of html documentation. It also adjusts I<CODEBASE> 
of I<package.ppd> to reflect the generated I<package.tar.gz> 
or I<package.zip> archive. Such packages are suitable both for 
local installation via

  C:\.cpan\build\package_src> ppm install

and for distribution via a repository.

Options can be given as some combination of key/value
pairs passed to the I<new()> constructor (described below) 
and those specified in a configuration file.
This file can either be that given by the value of
the I<PPM_CFG> environment variable or, if not set,
a file called F<.ppmcfg> at the top-level
directory (on Win32) or under I<HOME> (on Unix).

The configuration file is of an INI type. If a section
I<default> is specified as

  [ default ]
  option1 = value1
  option2 = value2

these values will be used as the default. Architecture-specific
values may be specified within their own section:

  [ MSWin32-x86-multi-thread-5.8 ]
  option1 = new_value1
  option3 = value3

In this case, an architecture specified as
I<MSWin32-x86-multi-thread-5.8> within PPM::Make will
have I<option1 = new_value1>, I<option2 = value2>,
and I<option3 = value3>, while any other architecture
will have I<option1 = value1> and I<option2 = value2>.
Options specified within the configuration file
can be overridden by passing the option into
the I<new()> method of PPM::Make.

Valid options that may be specified within the 
configuration file are those of PPM::Make, described below. 
For the I<program> and I<upload> options (which take hash references),
the keys (make, zip, unzip, tar, gzip),
or (ppd, ar, host, user, passwd), respectively,
should be specified. For binary options, a value
of I<yes|on> in the configuration file will be interpreted
as true, while I<no|off> will be interpreted as false.

=head2 OPTIONS

The available options accepted by the I<new> constructor are

=over

=item dist => value

If I<dist> is not specified, it will be assumed that one
is working inside an already unpacked source directory,
and the ppm distribution will be built from there. A value 
for I<dist> will be interpreted either as a CPAN-like source
distribution to fetch and build, or as a module name,
in which case I<CPAN.pm> will be used to infer the
corresponding distribution to grab.

=item binary => value

The value of I<binary> is used in the I<BINARY_LOCATION>
attribute passed to C<perl Makefile.PL>, and arises in
setting the I<HREF> attribute of the I<CODEBASE> field
in the ppd file.

=item arch_sub => boolean

Setting this option will insert the value of C<$Config{archname}>
(or the value of the I<arch> option, if given)
as a relative subdirectory in the I<HREF> attribute of the 
I<CODEBASE> field in the ppd file.

=item script => value

The value of I<script> is used in the I<PPM_INSTALL_SCRIPT>
attribute passed to C<perl Makefile.PL>, and arises in
setting the value of the I<INSTALL> field in the ppd file.
If this begins with I<http://> or I<ftp://>, so that the
script is assumed external, this will be
used as the I<HREF> attribute for I<INSTALL>.

=item exec => value

The value of I<exec> is used in the I<PPM_INSTALL_EXEC>
attribute passed to C<perl Makefile.PL>, and arises in
setting the I<EXEC> attribute of the I<INSTALL> field
in the ppd file. 

=item  add => \@files

The specified array reference contains a list of files
outside of the F<blib> directory to be added to the archive. 

=item zip => boolean

By default, a I<.tar.gz> distribution will be built, if possible. 
Giving I<zip> a true value forces a I<.zip> distribution to be made.

=item force => boolean

If a F<blib/> directory is detected, it will be assumed that
the distribution has already been made. Setting I<force> to
be a true value forces remaking the distribution.

=item ignore => boolean

If when building and testing a distribution, failure of any
supplied tests will be treated as a fatal error. Setting
I<ignore> to a true value causes failed tests to just
issue a warning.

=item os => value

If this option specified, the value, if present, will be used instead 
of the default for the I<NAME> attribute of the I<OS> field of the ppd 
file. If a value of an empty string is given, the I<OS> field will not 
be included in the  ppd file.

=item arch => value

If this option is specified, the value, if present, will be used instead 
of the default for the I<NAME> attribute of the I<ARCHITECTURE> field of 
the ppd file. If a value of an empty string is given, the 
I<ARCHITECTURE> field will not be included in the ppd file.

=item install => boolean

If specified, the C<ppm> utility will be used to install
the module.

=item remove => boolean

If specified, the directory used to build the ppm distribution
(with the I<dist> option) will be removed after a successful install.

=item program => { p1 => '/path/to/q1', p2 => '/path/to/q2', ...}

This option specifies that C</path/to/q1> should be used
for program C<p1>, etc., rather than the ones PPM::Make finds. The
programs specified can be one of C<tar>, C<gzip>, C<zip>, C<unzip>,
or C<make>.

=item as => boolean

Beginning with Perl-5.8, Activestate adds the Perl version number to
the NAME of the ARCHITECTURE tag in the ppd file. This option,
which is true by default, will make a ppd file compatible with this
practice.

=item vs => boolean

This option, if enabled, will add a version string 
(based on the VERSION reported in the ppd file) to the 
ppd and archive filenames.

=item upload => {key1 => val1, key2 => val2, ...}

If given, this option will copy the ppd and archive files
to the specified locations. The available options are

=over

=item ppd => $path_to_ppd_files

This is the location where the ppd file should be placed,
and must be given as an absolute pathname.

=item ar => $path_to_archive_files

This is the location where the archive file should be placed.
This may either be an absolute pathname or a relative one,
in which case it is interpreted to be relative to that
specified by I<ppd>. If this is not given, and yet I<ppd>
is specified, then this defaults, first of all, to the
value of I<arch_sub>, if given, or else to the value
of I<ppd>.

=item host => $hostname

If specified, an ftp transfer to the specified host is
done, with I<ppd> and I<ar> as described above.

=item user => $username

This specifies the user name to login as when transferring
via ftp.

=item passwd => $passwd

This is the associated password to use for I<user>

=back

=back

=head2 STEPS

The steps to make the PPM distribution are as follows. 

=over

=item determine available programs

For building and making the distribution, certain
programs will be needed. For unpacking and making 
I<.tar.gz> files, either I<Archive::Tar> and I<Compress::Zlib>
must be installed, or a C<tar> and C<gzip> program must
be available. For unpacking and making I<.zip> archives,
either I<Archive::Zip> must be present, or a C<zip> and
C<unzip> program must be available. Finally, a C<make>
program must be present.

=item fetch and unpack the distribution

If I<dist> is specified, the corresponding file is
fetched (by I<LWP::Simple>, if a I<URL> is specified).
If I<dist> appears to be a module name, the associated
distribution is determined by I<CPAN.pm>. The distribution
is then unpacked.

=item build the distribution

If needed, or if specied by the I<force> option, the
distribution is built by the usual

  C:\.cpan\build\package_src> perl Makefile.PL
  C:\.cpan\build\package_src> nmake
  C:\.cpan\build\package_src> nmake test

procedure. A failure in any of the tests will be considered
fatal unless the I<ignore> option is used. Additional
arguments to these commands present in either I<CPAN::Config>
or present in the I<binary> option to specify I<BINARY_LOCATION>
in F<Makefile.PL> will be added.

=item parse Makefile.PL

Some information contained in the I<WriteMakefile> attributes
of F<Makefile.PL> is then extracted.

=item parse Makefile

If certain information in F<Makefile.PL> can't be extracted,
F<Makefile> is tried.

=item determining the ABSTRACT

If an I<ABSTRACT> or I<ABSTRACT_FROM> attribute in F<Makefile.PL> 
is not given, an attempt is made to extract an abstract from the 
pod documentation of likely files.

=item determining the AUTHOR

If an I<AUTHOR> attribute in F<Makefile.PL> is not given,
an attempt is made to get the author information using I<CPAN.pm>.

=item HTML documentation

C<pod2html> is used to generate a set of html documentation.
This is placed under the F<blib/html/site/lib/> subdirectory, 
which C<ppm install> will install into the user's html tree.

=item Make the PPM distribution

A distribution file based on the contents of the F<blib/> directory
is then made. If possible, this will be a I<.tar.gz> file,
unless suitable software isn't available or if the I<zip>
option is used, in which case a I<.zip> archive is made, if possible.

=item adjust the PPD file

The F<package_name.ppd> file generated by C<nmake ppd> will
be edited appropriately. This includes filling in the 
I<ABSTRACT> and I<AUTHOR> fields, if needed and possible,
and also filling in the I<CODEBASE> field with the 
name of the generated archive file. This will incorporate
a possible I<binary> option used to specify
the I<HREF> attribute of the I<CODEBASE> field. 
Two routines are used in doing this - C<parse_ppd>, for
parsing the ppd file, and C<print_ppd>, for generating
the modified file.

=item install the distribution

If the I<install> option is specified, the C<ppm> utility,
if available, will be used to install the distribution.
The I<clean> option, if specified, will remove the build
directory and the distribution file for a distribution
specified with the I<dist> option.

=item upload the ppm files

If the I<upload> option is specified, the ppd and archive
files will be copied to the given locations.

=back

=head1 REQUIREMENTS

As well as the needed software for unpacking and
making I<.tar.gz> and I<.zip> archives, and a C<make>
program, it is assumed in this that I<CPAN.pm> is 
available and already configured, either site-wide or
through a user's F<$HOME/.cpan/CPAN/MyConfig.pm>.

Although the examples given above had a Win32 flavour,
like I<PPM>, no assumptions on the operating system are 
made in the module. 

=head1 COPYRIGHT

This program is copyright, 2002, by Randy Kobes <randy@theoryx5.uwinnipeg.ca>.
It is distributed under the same terms as Perl itself.

=head1 SEE ALSO

L<make_ppm>, and L<PPM>.

=cut

