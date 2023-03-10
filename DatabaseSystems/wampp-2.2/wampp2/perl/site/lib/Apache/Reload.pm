package Apache::Reload;

use strict;
use warnings FATAL => 'all';

use mod_perl 1.99;

our $VERSION = '0.09';

use Apache::Const -compile => qw(OK);

use Apache::Connection;
use Apache::ServerUtil;
use Apache::RequestUtil;

use vars qw(%INCS %Stat $TouchTime %UndefFields);

%Stat = ($INC{"Apache/Reload.pm"} => time);

$TouchTime = time;

sub import {
    my $class = shift;
    my($package,$file) = (caller)[0,1];

    $class->register_module($package, $file);
}

sub package_to_module {
    my $package = shift;
    $package =~ s/::/\//g;
    $package .= ".pm";
    return $package;
}

sub register_module {
    my($class, $package, $file) = @_;
    my $module = package_to_module($package);

    if ($file) {
        $INCS{$module} = $file;
    }
    else {
        $file = $INC{$module};
        return unless $file;
        $INCS{$module} = $file;
    }

    no strict 'refs';
    if (%{"${package}::FIELDS"}) {
        $UndefFields{$module} = "${package}::FIELDS";
    }
}

# the first argument is:
# $c if invoked as 'PerlPreConnectionHandler'
# $r if invoked as 'PerlInitHandler'
sub handler {
    my $o = shift;
    $o = $o->base_server if ref($o) eq 'Apache::Connection';

    my $DEBUG = ref($o) && (lc($o->dir_config("ReloadDebug") || '') eq 'on');

    my $TouchFile = ref($o) && $o->dir_config("ReloadTouchFile");

    my $TouchModules;

    if ($TouchFile) {
        warn "Checking mtime of $TouchFile\n" if $DEBUG;
        my $touch_mtime = (stat($TouchFile))[9] || return 1;
        return 1 unless $touch_mtime > $TouchTime;
        $TouchTime = $touch_mtime;
        open my $fh, $TouchFile or die "Can't open '$TouchFile': $!";
        $TouchModules = <$fh>;
        chomp $TouchModules if $TouchModules;
    }

    if (ref($o) && (lc($o->dir_config("ReloadAll") || 'on') eq 'on')) {
        *Apache::Reload::INCS = \%INC;
    }
    else {
        *Apache::Reload::INCS = \%INCS;
        my $ExtraList = 
                $TouchModules || 
                (ref($o) && $o->dir_config("ReloadModules")) || 
                '';
        my @extra = split(/\s+/, $ExtraList);
        foreach (@extra) {
            if (/(.*)::\*$/) {
                my $prefix = $1;
                $prefix =~ s/::/\//g;
                foreach my $match (keys %INC) {
                    if ($match =~ /^\Q$prefix\E/) {
                        $Apache::Reload::INCS{$match} = $INC{$match};
                        my $package = $match;
                        $package =~ s/\//::/g;
                        $package =~ s/\.pm$//;
                        no strict 'refs';
#                        warn "checking for FIELDS on $package\n";
                        if (%{"${package}::FIELDS"}) {
#                            warn "found fields in $package\n";
                            $UndefFields{$match} = "${package}::FIELDS";
                        }
                    }
                }
            }
            else {
                Apache::Reload->register_module($_);
            }
        }
    }

    my $ReloadDirs = ref($o) && $o->dir_config("ReloadDirectories");
    my @watch_dirs = split(/\s+/, $ReloadDirs||'');
    while (my($key, $file) = each %Apache::Reload::INCS) {
        next if @watch_dirs && !grep { $file =~ /^$_/ } @watch_dirs;
        warn "Apache::Reload: Checking mtime of $key\n" if $DEBUG;

        my $mtime = (stat $file)[9];

        unless (defined($mtime) && $mtime) {
            for (@INC) {
                $mtime = (stat "$_/$file")[9];
                last if defined($mtime) && $mtime;
            }
        }

        warn("Apache::Reload: Can't locate $file\n"), next
            unless defined $mtime and $mtime;

        unless (defined $Stat{$file}) {
            $Stat{$file} = $^T;
        }

        if ($mtime > $Stat{$file}) {
            delete $INC{$key};
#           warn "Reloading $key\n";
            if (my $symref = $UndefFields{$key}) {
#                warn "undeffing fields\n";
                no strict 'refs';
                undef %{$symref};
            }
            no warnings FATAL => 'all';
            require $key;
            warn("Apache::Reload: process $$ reloading $key\n")
                    if $DEBUG;
        }
        $Stat{$file} = $mtime;
    }

    return Apache::OK;
}

1;
__END__
=head1 NAME

Apache::Reload - Reload Perl Modules when Changed on Disk

=head1 Synopsis

  # Monitor and reload all modules in %INC:
  # httpd.conf:
  PerlModule Apache::Reload
  PerlInitHandler Apache::Reload

  # when working with protocols and connection filters
  # PerlPreConnectionHandler Apache::Reload

  # Reload groups of modules:
  # httpd.conf:
  PerlModule Apache::Reload
  PerlInitHandler Apache::Reload
  PerlSetVar ReloadAll Off
  PerlSetVar ReloadModules "ModPerl::* Apache::*"
  #PerlSetVar ReloadDebug On

  # Reload a single module from within itself:
  package My::Apache::Module;
  use Apache::Reload;
  sub handler { ... }
  1;

=head1 Description

C<Apache::Reload> reloads modules that change on the disk.

When Perl pulls a file via C<require>, it stores the filename in the
global hash C<%INC>.  The next time Perl tries to C<require> the same
file, it sees the file in C<%INC> and does not reload from disk.  This
module's handler can be configured to iterate over the modules in
C<%INC> and reload those that have changed on disk or only specific
modules that have registered themselves with C<Apache::Reload>. It can
also do the check for modified modules, when a special touch-file has
been modified.

Note that C<Apache::Reload> operates on the current context of
C<@INC>.  Which means, when called as a C<Perl*Handler> it will not
see C<@INC> paths added or removed by C<Apache::Registry> scripts, as
the value of C<@INC> is saved on server startup and restored to that
value after each request.  In other words, if you want
C<Apache::Reload> to work with modules that live in custom C<@INC>
paths, you should modify C<@INC> when the server is started.  Besides,
C<'use lib'> in the startup script, you can also set the C<PERL5LIB>
variable in the httpd's environment to include any non-standard 'lib'
directories that you choose.  For example, to accomplish that you can
include a line:

  PERL5LIB=/home/httpd/perl/extra; export PERL5LIB

in the script that starts Apache. Alternatively, you can set this
environment variable in I<httpd.conf>:

  PerlSetEnv PERL5LIB /home/httpd/perl/extra

=head2 Monitor All Modules in C<%INC>

To monitor and reload all modules in C<%INC> at the beginning of
request's processing, simply add the following configuration to your
I<httpd.conf>:

  PerlModule Apache::Reload
  PerlInitHandler Apache::Reload

When working with connection filters and protocol modules
C<Apache::Reload> should be invoked in the pre_connection stage:

  PerlPreConnectionHandler Apache::Reload

See also the discussion on
C<L<PerlPreConnectionHandler|docs::2.0::user::handlers::protocols/PerlPreConnectionHandler>>.

=head2 Register Modules Implicitly

To only reload modules that have registered with C<Apache::Reload>,
add the following to the I<httpd.conf>:

  PerlModule Apache::Reload
  PerlInitHandler Apache::Reload
  PerlSetVar ReloadAll Off
  # ReloadAll defaults to On

Then any modules with the line:

  use Apache::Reload;

Will be reloaded when they change.

=head2 Register Modules Explicitly

You can also register modules explicitly in your I<httpd.conf> file
that you want to be reloaded on change:

  PerlModule Apache::Reload
  PerlInitHandler Apache::Reload
  PerlSetVar ReloadAll Off
  PerlSetVar ReloadModules "My::Foo My::Bar Foo::Bar::Test"

Note that these are split on whitespace, but the module list B<must>
be in quotes, otherwise Apache tries to parse the parameter list.

The C<*> wild character can be used to register groups of files under
the same namespace. For example the setting:

  PerlSetVar ReloadModules "ModPerl::* Apache::*"

will monitor all modules under the namespaces C<ModPerl::> and
C<Apache::>.

=head2 Monitor Only Certain Sub Directories

To reload modules only in certain directories (and their
subdirectories) add the following to the I<httpd.conf>:

  PerlModule Apache::Reload
  PerlInitHandler Apache::Reload
  PerlSetVar ReloadDirectories "/tmp/project1 /tmp/project2"

You can further narrow the list of modules to be reloaded from the
chosen directories with C<ReloadModules> as in:

  PerlModule Apache::Reload
  PerlInitHandler Apache::Reload
  PerlSetVar ReloadDirectories "/tmp/project1 /tmp/project2"
  PerlSetVar ReloadAll Off
  PerlSetVar ReloadModules "MyApache::*"

In this configuration example only modules from the namespace
C<MyApache::> found in the directories I</tmp/project1/> and
I</tmp/project2/> (and their subdirectories) will be reloaded.

=head2 Special "Touch" File

You can also declare a file, which when gets C<touch(1)>ed, causes the
reloads to be performed. For example if you set:

  PerlSetVar ReloadTouchFile /tmp/reload_modules

and don't C<touch(1)> the file I</tmp/reload_modules>, the reloads
won't happen until you go to the command line and type:

  % touch /tmp/reload_modules

When you do that, the modules that have been changed, will be
magically reloaded on the next request. This option works with any
mode described before.

=head1 Performance Issues

This modules is perfectly suited for a development environment. Though
it's possible that you would like to use it in a production
environment, since with C<Apache::Reload> you don't have to restart
the server in order to reload changed modules during software
updates. Though this convenience comes at a price:

=over

=item *

If the "touch" file feature is used, C<Apache::Reload> has to stat(2)
the touch file on each request, which adds a slight but most likely
insignificant overhead to response times. Otherwise C<Apache::Reload>
will stat(2) each registered module or even worse--all modules in
C<%INC>, which will significantly slow everything down.

=item *

Once the child process reloads the modules, the memory used by these
modules is not shared with the parent process anymore. Therefore the
memory consumption may grow significantly.

=back

Therefore doing a full server stop and restart is probably a better
solution.

=head1 Debug

If you aren't sure whether the modules that are supposed to be
reloaded, are actually getting reloaded, turn the debug mode on:

  PerlSetVar ReloadDebug On

=head1 Problems With Reloading Modules Which Do Not Declare Their Package Name

If you modify modules which don't declare their C<package> and rely on
C<Apache::Reload> to reload them you may encounter problems: i.e.,
it'll appear as if the module wasn't reloaded when in fact it
was. This happens because when C<Apache::Reload> C<require()>s such a
module all the global symbols end up in the C<Apache::Reload>
namespace!  So the module does get reloaded and you see the compile
time errors if there are any, but the symbols don't get imported to
the right namespace. Therefore the old version of the code is running.

=head1 Threaded MPM and Multiple Perl Interpreters

If you use C<Apache::Reload> with a threaded MPM and multiple Perl
interpreters, the modules will be reloaded by each interpreter as they
are used, not every interpreters at once.  Similar to mod_perl 1.0
where each child has its own Perl interpreter, the modules are
reloaded as each child is hit with a request.

If a module is loaded at startup, the syntax tree of each subroutine
is shared between interpreters (big win), but each subroutine has its
own padlist (where lexical my variables are stored).  Once
C<Apache::Reload> reloads a module, this sharing goes away and each
Perl interpreter will have its own copy of the syntax tree for the
reloaded subroutines.


=head1 Pseudo-hashes

The short summary of this is: Don't use pseudo-hashes. They are
deprecated since Perl 5.8 and are removed in 5.9.

Use an array with constant indexes. Its faster in the general case,
its more guaranteed, and generally, it works.

The long summary is that some work has been done to get this module
working with modules that use pseudo-hashes, but it's still broken in
the case of a single module that contains multiple packages that all
use pseudo-hashes.

So don't do that.

=head1 Authors

Matt Sergeant, matt@sergeant.org

Stas Bekman (porting to mod_perl 2.0)

A few concepts borrowed from C<Stonehenge::Reload> by Randal Schwartz
and C<Apache::StatINC> (mod_perl 1.x) by Doug MacEachern and Ask
Bjoern Hansen.

=head1 See Also

C<Stonehenge::Reload>

=cut
