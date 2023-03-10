=head1 NAME

Crypt::Rijndael - Crypt::CBC compliant Rijndael encryption module

=head1 SYNOPSIS

 use Crypt::Rijndael;

 # keysize() is 32, but 24 and 16 are also possible
 # blocksize() is 16

 $cipher = new Crypt::Rijndael "a" x 32, Crypt::Rijndael::MODE_CBC;

 $cipher->set_iv($iv);
 $crypted = $cipher->encrypt($plaintext);
 # - OR -
 $plaintext = $cipher->decrypt($crypted);

=head1 DESCRIPTION

This module implements the Rijndael cipher, which has just been selected
as the Advanced Encryption Standard.

=over 4

=cut

package Crypt::Rijndael;

require DynaLoader;

$VERSION = 0.04;
@ISA = qw/DynaLoader/;

bootstrap Crypt::Rijndael $VERSION;

=item keysize

Returns the keysize, which is 32 (bytes). The Rijndael cipher
actually supports keylengths of 16, 24 or 32 bytes, but there is no
way to communicate this to C<Crypt::CBC>.

=item blocksize

The blocksize for Rijndael is 16 bytes (128 bits), although the
algorithm actually supports any blocksize that is any multiple of
our bytes.  128 bits, is however, the AES-specified block size,
so this is all we support.

=item $cipher = new $key [, $mode]

Create a new C<Crypt::Rijndael> cipher object with the given key
(which must be 128, 192 or 256 bits long). The additional C<$mode>
argument is the encryption mode, either C<MODE_ECB> (electronic
codebook mode, the default), C<MODE_CBC> (cipher block chaining, the
same that C<Crypt::CBC> does), C<MODE_CFB> (128-bit cipher feedback),
C<MODE_OFB> (128-bit output feedback), or C<MODE_CTR> (counter mode).

ECB mode is very insecure (read a book on cryptography if you dont
know why!), so you should probably use CBC mode.

=item $cipher->set_iv($iv)

This allows you to change the initial value vector used by the
chaining modes.  It is not relevant for ECB mode.

=item $cipher->encrypt($data)

Encrypt data. The size of C<$data> must be a multiple of C<blocksize>
(16 bytes), otherwise this function will croak. Apart from that, it
can be of (almost) any length.

=item $cipher->decrypt($data)

Decrypts C<$data>.

=back

=head1 SEE ALSO

  L<Crypt::CBC>, http://www.csrc.nist.gov/encryption/aes/

=head1 BUGS

Should EXPORT or EXPORT_OK the MODE constants.

=head1 AUTHOR

 Rafael R. Sevilla <sevillar@team.ph.inter.net>

 The Rijndael Algorithm was developed by Vincent Rijmen and Joan Daemen,
 and has been selected as the US Government's Advanced Encryption Standard.

=cut

1;

