package Encode::Unicode;

use strict;
use warnings;

our $VERSION = do { my @r = (q$Revision: 1.39 $ =~ /\d+/g); sprintf "%d."."%02d" x $#r, @r };

use XSLoader;
XSLoader::load(__PACKAGE__,$VERSION);

#
# Object Generator 8 transcoders all at once!
#

require Encode;

for my $name (qw(UTF-16 UTF-16BE UTF-16LE
                 UTF-32 UTF-32BE UTF-32LE
                        UCS-2BE  UCS-2LE))
{
    my ($size, $endian, $ucs2, $mask);
    $name =~ /^(\w+)-(\d+)(\w*)$/o;
    if ($ucs2 = ($1 eq 'UCS')){
	$size = 2;
    }else{
	$size = $2/8;
    }
    $endian = ($3 eq 'BE') ? 'n' : ($3 eq 'LE') ? 'v' : '' ;
    $size == 4 and $endian = uc($endian);

    $Encode::Encoding{$name} = 	
	bless {
	       Name   =>   $name,
	       size   =>   $size,
	       endian => $endian,
	       ucs2   =>   $ucs2,
	      } => __PACKAGE__;

}

use base qw(Encode::Encoding);

#
# three implementations of (en|de)code exist.  The XS version is the
# fastest.  *_modern uses an array and *_classic sticks with substr.
# *_classic is  much slower but more memory conservative.
# *_xs is the default.

sub set_transcoder{
    no warnings qw(redefine);
    my $type = shift;
    if    ($type eq "xs"){
	*decode = \&decode_xs;
	*encode = \&encode_xs;
    }elsif($type eq "modern"){
	*decode = \&decode_modern;
	*encode = \&encode_modern;
    }elsif($type eq "classic"){
	*decode = \&decode_classic;
	*encode = \&encode_classic;
    }else{
	require Carp; 
	Carp::croak __PACKAGE__, "::set_transcoder(modern|classic|xs)";
    }
}

set_transcoder("xs");

#
# Aux. subs & constants
#

sub FBCHAR(){ 0xFFFd }
sub BOM_BE(){ 0xFeFF }
sub BOM16LE(){ 0xFFFe }
sub BOM32LE(){ 0xFFFe0000 }

sub valid_ucs2($){
    return 
	(0 <= $_[0] && $_[0] < 0xD800) 
	    || 	( 0xDFFF < $_[0] && $_[0] <= 0xFFFF);
}

sub issurrogate($){   0xD800 <= $_[0]  && $_[0] <= 0xDFFF }
sub isHiSurrogate($){ 0xD800 <= $_[0]  && $_[0] <  0xDC00 }
sub isLoSurrogate($){ 0xDC00 <= $_[0]  && $_[0] <= 0xDFFF }

sub ensurrogate($){
    use integer; # we have divisions
    my $uni = shift;
    my  $hi = ($uni - 0x10000) / 0x400 + 0xD800;
    my  $lo = ($uni - 0x10000) % 0x400 + 0xDC00;
    return ($hi, $lo);
}

sub desurrogate($$){
    my ($hi, $lo) = @_;
    return 0x10000 + ($hi - 0xD800)*0x400 + ($lo - 0xDC00);
}

sub Mask { {2 => 0xffff,  4 => 0xffffffff} }

#
# *_modern are much faster but guzzle more memory
#

sub decode_modern($$;$)
{
    my ($obj, $str, $chk ) = @_;
    my ($size, $endian, $ucs2) = @$obj{qw(size endian ucs2)};

    # warn "$size, $endian, $ucs2";
    $endian ||= BOMB($size, substr($str, 0, $size, ''))
	or poisoned2death($obj, "Where's the BOM?");
    my  $mask = Mask->{$size};
    my $utf8   = '';
    my @ord = unpack("$endian*", $str);
    undef $str; # to conserve memory
    while (@ord){
	my $ord = shift @ord;
	unless ($size == 4 or valid_ucs2($ord &= $mask)){
	    if ($ucs2){
		$chk and 
		    poisoned2death($obj, "no surrogates allowed", $ord);
		shift @ord; # skip the next one as well
		$ord = FBCHAR;
	    }else{
		unless (isHiSurrogate($ord)){
		    poisoned2death($obj, "Malformed HI surrogate", $ord);
		}
		my $lo = shift @ord;
		unless (isLoSurrogate($lo &= $mask)){
		    poisoned2death($obj, "Malformed LO surrogate", $ord, $lo);
		}
		$ord = desurrogate($ord, $lo);
	    }
	}
	$utf8 .= chr($ord);
    }
    utf8::upgrade($utf8);
    return $utf8;
}

sub encode_modern($$;$)
{
    my ($obj, $utf8, $chk) = @_;
    my ($size, $endian, $ucs2) = @$obj{qw(size endian ucs2)};
    my @str = ();
    unless ($endian){
	$endian = ($size == 4) ? 'N' : 'n';
	push @str, BOM_BE;
    }
    my @ord = unpack("U*", $utf8);
    undef $utf8; # to conserve memory
    for my $ord (@ord){
	unless ($size == 4 or valid_ucs2($ord)) {
	    unless(issurrogate($ord)){
		if ($ucs2){
		    $chk and 
			poisoned2death($obj, "code point too high", $ord);

		    push @str, FBCHAR;
		}else{
		 
		    push @str, ensurrogate($ord);
		}
	    }else{  # not supposed to happen
		push @str, FBCHAR;
	    }
	}else{
	    push @str, $ord;
	}
    }
    return pack("$endian*", @str);
}

#
# *_classic are slower but more memory conservative
#

sub decode_classic($$;$)
{
    my ($obj, $str, $chk ) = @_;
    my ($size, $endian, $ucs2) = @$obj{qw(size endian ucs2)};

    # warn "$size, $endian, $ucs2";
    $endian ||= BOMB($size, substr($str, 0, $size, ''))
	or poisoned2death($obj, "Where's the BOM?");
    my  $mask = Mask->{$size};
    my $utf8   = '';
    my @ord = unpack("$endian*", $str);
    while (length($str)){
	 my $ord = unpack($endian, substr($str, 0, $size, ''));
	unless ($size == 4 or valid_ucs2($ord &= $mask)){
	    if ($ucs2){
		$chk and 
		    poisoned2death($obj, "no surrogates allowed", $ord);
		substr($str,0,$size,''); # skip the next one as well
		$ord = FBCHAR;
	    }else{
		unless (isHiSurrogate($ord)){
		    poisoned2death($obj, "Malformed HI surrogate", $ord);
		}
		my $lo = unpack($endian ,substr($str,0,$size,''));
		unless (isLoSurrogate($lo &= $mask)){
		    poisoned2death($obj, "Malformed LO surrogate", $ord, $lo);
		}
		$ord = desurrogate($ord, $lo);
	    }
	}
	$utf8 .= chr($ord);
    }
    utf8::upgrade($utf8);
    return $utf8;
}

sub encode_classic($$;$)
{
    my ($obj, $utf8, $chk) = @_;
    my ($size, $endian, $ucs2) = @$obj{qw(size endian ucs2)};
    # warn join ", ", $size, $ucs2, $endian, $mask;
    my $str   = '';
    unless ($endian){
	$endian = ($size == 4) ? 'N' : 'n';
	$str .= pack($endian, BOM_BE);
    }
    while (length($utf8)){
	my $ord  = ord(substr($utf8,0,1,''));
	unless ($size == 4 or valid_ucs2($ord)) {
	    unless(issurrogate($ord)){
		if ($ucs2){
		    $chk and 
			poisoned2death($obj, "code point too high", $ord);
		    $str .= pack($endian, FBCHAR);
		}else{
		    $str .= pack($endian.2, ensurrogate($ord));
		}
	    }else{  # not supposed to happen
		$str .= pack($endian, FBCHAR);
	    }
	}else{
	    $str .= pack($endian, $ord);
	}
    }
    return $str;
}

sub BOMB {
    my ($size, $bom) = @_;
    my $N = $size == 2 ? 'n' : 'N';
    my $ord = unpack($N, $bom);
    return ($ord eq BOM_BE) ? $N : 
	($ord eq BOM16LE) ? 'v' : ($ord eq BOM32LE) ? 'V' : undef;
}

sub poisoned2death{
    my $obj = shift;
    my $msg = shift;
    my $pair = join(", ", map {sprintf "\\x%x", $_} @_);
    require Carp;
    Carp::croak $obj->name, ":", $msg, "<$pair>.", caller;
}

1;
__END__

=head1 NAME

Encode::Unicode -- Various Unicode Transformation Formats

=cut

=head1 SYNOPSIS

    use Encode qw/encode decode/; 
    $ucs2 = encode("UCS-2BE", $utf8);
    $utf8 = decode("UCS-2BE", $ucs2);

=head1 ABSTRACT

This module implements all Character Encoding Schemes of Unicode that
are officially documented by Unicode Consortium (except, of course,
for UTF-8, which is a native format in perl).

=over 4

=item L<http://www.unicode.org/glossary/> says:

I<Character Encoding Scheme> A character encoding form plus byte
serialization. There are Seven character encoding schemes in Unicode:
UTF-8, UTF-16, UTF-16BE, UTF-16LE, UTF-32 (UCS-4), UTF-32BE (UCS-4BE) and
UTF-32LE (UCS-4LE), and UTF-7.

Since UTF-7 is a 7-bit (re)encoded version of UTF-16BE, It is not part of
Unicode's Character Encoding Scheme.  It is separately implemented in
Encode::Unicode::UTF7.  For details see L<Encode::Unicode::UTF7>.

=item Quick Reference

                Decodes from ord(N)           Encodes chr(N) to...
       octet/char BOM S.P d800-dfff  ord > 0xffff     \x{1abcd} ==
  ---------------+-----------------+------------------------------
  UCS-2BE	2   N   N  is bogus                  Not Available
  UCS-2LE       2   N   N     bogus                  Not Available
  UTF-16      2/4   Y   Y  is   S.P           S.P            BE/LE
  UTF-16BE    2/4   N   Y       S.P           S.P    0xd82a,0xdfcd
  UTF-16LE	2   N   Y       S.P           S.P    0x2ad8,0xcddf
  UTF-32	4   Y   -  is bogus         As is            BE/LE
  UTF-32BE	4   N   -     bogus         As is       0x0001abcd
  UTF-32LE	4   N   -     bogus         As is       0xcdab0100
  UTF-8       1-4   -   -     bogus   >= 4 octets   \xf0\x9a\af\8d
  ---------------+-----------------+------------------------------

=back

=head1 Size, Endianness, and BOM

You can categorize these CES by 3 criteria:  size of each character,
endianness, and Byte Order Mark.

=head2 by size

UCS-2 is a fixed-length encoding with each character taking 16 bits.
It B<does not> support I<surrogate pairs>.  When a surrogate pair
is encountered during decode(), its place is filled with \x{FFFD}
if I<CHECK> is 0, or the routine croaks if I<CHECK> is 1.  When a
character whose ord value is larger than 0xFFFF is encountered,
its place is filled with \x{FFFD} if I<CHECK> is 0, or the routine
croaks if I<CHECK> is 1.

UTF-16 is almost the same as UCS-2 but it supports I<surrogate pairs>.
When it encounters a high surrogate (0xD800-0xDBFF), it fetches the
following low surrogate (0xDC00-0xDFFF) and C<desurrogate>s them to
form a character.  Bogus surrogates result in death.  When \x{10000}
or above is encountered during encode(), it C<ensurrogate>s them and
pushes the surrogate pair to the output stream.

UTF-32 (UCS-4) is a fixed-length encoding with each character taking 32 bits.
Since it is 32-bit, there is no need for I<surrogate pairs>.

=head2 by endianness

The first (and now failed) goal of Unicode was to map all character
repertoires into a fixed-length integer so that programmers are happy.
Since each character is either a I<short> or I<long> in C, you have to
pay attention to the endianness of each platform when you pass data
to one another.

Anything marked as BE is Big Endian (or network byte order) and LE is
Little Endian (aka VAX byte order).  For anything not marked either
BE or LE, a character called Byte Order Mark (BOM) indicating the
endianness is prepended to the string.

=over 4

=item BOM as integer when fetched in network byte order

              16         32 bits/char
  -------------------------
  BE      0xFeFF 0x0000FeFF
  LE      0xFFeF 0xFFFe0000
  -------------------------

=back

This modules handles the BOM as follows.

=over 4

=item *

When BE or LE is explicitly stated as the name of encoding, BOM is
simply treated as a normal character (ZERO WIDTH NO-BREAK SPACE).

=item *

When BE or LE is omitted during decode(), it checks if BOM is at the
beginning of the string; if one is found, the endianness is set to
what the BOM says.  If no BOM is found, the routine dies.

=item *

When BE or LE is omitted during encode(), it returns a BE-encoded
string with BOM prepended.  So when you want to encode a whole text
file, make sure you encode() the whole text at once, not line by line
or each line, not file, will have a BOM prepended.

=item *

C<UCS-2> is an exception.  Unlike others, this is an alias of UCS-2BE.
UCS-2 is already registered by IANA and others that way.

=back

=head1 Surrogate Pairs

To say the least, surrogate pairs were the biggest mistake of the
Unicode Consortium.  But according to the late Douglas Adams in I<The
Hitchhiker's Guide to the Galaxy> Trilogy, C<In the beginning the
Universe was created. This has made a lot of people very angry and
been widely regarded as a bad move>.  Their mistake was not of this
magnitude so let's forgive them.

(I don't dare make any comparison with Unicode Consortium and the
Vogons here ;)  Or, comparing Encode to Babel Fish is completely
appropriate -- if you can only stick this into your ear :)

Surrogate pairs were born when the Unicode Consortium finally
admitted that 16 bits were not big enough to hold all the world's
character repertoires.  But they already made UCS-2 16-bit.  What
do we do?

Back then, the range 0xD800-0xDFFF was not allocated.  Let's split
that range in half and use the first half to represent the C<upper
half of a character> and the second half to represent the C<lower
half of a character>.  That way, you can represent 1024 * 1024 =
1048576 more characters.  Now we can store character ranges up to
\x{10ffff} even with 16-bit encodings.  This pair of half-character is
now called a I<surrogate pair> and UTF-16 is the name of the encoding
that embraces them.

Here is a formula to ensurrogate a Unicode character \x{10000} and
above;

  $hi = ($uni - 0x10000) / 0x400 + 0xD800;
  $lo = ($uni - 0x10000) % 0x400 + 0xDC00;

And to desurrogate;

 $uni = 0x10000 + ($hi - 0xD800) * 0x400 + ($lo - 0xDC00);

Note this move has made \x{D800}-\x{DFFF} into a forbidden zone but
perl does not prohibit the use of characters within this range.  To perl, 
every one of \x{0000_0000} up to \x{ffff_ffff} (*) is I<a character>.

  (*) or \x{ffff_ffff_ffff_ffff} if your perl is compiled with 64-bit
  integer support!

=head1 SEE ALSO

L<Encode>, L<Encode::Unicode::UTF7>, L<http://www.unicode.org/glossary/>,
L<http://www.unicode.org/unicode/faq/utf_bom.html>,

RFC 2781 L<http://rfc.net/rfc2781.html>,

The whole Unicode standard L<http://www.unicode.org/unicode/uni2book/u2.html>

Ch. 15, pp. 403 of C<Programming Perl (3rd Edition)>
by Larry Wall, Tom Christiansen, Jon Orwant; 
O'Reilly & Associates; ISBN 0-596-00027-8

=cut
