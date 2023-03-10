package Apache::Geo::IP::Record;

use Apache::GeoIP;
use strict;
use Apache::RequestRec;
use Apache::RequestUtil;
use APR::Table;
use Apache::Log;
use vars qw($VERSION $record $gir);

my $GEOIP_DBCITYFILE;

@Apache::Geo::IP::Record::ISA = qw(Apache::RequestRec);

$VERSION = '1.12';

sub GEOIP_STANDARD(){0;}
sub GEOIP_MEMORY_CACHE(){1;}

sub new {
  my ($class, $r) = @_;
 
  init($r) unless ($gir);

  return bless { r => $r }, $class;
}

sub init {
  my $r = shift;
  my $file = $r->dir_config->get('GeoIPDBCityFile') || $GEOIP_DBCITYFILE;
  if ($file) {
    unless (-e $file) {
      $r->log_error("Cannot find GeoIPCity database file '$file'");
      die;
    }
  }
  else {
    $r->warn("Cannot find GeoIPCity database file");
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
  unless ($gir = Apache::GeoIP->open($file, $flag)) {
    $r->log_error("Couldn't make GeoIP record object");
    die;
  }
  unless (make_record($r->connection->remote_ip)) {
    $r->log_error("Couldn't make GeoIP record");
    die;
  }
}

sub make_record {
  my $conn = shift;
  $record = ($conn =~ /^[0-9\.]+$/) ?
    $gir->record_by_addr($conn) :
      $gir->record_by_name($conn);
  return $record ? 1 : 0;
}

sub country_code {
  my $self = shift;
  if (my $conn = shift ) {
    make_record($conn);
  }
  return $record->_country_code();
}

sub country_code3 {
  my $self = shift;
  if (my $conn = shift ) {
    make_record($conn);
  }
  return $record->_country_code3();
}

sub country_name {
  my $self = shift;
  if (my $conn = shift ) {
    make_record($conn);
  }
  return $record->_country_name();
}

sub region {
  my $self = shift;
  if (my $conn = shift ) {
    make_record($conn);
  }
  return $record->_region();
}

sub city {
  my $self = shift;
  if (my $conn = shift ) {
    make_record($conn);
  }
  return $record->_city();
}

sub postal_code {
  my $self = shift;
  if (my $conn = shift ) {
    make_record($conn);
  }
  return $record->_postal_code();
}

sub latitude {
  my $self = shift;
  if (my $conn = shift ) {
    make_record($conn);
  }
  return sprintf("%.4f", $record->_latitude());
}

sub longitude {
  my $self = shift;
  if (my $conn = shift ) {
    make_record($conn);
  }
  return sprintf("%.4f", $record->_longitude());
}

1;
__END__

=head1 NAME

Apache::Geo::IP::Record - Contains city information for GeoIP City Edition

=head1 SYNOPSIS

 # in httpd.conf
 # PerlModule Apache::HelloIP
 #<Location /ip>
 #   SetHandler perl-script
 #   PerlResponseHandler Apache::HelloIP
 #   PerlSetVar GeoIPDBCityFile "/usr/local/share/GeoIP/GeoIPCity.dat"
 #   PerlSetVar GeoIPFlag Standard
 #</Location>
 
 # file Apache::HelloIP
  
 use Apache::Geo::IP::Record;
 use strict;

 use Apache::Const -compile => 'OK';
 
 sub handler {
   my $r = Apache::Geo::IP::Record->new(shift);
   $r->content_type('text/plain');
   my $city = $r->city;
 
   $r->print($city);
  
   return Apache::OK;
 }
 1;

=head1 DESCRIPTION

This module constitutes a mod_perl (version 2) interface to the 
I<Geo::IP> module which contains location information
returned by the GeoIP City database.

=head1 CONFIGURATION

This module subclasses I<Apache::RequestReq>, and can be used as follows
in an Apache module.
 
  # file Apache::HelloIP
  
  use Apache::Geo::IP::Record;
  use strict;
  
  sub handler {
     my $r = Apache::Geo::IP::Record->new(shift);
     # continue along
  }
 
The directives in F<httpd.conf> are as follows:
 
  PerlModule Apache::HelloIP
  <Location /ip>
    PerlSetVar GeoIPDBCityFile "/usr/local/share/GeoIP/GeoIPCity.dat"
    PerlSetVar GeoIPFlag Standard
    # other directives
  </Location>
 
The C<PerlSetVar> directives available are

=over 4

=item PerlSetVar GeoIPDBCityFile "/path/to/GeoIPCity.dat"

This specifies the location of the F<GeoIPCity.dat> file.
If not given, it defaults to the location optionally specified
upon installing the module.

=item PerlSetVar GeoIPFlag Standard

This can be set to I<STANDARD>, or for faster performance
but at a cost of using more memory, I<MEMORY_CACHE>.
If not specified, I<STANDARD> is used.

=back

=head1 METHODS

The available methods are as follows.

=over 4

=item $code = $r->country_code( [$conn] );

Returns the ISO 3166 country code for an IP address or hostname.
If I<$conn> is not given, the value obtained by
C<$r-E<gt>connection-E<gt>remote_ip> is used.

=item $code = $r->country_code3( [$conn] );

Returns the 3 letter country code for an IP address or hostname.
If I<$conn> is not given, the value obtained by
C<$r-E<gt>connection-E<gt>remote_ip> is used.

=item $name = $r->country_name( [$conn] );

Returns the full country name for an IP address or hostname.
If I<$conn> is not given, the value obtained by
C<$r-E<gt>connection-E<gt>remote_ip> is used.

=item $region = $r->region( [$conn] );

Returns the region for an IP address or hostname.
If I<$conn> is not given, the value obtained by
C<$r-E<gt>connection-E<gt>remote_ip> is used.

=item $city = $r->city( [$conn] );

Returns the city for an IP address or hostname.
If I<$conn> is not given, the value obtained by
C<$r-E<gt>connection-E<gt>remote_ip> is used.

=item $postal_code = $r->postal_code( [$conn] );

Returns the postal code for an IP address or hostname.
If I<$conn> is not given, the value obtained by
C<$r-E<gt>connection-E<gt>remote_ip> is used.

=item $lat = $r->latitude( [$conn] );

Returns the latitude for an IP address or hostname.
If I<$conn> is not given, the value obtained by
C<$r-E<gt>connection-E<gt>remote_ip> is used.

=item $lon = $r->longitude( [$conn] );

Returns the longitude for an IP address or hostname.
If I<$conn> is not given, the value obtained by
C<$r-E<gt>connection-E<gt>remote_ip> is used.

=back

=head1 VERSION

1.11

=head1 SEE ALSO

L<Geo::IP> and L<Apache>.

=head1 AUTHOR

The look-up code for obtaining this information
is based on the GeoIP library and the Geo::IP Perl module, and is 
Copyright (c) 2002, T.J. Mather, tjmather@tjmather.com, New York, NY, 
USA. See http://www.maxmind.com/ for details. The mod_perl interface is 
Copyright (c) 2002, Randy Kobes <randy@theoryx5.uwinnipeg.ca>.

All rights reserved.  This package is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=cut
