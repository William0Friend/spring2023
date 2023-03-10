package Apache::compat;

use strict;
use warnings FATAL => 'all';
no warnings 'redefine';

#1.xx compat layer
#some of this will stay as-is
#some will be implemented proper later on

#there's enough here to get simple registry scripts working
#add to startup.pl:
#use Apache::compat ();
#use lib ...; #or something to find 1.xx Apache::Registry

#Alias /perl /path/to/perl/scripts
#<Location /perl>
#   Options +ExecCGI
#   SetHandler modperl
#   PerlResponseHandler Apache::Registry
#</Location>

use Apache::RequestRec ();
use Apache::SubRequest ();
use Apache::Connection ();
use Apache::Server ();
use Apache::ServerUtil ();
use Apache::Access ();
use Apache::RequestIO ();
use Apache::RequestUtil ();
use Apache::Response ();
use Apache::Util ();
use Apache::Log ();
use Apache::URI ();
use APR::Date ();
use APR::Table ();
use APR::Pool ();
use APR::URI ();
use APR::Util ();
use mod_perl ();
use Symbol ();

BEGIN {
    $INC{'Apache.pm'} = __FILE__;

    $INC{'Apache/Constants.pm'} = __FILE__;

    $INC{'Apache/File.pm'} = __FILE__;

    $INC{'Apache/Table.pm'} = __FILE__;
}

sub request {
    my $what = shift;

    my $r = Apache->request;

    unless ($r) {
        die "cannot use $what ",
            "without 'SetHandler perl-script' ",
            "or 'PerlOptions +GlobalRequest'";
    }

    $r;
}

package Apache::Server;
# XXX: is that good enough? see modperl/src/modules/perl/mod_perl.c:367
our $CWD = Apache->server_root_relative();

our $AddPerlVersion = 1;

package Apache;

sub exit {
    require ModPerl::Util;

    my $status = 0;
    my $nargs = @_;

    if ($nargs == 2) {
        $status = $_[1];
    }
    elsif ($nargs == 1 and $_[0] =~ /^\d+$/) {
        $status = $_[0];
    }

    ModPerl::Util::exit($status);
}

#XXX: warn
sub import {
}

sub untaint {
    shift;
    require ModPerl::Util;
    ModPerl::Util::untaint(@_);
}

sub module {
    require Apache::Module;
    die 'Usage: Apache->module($name)' if @_ != 2;
    return Apache::Module::loaded($_[1]);
}

sub gensym {
    return Symbol::gensym();
}

sub define {
    shift if @_ == 2;
    exists_config_define(@_);
}

sub log_error {
    Apache->server->log_error(@_);
}

sub httpd_conf {
    shift;
    my $obj;
    eval { $obj = Apache->request };
    $obj = Apache->server if $@;
    my $err = $obj->add_config([split /\n/, join '', @_]);
    die $err if $err;
}

sub push_handlers {
    shift;
    Apache->server->push_handlers(@_);
}

sub set_handlers {
    shift;
    Apache->server->set_handlers(@_);
}

sub get_handlers {
    shift;
    Apache->server->get_handlers(@_);
}

package Apache::Constants;

use Apache::Const ();

sub import {
    my $class = shift;
    my $package = scalar caller;
    Apache::Const->compile($package => @_);
}

#no need to support in 2.0
sub export {}

sub SERVER_VERSION { Apache::get_server_version() }

package Apache::RequestRec;

use Apache::Const -compile => qw(REMOTE_NAME);

#no longer exist in 2.0
sub soft_timeout {}
sub hard_timeout {}
sub kill_timeout {}
sub reset_timeout {}

sub current_callback {
    return Apache::current_callback();
}

sub send_http_header {
    my ($r, $type) = @_;

    # since send_http_header() in mp1 was telling mod_perl not to
    # parse headers and in mp2 one must call $r->content_type($type) to
    # perform the same, we make sure that this happens
    $type = $r->content_type || 'text/html' unless defined $type;

    $r->content_type($type);
}

#to support $r->server_root_relative
*server_root_relative = \&Apache::server_root_relative;

#we support Apache->request; this is needed to support $r->request
#XXX: seems sorta backwards
*request = \&Apache::request;

sub table_get_set {
    my($r, $table) = (shift, shift);
    my($key, $value) = @_;

    if (1 == @_) {
        return wantarray() 
            ?       ($table->get($key))
            : scalar($table->get($key));
    }
    elsif (2 == @_) {
        if (defined $value) {
            return wantarray() 
                ?        ($table->set($key, $value))
                :  scalar($table->set($key, $value));
        }
        else {
            return wantarray() 
                ?       ($table->unset($key))
                : scalar($table->unset($key));
        }
    }
    elsif (0 == @_) {
        return $table;
    }
    else {
        my $name = (caller(1))[3];
        warn "Usage: \$r->$name([key [,val]])";
    }
}

sub header_out {
    my $r = shift;
    return wantarray() 
        ?       ($r->table_get_set(scalar($r->headers_out), @_))
        : scalar($r->table_get_set(scalar($r->headers_out), @_));
}

sub header_in {
    my $r = shift;
    return wantarray() 
        ?       ($r->table_get_set(scalar($r->headers_in), @_))
        : scalar($r->table_get_set(scalar($r->headers_in), @_));
}

sub err_header_out {
    my $r = shift;
    return wantarray() 
        ?       ($r->table_get_set(scalar($r->err_headers_out), @_))
        : scalar($r->table_get_set(scalar($r->err_headers_out), @_));
}

{
    my $notes_sub = *Apache::RequestRec::notes{CODE};
    *Apache::RequestRec::notes = sub {
        my $r = shift;
        return wantarray()
            ?       ($r->table_get_set(scalar($r->$notes_sub), @_))
            : scalar($r->table_get_set(scalar($r->$notes_sub), @_));
    }
}

sub register_cleanup {
    shift->pool->cleanup_register(@_);
}

*post_connection = \&register_cleanup;

sub get_remote_host {
    my($r, $type) = @_;
    $type = Apache::REMOTE_NAME unless defined $type;
    $r->connection->get_remote_host($type, $r->per_dir_config);
}

#XXX: should port 1.x's Apache::unescape_url_info
sub parse_args {
    my($r, $string) = @_;
    return () unless defined $string and $string;

    return map {
        tr/+/ /;
        s/%([0-9a-fA-F]{2})/pack("C",hex($1))/ge;
        $_;
    } split /[=&;]/, $string, -1;
}

#sorry, have to use $r->Apache::args at the moment
#for list context splitting

sub Apache::args {
    my $r = shift;
    my $args = $r->args;
    return $args unless wantarray;
    return $r->parse_args($args);
}

use constant IOBUFSIZE => 8192;

sub content {
    my $r = shift;

    $r->setup_client_block;

    return undef unless $r->should_client_block;

    my $data = '';
    my $buf;
    while (my $read_len = $r->get_client_block($buf, IOBUFSIZE)) {
        if ($read_len == -1) {
            die "some error while reading with get_client_block";
        }
        $data .= $buf;
    }

    return $data unless wantarray;
    return $r->parse_args($data);
}

sub clear_rgy_endav {
    my($r, $script_name) = @_;
    require ModPerl::Global;
    my $package = 'Apache::ROOT' . $script_name;
    ModPerl::Global::special_list_clear(END => $package);
}

sub stash_rgy_endav {
    #see run_rgy_endav
}

#if somebody really wants to have END subroutine support
#with the 1.x Apache::Registry they will need to configure:
# PerlHandler Apache::Registry Apache::compat::run_rgy_endav
sub Apache::compat::run_rgy_endav {
    my $r = shift;

    require ModPerl::Global;
    require Apache::PerlRun; #1.x's
    my $package = Apache::PerlRun->new($r)->namespace;

    ModPerl::Global::special_list_call(END => $package);
}

sub seqno {
    1;
}

sub chdir_file {
    #XXX resolve '.' in @INC to basename $r->filename
}

sub finfo {
    my $r = shift;
    stat $r->filename;
    \*_;
}

*log_reason = \&log_error;

sub slurp_filename {
    my $r = shift;
    open my $fh, $r->filename;
    local $/;
    my $data = <$fh>;
    close $fh;
    return \$data;
}

#XXX: would like to have a proper implementation
#that reads line-by-line as defined by $/
#the best way will probably be to use perlio in 5.8.0
#anything else would be more effort that it is worth
sub READLINE {
    my $r = shift;
    my $line;
    $r->read($line, $r->headers_in->get('Content-length'));
    $line ? $line : undef;
}

#XXX: howto convert PerlIO to apr_file_t
#so we can use the real ap_send_fd function
#2.0 ap_send_fd() also has an additional offset parameter

sub send_fd_length {
    my($r, $fh, $length) = @_;

    my $buff;
    my $total_bytes_sent = 0;
    my $len;

    return 0 if $length == 0;

    if (($length > 0) && ($total_bytes_sent + IOBUFSIZE) > $length) {
        $len = $length - $total_bytes_sent;
    }
    else {
        $len = IOBUFSIZE;
    }

    binmode $fh;

    while (CORE::read($fh, $buff, $len)) {
        $total_bytes_sent += $r->puts($buff);
    }

    $total_bytes_sent;
}

sub send_fd {
    my($r, $fh) = @_;
    $r->send_fd_length($fh, -1);
}

sub is_main { !shift->main }

package Apache::File;

use Fcntl ();
use Symbol ();
use Carp ();

sub new {
    my($class) = shift;
    my $fh = Symbol::gensym;
    my $self = bless $fh, ref($class)||$class;
    if (@_) {
        return $self->open(@_) ? $self : undef;
    }
    else {
        return $self;
    }
}

sub open {
    my($self) = shift;

    Carp::croak("no Apache::File object passed")
          unless $self && ref($self);

    # cannot forward @_ to open() because of its prototype
    if (@_ > 1) {
        my ($mode, $file) = @_;
        CORE::open $self, $mode, $file;
    }
    else {
        my $file = shift;
        CORE::open $self, $file;
    }
}

sub close {
    my($self) = shift;
    CORE::close $self;
}

my $TMPNAM = 'aaaaaa';
my $TMPDIR = $ENV{'TMPDIR'} || $ENV{'TEMP'} || '/tmp';
($TMPDIR) = $TMPDIR =~ /^([^<>|;*]+)$/; #untaint
my $Mode = Fcntl::O_RDWR()|Fcntl::O_EXCL()|Fcntl::O_CREAT();
my $Perms = 0600;

sub tmpfile {
    my $class = shift;
    my $limit = 100;
    my $r = Apache::compat::request('Apache::File->tmpfile');

    while ($limit--) {
        my $tmpfile = "$TMPDIR/${$}" . $TMPNAM++;
        my $fh = $class->new;

        sysopen($fh, $tmpfile, $Mode, $Perms);
        $r->pool->cleanup_register(sub { unlink $tmpfile });

        if ($fh) {
            return wantarray ? ($tmpfile, $fh) : $fh;
        }
    }
}

# the following functions now live in Apache::Response
# * discard_request_body
# * meets_conditions
# * set_content_length
# * set_etag
# * set_last_modified
# * update_mtime

# the following functions now live in Apache::RequestRec
# * mtime

package Apache::Util;

sub size_string {
    my($size) = @_;

    if (!$size) {
        $size = "   0k";
    }
    elsif ($size == -1) {
        $size = "    -";
    }
    elsif ($size < 1024) {
        $size = "   1k";
    }
    elsif ($size < 1048576) {
        $size = sprintf "%4dk", ($size + 512) / 1024;
    }
    elsif ($size < 103809024) {
        $size = sprintf "%4.1fM", $size / 1048576.0;
    }
    else {
        $size = sprintf "%4dM", ($size + 524288) / 1048576;
    }

    return $size;
}

*unescape_uri = \&Apache::unescape_url;

sub escape_uri {
    my $path = shift;
    my $r = Apache::compat::request('Apache::Util::escape_uri');
    Apache::Util::escape_path($path, $r->pool);
}

#tmp compat until ap_escape_html is reworked to not require a pool
my %html_escapes = (
    '<' => 'lt',
    '>' => 'gt',
    '&' => 'amp',
    '"' => 'quot',
);

%html_escapes = map { $_, "&$html_escapes{$_};" } keys %html_escapes;

my $html_escape = join '|', keys %html_escapes;

sub escape_html {
    my $html = shift;
    $html =~ s/($html_escape)/$html_escapes{$1}/go;
    $html;
}

sub ht_time {
    my($t, $fmt, $gmt) = @_;

    $t   ||= time;
    $fmt ||= '%a, %d %b %Y %H:%M:%S %Z';
    $gmt = 1 unless @_ == 3;

    my $r = Apache::compat::request('Apache::Util::ht_time');

    return Apache::Util::format_time($t, $fmt, $gmt, $r->pool);
}

*parsedate = \&APR::Date::parse_http;

*validate_password = \&APR::password_validate;

sub Apache::URI::parse {
    my($class, $r, $uri) = @_;

    $uri ||= $r->construct_url;

    APR::URI->parse($r->pool, $uri);
}

{
    my $sub = *APR::URI::unparse{CODE};
    *APR::URI::unparse = sub {
        my($uri, $flags) = @_;

        if (defined $uri->hostname && !defined $uri->scheme) {
            # we do this only for back compat, the new APR::URI is
            # protocol-agnostic and doesn't fallback to 'http' when the
            # scheme is not provided
            $uri->scheme('http');
        }

        $sub->(@_);
    };
}

package Apache::Table;

sub new {
    my($class, $r, $nelts) = @_;
    $nelts ||= 10;
    APR::Table::make($r->pool, $nelts);
}

package Apache::SIG;

use Apache::Const -compile => 'DECLINED';

sub handler {
    # don't set the SIGPIPE
    return Apache::DECLINED;
}

package Apache::Connection;

# auth_type and user records don't exist in 2.0 conn_rec struct
# 'PerlOptions +GlobalRequest' is required
sub auth_type { shift; Apache->request->ap_auth_type(@_) }
sub user      { shift; Apache->request->user(@_)      }

1;
__END__
=head1 NAME

Apache::compat -- 1.0 backward compatibility functions deprecated in 2.0

=head1 SYNOPSIS

  # either add at the very beginning of startup.pl
  use Apache2
  use Apache::compat;
  # or httpd.conf
  PerlModule Apache2
  PerlModule Apache::compat

=head1 DESCRIPTION

C<Apache::compat> provides mod_perl 1.0 compatibility layer and can be
used to smooth the transition process to mod_perl 2.0.

It includes functions that have changed their API or were removed in
mod_perl 2.0. If your code uses any of those functions, you should
load this module at the server startup, and everything should work as
it did in 1.0. If it doesn't please L<report the
bug|docs::2.0::user::help::help/Reporting_Problems>, but before you
do that please make sure that your code does work properly under
mod_perl 1.0.

However, remember, that it's implemented in pure Perl and not C,
therefore its functionality is not optimized and it's the best to try
to L<port your
code|docs::2.0::user::porting::porting> not to use deprecated
functions and stop using the compatibility layer.

=head1 Use in CPAN Modules

The short answer: B<Do not use> C<Apache::compat> in CPAN modules.

The long answer:

C<Apache::compat> is useful during the mod_perl 1.0 code
porting. Though remember that it's implemented in pure Perl. In
certain cases it overrides mod_perl 2.0 methods, because their API is
very different and doesn't map 1:1 to mod_perl 1.0. So if anything,
not under user's control, loads C<Apache::compat> user's code is
forced to use the potentially slower method. Which is quite bad.

Some users may choose to keep using C<Apache::compat> in production
and it may perform just fine. Other users will choose not to use that
module, by porting their code to use mod_perl 2.0 API. However it
should be users' choice whether to load this module or not and not to
be enforced by CPAN modules.

If you port your CPAN modules to work with mod_perl 2.0, you should
follow the porting L<Perl|docs::2.0::user::porting::porting> and
L<XS|docs::2.0::devel::porting::porting> module guidelines.

Users that are stuck with CPAN modules preloading C<Apache::compat>,
can prevent this from happening by adding

  $INC{'Apache/compat.pm'} = __FILE__;

at the very beginning of their I<startup.pl>. But this will most
certainly break the module that needed this module.

=head1 API

You should be reading the mod_perl 1.0 L<API
docs|docs::1.0::api::index> for usage of the methods and functions
in this package, since what this module is doing is providing a
backwards compatibility and it makes no sense to duplicate
documentation.

Another important document to read is: L<Migrating from mod_perl 1.0
to mod_perl 2.0|docs::2.0::user::porting::compat> which covers all
mod_perl 1.0 constants, functions and methods that have changed in
mod_perl 2.0.

=cut
