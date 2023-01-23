# NOTE: Derived from blib\lib\Net\SSLeay.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::SSLeay;

#line 1955 "blib\lib\Net\SSLeay.pm (autosplit into blib\lib\auto\Net\SSLeay\do_https3.al)"
sub do_https3 {
    my ($method, $site, $port, $path, $headers,
	$content, $mime_type, $crt_path, $key_path) = @_;
    my ($response, $page, $h,$v);

    if ($content) {
	$mime_type = "application/x-www-form-urlencoded" unless $mime_type;
	my $len = blength($content);
	$content = "Content-Type: $mime_type$CRLF"
	    . "Content-Length: $len$CRLF$CRLF$content";
    } else {
	$content = "$CRLF$CRLF";
    }
    my $req = "$method $path HTTP/1.0$CRLF"."Host: $site:$port$CRLF"
      . (defined $headers ? $headers : '') . "Accept: */*$CRLF$content";    

    my ($http, $errs, $server_cert)
	= https_cat($site, $port, $req, $crt_path, $key_path);
    return (undef, "HTTP/1.0 900 NET OR SSL ERROR$CRLF$CRLF$errs") if $errs;
    
    $http = '' if !defined $http;
    ($headers, $page) = split /\s?\n\s?\n/, $http, 2;
    ($response, $headers) = split /\s?\n/, $headers, 2;
    return ($page, $response, $headers, $server_cert);
}

# end of Net::SSLeay::do_https3
1;
