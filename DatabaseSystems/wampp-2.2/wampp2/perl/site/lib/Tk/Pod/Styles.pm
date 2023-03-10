
require 5;
use strict;
package Tk::Pod::Styles;

sub init_styles {
  my $w = shift;
  $w->set_base_font_size($w->standard_font_size);
}

sub standard_font_size {
  my $w = shift;
  my $std_font = $w->optionGet('font', 'Font');
  my $std_font_size;
  if (!defined $std_font || $std_font eq '') {
    my $l = $w->Label;
    $std_font = $l->cget(-font);
    $std_font_size = $l->fontActual($std_font, '-size');
    $l->destroy;
  } else {
    $std_font_size = $w->fontActual($std_font, '-size');
  }
  $std_font_size;
}

sub adjust_font_size {
  my($w, $new_size) = @_;
  my $delta = $new_size - $w->base_font_size;
  $w->set_base_font_size($new_size);

  for my $tag ($w->tagNames) {
    my $f = $w->tagCget($tag, '-font');
    if ($f) {
      my %f = $w->fontActual($f);
      $f{-size} += $delta;
      my $new_f = $w->fontCreate(%f);
      $w->tagConfigure($tag, -font => $new_f);
    }
  }
}

sub set_base_font_size { $_[0]{'style'}{'base_font_size'} = $_[1] }

sub base_font_size { return $_[0]{'style'}{'base_font_size'} ||= 10 }

sub style_over_bullet {
  $_[0]->{'style'}{'over_bullet'} ||=
    [ 'indent' => $_[1]->attr('indent') || 4, @{ $_[0]->style_Para } ]
}
sub style_over_number {
  $_[0]->{'style'}{'over_number'} ||=
    [ 'indent' => $_[1]->attr('indent') || 4, @{ $_[0]->style_Para } ]
}
sub style_over_text   {
  $_[0]->{'style'}{'over_text'} ||=
    [ 'indent' => $_[1]->attr('indent') || 4, @{ $_[0]->style_Para } ]
}

sub style_item_text   {
  $_[0]->{'style'}{'item_text'} ||=
    [ 'indent' => -1, @{ $_[0]->style_Para } ]  # for back-denting
}
sub style_item_bullet   {
  $_[0]->{'style'}{'item_bullet'} ||=
    [ 'indent' => -1, @{ $_[0]->style_Para } ]  # for back-denting
}
sub style_item_number   {
  $_[0]->{'style'}{'item_number'} ||=
    [ 'indent' => -1, @{ $_[0]->style_Para } ]  # for back-denting
}

sub style_Para {
  $_[0]->{'style'}{'Para'} ||=
    [ 'family' => 'times', 'size' => $_[0]->base_font_size ]
}

sub style_Verbatim {
  $_[0]->{'style'}{'Verbatim'} ||=
    [ 'family' => 'courier',
      'size' => $_[0]->base_font_size,
      'wrap' => 'none',
    ]
}

sub style_head1 {
  $_[0]->{'style'}{'head1'} ||=
    [ 'family' => 'helvetica', 'size' => int(1 + 1.75 * $_[0]->base_font_size),
      'underline' => 'true',
    ]
}
sub style_head2 {
  $_[0]->{'style'}{'head2'} ||=
    [ 'family' => 'helvetica', 'size' => int(1 + 1.50 * $_[0]->base_font_size),
      'underline' => 'true',
    ]
}
sub style_head3 {
  $_[0]->{'style'}{'head3'} ||=
    [ 'family' => 'helvetica', 'size' => int(1 + 1.25 * $_[0]->base_font_size),
      'underline' => 'true',
    ]
}
sub style_head4 {
  $_[0]->{'style'}{'head4'} ||=
    [ 'family' => 'helvetica', 'size' => int(1 + 1.10 * $_[0]->base_font_size),
      'underline' => 'true',
    ]
}

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

sub style_C {
  $_[0]->{'style'}{'C'} ||=  [ 'family' => 'courier',  ]  }

sub style_B {
  $_[0]->{'style'}{'B'} ||=  [ 'weight' => 'bold',     ]  }

sub style_I {
  $_[0]->{'style'}{'I'} ||=  [ 'slant' => 'italic'  ,  ]  }

sub style_F {
  $_[0]->{'style'}{'F'} ||=  [ 'slant' => 'italic'  ,  ]  }

#sub style_S {
#  $_[0]->{'style'}{'C'} ||=  [ 'wrap' => 'none' ]        }

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
1;
__END__


