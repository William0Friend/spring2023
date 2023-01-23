package Apache::MyHandler;

use strict;
use HTML::Mason::ApacheHandler;

my $ah =
    HTML::Mason::ApacheHandler->new
          ( comp_root => 'C:/Apache2/mason',
            data_dir  => 'C:/Windows/Temp',
	    args_method => 'CGI',
	  );

sub handler {
  my ($r) = @_;
  
  return $ah->handle_request($r);
}

1;
