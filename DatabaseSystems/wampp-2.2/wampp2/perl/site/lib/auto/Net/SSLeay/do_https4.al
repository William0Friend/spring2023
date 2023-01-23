# NOTE: Derived from blib\lib\Net\SSLeay.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::SSLeay;

#line 1993 "blib\lib\Net\SSLeay.pm (autosplit into blib\lib\auto\Net\SSLeay\do_https4.al)"
### Returns headers as a hash where multiple instances of same header
### are handled correctly.

sub do_https4 {
    my ($page, $response, $headers) = &do_https3;
    my %hr = ();
    for my $hh (split /\s?\n/, $headers) {
	my ($h,$v)=/^(\S+)\:\s*(.*)$/;
	push @{$hr{uc($h)}}, $v;
    }
    return ($page, $response, \%hr);
}

# end of Net::SSLeay::do_https4
1;
