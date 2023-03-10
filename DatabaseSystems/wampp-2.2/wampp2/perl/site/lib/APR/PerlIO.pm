package APR::PerlIO;

require 5.6.1;

our $VERSION = '0.01';

# The PerlIO layer is available only since 5.8.0 (5.7.2@13534)
use Config;
use constant PERLIO_LAYERS_ARE_ENABLED => $Config{useperlio} && $] >= 5.00703;

use APR::XSLoader ();
APR::XSLoader::load __PACKAGE__;


1;
=head1 NAME

APR:PerlIO -- An APR Perl IO layer

=head1 SYNOPSIS

  use APR::PerlIO ();
  
  sub handler {
      my $r = shift;
  
      die "This Perl build doesn't support PerlIO layers"
          unless APR::PerlIO::PERLIO_LAYERS_ARE_ENABLED;
  
      open my $fh, ">:APR", $filename, $r or die $!;
      # work with $fh as normal $fh
      close $fh;
  
      return Apache::OK;
  }

=head1 DESCRIPTION

C<APR::PerlIO> implements a Perl IO layer using APR's file
manipulation as its internals.

Why do you want to use this? Normally you shouldn't, probably it won't
be faster than Perl's default layer. It's only useful when you need to
manipulate a filehandle opened at the APR side, while using Perl.

Normally you won't call open() with APR layer attribute, but some
mod_perl functions will return a filehandle which is internally hooked
to APR. But you can use APR Perl IO directly if you want.

=head1 Constants

=head2 PERLIO_LAYERS_ARE_ENABLED

Before using the Perl IO APR layer one has to check whether it's
supported by the used perl build.

  die "This Perl build doesn't support PerlIO layers"
      unless APR::PerlIO::PERLIO_LAYERS_ARE_ENABLED;

Notice that loading C<APR::PerlIO> won't fail when Perl IO layers
aren't available since C<APR::PerlIO> provides functionality for Perl
builds not supporting Perl IO layers.

=head1 API

Perl Interface:

=head2 open()

To use APR Perl IO to open a file the four arguments open() should be
used. For example:

  open my $fh, ">:APR", $filename, $r or die $!;

where:

the second argument is the mode to open the file, constructed from two
sections separated by the C<:> character: the first section is the
mode to open the file under (E<gt>, E<lt>, etc) and the second section
must be a string I<APR>.

the fourth argument can be a C<Apache::RequestRec> or
C<Apache::ServerRec> object.

the rest of the arguments are the same as described by the I<open()>
manpage.

=head2 seek()

  seek($fh, $offset, $whence);

If C<$offset> is zero, C<seek()> works normally.

However if C<$offset> is non-zero and Perl has been compiled with with
large files support (C<-Duselargefiles>), whereas APR wasn't, this
function will croak. This is because largefile size C<Off_t> simply
cannot fit into a non-largefile size C<apr_off_t>.

To solve the problem, rebuild Perl with C<-Uuselargefiles>. Currently
there is no way to force APR to build with large files support.

=head1 C API

The C API provides functions to convert between Perl IO and APR Perl
IO filehandles.

META: document these

=head1 SEE ALSO

The I<perliol(1)>, I<perlapio(1)> and I<perl(1)> manpages.

=cut

