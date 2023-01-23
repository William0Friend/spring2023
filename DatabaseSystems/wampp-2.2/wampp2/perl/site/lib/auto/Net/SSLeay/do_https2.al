# NOTE: Derived from blib\lib\Net\SSLeay.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::SSLeay;

#line 1981 "blib\lib\Net\SSLeay.pm (autosplit into blib\lib\auto\Net\SSLeay\do_https2.al)"
### do_https2() is a legacy version in the sense that it is unable
### to return all instances of duplicate headers.

sub do_https2 {
    my ($page, $response, $headers) = &do_https3;
    return ($page, $response,
	    map( { ($h,$v)=/^(\S+)\:\s*(.*)$/; (uc($h),$v); }
		split(/\s?\n/, $headers)
		)
	    );
}

# end of Net::SSLeay::do_https2
1;
