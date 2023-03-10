package Apache::TestClient;

#this module provides some fallback for when libwww-perl is not installed
#it is by no means an LWP replacement, just enough for very simple requests

#this module does not and will never support certain features such as:
#file upload, http/1.1 (byteranges, keepalive, etc.), following redirects,
#authentication, GET body callbacks, SSL, etc.

use strict;
use warnings FATAL => 'all';

use Apache::TestRequest ();

my $CRLF = "\015\012";

sub request {
    my($method, $url, $headers) = @_;

    my $config = Apache::Test::config();

    $method  ||= 'GET';
    $url     ||= '/';
    $headers ||= {};

    my $hostport = Apache::TestRequest::hostport($config);
    $headers->{Host} = (split ':', $hostport)[0];

    my $s = Apache::TestRequest::vhost_socket();

    unless ($s) {
        warn "cannot connect to $hostport: $!";
        return undef;
    }

    my $content = delete $headers->{'content'};
    if ($content) {
        $headers->{'Content-Length'} ||= length $content;
        $headers->{'Content-Type'}   ||= 'application/x-www-form-urlencoded';
    }

    #for modules/setenvif
    $headers->{'User-Agent'} ||= 'libwww-perl/0.00';

    my $request = join $CRLF,
      "$method $url HTTP/1.0",
      (map { "$_: $headers->{$_}" } keys %$headers), $CRLF;

    print $s $request;
    print $s $content if $content;

    $request =~ s/\015//g; #for as_string

    my $res = {
        request => (bless {
            headers_as_string => $request,
            content => $content || '',
        }, 'Apache::TestClientRequest'),
        headers_as_string => '',
        method => $method,
    };

    my($response_line, $header_term);
    my $eol = "\015?\012";

    local $_;

    while (<$s>) {
        $res->{headers_as_string} .= $_;
        if (m:^(HTTP/\d+\.\d+)[ \t]+(\d+)[ \t]*(.*?)$eol:io) {
            $res->{protocol} = $1;
            $res->{code} = $2;
            $res->{message} = $3;
            $response_line = 1;
        }
        elsif (/^([a-zA-Z0-9_\-]+)\s*:\s*(.*?)$eol/o) {
            $res->{headers}->{$1} = $2;
        }
        elsif (/^$eol$/o) {
            $header_term = 1;
            last;
        }
    }

    unless ($response_line and $header_term) {
        warn "malformed response";
    }

    {
        local $/;
        $res->{content} = <$s>;
    }
    close $s;

    $res->{headers_as_string} =~ s/\015//g; #for as_string

    bless $res, 'Apache::TestClientResponse';
}

for my $method (qw(GET HEAD POST PUT)) {
    no strict 'refs';
    *$method = sub {
        my $url = shift;
        my $headers = { @_ };
        request($method, $url, $headers);
    };
}

package Apache::TestClientResponse;

sub header {
    my($self, $key) = @_;
    $self->{headers}->{$key};
}

my @headers = qw(Last-Modified Content-Type);

for my $header (@headers) {
    no strict 'refs';
    (my $method = lc $header) =~ s/-/_/g;
    *$method = sub { shift->{headers}->{$header} };
}

sub is_success {
    my $code = shift->{code};
    $code >= 200 && $code < 300;
}

sub status_line {
    my $self = shift;
    "$self->{code} $self->{message}";
}

sub as_string {
    my $self = shift;
    $self->{headers_as_string} . ($self->{content} || '');
}

my @methods = qw(
request protocol code message method
headers_as_string headers content
);

for my $method (@methods) {
    no strict 'refs';
    *$method = sub {
        my($self, $val) = @_;
        $self->{$method} = $val if $val;
        $self->{$method};
    };
}

#inherit headers_as_string, as_string, protocol, content, etc. methods
@Apache::TestClientRequest::ISA = qw(Apache::TestClientResponse);

1;
