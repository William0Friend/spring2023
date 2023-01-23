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
#use warnings;
use Tk;
use PPM;
use Tk::MListbox;
require Tk::DialogBox;
require Tk::BrowseEntry;
require Tk::LabEntry;
use CPAN;

my $ppmv = '2.1.6';
our ($type, $message, $no_case, $save, $repository);
$type = 'Package';
$no_case = 1;
$save = 1;

my (%reps, %alias, @choices, %indices);
## Create main perl/tk window.
my $mw = MainWindow->new;
$mw->title("Interface to PPM $ppmv");

my ($info, $error, $upgrades);

## Create the MListbox widget. 
## Specify alternative comparison routine for integers and date.
## frame, but since the "Show All" button references $ml, we have to create
## it now. 

my %tan = qw(-bg tan -fg black);
my %orange = qw(-bg orange -fg black);
my %green = qw(-bg green -fg black);
my %cyan = qw(-bg cyan -fg black);
my %yellow = qw(-bg yellow -fg black);

CPAN::Config->load unless $CPAN::Config_loaded++;
my $top = $mw->Frame(-label => "Interface to PPM $ppmv");
my $options = $mw->Frame();
my $left = $mw->Frame(-label => 'Local');
my $middle = $mw->Frame();
my $right = $mw->Frame(-label => 'Repository');
my $bottom = $mw->Frame();

my $cb_label = 
  $options->Label(-text => 'Treat query as a',
		 )->pack(-side => 'left', -padx => 4);

my $package = $options->Radiobutton(-text => 'Package',
				   -variable => \$type,
				   -value => 'Package',
				  )->pack(-side => 'left');
help_msg($package, 'Treat search term as a package name');

my $abstract = $options->Radiobutton(-text => 'Abstract',
				     -variable => \$type,
				     -value => 'ABSTRACT',
				    )->pack(-side => 'left');
help_msg($abstract, 'Treat search term as part of the abstract');

my $author = $options->Radiobutton(-text => 'Author',
				   -variable => \$type,
				   -value => 'AUTHOR',
				  )->pack(-side => 'left');
help_msg($author, 'Treat search term as an author name');

my $module = $options->Radiobutton(-text => 'Module',
				   -variable => \$type,
				   -value => 'Module',
				  )->pack(-side => 'left');
help_msg($module, 'Treat search term as an (exact) module name');

my $search_label = 
  $top->Label(-text => 'Search term:')->pack(-side => 'left');
my $search_box = 
  $top->Entry(-width => 20)->pack(-side => 'left', -padx => 10);
help_msg($search_box, 'Enter a (regular expression) search term');

#$search_box->bind('<Return>', [\&search]);

my $search = $top->Button(-text => 'Search',
			  -command => [\&search],
			 )->pack(-side => 'left', -padx => 10);
help_msg($search, 'Perform a repository search');

my $query = $top->Button(-text => 'Query',
			 -command => [\&query],
			)->pack(-side => 'left', -padx => 10, -pady => 5);
help_msg($query, 'Perform a query on installed packages');

my $inst = $top->Button(-text => 'Install',
			-command => [\&ppminstall_search],
		       )->pack(-side => 'left', -padx => 10, -pady => 5);
help_msg($inst, 'Search for and install a package');

my $clear = $top->Button(-text => 'Clear',
			 -command => sub{$search_box->delete(0, 'end');},
			 )->pack(-side => 'left', -padx => 10);
help_msg($clear, 'Clear the Search box entry');

my $cb_case = $top->Checkbutton(-text => 'case insensitive',
				-variable => \$no_case,
				-onvalue => 1,
				-offvalue => 0,
			       )
  ->pack(-side => 'left', -padx => 10, -pady => 5);
help_msg($cb_case, 'Perform case sensitive/insensitive searches');

my $lscrolly = $left->Scrollbar();
my $local = 
  $left->MListbox(-yscrollcommand => ['set' => $lscrolly],
		  -background => 'white', 
		  -foreground => 'blue',
		  -textwidth => 10,
		  -highlightthickness => 2,
		  -width => 0,
		  -selectmode => 'single',
		  -bd=>2,
		  -relief=>'sunken',
		  -columns=>[
			     [qw/-text Package -textwidth 18/, %green,
			      -comparecmd => sub {lc $_[0] cmp lc $_[1]}],
			     [qw/-text Version -textwidth 6/, %orange, 
			      -comparecmd => sub {$_[0] <=> $_[1]}],
			    ]);
$lscrolly->configure(-command => ['yview' => $local]);
$lscrolly->pack(-side => 'left', -fill => 'y');

$local->pack(-side => 'left', -fill => 'both');
$local->bindRows('<Button-3>', [\&display_info, 'local']);
$local->bindRows('<Double-Button-1>', [\&upgrade]);

my $verify = $left->Button(-text => 'Verify',
			   -command => [\&verify],
			  )->pack(-side => 'top',
				  -anchor => 'sw',
				  -fill => 'x');
help_msg($verify, 'Verify a locally installed package');

my $upgrade = $left->Button(-text => 'Upgrade',
			    -command => [\&upgrade],
			   )->pack(-side => 'top', 
				   -anchor => 'w', 
				   -fill => 'x');
help_msg($upgrade, 'Upgrade the selected local package');

my $remove = $left->Button(-text => 'Remove',
			   -command => [\&remove],
			  )->pack(-side => 'top', 
				  -anchor => 'w', 
				  -fill => 'x');
help_msg($remove, 'Remove the selected local package');

my $clr_local = $left->Button(-text => 'Clear',
			      -command => [\&clear, $local],
			     )->pack(-side => 'top', 
				     -anchor => 'w', 
				     -fill => 'x');
help_msg($clr_local, 'Clear the local listbox entries');

set_reps();
$middle->Label( -text => 'Repository: ')
  ->pack(-side => 'top', -anchor => 'n');

my $replist = 
  $middle->BrowseEntry(-variable => \$repository,
		       -choices => [@choices],
		      )
  ->pack(-side => 'top', -anchor => 'n', -pady => 5);  
help_msg($replist, 'Choose a repository to search');

my $help_msg =<<'END';
Right click on a selection
for further information, or
double click a selection
to upgrade/install.
END

my $info_label = $middle->Label(-text => $help_msg, 
				-relief => 'groove',
			       )->pack(-side => 'top', 
				       -padx => 25, -pady => 15,
				       -anchor => 'center');

my $rscrolly = $right->Scrollbar();
my $rep = 
  $right->MListbox(-yscrollcommand => ['set' => $rscrolly],
		   #		   -background => 'white', 
		   -foreground => 'blue',
		   #		   -textwidth => 10,
		   -highlightthickness => 2,
		   #		   -width => 0,
		   -selectmode => 'single',
		   -bd=>2,
		   -relief=>'sunken',
		   -columns=>[
			      [qw/-text Package -textwidth 18/, %green,
			       -comparecmd => sub {lc $_[0] cmp lc $_[1]}],
			      [qw/-text Version -textwidth 6/, %orange, 
			       -comparecmd => sub {$_[0] <=> $_[1]}],
			      [],
			     ]);
$rep->columnHide(2);
$rscrolly->configure(-command => ['yview' => $rep]);
$rscrolly->pack(-side => 'right', -fill => 'y');

$rep->pack(-side => 'left', -fill => 'x');
$rep->pack(-side => 'right', -fill => 'y');
$rep->bindRows('<Button-3>', [\&display_info]);
$rep->bindRows('<Double-Button-1>', [\&ppminstall_bind]);

my $install = $right->Button(-text => 'Install',
			     -command => [\&ppminstall_bind],
			    )->pack(-side => 'top', 
				    -anchor => 'n',
				    -fill => 'x');
help_msg($install, 'Install the selected package');

my $summary = $right->Button(-text => 'Summary',
			     -command => [\&summary],
			    )->pack(-side => 'top', 
				    -anchor => 's',
				    -fill => 'x');
help_msg($summary, 'Get a summary of packages available from repositories');

my $rep_edit = $right->Button(-text => 'Repositories',
			      -command => [\&rep],
			     )->pack(-side => 'top', 
				     -anchor => 'w', 
				     -fill => 'x');
help_msg($rep_edit, 'Add or remove a site from the repository list');

my $clr_rep = $right->Button(-text => 'Clear',
			     -command => [\&clear, $rep],
			    )->pack(-side => 'top', 
				    -anchor => 'w', 
				    -fill => 'x');
help_msg($clr_rep, 'Clear the repository listbox entries');

my $stdout = $bottom->Scrolled('Text',
			       -scrollbars => 'w',
			       -height => 5,
			      )->pack(-side => 'top', 
				      -fill => 'x',
				      -anchor => 's');

my $help = $bottom->Label(-textvariable => \$message,
			  -relief => 'groove',
			 )->pack(-side => 'top', -expand => 1,-fill => 'x');
my $exit = $bottom->Button(-text => 'Exit',
			   -command => [$mw => 'destroy'],
			  )->pack(-side => 'top', -anchor => 'center');
help_msg($exit, 'Quit Tk-PPM');

tie(*STDOUT, 'Tk::Text', $stdout);

$top->pack(-side => 'top');
$options->pack(-side => 'top');
$bottom->pack(-side => 'bottom', -fill => 'x');
$left->pack(-side => 'left');
$middle->pack(-side => 'left');
$right->pack(-side => 'right');

MainLoop;

sub set_reps {
  %reps = PPM::ListOfRepositories();
  %alias = reverse %reps;
  @choices = ('All available', keys %reps);
  %indices = map {$choices[$_] => $_} (0 .. $#choices);
  $repository ||= $choices[0];
}

sub search_term {
  my %args = @_;
  my $RE = trim($search_box->get());
  eval { $RE =~ /$RE/ };
  if ($@) {
    $error = qq{"$RE" is not a valid regular expression.};
    return;
  }
  unless ($args{all}) {
    unless ($RE =~ /\w{1}/) {
      $error = q{The search query must contain at least one word character};
      return;
    }
  }
  if ($type eq 'Module') {
    my $dist = mod_to_dist($RE);
    unless ($dist) {
      $error = qq{Could not find a distribution containing "$RE"};
      return;
    }
    $RE = "^$dist\$";
    $type = 'Package';
  }
  else {
    if ($args{exact}) {
      $RE = "^$RE\$";
    }
    else {
      $RE = "(?i)$RE" if ($no_case == 1);
    }
  }
  return $RE;
}

sub search_tag {
  return ($type eq 'AUTHOR' or $type eq 'ABSTRACT') ?
    $type : undef;
}

sub query {
  my $RE = search_term(all => 1);
  my $searchtag = search_tag();
  unless ($RE) {
    dialog_error('Invalid search term', q{Could not perform the search.});
    return;
  }
  my %installed = InstalledPackageProperties();
  foreach(keys %installed) {
    if ($searchtag) {
      delete $installed{$_} unless $installed{$_}{$searchtag} =~ /$RE/;
    }
    else {
      delete $installed{$_} unless /$RE/;
    }
  }
  if (%installed) {
    $local->delete(0, 'end');
    populate(\%installed, 'local');
  }
  else {
    dialog_info('No matches',
		qq{No matches for "$RE" were found});
  }
}

sub search {
  my $searchRE;
  unless ($searchRE = search_term()) {
    dialog_error('Invalid search term', q{Could not perform the search.});
    return;
  }
  my $packages;
  unless ($packages = search_for($searchRE) ) {
    dialog_error('No results found', 
		 qq{Search failed.});
    return;
  }
  $rep->delete(0, 'end');
  populate($packages->{$_}, $_) foreach (keys %$packages);
}

sub search_for {
  my ($searchRE, $location) = @_;
  my $searchtag = search_tag();
  msg_update(qq{Searching for /$searchRE/ of type "$type" - please wait ...});
  my ($packages, @locations);
  if ($location) {
    @locations = ($location);
  }
  else {
    @locations = ($repository eq 'All available') ?
      values %reps : ($reps{$repository});
  }
  foreach my $loc (@locations) {
    my %summary;
    # see if the repository has server-side searching
    if (defined $searchRE && 
	(%summary = ServerSearch(location => $loc, 
				 searchRE => $searchRE, 
				 searchtag => $searchtag))) {
      # XXX: clean this up
      foreach my $package (keys %{$summary{$loc}}) {
	$packages->{$loc}->{$package} = \%{$summary{$loc}{$package}};
      }
      next;
    }
    
    # see if a summary file is available
    %summary = RepositorySummary(location => $loc);
    if (%summary) {
      foreach my $package (keys %{$summary{$loc}}) {
	next if (defined $searchtag && 
		 $summary{$loc}{$package}{$searchtag} !~ /$searchRE/);
	next if (!defined $searchtag && 
		 defined $searchRE && $package !~ /$searchRE/);
	$packages->{$loc}->{$package} = \%{$summary{$loc}{$package}};
      }
    }
    else {
      my %ppds = PPM::RepositoryPackages(location => $loc);
      # No summary: oh my, nothing but 'Net
      foreach my $package (@{$ppds{$loc}}) {
	my %package_details = 
	  RepositoryPackageProperties(package => $package, 
				      location => $loc);
	next unless %package_details;
	next if (defined $searchtag && 
		 $package_details{$searchtag} !~ /$searchRE/);
	next if (!defined $searchtag && 
		 defined $searchRE && $package !~ /$searchRE/);
	$packages->{$loc}->{$package} = \%package_details;
      }
    }
  }
  msg_update(qq{  Done!});
  unless ($packages) {
    $error = qq{No matches for "$searchRE" were found};
    return;
  }
  return $packages;
}

sub verify {
  my ($index, $pack, $version, $loc) = get_selection($local) or do {
    dialog_error('No selection made', 'Please make a selection first');
    return;
  };
  my $resp = verify_pack($pack);
  if ($resp eq 'OK') {
    dialog_info('Up to date',
	       qq{"$pack" is up to date});
  }
  elsif ($resp eq 'UK') {
    dialog_info('No upgrade found',
		qq{No upgrade for "$pack" was found});
  }
  else {
    dialog_info('Upgrade available',
		qq{An upgrade to $resp for "$pack" from $alias{$upgrades->{$pack}->{location}} is available});
  }
}

sub upgrade {
  my ($index, $pack, $version, $loc) = get_selection($local) or do {
    dialog_error('No selection made', 'Please make a selection first');
    return;
  };
  my $resp = verify_pack($pack);
  if ($resp eq 'OK') {
    dialog_info('Up to date',
	       qq{"$pack" is up to date});
    return;
  }
  elsif ($resp eq 'UK') {
    dialog_info('No upgrade found',
		qq{No upgrade for "$pack" was found});
    return;
  }
  else {
    $loc = $upgrades->{$pack}->{location};
    return unless 
      dialog_yes_no('Upgrade available',
		    qq{Upgrade "$pack" to $resp from $alias{$loc}?});
  }
  msg_update(qq{Removing "$pack" - please wait ....});
  unless (RemovePackage(package => $pack)) {
    $error = $PPM::PPMERR;
    dialog_error('Removal error', 
		 qq{Removal of "$pack" failed.});
    return;
  }
  msg_update(qq{Done!});
  msg_update(qq{Installing "$pack" - please wait ....});
  unless (InstallPackage(package => $pack, location => $reps{$loc})) {
    $error = $PPM::PPMERR;
    dialog_error('Installation error', 
		 qq{Installation of "$pack" failed.});
    return;
  }
  msg_update(qq{Done!});
  $local->delete($index);
  $local->insert($index, 
		 [$pack, fix_version($upgrades->{$pack}->{version})]);
  $info->{$pack}->{local}->{version} = $upgrades->{$pack}->{version};
  dialog_info('Installation successful',
	      qq{Installation of "$pack" was successful});
}

sub verify_pack {
  my $pack = shift;
  my $packages;
  unless ($packages = search_for(qq{^$pack\$}) ) {
    return 'UK';
  }
  my $version = $info->{$pack}->{local}->{version};
  my @installed_version = split(',', $version);
  my ($available, $remote_version, $location);
  foreach (keys %$packages) {
    $location = $_;
    $remote_version = $packages->{$location}->{$pack}->{VERSION};
    my @remote_version = split (',', $remote_version);
    foreach(0..3) {
      next if $installed_version[$_] == $remote_version[$_];
      $available++ if $installed_version[$_] < $remote_version[$_];
      last;
    }
    last if $available;
  }
  if ($available) {
    $upgrades->{$pack} = {location => $location,
			  version => $remote_version};
    return fix_version($remote_version);
  }
  else {
    return 'OK';
  }
}

sub get_selection {
  my $widget = shift;
  my @sel = $widget->curselection;
  return unless (@sel == 1);
  my $pack = ($widget->getRow($sel[0]))[0];
  my $version = 
  my $loc = ($widget->getRow($sel[0]))[2] ?
    ($widget->getRow($sel[0]))[2] : undef;
  return ($sel[0], $pack, ($widget->getRow($sel[0]))[1], $loc);
}

sub remove {
  my ($index, $package, $version, $loc) = get_selection($local) or do {
    dialog_error('No selection made', 'Please make a selection first');
    return;
  };
  return unless dialog_yes_no('Confirm delete',
			      qq{Remove "$package?"});
  msg_update(qq{Removing "$package" - please wait ....});
  unless (RemovePackage(package => $package)) {
    $error = $PPM::PPMERR;
    dialog_error('Removal error', 
		 qq{Removal of "$package" failed.});
    return;
  }
  msg_update(qq{Done!});
  dialog_info('Removal suceessful',
	     qq{Removed "$package"});
  $local->delete($index);
}

sub ppminstall_bind {
  my ($widget, $hash, %args) = @_;
  my ($index, $package, $version, $alias) = get_selection($rep) or do {
      dialog_error('No selection made', 'Please make a selection first');
      return;
    };
  ppminstall($package, $reps{$alias}, $version);
}

sub ppminstall_search {
  my $searchtag = search_tag();
  if ($searchtag and ($searchtag eq 'AUTHOR' or $searchtag eq 'ABSTRACT')) {
    dialog_error('Cannot install', 
		 qq{Cannot install "AUTHORS" or "ABSTRACTS"});
    return;
  }
  my $searchRE;
  unless ($searchRE = search_term(exact => 1)) {
    dialog_error('Invalid search term', q{Could not perform the search.});
    return;
  }
  my $packages;
  unless ($packages = search_for($searchRE) ) {
    dialog_error('No results found', 
		 qq{Search failed.});
    return;
  }
  my @locs = keys %$packages;
  my @packs = keys %{$packages->{$locs[0]}};
  
  ppminstall($packs[0], $locs[0], 
	     $packages->{$locs[0]}->{$packs[0]}->{version});
}

sub ppminstall {
  my ($package, $location, $version) = @_;
  return unless ($package);
  my %installed = InstalledPackageProperties();
  if (my $pkg = (grep {/^$package$/i} keys %installed)[0]) {
    my $version = fix_version($installed{$pkg}{'VERSION'});
    dialog_error('Already installed', 
		 qq{Version $version of '$pkg' is already installed.\n} .
		 qq{Either remove it or use the upgrade button.});
    return;
  }
  return unless dialog_yes_no('Confirm install',
			      qq{Install "$package?"});
  msg_update(qq{Installing "$package" - please wait ....});
  unless (InstallPackage(package => $package, location => $location)) {
    $error = $PPM::PPMERR;
    dialog_error('Installation error', 
		 qq{Installation of "$package" failed.});
    return;
  }
  msg_update(qq{Done!});
  dialog_info('Installation successful',
	      qq{Installed "$package".});
  my $hashref = $info->{$package}->{$location};
  foreach (keys %$hashref) {
    next if ($_ eq 'location');
    $info->{$package}->{local}->{$_} = $hashref->{$_};
  }
  my $version = fix_version($info->{$package}->{local}->{version});
  my $index = 'end';
  my $version = fix_version($info->{$package}->{local}->{version});
  if ($index = get_index($package, $local)) {
    $local->delete($index);
  }
  $index ||= 'end';
  $local->insert($index, [$package, $version]);
}

sub summary {
  my %packages;
  msg_update(qq{Obtaining summary from "$repository" - please wait ....});
  my @locations = ($repository eq 'All available') ?
      values %reps : ($reps{$repository});

  foreach my $loc (@locations) {
    # see if the repository has server-side searching
    # see if a summary file is available
    my %summary = RepositorySummary(location => $loc);
    if (%summary) {
      foreach my $package (keys %{$summary{$loc}}) {
	$packages{$loc}{$package} = \%{$summary{$loc}{$package}};
      }
    }
    else {
      my %ppds = PPM::RepositoryPackages(location => $loc);
      # No summary: oh my, nothing but 'Net
      foreach my $package (@{$ppds{$loc}}) {
	my %package_details = 
	  RepositoryPackageProperties(package => $package, 
				      location => $loc);
	next unless %package_details;
	$packages{$loc}{$package} = \%package_details;
      }
    }
  }
  msg_update(q{Done!});
  unless (%packages) {
    dialog_info(q{No summary available},
		q{Cannot get summary information});
    return;
  }
  foreach (keys %packages) {
    populate(\%{$packages{$_}}, $_);
  }
}

sub rep {
  my $reps = $mw->Toplevel;
  $reps->title('Repositories');
  my @choices = keys %reps;
  my $rep = $choices[0];
  my $add = $reps{$rep};
  $reps->Label( -text => 'Repository: ')
    ->grid(-row => 0, -pady => 5, -padx => 5,
	   -column => 0, -sticky => 'e');  
  my $box = 
    $reps->BrowseEntry(-variable => \$rep,
		       -choices => [@choices],
		       -browsecmd => sub{$add = $reps{$rep}},
		      )
      ->grid(-row => 0, -column => 1, -columnspan => 2, 
             -pady => 5, -padx => 5, -sticky => 'w', -ipadx => 5);
  
  $reps->Label( -text => 'URL: ')
    ->grid(-row => 1, -column => 0, -sticky => 'e', -pady => 10);
  $reps->Label( -textvariable => \$add, -relief => 'groove')
    ->grid(-row => 1, -column => 1, -columnspan => 3, -pady => 10,
           -sticky => 'w', -padx => 5);
 
  $reps->Button( -text => 'New',
		 -command => [\&new_rep, $reps],
	       )->grid(-row => 2, -pady => 10, 
		       -padx => 10, -column => 1, -sticky => 'e');
  $reps->Button( -text => 'Delete',
		 -command => [\&del_rep, $reps, \$rep],
	       )->grid(-row => 2, -pady => 10, 
		       -padx => 10, -column => 2, -sticky => 'w');
  $reps->Checkbutton(-text => 'save changes',
		     -variable => \$save,
		     -onvalue => 1,
		     -offvalue => 0,
		    )
    ->grid(-row => 2, -column => 0, 
	   -pady => 5,  -sticky => 'e');
  
  $reps->Button( -text => 'Close',
		 -command => [ $reps => 'destroy'],
	       )->grid(-row => 2, -pady => 10, -ipadx => 5,
		       -padx => 10, -column => 3, -sticky => 'e');
}

sub del_rep {
  my ($tl, $rep) = @_;
  return unless dialog_yes_no('Confirm delete',
			      qq{Delete "$$rep" from the repository list?});
  RemoveRepository(repository => $$rep, save => $save);
  $tl->destroy;
  $replist->delete($indices{$$rep});
  set_reps();
  rep();
}

sub new_rep {
  my $tl = shift;
  my ($rep, $loc);
  my $add = $mw->DialogBox(-title => 'Add a repository',
			   -buttons => ['OK', 'Cancel']);
  $add->add('LabEntry', -textvariable => \$rep, 
	    -label => 'Name: ', -width => 20, 
	    -labelPack => [-side => 'left'])
    ->grid(-row => 0, -column => 0, -pady => 10,
	   -sticky => 'w');
  $add->add('LabEntry', -textvariable => \$loc, 
	    -width => 40, -label => 'URL:   ', 
	    -labelPack => [-side => 'left'])
    ->grid(-row => 1, -column => 0, -pady => 10,
	   -sticky => 'w');
  my $ans = $add->Show;
  return unless ($ans eq 'OK');
  $rep = trim($rep);
  $loc = trim($loc);
  unless ($rep and $loc) {
    dialog_error('Incomplete specification',
		q{Please specify both a name and the URL for the repository});
    return;
  }
  AddRepository(repository => $rep, location => $loc, save => $save);
  $tl->destroy;
  $replist->insert('end', $rep);
  set_reps();
  rep();
}

sub populate {
  my ($data, $where) = @_;
  foreach my $package (sort keys %{$data}) {
    my $author = $data->{$package}->{AUTHOR};
    my $version = fix_version($data->{$package}->{VERSION});
    if ($author and $author =~ /Unknown/i) {
      $author = 'Unknown';
    }
    $info->{$package}->{$where}
      = {author => $author,
	 abstract => $data->{$package}->{ABSTRACT},
	 version => $data->{$package}->{VERSION},
	};
    if ($where eq 'local') {
      $local->insert('end', [$package, $version]);
    }
    else {
      $rep->insert('end', [$package, $version, $alias{$where}]);
    }
  }
}

sub fix_version {
  local $_ = shift;
  s/(,0)*$//;
  tr/,/./;
  return $_;
}

sub trim {
  local $_ = shift;
  s/^\s*//;
  s/\s*$//;
  return $_;
}

sub get_index {
  my ($match, $widget) = @_;
  my @list = $widget->get(0, 'end');
  my $i = 0;
  foreach (@list) {
    return $i if ($_->[0] eq $match);
    $i++;
  }
  return;
}

sub clear {
  my $widget = shift;
  $widget->delete(0, 'end');
}

sub display_info {
  my ($widget, $hash, $where) = @_;
  my ($package, $index, $version, $loc);
  if ($where and $where eq 'local') {
    ($index, $package, $version) = get_selection($widget);
  }
  else {
    ($index, $package, $version, $where) = get_selection($widget);
  }
  unless ($package) {
    dialog_error('Selection error', 'Please make a selection first');
    return;
  }
  my $loc = $where eq 'local' ? 'local' : $reps{$where};
  my $vers = fix_version($info->{$package}->{$loc}->{version});
  my $msg = <<"END";
 Package "$package":
   Version: $vers        
   Author: $info->{$package}->{$loc}->{author}             
   Abstract: $info->{$package}->{$loc}->{abstract}              
END
  if ($where ne 'local') {
    $msg .= qq[   Location: $where                      \n];
  }
  dialog_info(qq{Information for "$package"}, $msg);
}

sub help_msg {
  my ($widget, $msg) = @_;
  $widget->bind('<Enter>', [sub {$message = $_[1]; }, $msg]);
  $widget->bind('<Leave>', [sub {$message = ''; }]);
}

sub msg_update {
  $message = shift;
  $mw->update;
}

sub dialog_error {
  my ($title, $msg) = @_;
  $msg .= "\n\n$error" if $error;
  my $ans = $mw->messageBox(-title => $title, -message => $msg,
			    -icon => 'error', -type => 'OK');
  undef $error;
}

sub dialog_info {
  my ($title, $msg) = @_;
  my $ans = $mw->messageBox(-title => $title, -message => $msg,
			    -icon => 'info', -type => 'OK');
  undef $error;
}

sub dialog_yes_no {
  my ($title, $msg) = @_;
  my $ans = $mw->messageBox(-title => $title, -message => $msg,
			    -icon => 'warning', -type => 'YesNo');
  return ($ans eq 'yes') ? 1 : 0;
}

sub mod_to_dist {
  my $mod = shift;
  my $ext = qr{\.(tar\.gz|tgz|tar\.Z|zip)};
  $mod =~ s!-!::!g;
  msg_update(qq{Searching CPAN database for "$mod" - please wait ...});
  my $module = CPAN::Shell->expand('Module', $mod);
  return unless $module;
  (my $file = $module->cpan_file) =~ s!.*/(.*)$ext!$1!;
  my ($dist, $version) = version($file);
  msg_update(qq{Done!});
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

__END__
:endofperl
