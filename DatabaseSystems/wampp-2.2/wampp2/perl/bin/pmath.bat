@rem = '--*-Perl-*--
@echo off
if "%OS%" == "Windows_NT" goto WinNT
perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
:WinNT
perl -x -S %0 %*
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
if errorlevel 1 goto script_failed_so_exit_with_non_zero_val 2>nul
goto endofperl
@rem ';
#!/usr/bin/perl
#line 15
use Config;
use Carp;
use Term::ReadLine;
use Math::Cephes qw(:all);
use Math::Cephes::Complex qw(cmplx);
use Math::Cephes::Fraction qw(:fract);
use strict;
use vars qw($attribs %topics @pagers @topics %desc $lines_max $last_result);
$lines_max = $ENV{LINES} || 20;
search_pagers();
get_topics();
get_descs();
@topics = sort keys %topics;
my $term = Term::ReadLine->new('Math::Cephes interface');
my $rl_package = $term->ReadLine;
my $prompt = "pmath> ";
my $OUT = $term->OUT || '';
select $OUT;
my ($rl_avail);
if ($rl_package eq "Term::ReadLine::Gnu") {
  $attribs = $term->Attribs;
  $attribs->{'attempted_completion_function'} = \&gnu_cpl;
  $attribs->{'completion_entry_function'} =
    $attribs->{'list_completion_function'};
  $rl_avail = 'enabled';
} 
else {
  $readline::rl_completion_function = 'main::cpl';
  if ($rl_package eq 'Term::ReadLine::Perl'  ||
      $rl_package eq 'Term::ReadLine::readline_pl') {
    $rl_avail = 'enabled';
  } 
  else {
    $rl_avail = "available (get Term::ReadKey and"
      . " Term::ReadLine::[Perl|GNU])";
  }
}

print <<"END";

Interactive interface to the Math::Cephes module.
TermReadLine $rl_avail. Type 'help' or '?'  for help.

END

my $prec = 6;
my $flag = 0;
my $expression = '';
while ( defined ($_ = $term->readline($prompt)) ) {
  last if /^\s*(quit|exit|q)\s*$/;
  if ( s!\\\s*$!!) {
    $expression .= $_;
    $flag = 1;
    $prompt = "       ";
    next;
  }
  my @res;
  if ($flag) {
    {
      no strict;
      $expression .= $_;
      @res = eval ($expression);
    }
    warn $@ if $@;
    if (! $@) {
      $last_result = $res[0] if @res == 1;
      print_res(@res);
    }
    $flag = 0;
    $prompt = "pmath> ";
    $expression = '';
    next;
  }
  if (m!;\s*\S+.*;\s*!) {
    {
      no strict;
      @res = eval($_);
    }
    warn $@ if $@;
    if (! $@) {
      $last_result = $res[0] if @res == 1;
      print_res(@res);
    }
    next;
  }
  s/^\s*(\?)/help /;
  s/;\s*$//;
  if (/^\s*(help)\s+/) {
    help($_);
    next;
  }
  if (/^\s*setprec/) {
    set_prec($_);
    next;
  }
  if (/%/) {
    s/%/$last_result/;
  }
  if (/^mixed/) {
    print "\t", $last_result->as_mixed_string, "\n";
    next;
  }
  {
    no strict;
    @res = eval($_), "\n";
  }
  warn $@ if $@;
  if (! $@) {
    $last_result = $res[0] if @res == 1;
    print_res(@res);
  }
  $term->addhistory($_) if /\S/;
}

sub set_prec {
  my $arg = shift;
  ($prec = $arg) =~ s!^\s*setprec(\s*\(|\s+)(\d+).*!$2!;
  if ($prec =~ /\D+/) {
    print  "\nPlease enter a positive integer for setprec\n";
    $prec = 6;
  }
  else {
    print  "\tdisplay set to $prec decimal places\n";
  }
}


sub print_res {
  my @results = @_;
  foreach my $res (@results) {
    next if (@results == 1 and $res == 1);
    if ($res =~ m!^[+-\d]+$!) {
      print  sprintf("\t%d  ", $res);
    }
    elsif ($res =~ m!^[+\-\d\.]+$!) {
      my $length = length(int($res)) + $prec + 2;
      print  sprintf("\t%$length.${prec}f  ", $res);
    }
    elsif ($res =~ m!^[+\-\d\.e]+$!) {
      my $length = $prec + 6;
      print  sprintf("\t%$length.${prec}e  ", $res);
    }
    else {
      if (ref($res) =~ /^Math::Cephes/) {
	print "\t", $res->as_string, "\n";
      }
      else {
	print "\t", $res;
      }
    }
  }
  print  "\n";
}


sub help {
  my $param = shift;
  (my $topic = $param) =~ s!^\s*(help)\s+!!;
  if (!$topic) {
    foreach my $pager (@pagers) {
      open (PAGER, "| $pager") or next;
      print PAGER <<"END";
Enter an expression to be evaluated, or 'q' to quit.
Use 'setprec j' to display 'j' decimal places.
'%' gives the last (successful) evaluated result.
Type 'help function_name' for help on a particular function,
or 'help group_name' for a list of functions grouped as follows:

 constants: useful constants
 trigs: various trigonometric functions
 hypers: various hyperbolic functions
 explog: various exponentiation and logarithmic functions
 complex: some functions to manipulate complex numbers
 fract: some functions to evaluate fractions
 utils: various utilities
 bessels: various Bessel functions
 dists: various distribution functions
 gammas: various gamma functions
 betas: various beta functions
 elliptics: various elliptic functions
 hypergeometrics: some hypergeometric functions
 misc: miscellaneous functions

END
  close(PAGER) or next;
      last;
    }
    
  }
  else {
    $topic =~ s!^\s*(.*?)\s*$!$1!;
    if ($topics{$topic}) {
      my $lines = $topics{$topic} =~ tr/\n//;
      if ($lines > $lines_max) {
	foreach my $pager (@pagers) {
	  open (PAGER, "| $pager") or next;
	  print PAGER $topics{$topic};
	  print PAGER "\n";
	  close(PAGER) or next;
	  last;
	}
      }
      else {
	print $topics{$topic}, "\n";
      }
    }
    else {
      print "\nSorry - no help is available on $topic\n";
    }
  }
  return;
}

sub get_topics {

  my $help = << 'END';
Type "help topic" to get help on a particular topic.

END
  my $setprec = << 'END';
Type "setprec j" to retain "j" decimal places in the result.

END

  my $hypot = << 'END';
hypot: returns the hypotenuse associated with the sides of a right triangle

 SYNOPSIS:

 # double x, y, z, hypot();

 $z = hypot( $x, $y );


 DESCRIPTION:

 Calculates the hypotenuse associated with the sides of a 
 right triangle, according to

	z = sqrt( x**2 + y**2)

END

  my $unity = << 'END';
unity:  Relative error approximations for function arguments near unity.

 SYNOPSIS:

#    log1p(x) = log(1+x)
	
 $y = log1p( $x );

#    expm1(x) = exp(x) - 1

 $y = expm1( $x );

#    cosm1(x) = cos(x) - 1

 $y = cosm1( $x );

END
  my $cmplx = << 'END';

 SYNOPSIS:

 # typedef struct {
 #     double r;     real part
 #     double i;     imaginary part
 #    }cmplx;

 # cmplx *a, *b, *c;

 $x = cmplx(3, 5);   # x = 3 + 5 i
 $y = cmplx(2, 3);   # y = 2 + 3 i

 $z = $x->cadd( $y );  #   z = x + y
 $z = $x->csub( $y );  #   z = x - y
 $z = $x->cmul( $y );  #   z = x * y
 $z = $x->cdiv( $y );  #   z = x / y
 $z = $y->cneg;        #   z = -y
 $z = $y->cmov;        #   z = y

 print $z->{r}, \'  \', $z->{i};   # prints real and imaginary parts of $z
 print $z->as_string;                 # prints $z as Re(z) + i Im(z)

 DESCRIPTION:

 Addition:
    c.r  =  b.r + a.r
    c.i  =  b.i + a.i

 Subtraction:
    c.r  =  b.r - a.r
    c.i  =  b.i - a.i

 Multiplication:
    c.r  =  b.r * a.r  -  b.i * a.i
    c.i  =  b.r * a.i  +  b.i * a.r

 Division:
    d    =  a.r * a.r  +  a.i * a.i
    c.r  = (b.r * a.r  + b.i * a.i)/d
    c.i  = (b.i * a.r  -  b.r * a.i)/d

END

  my $euclid = << 'END';
Rational arithmetic routines

 SYNOPSIS:

 # typedef struct
 #     {
 #     double n;  numerator
 #     double d;  denominator
 #     }fract;

 $x = fract(3, 4);	 #  x = 3 / 4
 $y = fract(2, 3);       #  y = 2 / 3
 $z = $x->radd( $y );    #  z = x + y
 $z = $x->rsub( $y );    #  z = x - y 
 $z = $x->rmul( $y );    #  z = x * y
 $z = $x->rdiv( $y );    #  z = x / y
 print $z->{n}, ' ', $z->{d};  # prints numerator and denominator of $z
 print $z->as_string;         # prints the fraction $z
 print $z->as_mixed_string;   # converts $z to a mixed fraction, then prints it
 
 $m = 60;
 $n = 144;
 ($gcd, $m_reduced, $n_reduced) = euclid($m, $n); 
 # returns the greatest common divisor of $m and $n, as well as
 # the result of reducing $m and $n by $gcd

 Arguments of the routines are pointers to the structures.
 The double precision numbers are assumed, without checking,
 to be integer valued.  Overflow conditions are reported.

END

  %topics = ( 'help' => $help,
	      'setprec' => $setprec,
	      'cmplx' => $cmplx,
	      'cadd' => $cmplx,
	      'cdiv' => $cmplx,
	      'cmul' => $cmplx,
	      'csub' => $cmplx,
	      'cneg' => $cmplx,
	      'cmov' => $cmplx,
	      'radd' => $euclid,
	      'rmul' => $euclid,
	      'rdiv' => $euclid,
	      'rsub' => $euclid,
	      'fract' => $euclid,
	      'euclid' => $euclid,
	      'unity' => $unity,
	      'cosm1' => $unity,
	      'log1p' => $unity,
	      'expm1' => $unity,
	      'hypot' => $hypot,
	      'radian' => 'radian: Degrees, minutes, seconds to radians

 SYNOPSIS:

 # double d, m, s, radian();

 $r = radian( $d, $m, $s );

DESCRIPTION:

 Converts an angle of degrees, minutes, seconds to radians.

 ',

          'igamc' => 'igamc:  Complemented incomplete gamma integral

SYNOPSIS:

 # double a, x, y, igamc();

 $y = igamc( $a, $x );

 DESCRIPTION:

 The function is defined by

  igamc(a,x)   =   1 - igam(a,x)

                            inf.
                              -
                     1       | |  -t  a-1
               =   -----     |   e   t   dt.
                    -      | |
                   | (a)    -
                             x

 In this implementation both arguments must be positive.
 The integral is evaluated by either a power series or
 continued fraction expansion, depending on the relative
 values of a and x.

 ',
          'lgam' => 'lgam:  Natural logarithm of gamma function

SYNOPSIS:

 # double x, y, lgam();
 # extern int sgngam;

 $y = lgam( $x );

DESCRIPTION:

 Returns the base e (2.718...) logarithm of the absolute
 value of the gamma function of the argument.
 The sign (+1 or -1) of the gamma function is returned in a
 global (extern) variable named sgngam.

 For arguments greater than 13, the logarithm of the gamma
 function is approximated by the logarithmic version of
 Stirling\'s formula using a polynomial approximation of
 degree 4. Arguments between -33 and +33 are reduced by
 recurrence to the interval [2,3] of a rational approximation.
 The cosecant reflection formula is employed for arguments
 less than -33.

 Arguments greater than MAXLGM return MAXNUM and an error
 message.  MAXLGM = 2.035093e36 for DEC
 arithmetic or 2.556348e305 for IEEE arithmetic.

',
          'nbdtri' => 'nbdtri:  Functional inverse of negative binomial distribution

SYNOPSIS:

 # int k, n;
 # double p, y, nbdtri();

 $p = nbdtri( $k, $n, $y );

 DESCRIPTION:

 Finds the argument p such that nbdtr(k,n,p) is equal to y.

 ',
          'yn' => 'yn:  Bessel function of second kind of integer order

SYNOPSIS:

 # double x, y, yn();
 # int n;

 $y = yn( $n, $x );

DESCRIPTION:

 Returns Bessel function of order n, where n is a
 (possibly negative) integer.

 The function is evaluated by forward recurrence on
 n, starting with values computed by the routines
 y0() and y1().

 If n = 0 or 1 the routine for y0 or y1 is called
 directly.

',
          'igami' => 'igami:  Inverse of complemented imcomplete gamma integral

SYNOPSIS:

 # double a, x, p, igami();

 $x = igami( $a, $p );

 DESCRIPTION:

 Given p, the function finds x such that

  igamc( a, x ) = p.

 Starting with the approximate value

         3
  x = a t

  where

  t = 1 - d - ndtri(p) sqrt(d)
 
 and

  d = 1/9a,

 the routine performs up to 10 Newton iterations to find the
 root of igamc(a,x) - p = 0.

 ',
          'catan' => 'catan:  Complex circular arc tangent

SYNOPSIS:

 # void catan();
 # cmplx z, w;

 $z = cmplx(2, 3);    # $z = 2 + 3 i
 $w = $z->catan;
 print $w->{r}, \'  \', $w->{i};  # prints real and imaginary parts of $w
 print $w->as_string;                 # prints $w as Re(w) + i Im(w)

 DESCRIPTION:

 If
     z = x + iy,

 then
          1       (    2x     )
 Re w  =  - arctan(-----------)  +  k PI
          2       (     2    2)
                  (1 - x  - y )

               ( 2         2)
          1    (x  +  (y+1) )
 Im w  =  - log(------------)
          4    ( 2         2)
               (x  +  (y-1) )

 Where k is an arbitrary integer.

',
          'atanh' => 'atanh:  Inverse hyperbolic tangent

SYNOPSIS:

 # double x, y, atanh();

 $y = atanh( $x );

DESCRIPTION:

 Returns inverse hyperbolic tangent of argument in the range
 MINLOG to MAXLOG.

 If |x| < 0.5, the rational form x + x**3 P(x)/Q(x) is
 employed.  Otherwise,
        atanh(x) = 0.5 * log( (1+x)/(1-x) ).

',
          'yv' => 'yv:  Bessel function Yv with noninteger v

SYNOPSIS:

 # double v, x;

 # double yv( v, x );

 $y = yv( $v, $x );

 ',
          'cexp' => 'cexp:  Complex exponential function

SYNOPSIS:

 # void cexp();
 # cmplx z, w;

 $z = cmplx(2, 3);    # $z = 2 + 3 i
 $w = $z->cexp;
 print $w->{r}, \'  \', $w->{i};  # prints real and imaginary parts of $w
 print $w->as_string;                 # prints $w as Re(w) + i Im(w)

 DESCRIPTION:

 Returns the exponential of the complex argument z
 into the complex result w.

 If
     z = x + iy,
     r = exp(x),

 then

     w = r cos y + i r sin y.

 ',
          'ellpe' => 'ellpe:  Complete elliptic integral of the second kind

SYNOPSIS:

 # double m1, y, ellpe();

 $y = ellpe( $m1 );

DESCRIPTION:

 Approximates the integral

            pi/2
             -
            | |                 2
 E(m)  =    |    sqrt( 1 - m sin t ) dt
          | |    
           -
            0

 Where m = 1 - m1, using the approximation

      P(x)  -  x log x Q(x).

 Though there are no singularities, the argument m1 is used
 rather than m for compatibility with ellpk().

 E(1) = 1; E(0) = pi/2.

 ',
          'chdtr' => 'chdtr:  Chi-square distribution

SYNOPSIS:

 # double v, x, y, chdtr();

 $y = chdtr( $v, $x );

DESCRIPTION:

 Returns the area under the left hand tail (from 0 to x)
 of the Chi square probability density function with
 v degrees of freedom.

                                  inf.
                                    -
                        1          | |  v/2-1  -t/2
  P( x | v )   =   -----------     |   t      e     dt
                    v/2  -       | |
                   2    | (v/2)   -
                                   x

 where x is the Chi-square variable.

 The incomplete gamma integral is used, according to the
 formula

	y = chdtr( v, x ) = igam( v/2.0, x/2.0 ).

 The arguments must both be positive.

',
          'zetac' => 'zetac:  Riemann zeta function

SYNOPSIS:

 # double x, y, zetac();

 $y = zetac( $x );

DESCRIPTION:

               inf.
                 -    -x
   zetac(x)  =   >   k   ,   x > 1,
                 -
                k=2

 is related to the Riemann zeta function by

	Riemann zeta(x) = zetac(x) + 1.

 Extension of the function definition for x < 1 is implemented.
 Zero is returned for x > log2(MAXNUM).

 An overflow error may occur for large negative x, due to the
 gamma function in the reflection formula.

 ',
          'ellpj' => 'ellpj:  Jacobian Elliptic Functions

SYNOPSIS:

 # double u, m, sn, cn, dn, phi;
 # int ellpj();

 ($flag, $sn, $cn, $dn, $phi) = ellpj( $u, $m );

DESCRIPTION:

 Evaluates the Jacobian elliptic functions sn(u|m), cn(u|m),
 and dn(u|m) of parameter m between 0 and 1, and real
 argument u.

 These functions are periodic, with quarter-period on the
 real axis equal to the complete elliptic integral
 ellpk(1.0-m).

 Relation to incomplete elliptic integral:
 If u = ellik(phi,m), then sn(u|m) = sin(phi),
 and cn(u|m) = cos(phi).  Phi is called the amplitude of u.

 Computation is by means of the arithmetic-geometric mean
 algorithm, except when m is within 1e-9 of 0 or 1.  In the
 latter case with m close to 1, the approximation applies
 only for phi < pi/2.

 ',
          'jn' => 'jn:  Bessel function of integer order

SYNOPSIS:

 # int n;
 # double x, y, jn();

 $y = jn( $n, $x );

DESCRIPTION:

 Returns Bessel function of order n, where n is a
 (possibly negative) integer.

 The ratio of jn(x) to j0(x) is computed by backward
 recurrence.  First the ratio jn/jn-1 is found by a
 continued fraction expansion.  Then the recurrence
 relating successive orders is applied until j0 or j1 is
 reached.

 If n = 0 or 1 the routine for j0 or j1 is called
 directly.

',
          'ellpk' => 'ellpk:  Complete elliptic integral of the first kind

 SYNOPSIS:

 # double m1, y, ellpk();

 $y = ellpk( $m1 );

 DESCRIPTION:

 Approximates the integral

            pi/2
             -
            | |
            |           dt
 K(m)  =    |    ------------------
            |                   2
          | |    sqrt( 1 - m sin t )
           -
            0

 where m = 1 - m1, using the approximation

     P(x)  -  log x Q(x).

 The argument m1 is used rather than m so that the logarithmic
 singularity at m = 1 will be shifted to the origin; this
 preserves maximum accuracy.

 K(0) = pi/2.

 ',
          'chdtrc' => 'chdtrc:  Complemented Chi-square distribution

SYNOPSIS:

 # double v, x, y, chdtrc();

 $y = chdtrc( $v, $x );

DESCRIPTION:

 Returns the area under the right hand tail (from x to
 infinity) of the Chi square probability density function
 with v degrees of freedom:

                                  inf.
                                    -
                        1          | |  v/2-1  -t/2
  P( x | v )   =   -----------     |   t      e     dt
                    v/2  -       | |
                   2    | (v/2)   -
                                   x

 where x is the Chi-square variable.

 The incomplete gamma integral is used, according to the
 formula

	y = chdtrc( v, x ) = igamc( v/2.0, x/2.0 ).

 The arguments must both be positive.

',
          'beta' => 'beta:  Beta function

SYNOPSIS:

 # double a, b, y, beta();

 $y = beta( $a, $b );

DESCRIPTION:

                   -     -
                  | (a) | (b)
 beta( a, b )  =  -----------.
                     -
                    | (a+b)

 For large arguments the logarithm of the function is
 evaluated using lgam(), then exponentiated.

',
          'ceil' => 'ceil:  ceil

 ceil() returns the smallest integer greater than or equal
 to x.  It truncates toward plus infinity.

 SYNOPSIS:

 # double x, y, ceil();

 $y = ceil( $x );


',
          'spence' => 'spence:  Dilogarithm

SYNOPSIS:

 # double x, y, spence();

 $y = spence( $x );

DESCRIPTION:

 Computes the integral

                    x
                    -
                   | | log t
 spence(x)  =  -   |   ----- dt
                 | |   t - 1
                  -
                  1

 for x >= 0.  A rational approximation gives the integral in
 the interval (0.5, 1.5).  Transformation formulas for 1/x
 and 1-x are employed outside the basic expansion range.

',
          'chdtri' => 'chdtri:  Inverse of complemented Chi-square distribution

SYNOPSIS:

 # double df, x, y, chdtri();

 $x = chdtri( $df, $y );

 DESCRIPTION:

 Finds the Chi-square argument x such that the integral
 from x to infinity of the Chi-square density is equal
 to the given cumulative probability y.

 This is accomplished using the inverse gamma integral
 function and the relation

    x/2 = igami( df/2, y );


',
          'jv' => 'jv:  Bessel function of noninteger order

SYNOPSIS:

 # double v, x, y, jv();

 $y = jv( $v, $x );

DESCRIPTION:

 Returns Bessel function of order v of the argument,
 where v is real.  Negative x is allowed if v is an integer.

 Several expansions are included: the ascending power
 series, the Hankel expansion, and two transitional
 expansions for large v.  If v is not too large, it
 is reduced by recurrence to a region of best accuracy.
 The transitional expansions give 12D accuracy for v > 500.

',
          'btdtr' => 'btdtr:  Beta distribution

SYNOPSIS:

 # double a, b, x, y, btdtr();

 $y = btdtr( $a, $b, $x );

DESCRIPTION:

 Returns the area from zero to x under the beta density
 function:

                          x
            -             -
           | (a+b)       | |  a-1      b-1
 P(x)  =  ----------     |   t    (1-t)    dt
           -     -     | |
          | (a) | (b)   -
                         0

 This function is identical to the incomplete beta
 integral function incbet(a, b, x).

 The complemented function is

 1 - P(1-x)  =  incbet( b, a, x );

 ',
          'log' => 'log:  Natural logarithm

SYNOPSIS:

 # double x, y, log();

 $y = log( $x );

DESCRIPTION:

 Returns the base e (2.718...) logarithm of x.

 The argument is separated into its exponent and fractional
 parts.  If the exponent is between -1 and +1, the logarithm
 of the fraction is approximated by

     log(1+x) = x - 0.5 x**2 + x**3 P(x)/Q(x).

 Otherwise, setting  z = 2(x-1)/x+1),
 
     log(x) = z + z**3 P(z)/Q(z).

',
          'log10' => 'log10:  Common logarithm

SYNOPSIS:

 # double x, y, log10();

 $y = log10( $x );

DESCRIPTION:

 Returns logarithm to the base 10 of x.

 The argument is separated into its exponent and fractional
 parts.  The logarithm of the fraction is approximated by

     log(1+x) = x - 0.5 x**2 + x**3 P(x)/Q(x).

',
          'atan' => 'atan:  Inverse circular tangent (arctangent)

SYNOPSIS:

 # double x, y, atan();

 $y = atan( $x );

DESCRIPTION:

 Returns radian angle between -pi/2 and +pi/2 whose tangent
 is x.

 Range reduction is from three intervals into the interval
 from zero to 0.66.  The approximant uses a rational
 function of degree 4/5 of the form x + x**3 P(x)/Q(x).

',
          'frexp' => 'frexp:  frexp

 frexp() extracts the exponent from x.  It returns an integer
 power of two to expnt and the significand between 0.5 and 1
 to y.  Thus  x = y * 2**expn.

 SYNOPSIS:

 # double x, y, frexp();
 # int expnt;

 ($y, $expnt)  = frexp( $x );


',
          'sin' => 'sin:  Circular sine

SYNOPSIS:

 # double x, y, sin();

 $y = sin( $x );

DESCRIPTION:

 Range reduction is into intervals of pi/4.  The reduction
 error is nearly eliminated by contriving an extended precision
 modular arithmetic.

 Two polynomial approximating functions are employed.
 Between 0 and pi/4 the sine is approximated by
      x  +  x**3 P(x**2).
 Between pi/4 and pi/2 the cosine is represented as
      1  -  x**2 Q(x**2).

 ',
          'tanh' => 'tanh:  Hyperbolic tangent

SYNOPSIS:

 # double x, y, tanh();

 $y = tanh( $x );

DESCRIPTION:

 Returns hyperbolic tangent of argument in the range MINLOG to
 MAXLOG.

 A rational function is used for |x| < 0.625.  The form
 x + x**3 P(x)/Q(x) of Cody _& Waite is employed.
 Otherwise,
    tanh(x) = sinh(x)/cosh(x) = 1  -  2/(exp(2x) + 1).

',
          'ellie' => 'ellie:  Incomplete elliptic integral of the second kind

SYNOPSIS:

 # double phi, m, y, ellie();

 $y = ellie( $phi, $m );

DESCRIPTION:

 Approximates the integral

                phi
                 -
                | |
                |                   2
 E(phi_\\m)  =    |    sqrt( 1 - m sin t ) dt
                |
              | |    
               -
                0

 of amplitude phi and modulus m, using the arithmetic -
 geometric mean algorithm.

',
          'ellik' => 'ellik:  Incomplete elliptic integral of the first kind

SYNOPSIS:

 # double phi, m, y, ellik();

 $y = ellik( $phi, $m );

DESCRIPTION:

 Approximates the integral

               phi
                 -
                | |
                |           dt
 F(phi_\\m)  =    |    ------------------
                |                   2
              | |    sqrt( 1 - m sin t )
               -
                0

 of amplitude phi and modulus m, using the arithmetic -
 geometric mean algorithm.


',
          'mtherr' => 'mtherr:  Library common error handling routine

SYNOPSIS:

 char *fctnam;
 # int code;
 # int mtherr();

 mtherr( $fctnam, $code );

DESCRIPTION:

 This routine may be called to report one of the following
 error conditions (in the include file mconf.h).
  
   Mnemonic        Value          Significance

    DOMAIN            1       argument domain error
    SING              2       function singularity
    OVERFLOW          3       overflow range error
    UNDERFLOW         4       underflow range error
    TLOSS             5       total loss of precision
    PLOSS             6       partial loss of precision
    EDOM             33       Unix domain error code
    ERANGE           34       Unix range error code

 The default version of the file prints the function name,
 passed to it by the pointer fctnam, followed by the
 error condition.  The display is directed to the standard
 output device.  The routine then returns to the calling
 program.  Users may wish to modify the program to abort by
 calling exit() under severe error conditions such as domain
 errors.

 Since all error conditions pass control to this function,
 the display may be easily changed, eliminated, or directed
 to an error logging device.

 SEE ALSO:

 mconf.h




',
          'zeta' => 'zeta:  Riemann zeta function of two arguments

SYNOPSIS:

 # double x, q, y, zeta();

 $y = zeta( $x, $q );

DESCRIPTION:

                inf.
                  -        -x
   zeta(x,q)  =   >   (k+q)  
                  -
                 k=0

 where x > 1 and q is not a negative integer or zero.
 The Euler-Maclaurin summation formula is used to obtain
 the expansion

                n         
                -       -x
 zeta(x,q)  =   >  (k+q)  
                -         
               k=1        

           1-x                 inf.  B   x(x+1)...(x+2j)
      (n+q)           1         -     2j
  +  ---------  -  -------  +   >    --------------------
        x-1              x      -                   x+2j+1
                   2(n+q)      j=1       (2j)! (n+q)

 where the B2j are Bernoulli numbers.  Note that (see zetac.c)
 zeta(x,1) = zetac(x) + 1.

',
          'pow' => 'pow:  Power function

SYNOPSIS:

 # double x, y, z, pow();

 $z = pow( $x, $y );

DESCRIPTION:

 Computes x raised to the yth power.  Analytically,

      x**y  =  exp( y log(x) ).

 Following Cody and Waite, this program uses a lookup table
 of 2**-i/16 and pseudo extended precision arithmetic to
 obtain an extra three bits of accuracy in both the logarithm
 and the exponential.

',
          'kn' => 'kn:  Modified Bessel function, third kind, integer order

SYNOPSIS:

 # double x, y, kn();
 # int n;

 $y = kn( $n, $x );

DESCRIPTION:

 Returns modified Bessel function of the third kind
 of order n of the argument.

 The range is partitioned into the two intervals [0,9.55] and
 (9.55, infinity).  An ascending power series is used in the
 low range, and an asymptotic expansion in the high range.

',
          'cabs' => 'cabs:  Complex absolute value

SYNOPSIS:

 # double r, cabs();
 # cmplx z;

 $z = cmplx(2, 3);    # z = 2 + 3 i
 $r = $z->cabs;

 DESCRIPTION:

 If z = x + iy

 then

       r = sqrt( x**2 + y**2 ).
 
 Overflow and underflow are avoided by testing the magnitudes
 of x and y before squaring.  If either is outside half of
 the floating point full scale range, both are rescaled.

 ',
          'stdtri' => 'stdtri:  Functional inverse of Student\'s t distribution

SYNOPSIS:

 # double p, t, stdtri();
 # int k;

 $t = stdtri( $k, $p );

 DESCRIPTION:

 Given probability p, finds the argument t such that stdtr(k,t)
 is equal to p.
 
 ',
          'pdtr' => 'pdtr:  Poisson distribution

SYNOPSIS:

 # int k;
 # double m, y, pdtr();

 $y = pdtr( $k, $m );

DESCRIPTION:

 Returns the sum of the first k terms of the Poisson
 distribution:

   k         j
   --   -m  m
   >   e    --
   --       j!
  j=0

 The terms are not summed directly; instead the incomplete
 gamma integral is employed, according to the relation

 y = pdtr( k, m ) = igamc( k+1, m ).

 The arguments must both be positive.

',
          'i0e' => 'i0e:  Modified Bessel function of order zero, exponentially scaled

SYNOPSIS:

 # double x, y, i0e();

 $y = i0e( $x );

DESCRIPTION:

 Returns exponentially scaled modified Bessel function
 of order zero of the argument.

 The function is defined as i0e(x) = exp(-|x|) j0( ix ).

',
          'floor' => 'floor:  floor

 floor() returns the largest integer less than or equal to x.
 It truncates toward minus infinity.

 SYNOPSIS:

 # double x, y, floor();

 $y = floor( $x );


',
          'struve' => 'struve:  Struve function

SYNOPSIS:

 # double v, x, y, struve();

 $y = struve( $v, $x );

DESCRIPTION:

 Computes the Struve function Hv(x) of order v, argument x.
 Negative x is rejected unless v is an integer.

 ',
	  'plancki' => 'plancki: Integral of Planck black body radiation formula
SYNOPSIS:

 # double lambda, T, y, plancki()

 $y = plancki( $lambda, $T );

DESCRIPTION:

 Evaluates the definite integral, from wavelength 0 to lambda,
 of the Planck radiation formula
                       -5
             c1  lambda
      E =  ------------------
             c2/(lambda T)
            e             - 1
 
 Physical constants c1 = 3.7417749e-16 and c2 = 0.01438769 are built in
 to the function program.  They are scaled to provide a result
 in watts per square meter.  Argument T represents temperature in degrees
 Kelvin; lambda is wavelength in meters.
',
	  'polylog' => 'polylog: polylogarithm function
SYNOPSIS:

 # double x, y, polylog();
 # int n;

     $y = polylog( $n, $x );

 The polylogarithm of order n is defined by the series

               inf   k
                -   x
   Li (x)  =    >   ---  .
     n          -     n
               k=1   k
 
   For x = 1,
 
                inf
                 -    1
    Li (1)  =    >   ---   =  Riemann zeta function (n)  .
      n          -     n
                k=1   k
 
  When n = 2, the function is the dilogarithm, related to the Spence integral:
 
                  x                      1-x
                  -                        -
                 | |  -ln(1-t)            | |  ln t
    Li (x)  =    |    -------- dt    =    |    ------ dt    =   spence(1-x) .
      2        | |       t              | |    1 - t
                -                        -
                 0                        1
',
	  'bernum' => 'bernum: Bernoulli numbers

SYNOPSIS:

    ($num, $den) = bernum( $n);
    ($num_array, $den_array) = bernum();

DESCRIPTION:

 This calculates the Bernoulli numbers, up to 30th order.
 If called with an integer argument, the numerator and denominator
 of that Bernoulli number is returned; if called with no argument,
 two array references representing the numerator and denominators
 of the first 30 Bernoulli numbers are returned.
',
          'csqrt' => 'csqrt:  Complex square root

SYNOPSIS:

 # void csqrt();
 # cmplx z, w;

 $z = cmplx(2, 3);    # $z = 2 + 3 i
 $w = $z->csqrt;
 print $w->{r}, \'  \', $w->{i};  # prints real and imaginary parts of $w
 print $w->as_string;                 # prints $w as Re(w) + i Im(w)

DESCRIPTION:

 If z = x + iy,  r = |z|, then

                       1/2
 Im w  =  [ (r - x)/2 ]   ,

 Re w  =  y / 2 Im w.

 Note that -w is also a square root of z.  The root chosen
 is always in the upper half plane.

 Because of the potential for cancellation error in r - x,
 the result is sharpened by doing a Heron iteration
 (see sqrt.c) in complex arithmetic.

',
          'exp10' => 'exp10:  Base 10 exponential function (Common antilogarithm)

SYNOPSIS:

 # double x, y, exp10();

 $y = exp10( $x );

DESCRIPTION:

 Returns 10 raised to the x power.

 Range reduction is accomplished by expressing the argument
 as 10**x = 2**n 10**f, with |f| < 0.5 log10(2).
 The Pade\' form

    1 + 2x P(x**2)/( Q(x**2) - P(x**2) )

 is used to approximate 10**f.

',
          'gdtrc' => 'gdtrc:  Complemented gamma distribution function

SYNOPSIS:

 # double a, b, x, y, gdtrc();

 $y = gdtrc( $a, $b, $x );

DESCRIPTION:

 Returns the integral from x to infinity of the gamma
 probability density function:

               inf.
        b       -
       a       | |   b-1  -at
 y =  -----    |    t    e    dt
       -     | |
      | (b)   -
               x

  The incomplete gamma integral is used, according to the
 relation

 y = igamc( b, ax ).

 ',
          'incbet' => 'incbet:  Incomplete beta integral

 SYNOPSIS:

 # double a, b, x, y, incbet();

 $y = incbet( $a, $b, $x );

 DESCRIPTION:

 Returns incomplete beta integral of the arguments, evaluated
 from zero to x.  The function is defined as

                  x
     -            -
    | (a+b)      | |  a-1     b-1
  -----------    |   t   (1-t)   dt.
   -     -     | |
  | (a) | (b)   -
                 0

 The domain of definition is 0 <= x <= 1.  In this
 implementation a and b are restricted to positive values.
 The integral from x to 1 may be obtained by the symmetry
 relation

    1 - incbet( a, b, x )  =  incbet( b, a, 1-x ).

 The integral is evaluated by a continued fraction expansion
 or, when b*x is small, by a power series.

 ',
          'nbdtr' => 'nbdtr:  Negative binomial distribution

SYNOPSIS:

 # int k, n;
 # double p, y, nbdtr();

 $y = nbdtr( $k, $n, $p );

 DESCRIPTION:

 Returns the sum of the terms 0 through k of the negative
 binomial distribution:

   k
   --  ( n+j-1 )   n      j
   >   (       )  p  (1-p)
   --  (   j   )
  j=0

 In a sequence of Bernoulli trials, this is the probability
 that k or fewer failures precede the nth success.

 The terms are not computed individually; instead the incomplete
 beta integral is employed, according to the formula

 y = nbdtr( k, n, p ) = incbet( n, k+1, p ).

 The arguments must be positive, with p ranging from 0 to 1.

 ',
          'fabs' => 'fabs:  	Absolute value

SYNOPSIS:

 # double x, y;

 $y = fabs( $x );

DESCRIPTION:
 
 Returns the absolute value of the argument.



',
          'powi' => 'powi:  Real raised to integer power

SYNOPSIS:

 # double x, y, powi();
 # int n;

 $y = powi( $x, $n );

DESCRIPTION:

 Returns argument x raised to the nth power.
 The routine efficiently decomposes n as a sum of powers of
 two. The desired power is a product of two-to-the-kth
 powers of x.  Thus to compute the 32767 power of x requires
 28 multiplications instead of 32767 multiplications.

',
          'i1e' => 'i1e:  Modified Bessel function of order one, exponentially scaled

SYNOPSIS:

 # double x, y, i1e();

 $y = i1e( $x );

DESCRIPTION:

 Returns exponentially scaled modified Bessel function
 of order one of the argument.

 The function is defined as i1(x) = -i exp(-|x|) j1( ix ).

',
          'exp2' => 'exp2:  Base 2 exponential function

SYNOPSIS:

 # double x, y, exp2();

 $y = exp2( $x );

DESCRIPTION:

 Returns 2 raised to the x power.

 Range reduction is accomplished by separating the argument
 into an integer k and fraction f such that
     x    k  f
    2  = 2  2.

 A Pade\' form

   1 + 2x P(x**2) / (Q(x**2) - x P(x**2) )

 approximates 2**x in the basic range [-0.5, 0.5].

 ',

	  'expxx' => 'expxx: exp(x*x)

 # double x, y, expxx();
 # int sign;
 
   $y = expxx( $x );

 DESCRIPTION:
 
  Computes y = exp(x*x) while suppressing error amplification
  that would ordinarily arise from the inexactness of the
  exponential argument x*x.

  If sign < 0, exp(-x*x) is returned.
  If sign > 0, or omitted, exp(x*x) is returned.
',    
          'tan' => 'tan:  Circular tangent

SYNOPSIS:

 # double x, y, tan();

 $y = tan( $x );

DESCRIPTION:

 Returns the circular tangent of the radian argument x.

 Range reduction is modulo pi/4.  A rational function
       x + x**3 P(x**2)/Q(x**2)
 is employed in the basic interval [0, pi/4].

',
          'sici' => 'sici:  Sine and cosine integrals

SYNOPSIS:

 # double x, Ci, Si, sici();

 ($flag, $Si, $Ci) = sici( $x );

 DESCRIPTION:

 Evaluates the integrals

                          x
                          -
                         |  cos t - 1
   Ci(x) = eul + ln x +  |  --------- dt,
                         |      t
                        -
                         0
             x
             -
            |  sin t
   Si(x) =  |  ----- dt
            |    t
           -
            0

 where eul = 0.57721566490153286061 is Euler\'s constant.
 The integrals are approximated by rational functions.
 For x > 8 auxiliary functions f(x) and g(x) are employed
 such that

 Ci(x) = f(x) sin(x) - g(x) cos(x)
 Si(x) = pi/2 - f(x) cos(x) - g(x) sin(x)

 ',
          'ccos' => 'ccos:  Complex circular cosine

SYNOPSIS:

 # void ccos();
 # cmplx z, w;

 $z = cmplx(2, 3);    # $z = 2 + 3 i
 $w = $z->ccos;
 print $w->{r}, \'  \', $w->{i};  # prints real and imaginary parts of $w
 print $w->as_string;                 # prints $w as Re(w) + i Im(w)

 DESCRIPTION:

 If
     z = x + iy,

 then

     w = cos x  cosh y  -  i sin x sinh y.

',
          'ccot' => 'ccot:  Complex circular cotangent

SYNOPSIS:

 # void ccot();
 # cmplx z, w;

 $z = cmplx(2, 3);    # $z = 2 + 3 i
 $w = $z->ccot;
 print $w->{r}, \'  \', $w->{i};  # prints real and imaginary parts of $w
 print $w->as_string;                 # prints $w as Re(w) + i Im(w)

 DESCRIPTION:

 If
     z = x + iy,

 then

           sin 2x  -  i sinh 2y
     w  =  --------------------.
            cosh 2y  -  cos 2x

 On the real axis, the denominator has zeros at even
 multiples of PI/2.  Near these points it is evaluated
 by a Taylor series.

 ',
          'sqrt' => 'sqrt:  Square root

SYNOPSIS:

 # double x, y, sqrt();

 $y = sqrt( $x );

DESCRIPTION:

 Returns the square root of x.

 Range reduction involves isolating the power of two of the
 argument and using a polynomial approximation to obtain
 a rough value for the square root.  Then Heron\'s iteration
 is used three times to converge to an accurate value.

',
          'tandg' => 'tandg:  Circular tangent of argument in degrees

SYNOPSIS:

 # double x, y, tandg();

 $y = tandg( $x );

DESCRIPTION:

 Returns the circular tangent of the argument x in degrees.

 Range reduction is modulo pi/4.  A rational function
       x + x**3 P(x**2)/Q(x**2)
 is employed in the basic interval [0, pi/4].

',
          'cosdg' => 'cosdg:  Circular cosine of angle in degrees

SYNOPSIS:

 # double x, y, cosdg();

 $y = cosdg( $x );

DESCRIPTION:

 Range reduction is into intervals of 45 degrees.

 Two polynomial approximating functions are employed.
 Between 0 and pi/4 the cosine is approximated by
      1  -  x**2 P(x**2).
 Between pi/4 and pi/2 the sine is represented as
      x  +  x**3 P(x**2).

 ',
          'fdtr' => 'fdtr:  F distribution

SYNOPSIS:

 # int df1, df2;
 # double x, y, fdtr();

 $y = fdtr( $df1, $df2, $x );

 DESCRIPTION:

 Returns the area from zero to x under the F density
 function (also known as Snedcor\'s density or the
 variance ratio density).  This is the density
 of x = (u1/df1)/(u2/df2), where u1 and u2 are random
 variables having Chi square distributions with df1
 and df2 degrees of freedom, respectively.

 The incomplete beta integral is used, according to the
 formula

	P(x) = incbet( df1/2, df2/2, df1*x/(df2 + df1*x) ).

 The arguments a and b are greater than zero, and x is
 nonnegative.

 ',
          'rgamma' => 'rgamma:  Reciprocal gamma function

SYNOPSIS:

 # double x, y, rgamma();

 $y = rgamma( $x );

DESCRIPTION:

 Returns one divided by the gamma function of the argument.

 The function is approximated by a Chebyshev expansion in
 the interval [0,1].  Range reduction is by recurrence
 for arguments between -34.034 and +34.84425627277176174.
 1/MAXNUM is returned for positive arguments outside this
 range.  For arguments less than -34.034 the cosecant
 reflection formula is applied; lograrithms are employed
 to avoid unnecessary overflow.

 The reciprocal gamma function has no singularities,
 but overflow and underflow may occur for large arguments.
 These conditions return either MAXNUM or 1/MAXNUM with
 appropriate sign.

 ',
          'shichi' => 'shichi:  Hyperbolic sine and cosine integrals

SYNOPSIS:

 # double x, Chi, Shi, shichi();

 ($flag, $Shi, $Chi) = shichi( $x );

 DESCRIPTION:

 Approximates the integrals

                            x
                            -
                           | |   cosh t - 1
   Chi(x) = eul + ln x +   |    -----------  dt,
                         | |          t
                          -
                          0

               x
               -
              | |  sinh t
   Shi(x) =   |    ------  dt
            | |       t
             -
             0

 where eul = 0.57721566490153286061 is Euler\'s constant.
 The integrals are evaluated by power series for x < 8
 and by Chebyshev expansions for x between 8 and 88.
 For large x, both functions approach exp(x)/2x.
 Arguments greater than 88 in magnitude return MAXNUM.

 ',
          'ndtr' => 'ndtr:  Normal distribution function

SYNOPSIS:

 # double x, y, ndtr();

 $y = ndtr( $x );

DESCRIPTION:

 Returns the area under the Gaussian probability density
 function, integrated from minus infinity to x:

                            x
                             -
                   1        | |          2
    ndtr(x)  = ---------    |    exp( - t /2 ) dt
               sqrt(2pi)  | |
                           -
                          -inf.

             =  ( 1 + erf(z) ) / 2
 
 where z = x/sqrt(2). Computation is via the functions
 erf and erfc.

 ',
          'lbeta' => 'lbeta:  Natural logarithm of |beta|

SYNOPSIS:

 # double a, b;

 # double lbeta( a, b );

 $y = lbeta( $a, $b);


',
          'cacos' => 'cacos:  Complex circular arc cosine

SYNOPSIS:

 # void cacos();
 # cmplx z, w;

 $z = cmplx(2, 3);    # $z = 2 + 3 i
 $w = $z->cacos;
 print $w->{r}, \'  \', $w->{i};  # prints real and imaginary parts of $w
 print $w->as_string;                 # prints $w as Re(w) + i Im(w)

 DESCRIPTION:

 w = arccos z  =  PI/2 - arcsin z.


',
          'cbrt' => 'cbrt:  Cube root

SYNOPSIS:

 # double x, y, cbrt();

 $y = cbrt( $x );

DESCRIPTION:

 Returns the cube root of the argument, which may be negative.

 Range reduction involves determining the power of 2 of
 the argument.  A polynomial of degree 2 applied to the
 mantissa, and multiplication by the cube root of 1, 2, or 4
 approximates the root to within about 0.1%.  Then Newton\'s
 iteration is used three times to converge to an accurate
 result.

',
          'exp' => 'exp:  Exponential function

 SYNOPSIS:

 # double x, y, exp();

 $y = exp( $x );

 DESCRIPTION:

 Returns e (2.71828...) raised to the x power.

 Range reduction is accomplished by separating the argument
 into an integer k and fraction f such that

     x    k  f
    e  = 2  e.

 A Pade\' form  1 + 2x P(x**2)/( Q(x**2) - P(x**2) )
 of degree 2/3 is used to approximate exp(f) in the basic
 interval [-0.5, 0.5].

 ',
          'threef0' => 'threef0:  Hypergeometric function 3F0

SYNOPSIS:

 # double a, b, c, x, value;

 # double *err;

 ($value, $err) = threef0( $a, $b, $c, $x )

 ',
          'hyperg' => 'hyperg:  Confluent hypergeometric function

SYNOPSIS:

 # double a, b, x, y, hyperg();

 $y = hyperg( $a, $b, $x );

DESCRIPTION:

 Computes the confluent hypergeometric function

                          1           2
                       a x    a(a+1) x
   F ( a,b;x )  =  1 + ---- + --------- + ...
  1 1                  b 1!   b(b+1) 2!

 Many higher transcendental functions are special cases of
 this power series.

 As is evident from the formula, b must not be a negative
 integer or zero unless a is an integer with 0 >= a > b.

 The routine attempts both a direct summation of the series
 and an asymptotic expansion.  In each case error due to
 roundoff, cancellation, and nonconvergence is estimated.
 The result with smaller estimated error is returned.

',
          'log2' => 'log2:  Base 2 logarithm

SYNOPSIS:

 # double x, y, log2();

 $y = log2( $x );

DESCRIPTION:

 Returns the base 2 logarithm of x.

 The argument is separated into its exponent and fractional
 parts.  If the exponent is between -1 and +1, the base e
 logarithm of the fraction is approximated by

     log(1+x) = x - 0.5 x**2 + x**3 P(x)/Q(x).

 Otherwise, setting  z = 2(x-1)/x+1),
 
     log(x) = z + z**3 P(z)/Q(z).

',
          'airy' => 'airy:  Airy function

SYNOPSIS:

 # double x, ai, aiprime, bi, biprime;
 # int airy();

 ($flag, $ai, $aiprime, $bi, $biprime) = airy( $x );

DESCRIPTION:

 Solution of the differential equation

	y"(x) = xy.

 The function returns the two independent solutions Ai, Bi
 and their first derivatives Ai\'(x), Bi\'(x).

 Evaluation is by power series summation for small x,
 by rational minimax approximations for large x.

',
          'onef2' => 'onef2:  Hypergeometric function 1F2

SYNOPSIS:

 # double a, b, c, x, value;

 # double *err;

 ($value, $err) = onef2( $a, $b, $c, $x)

 ',
	  'ei' => 'ei: Exponential integral
 
 
  SYNOPSIS:
 
  #double x, y, ei();
 
  $y = ei( $x );
 
 
 
  DESCRIPTION:
 
                x
                 -     t
                | |   e
     Ei(x) =   -|-   ---  dt .
              | |     t
               -
              -inf
  
  Not defined for x <= 0.
  See also expn.c.

',
          'expn' => 'expn:  	Exponential integral En

SYNOPSIS:

 # int n;
 # double x, y, expn();

 $y = expn( $n, $x );

DESCRIPTION:

 Evaluates the exponential integral

                 inf.
                   -
                  | |   -xt
                  |    e
      E (x)  =    |    ----  dt.
       n          |      n
                | |     t
                 -
                  1

 Both n and x must be nonnegative.

 The routine employs either a power series, a continued
 fraction, or an asymptotic formula depending on the
 relative values of n and x.

 ',
          'dawsn' => 'dawsn:  Dawson\'s Integral

SYNOPSIS:

 # double x, y, dawsn();

 $y = dawsn( $x );

DESCRIPTION:

 Approximates the integral

                             x
                             -
                      2     | |        2
  dawsn(x)  =  exp( -x  )   |    exp( t  ) dt
                          | |
                           -
                           0

 Three different rational approximations are employed, for
 the intervals 0 to 3.25; 3.25 to 6.25; and 6.25 up.

 ',
          'clog' => 'clog:  Complex natural logarithm

SYNOPSIS:

 # void clog();
 # cmplx z, w;

 $z = cmplx(2, 3);    # $z = 2 + 3 i
 $w = $z->clog;
 print $w->{r}, \'  \', $w->{i};  # prints real and imaginary parts of $w
 print $w->as_string;                 # prints $w as Re(w) + i Im(w)

 DESCRIPTION:

 Returns complex logarithm to the base e (2.718...) of
 the complex argument x.

 If z = x + iy, r = sqrt( x**2 + y**2 ),
 then
       w = log(r) + i arctan(y/x).
 
 The arctangent ranges from -PI to +PI.

 ',
          'acos' => 'acos:  Inverse circular cosine

SYNOPSIS:

 # double x, y, acos();

 $y = acos( $x );

DESCRIPTION:

 Returns radian angle between 0 and pi whose cosine
 is x.

 Analytically, acos(x) = pi/2 - asin(x).  However if |x| is
 near 1, there is cancellation error in subtracting asin(x)
 from pi/2.  Hence if x < -0.5,

    acos(x) =	 pi - 2.0 * asin( sqrt((1+x)/2) );

 or if x > +0.5,

    acos(x) =	 2.0 * asin(  sqrt((1-x)/2) ).

 ',
          'fresnl' => 'fresnl:  Fresnel integral

SYNOPSIS:

 # double x, S, C;
 # void fresnl();

 ($flag, $S, $C) = fresnl( $x );

 DESCRIPTION:

 Evaluates the Fresnel integrals

           x
           -
          | |
 C(x) =   |   cos(pi/2 t**2) dt,
        | |
         -
          0

           x
           -
          | |
 S(x) =   |   sin(pi/2 t**2) dt.
        | |
         -
          0

 The integrals are evaluated by a power series for x < 1.
 For x >= 1 auxiliary functions f(x) and g(x) are employed
 such that

 C(x) = 0.5 + f(x) sin( pi/2 x**2 ) - g(x) cos( pi/2 x**2 )
 S(x) = 0.5 - f(x) cos( pi/2 x**2 ) - g(x) sin( pi/2 x**2 )

',
          'psi' => 'psi:  Psi (digamma) function

 SYNOPSIS:

 # double x, y, psi();

 $y = psi( $x );

 DESCRIPTION:

              d      -
   psi(x)  =  -- ln | (x)
              dx

 is the logarithmic derivative of the gamma function.
 For integer x,
                   n-1
                    -
 psi(n) = -EUL  +   >  1/k.
                    -
                   k=1

 This formula is used for 0 < n <= 10.  If x is negative, it
 is transformed to a positive argument by the reflection
 formula  psi(1-x) = psi(x) + pi cot(pi x).
 For general positive x, the argument is made greater than 10
 using the recurrence  psi(x+1) = psi(x) + 1/x.
 Then the following asymptotic expansion is applied:

                           inf.   B
                            -      2k
 psi(x) = log(x) - 1/2x -   >   -------
                            -        2k
                           k=1   2k x

 where the B2k are Bernoulli numbers.

 ',
'csinh' => 'csinh: Complex hyperbolic sine
 
 
  SYNOPSIS:
 
  # void csinh();
  # cmplx z, w;
 
 $z = cmplx(2, 3);    # z = 2 + 3 i
 $w = $z->csinh;
 print $w->{r}, "  ", $w->{i};  # prints real and imaginary parts of $w
 print $w->as_string;                 # prints $w as Re(w) + i Im(w)

 
  DESCRIPTION:
 
  csinh z = (cexp(z) - cexp(-z))/2
          = sinh x * cos y  +  i cosh x * sin y .
 
',
	     'casinh' => 'casinh: Complex inverse hyperbolic sine
 
 
  SYNOPSIS:
 
  # void casinh();
  # cmplx z, w;
 
 $z = cmplx(2, 3);    # $z = 2 + 3 i
 $w = $z->casinh;
 print $w->{r}, "  ", $w->{i};  # prints real and imaginary parts of $w
 print $w->as_string;                 # prints $w as Re(w) + i Im(w) 
 
  DESCRIPTION:
 
  casinh z = -i casin iz .
 
', 
	     'ccosh' => 'ccosh: Complex hyperbolic cosine
 
 
  SYNOPSIS:
 
  # void ccosh();
  # cmplx z, w;
  
 $z = cmplx(2, 3);    # $z = 2 + 3 i
 $w = $z->ccosh;
 print $w->{r}, "  ", $w->{i};  # prints real and imaginary parts of $w
 print $w->as_string;                 # prints $w as Re(w) + i Im(w)
 
  DESCRIPTION:
 
  ccosh(z) = cosh x  cos y + i sinh x sin y .
 
',
	     'cacosh' => 'cacosh: Complex inverse hyperbolic cosine
 
 
  SYNOPSIS:
 
  # void cacosh();
  # cmplx z, w;
 
 $z = cmplx(2, 3);    # $z = 2 + 3 i
 $w = $z->cacosh;
 print $w->{r}, "  ", $w->{i};  # prints real and imaginary parts of $w 
 print $w->as_string;                 # prints $w as Re(w) + i Im(w)
 
  DESCRIPTION:
 
  acosh z = i acos z .
 
',
	      'ctanh' => 'ctanh: Complex hyperbolic tangent

 SYNOPSIS:

 # void ctanh();
 # cmplx z, w;

 $z = cmplx(2, 3);    # $z = 2 + 3 i
 $w = $z->ctanh;
 print $w->{r}, "  ", $w->{i};  # prints real and imaginary parts of $w  
 print $w->as_string;                 # prints $w as Re(w) + i Im(w)

 DESCRIPTION:

 tanh z = (sinh 2x  +  i sin 2y) / (cosh 2x + cos 2y) .
',
	     'catanh' => 'catanh: Complex inverse hyperbolic tangent
  
  SYNOPSIS:
 
  # void catanh();
  # cmplx z, w;
 
 $z = cmplx(2, 3);    # $z = 2 + 3 i
 $w = $z->catanh;
 print $w->{r}, "  ", $w->{i};  # prints real and imaginary parts of $w  
 print $w->as_string;                 # prints $w as Re(w) + i Im(w)
 
  DESCRIPTION:
 
  Inverse tanh, equal to  -i catan (iz);
 
',
	     'cpow' => 'cpow: Complex power function 
 
  SYNOPSIS:
 
  # void cpow();
  # cmplx x, z, w;
 
 $x = cmplx(5, 6);    # x = 5 + 6 i
 $z = cmplx(2, 3);    # z = 2 + 3 i
 $w = $x->cpow($z);
 print $w->{r}, "  ", $w->{i};  # prints real and imaginary parts of $w  
 print $w->as_string;                 # prints $w as Re(w) + i Im(w)
 
  DESCRIPTION:
 
  Raises complex X to the complex Zth power.
  Definition is per AMS55 # 4.2.8,
  analytically equivalent to cpow(x,z) = cexp(z clog(x)).
 
',
          'csin' => 'csin:  Complex circular sine

SYNOPSIS:

 # void csin();
 # cmplx z, w;

 $z = cmplx(2, 3);    # $z = 2 + 3 i
 $w = $z->csin;
 print $w->{r}, \'  \', $w->{i};  # prints real and imaginary parts of $w
 print $w->as_string;                 # prints $w as Re(w) + i Im(w)

 DESCRIPTION:

 If
     z = x + iy,

 then

     w = sin x  cosh y  +  i cos x sinh y.

',
          'stdtr' => 'stdtr:  Student\'s t distribution

SYNOPSIS:

 # double t, stdtr();
 short k;

 $y = stdtr( $k, $t );

 DESCRIPTION:

 Computes the integral from minus infinity to t of the Student
 t distribution with integer k > 0 degrees of freedom:

                                      t
                                      -
                                     | |
              -                      |         2   -(k+1)/2
             | ( (k+1)/2 )           |  (     x   )
       ----------------------        |  ( 1 + --- )        dx
                     -               |  (      k  )
       sqrt( k pi ) | ( k/2 )        |
                                   | |
                                    -
                                   -inf.
 
 Relation to incomplete beta integral:

        1 - stdtr(k,t) = 0.5 * incbet( k/2, 1/2, z )
 where
        z = k/(k + t**2).

 For t < -2, this is the method of computation.  For higher t,
 a direct method is derived from integration by parts.
 Since the function is symmetric about t=0, the area under the
 right tail of the density is found by calling the function
 with -t instead of t.
 
 ',
          'cotdg' => 'cotdg:  Circular cotangent of argument in degrees

SYNOPSIS:

 # double x, y, cotdg();

 $y = cotdg( $x );

DESCRIPTION:

 Returns the circular cotangent of the argument x in degrees.

 Range reduction is modulo pi/4.  A rational function
       x + x**3 P(x**2)/Q(x**2)
 is employed in the basic interval [0, pi/4].

 ERROR MESSAGES:

   message         condition          value returned
 cotdg total loss   x > 8.0e14 (DEC)      0.0
                    x > 1.0e14 (IEEE)
 cotdg singularity  x = 180 k            MAXNUM


',
          'asinh' => 'asinh:  Inverse hyperbolic sine

SYNOPSIS:

 # double x, y, asinh();

 $y = asinh( $x );

DESCRIPTION:

 Returns inverse hyperbolic sine of argument.

 If |x| < 0.5, the function is approximated by a rational
 form  x + x**3 P(x)/Q(x).  Otherwise,

     asinh(x) = log( x + sqrt(1 + x*x) ).

',
          'i0' => 'i0:  Modified Bessel function of order zero

SYNOPSIS:

 # double x, y, i0();

 $y = i0( $x );

DESCRIPTION:

 Returns modified Bessel function of order zero of the
 argument.

 The function is defined as i0(x) = j0( ix ).

 The range is partitioned into the two intervals [0,8] and
 (8, infinity).  Chebyshev polynomial expansions are employed
 in each interval.

',
          'i1' => 'i1:  Modified Bessel function of order one

SYNOPSIS:

 # double x, y, i1();

 $y = i1( $x );

DESCRIPTION:

 Returns modified Bessel function of order one of the
 argument.

 The function is defined as i1(x) = -i j1( ix ).

 The range is partitioned into the two intervals [0,8] and
 (8, infinity).  Chebyshev polynomial expansions are employed
 in each interval.

',
          'constants' => 'constants:  various useful constants

 SYNOPSIS

  $PI      :   3.14159265358979323846      #  pi
  $PIO2    :   1.57079632679489661923      #  pi/2
  $PIO4    :   0.785398163397448309616     #  pi/4
  $SQRT2   :   1.41421356237309504880      #  sqrt(2)
  $SQRTH   :   0.707106781186547524401     #  sqrt(2)/2
  $LOG2E   :   1.4426950408889634073599    #  1/log(2)
  $SQ2OPI  :   0.79788456080286535587989   #  sqrt( 2/pi )
  $LOGE2   :   0.693147180559945309417     #  log(2)
  $LOGSQ2  :   0.346573590279972654709     #  log(2)/2
  $THPIO4  :   2.35619449019234492885      #  3*pi/4
  $TWOOPI  :   0.636619772367581343075535  #  2/pi

  As well, there are 4 machine-specific numbers available:

   $MACHEP : machine roundoff error
   $MAXLOG : maximum log on the machine
   $MINLOG : minimum log on the machine
   $MAXNUM : largest number represented

',
          'erf' => 'erf:  Error function

SYNOPSIS:

 # double x, y, erf();

 $y = erf( $x );

DESCRIPTION:

 The integral is

                           x 
                            -
                 2         | |          2
   erf(x)  =  --------     |    exp( - t  ) dt.
              sqrt(pi)   | |
                          -
                           0

 The magnitude of x is limited to 9.231948545 for DEC
 arithmetic; 1 or -1 is returned outside this range.

 For 0 <= |x| < 1, erf(x) = x * P4(x**2)/Q5(x**2); otherwise
 erf(x) = 1 - erfc(x).

',
          'k0e' => 'k0e:  Modified Bessel function, third kind, order zero, exponentially scaled

SYNOPSIS:

 # double x, y, k0e();

 $y = k0e( $x );

DESCRIPTION:

 Returns exponentially scaled modified Bessel function
 of the third kind of order zero of the argument.

      k0e(x) = exp(x) * k0(x).

',
          'erfc' => 'erfc:  Complementary error function

SYNOPSIS:

 # double x, y, erfc();

 $y = erfc( $x );

DESCRIPTION:

  1 - erf(x) =

                           inf. 
                             -
                  2         | |          2
   erfc(x)  =  --------     |    exp( - t  ) dt
               sqrt(pi)   | |
                           -
                            x

 For small x, erfc(x) = 1 - erf(x); otherwise rational
 approximations are computed.

',
          'gamma' => 'gamma:  Gamma function

SYNOPSIS:

 # double x, y, gamma();
 # extern int sgngam;

 $y = gamma( $x );

DESCRIPTION:

 Returns gamma function of the argument.  The result is
 correctly signed, and the sign (+1 or -1) is also
 returned in a global (extern) variable named sgngam.
 This variable is also filled in by the logarithmic gamma
 function lgam().

 Arguments |x| <= 34 are reduced by recurrence and the function
 approximated by a rational function of degree 6/7 in the
 interval (2,3).  Large arguments are handled by Stirling\'s
 formula. Large negative arguments are made positive using
 a reflection formula.  

 ',
          'incbi' => 'incbi:  Inverse of imcomplete beta integral

SYNOPSIS:

 # double a, b, x, y, incbi();

 $x = incbi( $a, $b, $y );

DESCRIPTION:

 Given y, the function finds x such that

  incbet( a, b, x ) = y .

 The routine performs interval halving or Newton iterations to find the
 root of incbet(a,b,x) - y = 0.

 ',
          'round' => 'round:  Round double to nearest or even integer valued double

SYNOPSIS:

 # double x, y, round();

 $y = round( $x );

DESCRIPTION:

 Returns the nearest integer to x as a double precision
 floating point result.  If x ends in 0.5 exactly, the
 nearest even integer is chosen.
 

 ',
          'drand' => 'drand:  Pseudorandom number generator

SYNOPSIS:

 # double y, drand();

 ($flag, $y) = drand( );

DESCRIPTION:

 Yields a random number 1.0 <= y < 2.0.

 The three-generator congruential algorithm by Brian
 Wichmann and David Hill (BYTE magazine, March, 1987,
 pp 127-8) is used. The period, given by them, is
 6953607871644.

 Versions invoked by the different arithmetic compile
 time options DEC, IBMPC, and MIEEE, produce
 approximately the same sequences, differing only in the
 least significant bits of the numbers. The UNK option
 implements the algorithm as recommended in the BYTE
 article.  It may be used on all computers. However,
 the low order bits of a double precision number may
 not be adequately random, and may vary due to arithmetic
 implementation details on different computers.

 The other compile options generate an additional random
 integer that overwrites the low order bits of the double
 precision number.  This reduces the period by a factor of
 two but tends to overcome the problems mentioned.



',
          'y0' => 'y0:  Bessel function of the second kind, order zero

SYNOPSIS:

 # double x, y, y0();

 $y = y0( $x );

DESCRIPTION:

 Returns Bessel function of the second kind, of order
 zero, of the argument.

 The domain is divided into the intervals [0, 5] and
 (5, infinity). In the first interval a rational approximation
 R(x) is employed to compute
   y0(x)  = R(x)  +   2 * log(x) * j0(x) / PI.
 Thus a call to j0() is required.

 In the second interval, the Hankel asymptotic expansion
 is employed with two rational functions of degree 6/6
 and 7/7.

',
          'fac' => 'fac:  Factorial function

SYNOPSIS:

 # double y, fac();
 # int i;

 $y = fac( $i );

DESCRIPTION:

 Returns factorial of i  =  1 * 2 * 3 * ... * i.
 fac(0) = 1.0.

 Due to machine arithmetic bounds the largest value of
 i accepted is 33 in DEC arithmetic or 170 in IEEE
 arithmetic.  Greater values, or negative ones,
 produce an error message and return MAXNUM.

',
          'y1' => 'y1:  Bessel function of second kind of order one

SYNOPSIS:

 # double x, y, y1();

 $y = y1( $x );

DESCRIPTION:

 Returns Bessel function of the second kind of order one
 of the argument.

 The domain is divided into the intervals [0, 8] and
 (8, infinity). In the first interval a 25 term Chebyshev
 expansion is used, and a call to j1() is required.
 In the second, the asymptotic trigonometric representation
 is employed using two rational functions of degree 5/5.

',
          'casin' => 'casin:  Complex circular arc sine

SYNOPSIS:

 # void casin();
 # cmplx z, w;

 $z = cmplx(2, 3);    # $z = 2 + 3 i
 $w = $z->casin;
 print $w->{r}, \'  \', $w->{i};  # prints real and imaginary parts of $w
 print $w->as_string;                 # prints $w as Re(w) + i Im(w)

 DESCRIPTION:

 Inverse complex sine:

                               2
 w = -i clog( iz + csqrt( 1 - z ) ).

 ',
          'acosh' => 'acosh:  Inverse hyperbolic cosine

 SYNOPSIS:

 # double x, y, acosh();

 $y = acosh( $x );

DESCRIPTION:

 Returns inverse hyperbolic cosine of argument.

 If 1 <= x < 1.5, a rational approximation

	sqrt(z) * P(z)/Q(z)

 where z = x-1, is used.  Otherwise,

 acosh(x)  =  log( x + sqrt( (x-1)(x+1) ).

',
          'bdtrc' => 'bdtrc:  Complemented binomial distribution

SYNOPSIS:

 # int k, n;
 # double p, y, bdtrc();

 $y = bdtrc( $k, $n, $p );

 DESCRIPTION:

 Returns the sum of the terms k+1 through n of the Binomial
 probability density:

   n
   --  ( n )   j      n-j
   >   (   )  p  (1-p)
   --  ( j )
  j=k+1

 The terms are not summed directly; instead the incomplete
 beta integral is employed, according to the formula

 y = bdtrc( k, n, p ) = incbet( k+1, n-k, p ).

 The arguments must be positive, with p ranging from 0 to 1.

 ',
          'gdtr' => 'gdtr:  Gamma distribution function

SYNOPSIS:

 # double a, b, x, y, gdtr();

 $y = gdtr( $a, $b, $x );

DESCRIPTION:

 Returns the integral from zero to x of the gamma probability
 density function:

                x
        b       -
       a       | |   b-1  -at
 y =  -----    |    t    e    dt
       -     | |
      | (b)   -
               0

  The incomplete gamma integral is used, according to the
 relation

 y = igam( b, ax ).

 ',
          'lrand' => 'lrand:  Pseudorandom number generator

SYNOPSIS:

 long y, lrand();

 $y = lrand( );

DESCRIPTION:

 Yields a long integer random number.

 The three-generator congruential algorithm by Brian
 Wichmann and David Hill (BYTE magazine, March, 1987,
 pp 127-8) is used. The period, given by them, is
 6953607871644.




',
          'sinh' => 'sinh:  Hyperbolic sine

SYNOPSIS:

 # double x, y, sinh();

 $y = sinh( $x );

DESCRIPTION:

 Returns hyperbolic sine of argument in the range MINLOG to
 MAXLOG.

 The range is partitioned into two segments.  If |x| <= 1, a
 rational function of the form x + x**3 P(x)/Q(x) is employed.
 Otherwise the calculation is sinh(x) = ( exp(x) - exp(-x) )/2.

',
          'fdtrc' => 'fdtrc:  Complemented F distribution

SYNOPSIS:

 # int df1, df2;
 # double x, y, fdtrc();

 $y = fdtrc( $df1, $df2, $x );

 DESCRIPTION:

 Returns the area from x to infinity under the F density
 function (also known as Snedcor\'s density or the
 variance ratio density).

                      inf.
                       -
              1       | |  a-1      b-1
 1-P(x)  =  ------    |   t    (1-t)    dt
            B(a,b)  | |
                     -
                      x

 The incomplete beta integral is used, according to the
 formula

	P(x) = incbet( df2/2, df1/2, df2/(df2 + df1*x) ).

 ',
          'bdtri' => 'bdtri:  Inverse binomial distribution

SYNOPSIS:

 # int k, n;
 # double p, y, bdtri();

 $p = bdtri( $k, $n, $y );

 DESCRIPTION:

 Finds the event probability p such that the sum of the
 terms 0 through k of the Binomial probability density
 is equal to the given cumulative probability y.

 This is accomplished using the inverse beta integral
 function and the relation

 1 - p = incbi( n-k, k+1, y ).

 ',
          'atan2' => 'atan2:  Quadrant correct inverse circular tangent

SYNOPSIS:

 # double x, y, z, atan2();

 $z = atan2( $y, $x );

DESCRIPTION:

 Returns radian angle whose tangent is y/x.
 Define compile time symbol ANSIC = 1 for ANSI standard,
 range -PI < z <= +PI, args (y,x); else ANSIC = 0 for range
 0 to 2PI, args (x,y).

',
          'lsqrt' => 'lsqrt:  Integer square root

SYNOPSIS:

 long x, y;
 long lsqrt();

 $y = lsqrt( $x );

DESCRIPTION:

 Returns a long integer square root of the long integer
 argument.  The computation is by binary long division.

 The largest possible result is lsqrt(2,147,483,647)
 = 46341.

 If x < 0, the square root of |x| is returned, and an
 error message is printed.

 ',
          'hyp2f0' => 'hyp2f0:  Gauss hypergeometric function   F
	                               		2 0

 SYNOPSIS:

 # double a, b, x, value, *err;
 # int type;	/* determines what converging factor to use */

 ($value, $err) =  hyp2f0( $a, $b, $x, $type )


',
          'fdtri' => 'fdtri:  Inverse of complemented F distribution

SYNOPSIS:

 # int df1, df2;
 # double x, p, fdtri();

 $x = fdtri( $df1, $df2, $p );

 DESCRIPTION:

 Finds the F density argument x such that the integral
 from x to infinity of the F density is equal to the
 given probability p.

 This is accomplished using the inverse beta integral
 function and the relations

      z = incbi( df2/2, df1/2, p )
      x = df2 (1-z) / (df1 z).

 Note: the following relations hold for the inverse of
 the uncomplemented F distribution:

      z = incbi( df1/2, df2/2, p )
      x = df2 z / (df1 (1-z)).

 ',
          'hyp2f1' => 'hyp2f1:  Gauss hypergeometric function   F
	                               		2 1

 SYNOPSIS:

 # double a, b, c, x, y, hyp2f1();

 $y = hyp2f1( $a, $b, $c, $x );

 DESCRIPTION:

  hyp2f1( a, b, c, x )  =   F ( a, b; c; x )
                           2 1

           inf.
            -   a(a+1)...(a+k) b(b+1)...(b+k)   k+1
   =  1 +   >   -----------------------------  x   .
            -         c(c+1)...(c+k) (k+1)!
          k = 0

  Cases addressed are
	Tests and escapes for negative integer a, b, or c
	Linear transformation if c - a or c - b negative integer
	Special case c = a or c = b
	Linear transformation for  x near +1
	Transformation for x < -0.5
	Psi function expansion if x > 0.5 and c - a - b integer
      Conditionally, a recurrence on c to make c-a-b > 0

 |x| > 1 is rejected.

 The parameters a, b, c are considered to be integer
 valued if they are within 1.0e-14 of the nearest integer
 (1.0e-13 for IEEE arithmetic).

 ',
          'j0' => 'j0:  Bessel function of order zero

SYNOPSIS:

 # double x, y, j0();

 $y = j0( $x );

DESCRIPTION:

 Returns Bessel function of order zero of the argument.

 The domain is divided into the intervals [0, 5] and
 (5, infinity). In the first interval the following rational
 approximation is used:

        2         2
 (w - r  ) (w - r  ) P (w) / Q (w)
       1         2    3       8

            2
 where w = x  and the two r\'s are zeros of the function.

 In the second interval, the Hankel asymptotic expansion
 is employed with two rational functions of degree 6/6
 and 7/7.

',
          'j1' => 'j1:  Bessel function of order one

SYNOPSIS:

 # double x, y, j1();

 $y = j1( $x );

DESCRIPTION:

 Returns Bessel function of order one of the argument.

 The domain is divided into the intervals [0, 8] and
 (8, infinity). In the first interval a 24 term Chebyshev
 expansion is used. In the second, the asymptotic
 trigonometric representation is employed using two
 rational functions of degree 5/5.

',
          'ldexp' => 'ldexp:  multiplies x by 2**n.

 SYNOPSIS:

 # double x, y, ldexp();
 # int n;

 $y = ldexp( $x, $n );


',
          'pdtrc' => 'pdtrc:  Complemented poisson distribution

SYNOPSIS:

 # int k;
 # double m, y, pdtrc();

 $y = pdtrc( $k, $m );

DESCRIPTION:

 Returns the sum of the terms k+1 to infinity of the Poisson
 distribution:

  inf.       j
   --   -m  m
   >   e    --
   --       j!
  j=k+1

 The terms are not summed directly; instead the incomplete
 gamma integral is employed, according to the formula

 y = pdtrc( k, m ) = igam( k+1, m ).

 The arguments must both be positive.

',
          'igam' => 'igam:  Incomplete gamma integral

SYNOPSIS:

 # double a, x, y, igam();

 $y = igam( $a, $x );

 DESCRIPTION:

 The function is defined by

                           x
                            -
                   1       | |  -t  a-1
  igam(a,x)  =   -----     |   e   t   dt.
                  -      | |
                 | (a)    -
                           0

 In this implementation both arguments must be positive.
 The integral is evaluated by either a power series or
 continued fraction expansion, depending on the relative
 values of a and x.

 ',
          'machconst' => 'machconst:  Globally declared constants

SYNOPSIS:

 extern double nameofconstant;

 DESCRIPTION:

 This file contains a number of mathematical constants and
 also some needed size parameters of the computer arithmetic.
 The values are supplied as arrays of hexadecimal integers
 for IEEE arithmetic; arrays of octal constants for DEC
 arithmetic; and in a normal decimal scientific notation for
 other machines.  The particular notation used is determined
 by a symbol (DEC, IBMPC, or UNK) defined in the include file
 mconf.h.

 The default size parameters are as follows.

 For DEC and UNK modes:
 MACHEP =  1.38777878078144567553E-17       2**-56
 MAXLOG =  8.8029691931113054295988E1       log(2**127)
 MINLOG = -8.872283911167299960540E1        log(2**-128)
 MAXNUM =  1.701411834604692317316873e38    2**127

 For IEEE arithmetic (IBMPC):
 MACHEP =  1.11022302462515654042E-16       2**-53
 MAXLOG =  7.09782712893383996843E2         log(2**1024)
 MINLOG = -7.08396418532264106224E2         log(2**-1022)
 MAXNUM =  1.7976931348623158E308           2**1024

 These lists are subject to change.


',
          'k1e' => 'k1e:  Modified Bessel function, third kind, order one, exponentially scaled

SYNOPSIS:

 # double x, y, k1e();

 $y = k1e( $x );

DESCRIPTION:

 Returns exponentially scaled modified Bessel function
 of the third kind of order one of the argument:

      k1e(x) = exp(x) * k1(x).

',
          'ndtri' => 'ndtri:  Inverse of Normal distribution function

SYNOPSIS:

 # double x, y, ndtri();

 $x = ndtri( $y );

DESCRIPTION:

 Returns the argument, x, for which the area under the
 Gaussian probability density function (integrated from
 minus infinity to x) is equal to y.

 For small arguments 0 < y < exp(-2), the program computes
 z = sqrt( -2.0 * log(y) );  then the approximation is
 x = z - log(z)/z  - (1/z) P(1/z) / Q(1/z).
 There are two rational functions P/Q, one for 0 < y < exp(-32)
 and the other for y up to exp(-2).  For larger arguments,
 w = y - 0.5, and  x/sqrt(2pi) = w + w**3 R(w**2)/S(w**2)).

 ',
          'pdtri' => 'pdtri:  Inverse Poisson distribution

SYNOPSIS:

 # int k;
 # double m, y, pdtr();

 $m = pdtri( $k, $y );


DESCRIPTION:

 Finds the Poisson variable x such that the integral
 from 0 to x of the Poisson density is equal to the
 given probability y.

 This is accomplished using the inverse gamma integral
 function and the relation

    m = igami( k+1, y ).


',
          'cos' => 'cos:  Circular cosine

SYNOPSIS:

 # double x, y, cos();

 $y = cos( $x );

DESCRIPTION:

 Range reduction is into intervals of pi/4.  The reduction
 error is nearly eliminated by contriving an extended precision
 modular arithmetic.

 Two polynomial approximating functions are employed.
 Between 0 and pi/4 the cosine is approximated by
      1  -  x**2 Q(x**2).
 Between pi/4 and pi/2 the sine is represented as
      x  +  x**3 P(x**2).

 ',
          'ctan' => 'ctan:  Complex circular tangent

SYNOPSIS:

 # void ctan();
 # cmplx z, w;

 $z = cmplx(2, 3);    # $z = 2 + 3 i
 $w = $z->ctan;
 print $w->{r}, \'  \', $w->{i};  # prints real and imaginary parts of $w
 print $w->as_string;                 # prints $w as Re(w) + i Im(w)

 DESCRIPTION:

 If
     z = x + iy,

 then

           sin 2x  +  i sinh 2y
     w  =  --------------------.
            cos 2x  +  cosh 2y

 On the real axis the denominator is zero at odd multiples
 of PI/2.  The denominator is evaluated by its Taylor
 series near these points.

 ',
          'cot' => 'cot:  Circular cotangent

SYNOPSIS:

 # double x, y, cot();

 $y = cot( $x );

DESCRIPTION:

 Returns the circular cotangent of the radian argument x.

 Range reduction is modulo pi/4.  A rational function
       x + x**3 P(x**2)/Q(x**2)
 is employed in the basic interval [0, pi/4].

',
          'asin' => 'asin:  Inverse circular sine

SYNOPSIS:

 # double x, y, asin();

 $y = asin( $x );

DESCRIPTION:

 Returns radian angle between -pi/2 and +pi/2 whose sine is x.

 A rational function of the form x + x**3 P(x**2)/Q(x**2)
 is used for |x| in the interval [0, 0.5].  If |x| > 0.5 it is
 transformed by the identity

    asin(x) = pi/2 - 2 asin( sqrt( (1-x)/2 ) ).

 ',
          'bdtr' => 'bdtr:  Binomial distribution

SYNOPSIS:

 # int k, n;
 # double p, y, bdtr();

 $y = bdtr( $k, $n, $p );

DESCRIPTION:

 Returns the sum of the terms 0 through k of the Binomial
 probability density:

   k
   --  ( n )   j      n-j
   >   (   )  p  (1-p)
   --  ( j )
  j=0

 The terms are not summed directly; instead the incomplete
 beta integral is employed, according to the formula

 $y = bdtr( k, n, p ) = incbet( n-k, k+1, 1-p ).

 The arguments must be positive, with p ranging from 0 to 1.

 ',
          'cosh' => 'cosh:  Hyperbolic cosine

SYNOPSIS:

 # double x, y, cosh();

 $y = cosh( $x );

DESCRIPTION:

 Returns hyperbolic cosine of argument in the range MINLOG to
 MAXLOG.

 cosh(x)  =  ( exp(x) + exp(-x) )/2.

',
          'sindg' => 'sindg:  Circular sine of angle in degrees

SYNOPSIS:

 # double x, y, sindg();

 $y = sindg( $x );

DESCRIPTION:

 Range reduction is into intervals of 45 degrees.

 Two polynomial approximating functions are employed.
 Between 0 and pi/4 the sine is approximated by
      x  +  x**3 P(x**2).
 Between pi/4 and pi/2 the cosine is represented as
      1  -  x**2 P(x**2).

',
          'k0' => 'k0:  Modified Bessel function, third kind, order zero

SYNOPSIS:

 # double x, y, k0();

 $y = k0( $x );

DESCRIPTION:

 Returns modified Bessel function of the third kind
 of order zero of the argument.

 The range is partitioned into the two intervals [0,8] and
 (8, infinity).  Chebyshev polynomial expansions are employed
 in each interval.

',
          'k1' => 'k1:  Modified Bessel function, third kind, order one

SYNOPSIS:

 # double x, y, k1();

 $y = k1( $x );

DESCRIPTION:

 Computes the modified Bessel function of the third kind
 of order one of the argument.

 The range is partitioned into the two intervals [0,2] and
 (2, infinity).  Chebyshev polynomial expansions are employed
 in each interval.

',
          'nbdtrc' => 'nbdtrc:  Complemented negative binomial distribution

SYNOPSIS:

 # int k, n;
 # double p, y, nbdtrc();

 $y = nbdtrc( $k, $n, $p );

 DESCRIPTION:

 Returns the sum of the terms k+1 to infinity of the negative
 binomial distribution:

   inf
   --  ( n+j-1 )   n      j
   >   (       )  p  (1-p)
   --  (   j   )
  j=k+1

 The terms are not computed individually; instead the incomplete
 beta integral is employed, according to the formula

 y = nbdtrc( k, n, p ) = incbet( k+1, n, 1-p ).

 The arguments must be positive, with p ranging from 0 to 1.

 ',
          'iv' => 'iv:  Modified Bessel function of noninteger order

SYNOPSIS:

 # double v, x, y, iv();

 $y = iv( $v, $x );

DESCRIPTION:

 Returns modified Bessel function of order v of the
 argument.  If x is negative, v must be integer valued.

 The function is defined as Iv(x) = Jv( ix ).  It is
 here computed in terms of the confluent hypergeometric
 function, according to the formula

              v  -x
 Iv(x) = (x/2)  e   hyperg( v+0.5, 2v+1, 2x ) / gamma(v+1)

 If v is a negative integer, then v is replaced by -v.

 '

	    );
}

sub get_descs {
  $topics{'trigs'} = "Help is available on the following functions: \n\n";
  foreach (sort qw(asin acos atan atan2 sin cos tan cot hypot
		   tandg cotdg sindg cosdg radian unity)) {
    (my $desc = $topics{$_}) =~ s!^(.*?\n).*!$1!s;
    $topics{'trigs'} .= $desc;
  }

  $topics{'hypers'} = "Help is available on the following functions: \n\n";
  foreach (sort qw(acosh asinh atanh sinh cosh tanh) ) {
    (my $desc = $topics{$_}) =~ s!^(.*?\n).*!$1!s;
    $topics{'hypers'} .= $desc;  
  }

  $topics{'explog'} = "Help is available on the following functions: \n\n";
  foreach (sort qw(unity exp exp10 exp2 log log10 log2 expxx)) {
    (my $desc = $topics{$_}) =~ s!^(.*?\n).*!$1!s;
    $topics{'explog'} .= $desc;  
  } 

  $topics{'complex'} = "Help is available on the following functions: \n\n";
  foreach (sort qw(clog cexp csin ccos ctan ccot casin cabs csqrt
		   cacos catan cadd csub cmul cdiv cmov cneg cmplx
		   csinh ccosh ctanh cpow casinh cacosh catanh) ) {
    (my $desc = $topics{$_}) =~ s!^(.*?\n).*!$1!s;
    $topics{'complex'} .= $desc unless $desc =~ /^\s*$/;;
  }

  $topics{'utils'} = "Help is available on the following functions: \n\n";
  foreach (sort qw(ceil floor frexp ldexp fabs fac cbrt
		   round sqrt lrand pow powi drand lsqrt ) ) {
    (my $desc = $topics{$_}) =~ s!^(.*?\n).*!$1!s;
    $topics{'utils'} .= $desc;
  }

  $topics{'bessels'} = "Help is available on the following functions: \n\n";
  foreach (sort qw( i0 i0e i1 i1e iv j0 j1 jn jv k0 k1 kn yn 
		    yv k0e k1e y0 y1) ) {
    (my $desc = $topics{$_}) =~ s!^(.*?\n).*!$1!s;
    $topics{'bessels'} .= $desc;
  }

  $topics{'dists'} = "Help is available on the following functions: \n\n";
  foreach (sort qw(bdtr bdtrc bdtri btdtr chdtr chdtrc chdtri 
		   fdtr fdtrc fdtri gdtr gdtrc nbdtr nbdtrc nbdtri 
		   ndtr ndtri pdtr pdtrc pdtri stdtr stdtri) ) {
    (my $desc = $topics{$_}) =~ s!^(.*?\n).*!$1!s;
    $topics{'dists'} .= $desc;
  } 

  $topics{'gammas'} = "Help is available on the following functions: \n\n";
  foreach (sort qw(gamma igam igamc igami psi fac rgamma) ) {
    (my $desc = $topics{$_}) =~ s!^(.*?\n).*!$1!s;
    $topics{'gammas'} .= $desc;
}

  $topics{'betas'} = "Help is available on the following functions: \n\n";
  foreach (sort qw( beta lbeta incbet incbi) ) {
    (my $desc = $topics{$_}) =~ s!^(.*?\n).*!$1!s;
    $topics{'betas'} .= $desc;
  }

  $topics{'elliptics'} = "Help is available on the following functions: \n\n";
  foreach (sort qw(ellie ellik ellpe ellpj ellpk) ) {
    (my $desc = $topics{$_}) =~ s!^(.*?\n).*!$1!s;
    $topics{'elliptics'} .= $desc;
  }
  
  $topics{'hypergeometrics'} = "Help is available on the following functions: \n\n";
  foreach (sort qw(onef2 threef0 hyp2f1 hyperg hyp2f0) ) {
    (my $desc = $topics{$_}) =~ s!^(.*?\n).*!$1!s;
    $topics{'hypergeometrics'} .= $desc;
  }

  $topics{'misc'} = "Help is available on the following functions: \n\n";
  foreach (sort qw(zeta zetac airy dawsn fresnl sici shichi expn 
	      spence ei erfc erf struve plancki polylog bernum) ) {
    (my $desc = $topics{$_}) =~ s!^(.*?\n).*!$1!s;
    $topics{'misc'} .= $desc;
  }


}
sub cpl  {
  my $word = shift;
  my @possibilities;
  if (! $word) {
    @possibilities = qw(constants trigs hypers explog complex utils bessels
			dists gammas betas elliptics hypergeometrics 
			misc frac help setprec);
  }
  else {
    @possibilities = grep /^\Q$word\E/, @topics;
  }
  return @possibilities;
}

sub gnu_cpl {
 my $word = shift;
 my @possibilities = cpl($word);
 $attribs->{completion_word} = \@possibilities;
 return;
}

sub search_pagers {
  push @pagers, $Config{pager};
  if ($^O =~ /Win32/) {
    push @pagers, qw( more less notepad );
    unshift @pagers, $ENV{PAGER}  if $ENV{PAGER};
  } 
  elsif ($^O eq 'VMS') {
    push @pagers, qw( most more less type/page );
  } 
  elsif ($^O eq 'os2') {
    unshift @pagers, 'less', 'cmd /c more <';
  }
  else {
    if ($^O eq 'os2') {
      unshift @pagers, 'less', 'cmd /c more <';
    } 
    push @pagers, qw( more less pg view cat );
    unshift @pagers, $ENV{PAGER}  if $ENV{PAGER};
  }
}

__END__

=head1 NAME

pmath - simple command line interface to Math::Cephes

=head1 SYNOPSIS

  bash> pmath

 Interactive interface to the Math::Cephes module.
 TermReadLine enabled. Type 'help' or '?'  for help.

 pmath> setprec 4
         display set to 4 decimal places
 pmath> cos($PI)
         -1.0000
 pmath> acos(%)
          3.1416
 pmath> q
 bash> 
  

=head1 DESCRIPTION

This script provides a simple command line interface to the
C<Math::Cephes> module. If available, it will use the C<Term::ReadKey> 
and C<Term::ReadLine::Perl> or C<Term::ReadLine::GNU> modules to
provide command line history and word completion.

Typing C<help> or C<?> alone will provide a list of help topics
grouped by major category name. C<help category> will provide 
a listing and short description of each function within the
named category. C<help function> will provide a description and
synopsis of the named function.

Entering an expression that returns a single value, such as 
C<sin($x)>, or one that returns multiple values, such as
C<airy($x)>, will result in all return values being printed.
The last (successful) single value returned is saved as the
C<%> symbol (as in Maple), so that one can do

     pmath> sin($PI/2)
            1
     pmath> asin(%)
            1.570796
     pmath>

The number of decimal places displayed can be set to C<j> using
C<setprec j>:

     pmath> setprec 8
             display set to 8 decimal places
     pmath> $PI
             3.14159265
     pmath>

Multiple statements can be entered on a line, such as
     pmath> $x=1; $y=exp($x); printf("\texp(%5.2f)=%5.2f\n",$x,$y);
             exp( 1.00)= 2.72
     pmath>

or on multiple lines using C<\> as a continuation signal:

    pmath> $x = 1; \
           $y = exp($x); \
            printf("exp(%5.2f)=%5.2f\n", $x, $y);
             exp( 1.00)= 2.72
    pmath>

To quit the program, enter C<q>, C<quit>, or C<exit>.

The C<Math::Cephes> module has some support for handling
fractions and complex numbers through the C<Math::Cephes::Fraction>
and C<Math::Cephes::Complex> modules. For fractions, one can use the
C<fract()> function to create a fraction object, and then use 
these in a fraction routine:

    pmath> $f=fract(1,3); $g=fract(4,3); $f->radd($g);
            5/3
    pmath> mixed(%)
            1 2/3
    pmath>

Similarly, for complex numbers one can use the C<cmplx()>
function to create a complex number object, and then use 
these in a complex number routine:

    pmath> $f=cmplx(1,3); $g=cmplx(4,3); $f->cadd($g);
            5+6 i
    pmath>

See L<Math::Cephes::Polynomial> for an interface to some
polynomial routines, and L<Math::Cephes::Matrix> for some
matrix routines.

=head1 BUGS

Probably. Please report any to Randy Kobes <randy@theoryx5.uwinnipeg.ca>

=head1 SEE ALSO

L<Math::Cephes>, L<Math::Cephes::Fraction>, L<Math::Cephes::Complex>,
L<Math::Cephes::Polynomial> and L<Math::Cephes::Matrix>.

=head1 COPYRIGHT

This script is copyrighted, 2000, 2002, by Randy Kobes. It may be 
distributed under the same terms as Perl itself.

=cut

__END__
:endofperl
