package ModPerl::Registry;

use strict;
use warnings FATAL => 'all';

# we try to develop so we reload ourselves without die'ing on the warning
no warnings qw(redefine); # XXX, this should go away in production!

our $VERSION = '1.99';

use base qw(ModPerl::RegistryCooker);

sub handler : method {
    my $class = (@_ >= 2) ? shift : __PACKAGE__;
    my $r = shift;
    return $class->new($r)->default_handler();
}

my $parent = 'ModPerl::RegistryCooker';
# the following code:
# - specifies package's behavior different from default of $parent class
# - speeds things up by shortcutting @ISA search, so even if the
#   default is used we still use the alias
my %aliases = (
    new             => 'new',
    init            => 'init',
    default_handler => 'default_handler',
    run             => 'run',
    can_compile     => 'can_compile',
    make_namespace  => 'make_namespace',
    namespace_root  => 'namespace_root',
    namespace_from  => 'namespace_from_filename',
    is_cached       => 'is_cached',
    should_compile  => 'should_compile_if_modified',
    flush_namespace => 'NOP',
    cache_table     => 'cache_table_common',
    cache_it        => 'cache_it',
    read_script     => 'read_script',
    rewrite_shebang => 'rewrite_shebang',
    set_script_name => 'set_script_name',
    chdir_file      => 'chdir_file_normal',
    get_mark_line   => 'get_mark_line',
    compile         => 'compile',
    error_check     => 'error_check',
    strip_end_data_segment             => 'strip_end_data_segment',
    convert_script_to_compiled_handler => 'convert_script_to_compiled_handler',
);

# in this module, all the methods are inherited from the same parent
# class, so we fixup aliases instead of using the source package in
# first place.
$aliases{$_} = $parent . "::" . $aliases{$_} for keys %aliases;

__PACKAGE__->install_aliases(\%aliases);

# Note that you don't have to do the aliases if you use defaults, it
# just speeds things up the first time the sub runs, after that
# methods are cached.
#
# But it's still handy, since you explicitly specify which subs from
# the parent package you are using
#

# META: if the ISA search results are cached on the first lookup, may
# be we need to alias only those methods that override the defaults?


1;
__END__
=head1 NAME

ModPerl::Registry - Run unaltered CGI scripts persistently under mod_perl

=head1 Synopsis

  # httpd.conf
  PerlModule ModPerl::Registry
  Alias /perl/ /home/httpd/perl/
  <Location /perl>
      SetHandler perl-script
      PerlResponseHandler ModPerl::Registry
      #PerlOptions +ParseHeaders
      #PerlOptions -GlobalRequest
      Options +ExecCGI
  </Location>

=head1 Description

URIs in the form of C<http://example.com/perl/test.pl> will be
compiled as the body of a Perl subroutine and executed.  Each child
process will compile the subroutine once and store it in memory. It
will recompile it whenever the file (e.g. I<test.pl> in our example)
is updated on disk.  Think of it as an object oriented server with
each script implementing a class loaded at runtime.

The file looks much like a "normal" script, but it is compiled into a
subroutine.

For example:

  my $r = Apache->request;
  $r->content_type("text/html");
  $r->send_http_header;
  $r->print("mod_perl rules!");

XXX: STOPPED here

META: document that for now we don't chdir() into the script's dir,
because it affects the whole process under threads.


This module emulates the CGI environment, allowing programmers to
write scripts that run under CGI or mod_perl without change.  Existing
CGI scripts may require some changes, simply because a CGI script has
a very short lifetime of one HTTP request, allowing you to get away
with "quick and dirty" scripting.  Using mod_perl and Apache::Registry
requires you to be more careful, but it also gives new meaning to the
word "quick"!

Be sure to read all mod_perl related documentation for more details,
including instructions for setting up an environment that looks
exactly like CGI:

 print "Content-type: text/html\n\n";
 print "Hi There!";

Note that each httpd process or "child" must compile each script once,
so the first request to one server may seem slow, but each request
there after will be faster.  If your scripts are large and/or make use
of many Perl modules, this difference should be noticeable to the
human eye.

=head1 Security

Apache::Registry::handler will preform the same checks as mod_cgi
before running the script.

=head1 Environment

The Apache function `exit' overrides the Perl core built-in function.

The environment variable B<GATEWAY_INTERFACE> is set to C<CGI-Perl/1.1>.

=head1 Commandline Switches In First Line

Normally when a Perl script is run from the command line or under CGI,
arguments on the `#!' line are passed to the perl interpreter for processing.

C<Apache::Registry> currently only honors the B<-w> switch and will
enable the C<warnings> pragma in such case.

Another common switch used with CGI scripts is B<-T> to turn on taint
checking.  This can only be enabled when the server starts with the
configuration directive:

 PerlSwitches -T

However, if taint checking is not enabled, but the B<-T> switch is
seen, C<Apache::Registry> will write a warning to the I<error_log>
file.

=head1 Debugging

You may set the debug level with the $Apache::Registry::Debug bitmask

 1 => log recompile in errorlog
 2 => Apache::Debug::dump in case of $@
 4 => trace pedantically

=head1 Caveats

Apache::Registry makes things look just the CGI environment, however, you
must understand that this *is not CGI*.  Each httpd child will compile
your script into memory and keep it there, whereas CGI will run it once,
cleaning out the entire process space.  Many times you have heard
"always use C<-w>, always use C<-w> and 'use strict'".
This is more important here than anywhere else!

Your scripts cannot contain the __END__ or __DATA__ token to terminate
compilation. (META: works in 2.0).


=head1 Authors

Andreas J. Koenig, Doug MacEachern and Stas Bekman.

=head1 See Also

C<L<ModPerl::RegistryCooker>>, C<L<ModPerl::RegistryBB>>,
C<L<ModPerl::PerlRun>>, Apache(3), mod_perl(3)

=cut
