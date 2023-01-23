# NOTE: Derived from blib\lib\Net\SSLeay.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::SSLeay;

#line 1480 "blib\lib\Net\SSLeay.pm (autosplit into blib\lib\auto\Net\SSLeay\open_proxy_tcp_connection.al)"
### Open connection via standard web proxy, if one was defined
### using set_proxy().

sub open_proxy_tcp_connection {
    my ($dest_serv, $port) = @_;
    
    return open_tcp_connection($dest_serv, $port) if !$proxyhost;
    
    warn "Connect via proxy: $proxyhost:$proxyport" if $trace>2;
    my @ret = open_tcp_connection($proxyhost, $proxyport);
    return wantarray ? @ret : 0 if !$ret[0];  # Connection fail
    
    warn "Asking proxy to connect to $dest_serv:$port" if $trace>2;
    print SSLCAT_S "CONNECT $dest_serv:$port HTTP/1.0$proxyauth$CRLF$CRLF";
    my $line = <SSLCAT_S>; 
    warn "Proxy response: $line" if $trace>2;
    
    return wantarray ? (1,undef) : 1;  # Success
}

# end of Net::SSLeay::open_proxy_tcp_connection
1;
