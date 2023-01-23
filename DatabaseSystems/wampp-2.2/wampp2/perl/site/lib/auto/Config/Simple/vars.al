# NOTE: Derived from blib\lib\Config\Simple.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Config::Simple;

#line 1318 "blib\lib\Config\Simple.pm (autosplit into blib\lib\auto\Config\Simple\vars.al)"
# returns all the keys as a hash or hashref
sub vars {
  my $self = shift;

  my $syntax = $self->{_SYNTAX} or die "'_SYNTAX' is not defined";
  my %vars = ();
  if ( $syntax eq 'ini' ) {
    while ( my ($block, $values) = each %{$self->{_DATA}} ) {
      while ( my ($k, $v) = each %{$values} ) {
        $vars{"$block.$k"} = defined($v->[1]) ? $v : $v->[0];
      }
    }
  } else {
    while ( my ($k, $v) = each %{$self->{_DATA}} ) {
      $vars{$k} = $v->[1] ? $v : $v->[0];
    }
  }
  return wantarray ? %vars : \%vars;
}

# end of Config::Simple::vars
1;
