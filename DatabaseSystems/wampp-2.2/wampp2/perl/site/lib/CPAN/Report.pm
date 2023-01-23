package CPAN::Report;
use Exporter ();
use strict;
use CPAN;
use vars qw(@ISA @EXPORT);
@ISA = qw(Exporter);
@EXPORT = qw(
	     autobundle bundle expand force get cvs_import
	     install make readme recompile shell test clean cpantest
	    );
use Config;
use Getopt::Long;
use MIME::Lite;
use IO::File;
use IO::Tee;
use Cwd;
use vars qw($VERSION);
$VERSION = '0.91';
my $cwd = cwd;
######################################################
# Configuration section
#####################################################

use vars qw($CPAN_testers $From $SMTP_HOST);

# The following is where the report is sent
#$CPAN_testers   = 'cpan-testers@perl.org';

# The following is your SMTP host, if you use SMTP
#$SMTP_HOST = '';

# The following is to set your return address
#$From = 'Whoever <me@wherever>';

######


$SMTP_HOST = 'smtp.mb.sympatico.ca';

$CPAN_testers = 'cpan-testers@perl.org';

$From = 'randy@theoryx5.uwinnipeg.ca';
######
######################################################
# End of Configuration section
#####################################################


use vars qw($LAST_MOD $LOG $Report %Grades);

$LOG           = $ENV{CPANLOG} ||
  ($ENV{TMPDIR} ? "$ENV{TMPDIR}/LOG.RPT" : 
   "$cwd/LOG.RPT");
$Report         = $ENV{CPANTEST} ||
  ($ENV{TMPDIR} ? "$ENV{TMPDIR}/CPANTEST.RPT" :
   "$cwd/CPANTEST.RPT");

%Grades = (     # Legal grades:
    'pass'      => "all tests pass",
    'fail'      => "some tests fail",
    'na'        => "package will not work on this platform",
    'unknown'   => "package did not include tests",
);

sub new {
  my $class = shift;

  my $self = {
	      Grade  => undef,
	      Package => undef,
	      No_comment => 0, 
	      Automatic  => 0,
	      CC => [],
	      Include => 0,
	      headers => {
			  To => $CPAN_testers,
			  From => $From || undef,
			  Subject => undef,
			  Cc => undef,
			  'X-reported-via' => "CPAN::Report version $VERSION",
			 },
	     };
    bless $self, $class;
}

sub CPAN::Shell::cpantest {
  my $self = shift;
  $self = ref($self) ? $self : CPAN::Report->new();
  unless ($self->{headers}->{From}) {
    $CPAN::Frontend->mywarn(qq{
Please configure \$From in CPAN::Report for your return address.
});
    return;
  }
  my ($Grade, $Module, $Author_email);
  local @ARGV = @_;
  GetOptions(
	     'g=s',  \$Grade,
	     'm=s',  \$Module,
	     'nc',   \$self->{No_comment},
	     'auto', \$self->{Automatic},
	     'cc' ,  \$Author_email,
	     'i',    \$self->{Include}
	    ) or do {
	      usage();
	      return;
	    };
  unless ($Grade) {
    usage();
    return;
  }
  unless ($Grades{$Grade}) {
    usage("grade `$Grade' is invalid");
    return;
  }
  $self->{Grade} = $Grade;
  if ($self->{Automatic} and !$Module) {
    usage("-m is required with -auto");
    return;
  }
  $Module = prompt('Module', $LAST_MOD ? $LAST_MOD : '') unless ($Module);
  unless (defined $Module) {
    $CPAN::Frontend->mywarn(qq{
Please specify the module to report on.
});
    return;
  }
  $LAST_MOD = $Module;
  my $mod = CPAN::Shell->expand('Module',$Module);
  unless ($mod) {
    $CPAN::Frontend->mywarn(qq{
No information on module "$Module" is available
});
    return;
  }
  my $cpan_file = $mod->cpan_file;
  if ($cpan_file eq 'N/A' or  $cpan_file =~ /^Contact Author/) {
    $CPAN::Frontend->mywarn(qq{
The distribution file for "$Module" is not on CPAN
});
    return;
  }
  ($self->{Package} = $cpan_file) =~ s!.*/(.*)\.(tar.gz|tgz|zip)$!$1!;

  for (@ARGV) {
    my $author = expand_author($_);
    next unless $author;
    push @{$self->{CC}},  $author;
  }

  $self->{No_comment} = 1 if $self->{Automatic};
  if ($Author_email) {
    my $dist = $CPAN::META->instance('CPAN::Distribution',$cpan_file);
    my $email = $CPAN::META->instance('CPAN::Author',
				      $dist->cpan_userid
				     )->email;
    if ($email) {
      push @{$self->{CC}}, $email;
    }
    else {
      $CPAN::Frontend->mywarn(qq{
No email address for the author of $Module is known.
});
    }
  }
  
  unless ($self->prepare_Report()) {
    $CPAN::Frontend->mywarn(qq{
Could not prepare the report.
});
    return;
  }

  unless ($self->send_Report()) {
    $CPAN::Frontend->mywarn(qq{
The report was *not* sent.
});
  }
}

sub CPAN::Distribution::make {
    my($self) = @_;
    $CPAN::Frontend->myprint(sprintf "Running make for %s\n", $self->id);
    # Emergency brake if they said install Pippi and get newest perl
    if ($self->isa_perl) {
      if (
	  $self->called_for ne $self->id &&
          ! $self->{force_update}
	 ) {
        # if we die here, we break bundles
	$CPAN::Frontend->mywarn(sprintf qq{
The most recent version "%s" of the module "%s"
comes with the current version of perl (%s).
I\'ll build that only if you ask for something like
    force install %s
or
    install %s
},
			       $CPAN::META->instance(
						     'CPAN::Module',
						     $self->called_for
						    )->cpan_version,
			       $self->called_for,
			       $self->isa_perl,
			       $self->called_for,
			       $self->id);
        sleep 5; return;
      }
    }
    $self->get;
  EXCUSE: {
	my @e;
	$self->{archived} eq "NO" and push @e,
	"Is neither a tar nor a zip archive.";

	$self->{unwrapped} eq "NO" and push @e,
	"had problems unarchiving. Please build manually";

	exists $self->{writemakefile} &&
	    $self->{writemakefile} =~ m/ ^ NO\s* ( .* ) /sx and push @e,
		$1 || "Had some problem writing Makefile";

	defined $self->{'make'} and push @e,
            "Has already been processed within this session";

        exists $self->{later} and length($self->{later}) and
            push @e, $self->{later};

	$CPAN::Frontend->myprint(join "", map {"  $_\n"} @e) and return if @e;
    }
    $CPAN::Frontend->myprint("\n  CPAN.pm: Going to build ".$self->id."\n\n");
    my $builddir = $self->dir;
    chdir $builddir or Carp::croak("Couldn't chdir $builddir: $!");
    $self->debug("Changed directory to $builddir") if $CPAN::DEBUG;

    if ($^O eq 'MacOS') {
        ExtUtils::MM_MacOS::make($self);
        return;
    }

    my $system;
    if ($self->{'configure'}) {
      $system = $self->{'configure'};
    } else {
	my($perl) = $self->perl or die "Couldn\'t find executable perl\n";
	my $switch = "";
# This needs a handler that can be turned on or off:
#	$switch = "-MExtUtils::MakeMaker ".
#	    "-Mops=:default,:filesys_read,:filesys_open,require,chdir"
#	    if $] > 5.00310;
	$system = "$perl $switch Makefile.PL $CPAN::Config->{makepl_arg}";
    }
    unless (exists $self->{writemakefile}) {
	local($SIG{ALRM}) = sub { die "inactivity_timeout reached\n" };
	my($ret,$pid);
	$@ = "";
	if ($CPAN::Config->{inactivity_timeout}) {
	    eval {
		alarm $CPAN::Config->{inactivity_timeout};
		local $SIG{CHLD}; # = sub { wait };
		if (defined($pid = fork)) {
		    if ($pid) { #parent
			# wait;
			waitpid $pid, 0;
		    } else {    #child
		      # note, this exec isn't necessary if
		      # inactivity_timeout is 0. On the Mac I'd
		      # suggest, we set it always to 0.
		      exec $system;
		    }
		} else {
		    $CPAN::Frontend->myprint("Cannot fork: $!");
		    return;
		}
	    };
	    alarm 0;
	    if ($@){
		kill 9, $pid;
		waitpid $pid, 0;
		$CPAN::Frontend->myprint($@);
		$self->{writemakefile} = "NO $@";
		$@ = "";
		return;
	    }
	} else {
	  $ret = system($system);
	  if ($ret != 0) {
	    $self->{writemakefile} = "NO Makefile.PL returned status $ret";
	    return;
	  }
	}
	if (-f "Makefile") {
	  $self->{writemakefile} = "YES";
          delete $self->{make_clean}; # if cleaned before, enable next
	} else {
	  $self->{writemakefile} =
	      qq{NO Makefile.PL refused to write a Makefile.};
	  # It's probably worth to record the reason, so let's retry
	  # local $/;
	  # my $fh = IO::File->new("$system |"); # STDERR? STDIN?
	  # $self->{writemakefile} .= <$fh>;
	}
    }
    if ($CPAN::Signal){
      delete $self->{force_update};
      return;
    }
    if (my @prereq = $self->unsat_prereq){
      return 1 if $self->follow_prereqs(@prereq); # signal success to the queuerunner
    }
    $CPAN::Report::LAST_MOD = $self->called_for;
     $system = join " ", $CPAN::Config->{'make'}, $CPAN::Config->{make_arg};
    my($stderr) = $^O =~ /Win/i ? "" : " 2>&1 ";
#################################################################
# Added Sep 18, 2001
# invoke "$system" via a pipe, as in CPAN::Distribution::install,
# so that it can be captured by CPAN::Report in a log file
    my($pipe) = FileHandle->new("$system $stderr |");
    my $tee = new IO::Tee(\*STDOUT, new IO::File(">$LOG"));
    select($tee);
    while (<$pipe>){
	$CPAN::Frontend->myprint($_);
    }
    $pipe->close;
    if ($?==0) {
#    if (system($system) == 0) {
# end addition
#################################################################
	 $CPAN::Frontend->myprint("  $system -- OK\n");
	 $self->{'make'} = "YES";
    } else {
	 $self->{writemakefile} ||= "YES";
	 $self->{'make'} = "NO";
	 $CPAN::Frontend->myprint("  $system -- NOT OK\n");
    }
    select(STDOUT);
}

sub CPAN::Distribution::test {
    my($self) = @_;
    $self->make;
    if ($CPAN::Signal){
      delete $self->{force_update};
      return;
    }
    $CPAN::Frontend->myprint("Running make test\n");
    if (my @prereq = $self->unsat_prereq){
      return 1 if $self->follow_prereqs(@prereq); # signal success to the queuerunner
    }
  EXCUSE: {
	my @e;
	exists $self->{make} or exists $self->{later} or push @e,
	"Make had some problems, maybe interrupted? Won't test";

	exists $self->{'make'} and
	    $self->{'make'} eq 'NO' and
		push @e, "Can't test without successful make";

	exists $self->{build_dir} or push @e, "Has no own directory";
        $self->{badtestcnt} ||= 0;
        $self->{badtestcnt} > 0 and
            push @e, "Won't repeat unsuccessful test during this command";

        exists $self->{later} and length($self->{later}) and
            push @e, $self->{later};

	$CPAN::Frontend->myprint(join "", map {"  $_\n"} @e) and return if @e;
    }
    chdir $self->{'build_dir'} or
	Carp::croak("Couldn't chdir to $self->{'build_dir'}");
    $self->debug("Changed directory to $self->{'build_dir'}")
	if $CPAN::DEBUG;

    if ($^O eq 'MacOS') {
        ExtUtils::MM_MacOS::make_test($self);
        return;
    }

    $CPAN::Report::LAST_MOD = $self->called_for;
    my $system = join " ", $CPAN::Config->{'make'}, "test";
    my($stderr) = $^O =~ /Win/i ? "" : " 2>&1 ";
#################################################################
# Added Sep 18, 2001
# invoke "$system" via a pipe, as in CPAN::Distribution::install,
# so that it can be captured by CPAN::Test in a log file
    my($pipe) = FileHandle->new("$system $stderr |");
    my $tee = new IO::Tee(\*STDOUT, new IO::File(">$LOG"));
    select($tee);
    while (<$pipe>){
	$CPAN::Frontend->myprint($_);
    }
    $pipe->close;
#    if (system($system) == 0) {
# end addition
#################################################################
    if ($?==0) {
	 $CPAN::Frontend->myprint("  $system -- OK\n");
	 $self->{make_test} = "YES";
    } else {
	 $self->{make_test} = "NO";
         $self->{badtestcnt}++;
	 $CPAN::Frontend->myprint("  $system -- NOT OK\n");
    }
    select(STDOUT);
}

#-> sub CPAN::Distribution::install ;
sub CPAN::Distribution::install {
    my($self) = @_;
    $self->test;
    if ($CPAN::Signal){
      delete $self->{force_update};
      return;
    }
    $CPAN::Frontend->myprint("Running make install\n");
  EXCUSE: {
	my @e;
	exists $self->{build_dir} or push @e, "Has no own directory";

	exists $self->{make} or exists $self->{later} or push @e,
	"Make had some problems, maybe interrupted? Won't install";

	exists $self->{'make'} and
	    $self->{'make'} eq 'NO' and
		push @e, "make had returned bad status, install seems impossible";

	push @e, "make test had returned bad status, ".
	    "won't install without force"
	    if exists $self->{'make_test'} and
	    $self->{'make_test'} eq 'NO' and
	    ! $self->{'force_update'};

	exists $self->{'install'} and push @e,
	$self->{'install'} eq "YES" ?
	    "Already done" : "Already tried without success";

        exists $self->{later} and length($self->{later}) and
            push @e, $self->{later};

	$CPAN::Frontend->myprint(join "", map {"  $_\n"} @e) and return if @e;
    }
    chdir $self->{'build_dir'} or
	Carp::croak("Couldn't chdir to $self->{'build_dir'}");
    $self->debug("Changed directory to $self->{'build_dir'}")
	if $CPAN::DEBUG;

    if ($^O eq 'MacOS') {
        ExtUtils::MM_MacOS::make_install($self);
        return;
    }

    $CPAN::Report::LAST_MOD = $self->called_for;
    my $system = join(" ", $CPAN::Config->{'make'},
		      "install", $CPAN::Config->{make_install_arg});
    my($stderr) = $^O =~ /Win/i ? "" : " 2>&1 ";
    my($pipe) = FileHandle->new("$system $stderr|");
    my($makeout) = "";
    my $tee = new IO::Tee(\*STDOUT, new IO::File(">$LOG"));
    select($tee);
    while (<$pipe>){
	$CPAN::Frontend->myprint($_);
	$makeout .= $_;
    }
    $pipe->close;
    if ($?==0) {
	 $CPAN::Frontend->myprint("  $system -- OK\n");
	 return $self->{'install'} = "YES";
    } else {
	 $self->{'install'} = "NO";
	 $CPAN::Frontend->myprint("  $system -- NOT OK\n");
	 if ($makeout =~ /permission/s && $> > 0) {
	     $CPAN::Frontend->myprint(qq{    You may have to su }.
				      qq{to root to install the package\n});
	 }
    }
    delete $self->{force_update};
    select(STDOUT);
}

### End of main program; subroutines follow


sub ask_cc {
  my $cc = prompt('CC', 'none');
  
  return ($cc eq 'none') ? undef : expand_author($cc);
}


# Given an author identifier (either a CPAN authorname or a proper
# email address), return a proper email address.
sub expand_author {
  my ($author)    = @_;
  
  if ($author =~ /^[-A-Z]+$/) {   # Smells like a CPAN authorname
    
    my $email = $CPAN::META->instance("CPAN::Author", $author)->email;
    if ($email) {
      return $email;
    }
    else {
      $CPAN::Frontend->mywarn(qq{
No email address for "$author" is known.
});
      return undef;
    }
  }
    elsif ($author =~ /^\S+@[a-zA-z0-9\.-]+$/) {
      return $author;
    }
  
  return undef;
}


# Prompt for a new value for $label, given $default; return the user's
# selection.
sub prompt {
  my ($label, $default)   = @_;
  
  $CPAN::Frontend->mywarn(qq{
$label [$default]: });
  my $input = scalar <STDIN>;
  chomp $input;
  
  return (length $input) ? $input : $default;
}


sub usage {
  my ($message)   = @_;
  
  $CPAN::Frontend->mywarn(qq{
Error:  $message
}) if defined $message;
  $CPAN::Frontend->mywarn(qq{
Usage:
  cpantest  -g grade [ -nc ] [ -auto ] [ -m module ]
              [ -cc ] [ -i ] [ email-addresses ]

  -g grade  Indicates the status of the tested package.
            Possible values for grade are:
});
  $CPAN::Frontend->mywarn(sprintf qq{
              %-10s  %s}, $_, $Grades{$_}) for (keys %Grades);
  
  $CPAN::Frontend->mywarn(qq{

  -m module  Specify the name of the module tested.
  -nc        No comments on the package are needed.
  -auto      Autosubmission (non-interactive); implies -nc.
  -cc        Send a copy of the report to the module author
  -i         Include a transcript of the last make/test/install session
}); 
  return;
}

sub prepare_Report {
  my $self = shift;
  my $comment_marker = $self->{No_comment} ? '' :
    q{--
[ insert comments here ]
      
};
  
  
  ### Compose report:
  unless (open (REPORT, ">$Report")) {
    $CPAN::Frontend->mywarn(qq{
Could not open $Report: $!
});
    return undef;
  }
  print REPORT <<"EOF";
This distribution has been tested as part of the cpan-testers
effort to test as many new uploads to CPAN as possible.
See http://testers.cpan.org/.

Please cc any replies to cpan-testers\@perl.org to keep other
test volunteers informed and to prevent duplicate effort.
$comment_marker  
EOF
  if ($self->{Include}) {
    unless (open (LOG, $LOG)) {
      $CPAN::Frontend->mywarn(qq{
Could not open $LOG: $!});
    return undef;
    }
    print REPORT "\n-- \n" if $self->{No_comment};
    print REPORT $_ while (<LOG>);
    close LOG;
  }
  print REPORT "\n-- \n\n";
  print REPORT Config::myconfig();
  close REPORT;
  
  unless ($self->{No_comment}) {
    my $editor  = $ENV{VISUAL} || $ENV{EDITOR} || $ENV{EDIT}
      || ($^O eq 'VMS'     and "edit/tpu")
	|| ($^O eq 'MSWin32' and 'notepad.exe')
	  || 'vi';
    
    $editor = prompt('Editor', $editor);
    my $file = $Report;
    $file =~ tr!/!\\! if $^O eq 'MSWin32';
    if (system "$editor $file") {
      $CPAN::Frontend->mywarn(qq{
The editor "$editor" could not be run
});
      return undef;
    }
    unless (scalar @{$self->{CC}}) {
      my $cc = ask_cc();
      push @{$self->{CC}}, $cc if $cc;
    }
  }
  return 1;
}

sub send_Report {
  my $self = shift;
  $self->{headers}->{Subject} = uc($self->{Grade}) 
    . " $self->{Package} $Config{archname} $Config{osvers}";

  my $number = scalar @{$self->{CC}};
  $self->{headers}->{Cc} =  $number > 0 ? 
    ($number == 1 ? $self->{CC}->[0] :
      join ', ', @{$self->{CC}} ) : undef;

  unless ($self->{Automatic}) {
    $self->{headers}->{Subject} = 
      prompt('Subject', $self->{headers}->{Subject});
    
    for (sort keys %{$self->{headers}}) {
      if (! $self->{headers}->{$_}) {
	delete $self->{headers}->{$_};
	next;
      }
    $CPAN::Frontend->mywarn(qq{
$_:  $self->{headers}->{$_}}) ;
    }

    if (prompt("\nSend/Ignore", 'Ignore') !~ /^[Ss]/) {
      $CPAN::Frontend->mywarn(qq{
Ignoring message.});
      return undef;
    }
  }

  MIME::Lite->send('smtp', $SMTP_HOST, Timeout => 60) if $SMTP_HOST;

  my $msg = MIME::Lite->new(%{$self->{headers}}, 
			    Path => $Report, Type => 'TEXT');
  unless ($msg) {
    $CPAN::Frontend->mywarn(qq{
Could not send create message});
    return undef;
  }
  
  unless ($msg->send) {
    $CPAN::Frontend->mywarn(qq{
Could not send message});
    return undef;
  }
  return 1;
}

1;

__END__

=head1 NAME

CPAN::Report - send a report on a module to the cpan-testers list

=head1 SYNOPSIS

  bash$ perl -MCPAN::Report -e shell

  cpan> install Net::FTP
  cpan> cpantest -g pass -m  Net::FTP -nc -cc -i

=head1 DESCRIPTION

CPAN:Report adds to the CPAN.pm shell the functionality to
send package test results for a particular module to the cpan-testers 
list. See B<http://testers.cpan.org/> for details. It is assumed that the
version of the package being tested is that as reported by CPAN.pm
for the named module.

When the CPAN.pm shell is invoked via C<perl -MCPAN::Report -e shell>,
sending a report is done with the C<cpantest> shell command:

  cpan> cpantest -g grade [ -nc ] [ -auto ] [ -m module ]
           [ -cc ] [ -i ] [ email-addresses ]

where the available options are

=over 4

=item -g grade

C<grade> indicates the success or failure of the package's builtin
tests, and is one of:

    grade     meaning
    -----     -------
    pass      all tests included with the package passed
    fail      some tests failed
    na        the package does not work on this platform
    unknown   the package did not include tests

=item -m module

C<module> is the name of the module being tested.  If not specified
on the command line, you will be prompted for one.

=item -nc

No comment; you will not be prompted to supply a comment about the
package.

=item -auto

Autosubmission (non-interactive); you won't be prompted to supply any
information that you didn't provide on the command line.  Implies C<-nc>.

=item -cc

Include a copy of the report to the author of the module

=item -i

Include in the report a transcript of the last make/test/install
session done within the shell.

=item email-addresses

A list of additional email addresses that should be cc:'d in this
report. If such an address matches C< /^[-A-Z]+$/ >, it will
assume this is a CPAN id, and look up the address for you.

=back

=head1 CONFIGURATION

This module requires I<MIME::Lite>, I<Getopt::Long>,
and I<IO::Tee>. Near the top of I<Report.pm> are possible
variables that you might like to change from the values set
at the time of building - these are

=over

=item $SMTP_HOST

Set this to specify an SMTP host to use to send
the report. If this is not set, C<sendmail> will
be used.

=item $From

Set this to specify your return address in the report.

=item $CPAN_testers

This specifies where the report should be mailed to.

=back

=head1 AUTHOR

Randy Kobes E<lt>F<randy@theory.uwinnipeg.ca>E<gt>, based on
the C<cpantest> script of Kurt Starsinic E<lt>F<kstar@isinet.com>E<gt>.

=head1 COPYRIGHT

Copyright (c) 1998 Kurt Starsinic, 2001 Randy Kobes.
This program is free software; you may redistribute it
and/or modify it under the same terms as Perl itself.

=cut
