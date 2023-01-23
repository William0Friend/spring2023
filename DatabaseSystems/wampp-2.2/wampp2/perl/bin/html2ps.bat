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
#!perl
#line 15
eval 'exec perl -S $0 "$@"'
  if $running_under_some_shell;

#######################################################################
# Sun Jun  4 00:35:58 IDT 2000
# Comments by Stas Bekman <stas@stason.org>:
# 
# This package was last seen at http://www.tdb.uu.se/~jan/html2ps.html.
# The software wasn't developed anymore, none of my patches were accepted
# therefore I've forked it and add all the patches to this version.
#  
# Currently it's distributed as a component of the bigger package under
# the same license as Perl or GNU GPL, whichever you prefer.
#
# The original header/license is present on the next lines
#######################################################################

#######################################################################

# This is html2ps version 1.0 beta3, an HTML-to-PostScript converter.
#   Copyright (C) 1995-2000 Jan Karrman.
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# Author: Jan Karrman, Dept. of Scientific Computing, Uppsala University,
#         Sweden, e-mail: jan@tdb.uu.se.
#######################################################################


# Set the name of the global configuration file. See the installation notes
# and manual page for more details on configuration files.

#$globrc='/usr/local/lib/html2ps/html2psrc';
use FindBin qw($Bin);
use lib $Bin;

$globrc="$Bin/html2ps-global.conf";
$ug='/usr/local/lib/html2ps/html2ps.html';

$conf=<<'EOR';
@html2ps {
  package {
    PerlMagick: 0;
    ImageMagick: 0;
    pbmplus: 0;
    netpbm: 0;
    djpeg: 0;
    Ghostscript: 0;
    TeX: 0;
    dvips: 0;
    libwww-perl: 0;
    jfriedl: 0;
    geturl: "";
    check: "";
    path: "";
  }
  paper {
    type: A4;
    height: "";
    width: "";
  }
  option {
    twoup: 0;
    base: "";
    check: 0;
    toc: "";
    debug: 0;
    DSC: 0;
    encoding: "ISO-8859-1";
    rcfile: "";
    frame: 0;
    grayscale: 0;
    help: 0;
    hyphenate: 0;
    scaleimage: 1;
    cookie: "";
    language: "";
    landscape: 0;
    scalemath: 1;
    number: 0;
    startno: "";
    output: "";
    original: 0;
    rootdir: "";
    xref: 0;
    scaledoc: 1;
    style: "";
    titlepage: 0;
    text: 0;
    underline: 0;
    colour: 0;
    version: 0;
    web: "";
    duplex: "";
  }
  margin {
    middle: 2cm;
  }
  xref {
    text: "[p $N]";
    passes: 1;
  }
  quote {
    en {
      open: "&ldquo;";
      close: "&rdquo;";
      open2: "`";
      close2: "'";
    }
    sv {
      open: "&rdquo;";
      close: "&rdquo;";
      open2: "'";
      close2: "'";
    }
    da {
      open: "&raquo;";
      close: "&laquo;";
    }
    no {
      open: "&laquo;";
      close: "&raquo;";
    }
    fr {
      open: "&laquo;&nbsp;";
      close: "&nbsp;&raquo;";
    }
    de {
      open: "&bdquo;";
      close: "&ldquo;";
      open2: "&sbquo;";
      close2: "`";
    }
    fi: sv;
    es: en;
    it: no;
    nn: no;
    nb: no;
  }
  toc {
    heading: "<H1>Table of Contents</H1>";
    level: 6;
    indent: 1em;
  }
  titlepage {
    content: "<DIV align=center>
      <H1><BIG>$T</BIG></H1>
      <H2>$[author]</H2></DIV>";
    margin-top: 4cm;
  }
  font {
    times {
      names: "Times-Roman
              Times-Italic
              Times-Bold
              Times-BoldItalic";
    }
    new-century-schoolbook {
      names: "NewCenturySchlbk-Roman
              NewCenturySchlbk-Italic
              NewCenturySchlbk-Bold
              NewCenturySchlbk-BoldItalic";
    }
    helvetica {
      names: "Helvetica
              Helvetica-Oblique
              Helvetica-Bold
              Helvetica-BoldOblique";
    }
    helvetica-narrow {
      names: "Helvetica-Narrow
              Helvetica-Narrow-Oblique
              Helvetica-Narrow-Bold
              Helvetica-Narrow-BoldOblique";
    }
    palatino {
      names: "Palatino-Roman
              Palatino-Italic
              Palatino-Bold
              Palatino-BoldItalic";
    }
    avantgarde {
      names: "AvantGarde-Book
              AvantGarde-BookOblique
              AvantGarde-Demi
              AvantGarde-DemiOblique";
    }
    bookman {
      names: "Bookman-Light
              Bookman-LightItalic
              Bookman-Demi
              Bookman-DemiItalic";
    }
    courier {
      names: "Courier
              Courier-Oblique
              Courier-Bold
              Courier-BoldOblique";
    }
  }
  hyphenation {
    min: 8;
    start: 4;
    end: 3;
    en {
      file: "";
      extfile: "";
    }
  }
  header {
    left: "";
    center: "";
    right: "";
    odd-left: "";
    odd-center: "";
    odd-right: "";
    even-left: "";
    even-center: "";
    even-right: "";
    font-family: Helvetica;
    font-size: 8pt;
    font-style: normal;
    font-weight: normal;
    color: black;
    alternate: 1;
  }
  footer {
    left: "";
    center: "";
    right: "";
    odd-left: "";
    odd-center: "";
    odd-right: "";
    even-left: "";
    even-center: "";
    even-right: "";
    font-family: Helvetica;
    font-size: 8pt;
    font-style: normal;
    font-weight: normal;
    color: black;
    alternate: 1;
  }
  frame {
    width: 0.6pt;
    margin: 0.5cm;
    color: black;
  }
  justify {
    word: 15pt;
    letter: 0pt;
  }
  draft {
    text: DRAFT;
    print: "";
    dir: 0;
    font-family: Helvetica;
    font-style: normal;
    font-weight: bold;
    color: F0F0F0;
  }
  colour {
    black: 000000;
    green: 008000;
    silver: C0C0C0;
    lime: 00FF00;
    gray: 808080;
    olive: 808000;
    white: FFFFFF;
    yellow: FFFF00;
    maroon: 800000;
    navy: 000080;
    red: FF0000;
    blue: 0000FF;
    purple: 800080;
    teal: 008080;
    fuchsia: FF00FF;
    aqua: 00FFFF;
  }
  html2psrc: "$HOME/.html2psrc";
  imgalt: "[IMAGE]";
  datefmt: "%e %b %Y  %R";
  locale: "";
  doc-sep: "<!--NewPage-->";
  ball-radius: 0.25em;
  numbstyle: 0;
  showurl: 0;
  seq-number: 0;
  extrapage: 1;
  break-table: 0;
  forms: 1;
  textarea-data: 0;
  page-break: 1;
  expand-acronyms: 0;
  spoof: "";
  ssi: 1;
  prefilled: 0;
}

BODY {
  font-family: Times;
  font-size: 11pt;
  text-align: left;
  background: white;
}

H1, H2, H3, H4, H5, H6 {
  font-weight: bold;
  margin-top: 0.8em;
  margin-bottom: 0.5em;
}
H1 { font-size: 19pt }
H2 { font-size: 17pt }
H3 { font-size: 15pt }
H4 { font-size: 13pt }
H5 { font-size: 12pt }
H6 { font-size: 11pt }

P, OL, UL, DL, BLOCKQUOTE, PRE {
  margin-top: 1em;
  margin-bottom: 1em;
}

P {
  line-height: 1.2em;
  text-indent: 0;
}

OL, UL, DD { margin-left: 2em }

TT, KBD, PRE { font-family: Courier }

PRE { font-size: 9pt }

BLOCKQUOTE {
  margin-left: 1em;
  margin-right: 1em;
}

ADDRESS {
  margin-top: 0.5em;
  margin-bottom: 0.5em;
}

TABLE {
  margin-top: 1.3em;
  margin-bottom: 1em;
}

DIV.noprint { display: none }

DEL { text-decoration: line-through }

A:link, HR { color: black }

@page {
  margin-left: 2.5cm;
  margin-right: 2.5cm;
  margin-top: 3cm;
  margin-bottom: 3cm;
}

EOR

eval "require POSIX";
$posix = !$@;

%extend=('quote',1, 'font',1, 'colour',1, 'hyphenation',1);
%fal=("serif","times", "sans_serif","helvetica", "monospace","courier");
@fo=("p","pre","h1","h2","h3","h4","h5","h6","i","b","tt","kbd","cite","samp",
 "address","blockquote","ol","ul","dl","dt","dd","table","header","footer");
%quote=('','en');
%valid=('font',1, 'font_files',1, 'margin,left',1, 'margin,right',1,
 'margin,top',1, 'margin,bottom',1);
%cm=('cm',1, 'mm',0.1, 'in',2.54, 'pt',2.54/72, 'pc',2.54/6);
%pt=('cm',72/2.54, 'mm',72/25.4, 'in',72, 'pt',1, 'pc',12);
%space=('thinsp',6, '#8201',6, 'ensp',2, '#8194',2, 'emsp',1, '#8195',1);
$space=join('|',keys %space);
%vars=("T","Ti", "N","Pn", "U","UR", "H","h", "A","Au");
%height=("letter",27.9, "legal",35.6, "arche",121.9, "archd",91.4, "archc",61,
 "archb",45.7, "archa",30.5, "flsa",33, "flse",33, "halfletter",21.6,
 "11x17",43.2, "ledger",27.9);
%width=("letter",21.6, "legal",21.6, "arche",91.4, "archd",61, "archc",45.7,
 "archb",30.5, "archa",22.9, "flsa",21.6, "flse",21.6, "halfletter",14,
 "11x17",27.9, "ledger",43.2);

$version="html2ps version 1.0 beta3";
$opts="2|b:|c|C:|d|D|e:|f:|F|g|h|H|i:|k:|l:|L|m:|n|N:|o:|O|r:|R|s:|S:|t|T|u|"
 ."U|v|W:|x:";
%optalias=( 'twoup','2', 'base','b', 'check','c', 'toc','C', 'debug','d',
 'DSC','D', 'encoding','e', 'rcfile','f', 'frame','F', 'grayscale','g',
 'help','h', 'hyphenate','H', 'scaleimage','i', 'cookie','k', 'language','l',
 'landscape','L', 'scalemath','m', 'number','n', 'startno','N', 'output','o',
 'original','O', 'rootdir','r', 'xref','R', 'scaledoc','s', 'style','S',
 'titlepage','t', 'text','T', 'underline','u', 'colour','U', 'version','v',
 'web','W', 'duplex','x');
%type=( 'paper,height',2, 'paper,width',2, 'option,i',3, 'option,m',3,
 'option,N',4, 'option,s',3, 'option,x',4, 'xref,passes',4, 'draft,print',5);

$usage=<<EOU;
Usage:
 html2ps [-2cdDFghHLnORtTuUv] [-b URL] [-C string] [-e encoding]
  [-f file[:file[:...]]] [-i num] [-k file] [-l lang] [-m num] [-N num]
  [-o file] [-r path] [-s num] [-S string] [-W string] [-x num]
  [file|URL [file|URL [...]]]

EOU

$usage.="The html2ps users guide is available as $ug\n\n" if(-r $ug);

$args="@ARGV";
&Getopts($opts) || die $usage;

if($opt_d) {
  open(DBG,">html2ps.dbg") || die "Error opening debug file: html2ps.dbg\n";
  print STDERR "***** Writing debug info to html2ps.dbg\n";
  print DBG "***** $version\n***** Command: $0 $args\n***** Perl: $]\n";
  print DBG "***** HTML2PSPATH=$ENV{'HTML2PSPATH'}\n";
}
undef $/;
$user=0;
$V='(-?\d+\.?\d*|-?\d*\.?\d+)';
&getconf($conf);
&pagedef;
undef %AT_page;
for(@fo,"draft") {
  eval "\$deffnt{'$_'}=defined \$$_\{'font-family'\}?"
      ."\$$_\{'font-family'\}:\$body{'font-family'}";
}
$user=1;
if(open(RC,$globrc)) {
  $conf=<RC>;
  print DBG "***** Global file $globrc:\n$conf" if($opt_d);
  &getconf($conf);
  close RC;
} else {
# stas: temporarily commented out, since I don't know where this file
# will be installed on user's system. -- should solve this.
#  &dbg("Warning: cannot open the global resource file: $globrc\n") if($globrc);

}
$html2psrc=~s/^(~|\$HOME)/$ENV{"HOME"}/;
$prc=$html2psrc;
if($opt_f) {
  ($prc=$opt_f)=~s/^:/$html2psrc:/;
  $prc=~s/:$/:$html2psrc/;
  $prc=~s/::/:$html2psrc:/;
}
$cwd=$posix?POSIX::getcwd():"";
opendir(DIR,$cwd);
@local=readdir DIR;
closedir DIR;
$globrc=~/html2psrc/;
$gdir=$`;
$hpath=$ENV{"HTML2PSPATH"}?$ENV{"HTML2PSPATH"}:".:";
$hpath=~s/^:/$gdir:/;
$hpath=~s/:$/:$gdir/;
$hpath=~s/::/:$gdir:/;
$cur=$hpath=~s/(^|:)\.($|:)/$1$cwd$2/;
@hpath=split(/:/,$hpath);
for(@hpath) {
  if(opendir(DIR,$_)) {
    @files=readdir DIR;
    $files{$_}=" @files ";
    closedir DIR;
  }
}
@rc=split(/:/,$prc);
for $rc (@rc) {
  $found=0;
  S:for $dir (@hpath) {
    if(-r $rc && !grep(/^$rc$/,@local) || $files{$dir}=~/ $rc /) {
      chdir $dir if($files{$dir}=~/ $rc / && $cwd);
      if(open(RC,$rc)) {
        $conf=<RC>;
        print DBG "***** Personal file $rc:\n$conf" if($opt_d);
        &getconf($conf);
        close RC;
        $found=1;
      }
      last S;
    }
  }
  &dbg("Error opening resource file: $rc\n") if($opt_f && !$found);
}
chdir $cwd if($cwd);
$user=2;
&getconf($opt_S) if($opt_S);
print DBG "*****\n" if($opt_d);
&pagedef;
($pagew,$pageh)=split /\s+/, $AT_page{'size'} if(defined $AT_page{'size'});

require Image::Magick if($package{'PerlMagick'});
$geturl=$package{'geturl'};
$ulanch="f";
$f=72/2.54;
$giftopm="giftopnm" if($package{'netpbm'});
$giftopm="giftoppm" if($package{'pbmplus'});

for(keys %option){eval "\$opt_$_='$option{$_}' if(!defined \$opt_$_)"};
die $usage if $opt_h;
die "$version\n" if $opt_v;
&dbg("$version\n") if ($opt_v||$opt_d);
die "Ghostscript is required to generate DSC PostScript\n"
 if($opt_D && !$package{'Ghostscript'});
die "Ghostscript is required to generate cross references\n"
 if($opt_R && !$package{'Ghostscript'});
$tmpname=$posix?POSIX::tmpnam():"h2p_$$";
($scr=$tmpname)=~/\w+$/;
$tempdir=$`;

if($opt_u) {$ulanch="t"};
if(defined $opt_x && $opt_x!~/^[0-2]$/) {
  die "Illegal duplex value: $opt_x\n";
}
$V='(-?\d+\.?\d*|-?\d*\.?\d+)';
for $o ($opt_s,$opt_i,$opt_m,$opt_N) {
  die "Non numeric: $o\n" if(defined($o) && $o!~/^$V$/);
}

$twoup=$opt_2?"t":"f";
$xp=$extrapage?"t":"f";

die "Invalid option: -W $opt_W\n" if($opt_W!~/^[abflprsL\d]*$/);
$tocdoc=$opt_C=~/[ft]/;
if($tocdoc && !defined $opt_W) {$opt_W=4};
$mult=$#ARGV>0 || $opt_W;
$maxlev=$opt_W=~/(\d+)/?$1:4;
$link=$opt_W=~/l/;
$local=$opt_W=~/s/;
$rel=$opt_W=~/r/;
$below=$opt_W=~/b/;
$layer=$opt_W=~/L/;
$prompt=$opt_W=~/p/;

if($opt_C && $opt_C!~/^(b?[ft]|[ft]b?|b?h|hb?)$/)
  {die "Invalid option: -C $opt_C\n"};
$tc=$opt_C?"t":"f";
$rev=$opt_C=~/t/;
$first=$opt_C=~/b/ || $opt_R;
$th=$tocdoc?"f":"t";
$oeh=0;
$oef=0;

@now=localtime;
@gmnow=gmtime;
POSIX::setlocale(&POSIX::LC_TIME,$locale) if($posix);
$R='(\s*>|[^a-zA-Z0-9>][^>]*>)';
$S='([\w.:/%-]+)|"([^"]*)"|\'([^\']*)\'';
$X='[\da-fA-F]';
$IM='(gif|jpeg|jpg|png|xbm|xpm|ps|eps)';

for('odd-left','odd-center','odd-right','even-left','even-center','even-right')
 {
  $oeh=1 if defined $header{$_};
  $oef=1 if defined $footer{$_};
}
%metarc=();
for $a ('left','center','right') {
  if(defined $header{"odd-$a"} || defined $header{"even-$a"}) {
    $oeh=1;
  }
  if(defined $footer{"odd-$a"} || defined $footer{"even-$a"}) {
    $oef=1;
  }
  for('','odd-','even-') {
    $apa=$header{$_.$a};
    $numb=1 if($apa=~/(^|[^\$])\$N/);
    &spec($header{$_.$a});
    &spec($footer{$_.$a});
    $header{$_.$a}="($apa)";
    $apa=$footer{$_.$a};
    $numb=1 if($apa=~/(^|[^\$])\$N/);
    $footer{$_.$a}="($apa)";
    &varsub($header{$_.$a},$footer{$_.$a});
  }
}
if($oeh) {
  $yz="/YY [[{$header{'odd-left'}}{$header{'even-left'}}]"
     ."[{$header{'odd-right'}}{$header{'even-right'}}]"
     ."[{$header{'odd-center'}}{$header{'even-center'}}]] D\n";
} else {
  $ind=$header{'alternate'};
  $yz="/YY [[{$header{'left'}}$ind][{$header{'right'}}".(1-$ind)
     ."][{$header{'center'}}2]] D\n";
}
if($oef) {
  $yz.="/ZZ [[{$footer{'odd-left'}}{$footer{'even-left'}}]"
      ."[{$footer{'odd-right'}}{$footer{'even-right'}}]"
      ."[{$footer{'odd-center'}}{$footer{'even-center'}}]] D";
} else {
  $ind=$footer{'alternate'};
  $yz.="/ZZ [[{$footer{'left'}}$ind][{$footer{'right'}}".(1-$ind)
      ."][{$footer{'center'}}2]] D";
}
$number=$opt_n || !$numb && ($opt_C || $opt_N || $opt_R)?"t":"f";
$tih=$titlepage{'content'};
$toch=$toc{'heading'};
for ($imgalt,$xref{'text'},$tih,$toch,$inh,$draft{'text'}) {
  &spec($_);
}

for ($paper{'height'},$paper{'width'},$margin{'middle'},$frame{'margin'},
     $mlr,$mrl,$mtl,$mbl,$mll,$mrr,$mtr,$mbr,$pagew,$pageh) {
  &getval($_,1);
}
$opt_s*=0.65 if($opt_2 && $opt_L);
$opt_N=1 if(!defined $opt_N);
$opt_N=int($opt_N-1);
$mm=int($margin{'middle'}*$f);
$is=0.8*$opt_i;
$msc=1/$opt_s;
$mag=1200*$opt_m*$opt_s;
$xref=$opt_R?"t":"f";
$xref{'text'}=~s/\$N/) WB pN WB (/g;

$d=int($f*$frame{'margin'});
for (0..10) {
  $temp=2**(-$_/2);
  $width{"a$_"}=int($temp*2**(-1/4)*1000+.5)/10;
  $height{"a$_"}=int($temp*2**(1/4)*1000+.5)/10;
  $width{"b$_"}=int($temp*1000+.5)/10;
  $height{"b$_"}=int($temp*2**(1/2)*1000+.5)/10;
}
if(!$pagew || !$pageh) {
  if($width{"\L$paper{'type'}"}) {
    $paper{'width'}=$width{"\L$paper{'type'}"} if(!defined $paper{'width'});
    $paper{'height'}=$height{"\L$paper{'type'}"} if(!defined $paper{'height'});
    ($pagew,$pageh)=($paper{'width'},$paper{'height'});
  } elsif($paper{'type'}) {
    &dbg("Unknown paper type: $paper{'type'}\n");
  }
}
if($opt_L) {
  $wl=$pageh-$mll-$mrl;
  $wr=$pageh-$mlr-$mrr;
  $hl=int(($pagew-$mtl-$mbl)*$f+.5);
  $hr=int(($pagew-$mtr-$mbr)*$f+.5);
  $xl=int($mtl*$f+.5);
  $xr=int($mtr*$f+.5);
  $yl=int($mll*$f+.5);
  $yr=int($mlr*$f+.5);
  $rot=" 90 rotate";
} else {
  $wl=$pagew-$mll-$mrl;
  $wr=$pagew-$mlr-$mrr;
  $hl=int(($pageh-$mtl-$mbl)*$f+.5);
  $hr=int(($pageh-$mtr-$mbr)*$f+.5);
  $xl=int($mll*$f+.5);
  $xr=int($mlr*$f+.5);
  $yl=int(($pageh-$mtl)*$f+.5);
  $yr=int(($pageh-$mtr)*$f+.5);
  $rot="";
}

if($opt_2) {
  $wl=($wl-$margin{'middle'})/2;
  $wr=($wr-$margin{'middle'})/2;
}
$wl=int($wl*$f+.5);
$wr=int($wr*$f+.5);
$pag=int($pageh*$f+.5);
$fe=$opt_F?"t":"f";
$cf=$opt_U?"t":"f";
$tp=$opt_t?"t":"f";
$rm=$numbstyle?"t":"f";
$pa=$showurl?"t":"f";
$nh=$seq_number?"t":"f";
$bt=$break_table?"t":"f";
$ea=$expand_acronyms?"t":"f";
$fi=$prefilled?"t":"f";
$latin1=$opt_e=~/ISO-8859-1/i;
$lt=$del{'text-decoration'}=~/^line-through$/i?"SE":"WB";
if(!$opt_x && defined $opt_x) {
  $dupl="[{false statusdict/setduplexmode get exec} stopped cleartomark";
}
if($opt_x) {
  $dupl="[{true statusdict/setduplexmode get exec} stopped cleartomark";
}
if($opt_x==2) {
  $dupl.="\n[{true statusdict/settumble get exec} stopped cleartomark";
}

%head=("html",1, "head",1, "title",1, "base",1, "meta",1, "link",1, "style",1,
 "script",1, "isindex",1);
%algn=("left",1, "center",2, "right",3, "justify",4, "char",5);
%f=("void",1, "above",2, "below",3, "hsides",4, "lhs",5, "rhs",6, "vsides",7,
    "box",8, "border",9);
%r=("none",1, "groups",2, "rows",3, "cols",4, "all",5);
%v=("top",1, "middle",2, "bottom",3, "baseline",4);
%it=("radio",0, "checkbox",1, "text",2, "password",2, "image",3);
%ssy=(200,"\\", 201, "(", 202, ")");
%lity=("I",0, "i",1, "A",2, "a",3, "1",4, "disc",5, "square",6, "circle",7);
$ltr=join('|',keys %lity);
%tex=('`a',"\340", '\^a',"\342", '`e',"\350", '`e',"\350", 'c\{c\}',"\347",
      "'e","\351", '\^e',"\352", '"e',"\353", '\^i',"\356", '"i',"\357",
      '\^o',"\364", '`u',"\371", '\^u',"\373", '"u',"\374", '"y',"\377",
      'aa',"\345", '"a',"\344", '"o',"\366", 'ae',"\346", 'oe',"\225");
@hind=(0,0,0,0,0,0);
$ltrs='A-Za-z\222-\226\300-\377';
%ent=(
"lsquo|#8216",96,
"rsquo|#8217",39,
"circ|#710",141,
"tilde|#732",142,
"permil|#8240",143,
"dagger|#8224",144,
"Dagger|#8225",145,
"Yuml|#376",146,
"scaron|#353",147,
"Scaron|#352",148,
"oelig|#339",149,
"OElig|#338",150,
"lsaquo|#8249",151,
"rsaquo|#8250",152,
"sbquo|#8218",153,
"bdquo|#8222",154,
"ldquo|#8220",155,
"rdquo|#8221",156,
"ndash|#8211",157,
"mdash|#8212",158,
"trade|#8482",159,
"nbsp",160,
"iexcl",161,
"cent",162,
"pound",163,
"curren",164,
"yen",165,
"brvbar",166,
"sect",167,
"uml",168,
"copy",169,
"ordf",170,
"laquo",171,
"not",172,
"reg",174,
"macr",175,
"deg",176,
"plusmn",177,
"sup2",178,
"sup3",179,
"acute",180,
"micro",181,
"para",182,
"middot",183,
"cedil",184,
"sup1",185,
"ordm",186,
"raquo",187,
"frac14",188,
"frac12",189,
"frac34",190,
"iquest",191,
"Agrave",192,
"Aacute",193,
"Acirc",194,
"Atilde",195,
"Auml",196,
"Aring",197,
"AElig",198,
"Ccedil",199,
"Egrave",200,
"Eacute",201,
"Ecirc",202,
"Euml",203,
"Igrave",204,
"Iacute",205,
"Icirc",206,
"Iuml",207,
"ETH",208,
"Ntilde",209,
"Ograve",210,
"Oacute",211,
"Ocirc",212,
"Otilde",213,
"Ouml",214,
"times",215,
"Oslash",216,
"Ugrave",217,
"Uacute",218,
"Ucirc",219,
"Uuml",220,
"Yacute",221,
"THORN",222,
"szlig",223,
"agrave",224,
"aacute",225,
"acirc",226,
"atilde",227,
"auml",228,
"aring",229,
"aelig",230,
"ccedil",231,
"egrave",232,
"eacute",233,
"ecirc",234,
"euml",235,
"igrave",236,
"iacute",237,
"icirc",238,
"iuml",239,
"eth",240,
"ntilde",241,
"ograve",242,
"oacute",243,
"ocirc",244,
"otilde",245,
"ouml",246,
"divide",247,
"oslash",248,
"ugrave",249,
"uacute",250,
"ucirc",251,
"uuml",252,
"yacute",253,
"thorn",254,
"yuml",255);
%symb=(
"alpha|#945",141,
"beta|#946",142,
"gamma|#947",147,
"delta|#948",144,
"epsilon|#949",145,
"zeta|#950",172,
"eta|#951",150,
"theta|#952",161,
"thetasym|#977",112,
"iota|#953",151,
"kappa|#954",153,
"lambda|#955",154,
"mu|#956",155,
"nu|#957",156,
"xi|#958",170,
"pi|#960",160,
"piv|#982",166,
"omicron|#959",157,
"rho|#961",162,
"sigma|#963",163,
"sigmaf|#962",126,
"tau|#964",164,
"upsilon|#965",165,
"upsih|#978",241,
"phi|#966",146,
"phiv",152,
"chi|#967",143,
"psi|#968",171,
"omega|#969",167,
"Alpha|#913",101,
"Beta|#914",102,
"Gamma|#915",107,
"Delta|#916",104,
"Epsilon|#917",105,
"Zeta|#918",132,
"Eta|#919",110,
"Theta|#920",121,
"Iota|#921",111,
"Kappa|#922",113,
"Lambda|#923",114,
"Mu|#924",115,
"Nu|#925",116,
"Xi|#926",130,
"Omicron|#927",117,
"Pi|#928",120,
"Rho|#929",122,
"Sigma|#931",123,
"Tau|#932",124,
"Upsilon|#933",125,
"Phi|#934",106,
"Chi|#935",103,
"Psi|#936",131,
"Omega|#937",127,
"fnof|#402",246,
"perp|#8869",136,
"plusmn|#177",261,
"cdot|#183",327,
"or|#8744",332,
"and|#8743",331,
"le|#8804",243,
"ge|#8805",263,
"equiv|#8801",272,
"cong|#8773",100,
"asymp|#8776",273,
"ne|#8800",271,
"sub|#8834",314,
"sube|#8838",315,
"sup|#8835",311,
"supe|#8839",312,
"isin|#8712",316,
"larr|#8592",254,
"rarr|#8594",256,
"uarr|#8593",255,
"darr|#8595",257,
"harr|#8596",253,
"lArr|#8656",334,
"rArr|#8658",336,
"uArr|#8657",335,
"dArr|#8659",337,
"hArr|#8660",333,
"forall|#8704","042",
"exist|#8707","044",
"infin|#8734",245,
"nabla|#8711",321,
"part|#8706",266,
"hellip|#8230",274,
"int|#8747",362,
"sum|#8721",345,
"prod|#8719",325,
"real|#8476",302,
"image|#8465",301,
"bull|#8226",267,
"prime|#8242",242,
"Prime|#8243",262,
"oline|#8254",140,
"frasl|#8260",244,
"weierp|#8472",303,
"alefsym|#8501",300,
"crarr|#8629",277,
"empty|#8709",306,
"notin|#8713",317,
"ni|#8715","047",
"minus|#8722","055",
"lowast|#8727","052",
"radic|#8730",326,
"prop|#8733",265,
"ang|#8736",320,
"cap|#8745",307,
"cup|#8746",310,
"sim|#8764",176,
"nsub|#8836",313,
"oplus|#8853",305,
"otimes|#8855",304,
"sdot|#8901",327,
"lceil|#8968",351,
"rceil|#8969",371,
"lfloor|#8970",353,
"rfloor|#8971",373,
"lang|#9001",341,
"rang|#9002",361,
"spades|#9824",252,
"clubs|#9827",247,
"hearts|#9829",251,
"diams|#9830",250,
"loz|#9674",340);

$pc=')WB NL NP(';
$nimg=-1;
$nm=-1;
@font=();
@size=();
@styl=();
@alig=();
@colr=();
@topm=();
@botm=();
@lftm=();
@rgtm=();
@z1=();
@z2=();
@z3=();
&Subst($doc_sep);
($toct=$toch)=~s|<[\w/!?][^>]*>||g;
$dh="/h0 [()($toct)] D\n";
&Subst($toch);
$toch=~s/  H\(/ -1 H(/g;
$toch="($toch)";
&varsub($toch);
&Subst($tih);
$tih=~s/  H\(/ -1 H(/g;
$tih="($tih)";
&varsub($tih);
$mn=0;
$nfont=0;
$mi=0;
for (@fo) {&setel($_)};
%arr=%draft;
&fs("draft");

if(!$latin1 && !defined $fontid{"times"}) {
  $fontid{"times"}=$nfont++;
  @docfonts=(@docfonts,split(/\s+/,$font_names{"times"}));
}
$wind=0;
$wf="t";
if(!$latin1) {
  $wind=$fontid{"times"};
  $wf="f";
}

for $k (keys %font_files){
  @ff=split(/\s+/,$font_files{$k});
  @fn=split(/\s+/,$font_names{$k});
  for (0..3) {
    if($ff[$_]) {
      $ff{$fn[$_]}=$ff[$_];
    } elsif(!$ff{$fn[$_]}) {
      $ff{$fn[$_]}=$ff[0];
    }
    $fr{$fn[$_]}=$k;
  }
}
$pta=defined $p{"text-align"}?$p{"text-align"}:$body{"text-align"};
$pal=0;
$pal=1 if($pta=~/^c/i);
$pal=2 if($pta=~/^r/i);
$pal=3 if($pta=~/^j/i);
$bgcol=&col2rgb($body{"background"});
if(!$bgcol) {$bgcol="[16#FF 16#FF 16#FF]"};
if(!$p{"color"}) {$p{"color"}="black"};
$tcol=&col2rgb($p{"color"});
$lcol=&col2rgb($a__link{"color"});
if($lcol) {
  $Lc="/Lc t D\n/Dl $lcol D\n";
  $Lc.=$tcol ne $lcol?"/LX t D":"/LX f D";
} else {
  $Lc="/Lc f D\n/LX f D";
}
$pcol=&col2rgb($pre{"color"});
if(!$pcol) {$pcol="[0 0 0]"};
$deftbg=&col2rgb($table{"background"});
$hc=&col2rgb($hr{"color"});
if(!$hc) {$hc="[0 0 0]"};
$fcol=&col2rgb($frame{"color"});
if(!$fcol) {$fcol="[0 0 0]"};
for ($p{"font-size"},$pre{"font-size"},$header{"font-size"},$frame{'width'},
 $footer{"font-size"},$justify{'letter'},$justify{'word'},
 $titlepage{'margin-top'}) {
  &getval($_,2);
}
for ($p{"line-height"},$p{"text-indent"},$p{"margin-top"},$toc{'indent'},
     $ball_radius) {
  &getval($_,0);
}
$fl="/FL [/".join("\n/",@docfonts)."] D";
for $k (keys %ff) {
  $f=$ff{$k};
  if(defined $fontid{$fr{$k}} && !defined($cont{$f})) {
    open(FONT,$f) || &dbg("Error opening fontfile $f\n");
    ($cont{$f}=<FONT>)=~s/(^|\r?\n|\r)%.*//g;
    close FONT;
  }
}
$fontdef="";
for (keys %cont) {
  $fontdef.=$cont{$_};
}
&ent($yz);
&ent($xref{'text'});
&ent($draft{'text'});

$lnum=0;
for (keys %quote_open) {
  $lid{$_}=$lnum++;
  if(!defined $quote_close{$_}) {$quote_close{$_}=$quote_open{$_}};
  if(!defined $quote_open2{$_}) {$quote_open2{$_}=$quote_open{$_}};
  if(!defined $quote_close2{$_}) {$quote_close2{$_}=$quote_close{$_}};
  &ent($quote_open{$_});
  &ent($quote_close{$_});
  &ent($quote_open2{$_});
  &ent($quote_close2{$_});
  push(@qo,$quote_open{$_});
  push(@qc,$quote_close{$_});
  push(@qo2,$quote_open2{$_});
  push(@qc2,$quote_close2{$_});
}
$qo=join(')(',@qo);
$qc=join(')(',@qc);
$qo2=join(')(',@qo2);
$qc2=join(')(',@qc2);
$hyphenation_file{''}=$hyphenation_file{'en'};
$br=$collapse_br?"f":"t";
$gd=0;
$ddr=defined $draft{'print'};
if($ddr) {
  if($draft{'print'}==0) {
    $draft="f";
  } else {
    $gd=1;
    $draft="t";
  }
}
if(-e '/dev/null' || !-e 'nul') {
  $pathsep=':';
  $gs='gs';
} else {
  $pathsep=';';
  $gs='gswin32c';
}
$gb=$gs_bug?"t":"f";
for (keys %quote) {$lid{$_}=$lid{$quote{$_}}};
$ENV{'PATH'}.="$pathsep$package{'path'}" if($package{'path'});
$delim="%-- End of variable part --";
$cd="/Cd {aload length 2 idiv dup dict begin {D} repeat currentdict end} D";

$mysymb=<<EOF;
/MySymbol 10 dict dup begin
 /FontType 3 D /FontMatrix [.001 0 0 .001 0 0 ] D /FontBBox [25 -10 600 600] D
 /Encoding 256 array D 0 1 255{Encoding exch /.notdef put}for
 Encoding (e) 0 get /euro put
 /Metrics 2 dict D Metrics begin
  /.notdef 0 D
  /euro 651 D
 end
 /BBox 2 dict D BBox begin
  /.notdef [0 0 0 0] D
  /euro [25 -10 600 600] D
 end
 /CharacterDefs 2 dict D CharacterDefs begin
  /.notdef {} D
  /euro{newpath 114 600 moveto 631 600 lineto 464 200 lineto 573 200 lineto
   573 0 lineto -94 0 lineto 31 300 lineto -10 300 lineto closepath clip
   50 setlinewidth newpath 656 300 moveto 381 300 275 0 360 arc stroke
   -19 350 moveto 600 0 rlineto -19 250 moveto 600 0 rlineto stroke}d
 end
 /BuildChar{0 begin
  /char E D /fontdict E D /charname fontdict /Encoding get char get D
  fontdict begin
   Metrics charname get 0 BBox charname get aload pop setcachedevice
   CharacterDefs charname get exec
  end
 end}D
 /BuildChar load 0 3 dict put /UniqueID 1 D
end
definefont pop
EOF

$P0=<<EOC;
%%Creator: $version
%%EndComments
save
2000 dict begin
/d {bind def} bind def
/D {def} d
/t true D
/f false D
$fl
/WF $wf D
/WI $wind D
/F $opt_s D
/IW $wr F div D
/IL $hr F div D
/PS $pag D
/EF [@font] D
/EZ [@size] D
/Ey [@styl] D
/EG [@alig] D
/Tm [@topm] D
/Bm [@botm] D
/Lm [@lftm] D
/Rm [@rgtm] D
/EU [@colr] D
/NO $number D
$yz
/Ts EZ 0 get D
/TU $twoup D
/Xp $xp D
/AU $ulanch D
/SN $opt_N D
/Cf $cf D
/Tp $tp D
/Fe $fe D
/TI $toc{'indent'} Ts mul D
/Fm $d D
/xL $xl D
/xR $xr D
/yL $yl D
/yR $yr D
/Wl $wl F div D
/Wr $wr F div D
/hL $hl F div D
/hR $hr F div D
/FE {newpath Fm neg Fm M CP BB IW Fm add Fm L IW Fm add IL Fm add neg L CP BB
 Fm neg IL Fm add neg L closepath} D
/LA {PM 0 eq{/IW Wl D /IL hL D}{/IW Wr D /IL hR D}ie /W IW D /LL W D /LS W D
 /LE IL D TU PM 0 eq and{IW $mm F div add SA{Sf div}if 0 translate}
 {PM 0 eq{xL yL}{xR yR}ie translate$rot F SA{Sf mul}if dup scale
 CS CF FS Cf{CA CL get VC}if /Bb f D}ie 0 0 M
 TF not Tc or {Cf{gsave SA{1 Sf div dup scale}if Cb VC FE fill grestore}if}if}D
/Pi $p{"text-indent"} Ts mul D
/SG [$is $opt_i $msc] D
/Ab $justify{'word'} D
/J $justify{'letter'} D
/Tc $tc D
/NH $toc{'level'} D
/Nf $nh D
/Pa $pa D
/LH $p{"line-height"} D
/XR $xref D
/Xr {/pN E D ( $xref{'text'} )WB} D
/Db $bgcol D
/Dt $tcol D
/eA $ea D
/Fi $fi D
/bT $bt D
$Lc
/Br $ball_radius D
/IA ($imgalt) D
/DS {/PF f D($doc_sep)pop RC ZF} D
/Gb $gb D
/Mb $br D
/Hc $hc D
/Bl 3 D
/MI -$mi D
/DX ($draft{'text'}) D
/Di $draft{'dir'} D
/Tt $titlepage{'margin-top'} D
/Th {$tih} D
/tH {$toch} D
/FD $fontid{"\L$font"} D
/Dy $styl D
/cD $col D
/FW $frame{'width'} D
/FU $fcol D
/ET {/RM $rm D /A0 $pal D /PN SN D /OU t D /Ou t D /W IW D /LL W D D1
 Ms not TP and{Ip}if /TF f D} D
$dupl
$delim
$mysymb
EOC

$reenc=<<EOD;
WF{FL{reencodeISO D}forall}{4 1 FL length 1 sub{FL E get reencodeISO D}for}ie
/Symbol dup dup findfont dup length dict begin
 {1 index /FID ne{D}{pop pop}ie}forall /Encoding [Encoding aload pop]
 dup 128 /therefore put D currentdict end definefont D
EOD
$defs=<<EOD;
/reencodeISO {
 dup dup findfont dup length dict begin{1 index /FID ne{D}{pop pop}ie}forall
 /Encoding ISOLatin1Encoding D currentdict end definefont} D
/ISOLatin1Encoding [
/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef
/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef
/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef
/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef
/space/exclam/quotedbl/numbersign/dollar/percent/ampersand/quoteright
/parenleft/parenright/asterisk/plus/comma/hyphen/period/slash
/zero/one/two/three/four/five/six/seven/eight/nine/colon/semicolon
/less/equal/greater/question/at/A/B/C/D/E/F/G/H/I/J/K/L/M/N
/O/P/Q/R/S/T/U/V/W/X/Y/Z/bracketleft/backslash/bracketright
/asciicircum/underscore/quoteleft/a/b/c/d/e/f/g/h/i/j/k/l/m
/n/o/p/q/r/s/t/u/v/w/x/y/z/braceleft/bar/braceright/asciitilde
/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef
/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef
/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef
/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef/.notdef
/.notdef/space/exclamdown/cent/sterling/currency/yen/brokenbar
/section/dieresis/copyright/ordfeminine/guillemotleft/logicalnot
/hyphen/registered/macron/degree/plusminus/twosuperior/threesuperior
/acute/mu/paragraph/periodcentered/cedilla/onesuperior/ordmasculine
/guillemotright/onequarter/onehalf/threequarters/questiondown
/Agrave/Aacute/Acircumflex/Atilde/Adieresis/Aring/AE/Ccedilla
/Egrave/Eacute/Ecircumflex/Edieresis/Igrave/Iacute/Icircumflex
/Idieresis/Eth/Ntilde/Ograve/Oacute/Ocircumflex/Otilde/Odieresis
/multiply/Oslash/Ugrave/Uacute/Ucircumflex/Udieresis/Yacute
/Thorn/germandbls/agrave/aacute/acircumflex/atilde/adieresis
/aring/ae/ccedilla/egrave/eacute/ecircumflex/edieresis/igrave
/iacute/icircumflex/idieresis/eth/ntilde/ograve/oacute/ocircumflex
/otilde/odieresis/divide/oslash/ugrave/uacute/ucircumflex/udieresis
/yacute/thorn/ydieresis
] D
[128/backslash 129/parenleft 130/parenright 141/circumflex 142/tilde
143/perthousand 144/dagger 145/daggerdbl 146/Ydieresis 147/scaron 148/Scaron
149/oe 150/OE 151/guilsinglleft 152/guilsinglright 153/quotesinglbase
154/quotedblbase 155/quotedblleft 156/quotedblright 157/endash 158/emdash
159/trademark]
aload length 2 idiv 1 1 3 -1 roll{pop ISOLatin1Encoding 3 1 roll put}for
/colorimage where{pop}{
 /colorimage {
  pop pop /Pr E D {/Cv Pr D /Gr Cv length 3 idiv string D 0 1 Gr length 1 sub
   {Gr E dup /i E 3 mul D Cv i get 0.299 mul Cv i 1 add get 0.587 mul add
    Cv i 2 add get 0.114 mul add cvi put}for Gr} image} D
}ie
/pdfmark where{pop}{userdict /pdfmark /cleartomark load put}ie
EOD

$P1=<<EOT;
$cd
/EX {EC cvx exec} D
/DU {} d
/BB {pop pop}d
/ie {ifelse} d
/E {exch} d
/M {moveto} d
/R {rmoveto} d
/L {lineto} d
/RL {rlineto} d
/CP {currentpoint} d
/SW {stringwidth} d
/GI {getinterval} d
/PI {putinterval} d
/Sg {setgray} d
/LW {setlinewidth} d
/S {dup () ne OU and{0 Co R AT 3 eq LB and HF not and A1 0 ne A2 0 ne or and
 {A2 0 32 A1 0 6 -1 roll awidthshow}{show}ie 0 Co neg R}{pop}ie
 OU PH 3 eq or{/Ms t D}if} D
/U {OU{gsave CP currentfont /FontInfo get /UnderlinePosition get
 0 E currentfont /FontMatrix get dtransform E pop add newpath M dup SW pop
 CJ 0 RL stroke grestore}if} D
/B {OU Br 0 gt and{CP Ts neg Ts .33 mul R gsave 0 Sg
 CP newpath Ts Br mul 0 360 arc closepath UI 2 mod 0 eq{stroke}{fill}ie
 grestore M CP E Ts Br 1 add mul sub E BB /Ms t D}if}D
/NP {Ms TP not or PA and OU and{TP{OR}if f1{mF k2 /mF E D /YC 0 D}if
 TP TU not PM 0 eq or and{showpage}if DU Ip TE not{LA}if 0.6 LW
 /CI 0 D /TP t D /Hs f D /hl 6 D /Hv 6 D /HI hi D /Ms f D}if Bs XO BO M} D
/Np {LE sub CP E pop gt PL 0 eq and{NP}if}D
/Ip {/PN PN 1 add D /Pn RM{1}{4}ie PN Ns D /PM PN SN sub 2 mod D} D
/GP {E dup 3 -1 roll get PN 1 add 2 mod get dup type /integertype eq
 {get 0 get}{E pop}ie}d
/Fc {dup 2 GP exec SW pop /S1 E D dup 1 GP exec SW pop /S2 E D 0 GP exec SW
 pop /S3 E D S1 0 gt{S2 2 mul S1 add S3 2 mul S1 add 2 copy lt{E}if pop}{0}ie
 S2 S3 add 2 copy lt{E}if pop IW .9 mul div dup 1 gt{1 E div}{pop 1}ie}D
/OR {Df{Sd}if tp not{gsave SA{1 Sf div dup scale}if Fe{Cf{FU VC}if FW LW
 1 setlinejoin FE stroke}if /YO {60 F div dup 40 gt{pop 40}if}D /cs CS D
 /cf CF D /CF 0 D /pf PF D /PF f D /Fn FN D /At AT D /AT 0 D /FN EF Hf 1 add
 get D Fz Fs FS ZZ Fc Fz mul Fs FS EU Hf 1 add get dup type /arraytype eq
 Cf and{VC}{pop 0 Sg}ie IW IL neg YO sub M ZZ 1 GP exec dup SW pop neg 0 R Sh
 0 IL neg YO sub M ZZ 0 GP exec Sh ZZ 2 GP exec dup SW pop IW E sub 2 div
 IL neg YO sub M Sh Fz Fs FS NO{/AW IW Pn SW pop sub D AW 2 div IL neg YO sub
 S1 0 gt S2 AW .45 mul gt or S3 AW .45 mul gt or{Fz 2 mul sub}if M Pn Sh}if
 EU Hf get dup type /arraytype eq Cf and{VC}{pop 0 Sg}ie YY Fc /FN EF Hf get D
 Hz mul HS FS IW YO M YY 1 GP exec dup SW pop neg 0 R Sh 0 YO M YY 0 GP exec Sh
 YY 2 GP exec dup SW pop IW E sub 2 div YO M Sh /FN Fn D /AT At D t Pb XO SZ
 SL get neg R /PF pf D grestore /CF 0 D cs cf FS}if}D
/Sh {dup () ne{CP Hz 4 div sub BB show CP CS add BB}{pop}ie}D
/Pb {/OU E D /Ou OU D /PB t D 0 0 M Ba{/Sa save D /BP t D /Fl t D RC /PL 0 D
 /PH 0 D /W IW D /LE IL .7 mul D /EO 0 D SI ZF /YA 0 D /BO 0 D /C1 () D
 BA 0 Ts neg R Bb{Xl Yl Xh Yh}if Bb CP Sa restore M
 {/Yh E D /Xh E D /Yl E D /Xl E D}if /Fl t D}if
 BL /OU t D /HM f D /Ou t D /PB f D} D
/Bs {/BP Ba not D}D
$defs$fontdef$reenc
/SF {/CS E D SZ SL CS put FO SL FN put /YI CS LH neg mul D dup ST cvs ( ) join
 CS ST cvs join C1 E join ( NF ) join /C1 E D CS NF /Wf WF FN 0 gt or D
 /BW Wf{( ) SW pop}{0}ie D}D
/NF {/cS E D /cF E D cF 0 ge{FL cF get}{cF -1 eq{/Symbol}{/MySymbol}ie}ie
 findfont cS scalefont setfont} D
/FS {CF or /CF E D FR SL CF put CF CF 0 ge{FN 4 mul add}if E SF} D
/PC {SH /BP f D fin not GL not and{NL}if /HM t D /LL LS D} D
/BS {/TX E D Wf{/fin f D /CW 0 D /LK 0 D /SC 0 D
 /RT TX D {RT ( ) search{/NW E D pop /RT E D /WH NW SW pop D CW WH add LL gt
 {TX SC LK SC sub 1 sub NN GI GL{SH cF cS OC
 2 copy cS ne E cF ne or{NF}{pop pop}ie}{PC /CW WH BW add D}ie
 /SC LK D}
 {GL{JC}if
 /CW CW WH add BW add D /HM t D}ie /GL f D /Ph f D
 /LK LK NW length 1 add add D}{pop exit}ie}loop
 /fin t D TX SC LK SC sub GI SH RT () ne{GL not{CC}if}if
 /LC TX length D /WH RT SW pop D CW WH add Hy{HC SW pop add}if LL gt
 {RT GL{SH cF cS OC 2 copy cS ne E cF ne or{NF}{pop pop}ie
 Hy{/Ph t D}if /LL LS D}{NL /LL LS D SH}ie}
 {RT PC Hy{CC}if /Ph Ph Hy or D}ie RT () ne{/GL t D /HM t D}if}
 {TX SW pop LL le{TX SH}{/NW () D 0 2 TX length 1 sub
 {/CW E D TX 0 CW GI dup SW pop LL gt{pop NW SH /HM t D NL/LL W XO sub MR sub D
 /CW CW 2 sub NN D /TX TX CW TX length CW sub GI D TX BS exit}
 {/NW E D}ie}for}ie}ie /HM t D}D
/CC {C0 length 0 gt{JC}if /C0 [C1 L1 YA YB Mf NS NB TB AF Bw] D
 /C1 () D /L0 L1 D /YA 0 D /YB 0 D /Mf 0 D /NS 0 D /NB 0 D}D
/JC {C0 aload length 0 gt{pop pop pop NB add /NB E D NS add /NS E D
 dup Mf gt{/Mf E D}{pop}ie dup YB gt{/YB E D}{pop}ie
 dup YA gt{/YA E D}{pop}ie pop C1 join /C1 E D /C0 [] D}if}D
/OC {C0 length 0 gt{C1 L1 L0 sub YA YB Mf NS NB TB AF Bw GL C0 aload pop
 /Bw E D /AF E D /TB E D /NB E D /NS E D /Mf E D /YB E D /YA E D /C0 [] D
 /L1 E D /C1 E D Ph{HC SH}if NL /GL E D /Bw E D /AF E D /TB E D /NB E D /NS E D
 /Mf E D /YB E D /YA E D /L1 E D /LL W L1 sub XO sub MR sub WH sub D /CW 0 D
 C1 E join /C1 E D}if}D
/BT {/LB t D dup length string copy RS dup dup () ne E ( ) ne and
 {/CI 0 D /LS LL D /LL W L1 sub XO sub MR sub D BS}
 {dup ( ) eq{/GL f D}if dup () eq L1 0 eq or{pop}{SH /BP f D /Ph f D}ie}ie
 /LB f D} D
/BL {CP E pop XO E M} D
/NL {JC /GL f D /SK W XO sub MR sub L1 sub TB{Bw add}if D
 /YA LF{Mf HM Fl not and PF or{LH mul}if}{0 /LF t D}ie YA 2 copy lt{E}if pop D
 C1 () ne{/FB YB Mf SA{Sf mul}if 4 div 2 copy lt{E}if pop D}if Fl{/Ya YA D}if
 CP E pop YA sub YB sub LE neg lt Fl not and PB not and{NP}if NT TL BL
 OU PF not and PB or{/RE L1 TB{Bw sub}if
 W XO sub MR sub div YA YB add LE BO add div 2 copy lt{E}if pop D
 RE 1 gt{BL 1 RE div dup scale}if}if
 AT 2 le{SK AT mul 2 div YA neg R}if
 AT 3 eq{0 YA neg R TB{/NB NB 1 sub D /NS NS 1 sub D}if /NB NB 1 sub NN D
 /A3 NS 6 mul NB add D NS NB add 0 eq
  {/A1 0 D /A2 0 D}
  {NS 0 eq{/A1 SK NB div dup J gt{pop 0}if D /A2 0 D}{J A3 mul SK lt
   {/A1 J D /A2 SK J NB mul sub NS div dup Ab gt{/A1 0 D pop 0}if D}
   {/A1 SK A3 div D /A2 A1 6 mul D}ie}ie}ie /A1 A1 NN D /A2 A2 NN D}if
 AT 4 eq{0 YA neg R PH 2 le{PD 0 lt{/PD L1 D}if PD M1 gt{/M1 PD D}if
 L1 PD sub M2 gt{/M2 L1 PD sub D}if}{DV ID 1 sub get 0 ge{Lo 0 R}if}ie}if
 F0 cF ne Cs cS ne or{F0 Cs NF}if
 /ms Ms D /Ms f D CP FB sub
 C1 cvx exec XO EO sub L1 add TB{BW sub}if dup LM gt{/LM E D}{pop}ie
 PH 0 eq PH 4 eq or Ms and{HF not{/PO t D /AH t D}if
 BB CP YA add E AT 3 eq LB and{A1 sub}if TB{BW sub}if E BB}
 {pop pop}ie Ms HM PH 3 eq and or{/BP f D /Fl f D}if
 /Lo 0 D /L1 0 D /F0 cF D /Cs cS D BP not{0 YB NN neg R}if
 OU f1 and mF not and{k2 /f1 f D}if
 OU PF not and PB or{RE 1 gt{RE dup scale}if}if /Ms ms Ms or D
 /C1 AF{(Cp )}{()}ie D /YA 0 D /YB 0 D BL
 AT 4 eq LB not and PH 3 ge and
 {ID DV length lt{DV ID get dup 0 ge{DO E sub /Lo E D /L1 Lo D}{pop}ie
 /ID ID 1 add D}if}if /T t D CD{/LN LN 1 add D PD}if
 /PD -1 D /NS 0 D /NB 0 D /TB f D /Ph f D /Mf 0 D /HM f D} D
/RS {/TM E D /CN 0 D TM{10 eq{TM CN ( ) PI}if /CN CN 1 add D}forall
 /CN 0 D /BK HM EN and{0}{1}ie D TM
 {dup 32 ne{TM CN 3 2 roll put /CN CN 1 add D /BK 0 D}
 {pop BK 0 eq{TM CN 32 put /CN CN 1 add D}if /BK 1 D}ie}forall
 TM 0 CN GI dup dup () ne E ( ) ne and
 {dup CN 1 sub get 32 eq{/EN f D}{/EN t D}ie}if} D
/join {2 copy length E length add string dup 4 2 roll 2 index 0 3 index
 PI E length E PI}d
/WR {(\\n) search{dup () ne BP not or
 {Li 4 le CP E pop YI Li mul add LE add 0 lt and PL 0 eq and{NP}if
 SH NL pop /Li Li 1 sub D WR}{pop pop WR}ie}{SH}ie /CI 0 D /BP f D} D
/SH {dup dup () ne E ( ) ne and PF or CS Mf gt and{/Mf CS D}if
 T not Wf and{( ) E join /T t D}if dup BP{/MF CS D}if
 AT 3 eq{2 copy length dup 0 gt{/NB E NB add D
 {( ) search{/NS NS 1 add D pop pop}{pop exit}ie}loop}{pop pop}ie}if
 CD PD 0 lt and{dup DC search{SW pop /PD E L1 add D pop pop}{pop}ie}if
 0 Np dup SW pop L1 add /L1 E D dup () ne
 {C1 (\\() join E join (\\)) join AU AF and UF or Wf and{( U ) join}if
 sF{( s ) join}if ( S ) join
 /C1 E D dup length 1 sub get 32 eq /TB E D /Bw BW D}{pop pop}ie} D
/BG {AI LG BC add add 0 eq} D
/ON {OU{Ty AR AI NN get dup 1 add Ln Ns Ty 2 mod 0 eq{(.  )}{(\\)  )}ie join
 dup SW pop neg 0 R CP E 0 lt{0 E M}{pop}ie CP BB show /Ms t D}if} D
/Ln {AR AI 3 -1 roll put}D
/SP {dup CI lt BP not and{dup CI sub 0 E R /CI E D}{pop}ie} D
/BN {PF{WR /HM f D}{BT NL}ie} D
/NN {dup 0 lt{pop 0}if} D
/h {(h) HI ST cvs join cvx exec dup 1 get E Nf{0 get E join}{pop}ie} D
/H {/fn FN D /Hi E 1 add D 1 sub /HL E D /H2 HL 2 add D /GS EZ H2 get D
 E Tm H2 get GS mul BE dup 0 gt{1 sub}{pop EG H2 get dup 0 lt{pop AT}if}ie NA
 WW Np /SL SL 1 add D /FN EF H2 get D GS Ey H2 get FS
 EU H2 get Sc Hs not HL Hl lt and Hs HL hl lt and or Hi 0 eq or
 {/HI Hi D /Hs t D /hl HL D /Hv HL D}if HL Hl lt{/hi Hi D}if
 Nf HI 0 gt and{(h) Hi ST cvs join cvx exec 0 get WB}if
 /HF t D /AH f D /PO f D} D
/EH {Bm H2 get GS mul BE OA /SL SL 1 sub NN D /CF 0 D /FN fn D
 SZ SL get FR SL get FS /HF f D /GS Ts D ()Ec} D
/P {E PF{WR}{PO{EP}{BN}ie Ts 4 mul Np AE not{Tm 0 get Ts mul neg SP}if
 dup 0 ge AH and{Pi Pd}if}ie 1 sub dup 0 lt{pop AV AL get}if /AT E D /PO t D} D
/EP {PF{WR}{BN Ts 4 mul Np}ie AE not{Bm 0 get Ts mul neg SP}if
 /AT AV AL get D /PO f D} D
/BE {E PO{EP}{BN}ie Ts 4 mul Np neg SP} D
/HR {/Aw W EO sub D /RW E dup 0 gt{Aw mul}{neg}ie dup Aw gt{pop Aw}if D /RZ E D
 E BN Ts neg SP 1 sub 2 div Aw RW sub mul EO add CP E pop M PF{0 Ps neg R}if
 0 Np OU{gsave RZ LW Cf{Hc VC}{0 Sg}ie CP BB RW 0 RL CP BB stroke grestore}if
 /CI 0 D /BP f D PF not{Ts neg SP}if /Ms t D} D
/AD {I NL EG 14 get dup 0 lt{pop AT}if NA /AE t D Tm 14 get Ts mul neg SP
 Cf{EU 14 get dup -1 eq{pop CA CL get}if Sc}if} D
/DA {BN ()ES OA /AE f D ()Ec Bm 14 get Ts mul neg SP} D
/PR {/MW E D /Li E D Tm 1 get Ps mul BE 0 NA /FN Fp D /PF t D SI /SL SL 1 add D
 /CF 0 D Ps CS mul Ts div MW WC mul CS mul Ts div dup LL gt PL 0 eq and
 {LL div div}{pop}ie Ey 1 get FS CP E pop LE add YI neg div cvi dup Li lt
 AH and{4 lt YI Li mul 5 mul LE add 0 gt or PL 0 eq and{NP}if}{pop}ie
 EU 1 get Sc /GS Ps D}D
/RP {WR NL () /PF f D SI /FN 0 D ES Bm 1 get Ps mul neg SP OA /GS Ts D} D
/SI {/XO Lm 15 get BC NN mul Lm 16 get AI UI sub NN mul add
 Lm 17 get UI NN mul add Lm 20 get LG NN mul add Ts mul
 PF{Lm 1 get Ps mul add}if EO add D
 /MR Rm 15 get BC NN mul Rm 16 get AI UI sub NN mul add
 Rm 17 get UI NN mul add Rm 20 get LG NN mul add Ts mul
 PF{Rm 1 get Ps mul add}if D /LL W XO sub MR sub D} D
/DT {/cC E D BN /LG LG 1 sub D SI /LG LG 1 add D WW 2 div Np BL} D
/DD {WB Cc 0 eq cC 0 eq and L1 0 eq or Lm 20 get Ts mul L1 sub TB{BW add}if
 Ts 2 div lt or NL /LF E D SI BL /cC 0 D} D
/DL {Dc LG Cc put /Cc E D BG{Tm 18 get Ts mul BE}{BN}ie /LG LG 1 add D BL} D
/LD {BN LG 0 gt{/LG LG 1 sub D}if /Cc Dc LG get D SI
 BG{()Bm 18 get Ts mul BE}if BL} D
/UL {BG{Tm 17 get Ts mul BE}{BN}ie NR AI NN 0 put /UI UI 1 add D
 /AI AI 1 add D SI BL} D
/LU {BN /UI UI 1 sub D /AI AI 1 sub D SI BG{()Bm 17 get Ts mul BE}if BL} D
/OL {E BG{Tm 16 get Ts mul BE}{BN}ie TR AI NN Ty put /Ty E D NR AI NN 1 put
 /AI AI 1 add D SI BL 1 Ln} D
/LO {BN /AI AI 1 sub D /Ty TR AI get D SI BG{()Bm 16 get Ts mul BE}if BL} D
/LI {E BN -1 SP /BP f D /CI 0 D 0 Np NR AI 1 sub NN get 1 eq
 {dup dup 0 gt E 4 le and{/Ty E D}{pop}ie
 /L1 L1 Ty AR AI NN get Ns SW pop XO sub dup 0 lt{pop 0}if add D ( ON )}
 {pop ( B )}ie C1 E join /C1 E D CS Mf gt{/Mf CS D}if BL} D
/BQ {Tm 15 get Ts mul BE /BC BC 1 add D SI BL} D
/QB {Bm 15 get Ts mul BE /BC BC 1 sub D SI BL} D
/Al {E EP 1 sub dup 0 lt{pop AV AL get}if NA} D
/Ea {EP OA} D
/WB {PF{WR}{BT}ie} D
/F1 {WB /FN 0 D CS 0 FS} D
/F2 {WB /FN WI D CS 0 FS} D
/HY {/Hy t D WB /Hy f D} D
/YH {WB} D
/A {/LT E D LT 1 eq{/RN E D}if /Lh E D WB /C1 C1 ( Cp ) join D
 Lc AF not and{Cl Sc}if /AF t D} D
/EA {Lc AF and{Ec}{WB}ie TL Pa AF and Lh 0 ne and
 {( \\() Lh join (\\)) join /AF f D WB}if /AF f D} D
/TL {C1 ( Tl ) apa /C1 E D} d
/apa {AF OU and Lh 0 ne LT 1 eq or and{LT 1 eq{RN ( /) E ST cvs join}
 {(\\() Lh join (\\)) join}ie E join join}{pop}ie} d
/Cp {/Xc CP /Yc E D D} D
/SS {Cf{dup 0 ge{EU E get dup -1 eq{pop CA CL get}if}{pop CA CL get}ie Sc}
 {pop}ie SZ SL get /SL SL 1 add D} D
/I {WB 8 SS 1 FS} D
/EM {WB 8 SS /CF CF 1 xor D 0 FS} D
/BD {WB 9 SS 2 FS} D
/TT {WB 10 SS /FN Fp D 0 FS} D
/KB {WB 11 SS /FN Fp D 2 FS} D
/CT {WB 12 SS 1 FS} D
/SM {WB 13 SS /FN Fp D 0 FS} D
/Q {/QL QL 1 add D QO QL 2 mod get La get join WB} D
/EQ {QC QL 2 mod get La get join WB /QL QL 1 sub D} D
/RO {WB -1 SS /CF 0 D 0 FS} D
/SY {WB -1 SS -1 FS} D
/MY {WB -1 SS -2 FS} D
/ES {WB /SL SL 1 sub NN D /CF 0 D /FN FO SL get D SZ SL get FR SL get FS ()Ec}D
/FZ {3 sub 1.2 E exp GS mul E WB TL /C1 C1 ( Cp ) join D /SL SL 1 add D 0 FS} D
/Ef {WB TL ()ES /C1 C1 ( Cp ) join D} D
/BZ {dup /Bf E D FZ}D
/Sc {dup -1 ne Cf and{/CL CL 1 add D dup 0 eq{pop [0 0 0]}if
 dup CA E CL E put VS ( VC ) join C1 E join /C1 E D}{pop}ie} D
/Ec {WB Cf{/CL CL 1 sub NN D CA CL get VS ( VC ) join C1 E join /C1 E D}if} D
/VS {dup type /arraytype eq{([) E {ST cvs join ( ) join}forall (]) join}if} D
/VC {{255 div}forall setrgbcolor} D
/Sl {dup type /integertype ne{Ds}if /La E D WB}d
/UN {WB /UF t D} D
/NU {WB /UF f D} D
/SE {WB /sF t D} D
/XE {WB /sF f D} D
/sM {/C1 C1 ( k1 ) join D}d
/eM {/C1 C1 ( k2 ) join D}d
/k1 {/YC CP E pop Ts add D /mF t D /f1 t D}d
/k2 {gsave 3 LW -9 CP E pop Ts 0.2 mul sub M -9 YC L stroke grestore /mF f D}d
/Ac {/AC E D WB}d
/Ca {eA{( \\()join AC join(\\) )join}if WB}d
/s {OU{gsave 0 CS .25 mul R dup SW pop CJ 0 RL stroke grestore}if}D
/CJ {AT 3 eq LB and{E dup dup length 1 sub A1 mul E
 {( ) search{pop pop E A2 add E}{pop exit}ie}loop 3 -1 roll add
 W CP pop sub 2 copy gt{E}if pop}if}D
/So {/Co E D} D
/SO {C1 Yo ST cvs join ( So ) join /C1 E D (j) SW pop 2 div Pd} D
/Se {E WB CS E div Pd}D
/Pd {dup type /stringtype eq{SW pop}if dup /L1 E L1 add D
 ST cvs ( 0 R ) join C1 E join /C1 E D} D
/Sp {0.35 CO} D
/Sb {-0.2 CO} D
/CO {OV Io Yo put /Yo E CS mul Yo add D /Io Io 1 add D -1.5 Io mul 3 add FZ SO
 CS Yo add dup YA gt{/YA E D}{pop}ie
 Yo neg dup YB gt{/YB E D}{pop}ie} D
/Es {ES /Io Io 1 sub NN D /Yo OV Io get D SO} D
/SB {/N2 0 D 0 1 NI{/N E D{IX N2 get 0 lt{/N2 N2 1 add D}{exit}ie}loop
 /K WS N get FC N get mul D /NY AY N2 get D /BV NY array D
 0 1 NY 1 sub{/TM K string D currentfile TM readhexstring pop pop BV E TM put}
 for BM N BV put /N2 N2 1 add D}for} D
/IC [{/MA E D /MB 0 D}{2 div /MA E D /MB MA D}{/MB E CS sub D /MA CS D}
 {pop /MA YS AB mul D /MB 1 AB sub YS mul D}{pop /MA 0 D /MB 0 D}] D
/IP {BV N get /N N 1 add D} D
/II {/K E D IX K get 0 lt{/EC E D}if /TY E D
 TY 4 eq{/Y E D /X E D}if TY 3 eq{/AB E D}if
 /XW AX K get D /YW AY K get D /IS SG IT K get get D /XS XW IS mul D
 /YS YW IS mul D YS IC TY get exec /MA MA Fl not{3 add}if D} D
/IM {II /ty TY D /xs XS D /ys YS D /ya YA D /yb YB D /ma MA D /mb MB D /k K D
 /ec EC D /BP f D /CI 0 D WB TL L1 xs add dup XO add MR add W gt
 {pop /ma ma Fl{3 add}if D NL /YA ma D /YB mb D /YS ys D /L1 xs D}
 {/L1 E D ma YA gt{/YA ma D}if mb YB gt{/YB mb D}if}ie /TB f D
 OU{CP E pop YS sub LE neg lt Fl not and PB not and{NP /YA ma D /YB mb D}if
 /BP f D ty ST cvs ( ) join IX k get 0 lt{(\\() join ec join (\\) ) join}if
 k ST cvs join ty 3 eq{AB ST cvs ( ) join E join}if
 ty 4 eq{X ST cvs ( ) join Y ST cvs join ( ) join E join}if C1 E join
 ( DI ) join FP 2 eq FP 1 eq AF and or{( FM ) join}if
 ( Il Cp ) apa /C1 E D /EN f D}if /HM t D /T f D} D
/DI {II /Xc CP /Yc E D D /YN YW neg D /HM t D /CI 0 D /K2 IX K get D gsave
 TY 4 eq{OX X IS mul add OY FY add YS sub Y IS mul sub}
 {/FY YS D CP MB sub 2 copy /OY E D /OX E D}ie
 translate K2 0 ge{/DP AZ K2 get D /BV BM K2 get D XS YS scale /N 0 D XW YW DP
 [XW 0 0 YN 0 YW] {IP} FC K2 get 1 eq{image}{f 3 colorimage}ie}
 {EX}ie grestore XS 0 R /Ms t D} D
/FM {gsave 0 Sg CP MB sub translate XS neg 0 M 0 YS RL XS 0 RL 0 YS neg RL
 XS neg 0 RL stroke grestore} D
/NA {/AT E D /AL AL 1 add D AV AL AT put} D
/OA {AL 0 gt{/AL AL 1 sub D /AT AV AL get D}if} D
/D1 {/BR {CP E pop E BN Mb{CP E pop eq{0 YI R}if}{pop}ie} D
 /Sn {OU{C1 E ST cvs join ( Ld ) join /C1 E D}{pop}ie} D} D
/D1 {/BR {BN} D /Sn {OU {C1 E ST cvs join ( Ld ) join /C1 E D} {pop} ie} D} D
/TC {/TF t D /ML 0 D HN{SW pop dup ML gt{/ML E D}{pop}ie}forall NP /RM RM not D
 RC /OU Tc D Ep /PN 0 D Ms not TP and{Ip}if /W IW ML sub Ts sub D
 /A0 0 D TH{/BR {( ) join BT} D /Sn {pop} D /Au () D}if} D
/TN {0 eq{E EA PF HF or not XR and{HN E get Xr}{pop}ie}
 {OU{Tn 0 ge{() BN}if /Tn E D}{pop}ie WB}ie} D
/NT {OU LB not and Tn 0 ge and{PL 0 eq{Ms not{CS CF FS}if CP dup
 /y E YA sub D W 9 sub CS -1.8 mul XO L1 add 2 add{y M (.) show}for
 HN Tn get dup SW pop IW E sub y M show CP BB M}if /Tn -1 D}if} D
/Ld {/DN E D HN DN Pn put [/View [/XYZ -4 Fl{PS}{CP YA add US E pop}ie null]
 /Dest DN ST cvs cvn /DEST pdfmark} D
/C {ND 1 eq{1 sub}if TI mul /XO E D NL Nf not{pop()}if 0 3 -1 roll 1 A} D
/OP {BP not{NP}if PN 2 mod 0 eq{NP}if}D
/Ep {Xp PN 2 mod 0 eq and OU and{/Pn (-) D showpage /PM 1 D LA}if}D
/Dg [73 86 88 76 67 68 77] D
/Rd [0 [1 1 0][2 1 0][3 1 0][2 1 1][1 1 1][2 2 1][3 3 1][4 4 1][2 1 2]] D
/Ns {/m E D /c E 32 mul D /j m 1000 idiv D /p j 12 add string D
 c 96 le m 0 gt and{c 32 le {/i 0 D /d 77 D /l 100 D /m m j 1000 mul sub D
  j -1 1 {pop p i d c add put /i i 1 add D}for
  4 -2 0 {/j E D /n m l idiv D /m m n l mul sub D /d Dg j get D
   n 0 gt {/x Rd n get D x 0 get -1 1 {pop p i d c add put /i i 1 add D}for
   p i x 1 get sub Dg x 2 get j add get c add put}if /l l 10 idiv D
  }for p 0 i GI}
  {/i ST length 1 sub D m {1 sub dup 0 ge{dup 26 mod c add 1 add
   ST i 3 -1 roll put 26 idiv dup 0 eq{pop exit}if}if /i i 1 sub D}loop
   ST i ST length i sub GI}ie}
 {m p cvs}ie} D
/US {matrix currentmatrix matrix defaultmatrix matrix invertmatrix
 matrix concatmatrix transform} D
/GB {Gb{US}if}D
/Tl {/Rn E D Xc CP pop ne{
 [/Rect [Xc 1 sub Yc cS 0.25 mul sub GB CP E 1 add E cS 0.85 mul add GB]
  /Subtype /Link /Border [0 0 Cf Lc and LX and AU or{0}{1}ie] Rn type
  /nametype eq {/Dest Rn}{/Action [/Subtype /URI /URI Rn] Cd}ie
  /ANN pdfmark}if} D
/Il {/Rn E D [/Rect [Xc Yc GB Xc XS add Yc YS add GB] /Subtype /Link
 /Border [0 0 0] Rn type /nametype eq{/Dest Rn}
 {/Action [/Subtype /URI /URI Rn] Cd}ie /ANN pdfmark} D
/XP {[{/Z Bz 2 div D Z 0 R Z Z RL Z neg Z RL Z neg Z neg RL Z Z neg RL
 Fi cH 1 eq and{fill}if} {Bz 0 RL 0 Bz RL Bz neg 0 RL 0 Bz neg RL
 Fi cH 1 eq and{fill}if} {0 -5 R Bz 0 RL 0 21 RL Bz neg 0 RL 0 -21 RL}]} D
/MS {/Sm E D WB}D
/O {BN()Sm BX} D
/BX {/Bt E D Bt 2 lt{/Ch E D CS 0.8 mul}{11 mul}ie W XO sub MR sub
 2 copy gt{E}if pop /HZ E D Bt 2 eq{Fi not{pop()}if ( )E join /Ft E D TT
 /PF t D /MW 1 D /Li 1 D /Fw Ft SW pop D Fw HZ gt{/HZ Fw 8 add D}if
 HZ ST cvs( )join}{WB Ch ST cvs( )join}ie L1 HZ add XO add MR add W gt{NL}if
 Bt 2 eq{Ft ES Fw neg HM{CS sub}if Pd}if Bt ST cvs join( Bx )join
 Bt 2 eq HM and{CS Pd}if C1 E join /C1 E D /L1 L1 HZ add D /T f D
 ( ) Pd /PF f D Bt 2 lt{YA CS .8 mul lt{/YA CS .8 mul D}if}
 {YB 5 lt{/YB 5 D}if YA 21 lt{/YA 21 D}if}ie /CI 0 D} D
/Bx {dup 2 eq{E /Bz E D}{E /cH E D /Bz CS .8 mul D}ie
 OU {gsave 0 Sg XP E get exec stroke grestore}{pop}ie Bz 0 R /Ms t D}D
/SD {FD 4 mul Dy add DZ NF newpath 0 0 M DX t charpath pathbbox
 3 -1 roll sub /DY E D E dup /X1 E D sub WM mul WX DY mul add WM DG mul E div
 /DF E D /DR WX DF mul DY mul WM div 2 div D} d
/Sd {gsave 0 IL Di mul neg translate IL IW atan Di 0 eq{neg}if rotate
 FD 4 mul Dy add DZ NF DR X1 sub DY 2 div neg M cD VC DX show grestore} d
/Pt {/tp t D Tp{NP /Pn (TP) D 0 Tt neg R Th BN NP Ep ET RC ZF}if /tp f D} D
/RC {/AI 0 D /LG 0 D /BC 0 D /UI 0 D /PF f D /Cc 0 D /cC 0 D /Dc 10 array D
 /NR [0 1 9{pop 0}for] D /La Ds D /AR 10 array D /TR 10 array D /AV 30 array D
 SI /AL -1 D /AT A0 D AT NA /OV 9 array D /Yo 0 D /Co 0 D /Io 0 D /Hy f D
 /Ph f D /CL -1 D Ct Sc}D
/ZF {/FR [0 1 30{pop 0}for] D /SZ [0 1 30{pop 0}for] D /FO [0 1 30{pop 0}for] D
 /SL 0 D /CF 0 D /FN 0 D 0 Ts SF}D
/QO [[($qo)][($qo2)]] D
/QC [[($qc)][($qc2)]] D
/Hf EF length 2 sub D
/Hz EZ Hf get D
/HS Ey Hf get D
/Fz EZ Hf 1 add get D
/Fs Ey Hf 1 add get D
/LE IL D
/Ps EZ 1 get D
/Fp EF 1 get D
/XO 0 D
/YI 0 D
/CI 0 D
/FP 0 D
/WW Ts 7 mul D
/Mf 0 D
/YA 0 D
/YB 0 D
/Cs Ts D
/GS Ts D
/F0 0 D
/NS 0 D
/NB 0 D
/N 0 D
/C0 [] D
/C1 () D
/Lo 0 D
/L1 0 D
/LM 0 D
/PH 0 D
/EC 0 D
/Lh 0 D
/LT 0 D
/CH 1 string D
/ST 16 string D
/CA 9 array D
/HC (\\255) D
/HM f D
/PF f D
/EN f D
/TB f D
/UF f D
/sF f D
/AE f D
/AF f D
/BP t D
/CD f D
/PA t D
/GL f D
/T t D
/HF f D
/AH f D
/SA f D
/PB f D
/f1 f D
/mF f D
/OX 0 D
/OY 0 D
/FY 0 D
/EO 0 D
/FB 0 D
/PL 0 D
/Bw 0 D
/PD -1 D
/TP f D
/tp f D
/TH $th D
/Ty 4 D
/Tn -1 D
/Fl t D
/LB t D
/PM 1 D
/Ms f D
/Ba f D
/Bb f D
/Hl 3 D
/hl 6 D
/Hv 6 D
/Hs f D
/HI 0 D
/hi 0 D
/PO t D
/TE f D
/LF t D
/BO 0 D
/Sm 1 D
/Bf 3 D
/A1 0 D
/A2 0 D
/Ds $lid{'en'} D
/QL -1 D
/Cb Db D
/Ct Dt D
/Cl Dl D
EOT

$tbl=<<EOT;
/TS {
 tables E get /table E D
 table aload pop /rdesc E D /cdesc E D /tdesc E D
 tdesc aload pop /capalg E D /caption E D /rules E D /frame E D /nfoot E D
  /nhead E D /ncol E D /nrow E D /border E D /twid E D /units E D /talign E D
  /flow E D /clear E D /tclass E D pop pop
 /w W D /eps 0.1 D /OU f D /PL 1 D
 /FN EF 21 get D EZ 21 get Ey 21 get FS
 0 1 1{
  /pass E D
  0 1 nrow{
   /irow E D
   /cells rdesc irow get 6 get D
   0 1 ncol{
    /icol E D
    /cell cells icol get D
    cell 0 ne{
     cell aload pop /ang E D /CB E D pop pop pop
     /DV E D /bot E D /top E D /right E D /left E D /nowrap E D /valign E D
     /dp E D /align E D /rspan E D /cspan E D /cclass E D /ctype E D /cmax E D
     /cmin E D /proc E D
     rspan 0 eq{/rspan nrow irow sub 1 add D}if
     cspan 0 eq{/cspan ncol icol sub 1 add D}if
     pass 0 eq cspan 1 eq and pass 1 eq cspan 1 gt and or{
      /W 1e5 D /LL W D /PH 1 D
      ctype 1 eq{() BD}if
      RC align NA
      AT 4 eq{/CD t D /DC dp D /LN 0 D /M1 0 D /M2 0 D}{/CD f D}ie
      0 0 M /LM 0 D proc exec BN
      AT 4 eq{
       LN array astore cell 15 3 -1 roll put
       cdesc icol get dup dup 5 get M1 lt{5 M1 put}{5 get /M1 E D}ie
       dup 6 get M2 lt{6 M2 put}{6 get /M2 E D}ie
       /LM M1 M2 add D
      }if
      /CD f D
      ang 0 ne{/LM CP E pop neg D}if
      /thiswid LM left add right add eps add D
      /oldmin 0 D /oldmax 0 D
      0 1 cspan 1 sub{
       icol add cdesc E get dup 2 get /oldmax E oldmax add D
       1 get /oldmin E oldmin add D
      }for
      thiswid oldmax ge{
       0 1 cspan 1 sub{
        icol add cdesc E get dup 2 E 2 get oldmax 0 eq
         {pop thiswid cspan div}{thiswid mul oldmax div}ie
        put
       }for
      }if
      nowrap 1 eq{
       thiswid oldmin ge{
        0 1 cspan 1 sub{
         icol add cdesc E get dup 1 E 1 get oldmin 0 eq
          {pop thiswid cspan div}{thiswid mul oldmin div}ie
         put
        }for
       }if
      }{
       /W 0 D /LL W D /PH 2 D
       ctype 1 eq{() ES () BD}if
       0 0 M /LM 0 D RC proc exec BN
       /thiswid LM left add right add eps add D
       thiswid oldmin ge{
        0 1 cspan 1 sub{
         icol add cdesc E get dup 1 E 1 get oldmin 0 eq
          {pop thiswid cspan div}{thiswid mul oldmin div}ie
         put
        }for
       }if
      }ie
      ctype 1 eq{() ES}if
     }if
    }if
   }for
  }for
 }for
 /tmin 0 D /tmax 0 D
 0 1 ncol{
  cdesc E get dup 1 get E 2 get 2 copy gt{pop dup}if
  tmax add /tmax E D tmin add /tmin E D
 }for
 twid 0 lt{twid neg IW gt{IW neg}{twid}ie /twid E D}if
 tdesc 0 twid neg tmin 2 copy lt{E}if pop put
 tdesc 1 twid neg tmax 2 copy lt{E}if pop put
 /W w D /LL W D /OU t D /PH 0 D /PL 0 D
} D
/PT {
 /PL PL 1 add D
 tables E get /table E D Tm 21 get Ts mul BE
 PL 2 ge{save}if
 /SL SL 1 add D /FN EF 21 get D EZ 21 get Ey 21 get FS
 table aload pop /rdesc E D /cdesc E D /tdesc E D
 tdesc aload pop /capalg E D /caption E D /rules E D /frame E D /nfoot E D
  /nhead E D /ncol E D /nrow E D /border E D /twid E D /units E D /talign E D
  /flow E D /clear E D /tclass E D /tmax E D /tmin E D
 /w W D /xo XO D /mr MR D /ll LL D /lg LG D /ai AI D /bc BC D /nr NR D /ar AR D
 /tr TR D /ui UI D /ph PH D /a0 A0 D /pf PF D /at AT D /av AV D /al AL D
 /Le LE D /la La D
 talign 0 lt{/talign AL 0 gt{AV AL get}{A0 2 le{A0}{0}ie}ie D}if
 ph 1 eq ph 2 eq or{
  NL ph 1 eq{tmax}{tmin}ie dup XO add LM gt{/LM E XO add D}{pop}ie LM E
 }{
  /PH 3 D /LE 1e5 D RC %ZF
  border 0 gt{/border 1 D}if
  /twidth 0 D /avail W xo sub D
  twid 0 eq{0 1 ncol{cdesc E get dup 2 get E 3 get dup 0 gt{div neg dup twid lt
   {/twid E D}{pop}ie}{pop pop}ie}for}if
  /twid twid dup 0 lt{neg avail 2 copy gt{E}if pop}{avail mul}ie D
  /OK t D 0 1 ncol{cdesc E get dup 1 get E 3 get twid mul gt{/OK f D}if}for
  0 1 ncol{
   cdesc E get dup 1 get /colmin E D dup 3 get /cwid E twid mul D dup
   tmax avail le{2 get}if
   tmin avail le tmax avail gt and{
    dup 2 get E 1 get dup 3 1 roll sub avail tmin sub mul tmax tmin sub div add
   }if
   tmin avail gt{1 get}if
   0 E colmin cwid lt OK and{pop cwid}if dup /twidth E twidth add D put
  }for
  /OU f D CP
  tmin twid le{
   0 1 ncol{cdesc E get dup 0 get twidth div twid mul 0 E put}for
   /twidth twid D
  }if
  CP printcap CP E pop sub /caphig E D pop
  0 1 1{
   /pass E D
   0 1 nrow{
    /irow E D
    /cells rdesc irow get 6 get D
    0 1 ncol{
     /icol E D
     /cell cells icol get D
     cell 0 ne{
      cell aload pop /ang E D /CB E D pop pop pop
      /DV E D /bot E D /top E D /right E D /left E D /nowrap E D /valign E D
      /dp E D /align E D /rspan E D /cspan E D /cclass E D /ctype E D /cmax E D
      /cmin E D /proc E D
      rspan 0 eq{/rspan nrow irow sub 1 add D}if
      cspan 0 eq{/cspan ncol icol sub 1 add D}if
      /W 0 D
      0 1 cspan 1 sub{icol add cdesc E get 0 get /W E W add D}for
      pass 0 eq rspan 1 eq and pass 1 eq rspan 1 gt and or{
       ctype 1 eq{() BD}if
       /W W left sub right sub D /XO 0 D /EO 0 D SI
       /A0 align D RC align NA
       AT 4 eq{
        /DC dp D /DO 0 D /ID 1 D
        0 1 DV length 1 sub{DV E get dup DO gt{/DO E D}{pop}ie}for
        /Lo DO DV 0 get sub D /L1 Lo D
       }if
       0 0 M /BP t D /Fl t D /MF 0 D /FB 0 D
       proc exec T not{/CI 0 D}if BN 0 FB neg R MF 0 eq{/MF CS D}if
       CP /thishig E neg bot add top add CI add D pop
       ang 0 ne{/thishig LM bot add top add D}if
       cell 16 MF put cell 17 Ya put cell 18 thishig put
       valign 4 eq{
        /below thishig Ya sub D
        rdesc irow get dup dup 4 get Ya lt
         {4 Ya put}{4 get /Ya E D}ie
        dup 5 get below lt{5 below put}{5 get /below E D}ie
        /thishig Ya below add D
       }if
       ctype 1 eq{()ES}if
       /oldhig 0 D
       0 1 rspan 1 sub{
        irow add rdesc E get 0 get /oldhig E oldhig add D
       }for
       thishig oldhig ge{
        0 1 rspan 1 sub{
         irow add rdesc E get dup 0 E 0 get oldhig 0 eq
          {pop thishig rspan div}{thishig mul oldhig div}ie
         put
        }for
       }if
      }if
     }if
    }for
   }for
  }for M RC %ZF
  /thight 0 D /racc 0 D /maxh 0 D /brk 0 D /rbeg nhead nfoot add D
  rbeg 1 nrow{
   rdesc E get dup 0 get dup /thight E thight add D
   brk 0 eq{/racc E D}{/racc E racc add D}ie
   racc maxh gt{/maxh racc D}if 2 get /brk E D
  }for
  ph 3 ge{thight caphig add E}if
  ph 0 eq ph 4 eq or{
   /PH 4 D /LE Le D /OU Ou D /yoff 0 D /headsz 0 D
   0 1 nhead 1 sub{rdesc E get 0 get headsz add /headsz E D}for
   /footsz 0 D
   0 1 nfoot 1 sub{rdesc E nhead add get 0 get footsz add /footsz E D}for
   /ahig LE BO add MI add D /maxh maxh headsz add footsz add D
   /thight thight headsz add footsz add D
   tmin avail gt maxh ahig gt or
    {/Sf avail tmin div dup ahig maxh div gt{pop ahig maxh div}if D /SA t D}
    {/Sf 1 D}ie
   tclass 1 eq thight LE 15 sub gt and
    {/SA t D LE 15 sub thight div dup Sf lt{/Sf E D}{pop}ie}if
   SA{Sf Sf scale /ll ll Sf div D /xo xo Sf div D /LE LE Sf div D
    /mr mr Sf div D /BO BO Sf div D /ahig ahig Sf div D}if
   nhead nfoot add getwid
   LE CP E pop add capalg 0 eq{caphig sub}if
   bT{f}{dup thight lt thight ahig lt and}ie
   E headsz sub footsz sub rwid lt or{NP}if
   capalg 0 eq{printcap -8 SP}if
   CP /ycur E D pop
   printhead
   rbeg 1 nrow{/row E D row
    getwid
    ycur yoff add rwid sub footsz sub LE add 0 lt
    {nfoot 0 gt{printfoot}if Tf NP /rbeg irow1 D
     Ba{MI /MI MI SA{Sf div}if D MI SP /MI E D}if
     CP /ycur E D pop /yoff 0 D printhead}if
    irow1 printrow
   }for
   printfoot /row row 1 add D Tf
   0 ycur yoff add M
   capalg 1 eq{/EO 0 D SI -3 SP printcap}if
   Sf 1 lt{1 Sf div dup scale /ll ll Sf mul D /xo xo Sf mul D /LE LE Sf mul D
    /mr mr Sf mul D /BO BO Sf mul D /SA f D}if
   /EO 0 D
  }if
 }ie
 /W w D /XO xo D /MR mr D /LL ll D /LG lg D /AI ai D /BC bc D /NR nr D /AR ar D
 /TR tr D /UI ui D /PH ph D /A0 a0 D /PF pf D /AT at D /AV av D /AL al D
 /La la D
 /SL SL 1 sub NN D /CF 0 D /FN 0 D SZ SL get FR SL get FS Wf not{()F2}if
 PL 2 ge{Ms E restore Ms or /Ms E D PH 1 eq PH 2 eq or
  {/LM E D}if PH 3 ge{/CI 0 D NL 0 E neg R}if
 }if
 /PL PL 1 sub D /CI 0 D /BP f D /PO f D () Bm 21 get Ts mul BE BL %CF CS SF
} D
/printcap{
 capalg 0 ge{
  SA{/W w Sf div D}
   {talign 1 eq{/XO xo ll twidth sub 2 div add D}if
    talign 2 eq{/XO xo ll twidth sub add D}if
    /W XO twidth add D
   }ie /XO xo D /LL W XO sub MR sub D
  /PA f D /Fl capalg 0 eq D
  1 NA BL caption exec BN OA /PA t D
 }if
} D
/getwid{
 /irow1 E D
 /irow2 irow1 D
 /rwid 0 D
 {rdesc irow2 get dup 0 get rwid add /rwid E D 2 get 0 eq
  {exit}{/irow2 irow2 1 add D}ie
 }loop
} D
/printrow{
 /xoff ll twidth PL 2 ge{Sf div}if sub talign mul 2 div D
 /xleft xoff xo add D
 /irow E D
 /cells rdesc irow get 6 get D
 0 1 ncol{
  /icol E D
  /cell cells icol get D
  cell 0 ne{
   cell aload pop /ang E D /CB E D /cvsize E D /above E D /fontsz E D
   /DV E D /bot E D /top E D /right E D /left E D /nowrap E D /valign E D
   /dp E D /align E D /rspan E D /cspan E D /cclass E D /ctype E D /cmax E D
   /cmin E D /proc E D
   rspan 0 eq{/rspan nrow irow sub 1 add D}if
   cspan 0 eq{/cspan ncol icol sub 1 add D}if
   /width 0 D
   0 1 cspan 1 sub{icol add cdesc E get 0 get /width E width add D}for
   /rhight rdesc irow get 0 get D
   /hight rhight D
   1 1 rspan 1 sub{irow add rdesc E get 0 get /hight E hight add D}for
   /W xo xoff add width add right sub D
   ang 0 ne{/W xo xoff add hight add right sub D}if
   /EO xo xoff add left add D SI
   Cf{
    gsave CB VC xo xoff add ycur yoff add M
    0 hight neg RL width 0 RL 0 hight RL width neg 0 RL fill
    grestore
   }if
   ctype 1 eq{() BD}if
   /A0 align D RC
   AT 4 eq{
    /DC dp D /ID 1 D /DO cdesc icol get 5 get D /Lo DO DV 0 get sub D /L1 Lo D
   }if
   ang 0 ne{
    gsave ang 90 eq
     {xoff ycur add hight cvsize sub 2 div sub ycur hight sub xoff sub}
     {xoff ycur sub width add hight cvsize sub 2 div add ycur xoff add}ie
    translate ang rotate
   }if
   valign 3 le{0 ycur yoff add top sub
    hight cvsize sub valign 1 sub mul 2 div sub M}
   {0 ycur yoff add top sub above add rdesc irow get 4 get sub M}ie
   /PA f D /BP t D /Fl t D
   BL proc exec BN
   ang 0 ne{grestore}if
   /PA t D
   ctype 1 eq{() ES}if
  }if
  /xoff xoff cdesc icol get 0 get add D
 }for
 /yoff yoff rhight sub D
} D
/printhead {0 1 nhead 1 sub{printrow}for} D
/printfoot {nhead 1 nhead nfoot add 1 sub{printrow}for} D
/Tf {
 OU{rules 2 ge{/yoff 0 D
   gsave 0 Sg
   [0 1 nhead 1 sub{}for rbeg 1 row 1 sub{}for nhead 1 nhead nfoot add 1 sub{}for]{
    /irow E D
    /xoff ll twidth PL 2 ge{Sf div}if sub talign mul 2 div D
    /cells rdesc irow get 6 get D
    0 1 ncol{
     /icol E D
     /cell cells icol get D
     cell 0 ne{
      /rspan cell 6 get D
      /cspan cell 5 get D
      rspan 0 eq{/rspan nrow irow sub 1 add D}if
      cspan 0 eq{/cspan ncol icol sub 1 add D}if
      /width 0 D
      0 1 cspan 1 sub{icol add cdesc E get 0 get /width E width add D}for
      /rhight rdesc irow get 0 get D
      /hight rhight D
      1 1 rspan 1 sub{irow add rdesc E get 0 get /hight E hight add D}for
      xo xoff add width add ycur yoff add M
      0 hight neg icol cspan add 1 sub ncol lt
       {cdesc icol 1 add get 4 get dup rules 3 le{1 eq}{pop t}ie
        {1 eq{0.8}{0.3}ie
        LW RL CP stroke M}{pop R}ie}{R}ie
      irow nhead nfoot add 1 sub ne nfoot 0 eq or
       {irow rspan add 1 sub nrow lt
       {rdesc irow rspan add get 3 get}{nfoot 0 eq{0}{1}ie}ie
       dup rules 2 mod 0 eq{1 eq}{pop t}ie
       {1 eq irow rspan add nhead eq or irow rspan add row eq nfoot 0 gt and or
        {0.8}{0.3}ie LW width neg 0 RL CP stroke M}{pop}ie}if
     }if
     /xoff xoff cdesc icol get 0 get add D
    }for
    /yoff yoff rhight sub D
   }forall
   grestore
   /Ms t D
  }if
  frame 1 gt{
   gsave
   1 LW 0 Sg
   xleft ycur M CP BB
   0 yoff frame 5 eq frame 7 ge or{RL}{R}ie
   twidth 0 frame 3 eq frame 4 eq or frame 8 ge or{RL}{R}ie CP BB
   0 yoff neg frame 6 ge{RL}{R}ie
   twidth neg 0 frame 2 eq frame 4 eq or frame 8 ge or{RL}{R}ie
   closepath stroke
   grestore
   /Ms t D
  }if
 }if
} D
EOT

&openps if($opt_o);
$ntab=-1;
$tables="/tables [";
@docs=$#ARGV<0?("-"):@ARGV;
if($tocdoc) {$#docs=0};
for (@docs) {$levl{$_}=1};
$nref=0;
$nhd=0;
$nlnk=1;
$ndoc=0;
$nrem=0;
$toc=$first?"Pt\n":"";
$toc.="/BO 0 D TC /Ba f D Bs /AU f D /UR () D RC ZF\n";
$toc.="()F2" if(!$latin1);
$toc.="tH WB\n" if(!$tocdoc);
$fl1="";
$fl2="";
$np="NP RC ZF";
$P3="";
while($html=shift @docs) {
  $ndoc++;
  $ba2="";
  $P2="(";
  $banner="";
  undef @links;
  $level=$levl{$html};
  if(&h2p) {
    if($ndoc==1) {
      $toc=~s/\$T/$ti/g;
      $toc=~s/\$A/$au/g;
      $toc=~s/[\200-\377]+/)F1($&)F2(/g if(!$latin1);
    }
    if($layer) {
      @docs=(@docs,@links);
    } else {
      @docs=(@links,@docs);
    }
    $rem=$#docs+1;
    if($rem && $opt_W) {
      &dbg("At least $rem document".($rem>1?"s":"")." remaining\n");
    }
    if($banner) {
      $_="/Ba t D /BA {($banner)BN} D\nBs f Pb CP /BO E D pop\n";
      &Subst($_);
      s/  H\(/ -1 H(/g;
    } else {
      $_="/Ba f D /BO 0 D Bs";
    }
    if($tocdoc && $first && $ndoc==1) {
      $TC=" TC\n";
      $et=" NP Ep ET /Tc f D";
    } else {
      $TC="";
      $et="";
    }
    $_.="\n/UR ($html) D\n/Ti ($ti) D\n/Au ($au) D\n/Df $draft D\n/ME [";
    for $i (sort {$metarc{$a} <=> $metarc{$b}} keys %metarc){
      $_.="($meta{$i})";
    }
    $_.="] D\n$TC";
    if($ndoc==1) {$top=$_};
    if(!$tocdoc) {
      $toc.="ND 1 gt{Ts 3 mul Np $refs{$html}()0 C()BD($ti)ES()$refs{$html}"
           ." 1 TN()EA()BN}if\n";
    }
    $hv=0;
    while($P2=~s/(\d) (\d)  H\(([^\s<)]*)/$1 $2 $nhd H($3)WB $nref Sn(/) {
      $nhd++;
      if($hv+1<$2) {
        for($hv+1..$2-1) {
          push(@z1,-$nref);
          push(@z2,$_);
        }
      }
      $hv=$2;
      $hind[$hv-1]++;
      for $i ($hv..5) {$hind[$i]=0};
      $hind=join('.',@hind[0..$hv-1]);
      $hst=$3;
      $'=~/\)EH/;
      ($htxt=$hst.$`)=~s/\)EA\(//g;
      if(!$tocdoc) {
        $toc.="$hv NH le{$nref($hind\\020\\020)$hv C($htxt)$nref 1 TN()EA()BN}if\n";
      }
      push(@z1,$nref);
      push(@z2,$hv);
      $nref++;
      $htxt=~s/(\s+|\)BR\()/ /g;
      $htxt=~s/(^\s+|\)[^(]*\(|\s+$)//g;
      $htxt="" if(!$latin1);
# GB/STAS: Added to allow balanced parens inside ToC headers
      while ($htxt =~ s/\\201(.*?)\\202/\($1\)/g) {};
      $dh.="/h$nhd [($hind\\020\\020)($htxt)] D\n";
    }
    if($tocdoc) {
      if($ndoc==1 && !$first) {
        $toc="TC RC ZF $_ $P2 WB () BN\n";
        $P2="";
        $P3="";
        $np="";
        $_="";
      }
    }
    $P3.="$fl1\n/Cb $bg D /Ct $tcol D /Cl $lcol D /CL -1 D Ct Sc\n";
    if($ndoc==1 && !$first) {$P3.="Pt\n"};
    $P3.="$fl2\n$_\n$np\n$P2";
    if($tocdoc && $ndoc==1 && !$first) {
      $np="/Cb $bg D NP RC ZF";
    } else {
      $fl1="WB NL$et";
      $fl2="DS";
      $np="0 BO R";
    }
  }
}

$P3.=($P3!~/\)\s*$/?"()":"")."WB NL";
if(!$tocdoc && $first && $nhd){$P3="$toc/OU t D /Cb $bg D NP Ep ET $P3"};
if(!$first && ($tocdoc || !$tocdoc && $nhd)){$P3.=" $toc"};

if($ntab>=0) {
  $_="$tables] D";
  &ack($_);
  y/\t\f/ /;
  s/[\200-\377]/sprintf("\\%3.3o",ord($&))/eg;
  s/\)XX/)9 9 PR/g;
  s/  H\(/ -1 H(/g;
  $tables=$_;
}
$_="%!PS\n%%Title: $title\n$P0$P1";
if($nimg>=0) {
  $_.="/AX [".join(' ',@XS)."] D\n/AY [".join(' ',@YS)."] D\n"
     ."/IX [".join(' ',@IX)."] D\n/IT [".join(' ',@IT)."] D\n";
  if($nm>=0) {
    $_.="/AZ [".join(' ',@DP)."] D\n/WS [".join(' ',@WS)."] D\n"
       ."/FC [".join(' ',@FC)."] D\n/NI $nm D\n/BM ".($nm+1)." array D\nSB\n";
    for $i (0..$nm) {$_.="$BM[$i]\n\n"}
  }
  $_.="\n$pv%Endpv\n" if($nps);
}
@kw=split(/[, ]+/,$kw);
@Kw=();
for $i (@kw){push(@Kw,$i) if(!grep(/^$i$/,@Kw))};
$kw=join(', ',@Kw);
for $i (0..$#z2) {
  $n=0;
  $j=$i;
  while($j++<=$#z2 && $z2[$j]>$z2[$i]) {$n++ if($z2[$j]==$z2[$i]+1)};
  push(@z3,$n);
}
$tdef=$ntab>=0?"$tbl$tables\n0 1 $ntab\{TS}for RC ZF\n":"";
$hd="/Hr [@z1]D\n/HV [@z2]D\n/Cn [@z3]D";
&cut($hd);
if($gd) {
  $sd="/Df t D /DG IW IW mul IL IL mul add sqrt D IW IL IW IL lt{E}if"
  ." /WM E D /WX E D /DZ 180 D gsave SD /DZ DZ DF mul D SD grestore\n";
} else {
  $sd="/Df f D\n";
}
$_.=<<EOD;
[/Creator ($version) /Author ($Au) /Keywords ($kw) /Subject ($su)
 /Title ($title) /DOCINFO pdfmark
/ND $ndoc D
/HN [1 1 $nref\{pop (??)}for] D
$dh$hd
Hr length 0 gt{[/PageMode /UseOutlines /DOCVIEW pdfmark}if
/Hn 1 D
0 1 Hr length 1 sub{
 /Bn E D [Cn Bn get dup 0 gt{/Count E HV Bn get Bl ge{neg}if}{pop}ie
 /Dest Hr Bn get dup abs ST cvs cvn E 0 ge{(h)Hn ST cvs join cvx exec
 dup 1 get E Nf{0 get E join}{pop}ie /Hn Hn 1 add D}{()}ie
 /Title E dup length 255 gt{0 255 getinterval}if /OUT pdfmark}for
ZF /FN Fp D Ps 0 FS /WC Wf{( )}{<A1A1>}ie SW pop D
ET RC ZF
$sd$rfs$tdef$top$P3
/TE t D NP TU PM 0 eq and{/Pn () D showpage}if end restore
EOD

if(($first || $opt_R) && $xref{'passes'}) {
  &dbg("Inserting cross references\n") if($opt_d);
  for $i (1..$xref{'passes'}) {&ref};
}
&fin;

sub h2p {
  if($html eq '-') {
    $_=<>;
  } elsif($html=~m|://|) {
    if(($prompt || $nrem>50) && $level>1) {
      &prompt("Retrieve document $html (y/n/q)? ",$ans);
      if($ans=~/q/i) {undef @docs};
      return 0 unless($ans=~/y/i);
    }
    &geturl($html,$_) || return;
    $nrem++;
    if($contyp!~m|text/html|i) {$_=" <plaintext>\n$_"};
    unless(($ba2)=$html=~m|(.*://.*/)|) {$ba2=$html."/"};
  } else {
    if(open(FILE,$html)) {
      &dbg("Reading $html\n") if($opt_W || $opt_d);
      $_=<FILE>;
      if(!/<HTML/i && $html!~/html?$/i && ($html!~/\.ps$/i || $ndoc>1)) {
        $_=" <plaintext>\n$_";
      }
      close FILE;
      $var{DOCUMENT_NAME}=$html;
      if($posix) {
        $var{LAST_MODIFIED}=POSIX::strftime("%c",localtime((stat $html)[9]));
        $var{DATE_LOCAL}=POSIX::strftime("%c",@now);
        $var{DATE_GMT}=POSIX::strftime("%c",@gmnow);
      }  
      $mod=(stat $html)[9];
    } else {
      &dbg("*** Error opening $html\n");
      return 0;
    }
  }

  if(/^%!/ && /$delim/) {
    $psin=1;
    &openps if($opt_o);
    $_=$P0.$';
    for $s ("b","c","cw","g","t") {
      &dbg("Option -$s ignored\n") if(eval "\$opt_$s");
    }
    &fin;
  }

  &hb($_,$head);
  $head=~/<title$R\s*([\w\W]*)<\/title/i;
  ($ti=$2)=~s/\s+/ /g;
  $ti=$doctit{$html} if(!$ti);
  $ti=~s/\s*$//g;
  &spec($ti);
  &ent($ti);
  $ti="<Untitled>" if(!$ti);
  $title=$ti if(!$title);
  $draft="f" if(!$ddr);
  %meta=();
  $au="";
  while($head=~/<meta\s[^>]*(name|http-equiv)\s*=\s*["']?\s*(\w+)$R/gi) {
    $k=lc $2;
    ($v)=$&=~/content\s*=\s*["']\s*([^"']+)/i;
    $v=~s/\s+/ /g;
    $v=~s/\s*$//g;
    &spec($v);
    &ent($v);
    $meta{$k}=$v;
    if($k=~/author/) {$au=$au?"$au, $v":$v};
    if($k=~/keywords/) {$kw=$kw?"$kw, $v":$v};
    if($k=~/subject/ && !$su) {$su=$v};
    if(!$ddr && $k=~/status/ && $v=~/draft/i) {$draft="t";$gd=1};
  }
  $Au.=($Au?" + ":"").$au if($au);
  $b2=$opt_b;
  unless($b2) {
    ($b2)=$head=~/<base\s+href\s*=\s*"([^"]*)"$R/i;
    unless($b2) {($b2)=$head=~/<base\s+href\s*=\s*([\w\.-]+)$R/i}
    unless($b2) {$b2=$ba2}
  }
  $b2=~s|[^/]*$||;
  ($b1)=$b2=~m|(.*://[^/]*)/|;
  unless($b1) {$b1=$opt_r};
  unless($b2) {$b2=$html=~m|(.*/)[^/]*$|?$1:""};
  if(!defined $B2) {$B2=$b2};
  $levl{$b2.$html}=$levl{$html};

  while($link && $head=~/<link\s+[^>]*rel\s*=\s*["']?next$R/gi) {
    if(($lnk)=$&=~/href\s*=\s*["']?\s*([^"' >]*)/gi) {
      if($lnk=~m|.+//[^/]+$|) {$lnk=$&."/"}
      if($lnk=~m|://|) {
        $rlnk=0;
      } else {
        $rlnk=1;
        if($lnk=~m|^/|) {$lnk=$b1.$lnk} else {$lnk=$b2.$lnk}
      }
      while($lnk!~m|^\.\./| && $lnk=~m|[^/]*/\.\./|) {$lnk=$`.$'};
      $lnk=~s|/\./|/|g;
      if(&follow && !$levl{$lnk}) {
        $levl{$lnk}=$level+1;
        push(@links,$lnk);
      }
    }
  }
  ($battr)=/<BODY$R/i;
  ($lang)=$battr=~/\slang\s*=\s*['"]?([a-zA-Z-]+)/i;
  ($lang)=$head=~/<html[^>]+lang\s*=\s*['"]?([a-zA-Z-]+)/i if(!$lang);
  $lang=$opt_l if($opt_l);
  $lang='en' if(!$lang);
  $lang=lc $lang;
  if($battr=~/\stext\s*=\s*['"]?\s*#?(\w+)/i) {$tcol=&col2rgb($1)};
  if(!$tcol) {$tcol="Dt"};
  if($battr=~/\slink\s*=\s*['"]?\s*#?(\w+)/i) {$lcol=&col2rgb($1)};
  if(!$lcol) {$lcol="Dl"};
  &inihyph if($opt_H);
  ($bg)=$battr=~/BGCOLOR\s*=\s*["']?\s*#?(\w+)/i;
  $bg=&col2rgb($bg);
  if($bg) {
    ($red,$grn,$blu)=@cvec;
  } else {
    ($red,$grn,$blu)=$bgcol=~/#(\w+).*#(\w+).*#(\w+)/;
    $bg="Db";
  }

  $temp="";
  while(/<object$R/i) {
    $temp.=$`;
    $tag=$&;
    $end=$';
    $type=$tag=~/type\s*=\s*($S)/i?$+:"";
    $uaddr=$tag=~/data\s*=\s*($S)/i?$+:"";
    if($type=~/^text\/(html|plain)$/i
     || !$type && $uaddr=~m"(\.html?|://.+/|://[^/]+)$"i) {
      $tag=~/data\s*=\s*/i;
      if(&open($uaddr,$idoc)) {
        if($type=~/plain/i) {
          $idoc="<XMP>$idoc</XMP>";
        } else {
          &hb($idoc,$dum);
        }
        $_=$idoc;
        $_.=$' if($end=~/<\/object>/i);
      } else {
        &dbg("\n*** Error opening $uaddr\n");
        $_=$end;
      }
    } else {
      $temp.=$tag;
      $_=$end;
    }
  }
  $_=$temp.$_;

  if($opt_c && defined $package{'check'}) {
    $file=$html;
    if($html=~m|://|) {
      open(SCRATCH,">$scr");
      print SCRATCH;
      close SCRATCH;
      $file="$scr";
    }
    &dbg(`$package{'check'} $file`);
  }

  if(!$latin1) {
    if($opt_e=~/EUC-/i) {
      s/([\216\217\241-\376].)+/\000$&\000/g;
      &spec($_);
      s/\000(.+?)\000/)F1($1)F2(/g;
    } elsif($opt_e=~/SHIFT-JIS/i) {
      s/[\201-\237\340-\374][@-~\200-\374]/$&\000/g;
      s/[\241-\337]+(?!\000)/$&\000/g;
      s/[ -~\t\n\r\240]+(?!\000)/\002$&\001/g;
      &spec($_);
      s/\000//g;
    } else {
      while(/\e\$B([^\e]*)/) {
        $beg=$`;
        $end=$';
        $mat=$1;
        $mat=~s/\s//g;
        $_="$beg\001$mat$end";
      }
      s/\e\([BJ]/\002/g;
      &spec($_);
    }
    s/\001/)F1(/g;
    s/\002/)F2(/g;
    $_=")F2($_";
    y/\000-\010\013\016-\037\177//d;
  } else {
    &spec($_);
    y/\000-\010\013\016-\037\177-\237//d;
  }
  s/(\r\n|\r)/\n/g;
  $refs{$html}=$nref++ if(!defined $refs{$html});
  $_="\004$lang\004)WB $refs{$html} Sn($_";

#  Yes, I know Perl has case-insensitive pattern matching. But on my system
#  it takes about 10 times longer to run!

  $pt="";
  if(/<[pP][lL][aA][iI][nN][tT][eE][xX][tT]$R/) {$_=$`;$pt=$'};
  while($_){
    if(/(<[lL][iI][sS][tT][iI][nN][gG]$R)/) {$_=$`; $tag=$1; $rest=$';
      if(/<[xX][mM][pP]$R/){$_=$`; &Subst($_); $P2.="$_)XX("; $_=$'.$tag.$rest;
        if(m|</[xX][mM][pP]$R|) {$P2.="$`)RP("; $_=$'}
        else {$P2.=$'; $_=""}}
      else {&Subst($_); $P2.="$_)XX("; $_=$rest;
        if(m|</[lL][iI][sS][tT][iI][nN][gG]$R|) {$P2.="$`)RP("; $_=$'}
        else {$P2.=$'; $_=""}}}
    elsif(/<[xX][mM][pP]$R/) {$_=$`; &Subst($_); $P2.="$_)XX("; $_=$';
      if(m|</[xX][mM][pP]$R|) {$P2.="$`)RP("; $_=$'}
      else {$P2.=$'; $_=""}}
    else {&Subst($_);$P2.=$_; $_=""}
  }
  $pt=~s/\f/$pc/g;
  if($pt) {$P2.=")XX($pt"};
  $P2.=")";
  if($plain) {$P2.="RP ()"};
  while($P2=~/XX\(/) {
    $beg=$`;
    $'=~/\)(RP|$)/;
    $mat=$`;
    $end=$&.$';
    $mat=~s/(.*\n){30}.*/$&)WR(/g;
    ($temp=$mat)=~s/\)[^(]+\(//g;
    @prel=split(' *\n',$temp);
    $maxl=0;
    for $line (@prel) {
      $line=~s/\\.../x/g;
      while($line=~/\t+/) {
        $sp=' ' x (length($&)*8-length($`)%8);
        $line=~s/\t+/$sp/;
        $mat=~s/\t+/$sp/;
      }
      $ll=length($line);
      $maxl=$ll if($ll > $maxl);
    }
    $P2="$beg ".($#prel+1)." $maxl PR($mat$end";
  }
  $P1=~s/[\200-\377]/sprintf("\\%3.3o",ord($&))/eg;
  $P2=~s/[\200-\377]/sprintf("\\%3.3o",ord($&))/eg;
  $P2=~y/\t\f/ /;
  1;
}
sub Subst{
  local($_)=@_;
  if($page_break) {
    s/<!--NewPage-->/$pc/g;
    s/<(\?|hr\s+class\s*=\s*["']?)\s*page-break$R/$pc/gi;
  }
  s/<!--OddPage-->/)WB NL OP(/g;
  if($ssi && $html!~m|://|) {
    while(/<!--#(include|config|echo)\s+(\w+)\s*="([^"]+)"\s*-->/) {
      $inc="";
      $file=$3;
      if($1 eq "include" && (substr($file,0,1) ne "/" || $opt_r)) {
        if(substr($file,0,1) ne "/") {
          $file=$B2.$file;
        } elsif($2 eq "virtual") {
          $file=$opt_r.$file;
        }
        if(open INC,$file) {
          $inc=<INC>;
          &spec($inc);
          close INC;
        }
      } elsif ($1 eq "config" && $2 eq "timefmt") {
        if($posix) {
          $var{LAST_MODIFIED}=POSIX::strftime($3,localtime((stat $html)[9]));
          $var{DATE_LOCAL}=POSIX::strftime($3,@now);
          $var{DATE_GMT}=POSIX::strftime($3,@gmnow);
        }  
      } elsif ($1 eq "echo") {
        $inc=$var{$3};
      }
      $_=$`.$inc.$';
    }
  }
  s/(&shy;?|&#173;?|<!--hy-->)/)HY(/g;
  while(/<!--/) {
    $_=$`;
    &getcom;
    $_.=$rest;
  }
  $temp="";
  while(/<([^"'>]*=\s*["'])/) {
    $temp.=$`."<";
    $_=$1.$';
    while(/^[^"'>]*=\s*(["'])/) {
      $temp.=$&;
      $_=$';
      if(/$1/) {
        ($tg=$`)=~y/>/\003/;
        $temp.=$tg.$&;
        $_=$';
      }
    }
  }
  $_=$temp.$_;
  $a='[aA][lL][iI][gG][nN]';
  $Y='[sS][tT][yY][lL][eE]';
  $A="($a\\s*=\"?|$Y\\s*=\\s*\"?[tT][eE][xX][tT]-\\s*$a:)";
  $I='[lL][eE][fF][tT]';
  $C='[cC][eE][nN][tT][eE][rR]';
  $D='[rR][iI][gG][hH][tT]';
  $J='[jJ][uU][sS][tT][iI][fF][yY]';
  $s='[sS][eE][lL][eE][cC][tT]';
  $F='[fF][oO][nN][tT]';
  $U='[cC][oO][lL][oO][rR]';
  $O='[cC][oO][mM][pP][aA][cC][tT]';
  s/<\w+[^>]*\s+[iI][dD]\s*=\s*($S)[^>]*>/$&<a name="$+">/g;
  s|<[dD][eE][lL]$R[\w\W]*?</[dD][eE][lL]>||g if($del{'display'}=~/^none$/);
  $ndiv=1;
  s|</?[dD][iI][vV]\d$R||g;
  s|<(/?)([dD][iI][vV])([>\s])|"<$1$2".($1?--$ndiv:$ndiv++).$3|eg;
  while(/<[dD][iI][vV](\d+)$R/) {
    $dbeg=$`;
    $dnum=$1;
    $dattr=$2;
    $dend=$';
    $div="";
    $ediv="";
    if($2=~/class\s*=\s*["']?noprint$R/i) {
      $_=$dbeg;
      $_.=$' if($dend=~/<\/[dD][iI][vV]$dnum>/);
    } else {
      if($dattr=~/$A\s*($I|$C|$D|$J)/) {
        $div.=")".$algn{"\L$2"}." Al(";
        $ediv.=")Ea(";
      }
      if($dattr=~/lang\s*=\s*["']?([a-zA-Z-]+)/i) {
        $lang=lc $1;
        $div.="\004$lang\004";
        &inihyph if($opt_H);
        $dbeg=~/(\004[^\004]*\004)[^\004]*$/;
        $ediv.=$1;
      }
      $dend=~s|</[dD][iI][vV]$dnum>|$ediv)BR(|;
      $_="$dbeg$div)BR($dend";
    }
  }
  s|<$C$R|)2 Al(|g;
  s|</$C$R|)Ea(|g;
  s|<(\w+)/([^/]+)/|<$1>$2</$1>|g;
  s/(<\w+[^>]*>)\n|\n(<\/\w+>)/$+/g;
  s|(<[lL][iI])$R\s*<[pP]>|)0 P($1$2|g;
  s/<[hH]([1-6])\s+$A\s*($I|$C|$D|$J)$R/)$algn{"\L$3"} $1  H(/g;
  s|<[hH]([1-6])$R|)0 $1  H(|g;
  s|</[hH][1-6]>|)EH(|g;
  s|<[bB][rR]$R|)BR(|g;
  s/<[pP]\s+[^>]*$A\s*($I|$C|$D|$J)$R/)$algn{"\L$2"} P(/g;
  s|<[pP]$R|)0 P(|g;
  s|</[pP]>|)EP(|g;
  s|<[aA][dD][dD][rR][eE][sS][sS]$R|)AD(|g;
  s|</[aA][dD][dD][rR][eE][sS][sS]>|)DA(|g;
  s|<[pP][rR][eE]$R\n?|)XX(|g;
  s|\n? *</[pP][rR][eE]>|)RP(|g;
  s|<[dD][tT]\s[^>]*$O$R|)1 DT(|g;
  s|<[dD][tT]$R|)0 DT(|g;
  s|<[dD][dD]$R|)DD(|g;
  s|<[dD][lL]\s[^>]*$O$R|)1 DL(|g;
  s|<[dD][lL]$R|)0 DL(|g;
  s|</[dD][lL]>|)LD(|g;
  s|<[uU][lL]$R|)UL(|g;
  s|</[uU][lL]>|)LU(|g;
  s|<[mM][eE][nN][uU]$R|)UL(|g;
  s|</[mM][eE][nN][uU]>|)LU(|g;
  s|<[dD][iI][rR]$R|)UL(|g;
  s|</[dD][iI][rR]>|)LU(|g;
  s|<[oO][lL]\s[^>]*[sS][tT][aA][rR][tT]\s*=\s*['"]?(-?\d+)$R|$&)WB $1 Ln(|g;
  s|<[oO][lL]\s[^>]*[tT][yY][pP][eE]\s*=\s*['"]?([1iIaA])$R|)$lity{$1} OL(|g;
  s|<[oO][lL]$R|)4 OL(|g;
  s|</[oO][lL]>|)LO(|g;
  s|<[lL][iI]\s[^>]*[vV][aA][lL][uU][eE]\s*=\s*['"]?(-?\d+)$R|$&)WB $1 Ln(|g;
  s|<[lL][iI]\s[^>]*[tT][yY][pP][eE]\s*=\s*['"]?($ltr)$R|)$lity{$1} LI(|g;
  s|<[lL][iI]$R|)-1 LI(|g;
  s|</[lL][iI]$R||g;
  s"<([bB][qQ]|[bB][lL][oO][cC][kK][qQ][uU][oO][tT][eE])$R")BQ("g;
  s"</([bB][qQ]|[bB][lL][oO][cC][kK][qQ][uU][oO][tT][eE])>")QB("g;
  s|<[sS][tT][rR][oO][nN][gG]$R|)BD(|g;
  s|</[sS][tT][rR][oO][nN][gG]>|)ES(|g;
  s|<[sS][aA][mM][pP]$R|)SM(|g;
  s|</[sS][aA][mM][pP]>|)ES(|g;
  s|<[qQ]$R(\s*)|$2)Q(|g;
  s|(\s*)</[qQ]>|)EQ($1|g;
  s|<[cC][iI][tT][eE]$R|)CT(|g;
  s|</[cC][iI][tT][eE]>|)ES(|g;
  s|<[vV][aA][rR]$R|)I(|g;
  s|</[vV][aA][rR]>|)ES(|g;
  s|<[bB]$R|)BD(|g;
  s|</[bB]>|)ES(|g;
  s|<[iI]$R|)I(|g;
  s|</[iI]>|)ES(|g;
  s|<[tT][tT]$R|)TT(|g;
  s|</[tT][tT]>|)ES(|g;
  s|<[uU]$R|)UN(|g;
  s|</[uU]>|)NU(|g;
  s|<[sS]([tT][rR][iI][kK][eE])?$R|)SE(|g;
  s|</[sS]([tT][rR][iI][kK][eE])?>|)XE(|g;
  s|<[dD][fF][nN]$R|)I(|g;
  s|</[dD][fF][nN]>|)ES(|g;
  s|<[eE][mM]$R|)EM(|g;
  s|</[eE][mM]>|)ES(|g;
  s|<[cC][oO][dD][eE]$R|)SM(|g;
  s|</[cC][oO][dD][eE]>|)ES(|g;
  s|<[kK][bB][dD]$R|)KB(|g;
  s|</[kK][bB][dD]>|)ES(|g;
  s|<[bB][iI][gG]$R|)4 FZ(|g;
  s|</[bB][iI][gG]>|)ES(|g;
  s|<[sS][mM][aA][lL][lL]$R|)2 FZ(|g;
  s|</[sS][mM][aA][lL][lL]>|)ES(|g;
  s|<[iI][nN][sS]$R|)sM WB(|g;
  s|</[iI][nN][sS]>|)WB eM(|g;
  s|<[dD][eE][lL]$R|)sM $lt(|g;
  s|</[dD][eE][lL]>|)XE eM(|g;
  s|<[aA][cC][rR][oO][nN][yY][mM][^>]+[tT][iI][tT][lL][eE]\s*=\s*($S)[^>]*>|)($+)Ac(|g;
  s|</[aA][cC][rR][oO][nN][yY][mM]>|)Ca(|g;
  s|<[fF][oO][rR][mM][\w\W]*?</[fF][oO][rR][mM]>||g if(!$forms);
  s|</?[fF][oO][rR][mM]$R|)Ts BE(|g;
  s/<$s[^>]*[mM][uU][lL][tT][iI][pP][lL][eE]$R/)1 MS(<table>/g;
  s/<$s$R/)0 MS(<table>/g;
  s|</$s>|</table>|g;
  s/<[oO][pP][tT][iI][oO][nN]$R/<tr><td>)O(/g;
  while(/<[iI][nN][pP][uU][tT]$R/) {
    $beg=$`;
    $iattr=$1;
    $rest=$';
    $it=2;
    if($iattr=~/type\s*=\s*["']?(\w+)/i) {$it=$it{"\L$1"}};
    if($it<2) {
      $it=($iattr=~/\schecked\W/i?1:0) ." $it";
    } elsif($it==2) {
      $siz=$iattr=~/size\s*=\s*["']?(\d+)/i?$1:12;
      $ival=$iattr=~/value\s*=\s*($S)/i?$+:"";
      $it="($ival)$siz $it";
    }
    if(defined($it)) {
      $cmd=$it==3?"<img $iattr":")$it BX(";
    } else {
      $cmd="";
    }
    $_=$beg.$cmd.$rest;
  }
  while(/<[tT][eE][xX][tT][aA][rR][eE][aA]$R/) {
    $beg=$`;
    $txatr=$1;
    $rest=$';
    if($rest=~m|</[tT][eE][xX][tT][aA][rR][eE][aA]>|) {
      $rest=$';
      $data=$prefilled||$textarea_data?$`:"";
      $rows=4;
      $cols=20;
      if($txatr=~/rows\s*=\s*["']?(\d+)/i) {$rows=$1};
      if($txatr=~/cols\s*=\s*["']?(\d+)/i) {$cols=$1};
      $nl=$data=~y/\n/\n/;
      for ($nl..$rows) {$data.="\n"};
      $data=~/(.*\n){$rows}/;
      $tfont=$prefilled?"TT":"0 FZ";
      ($data=$&)=~s/.*\n/<tr height=24><td valign=top>)$tfont($&)ES(/g;
      $wi=10*$cols;
      $frame=$prefilled?"frame=box":"border";
      $_="$beg<table $frame width=$wi cellpadding=2>$data</table>$rest";
    } else {
      $_=$beg.$rest;
    }
  }
  $nfnt=1;
  s|<(/?)($F)([>\s])|"<$1$2".($1?--$nfnt:$nfnt++).$3|eg;
  while(/<$F(\d+)([^>]*)$U\s*=\s*["']?\s*#?(\w+)$R/) {
    $rgb=&col2rgb($3);
    $_=$`.($rgb?")WB $rgb Sc(":"")."<font$2$4";
    $temp=$';
    $temp=~s|</$F$1>|</font>)Ec(| if($rgb);
    $_.=$temp;
  }
  $base{"+"}="Bf add ";
  $base{"-"}="Bf add ";
  s/<$F\d*\s[^>]*[sS][iI][zZ][eE]\s*=\s*["']?([+-]?)(\d+\.?\d*)$R/)$1$2 $base{$1}FZ(/g;
  s|<$F\d*$R|)3 FZ(|g;
  s|</$F\d*>|)Ef(|g;
  s|<[bB][aA][sS][eE]$F\s[^>]*[sS][iI][zZ][eE]\s*=\s*["']?(\d+)$R|)$1 BZ(|g;
  while(/(<[aA]\s+[^>]*)[nN][aA][mM][eE]\s*=\s*(["']?)([^"'\s>]*)$R([^\s<)]*)/) {
    $lnk="$html#$3";
    $refs{$lnk}=$nref++ unless(defined $refs{$lnk});
    $_="$`$1$4$5)WB $refs{$lnk} Sn($'";
  }
  while(/<[aA]\s+[^>]*[hH][rR][eE][fF]\s*=\s*["']?\s*([^"'\s>]*)$R/) {
    $beg=$`;
    $tag=$&;
    $rest=$';
    $lnk=$1;
    $revtoc=$tag=~/rev\s*=['"]?\s*toc/i;
    $html=~m|[^/]*$|;
    $lnk=~s/^\Q$&#/#/;
    $loc=$lnk=~/^#/;
    if($loc) {
      $html=~m|[^/]*$|;
      $lnk=$&.$lnk;
    }
    if($lnk=~m|.+//[^/]+$|) {$lnk=$&."/"}
    if($lnk=~m|://|) {
      $rlnk=0;
    } else {
      $rlnk=1;
      if($lnk=~m|^/|) {$lnk=$b1.$lnk} elsif($lnk!~m|^\w+:|) {$lnk=$b2.$lnk};
    }
    while($lnk!~m|^\.\./| && $lnk=~m|[^/]*/\.\./|) {$lnk=$`.$'};
    $lnk=~s"(^|/)\./"$1"g;
    ($doc)=$lnk=~/([^#]*)/;
    ($doctit{$doc})=$tag=~/title\s*=['"]([^'"]*)['"]/i;
    $T=0;
    $anch=2;
    if($loc || grep(/^\Q$doc\E$/,(@docs,@links))
     || $opt_W && !$link && $level<=$maxlev && &follow){
      $refs{$lnk}=$nref++ unless(defined $refs{$lnk});
      $anch="$refs{$lnk} 1";
      $ltype=$rev && $revtoc && $ndoc==1 || $opt_C=~/f/ && $ndoc==1?1:0;
      $rest=~s|</a>|)$refs{$lnk} $ltype TN TL()Ec /AF f D(|i;
      if(&follow && !$levl{$doc}) {
        &dbg("Link: $doc\n") if($opt_d);
        $levl{$doc}=$level+1;
        push(@links,$doc);
      }
    } elsif(defined $refs{$lnk}) {
      $anch="$refs{$lnk} 1";
    }
    $addr=$dum{$lnk}?"R$dum{$lnk}":0;
    if(!$dum{$lnk} && $lnk=~m|://|) {
      $dum{$lnk}=$nlnk++;
      $rfs.="/R$dum{$lnk} ($lnk) D\n";
      $addr="R$dum{$lnk}";
    }
    $_=$beg.")$addr $anch A(".$rest;
  }
  s|</[aA]>|)EA(|g;
  if((!$mult || $doc_sep eq $pc && $mult)
   && m|<[bB][aA][nN][nN][eE][rR]$R([\w\W]*)</[bB][aA][nN][nN][eE][rR]>|) {
    $banner=$2;
    $_=$`.$';
  }
  while(/<[tT][aA][bB][lL][eE]([^>]*)>/) {
    local($beg)=$`;
    local($rest)=$';
    $tattr=$1;
    $tag=$&;
    $rest=~/(<\/[tT][aA][bB][lL][eE]>|$)/;
    $table=$`;
    $rest=$';
    while($table=~/<[tT][aA][bB][lL][eE]([^>]*)>/) {
      $tattr=$1;
      $table=$';
      $beg.=$tag.$`;
      $tag=$&;
    }
    ($tla)=$tattr=~/lang\s*=\s*["']?([a-zA-Z-]+)/i;
    if(!$tla) {($tla)=$beg=~/\004_?([^\004]*)\004[^\004]*$/};
    $ntab++;
    $table=~s/^\s*//;
    undef %cells;
    undef %rd;
    undef @cali;
    undef @cval;
    undef @cgrp;
    undef @cwid;
    undef @codc;
    undef @r0;
    undef @c0;
    ($capat,$cap)=$table=~m|<caption$R([\w\W]*)</caption>|i;
    $capat=~/ALIGN\s*=\s*["']?\s*(\w+)/i;
    $capa=0;
    $capa=1 if("\L$1" eq "bottom");
    $capa=-1 if($cap!~/\S/);
    $bord=0;
    if($tattr=~/border/i) {
      ($bord)=$'=~/^\s*=\s*["']?(\d+)/;
      if(!$bord && $bord ne "0") {$bord=1};
    }
    ($talgn)=$tattr=~/ALIGN\s*=\s*["']?\s*(\w+)/i;
    $tal=-1;
    $tal=0 if($talgn=~/^left$/i);
    $tal=1 if($talgn=~/^center$/i);
    $tal=2 if($talgn=~/^right$/i);
    ($fra)=$tattr=~/FRAME\s*=\s*["']?\s*(\w+)/i;
    if($fra && $f{"\L$fra"}) {$fra=$f{"\L$fra"}} else {$fra=$bord?9:1};
    ($rul)=$tattr=~/RULES\s*=\s*["']?\s*(\w+)/i;
    if($rul && $r{"\L$rul"}) {$rul=$r{"\L$rul"}} else {$rul=$bord?5:1};
    unless(($twid)=$tattr=~/WIDTH\s*=\s*["']?(\d+\.?\d*%?)/i) {$twid=0};
    $twid=$twid=~/%$/?$`/100:-$twid;
    ($cpad)=$tattr=~/CELLPADDING\s*=\s*["']?\s*$V/i;
    if($tattr=~/CELLSPACING\s*=\s*["']?\s*$V/i && $1!=0) {$cpad+=$1/2};
    ($tbg)=$tattr=~/BGCOLOR\s*=\s*["']?\s*#?(\w+)/i;
    $tbg=&col2rgb($tbg);
    ($tcl)=$tattr=~/CLASS\s*=\s*["']?\s*(\w+)/i;
    $tcl="\L$tcl" eq "telelista"? 1: 0;
    $ic=0;
    $span=1;
    undef $gal;
    undef $gva;
    undef $odc;
    undef $gwi;
    $cgs=0;
    while($table=~/<[cC][oO][lL]([^>]*>)/g && $span>0) {
      $cola=$1;
      $ab=$`;
      $aft=$';
      $cola=~/(^|\s)ALIGN\s*=\s*["']?\s*(\w+)/i;
      $alg=$algn{"\L$2"};
      ($val)=$cola=~/VALIGN\s*=\s*["']?\s*(\w+)/i;
      $val=$v{"\L$val"};
      ($odc)=$cola=~/CHAR\s*=\s*["']?(.)/i;
      unless(($wid)=$cola=~/WIDTH\s*=\s*["'](\d+%?)/i) {$wid=0};
      if($wid=~/%$/) {$wid=$`/100};
      ($span)=$cola=~/SPAN\s*=\s*["']?\s*(\d+)/i;
      if(!$span && $span ne "0") {$span=1};
      $us=1;
      if($cola=~/^GROUP/i) {
        $gal=$alg;
        $gva=$val;
        $gdc=$odc;
        $gwi=$wid;
        $cgs=1;
        if($aft=~/<COL\s/i) {
          $us=$`=~m|</?COLGROUP|i;
        }
      } else {
        while($ab=~/<COLGROUP/i) {$ab=$'};
        if($ab=~m|</COLGROUP|i) {
          undef $gal;
          undef $gva;
          undef $odc;
          undef $gwi;
        }
        if(!$alg) {$alg=$gal};
        if(!$val) {$val=$gva};
        if(!$odc) {$odc=$gdc};
        if(!$wid) {$wid=$gwi};
        if($span eq "0") {
          $ic++;
          push(@cali,$alg);
          push(@cval,$val);
          push(@cwid,$wid);
          push(@codc,$odc);
          push(@cgrp,1);
        }
      }
      if($us) {
        for (1..$span) {
          $ic++;
          push(@cali,$alg);
          push(@cval,$val);
          push(@cwid,$wid);
          push(@codc,$odc);
          push(@cgrp,$cgs);
          $cgs=0;
        }
      }
    }
    $table=~/<t[hd][\s>]/i;
    if($`!~/<tr/i) {$table="<TR>$table"};
    $nrow=-1;
    $ncol=-1;
    $nhead=0;
    $nfoot=0;
    $nb=0;
    unless($table=~/<tbody$R/i || $table=~s|</tfoot>|$&<tbody>|i) {
      $table=~s|</thead>|$&<tbody>|i;
    }
    while($table=~/<[tT][rR]\s*([^>]*)>/g) {
      $nrow++;
      $ab=$`;
      $row=$';
      $rattr=$1;
      for $j (@c0) {
        $cells{"$nrow,$j,0"}=1;
      }
      $rgrp=0;
      if($ab=~/<tbody$R/i) {
        $ib=0;
        while($ab=~/<[tT][bB][oO][dD][yY]$R/g) {
          $ib++;
          $battr=$1;
          if($ib>$nb) {
            $rgrp=1;
            $nb=$ib;
          }
        }
      } else {
        if($ab=~/<tfoot$R/i) {
          $nfoot++;
          $battr=$1;
        } elsif($ab=~/<thead$R/i) {
          $nhead++;
          $battr=$1;
        }
      }
      $battr=~/(^|\s)ALIGN\s*=\s*["']?\s*(\w+)/i;
      $balgn=$algn{"\L$2"};
      $battr=~/VALIGN\s*=\s*["']?\s*(\w+)/i;
      $bva=$v{"\L$1"};
      ($bdc)=$battr=~/CHAR\s*=\s*["']?(.)/i;
      $rd{"$nrow,0"}=0;
      $rd{"$nrow,1"}=0;
      $rd{"$nrow,2"}=0 unless($rd{"$nrow,2"});
      $rd{"$nrow,3"}=$rgrp;
      $rattr=~/(^|\s)ALIGN\s*=\s*["']?\s*(\w+)/i;
      $ralgn=$algn{"\L$2"};
      $rattr=~/VALIGN\s*=\s*["']?\s*(\w+)/i;
      $rva=$v{"\L$1"};
      ($rla[$nrow])=$rattr=~/lang\s*=\s*["']?([a-zA-Z-]+)/i;
      ($rbg)=$rattr=~/BGCOLOR\s*=\s*["']?\s*#?(\w+)/i;
      $rbg[$nrow]=&col2rgb($rbg);
      ($rdc)=$rattr=~/CHAR\s*=\s*["']?(.)/i;
      if($row=~/<tr/i) {$row=$`};
      $rh[$nrow]=$rattr=~/HEIGHT\s*=\s*["']?(\d+)/i?$1:0;
      $icol=0;
      $colsp=1;
      while($row=~/<[tT]([hH]|[dD])(\s*[^>]*)>/g && $colsp>0) {
        $cattr=$2;
        $cell=$';
        $ctype=$1=~/h/i?1:0;
        if($cell=~/<t[hd]/i) {$cell=$`};
        $cell=~s/\s+$//;
        $cell=~s/\)HY\($/\255/;
        $cell=~s/[\200-\377]([^\\]|\\20.)/$&)WB(/g if(!$latin1);
        ($rowsp)=$cattr=~/ROWSPAN\s*=\s*["']?(\d+)/i;
        $rsp=$rowsp;
        if(!$rsp) {
          if($rsp eq "0") {
            push(@c0,$icol);
          } else {
            $rowsp=1;
          }
          $rsp=1;
        }
        ($colsp)=$cattr=~/COLSPAN\s*=\s*["']?(\d+)/i;
        $csp=$colsp;
        if(!$csp) {
          if($csp eq "0") {
            push(@r0,$nrow);
            $csp=$ncol-$icol<0? 1: $ncol-$icol+1;
          } else {
            $colsp=1;
            $csp=1;
          }
        }
        ($cdc)=$cattr=~/CHAR\s*=\s*["']?(.)/i;
        while($cells{"$nrow,$icol,0"}==1) {$icol++};
#
        for $i ($nrow..$nrow+$rsp-2) {$rd{"$i,2"}=1};
        for $j ($icol..$icol+$csp-1) {
          for $i ($nrow..$nrow+$rsp-1) {
            $cells{"$i,$j,0"}=1;
          }
        }
        if($colsp) {
          for $j ($ncol+1..$icol+$csp) {
            for $i (@r0) {
              $cells{"$i,$j,0"}=1;
            }
          }
        }
        if($ic<$icol+$csp) {
          for ($ic..$icol+$csp-1) {
            push(@cali,$cali[$ic-1]);
            push(@cval,$cval[$ic-1]);
            push(@cgrp,0);
          }
          $ic=$icol+$csp;
        }
        $cal=$ctype;
        $cal=$balgn-1 if($balgn);
        $cal=$ralgn-1 if($ralgn);
        $cal=$cali[$icol]-1 if($cali[$icol]);
        if($cattr=~/(^|\s)ALIGN\s*=\s*["']?\s*(\w+)/i) {
          $cal=$algn{"\L$2"}-1 if($algn{"\L$2"});
        }
        $cvl=2;
        $cvl=$cval[$icol] if($cval[$icol]);
        $cvl=$bva if($bva);
        $cvl=$rva if($rva);
        if($cattr=~/VALIGN\s*=\s*["']?\s*(\w+)/i) {
          $cvl=$v{"\L$1"} if($v{"\L$1"});
        }
        ($cbg)=$cattr=~/BGCOLOR\s*=\s*["']?\s*#?(\w+)/i;
        $cbg=&col2rgb($cbg);
        for($rbg[$nrow],$tbg,$deftbg,$bg) {$cbg=$_ if(!$cbg)};
        $now=0;
        $ro=$cattr=~/class\s*=\s*["']?rot(-?90)/i?$1:0;
        if($cattr=~/NOWRAP/i || $cal==4 || $ro) {$now=1};
        $dc=".";
        $dc=$bdc if($bdc || $bdc eq "0");
        $dc=$rdc if($rdc || $rdc eq "0");
        $dc=$codc[$icol] if($codc[$icol] || $codc[$icol] eq "0");
        $dc=$cdc if($cdc || $cdc eq "0");
        ($wid)=$cattr=~/WIDTH\s*=\s*["'](\d+%)/i;
        if($wid=~/%$/) {$wid=$`/100};
        if($wid>$cwid[$icol]) {$cwid[$icol]=$wid};
        if($cpad || $cpad eq "0") {
          $clm=$cpad;
          $crm=$cpad;
          $ctm=$cpad;
          $cbm=$cpad;
        } else {
          $clm=$rul<5?8:4;
          $crm=$rul<5?8:4;
          $ctm=2;
          $cbm=6;
        }
        if($tcl==1) {
          $clm=$icol>0?12:2;
          $crm=12;
          $ctm=0;
          $cbm=0;
        }
        if($rul==1 && $fra==1 && $icol==0 && $tal==0) {$clm=0};
        ($lang)=$cattr=~/lang\s*=\s*["']?([a-zA-Z-]+)/i;
        for($rla[$nrow],$tla) {$lang=$_ if(!$lang)};
        $lang=lc $lang;
        &inihyph if($opt_H);
        $cbg=~/#(\w+).*#(\w+).*#(\w+)/;
        &img($cell,$1,$2,$3);
        @cll=("{(\004$lang\004)WB($cell)}",0,0,$ctype,0,$colsp,$rowsp,$cal,
         "($dc)",$cvl,$now,$clm,$crm,$ctm,$cbm,0,0,0,0,$cbg,$ro);
        for $i (0..$#cll) {$cells{"$nrow,$icol,$i"}=$cll[$i]};
        $icol+=$csp;
        if($icol-1>$ncol) {$ncol=$icol-1};
      }
    }
    for $j (0..$ncol) {
      for $i (0..$nrow) {
        if($cells{"$i,$j,0"} && $cells{"$i,$j,0"}!=1) {
          if($cells{"$i,$j,6"}>$nrow-$i+1) {$cells{"$i,$j,6"}=$nrow-$i+1};
          if($cells{"$i,$j,6"}>1) {$rd{"$i,2"}=1};
        }
      }
    }
    $rd{"$nrow,2"}=0;
    $rw="[";
    for $i (0..$nrow) {
      $rw.="[$rh[$i] ".$rd{"$i,1"}." ".$rd{"$i,2"}." ".$rd{"$i,3"}." 0 0 [";
      for $j (0..$ncol) {
        $cbg="";
        for($rbg[$i],$tbg,$deftbg,$bg) {$cbg=$_ if(!$cbg)};
        $temp="[{()}0 0 0 0 1 1 0(.)0 0 $clm $crm $ctm $cbm 0 0 0 0 $cbg $ro]";
        if($cells{"$i,$j,0"}==1) {
          $temp="0";
        } elsif($cells{"$i,$j,0"}) {
          $temp="[";
          for $k (0..$#cll) {
            $temp.=$cells{"$i,$j,$k"}." ";
          }
          $temp.="]";
        }
        $rw.="$temp\n";
      }
      $rw.="]]\n";
    }
    if($nrow==$nhead+$nfoot-1) {
      $nhead=0;
      $nfoot=0;
    }
    $tdesc="[0 0 $tcl 0 0 $tal 0 $twid $bord $nrow $ncol"
           ." $nhead $nfoot $fra $rul {($cap)} $capa]\n";
    $cdesc="[";
    for (0..$ncol) {
      unless($wid=$cwid[$_]) {$wid=0};
      $cdesc.="[0 0 0 $wid $cgrp[$_] 0 0]";
    }
    $cdesc.="]\n";
    $tables.="[$tdesc $cdesc $rw]]\n";
    $_=$beg.")$ntab PT(".$rest;
  }
  &img($_,$red,$grn,$blu);
  &ack($_);
  $_[0]=$_;
}
sub getcom{
  $com=$&;
  $'=~/--\s*(--|>)/;
  $com.=$`.$&;
  $rest=$';
  while($1 eq "--") {
    $'=~/(>)/ if($'!~/--\s*(--|>)/);
    $com.=$`.$&;
    $rest=$';
  }
}
sub getl {
  ($l)=@_;
  if(!$lid{$l}) {
    while($l=~s/-[^-]+$// && !$lid{$l}) {};
  }
  $lid{$l};
}
sub ack {
  local($_)=@_;
  chdir $tempdir;
  while (/<[mM][aA][tT][hH]/) {
    $beg=$`;
    $rest=$&.$';
    $rest=~m|</[mM][aA][tT][hH]>|;
    $end=$';
    $math=$`;
    if(&math2sym($math)) {
      $_=$beg.$sym.$end;
    } elsif($package{'TeX'} && $package{'dvips'}) {
      $math=~s|\\200|\\|g;
      $math=~s|\\201|\(|g;
      $math=~s|\\202|\)|g;
      &math2tex($math);
      open(SCRATCH,">$scr.tex");
      print SCRATCH $tex;
      close SCRATCH;
      `tex $scr.tex`;
      `dvips -E -o $scr.ps $scr.dvi`;
      open(LOG,"$scr.log");
      $log=<LOG>;
      close LOG;
      ($h,$d)=$log=~/[\w\W]*$prog: +([\d.]+)pt: +([\d.]+)/ ? ($1,$2) : (1,0);
      $above=$h+$d>0?sprintf("%.4f",$h/($h+$d)):0;
      open(PS,"$scr.ps");
      $pic=<PS>;
      if($pic=~/^%!/ && $pic=~/%%BoundingBox: +$V +$V +$V +$V/) {
        $xs=$3-$1;
        $ys=$4-$2;
        $llx=$1;
        $lly=$2;
        $ps="";
        for $i (split(/\n/,$pic)) {
          $ps.=$i."\n" if($i && $i!~/^%/);
        }
        if($ps=~/\nTeXDict begin/) {
          if(!$ph) {
            $ph="/DH {1 F div dup scale /showpage {} D\n$`$&} D\n%EndDH\n";
            $pv=$ph.$pv;
          }
          $ps="save -$llx -$lly translate\nDH$' restore";
        }
      }
      $nimg++;
      $nps--;
      push(@XS,$xs);
      push(@YS,$ys);
      push(@IX,$nps);
      push(@IT,2);
      $pv.="/P$nimg {$ps} D\n";
      $eps{"P$nimg"}=$ps;
      $_=$beg.")$above 3 (P$nimg) $nimg IM(".$end;
    } else {
      $math=~s/<math$R//i;
      $_=$beg.$math.$end;
    }
  }
  chdir $cwd;
  s|<[sS][uU][bB]$R|)Sb(|g;
  s|<[sS][uU][pP]$R|)Sp(|g;
  s"</[sS][uU]([bB]|[pP])>")Es("g;
  s|<[A-Za-z/!?]\w*$R||g;
  &ent($_);
  y/\003/>/;
  s/\004([^\004]*)\004/")".&getl($1)." Sl($&"/eg;
  if($opt_H) {
    &dbg("Inserting potential hyphenation points\n") if($opt_d && $ndoc>0);
    $temp="";
    while(/\004([^\004]*)\004/) {
      $temp.=$`;
      $lang=$1;
      $end=$';
      if($end=~/\004([^\004]*)\004/) {
        $htext=$`;
        $end=$&.$';
      } else {
        $htext=$end;
        $end="";
      }
      $apa="";
      while($htext=~/(..?)\(([^)]*)/) {
        $slut=$';
        if($1 eq "XX") {
          $apa.=$`.$&;
          if($'=~/RP\(/) {
            $apa.=$`;
            $htext=$&.$';
          } else {
            $apa.=$slut;
            $htext="";
          }
        } elsif($1 eq ") ") {
          $apa.=$`.$&;
          $htext=$';
        } else {
          $apa.="$`$1(";
          $htext=$';
          ($txt=$2)=~s/[$ltrs]{$hyphenation{'min'},}/&hyph($&)/eg;
          $apa.=$txt;
        }
      }
      $_=$apa.$slut.$end;
    }
    $_=$temp.$_;
  }
  s/\004([^\004]*)\004//g;
  $_[0]=$_;
}
sub ent {
  local($_)=@_;
  s|&#x($X+);?|"&#".hex($1).";"|egi;
  for $char (keys %ent) {s/&($char)(;|$|(?=\W))/chr($ent{$char})/eg};
  for $char (keys %symb) {s/&($char)(;|$|(?=\W))/)SY(\\$symb{$char})ES(/g};
  s/&(euro|#8364)(;|$|(?=\W))/)MY(e)ES(/g;
  s|&lt;?|<|g;
  s|&gt;?|>|g;
  s|&quot;?|"|g;
  s/&($space);?/)$space{$1} Se(/g;
  s|&#(\d+);?|$1==38?"\005":$1<256?chr($1):$&|eg;
  s/(\005|&amp;?)/\&/g;
  $_[0]=$_;
}
sub spec {
  $_[0]=~s/(\\|&#92(;|$|(?=\W)))/\\200/g;
  $_[0]=~s/(\(|&#40(;|$|(?=\W)))/\\201/g;
  $_[0]=~s/(\)|&#41(;|$|(?=\W)))/\\202/g;
  $_[0]=~s/&(there4|#8756|#[xX]2234)(;|$|(?=\W))/)SY(\\200)ES(/g;
}
sub math2tex {
  local($_)=@_;
  local($beg,$rest);
  %a=("line","overline",
  "cub","overbrace",
  "hat","widehat",
  "tilde","widetilde",
  "larr", "overleftarrow",
  "rarr", "overrightarrow");
  %b=("line","underline",
  "cub","underbrace",
  "hat","widehat",
  "tilde","widetilde");
  %s=("medium","\\big",
  "large","\\Big",
  "huge","\\bigg");
  ($mattr)=/<math$R/i;
  $st=$mattr=~/class\s*=\s*["']?chem/i?'\rm ':'';
  $di=$mattr=~/class\s*=\s*["']?displayed/i?'\displaystyle ':'';
  s/<math$R//gi;
  s/\\/\\backslash/g;
  s/__/_\\>_/gi;
  s/\^\^/^\\>^/gi;
  s/_([^_]+)_/_{$1}/g;
  s/\^([^^]+)\^/^{$1}/g;
  s/&thinsp;?/\\,/g;
  s/&sp;?/\\>/g;
  s/&emsp;?/\\;/g;
  s/&nbsp;?/\\>/g;
  s/&epsi;?/\\varepsilon /g;
  s/&upsi;?/\\upsilon /g;
  s/&piv;?/\\varpi /g;
  s/&sigmav;?/\\varsigma /g;
  s/&thetav;?/\\vartheta /g;
  s/&phiv;?/\\varphi /g;
  s/&Upsi;?/\\Upsilon /g;
  s/&omicron;?/o/g;
  s/&plusmn;?/\\pm /g;
  s/&or;?/\\vee /g;
  s/&and;?/\\wedge /g;
  s/&ap;?/\\approx /g;
  s/&sube;?/\\subseteq /g;
  s/&sub;?/\\subset /g;
  s/&supe;?/\\supseteq /g;
  s/&sup;?/\\supset /g;
  s/&isin;?/\\in /g;
  s/&larr;?/\\leftarrow /g;
  s/&rarr;?([_^])/\\mathop\\rightarrow\\limits$1 /g;
  s/&rarr;?/\\rightarrow /g;
  s/&uarr;?/\\uparrow /g;
  s/&darr;?/\\downarrow /g;
  s/&harr;?/\\leftrightarrow /g;
  s/&lArr;?/\\Leftarrow /g;
  s/&rArr;?/\\Rightarrow /g;
  s/&uArr;?/\\Uparrow /g;
  s/&dArr;?/\\Downarrow /g;
  s/&exist;?/\\exists /g;
  s/&inf;?/\\infty /g;
  s/&?int;?/\\int\\limits /g;
  s/&?sum;?/\\sum\\limits /g;
  s/&?prod;?/\\prod\\limits /g;
  s/&pd;?/\\partial /g;
  s/&lcub;?/\\{/g;
  s/&rcub;?/\\}/g;
  s/<t>/\\hbox{/gi;
  s/<b>/\\bf /gi;
  s/<bt>/{\\bf\\hbox{/gi;
  s/<sub$R/_{/gi;
  s/<sup$R/\^{/gi;
  s/<box\s*size=["']?(\w+)["']?>/{\\def\\lft{$s{$1}}\\def\\rgt{$s{$1}}/gi;
  s/<box$R/{/gi;
  s/<text\s*>/\\hbox{/gi;
  s/([\(\[\|])\s*<left>/\\lft$1/gi;
  s/<right>/\\rgt /gi;
  s/<(atop|choose|over)>/\\\L$1 /gi;
  s/<of>/}\\of{/gi;
  s/<bar>/\\overline{/gi;
  s/<vec>/\\overrightarrow{/gi;
  s/<hat>/\\widehat{/gi;
  s/<tilde>/\\widetilde{/gi;
  s/<(sqrt|root|vec|dot|ddot|hat|tilde)>/\\\L$1\{/gi;
  while(/<above\s+sym\s*=\s*["']?equals["']?\s*>/i) {
    $beg=$`."\\overline{\\overline{";
    $rest=$';
    $rest=~s/<\/above>/}}/i;
    $_=$beg.$rest;
  }
  s/<above\s*>/\\overline{/gi;
  s/<above\s+sym\s*=\s*["']?(\w+)["']?\s*>/\\$a{$1}\{/gi;
  s/<below\s*>/\\underline{/gi;
  s/<below\s+sym\s*=\s*["']?(\w+)["']?\s*>/\\$b{$1}\{/gi;
  s/<\/(math|row|item|b)>//gi;
  s/<\/(box|t|sup|sub|sqrt|root|vec|bar|dot|ddot|hat|tilde|above|below|text|array)>/}/gi;
  s/<\/bt>/}}/gi;
  s/&lt;?/< /gi;
  s/&gt;?/>/gi;
  s/&(\w+);?/\\$1 /gi;
  s/<array$R/\\matrix{/gi;
  s/<row>\s*<item$R//i;
  s/<row>\s*<item$R/\\cr /gi;
  s/<item>/&/gi;
  s/<[^ ]$R//gi;
  s/\n*$//;
  $tex="\\batchmode\\magnification=$mag\\hsize=40cm\\nopagenumbers\n"
 ."\\def\\lft{\\left}\\def\\rgt{\\right}\n\\setbox0=\\hbox{\$$st$di".$_."\$}\n"
 ."\\immediate\\write0{$prog: \\the\\ht0: \\the\\dp0}\\box0\n\\end\n";
}
sub Getopts {
  local($optlist)=@_;
  local(@args,$_,$opt,$opts,$rest,$olist,$plist,$found,@popts);
  local($errs)=0;
  local($[)=0;
  @args=split( /\|/, $optlist );
  for $opt (@args) {
    if(substr($opt,-1,1) ne ':') {$olist.=$opt}
    else {$plist.=$opt}
  }
  @popts=split(/:/,$plist);
  while(@ARGV && ($_=$ARGV[0]) =~ /^-(.*)/) {
    $opt=$1;
    if($opt=~/^-/ && $optalias{"\L$'"}) {$opt=$optalias{"\L$'"}};
    if($opt =~ /^[$olist]+$/) {
      while ($char=chop $opt) {eval "\$opt_$char=1"}
      shift(@ARGV);
    }
    else {
      $found=0;
      for $opts (@popts) {
        $rest=substr($opt,length($opts));
        if(index($opt,$opts)==0) {
          $found=1;
          shift(@ARGV);
          if(length($rest)==0) {
            ++$errs unless @ARGV;
            $rest=shift(@ARGV);
          }
          eval "\$opt_$opts=\$rest";
        }
      }
      if(!$found) {
        &dbg("Unknown option: $opt\n");
        ++$errs;
        shift(@ARGV);
      }
    }
  }
  $errs==0;
}
sub openps {
  open(STDOUT,">$opt_o") || die "*** Error opening $opt_o for output\n";
}
sub getalt {
  if($imgcmd eq "img") {
    $alt="";
    $match=0;
    if($img=~/alt\s*=\s*"([^"]*)"/i) {$alt=$1; $match=1};
    if(!$match && $img=~/alt\s*=\s*([\w\.-]+)/i) {$alt=$1; $match=1};
    if(!$match) {$alt=")WB IA WB("};
    $text="$alt )WB(";
    return;
  }
  if($imgcmd eq "hr") {
    $text=$img=~/align\s*=\s*["']?(left|center|right)/i?")$algn{lc $1} ":")2 ";
    $text.=$img=~/size\s*=\s*["']?$V/i?$1:.6;
    $wd=1;
    if($img=~/width\s*=\s*["']?$V(%?)/i) {$wd=$2?$1/100:-$1};
    $text.=" $wd HR(";
    return;
  }
  if($imgcmd eq "fig") {
    $text=")BN(";
  }
}
sub xbmtops {
  $fc=1;
  $dp=1;
  ($xs,$ys)=$pic=~/^#define.* (\d+)[\w\W]*^#define.* (\d+)/;
  $nd=2*int(($xs+7)/8)*$ys;
  ($pic)=$pic=~/[^#].* char.*[\w\W]*{([\w\W]*)}/;
  $pic=~s/[ ,\n\r]*0x[ ,]*//g;
  $pic=~y/01246789bdef/f7bd91e62480/;
  $bm=unpack("H*", pack("h*",$pic));
}
sub pmtops {
  pmtoraw($pm) if($pm=~/^P([1-3])/);
  $pm=~/^P([4-6])/;
  $maptype=$1;
  return if(!$maptype);
  $pm=$';
  $bm="";
  $nint=3;
  $dp=8;
  if($maptype==4) {
    $nint=2;
    $dp=1;
  }
  undef @num;
  $found=0;
  while($pm && $found<$nint) {
    if($pm=~/^\s*(\d+)/) {$num[$found]=$1};
    if($num[$found]) {
      $found++;
      $pm=$';
    } elsif($pm=~/^\s*#.*\n/) {
      $pm=$';
    } else {
      return;
    }
  }
  ($b)=$pm=~/\s([\w\W]*)/;
  ($xs,$ys,$bits)=@num;
  return if($bits>255);
  $fc=1;
  if($maptype==6) {
    $fc=3;
    $nd=6*$xs*$ys;
    $bm=unpack("H*",$b);
  } else {
    $bm=unpack("H*",$b);
    if($maptype==4) {
      $nd=2*int(($xs+7)/8)*$ys;
      $bm=~y/0123456789abcdef/fedcba9876543210/;
    } else {
      $nd=2*$xs*$ys;
    }
  }
}
sub trans {
  $next = 13;
  $temp = ord substr($pic,10,1);
  if($temp & 0x80) {$next += 3*2**(($temp & 0x07) + 1)} else {return};
  $byte = ord substr($pic,$next,1);
  while($byte != 0x3b && $next <= length $pic) {
    if($byte == 0x21) {
      if(ord substr($pic,$next+1,1) == 0xf9) {
        if(ord substr($pic,$next+3,1) & 0x01) {
          &dbg("Transparent\n") if($opt_d);
          $src{$URL}=$pic;
          $idx = 3*(ord substr($pic,$next+6,1))+13;
          substr($pic,$idx,3) = pack("H*",$red.$grn.$blu) if($idx<length $pic);
        }
        return;
        $next += 2;
        &skip;
      } else {
        $next += 2;
        &skip;
      }
    } elsif($byte == 0x2c) {
      $next += 10;
      $temp = ord substr($pic,$next-1,1);
      if($temp & 0x80) {$next += 3*2**(($temp & 0x07) + 1)};
      $next++;
      &skip;
    } else {return}
  }
}
sub skip {
  $byte = ord substr($pic,$next,1);
  while($byte != 0) {
    $next += $byte + 1;
    $byte = ord substr($pic,$next,1);
  }
  $next++;
  $byte = ord substr($pic,$next,1);
}
sub run {
  &dbg("@_\n") if($opt_d);
  $pm=`@_`;
}
sub geturl {
  local($url)=@_;
  &dbg("Retrieving $url");
  if($package{'libwww-perl'} || $package{'jfriedl'}) {
    warn "\n";
    &gu();
    if($code==401) {
      &prompt("\nDocument requires username and password\n\nUsername: ",$user);
      &prompt("Password: ",$pass);
      &gu($user,$pass);
    }
    $_[1]=$cont;
  } elsif(defined $geturl) {
    &dbg("...");
    $_[1]=`$geturl '$url'`;
    if($?) {
      &dbg("\n*** Error opening $url\n");
      return 0;
    }
    &dbg("done\n");
    if($_[1]=~/\r?\n\r?\n/) {
      $_[1]=$';
      $dhead=$`;
      ($code)=$dhead=~/HTTP\/\S+ +(\d+)/i;
      ($contyp)=$dhead=~/Content-type:\s+(.*)/i;
    } else {
      $code=500;
    }
  }
  $_[0]=$url;
  $code<300;
}
sub gu {
  if($package{'libwww-perl'}) {
    require LWP::UserAgent;
    $ua=new LWP::UserAgent;
    $ua->env_proxy();
    if ($opt_k) {
      require HTTP::Cookies;
      $cookie_jar = HTTP::Cookies::Netscape->new(File => $opt_k, AutoSave => 1);
      $ua->cookie_jar($cookie_jar);
    }
    $req = HTTP::Request->new(GET => $url);
    $req->authorization_basic(@_) if(@_);
    $ua->agent($spoof) if($spoof);
    my $res = $ua->request($req);
    $code=$res->code;
    $contyp=$res->header('content-type');
    $cont=$res->content;
  } else {
    require "www.pl";
    @opts=@_?("authorization=$_[0]:$_[1]"):();
    push(@opts,"quiet") if(!$opt_d);
    $www::useragent=$spoof if($spoof);
    ($status,$memo,%info)=&www::open_http_url(*FILE,$url,@opts);
    $code=$info{'CODE'};
    ($contyp)=$info{'HEADER'}=~/Content-type:\s+(.*)/i;
    $cont=<FILE>;
  }
}
sub pictops {
  if($opt_g) {
    $fc=1;
    $pg1="pgm";
    $pg2="|ppmtopgm";
  } else {
    $fc=3;
    $pg1="ppm";
    $pg2="";
  }
  ($type)=$URL=~/([^\?]+)\??/;
  ($type)=$type=~/\.(\w+)$/;
  $bm="";
  $ps="";
  $pm="";
  if($opt_U && $src{$URL} && !$cmd{$URL.$red.$grn.$blu}) {
    $pic=$src{$URL};
  } elsif($URL=~m|://|) {
    &geturl($URL,$pic) || return;
  } else {
    $flag=0;
    if($opt_O) {
      $orig=$URL;
      unless($orig=~s/\.\w*$/.ps/) {$orig.=".ps"};
      if(open(ORIG,"$orig")) {
        $pic=<ORIG>;
        close ORIG;
        if($pic=~/^%!/ && $pic=~/%%BoundingBox:/) {
          $flag=1;
          &dbg("Using $orig as original for $URL\n") if($opt_d);
        }
      }
    }
    if(!$flag) {
      if(open(PIC,"$URL")) {
        binmode PIC;
        $pic=<PIC>;
        close PIC;
      } else {
        &dbg("*** Error opening $URL\n");
        return;
      }
    }
  }
  $pic=~s/^[\n\r]*//;
  &trans if($pic=~/^GIF/);
  if($pic=~/^P[1-6]/) {
    $pm=$pic;
  } else {
    open(SCRATCH,">$scr");
    binmode(SCRATCH);
    print SCRATCH "$pic";
    close SCRATCH;
    if($pic=~/^%!/ && $pic=~/%%BoundingBox: +$V +$V +$V +$V/) {
      $xs=$3-$1;
      $ys=$4-$2;
      $ps="save\n0 0 M\nIS IS scale\n/showpage {}D\n".(0-$1)." ".(0-$2)." translate\n";
      for $i (split(/\n/,$pic)) {
        $ps.=$i."\n" if($i && $i!~/^%/);
      }
      $ps.="restore";
    } elsif($type=~/.xbm$/i || $pic=~/^#define/) {
      &xbmtops;
    } elsif($package{'ImageMagick'}) {
      if($package{'PerlMagick'}) {
        $imobj=Image::Magick->new;
        $mess=$imobj->Read($scr);
        if($mess) {
          &dbg("$mess\n");
        } else {
          $mess=$imobj->Write("$scr\.$pg1");
          &dbg("$mess\n") if($mess);
        }
        undef $imobj;
      } else {
#        &run("convert $scr $pg1:-");
        &run("convert $scr $scr\.$pg1");
      }
      open(PNM,"$scr\.$pg1");
      binmode PNM;
      $pm=<PNM>;
      close PNM;
      if(!$pm && $pic=~/^\377\330/ && $package{'djpeg'}) {
        &run("djpeg $scr$pg2");
      }
    } elsif($pic=~/^\377\330/ && $package{'djpeg'}) {
      &run("djpeg $scr$pg2");
    } elsif($package{'pbmplus'} || $package{'netpbm'}) {
      if($pic=~/^GIF/) {
        &run("$giftopm $scr");
      } else {
        &run("anytopnm $scr");
      }
      if($opt_g && $pm=~/^P6/) {
        open(SCRATCH,">$scr");
        binmode(SCRATCH); 
        print SCRATCH $pm;
        close SCRATCH;
        &run("ppmtopgm $scr");
      }
    }
  }
  &pmtops if(!$bm);
  return if(!$bm);
  $bm=substr($bm,0,$nd);
  $pad=$nd-length($bm);
  if($pad) {$bm.="f" x $pad};
  $bm=~s/(.{60})/$1\n/g;
}
sub math2sym {
  local($_)=@_;
  s/<math$R//gi;
  for $char (keys %symb) {s/&($char)(;|$|(?=\W))/\\$symb{$char}/g};
  $stat=!/([&<][a-zA-Z]|[_^{])/;
  s/[a-zA-Z\s]*[a-zA-Z][a-zA-Z\s]*/)ES()I($&)ES()SY(/g;
  s/(\\200|\\201|\\202)/)RO($&)ES(/g;
  $sym=")SY($_)ES(";
  $stat;
}
sub varsub {
  for (@_) {
    s/\\\\/\000/g;
    s/\([^)]+\)/()$&join /g;
    s/(^|[^\\])\$(T|N|U|H|A)/$1)join $vars{$2} join(/g;
    s/(^|[^\\])\$D\{"(.*?)"\}/"$1".POSIX::strftime($+,@now)/eg if($posix);
    s/(^|[^\\])\$D/"$1".POSIX::strftime($datefmt,@now)/eg if($posix);
#    while(/(?=[^\\])\${([^}]+)}/) {
    while(/(?=[^\\])\$\[([^]]+)\]/) {
      if(!defined $metarc{lc $1}) {
        $metarc{lc $1}=$mn++;
      }
      $_="$`)join ME $metarc{lc $1} get join($'";
    }
    s/\\\$/\$/g;
    s/\000/\\\\/g;
    s/\(\)join//g;
    s/\(\) ?(\([^)]*\)|\w+) ?join/ $1/g;
  }
}
sub follow {
  return 0 if(!$opt_W);
  $H=$lnk=~/\.html?(#|$)/i || $lnk=~m|.+//.+/[^/\.]*$|;
  $T=$rev && ($revtoc && $ndoc==1 || $ndoc>1 && $H);
  $L=$b1=~m|://| && $lnk=~m"^$b1(/|$)" || $b1!~m|://| && $lnk!~m|://|;
  $B=$B2 && $lnk=~/^$B2/ || !$B2 && $lnk!~m"(^\.\.|://)";
  return $rlnk && ($H || $T) if($rel);
  return $L && ($H || $T) if($local);
  return $B && ($H || $T) if($below);
  return $H || $T if($rev);
  $H;
}
sub DSC {
  &dbg("Generating DSC PostScript\n") if($opt_d);
  %op=("moveto",2, "rmoveto",2, "lineto",2, "rlineto",2, "translate",2,
       "scale",2, "show",1, "awidthshow",6, "stroke",0, "save",0, "restore",0,
       "gsave",0, "grestore",0, "showpage",0, "newpath",0, "setlinewidth",1,
       "setlinejoin",1, "setgray",1, "closepath",0, "fill",0, "arc",5,
       "setrgbcolor",3, "rotate",1, "image",5, "colorimage",7);
  %sho=("moveto","M", "rmoveto","RM", "lineto","L", "rlineto","RL", "show","S",
        "showpage","N", "awidthshow","A");
  $i=0;
  $po="/OU true D\n";
  for (keys %op) {
    $cmd=$sho{$_}?$sho{$_}:$_;
    push(@val,$cmd);
    $in{$_}=$i++;
    $j=$op{$_}+1;
    $extra="";
    if(/showpage/) {$extra="Bb{Xl Yl Xh Yh}if Pn "};
    if(/image/) {$extra="K ";$j++};
    $t=$op{$_}?"$op{$_} copy $extra$in{$_} $j array astore":"[$extra$in{$_}]";
    $po.="/$_ {OU {$t ==} if $_}d\n";
  }
  $po.="/pdfmark {$i] ==} D\n";
  $in{"pdfmark"}=$i++;
  push(@val,"pdfmark");
  $po.="/NF {OU{2 copy E $i 3 array astore ==}if ONF}d\n"
      ."/EX {[IS EC] ==} D\n/Cd {} D\n/DU {TU PM 1 eq and TP and{Pn ==}if}d\n"
      ."/BB {US Bb{dup Yl lt{dup /Yl E D}if dup Yh gt{/Yh E D}{pop}ie\n"
      ." dup Xl lt{dup /Xl E D}if dup Xh gt{/Xh E D}{pop}ie}\n"
      ." {/Yl E D /Yh Yl D /Xl E D /Xh Xl D /Bb t D}ie}D\n";
  $in{"Nf"}=$i++;
  s|/(NF.*)|/O$1|;
  s|/BB .*|$po|;
  push(@val,"Nf");
  if($psin) {
    ($ti)=/%%Title: (.*)/;
    if(m|/BM (\d+)|) {
      $nbit=$1;
      for $vec ("IT","WS") {
        /\/$vec \[(.*)\]/;
        @$vec=split(' ',$1);
      }
      /\nSB/;
      for (0..$nbit-1) {
        $'=~/\n\n/;
        push(@BM,$`);
      }
    }
    ($epsf)=/(\n\/P\d+_?\d* [\w\W]*)%Endpv/;
    while($epsf=~/\n\/(P\d+_?\d*) \{/g) {
      $pid=$1;
      $rest=$';
      $temp=$'=~/\/P\d+_?\d* \{/?$`:$rest;
      ($eps{$pid})=$temp=~/([\w\W]*)} D/;
    }
    if(/\/DH {/) {
      $'=~/%EndDH/;
      $ph="/DH {$`";
    }
  }
  $j=-1;
  for $i (0..$#IT) {
    $j++ if($IT[$i] == 0);
    push(@ix,$j);
  }
  $dfn="/F $opt_s D\n$ph";
  for (keys %sho) {
    $dfn.="/$sho{$_} {$_} d\n";
  }

  open(SCR,">$scr.ps");
  print SCR "$_ quit\n";
  close SCR;
  $cd{')]'}="Cd ";
  $io="($in{'image'}|$in{'colorimage'})";
  $_="";
  $temp="";
  $pn="";
  $start=1;
  $EPS="%%EndPageSetup";
  $pp=0;
  $n=0;
  
  for $line (split(/\r?\n/,`$gs -q -dNODISPLAY $scr.ps -c quit`)) {
    if(!$pp) {
      $mv="";
      $cx="";
      $cy="";
    }
    if($start && $line!~/ $in{"pdfmark"}\]$/) {
      $pdf=$temp;
      $temp="";
      $start=0;
    }
    $pp=$line=~/^\[(\S+) (\S+) ($in{'moveto'}|$in{'rmoveto'}|$in{'Nf'})\]$/;
    S:{
      if($pp && $3==$in{"Nf"}) {
        $fn="$1 $2 $val[$3]\n";
        last S;
      }
      if($pp && $3==$in{"moveto"}) {
        $cx=$1;
        $cy=$2;
        $mv=sprintf("%.1f %.1f %s\n",$1,$2,$val[$3]);
        last S;
      }
      if($pp && $3==$in{"rmoveto"}) {
        if($mv) {
          $cx+=$1;
          $cy+=$2;
          $mv=sprintf("%.1f %.1f %s\n",$cx,$cy,$val[$in{"moveto"}]);
        } else {
          $temp.=sprintf("%.1f %.1f %s\n",$1,$2,$val[$3]) if($1||$2);
        }
        last S;
      }
      if($line=~s/^\[(.*)\((\S*)\) ($in{"showpage"})\]$/pgsave restore $val[$3]/) {
        $pbb="";
        if($1) {
          ($llx,$lly,$urx,$ury)=split(/ /,$1);
          $llx=int($llx);
          $lly=int($lly);
          $urx=int($urx+1);
          $ury=int($ury+1);
          $pbb="%%PageBoundingBox: $llx $lly $urx $ury\n";
          if(!defined($Llx) || $llx<$Llx) {$Llx=$llx};
          if(!defined($Lly) || $lly<$Lly) {$Lly=$lly};
          if(!defined($Urx) || $urx>$Urx) {$Urx=$urx};
          if(!defined($Ury) || $ury>$Ury) {$Ury=$ury};
        }
        $pn.="," if($pn && $2);
        $n++;
        @df=();
        for(0..$#docfonts) {
          push(@df,$docfonts[$_]) if($uf{$_}==$n);
        }
        push(@df,"Symbol") if($uf{"-1"}==$n);
        $fu="";
        $tmp=@df?"%%PageResources: font":"";
        &splitline(@df);
        $_.="%%Page: $pn$2 $n\n$fu$pbb%%BeginPageSetup\n/pgsave save D\n$temp$line\n";
        $EPS="%%EndPageSetup";
        $temp="";
        $line="";
        $fn="";
        $mv="";
        $pn="";
        last S;
      }
      if($line=~/^\[([^(]*)(\(.*\)) ($in{"show"}|$in{"awidthshow"})\]$/) {
        if(length $2>2) {
          $line="$fn$1$2 $val[$3]";
          if($fn=~/(\S+) Nf/ && $uf{$1}!=$n+1) {
            $uf{$1}=$n+1;
            $fnt=$1<0?"Symbol":$docfonts[$1];
            $line="%%IncludeResource: font $fnt\n$line";
          }
          $fn="";
          $pp=0;
        } else {
          $pp=1;
        }
        last S;
      }
      if($line=~/^\[(\S+) (\S+) ($in{"scale"})\]$/) {
        $line=$1!=1||$2!=1?"$1 $2 $val[$3]\n$EPS":"$EPS";
        $EPS="";
        last S;
      }
      if($line=~/^\[(.*) (\d+) $io\]$/) {
        $li=$BM[$2]=~y/\n/\n/+2;
        $line="\/picstr $WS[$ix[$2]] string D\n$1\n"
             ."%%BeginData: $li Hex Lines\n$val[$3]\n$BM[$2]\n%%EndData";
        last S;
      }
      if($line=~/^\((.*)\)$/) {
        $pn=$1;
        $line="";
        last S;
      }
      last S if($line=~s/^\[([^\/].* )?(\d+)\]$/$1$val[$2]/);
      last S if($line=~s/(\)\])? (\/\w+) $in{"pdfmark"}\]$/$1 $cd{$1}$2 pdfmark/);
      last S if($line=~s/^\[(\S+) \((P\d+.*)\)\]$/\/IS $1 D\n$eps{$2}/);
      &dbg("$line\n");
    }
    if(!$pp && $mv.$line) {
      $mv=~s/\.0//g;
      $temp.="$mv$line\n";
    }
  }
  @nf=();
  @sf=();
  $fontdef="";
  for(0..$#docfonts) {
    $ff=$ff{$docfonts[$_]};
    if($ff && $uf{$_}>0) {
      push(@sf,$docfonts[$_]);
      $fontdef.="%%BeginResource: font $docfonts[$_]\n$cont{$ff}\n%%EndResource\n";
      $cont{$ff}="";
    }
    push(@nf,$docfonts[$_]) if(!$ff && $uf{$_}>0);
  }
  push(@nf,"Symbol") if($uf{"-1"}>0);
  $ti="@ARGV" unless($psin);
  $or=$opt_L?"Landscape":"Portrait";
  $setup="%%BeginSetup\n";
  $setup.="$dupl\n" if($dupl);
  $setup.="$fontdef" if($fontdef);
  $fu="";
  $tmp=@nf?"%%DocumentNeededResources: font":"";
  &splitline(@nf);
  $tmp=@sf?"%%DocumentSuppliedResources: font":"";
  &splitline(@sf);
  s/\\(200|201|202)/\\$ssy{$1}/g;
  $dd="Clean7Bit";
  $dd="Clean8Bit" if(($fontdef.$_)=~/[\200-\377]/);
  $dd="Binary" if(($fontdef.$_)=~/[\000-\010\013-\014\016-\036]/);
  $time=localtime;
  print <<EOT;
%!PS-Adobe-3.0
%%Title: $title
%%Creator: $version
%%CreationDate: $time
$fu%%DocumentData: $dd
%%Orientation: $or
%%BoundingBox: $Llx $Lly $Urx $Ury
%%Pages: $n
%%EndComments
%%BeginProlog
/d {bind def} bind def
/D {def} d
/ie {ifelse} d
/E {exch} d
/t true D
/f false D
$fl
$cd
$defs
$mysymb/Nf {dup 0 ge{FL E get}{-1 eq{/Symbol}{/MySymbol}ie}ie findfont
 E scalefont setfont} D
/IP {currentfile picstr readhexstring pop} D
/WF $wf D
$dfn%%EndProlog
$setup$reenc$pdf%%EndSetup
$_%%EOF
EOT
}
sub splitline {
  for (@_) {
    if(length($tmp.$_)>78) {
      $fu.="$tmp\n";
      $tmp="%%+ font";
    }
    $tmp.=" $_";
  }
  $fu.="$tmp\n" if($tmp);
}
sub ref {
  @pnum=();
  /.*\s*$/;
  open(SCR,">$scr.ps");
  print SCR "$`HN{==}forall $& quit\n";
  close SCR;
  $pnum=`$gs -q -dNODISPLAY $scr.ps -c quit`;
  while($pnum=~/\([^)]*\)/g) {push(@pnum,$&)};
  $pnum="@pnum";
  &cut($pnum);
  s|/HN [^D]*D|/HN [$pnum] D|;
}
sub cut {
  $_[0]=~s/(.{70}[^ \n]*) ([^ ])/$1\n$2/g;
}
sub fin {
  if($opt_D) {
    &DSC;
  } else {
    print;
  }
  if($opt_d) {
    print DBG "\n";
    close DBG;
  }
  unlink "$scr","$scr.ps","$scr.ppm","$scr.tex","$scr.dvi","$scr.log" if($scr);
  exit;
}
sub col2rgb {
  $rgb=$colour{"\L$_[0]"}?($colour{"\L$_[0]"}):$_[0];
  @cvec=$rgb=~/($X$X)($X$X)($X$X)/?($1,$2,$3):();
  @cvec?"[16#$1 16#$2 16#$3]":"";
}
sub inihyph {
  if($hyphenation_file{$lang}) {
    $hyfile=$hyphenation_file{$lang};
  } else {
    &dbg("No hyphenation file for language '$lang'\n");
    $lng=$lang;
    while($lng=~s/-?[^-]+$// && !$hyphenation_file{$lng}) {};
    $hyfile=$hyphenation_file{$lng};
    &dbg(" ..using $hyfile\n");
  }
  if($init{$hyfile}) {
    $rep{$lang}=$refl{$hyfile};
    return;
  }
  if(open(HYPH,$hyfile)) {
    &dbg("Reading hyphenation patterns from $hyfile\n") if($opt_d);
    <HYPH>=~/\\patterns{.*/;
    close HYPH;
    $def=$`;
    ($patterns=$')=~s/\^\^($X$X)/chr hex $1/eg;
    $upp{$lang}='';
    $low{$lang}='';
    while ($def=~/\\lccode(`\\?\^\^|")($X$X)=(`\\?\^\^|")($X$X)/g) {
      if($2 ne $4) {
        $uc=$2;
        $lc=$4;
        if($`=~/\n$/ || $`!~/%.*$/) {
          $upp{$lang}.=chr hex $uc;
          $low{$lang}.=chr hex $lc;
        }
      }
    }
    while ($def=~/\\let\\(\w+)=(\^\^|")($X$X)/g) {
      $key=$1;
      $value=chr hex $3;
      $tex{$key}=$value if($`=~/\n$/ || $`!~/%.*$/);
    }
    for $key (keys %tex) {
      $patterns=~s/\\$key */$tex{$key}/g;
    }
    if($lang=~/^de/) {
      %de=('"a',228, '"o',246, '"u',252, '\3', 223);
      $patterns=~s/\\c\{[^}]*\}//g;
      $patterns=~s/\\n\{([^}]*)\}/$1/g;
      $patterns=~s/("a|"o|"u|\\3)/chr $de{$1}/eg;
      $upp{"de"}=~s/\337//;
      $low{"de"}=~s/\377//;
    }
    if($lang=~/^is/ && !$upp{"is"}) {
      %is=("'a","\341", "'e","\351", "'i","\355", "'o","\363", "'u","\372",
           "'y","\375", '"x',"\346", '"o',"\366", "'d","\360", "`t","\376");
      $isch=join("|",keys %is);
      $patterns=~s/($isch)/$is{$1}/g;
      $upp{"is"}="\301\311\315\323\332\335\306\326\336\320";
      $low{"is"}="\341\351\355\363\372\375\346\366\376\360";
    }
    if($lang=~/^fi/ && !$upp{"fi"}) {
      $upp{"fi"}="\304\326";
      $low{"fi"}="\344\366";
    }
    if($lang=~/^fr/ && !$upp{"fr"}) {
      $upp{"fr"}="\300\302\307\311\310\312\313\316\317\324\326\333\226";
      $low{"fr"}="\340\342\347\351\350\352\353\356\357\364\366\373\225";
    }
    if($lang=~/^es/ && !$upp{"es"}) {
      $upp{"es"}="\301\311\315\323\321\332\334";
      $low{"es"}="\341\351\355\363\361\372\374";
    }
    $patterns=~s/\{([\w\W]*?)\}/[$1]/g;
    $patterns=~/}/;
    $end=$`;
    if($def.$'=~/\\hyphenation\[.*/) {
      $'=~/]/;
      $hyext=$`;
    }
    ($patterns=$end)=~s/%.*//g;
    for $key (split('\s+',$patterns)) {
      $value=$key;
      $key=~s/\d//g;
      $value=~s/^([$ltrs.])/0$1/;
      $value=~s/[$ltrs](\d)/$1/g;
      $value=~s/[$ltrs.]/0/g;
      $patt{"$key,$lang"}=$value if($value=~/^\d+$/);
    }
  } else {
    &dbg("Cannot open hyphenation file: $hyfile\n");
  }
  $hext=$hyphenation_extfile{$lang};
  for(split('\s*:\s*',$hext)) {
    if(open(HEXT,$_)) {
      &dbg("Reading hyphenation extensions from $_\n") if($opt_d);
      $hyext.=<HEXT>;
      close HEXT;
    } else {
      &dbg("Cannot open hyphenation extension file: $_\n");
    }
  }
  if($hyext) {
    for $key (keys %tex) {
      $hyext=~s/$key */$tex{$key}/g;
    }
    for $key (split('\s+',$hyext)) {
      $key=~s/\s+//g;
      $value="00$key\0";
      $key=~s/-//g;
      $value=~s/[$ltrs]/0/g;
      $value=~s/0-/1/g;
      $hext{"$key,$lang"}=$value;
    }
  }
  $refl{$hyfile}=$lang;
  $rep{$lang}=$lang;
  $init{$hyfile}=1;
}
sub hyph {
  $word="\L$_[0]";
  eval "\$word=~y/$upp{$rep{$lang}}/$low{$rep{$lang}}/" if($upp{$rep{$lang}});
  $len=length($word);
  $h=$hext{"$word,$rep{$lang}"};
  if($h) {
    @br=split(//,$h);
  } else {
    @br=(0) x ($len+3);
    for $i (0..$len) {
      for $j (0..$len-$i) {
        $str=substr(".$word.",$j,$i+2);
        $pstr=$patt{"$str,$rep{$lang}"};
        if($pstr) {
          @patt=split(//,$pstr);
          for $k (0..$#patt) {
            $br[$k+$j]=$patt[$k] if($br[$k+$j]<$patt[$k]);
          }
        }
      }
    }
  }
  $hword="";
  for $i (0..$len-1) {
    $hword.=substr($_[0],$i,1);
    if(($h || $i>$hyphenation{'start'}-2 && $i<$len-$hyphenation{'end'})
      && $br[$i+2]%2==1) {$hword.=")HY("};
  }
  $hword.=")YH(" if(length $word < length $hword);
  $hword;
}
sub setel {
  $el=$_[0];
  eval "\%arr=\%$el";
  &fs($el);
  push(@font,$fontid{"\L$font"});
  push(@styl,$styl);
  push(@size,$arr{'font-size'});
  push(@alig,$algn{$arr{'text-align'}}-1);
  push(@topm,$arr{'margin-top'});
  push(@botm,$arr{'margin-bottom'});
  push(@lftm,$arr{'margin-left'});
  push(@rgtm,$arr{'margin-right'});
  push(@colr,$col eq "[16#00 16#00 16#00]"?0:$col);
  $temp=$arr{'margin-top'}*$arr{'font-size'};
  $mi=$temp if($temp>$mi);
  $temp=$arr{'margin-bottom'}*$arr{'font-size'};
  $mi=$temp if($temp>$mi);
}
sub fs {
  $arr{'font-family'}='times' if($el ne 'p' && !$latin1 && !defined $arr{$_});
  for ("font-family","font-size") {
    $arr{$_}=$body{$_} if(!defined $arr{$_});
  }
  ($font=$arr{'font-family'})=~s/\W/-/g;
  if(!$font_names{"\L$font"}) {$font=$fal{$font}};
  if(!$font_names{"\L$font"}) {
    &dbg("Unknown font: $arr{'font-family'}, using $deffnt{$_[0]}\n");
    $font=$deffnt{$_[0]};
  }
  if(!defined $fontid{"\L$font"}) {
    $fontid{"\L$font"}=$nfont++;
    @names=split(/\s+/,$font_names{"\L$font"});
    for($#names+1..3) {push(@names,$names[0])};
    @docfonts=(@docfonts,@names);
  }
  &getval($arr{"font-size"},2);
  for ('left','right','top','bottom') {
    $arr{"margin-$_"}=0 if(!defined $arr{"margin-$_"});
  }
  for ($arr{"text-indent"},$arr{"margin-top"},$arr{"margin-bottom"},
       $arr{"margin-left"},$arr{"margin-right"}) {
    &getval($_,0);
  }
  $styl=$arr{'font-style'}=~/^(i|o)/+2*($arr{'font-weight'}=~/^b/);
  $col=$arr{'color'}?&col2rgb($arr{'color'}):-1;
}
sub img {
  local($_,$red,$grn,$blu)=@_;
  local($beg,$end);
  ($red,$grn,$blu)=("FF","FF","FF") if(!$opt_U);
  while (/<(img|fig|hr|overlay|object)\s/i) {
    $imgcmd="\L$1";
    $beg=$`;
    $'=~/>/;
    $img=" $`";
    $end=$';
    $img=~s/\n/ /g;
    if($imgcmd ne "object" || $img=~/data\s*=\s*['"]?([\w\/\.:~%-]+\.$IM)/i
       || $img=~/type\s*=\s*['"]?(image\/|application\/postscript)/i){
    if($opt_T) {
      &getalt;
    } else {
      $al=0;
      $off="";
      ($align)=$img=~/align\s*=\s*['"]?(\w*)/i;
      if($align=~/^middle$/i) {$al=1};
      if($align=~/^top$/i) {$al=2};
      if($imgcmd eq "overlay") {
        $al=4;
        $xoff=0;
        $yoff=0;
        if($img=~/\s*x\s*=\s*['"]?(\d+)/i) {$xoff=$1};
        if($img=~/\s*y\s*=\s*['"]?(\d+)/i) {$yoff=$1};
        $off="$xoff $yoff ";
      }
      $url="";
      if($img=~/\s(src|data)\s*=\s*($S)/i) {($url)=$+=~/([^ \n]*)/};
      &dbg("Image: $url\n") if($opt_d && $url);
      $URL=$url;
      unless($url=~m|://|) {
        $url=~s/^file://;
        if($url=~m|^/|) {$URL=$b1.$url} else {$URL=$b2.$url}
      }
      while($URL!~m|^\.\./| && $URL=~m|[^/]*/\.\./|) {$URL=$`.$'};
      $URL=~s|/\./|/|g;
      $text=$src{$URL}?$cmd{$URL.$red.$grn.$blu}:$cmd{$URL};
      if(!$text || $opt_U && $src{$URL} && !$cmd{$URL.$red.$grn.$blu}) {
        if(!$url || $failed{$url}) {
          &getalt;
        } else {
          &pictops;
          if($bm || $ps) {
            &dbg("Size: $xs*$ys\n") if($opt_d);
            $nimg++;
            push(@XS,$xs);
            push(@YS,$ys);
            if($bm) {
              $nm++;
              push(@DP,$dp);
              push(@BM,$bm);
              push(@WS,int(($xs-1)*$dp/8)+1);
              push(@FC,$fc);
              push(@IX,$nm);
              push(@IT,0);
            }
            if($ps) {
              $nps--;
              push(@IX,$nps);
              push(@IT,1);
              $nli=30000;
              $n=1;
              $npr=$ps=~s|(.*\n){$nli}|sprintf("$&} D\n/P$nimg\_%d {",$n++)|eg;
              if($npr) {
                $proc=" (";
                for $i (0..$npr) {
                  $proc.="P$nimg\_$i ";
                }
                $proc.=")";
                $pv.="/P$nimg\_0 {$ps} D\n";
                $eps{"P$nimg\_0"}=$ps;
              } else {
                $proc=" (P$nimg)";
                $pv.="/P$nimg {$ps} D\n";
                $eps{"P$nimg"}=$ps;
              }
            }
            $text="$proc $nimg IM(";
            $cmd{$URL}=$text if(!$cmd{$URL});
            $cmd{$URL.$red.$grn.$blu}=$text if($src{$URL});
            $proc="";
            $end=$' if($imgcmd eq "object" && $end=~m|</object>|i);
          } else {
            &getalt;
            $failed{"$url"}=1;
          }
        }
      } elsif($imgcmd eq "object" && $end=~m|</object>|i) {
        $end=$';
      }
    }
    if($cmd{$URL}) {
      $text=")".$off.$al.$text;
      if($imgcmd eq "fig") {
        $end=~m|</fig>|i;
        $fig=$`;
        $end=$';
        $over="";
        while($fig=~/(<overlay$R)/ig) {$over.=$1};
        ($dum,$cap)=$fig=~m|<caption$R([\w\W]*)</caption>|i;
        ($dum,$cred)=$fig=~m|<credit$R([\w\W]*)</credit>|i;
        $text=")BN($text$over)BN($cap)BN($cred)BN(";
      }
    }
    }
    $_=$beg.$text.$end;
  }
  s|<[hH][rR]$R|)2 1 1 HR(|g;
  $_[0]=$_;
}
sub getval{
  local($val,$unit)=$_[0]=~/$V\s*(\w*)/g;
  $val*=$cm{$unit} if($_[1]==1 && defined $cm{$unit});
  $val*=$pt{$unit} if($_[1]==2 && defined $pt{$unit});
  $_[0]=$val;
}
sub getconf {
  local($_)=@_;
  while(/\@import\s+(([\w.\/-]+)|"([^"]*)"|'([^']*)')\s*;/) {
    if(open(SS,$+) && !$read{$+}) {
      $conf=<SS>;
      $_=$`.$conf.$';
      print DBG "***** $+:\n$conf" if($opt_d);
      close SS;
      $read{$+}=1;
    } else {
      &dbg($read{$+}?"Infinite \@import loop: $+\n":"Error opening: $+\n");
      $_=$`.$';
    }
  }
  @block=();
  while(&getblk($_)){};
}
sub getblk {
  local($_)=@_;
  local ($beg,$match,$end,$blk,$key,$val,$id,$temp);
  while(/^\s*\/\*/) {
    /\*\/|$/;
    $_=$';
  }
  return 0 if !/\S/;
  /[\w,:.@\s-]+\{/;
  $_=$';
  ($id=$&)=~s/^\s*|\s*\{//g;
  $id=lc $id;
  push(@block,"\L$id");
  if($#block==1) {
    $valid{$id}=1 if(!$user);
    if($id eq "color") {$id="colour"};
    if(!$valid{$id}) {
      &dbg("Error in configuration file: unknown block name '$id'\n");
    }
  }
  $blk="";
  W:while(/\s*(\/\*|[\w][\w-]*\s*:|[\w,:.\s-]+\{|\})\s*/) {
    $blk.=$1 if($1 ne "/*");
    $beg=$`;
    $match=$1;
    $end=$';
    S:{
      if($match=~/\{$/) {
        $temp=$match.$end;
        $blk.=&getblk($temp);
        $_=$temp;
        last S;
      }
      if($match=~/:$/) {
        ($key=$`)=~s/\s*$//;
#        $end=~/([\w.\$-]+|"[^"]*"|'[^']*')\s*;?/;
        $end=~/("[^"]*"|'[^']*'|.*?(?= *(\/\*|;|}|$)))/m;
        $blk.=$`.$&;
        $_=$';
        ($val=$1)=~s/^["']|["']$//g;
        $val=~s/'|\\/\\$&/g;
        $typ=1;
        $typ=2 if($val=~/^$V(cm|mm|in|pt|pc|em)$/);
        $typ=3 if($val=~/^$V$/);
        $typ=4 if($val=~/^-?\d+$/);
        $typ=5 if($val eq "0" || $val eq "1");
        if($block[0] eq '@html2ps') {
          if($#block==0) {
            if(!$user) {
              $valid{$key}=1;
              $type{$key}=$typ if(!defined $type{$key});
            }
            if($valid{$key}) {
              if($typ>=$type{$key}) {
                $key=~s/-/_/g;
                eval "\$$key='$val'" if($user || $val ne '');
#                print DBG "\$$key='$val'\n" if($opt_d && $user);
              } elsif($user) {
                &dbg("Error in configuration file: bad value for $key: $val\n");
              }
            } else {
              &dbg("Error in configuration file: unknown key '$key'\n");
            }
          }
          if($#block==1) {
            if($id eq "option" && $optalias{$key}) {$key=$optalias{$key}};
            if(!$user) {
              $valid{"$id,$key"}=1;
              $type{"$id,$key"}=$typ if(!defined $type{"$id,$key"});
            }
            if($valid{"$id,$key"} || $extend{$id}) {
              if($typ>=$type{"$id,$key"} || $id eq "colour") {
                eval "\$$id\{'$key'}='$val'" if($user || $val ne '');
#                print DBG "\$$id\{'$key'}='$val'\n" if($opt_d && $user);
              } elsif($user) {
                &dbg("Error in configuration file: bad value for $key: $val\n");
              }
            } else {
              &dbg("Error in block '$id' in configuration file:"
                  ." unknown key '$key'\n");
            }
          }
          if($#block>1) {
            $temp="$block[$#block-1]_$key";
            $valid{$temp}=1 if(!$user);
            $parblk=$block[$#block-1];
            if($valid{$temp}) {
              eval "\$$parblk\_$key\{'$id'}='$val'";
#              print DBG "\$$parblk\_$key\{'$id'}='$val'\n" if($opt_d && $user);
            } elsif($valid{$parblk}) {
              &dbg("Error in block '$parblk' in configuration file:"
                  ." unknown key '$key'\n");
            }
          }
        } else {
          for $i (split(',\s*',$id)) {
            $i=~s/@/AT_/;
            $i=~s/\./_/;
            $i=~s/ *:/__/;
            eval "\$$i\{'\L$key'}='\L$val'";
#            print DBG "\$$i\{'\L$key'}='\L$val'\n" if($opt_d && $user);
          }
        }
        last S;
      }
      if($match eq "/*") {
        /\*\/|$/;
        $_=$';
        last S;
      }
    last W;
    }
  }
  pop(@block);
  $_[0]=$end;
  $blk;
}
sub prompt {
  local($/)="\n";
  &dbg($_[0]);
  chop($_[1]=<STDIN>);
}
sub dbg {
  print STDERR $_[0];
  print DBG $_[0];
}
sub hb {
  local($_)=@_;
  local($head,$body,$beg,$end,$match,$tag);
#If neither </HEAD> nor <BODY> can be found, find the separation point (messy).
  if(!/<(body|\/head)/i || $`=~/<plaintext|<xmp|<listing|<!--/i) {
    $head="";
    $int="";
    S1: while(/<(\/?\w+|!--|!|\?)/) {
      S2:{
        $beg=$`;
        $end=$';
        $match=$&;
        $tag=$1;
        if($tag eq "!--") {
          $int.=$`;
          &getcom;
          $int.=$com;
          $_=$rest;
          last S2;
        }
        if($tag=~/[!?]/) {
          $end=~/>/;
          $int.="$beg$match$`>";
          $_=$';
          last S2;
        }
        $tag=~s|/||;
        last S1 if(!$head{"\L$tag"});
        $end=~/$R/;
        $head.=$int.$beg.$match.$&;
        $int="";
        $_=$';
      }
    }
    $body=$int.$_;
  } else {
    $head=$`;
    $body=$&.$';
  }
  $_[0]=$body;
  $_[1]=$head;
}
sub open {
  if($_[0]=~m|://|) {
    &geturl($_[0],$_[1]);
  } elsif(open(FILE,$_[0])) {
    $_[1]=<FILE>;
    close FILE;
  } else {
    0;
  }
}
sub pagedef {
  for $margin ('left','right','top','bottom') {
    ($m)=$margin=~/(.)/;
    if(defined $margin{$margin}) {
      &dbg("'margin { margin-$margin:... }' is obsolete, use '\@page'\n");
      $AT_page{"margin-$margin"}=$margin{$margin} if(!defined $AT_page{"margin-$margin"});
    }
    for $page ('left','right') {
      ($p)=$page=~/(.)/;
        eval "\$m$m$p=\$AT_page\{'margin'} if(defined \$AT_page\{'margin'})";
        eval "\$m$m$p=\$AT_page\{'margin-$margin'} if(defined \$AT_page\{'margin-$margin'})";
        eval "\$m$m$p=\$AT_page__$page\{'margin'} if(defined \$AT_page__$page\{'margin'})";
        eval "\$m$m$p=\$AT_page__$page\{'margin-$margin'} if(defined \$AT_page__$page\{'margin-$margin'})";
    }
  }
}
sub pmtoraw {
  @pars=();
  ($temp)=@_;
  for $i (0..3) {
    1 while ($temp=~s/^\s*#.*//);
    next if($pars[0] eq 'P1' && $i == 3);
    $temp=~s/\s*(\S+)\s*//;
    $pars[$i]=$1;
  }
  $temp=~s/#.*//g;
  $pars[0]=~s/\d/$&+3/e;
  $_[0]="$pars[0]\n$pars[1] $pars[2]\n";
  if($pars[0] eq 'P4') {
    $temp=~s/\s//g;
    $_[0].=pack("B*",$temp);
  } else {
    $_[0].="255\n";
    while ($temp=~/\d+/g) {
      $_[0].=pack("C",int(255*$&/$pars[3]+.5));
    }
  }
}

__END__
:endofperl
