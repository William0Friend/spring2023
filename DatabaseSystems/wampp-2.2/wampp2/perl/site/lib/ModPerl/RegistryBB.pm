package ModPerl::RegistryBB;

use strict;
use warnings FATAL => 'all';

# we try to develop so we reload ourselves without die'ing on the warning
no warnings qw(redefine); # XXX, this should go away in production!

our $VERSION = '1.99';

use base qw(ModPerl::RegistryCooker);

sub handler : method {
    my $class = (@_ >= 2) ? shift : __PACKAGE__;
    my $r = shift;
    return $class->new($r)->default_handler();
}

# currently all the methods are inherited through the normal ISA
# search may

1;
__END__

=head1 NAME

ModPerl::RegistryBB - Run unaltered CGI scripts persistently under mod_perl

=head1 Synopsis

  # httpd.conf
  PerlModule ModPerl::RegistryBB
  Alias /perl/ /home/httpd/perl/
  <Location /perl>
      SetHandler perl-script
      PerlResponseHandler ModPerl::RegistryBB
      #PerlOptions +ParseHeaders
      #PerlOptions -GlobalRequest
      Options +ExecCGI
  </Location>

=head1 Description

C<ModPerl::RegistryBB> is similar to C<L<ModPerl::Registry>>, but does
the bare minimum (mnemonic: BB = Bare Bones) to compile a script file
once and run it many times, in order to get the maximum
performance. Whereas C<L<ModPerl::Registry>> does various checks,
which add a slight overhead to response times.

=head1 Authors

Doug MacEachern

Stas Bekman

=head1 See Also

C<L<ModPerl::RegistryCooker>>, C<L<ModPerl::Registry>>, Apache(3),
mod_perl(3)

=cut
