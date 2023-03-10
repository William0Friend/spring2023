package HTML::Mason::CGIHandler;

use strict;

use HTML::Mason;
use HTML::Mason::Utils;
use CGI;
use File::Spec;
use Params::Validate qw(:all);

use Class::Container;
use base qw(Class::Container);

use HTML::Mason::MethodMaker
    ( read_write => [ qw( interp ) ] );

use vars qw($VERSION);

# Why do we have a version?  I'm glad you asked.  See, dummy me
# stupidly referenced it in the Subclassing docs _and_ the book.  It's
# needed in order to dynamically have a request subclass change its
# parent properly to work with CGIHandler or ApacheHandler.  It
# doesn't really matter what the version is, as long as it's a true
# value.  - dave
$VERSION = '1.00';


__PACKAGE__->valid_params
    (
     interp => { isa => 'HTML::Mason::Interp' },
    );

__PACKAGE__->contained_objects
    (
     interp => 'HTML::Mason::Interp',
     cgi_request => { class   => 'HTML::Mason::FakeApache', # $r
		      delayed => 1 },
    );


sub new {
    my $package = shift;

    my %p = @_;
    my $self = $package->SUPER::new(comp_root => $ENV{DOCUMENT_ROOT},
				    request_class => 'HTML::Mason::Request::CGI',
				    error_mode => 'output',
				    error_format => 'html',
				    %p);

    $self->interp->out_method(\$self->{output})
        unless exists $p{out_method};
    $self->interp->compiler->add_allowed_globals('$r');
    
    return $self;
}

sub handle_request {
    my $self = shift;
    $self->_handler( { comp => $ENV{PATH_INFO} }, @_ );
}

sub handle_comp {
    my ($self, $comp) = (shift, shift);
    $self->_handler( { comp => $comp }, @_ );
}

sub handle_cgi_object {
    my ($self, $cgi) = (shift, shift);
    $self->_handler( { comp => $cgi->path_info,
		       cgi       => $cgi },
		     @_);
}

sub _handler {
    my ($self, $p) = (shift, shift);

    my $r = $self->create_delayed_object('cgi_request', cgi => $p->{cgi});
    $self->interp->set_global('$r', $r);

    $self->{output} = '';

    $self->interp->delayed_object_params('request', cgi_request => $r);

    my %args = $self->request_args($r);

    $self->interp->exec($p->{comp}, %args);

    if (@_) {
	# This is a secret feature, and should stay secret (or go away) because it's just a hack for the test suite.
	$_[0] .= $r->http_header . $self->{output};
    } else {
	print $r->http_header;
	print $self->{output};
    }
}

# This is broken out in order to make subclassing easier.
sub request_args {
    my ($self, $r) = @_;

    return $r->params;
}

###########################################################
package HTML::Mason::Request::CGI;
# Subclass for HTML::Mason::Request object $m

use HTML::Mason::Request;
use base qw(HTML::Mason::Request);

use HTML::Mason::MethodMaker
    ( read_only => [ 'cgi_request' ] );

__PACKAGE__->valid_params( cgi_request => {isa => 'HTML::Mason::FakeApache'} );

sub cgi_object {
    my $self = shift;
    return $self->{cgi_request}->query(@_);
}

sub redirect {
    my $self = shift;
    my $url = shift;
    my $status = shift || 302;

    $self->clear_buffer;

    $self->{cgi_request}->header_out( Location => $url );
    $self->{cgi_request}->http_header( Status => $status );

    $self->abort;
}

###########################################################
package HTML::Mason::FakeApache;
# Analogous to Apache request object $r (but not an actual Apache subclass)
# In the future we'll probably want to switch this to Apache::Fake or similar

use HTML::Mason::MethodMaker(read_write => [qw(query headers)]);

sub new {
    my $class = shift;
    my %p = @_;

    return bless {
		  query   => $p{cgi} || new CGI(),
		  headers => {},
		 }, $class;
}

sub header_out {
    my ($self, $header) = (shift, shift);

    $header = $self->_canonical_header($header);

    return $self->_set_header($header, shift) if @_;
    return $self->headers->{$header};
}

sub content_type {
    my $self = shift;

    my $header = $self->_canonical_header('Content-type');

    return $self->_set_header($header, shift) if @_;
    return $self->headers->{$header};
}

sub _set_header {
    my ($self, $header, $value) = @_;

    delete $self->headers->{$header}, return unless defined $value;

    return $self->headers->{$header} = $value;
}

sub _canonical_header {
    my ($self, $header) = @_;

    # CGI really wants a - before each header
    $header = "-$header"  unless substr( $header, 0, 1 ) eq '-';

    return lc $header;
}

sub http_header {
    my $self = shift;

    my $location = $self->_canonical_header('Location');

    my $method = exists $self->headers->{$location} ? 'redirect' : 'header';
    return $self->query->$method(%{$self->headers});
}

sub params {
    my $self = shift;

    return HTML::Mason::Utils::cgi_request_args($self->query, $self->query->request_method);
}

1;

__END__

=head1 NAME

HTML::Mason::CGIHandler - Use Mason in a CGI environment

=head1 SYNOPSIS

In httpd.conf or .htaccess:

   Action html-mason /cgi-bin/mason_handler.cgi
   <LocationMatch "\.html$">
    SetHandler html-mason
   </LocationMatch>

A script at /cgi-bin/mason_handler.pl :

   #!/usr/bin/perl
   use HTML::Mason::CGIHandler;
   
   my $h = new HTML::Mason::CGIHandler
    (
     data_dir  => '/home/jethro/code/mason_data',
     allow_globals => [qw(%session $u)],
    );
   
   $h->handle_request;

A .html component somewhere in the web server's document root:

   <%args>
    $mood => 'satisfied'
   </%args>
   % $r->header_out(Location => "http://blahblahblah.com/moodring/$mood.html");
   ...

=head1 DESCRIPTION

This module lets you execute Mason components in a CGI environment.
It lets you keep your top-level components in the web server's
document root, using regular component syntax and without worrying
about the particular details of invoking Mason on each request.

If you want to use Mason components from I<within> a regular CGI
script (or any other Perl program, for that matter), then you don't
need this module.  You can simply follow the directions in
the L<Using Mason from a standalone script|HTML::Mason::Admin/Using Mason from a standalone script> section of the administrator's manual.

This module also provides an C<$r> request object for use inside
components, similar to the Apache request object under
C<HTML::Mason::ApacheHandler>, but limited in functionality.  Please
note that we aim to replicate the C<mod_perl> functionality as closely
as possible - if you find differences, do I<not> depend on them to
stay different.  We may fix them in a future release.  Also, if you
need some missing functionality in C<$r>, let us know, we might be
able to provide it.

Finally, this module alters the C<HTML::Mason::Request> object C<$m> to
provide direct access to the CGI query, should such access be necessary.

=head2 C<HTML::Mason::CGIHandler> Methods

=over 4

=item * new()

Creates a new handler.  Accepts any parameter that the Interpreter
accepts.

If no C<comp_root> parameter is passed to C<new()>, the component root
will be C<$ENV{DOCUMENT_ROOT}>.

=item * handle_request()

Handles the current request, reading input from C<$ENV{QUERY_STRING}>
or C<STDIN> and sending headers and component output to C<STDOUT>.
This method doesn't accept any parameters.  The initial component
will be the one specified in C<$ENV{PATH_INFO}>.

=item * handle_comp()

Like C<handle_request()>, but the first (only) parameter is a
component path or component object.  This is useful within a
traditional CGI environment, in which you're essentially using Mason
as a templating language but not an application server.

C<handle_component()> will create a CGI query object, parse the query
parameters, and send the HTTP header and component output to STDOUT.
If you want to handle those parts yourself, see
the L<Using Mason from a standalone script|HTML::Mason::Admin/Using Mason from a standalone script> section of the administrator's manual.

=item * handle_cgi_object()

Also like C<handle_request()>, but this method takes only a CGI object
as its parameter.  This can be quite useful if you want to use this
module with CGI::Fast.

The component path will be the value of the CGI object's
C<path_info()> method.

=item * request_args()

Given an C<HTML::Mason::FakeApache> object, this method is expected to
return a hash containing the arguments to be passed to the component.
It is a separate method in order to make it easily overrideable in a
subclass.

=item * interp()

Returns the Mason Interpreter associated with this handler.  The
Interpreter lasts for the entire lifetime of the handler.

=back

=head2 $r Methods

=over 4

=item * header_out()

This works much like the C<Apache> method of the same name.  When
passed the name of a header, returns the value of the given outgoing
header.  When passed a name and a value, sets the value of the header.
Setting the header to C<undef> will actually I<unset> the header
(instead of setting its value to C<undef>), removing it from the table
of headers that will be sent to the client.

The headers are eventually passed to the C<CGI> module's C<header()>
method.

One header currently gets special treatment - if you set a C<Location>
header, you'll cause the C<CGI> module's C<redirect()> method to be
used instead of the C<header()> method.  This means that in order to
do a redirect, all you need to do is:

 $r->header_out(Location => 'http://redirect.to/here');

You may be happier using the C<< $m->redirect >> method, though,
because it hides most of the complexities of sending headers and
getting the status code right.


=item * content_type()

When passed an argument, sets the content type of the current request
to the value of the argument.  Use this method instead of setting a
C<Content-Type> header directly with C<header_out()>.  Like
C<header_out()>, setting the content type to C<undef> will remove any
content type set previously.

When called without arguments, returns the value set by a previous
call to C<content_type()>.  The behavior when C<content_type()> hasn't
already been set is undefined - currently it returns C<undef>.

If no content type is set during the request, the default MIME type
C<text/html> will be used.

=item * http_header()

This method returns the outgoing headers as a string, suitable for
sending to the client.

=item * params()

This method returns a hash containing the parameters sent by the
client.  Multiple parameters of the same name are represented by array
references.  If both POST and query string arguments were submitted,
these will be merged together.

=back

=head2 Added C<$m> methods

The C<$m> object provided in components has all the functionality of
the regular C<HTML::Mason::Request> object C<$m>, and the following:

=over 4

=item * cgi_object()

Returns the current C<CGI> request object.  This is handy for
processing cookies or perhaps even doing HTML generation (but is that
I<really> what you want to do?).  If you pass an argument to this
method, you can set the request object to the argument passed.  Use
this with care, as it may affect components called after the current
one (they may check the content length of the request, for example).

Note that the ApacheHandler class (for using Mason under mod_perl)
also provides a C<cgi_object()> method that does the same thing as
this one.  This makes it easier to write components that function
equally well under CGIHandler and ApacheHandler.

=item * cgi_request

Returns the object that is used to emulate Apache's request object.
In other words, this is the object that C<$r> is set to when you use
this class.

=back

=head1 SEE ALSO

L<HTML::Mason|HTML::Mason>,
L<HTML::Mason::Admin|HTML::Mason::Admin>,
L<HTML::Mason::ApacheHandler|HTML::Mason::ApacheHandler>

=cut
