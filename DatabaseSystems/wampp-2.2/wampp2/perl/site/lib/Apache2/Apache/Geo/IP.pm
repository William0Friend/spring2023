package Apache::Geo::IP;

use strict;
use Apache::RequestRec;                         # $r
use Apache::Const -compile => qw(REMOTE_HOST);  # constants
use Apache::RequestUtil ();                     # $r->dir_config
use APR::Table;                                 # dir_config->get
use Apache::Log;                                # log_error
use vars qw($VERSION $gip);

use Apache::GeoIP;

@Apache::Geo::IP::ISA = qw(Apache::RequestRec);

$VERSION = '1.12';

my $GEOIP_DBFILE = "C:/Program Files/GeoIP/GeoIP.dat";
sub GEOIP_STANDARD(){0;}
sub GEOIP_MEMORY_CACHE(){1;}

sub new {
  my ($class, $r) = @_;

  init($r) unless $gip;

  return bless { r => $r}, $class;
}

sub init {
  my $r = shift;
  my $file = $r->dir_config->get('GeoIPDBFile') || $GEOIP_DBFILE;
  if ($file) {
    unless ( -e $file) {
      $r->log_error("Cannot find GeoIP database file '$file'");
      die;
    }
  }
  else {
    $r->log_error("Must specify GeoIP database file");
    die;
  }

  my $flag = $r->dir_config->get('GeoIPFlag');
  if ($flag) {
    unless ($flag =~ /^(STANDARD|MEMORY_CACHE)$/i) {
      $r->log_error("GeoIP flag '$flag' not understood");
      die;
    }
    $flag = 'GEOIP_' . uc($flag);
  }
  else {
    $flag = 'GEOIP_STANDARD';
  }

  unless ($gip = Apache::GeoIP->open($file, $flag)) {
    $r->log_error("Couldn't make GeoIP object");
    die;
  }
}

sub country_code_by_addr {
  my $self = shift;
  my $ip = shift || $self->connection->remote_ip;
  return $gip->_country_code_by_addr($ip);
}

sub country_code_by_name {
  my $self = shift;
  my $host = shift || $self->get_remote_host(Apache::REMOTE_HOST);
  return $gip->_country_code_by_name($host);
}

sub country_code3_by_addr {
  my $self = shift;
  my $ip = shift || $self->connection->remote_ip;
  return $gip->_country_code3_by_addr($ip);
}

sub country_code3_by_name {
  my $self = shift;
  my $host = shift || $self->get_remote_host(Apache::REMOTE_HOST);
  return $gip->_country_code3_by_name($host);
}

sub country_name_by_addr {
  my $self = shift;
  my $ip = shift || $self->connection->remote_ip;
  return $gip->_country_name_by_addr($ip);
}

sub country_name_by_name {
  my $self = shift;
  my $host = shift || $self->get_remote_host(Apache::REMOTE_HOST);
  return $gip->_country_name_by_name($host);
}


1;

__END__

=head1 NAME

Apache::Geo::IP - Look up country by IP address

=head1 SYNOPSIS

 # in httpd.conf
 # PerlModule Apache::HelloIP
 #<Location /ip>
 #   SetHandler perl-script
 #   PerlResponseHandler Apache::HelloIP
 #   PerlSetVar GeoIPDBFile "/usr/local/share/GeoIP/GeoIP.dat"
 #   PerlSetVar GeoIPFlag Standard
 #</Location>
 
 # file Apache::HelloIP
  
 use Apache::Geo::IP;
 use strict;
 
 use Apache::Const -compile => 'OK';
 
 sub handler {
   my $r = Apache::Geo::IP->new(shift);
   $r->content_type('text/plain');
   my $country = uc($r->country_code_by_addr());
  
   $r->print($country);
  
   return Apache::OK;
 }
 1;
 
=head1 DESCRIPTION

This module constitutes a mod_perl (version 2) interface to the 
I<Geo::IP> module, which looks up in a database a country of origin of
an IP address. This database simply contains
IP blocks as keys, and countries as values. This database should be more
complete and accurate than reverse DNS lookups.

This module can be used to automatically select the geographically 
closest mirror, to analyze your web server logs
to determine the countries of your visiters, for credit card fraud
detection, and for software export controls.

To find a country for an IP address, this module a finds the Network
that contains the IP address, then returns the country the Network is
assigned to.

=head1 CONFIGURATION

This module subclasses I<Apache::RequestRec>, and can be used 
as follows in an Apache module.
 
  # file Apache::HelloIP
  
  use Apache::Geo::IP;
  use strict;
 
  sub handler {
     my $r = Apache::Geo::IP->new(shift);
     # continue along
  }
 
The directives in F<httpd.conf> are as follows:
 
  <Location /ip>
    PerlSetVar GeoIPDBFile "/usr/local/share/GeoIP/GeoIP.dat"
    PerlSetVar GeoIPFlag Standard
    # other directives
  </Location>
 
The C<PerlSetVar> directives available are

=over 4

=item PerlSetVar GeoIPDBFile "/path/to/GeoIP.dat"

This specifies the location of the F<GeoIP.dat> file.
If not given, it defaults to the location specified
upon installing the module.

=item PerlSetVar GeoIPFlag Standard

This can be set to I<STANDARD>, or for faster performance
but at a cost of using more memory, I<MEMORY_CACHE>.
If not specified, I<STANDARD> is used.

=back

=head1 METHODS

The available methods are as follows.

=over 4

=item $code = $r->country_code_by_addr( [$ipaddr] );

Returns the ISO 3166 country code for an IP address.
If I<$ipaddr> is not given, the value obtained by
C<$r-E<gt>connection-E<gt>remote_ip> is used.

=item $code = $r->country_code_by_name( [$ipname] );

Returns the ISO 3166 country code for a hostname.
If I<$ipname> is not given, the value obtained by
C<$r-E<gt>get_remote_host(Apache::REMOTE_HOST)> is used.

=item $code = $r->country_code3_by_addr( [$ipaddr] );

Returns the 3 letter country code for an IP address.
If I<$ipaddr> is not given, the value obtained by
C<$r-E<gt>connection-E<gt>remote_ip> is used.

=item $code = $r->country_code3_by_name( [$ipname] );

Returns the 3 letter country code for a hostname.
If I<$ipname> is not given, the value obtained by
C<$r-E<gt>get_remote_host(Apache::REMOTE_HOST)> is used.

=item $name = $r->country_name_by_addr( [$ipaddr] );

Returns the full country name for an IP address.
If I<$ipaddr> is not given, the value obtained by
C<$r-E<gt>connection-E<gt>remote_ip> is used.

=item $name = $r->country_name_by_name( [$ipname] );

Returns the full country name for a hostname.
If I<$ipname> is not given, the value obtained by
C<$r-E<gt>get_remote_host(Apache::REMOTE_HOST)> is used.

=back

=head1 VERSION

1.11

=head1 SEE ALSO

L<Geo::IP> and L<Apache::RequestRec>.

=head1 AUTHOR

The look-up code for associating a country with an IP address 
is based on the GeoIP library and the Geo::IP Perl module, and is 
Copyright (c) 2002, T.J. Mather, tjmather@tjmather.com, New York, NY, 
USA. See http://www.maxmind.com/ for details. The mod_perl interface is 
Copyright (c) 2002, Randy Kobes <randy@theoryx5.uwinnipeg.ca>.

All rights reserved.  This package is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=cut
