package Apache::Hello;
use strict;
use Apache::RequestRec ();  # for $r->content_type
use Apache::RequestIO ();   # for $r->puts
use Apache::Const -compile => ':common';

sub handler {
   my $r = shift;
   my $time = scalar localtime();
   my $package = __PACKAGE__;
   $r->content_type('text/html');
   $r->puts(<<"END");
<HTML><BODY>
<H3>Hello</H3>
Hello from <B>$package</B>! The time is $time.
</BODY></HTML>
END
   return Apache::OK;
}

1;
