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
#!/usr/bin/perl -w
#line 15
################################################################################
#
# PROGRAM: ccconfig
#
################################################################################
#
# DESCRIPTION: Get Convert::Binary::C configuration for a compiler.
#
################################################################################
#
# $Project: /Convert-Binary-C $
# $Author: mhx $
# $Date: 2003/04/19 15:38:24 +0200 $
# $Revision: 40 $
# $Snapshot: /Convert-Binary-C/0.40 $
# $Source: /bin/ccconfig $
#
################################################################################
#
# Copyright (c) 2002-2003 Marcus Holland-Moritz. All rights reserved.
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
################################################################################

use IO::File;
use Getopt::Long;
use Data::Dumper;
use strict;

my($NAME) = $0 =~ /([\w\.]+)$/;
my $VERSION = ('$Snapshot: /Convert-Binary-C/0.40 $' =~ /([^\/\s]+)\s*\$$/)[0];
my $MESSAGE = "\nThis is $NAME, v$VERSION ($0).\n";
my %OPT;

unless( GetOptions( \%OPT, qw(
          cc|c=s ppout|p=s temp|t=s
          version debug quiet status! run! delete!
      ) ) ) {
  # poor man's pod2usage...
  my($USAGE) = do { local(@ARGV,$/)=($0); <> }
               =~ /^__END__.*?^=head\d\s+SYNOPSIS(.*?)^=/ms;
  my %M = ( 'I' => '*' );  # minimal markup
  $USAGE =~ s/([A-Z])<([^>]+)>/$M{$1}$2$M{$1}/g;
  $USAGE =~ s/^/    /gm;
  print STDERR "\nUsage:$USAGE",
               "Try `perldoc $NAME' for more information.\n\n";
  exit 2;
}

if( $OPT{version} ) {
  print <<VERSION;
$MESSAGE
Copyright (c) 2002-2003 Marcus Holland-Moritz. All rights reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

VERSION
  exit 0;
}

STDERR->autoflush(1);

$OPT{quiet} or print STDERR $MESSAGE, "\n";

my $cc  = new Compiler::Config %OPT, ccflags => [@ARGV];
my $cfg = $cc->get_config;
$cc->cleanup;

unless( $OPT{quiet} ) {
  my($wall, $usr, $sys, $cusr, $csys) = (time - $^T, times);
  my $cpu = sprintf "%.2f", $usr + $sys + $cusr + $csys;
  $usr = sprintf "%.2f", $usr + $cusr;
  $sys = sprintf "%.2f", $sys + $csys;
  print STDERR <<END;

$wall wallclock secs ($usr usr + $sys sys = $cpu CPU)

END
}

print Data::Dumper->Dump( [$cfg], ['*config'] );

exit 0;


package Compiler::Config;

use IPC::Open3;
use IO::File;
use Data::Dumper;
use Text::Wrap;
use File::Basename;
use Carp;
use strict;

use constant SUCCESS     => 0;
use constant ERR_REQUIRE => 1;
use constant ERR_CREATE  => 2;
use constant ERR_CONFIG  => 3;

use constant UNKNOWN     => 0;
use constant GNU_GCC     => 1;
use constant INTEL_ICC   => 2;
use constant MS_VCPP     => 3;

my %type_map;

BEGIN {
  %type_map = (
    &MS_VCPP => { 'long long' => '__int64' }
  );
};

sub ANSI_headers
{
  qw(
    assert.h  ctype.h  errno.h   float.h   limits.h
    locale.h  math.h   setjmp.h  signal.h  stdarg.h
    stddef.h  stdio.h  stdlib.h  string.h  time.h
  )
}

sub _preset_names
{
  qw(
    __386BSD__ __3dNOW__ __3dNOW_A__ __64BIT__ ____386BSD____ a29k ABI64
    ABIN32 ADDR64 aegis AES_SOURCE AIX AIX32 AIX370 AIX41 AIX42 AIX43 AIX51
    AIX64 AIX_SOURCE aixpc ALL_SOURCE alliant ALMOST_STDC alpha ALPHA_
    Alpha_AXP alpha_bwx alpha_cix alpha_ev4 alpha_ev5 alpha_ev6 alpha_fix
    alpha_max alpha_vxworks ALTIVEC AM29000 am29050 AM29K AM33 AMD64 amiga
    AMIGAOS AMIX ansi ANSI_C_SOURCE ANSI_COMPAT AOUT APCS_26 APCS_32 apollo
    APOLLO_SOURCE APPLE APPLE_CC APX386 arc arch64 arch_ arch__v3 arch__v8
    ARCH_COM ARCH_PPC ARCH_PPC64 ARCH_PWR ARCH_PWR2 arch_v10 arch_v3
    arch_v8 ARCHITECTURE ardent arm arm2 arm32 arm6 ARM_ARCH_2 ARM_ARCH_3
    ARM_ARCH_3M ARM_ARCH_4 ARM_ARCH_4T ARM_ARCH_5 ARM_ARCH_5E ARM_ARCH_5T
    ARM_ARCH_5TE arm_elf arm_oabi ARMEB ARMEL ARMWEL atarist athlon
    athlon_sse att386 att3b AUX AUX_SOURCE AVR AVR_ARCH AVR_ASM_ONLY
    AVR_AT43USB320 AVR_AT43USB355 AVR_AT76C711 AVR_AT90C8534 AVR_AT90S1200
    AVR_AT90S2313 AVR_AT90S2323 AVR_AT90S2333 AVR_AT90S2343 AVR_AT90S4414
    AVR_AT90S4433 AVR_AT90S4434 AVR_AT90S8515 AVR_AT90S8535 AVR_AT94K
    AVR_ATmega103 AVR_ATmega128 AVR_ATmega16 AVR_ATmega161 AVR_ATmega163
    AVR_ATmega32 AVR_ATmega323 AVR_ATmega603 AVR_ATmega64 AVR_ATmega8
    AVR_ATmega83 AVR_ATmega85 AVR_ATtiny11 AVR_ATtiny12 AVR_ATtiny15
    AVR_ATtiny22 AVR_ATtiny28 AVR_ENHANCED AVR_MEGA base BeOS BIG_ENDIAN
    BIGMODEL BIT_MSF bool BSD bsd43 bsd4_2 BSD4_3 bsd4_4 BSD_4_3 BSD_4_4
    BSD_C BSD_NET2 BSD_SOURCE BSD_TIME BSD_TYPES BSDCOMPAT bsdi BUFSIZ bull
    BULL_SOURCE BYTE_MSF BYTE_ORDER c C30 C31 C32 C33 C3x C40 C44 C4x
    cadmus CALL_AIX CALL_AIXDESC CALL_NT CALL_SYSV cdecl CHAR_UNSIGNED
    CLASSIFY_TYPE clipper CMU COFF COMPILER_VERSION CONCURRENT CONIX convex
    convex_c1 convex_c2 convex_c32 convex_c34 convex_c38 CONVEX_FLOAT_
    CONVEX_SOURCE cplusplus CPU CPU_FAMILY CPU_VARIANT CRAY CRAYIEEE
    CRAYMPP CRAYT3E CRIS CRIS_ABI_version CRIS_arch_tune CRIS_arch_version
    ctix CX_UX CYGWIN CYGWIN32 D30V DCC DCE_THREADS DCPLUSPLUS declspec
    DGUX DGUX_SOURCE DGUX_TARGET DIAB_TOOL DJGPP dmert DOLPHIN
    DOUBLE_IS_32BITS DPX2 DSO DSP1600 DSP1610 DYNAMIC Dynix DynixPTX EABI
    ECOFF ELF elinux elxsi embedded encore EPI EXTENSIONS EXTERN_PREFIX
    FAVOR_BSD FILE_OFFSET_BITS FILENAME_MAX float128 float80 fpreg fr30
    FreeBSD frv FRV_ACC FRV_DWORD FRV_FPR FRV_GPR FRV_HARD_FLOAT
    FRV_UNDERSCORE FRV_VLIW G_FLOAT gcc GCC_NEW_VARARGS gcos gcx GFLOAT
    gimpel GLIBC GLIBC_MINOR gmicro GNU GNU_CRIS gnu_hurd GNU_LIBRARY
    gnu_linux GNU_SOURCE GNUC GNUC_MINOR GNUC_PATCHLEVEL GO32 gould
    GOULD_PN GP_SUPPORT H3050R H3050RX H8300 H8300H H8300S hardfp
    HAVE_68881 HAVE_CE HAVE_FPA HAVE_FPU HAVE_SHORT_DOUBLE HAVE_SHORT_INT
    HAVE_SKY hbullx20 hcx HITACHI HIUX_SOURCE host_mips hp200 hp300 hp64000
    hp64902 hp64903 HP700 hp800 hp9000 hp9000ipc hp9000s200 hp9000s300
    hp9000s400 hp9000s500 hp9000s700 hp9000s800 hp9k8 HP_aCC hp_osf hppa
    hpux HPUX_ASM HPUX_SOURCE hypersparc i186 i286 i370 i386 i486 i586 i686
    i8086 I80960 i860 i960 i960_CA i960_CC i960_CF i960_KA i960_KB i960_MC
    i960_SA i960_SB i960CA i960CC i960CF i960JA i960JD i960JF i960KA i960KB
    i960MC i960RP i960SA i960SB IA64 iAPX286 IBITS32 ibm ibm032 ibmesa
    IBMR2 ibmrt IEEE_FLOAT IEEE_FLOAT_ IEEE_FP IEEE_FP_INEXACT ILP32 ILP64
    INCLUDE__STDC__ INCLUDE_LONGLONG INLINE INLINE_INTRINSICS INT int128
    INT64 INT_MAX INTEL interdata INTERIX INTRINSICS IP2K is68k itanium
    ix86 k6 k6_2 k6_3 KPRINTF_ATTRIBUTE KR ksr1 LANGUAGE_ASSEMBLY
    LANGUAGE_C LANGUAGE_C_PLUS_PLUS LANGUAGE_OBJECTIVE_C LARGE_FILE_API
    LARGEFILE64_SOURCE LARGEFILE_SOURCE LD64 LDBL LE370 LFS64_LARGEFILE
    LFS_LARGEFILE lint Linux LITTLE_ENDIAN LITTLE_ENDIAN_DATA LONG64
    LONG_DOUBLE LONG_DOUBLE_128 LONG_DOUBLE_64 LONG_LONG LONG_LONG_MAX
    LONG_MAX LONGDOUBLE LONGLONG LP64 luna luna88k Lynx M210 M32R M32RX
    M340 m68 M68000 m68020 m68030 m68040 m68332 m68k m88000 m88100 m88110
    m88k M88KBCS_TARGET M_ALPHA M_BITFIELDS M_COFF M_I186 M_I286 M_I386
    M_I8086 M_I86 M_I86SM M_INTERNAT M_IX86 M_SDATA M_STEXT M_SYS3 M_SYS5
    M_SYSIII M_SYSV M_UNIX M_WORDSWAP M_XENIX MACH machine MachTen macII
    MASSCOMP MATH_HAS_NO_SIDE_EFFECTS MBCS mc300 mc500 mc68000 mc68010
    mc68020 mc68030 mc68040 mc68060 MC6811 MC6812 mc68302 mc68332 mc68881
    mc68hc11 mc68hc12 mc68hc1x mc68hcs12 mc68k mc68k32 mc700 mc88000
    mc88100 mc88110 mcf5200 MCORE MCORE__ALIGN_4 MCORE_ALIGN_8 MCOREBE
    MCORELE mcpu32 merlin mert MINGW32 MiNT mips mips16 mips64 mips_eabi
    mips_fpr MIPS_FPSET MIPS_ISA MIPS_SIM mips_single_float mips_soft_float
    MIPS_SZINT MIPS_SZLONG MIPS_SZPTR MIPSEB MIPSEL MMIX MMIX_ABI_GNU
    MMIX_ABI_MMIXWARE MMX MN10200 MN10300 MODERN_C moss motorola mpc505
    mpc604 mpc750 mpc821 mpc860 mpeix MSC_VER MSDOS MSVCRT MT MTXINU
    MULTIMAX MULTITHREADED mvs n16 NATURAL_ALIGNMENT ncl_el ncl_mr NetBSD
    netware news1500 news1700 news1800 news1900 news3700 news700 news800
    news900 NeXT NEXT_SOURCE NLS NO_INLINE NO_INLINE_MATH NO_INLINE_STDLIB
    NO_INTERRUPTS NO_LEADING_UNDERSCORES NO_PROTOTYPE NO_UNDERSCORES NODE
    nofp nonstopux ns16000 ns32000 ns32016 ns32332 ns32532 ns32k nsc32000
    OCS88 OEMVS OPEN_NAMESPACE OpenBSD openedition OPENNT OPTIMIZE OS OS2
    OS390 OSF OSF1 OSF_SOURCE pa_risc PA_RISC1_1 PA_RISC2_0 PARAGON PARISC
    PC532 pdp11 pe pentium pentium2 pentium3 pentium4 pentium__mmx
    pentiumpro PGC pic PIC_ pj plexus PORTAR POSIX POSIX1B_SOURCE
    POSIX2_SOURCE POSIX4_SOURCE POSIX_C_SOURCE POSIX_SOURCE POSIX_THREADS
    POWER PowerPC powerpc64 ppc ppc403 ppc601 ppc602 ppc603 ppc603e PPC64
    PPC64_ PPC_ PRAGMA_REDEFINE_EXTNAME pro PROTOTYPES ps2 psos
    PTHREAD_USE_D4 PTHREADS PTRDIFF_TYPE PWB pyr QNX R3000 R4000 REENTRANT
    REGPARM RELOCATABLE RES REVARGV Rhapsody rios RISC6000 riscbsd riscix
    riscos ROSE rs6000 RT rtasim rtems s390 s390x s64_t SA110 SCO
    SCO_C_DIALECT SCO_COFF SCO_DS SCO_ELF SCO_ODS_30 SCO_XPG_VERS scs semi
    sequent SEQUENT_ sgi SGI_SOURCE sh sh1 sh2 sh3 SH3E SH4 SH4_NOFPU
    SH4_SINGLE SH4_SINGLE_ONLY SH5 SHARED SHMEDIA SHRT_MAX simulator sinix
    SIZE_INT SIZE_LONG SIZE_PTR SIZE_TYPE SNI SOCKET_SOURCE SOCKETS_SOURCE
    SOFT_FLOAT SOFTFP SOLARIS_THREADS sony sony_news sonyrisc sparc sparc64
    sparc_v8 sparc_v9 sparclet sparclite sparclite86x sparcv9 spectrum spur
    SSE SSE2 stardent STATIC STD_INCLUDE_DIR STDC STDC_EXT stdcall STDCPP
    stratos STRICT_ANSI STRICT_BSD STRICT_NAMES sun sun3 sun386 Sun386i
    supersparc SVID SVR3 svr4 SVR4_2 SVR4_ABI SVR4_SOURCE svr5 SX system
    SYSTYPE_BSD SYSTYPE_BSD43 SYSTYPE_BSD44 SYSTYPE_SVR4 SYSTYPE_SVR5
    SYSTYPE_SYSV SYSV SYSV3 SYSV4 SYSV5 sysV68 sysV88 SYSV_SOURCE tahoe
    Tek4132 Tek4300 THREAD_SAFE thumb THUMB_INTERWORK THUMBEB THUMBEL titan
    TM3200 TM5400 TM5600 TMS320C30 TMS320C31 TMS320C32 TMS320C33 TMS320C3x
    TMS320C40 TMS320C44 TMS320C4x tower tower32 tower32_200 tower32_600
    tower32_700 tower32_800 tower32_850 TOWER_ASM tss tune_ tune_athlon
    tune_athlon_sse tune_i386 tune_i486 tune_i586 tune_i686 tune_k6
    tune_k6_2 tune_k6_3 tune_pentium tune_pentium2 tune_pentium3
    tune_pentium4 tune_pentium_mmx tune_pentiumpro tune_v10 tune_v3 tune_v8
    u370 u3b u3b2 u3b20 u3b200 u3b20d u3b5 u64_t uclinux UINT128_T ultrix
    UMAXV unaligned UnicomPBB UnicomPBD UNICOS UNICOSMK unix UNIX95 UNIX99
    unixpc unos USE_BSD USE_FILE_OFFSET64 USE_GNU USE_INIT_FINI USE_ISOC9X
    USE_LARGEFILE USE_LARGEFILE64 USE_MISC USE_POSIX USE_POSIX199309
    USE_POSIX199506 USE_POSIX2 USE_REENTRANT USE_RTC USE_SVID USE_UNIX98
    USE_XOPEN USE_XOPEN_EXTENDED USES_INITFINI USG USGr4 USGr4_2 UTek Utek
    UTS UWIN uxpm uxps v20 v33 v850 v850e v850ea v851 vax venix VMESA VMS
    VSTA vxworks vxworks_5 wchar_t WCHAR_TYPE we32000 WIN32 WINNT WINT_TYPE
    X86_ x86_64 X_FLOAT xenix Xenix286 XOPEN_C XOPEN_SOURCE
    XOPEN_SOURCE_EXTENDED XPG2 XPG2_EXTENDED XPG3 XPG3_EXTENDED XPG4
    XPG4_EXTENDED XSCALE xstormy16 XTENSA XTENSA_EB XTENSA_EL
    XTENSA_SOFT_FLOAT z8000
  )
}

sub _assert
{
  {
    'cpu' => [qw(
      a29k alpha arc arm bwx cix clipper convex elxsi ev4 ev5 ev6 fix h8300
      h8300h h8300s hppa i370 i386 i860 i960 ia64 ibm032 m32r m68k m88k max
      mc68000 mc68020 mc68030 mc68040 mips ns32k parisc powerpc powerpc64
      pyr rs6000 sh sparc sparc64 spur tahoe tron v850 vax we32000 x86_64
      xtensa
    )],
    'endian' => [qw(
      big little
    )],
    'lint' => [qw(
      off
    )],
    'machine' => [qw(
      a29k alpha arc arm bigendian clipper convex d30v elxsi fr30 h8300
      h8300h h8300s hppa i370 i386 i860 i960 ia64 ibm032 littleendian m32r
      m68k m88k macII mc68000 mips ns32k parisc powerpc powerpc64 pyr
      rs6000 sgi sh sparc sparc64 sparcv9 spur tahoe tron v850 vax we32000
      x86_64 xstormy16 xtensa
    )],
    'model' => [qw(
      ilp32 lp64
    )],
    'system' => [qw(
      aix AUX beos bsd embedded FreeBSD gnu hiux hpux hurd interix linux
      lynx mach msdos mvs NetBSD netware OpenBSD openedition osf1 posix
      ptx4 rtems simulator svr3 svr4 unix vms vsta vxworks winnt xpg4
    )]
  }
}

sub _unique
{
  my %unique;
  grep !$unique{$_}++, @_;
}

sub new
{
  my $class = shift;
  my $self = bless {
    'headers' => [&ANSI_headers],
    'ppline'  => qr/^\s*#\s*(?:line\s*)?(\d+)\s*"([^"]*)"/,
    'debug'   => 0,
    'quiet'   => 0,
    'status'  => 1,
    'run'     => 1,
    'delete'  => 1,
    'temp'    => '_t_e_s_t.c',
    'timeout' => 30,
    @_
  }, $class;

  $self->{fatal} = 0;
  $self->{__int__} = 0;

  $SIG{INT} = sub { $self->{__int__} = 1; $SIG{INT} = 'DEFAULT' };

  $self->_configure;

  $self->{fatal} = 1;

  $self;
}

sub _getwarn
{
  my @warn = @_;

  for( @warn ) {
    s/\s+at\s+\Q$0\E\s+line\s+\d+\.//m;
    s/^\s*included\s+from\s+\[buffer\]:\d+[\r\n]+//m;
    s/[\r\n]+$//;
  };

  @warn;
}

sub check_config
{
  my $self    = shift;
  my $config  = shift;
  my @headers = @_;
  my %inc;

  eval { require Convert::Binary::C };
  $@ and return {code => ERR_REQUIRE};

  $self->{debug} and import Convert::Binary::C debug => 'all';

  my $c = eval { new Convert::Binary::C };
  $@ and return {code => ERR_CREATE};

  eval { $c->configure( %$config ) };
  $@ and return {code => ERR_CONFIG};

  @inc{@headers} = (undef) x @headers;

  my %res = (
    code     => SUCCESS,
    header   => \%inc,
    fail     => [],
    succ     => [],
    warnings => [],
  );

  for my $hdr ( keys %inc ) {
    my $code = "#include <$hdr>\n";
    my @warn;
    {
      local $^W = 1;
      local $SIG{__WARN__} = sub { push @warn, @_ };
      eval { $c->clean->parse( $code ) };
    }
    $inc{$hdr} = { warnings => [_getwarn(@warn)] };
    push @{$res{warnings}}, _getwarn(@warn);
    if( $@ ) {
      ($inc{$hdr}{error}) = _getwarn($@);
      push @{$res{fail}}, $hdr;
    }
    else {
      push @{$res{succ}}, $hdr;
    }
  }

  return \%res;
}

sub get_config
{
  my $self = shift;
  exists $self->{config} or $self->run_checks;

  my @headers;
  my @missing;

  $self->_msg( "\nChecking for ANSI headers..." );

  for my $hdr ( @{$self->{headers}} ) {
    my $found = 0;
    for my $inc ( @{$self->{inc_path}} ) {
      if( -e $inc.$hdr ) {
        $found = 1;
        last;
      }
    }
    push @{ $found ? \@headers : \@missing }, $hdr;
  }

  if( @missing ) {
    $self->_msg("The following ANSI headers are missing:");
    $self->_wrapped_list( @missing );
  }
  else {
    $self->_msg("All ANSI headers found.");
  }

  $self->_msg( "\nAssembling the configuration..." );

  my %predef = %{$self->{predefined} || {}};
  my %def;
  my $compiler = $self->_compiler;

  if( $compiler == GNU_GCC ) {
    $self->_msg( "You're using the GNU compiler." );
    %def = (
      '__asm(x)'          => '',
      '__asm__(x)'        => '',
      '__attribute(x)'    => '',
      '__attribute__(x)'  => '',
      '__typeof(x)'       => 'int',
      '__typeof__(x)'     => 'int',
      '__alignof(x)'      => '1',
      '__alignof__(x)'    => '1',
      '__label__'         => 'int',
      '__builtin_va_list' => 'int',
    );
  }
  elsif( $compiler == INTEL_ICC ) {
    $self->_msg( "You're using the Intel compiler." );
    %def = (
      '__asm(x)'          => '',
      '__asm__(x)'        => '',
      '__attribute(x)'    => '',
      '__attribute__(x)'  => '',
      '__typeof(x)'       => 'int',
      '__typeof__(x)'     => 'int',
      '__alignof(x)'      => '1',
      '__alignof__(x)'    => '1',
      '__label__'         => 'int',
      '__builtin_va_list' => 'int',
    );
  }
  elsif( $compiler == MS_VCPP ) {
    $self->_msg( "You're using the Microsoft compiler." );
    $def{'__int64'} = 'long long';
  }

  if( exists $predef{__CYGWIN__} || exists $predef{_WIN32} ) {
    $self->_msg( "This is a Windows compiler." );
    $def{'__cdecl'} = '';
    $def{'__declspec(x)'} = '';
  }

  my %cfg;
  my $define = sub { [ map { "$_=$predef{$_}" } sort keys %{$_[0]} ] };

  if( exists $self->{basic_sizes} ) {
    my %sizes = %{$self->{basic_sizes}};
    my %valid = (
                  PointerSize    => [    0, 1, 2, 4, 8        ],
                  EnumSize       => [-1, 0, 1, 2, 4, 8        ],
                  IntSize        => [    0, 1, 2, 4, 8        ],
                  ShortSize      => [    0, 1, 2, 4, 8        ],
                  LongSize       => [    0, 1, 2, 4, 8        ],
                  LongLongSize   => [    0, 1, 2, 4, 8        ],
                  FloatSize      => [    0, 1, 2, 4, 8, 12, 16],
                  DoubleSize     => [    0, 1, 2, 4, 8, 12, 16],
                  LongDoubleSize => [    0, 1, 2, 4, 8, 12, 16],
                );

    for my $type ( keys %sizes ) {
      my $opt = join( '', map ucfirst, split ' ', $type ) . 'Size';
      if( exists $valid{$opt} ) {
        if( grep { $sizes{$type} == $_ } @{$valid{$opt}} ) {
          $cfg{$opt} = $sizes{$type};
        }
        else {
          $self->_msg( "Strange size '$sizes{$type}' for type '$type'." );
        }
      }
      else {
        $self->_msg( "Strange type '$type' with size '$sizes{$type}'." );
      }
    }
  }

  if( exists $self->{unsigned_chars} and defined $self->{unsigned_chars} ) {
    $cfg{UnsignedChars} = $self->{unsigned_chars};
  }
  if( exists $self->{alignment} and defined $self->{alignment} ) {
    if( grep { $self->{alignment} == $_ } 1, 2, 4, 8, 16 ) {
      $cfg{Alignment} = $self->{alignment};
    }
    else {
      $self->_msg( "Strange alignment '$self->{alignment}'." );
    }
  }
  if( exists $self->{invalid_keywords} and @{$self->{invalid_keywords}} > 0 ) {
    $cfg{DisabledKeywords} = $self->{invalid_keywords};
  }
  if( exists $self->{keyword_map} and keys %{$self->{keyword_map}} > 0 ) {
    $cfg{KeywordMap} = $self->{keyword_map};
  }
  if( exists $self->{byteorder} and $self->{byteorder} ) {
    $cfg{ByteOrder} = $self->{byteorder};
  }
  if( exists $self->{cpp_comments} ) {
    $cfg{HasCPPComments} = $self->{cpp_comments};
  }
  if( exists $self->{inc_path} and @{$self->{inc_path}} > 0 ) {
    $cfg{Include} = [ map { s/[\\\/]+$//; $_ } @{$self->{inc_path}} ];
  }

  keys %{$self->{preasserted}} and $cfg{Assert} = [sort keys %{$self->{preasserted}}];

  $self->_msg( "\nTesting configuration..." );

  $self->_debug( Data::Dumper->Dump( [\%def, \%predef, \%cfg], [qw(*def *predef *cfg)] ) );

  # First, check if the configuration works without additional defines

  my $warnings = 0;
  my $failures = 0;
  keys %predef and $cfg{Define} = $define->( \%predef );

  my $res = $self->check_config( \%cfg, @headers );
  $self->_debug( Data::Dumper->Dump( [$res], [qw(res)] ) );

  if( $res->{code} == SUCCESS ) {
    $failures = @{$res->{fail}};
    $warnings = @{$res->{warnings}};
    if( $failures ) {
      $self->_msg( "Plain configuration failed for these headers:" );
      $self->_wrapped_list( sort @{$res->{fail}} );
    }
    else {
      if( $warnings == 0 ) {
        goto finish;
      }
      $self->_msg( "Plain configuration works fine, but there are some warnings:" );
      $self->_out( "| ", @{$res->{warnings}} );
    }
  }
  else {
    goto finish;
  }

  # There were errors or warnings. Let's see if there's something we can try...

  unless( keys %def ) {
    if( $res->{code} == SUCCESS ) {
      $self->_msg( "\nHowever, there's nothing I can do about it." );
    }
    goto finish;
  }

  $self->_msg( "\nI will try to add couple of defines..." );

  for my $key ( keys %def ) {
    my($name) = $key =~ /(\w+)/;
    delete $predef{$name};
    $predef{$key} = $def{$key};
  }

  keys %predef and $cfg{Define} = $define->( \%predef );

  my $newres = $self->check_config( \%cfg, @headers );
  $self->_debug( Data::Dumper->Dump( [$res], [qw(res)] ) );

  if( $res->{code} != SUCCESS ) {
    $res = $newres;
    goto finish;
  }

  if( @{$newres->{fail}} < $failures  or
      @{$newres->{fail}} == $failures && @{$newres->{warnings}} < $warnings ) {
    $self->_msg( "This configuration feels better." );
    if( $failures ) {
      if( @{$newres->{fail}} ) {
        $self->_msg( "Only these headers still fail:" );
        $self->_wrapped_list( sort @{$newres->{fail}} );
      }
      else {
        $self->_msg( "No more headers that fail." );
      }
    }
    $res = $newres;
    $failures = @{$res->{fail}};
    $warnings = @{$res->{warnings}};
  }
  else {
    if( $failures == 0 and @{$newres->{fail}} > 0 ) {
      $self->_msg( "Whoa, now it fails. Restoring original configuration." );
    }
    else {
      $self->_msg( "Doesn't help. Restoring original configuration." );
    }
    goto finish;
  }

  # Try to remove as many defines as possible

  $self->_msg( "\nNow let's see which defines aren't neccessary..." );

  my %orgdef = %{$self->{predefined}};
  my @additional;
  my $tested = 0;

  for my $key ( sort keys %def ) {
    my($name) = $key =~ /(\w+)/;
    delete $predef{$key};
    exists $orgdef{$name} and $predef{$name} = $orgdef{$name};

    keys %predef and $cfg{Define} = $define->( \%predef );

    $newres = $self->check_config( \%cfg, @headers );
    $self->_debug( Data::Dumper->Dump( [$res], [qw(res)] ) );

    if( $newres->{code} == SUCCESS and @{$newres->{fail}} <= $failures
                                   and @{$newres->{warnings}} <= $warnings ) {
      $res = $newres;
      $failures = @{$res->{fail}};
      $warnings = @{$res->{warnings}};
    }
    else {
      push @additional, $name;
      delete $predef{$name};
      $predef{$key} = $def{$key};
    }

    $self->_work_in_progress( sprintf "%d/%d needed", scalar @additional, ++$tested );
  }

  $self->_work_done;

  if( @additional ) {
    $self->_msg( "Additionally defining the following symbols:" );
    $self->_wrapped_list( sort @additional );
  }
  else {
    $self->_msg( "Not defining any additional symbols." );
  }

finish:
  if( $res->{code} == SUCCESS ) {
    if( @{$res->{succ}} > 0 ) {
      $self->_msg( "\n>>>>>>>>>> Successfully tested configuration! <<<<<<<<<<" );
    }
    else {
      $self->_msg( "\n>>>>>>>>>> Configuration test FAILED! <<<<<<<<<<" );
    }
    if( @{$res->{fail}} ) {
      $self->_msg( "\nThese headers fail:" );
      for my $hdr ( sort keys %{$res->{header}} ) {
        exists $res->{header}{$hdr}{error} or next;
        $self->_msg( "  <$hdr> $res->{header}{$hdr}{error}" );
      }
    }
    elsif( @{$res->{warnings}} ) {
      $self->_msg( "\nHowever, there are some warnings that I can't get rid of:" );
      $self->_out( "| ", @{$res->{warnings}} );
    }
  }
  else {
    $res->{code} == ERR_REQUIRE and
      $self->_msg( "Failed to load Convert::Binary::C, cannot test configuration." );
    $res->{code} == ERR_CREATE and
      $self->_msg( "Could not create Convert::Binary::C object." );
    $res->{code} == ERR_CONFIG and
      $self->_msg( "Could not configure Convert::Binary::C object." );
  }

  keys %predef and $cfg{Define} = $define->( \%predef );

  return \%cfg;
}

sub cleanup
{
  my $self = shift;
  if( $self->{'delete'} ) {
    for( qw( temp obj exe ) ) {
      exists $self->{$_} and -e $self->{$_} and unlink $self->{$_};
    }
    my $base = $self->_basename;
    for( glob "$base.*" ) { -e and unlink }
  }
}

sub run_checks
{
  my $self = shift;
  my $asserts;

  $self->{inc_path}           = $self->_run_incpath;
  ($self->{names}, $asserts)  = $self->_names( $self->{inc_path} );

  $self->{predefined}         = $self->_get_predefined( $self->{names} );
  $self->{preasserted}        = $self->_get_preasserted( $asserts );

  if( $self->{can_compile} ) {
    $self->{invalid_keywords} = $self->_get_invalid_keywords;
    $self->{keyword_map}      = $self->_get_keyword_map;
    $self->{cpp_comments}     = $self->_get_cpp_comments;

    $self->{basic_sizes}      = $self->_get_basic_sizes;
    $self->{byteorder}        = $self->_get_byteorder;
    $self->{unsigned_chars}   = $self->_get_unsigned_chars;
    $self->{alignment}        = $self->_get_alignment;
  }
}

sub _compiler
{
  my $self = shift;

  exists $self->{predefined}{__GNUC__}         and return GNU_GCC;

  exists $self->{predefined}{__ICC} ||
  exists $self->{predefined}{__INTEL_COMPILER} and return INTEL_ICC;

  exists $self->{predefined}{_MSC_VER}         and return MS_VCPP;

  return UNKNOWN;
}

sub _test_type
{
  my($self, $type, $init, $width) = @_;

  my $begin = "\x21\x05\x19\x77*MHXCBC*\xDE\xAD\xBE\xEF";
  my $end   = "\x21\x05\x19\x77*MARCUS*\xDE\xAD\xBE\xEF";

  my $cvt = sub { join ', ', map { sprintf "0x%02X", $_ } unpack "C*", $_[0] };

  my $c_begin = $cvt->( $begin );
  my $c_end   = $cvt->( $end );

  $self->_temp( <<ENDC );
struct _t_e_s_t_ {
  char _a_[16];
  $type _x_;
  char _z_[16];
};

struct _t_e_s_t_ _g_x = {
  { $c_begin },
  $init,
  { $c_end }
};

struct _t_e_s_t_ func()
{
  struct _t_e_s_t_ x = {
    { $c_begin },
    $init,
    { $c_end }
  };
  return x;
}
ENDC

  my $res = $self->_compile_temp;
  $res->{status} and return undef;

  my $fh = new IO::File $self->{obj} or return undef;
  binmode $fh;

  my $obj = do { local $/; <$fh> };

  $obj =~ /\Q$begin\E(.{1,$width}?)\Q$end\E/s and return $1;

  return undef;
}

sub _get_alignment_run
{
  my $self = shift;
  my $type = shift;

  $self->_work_in_progress;

  $self->_temp( <<ENDC );
#include <stdio.h>
#include <stddef.h>
struct align {
  char a;
  $type b;
};
int main()
{
  printf("align=%d\\n", offsetof(struct align, b));
  return 0;
}
ENDC

  my $res = $self->_build_temp;

  $res->{result} and return undef;

  if( -e $self->{exe} ) {
    local $self->{fatal} = 0;
    $res = $self->_run_temp;
  }
  else {
    $self->_work_done;
    $self->_msg( "Got no output from compiler for '$type'." );
    return undef;
  }

  if( $res->{didnotrun} or $res->{status} ) {
    $self->_work_done;
    $self->_msg( "It seems I cannot run your compiler's executables." );
    return undef;
  }

  for my $line ( @{$res->{stdout}} ) {
    $line =~ /^align=(\d+)/ and return $1;
  }

  $self->_work_done;
  $self->_msg( "Strange output..." );
  return undef;
}

sub _get_alignment_compile
{
  my $self = shift;
  my $type = shift;

  $self->_work_in_progress;

  my $res = $self->_test_type( "struct align { char a; $type b; }",
                               "{ sizeof(struct align) - sizeof($type), ($type) -1 }", 32 );

  unless( defined $res ) {
    $self->_work_done;
    $self->_msg( "Got no output from compiler for '$type'." );
    return undef;
  }

  my $off = unpack "C", $res;

  if( $off == 0 ) {
    $self->_work_done;
    $self->_msg( "Strange output..." );
    return undef;
  }

  return $off;
}

sub _get_alignment
{
  my $self = shift;

  $self->_msg( "\nTrying to determine struct member alignment..." );

  my $meth = $self->{can_run} ? "_get_alignment_run" : "_get_alignment_compile";
  my $align;

  my $compiler = $self->_compiler;

  for my $type ( 'int', 'short', 'long', 'long long', 'float', 'double', 'int *' ) {
    my $real_type = $type_map{$compiler}{$type} || $type;
    if( defined( my $rv = $self->$meth( $real_type ) ) ) {
      !defined($align) || $rv > $align and $align = $rv;
    }
  }

  $self->_work_done;

  if( defined $align ) {
    $self->_msg( "Struct members are aligned to $align-byte boundaries." );
  }
  else {
    $self->_msg( "Could not determine struct member alignment." );
  }

  return $align;
}

sub _get_basic_sizes_run
{
  my $self = shift;
  my $type = shift;

  $self->_work_in_progress;

  $self->_temp( <<ENDC );
#include <stdio.h>
typedef $type _t_y_p_e_;
int main()
{
  printf("sizeof=%d\\n", sizeof(_t_y_p_e_));
  return 0;
}
ENDC

  my $res = $self->_build_temp;

  $res->{result} and return undef;

  if( -e $self->{exe} ) {
    local $self->{fatal} = 0;
    $res = $self->_run_temp;
  }
  else {
    $self->_work_done;
    $self->_msg( "Got no output from compiler for '$type'." );
    return undef;
  }

  if( $res->{didnotrun} or $res->{status} ) {
    $self->_work_done;
    $self->_msg( "It seems I cannot run your compiler's executables." );
    return undef;
  }

  for my $line ( @{$res->{stdout}} ) {
    $line =~ /^sizeof=(\d+)/ and return $1;
  }

  $self->_work_done;
  $self->_msg( "Strange output..." );
  return undef;
}

sub _get_basic_sizes_compile
{
  my $self = shift;
  my $type = shift;

  $self->_work_in_progress;

  my $res = $self->_test_type( $type, "0", 16 );

  unless( defined $res ) {
    $self->_work_done;
    $self->_msg( "Got no output from compiler for '$type'." );
    return undef;
  }

  return length $res;
}

sub _get_basic_sizes
{
  my $self = shift;

  $self->_msg( "\nTrying to determine basic type sizes..." );

  my $meth = $self->{can_run} ? "_get_basic_sizes_run" : "_get_basic_sizes_compile";

  my %sizes;
  my $compiler = $self->_compiler;

  for my $type ( 'int', 'short', 'long', 'long long', 'float', 'double', 'long double', 'int *' ) {
    my $real_type = $type_map{$compiler}{$type} || $type;
    my $rv = $self->$meth( $real_type ) or next;
    $sizes{$type =~ y/*// ? 'pointer' : $type} = $rv;
  }

  my %enum;

  for my $type (
                 "enum pbyte { PB1 =      0, PB2 =   255 }",
                 "enum nbyte { NB1 =   -128, NB2 =   127 }",
                 "enum pword { PW1 =      0, PW2 = 65535 }",
                 "enum nword { NW1 = -32768, NW2 = 32767 }",
                 "enum plong { PL1 =      0, PL2 = 65536 }",
                 "enum nlong { NL1 = -32768, NL2 = 32768 }",
               ) {
    my $rv = $self->$meth( $type ) or next;
    my($name) = $type =~ /^enum\s+(\w+)/;
    $enum{$name} = $rv;
  }

  $self->_work_done;

  if( keys %enum == 6 ) {
    if( $enum{pbyte} == 2 && $enum{nbyte} == 1 &&
        $enum{pword} == 4 && $enum{nword} == 2 &&
        $enum{plong} == 4 && $enum{nlong} == 4 ) {
      $sizes{enum} = -1;
    }
    elsif( $enum{pbyte} == 1 && $enum{nbyte} == 1 &&
           $enum{pword} == 2 && $enum{nword} == 2 &&
           $enum{plong} == 4 && $enum{nlong} == 4 ) {
      $sizes{enum} = 0;
    }
    elsif( $enum{pbyte} == $enum{nbyte} &&
           $enum{pbyte} == $enum{pword} &&
           $enum{pbyte} == $enum{nword} &&
           $enum{pbyte} == $enum{plong} &&
           $enum{pbyte} == $enum{nlong} ) {
      $sizes{enum} = $enum{pbyte};
    }
    else {
      $self->_msg( "Hmm, your compiler has strange enums." );
    }
  }

  $self->_msg( "Got size information for the following types:" );
  $self->_wrapped_list( sort @{[map {y/ /_/; $_} keys %sizes]} );

  $self->_debug( Data::Dumper->Dump( [\%sizes], ['*sizes'] ) );

  \%sizes;
}

sub _get_unsigned_chars_run
{
  my $self = shift;

  $self->_temp( <<ENDC );
#include <stdio.h>
int main()
{
  char c;
  int  i;
  c = -1;
  i = c;
  printf("result=%d\\n", i);
}
ENDC

  my $res = $self->_build_temp;

  if( $res->{status} == 0 and -e $self->{exe} ) {
    {
      local $self->{fatal} = 0;
      $res = $self->_run_temp;
    }

    if( $res->{didnotrun} or $res->{result} ) {
      $self->_msg( "It seems I cannot run your compiler executables." );
      return undef;
    }

    for my $line ( @{$res->{stdout}} ) {
      $line =~ /^result=(-?\d+)/ and return $1;
    }
  }
  else {
    $self->_msg( "Could not build the test program." );
    $self->_out( '| ', @{$res->{stderr}} );
  }

  return undef;
}

sub _get_unsigned_chars_compile
{
  my $self = shift;

  my $res = $self->_test_type( "int", "(int)((char)-1)", 8 );

  if( defined $res ) {
    $res =~ /^\xFF+$/        and return -1;
    $res =~ /^\x00+\xFF$/ ||
    $res =~ /^\xFF\x00+$/    and return 255;
  }

  $self->_msg( "Could not determine character signedness." );
  return undef;
}

sub _get_unsigned_chars
{
  my $self = shift;

  $self->_msg( "\nTrying to find out if your chars are unsigned..." );

  my $meth = $self->{can_run} ? "_get_unsigned_chars_run" : "_get_unsigned_chars_compile";

  my $result = $self->$meth();

  if( defined $result ) {
    if( $result == -1 ) {
      $self->_msg( "Your chars are signed." );
      return 0;
    }
    elsif( $result == 255 ) {
      $self->_msg( "Your chars are unsigned." );
      return 1;
    }
    elsif( $result >= 0 ) {
      $self->_msg( "Your chars seem to be unsigned." );
      return 1;
    }
    else {
      $self->_msg( "Your chars seem to be signed." );
      return 0;
    }
  }

  $self->_msg( "No idea." );
  return undef;
}

sub _get_byteorder_run
{
  my $self = shift;

  $self->_temp( <<ENDC );
#include <stdio.h>
typedef unsigned long UVAL;
typedef union {
  UVAL multi;
  char byte[sizeof(UVAL)];
} order;
int main()
{
  order test;
  int i;
  if( sizeof(UVAL) > 4 )
    test.multi = (((UVAL)0x08070605) << 32) | ((UVAL)0x04030201);
  else
    test.multi = (UVAL)0x04030201;
  printf("order=");
  for( i=0; i<sizeof(long); ++i )
    printf("\%c", '0'+test.byte[i]);
  printf("\\n");
  return 0;
}
ENDC

  my $res = $self->_build_temp;

  if( $res->{status} == 0 and -e $self->{exe} ) {
    {
      local $self->{fatal} = 0;
      $res = $self->_run_temp;
    }

    if( $res->{didnotrun} or $res->{result} ) {
      $self->_msg( "It seems I cannot run your compiler executables." );
      return '';
    }

    my $order;

    for my $line ( @{$res->{stdout}} ) {
      $line =~ /^order=(\d+)/ and $order = $1;
    }

    if( defined $order ) {
      my %bo = (
        '87654321' => 'BigEndian',
        '4321'     => 'BigEndian',
        '21'       => 'BigEndian',
        '12345678' => 'LittleEndian',
        '1234'     => 'LittleEndian',
        '12'       => 'LittleEndian',
      );
      if( exists $bo{$order} ) {
        $self->_msg( "The byte order appears to be $bo{$order}." );
        return $bo{$order};
      }
      $self->_msg( "Your compiler seems to have a strange byte order ($order)." );
    }
    else {
      $self->_msg( "The test program delivered some strange output." );
      $self->_out( '| ', @{$res->{stdout}} );
    }
  }
  else {
    $self->_msg( "Could not build the test program." );
    $self->_out( '| ', @{$res->{stderr}} );
  }

  return '';
}

sub _get_byteorder_compile
{
  my $self = shift;

  my $res = $self->_test_type( "unsigned long", <<ENDINIT, 8 );
  sizeof(unsigned long) > 4
    ? (((unsigned long)0x08070605) << 32) | ((unsigned long)0x04030201)
    : (unsigned long)0x04030201
ENDINIT

  unless( defined $res ) {
    $self->_msg( "Could not determine byte order." );
    return '';
  }

  my %bo = (
    "\x08\x07\x06\x05\x04\x03\x02\x01" => 'BigEndian',
    "\x04\x03\x02\x01"                 => 'BigEndian',
    "\x02\x01"                         => 'BigEndian',
    "\x01\x02\x03\x04\x05\x06\x07\x08" => 'LittleEndian',
    "\x01\x02\x03\x04"                 => 'LittleEndian',
    "\x01\x02"                         => 'LittleEndian',
  );

  if( exists $bo{$res} ) {
    $self->_msg( "The byte order appears to be $bo{$res}." );
    return $bo{$res};
  }

  my $str = join '', map { sprintf "%02X", $_ } unpack "C*", $res;
  $self->_msg( "Your compiler seems to have a strange byte order (0x$str)." );

  return '';
}

sub _get_byteorder
{
  my $self = shift;

  $self->_msg( "\nTrying to determine byte order..." );

  my $meth = $self->{can_run} ? "_get_byteorder_run" : "_get_byteorder_compile";

  return $self->$meth();
}

sub _get_cpp_comments
{
  my $self = shift;

  $self->_msg( "\nTrying to find out if your compiler understands C++ comments..." );

  $self->_temp( <<ENDC );
extern int // nothing here
       i;
ENDC

  my $res = $self->_compile_temp;

  if( $res->{status} ) {
    $self->_msg( "No, it doesn't." );
    return 0;
  }
  else {
    $self->_msg( "Yes, it does." );
    return 1;
  }
}

sub _get_keyword_map
{
  my $self = shift;

  $self->_msg( "\nTrying to find out which special keywords your compiler knows..." );

  my @remap = qw( break case char continue default do else for goto if int return sizeof
                  struct switch typedef union while auto const double enum extern float
                  long register short signed static unsigned void volatile inline restrict );

  my @keywords = map { ("_${_}", "__${_}", "__${_}__") } sort
                 @remap, qw( bounded unbounded imag real complex extension );

  my @known;
  my $count = 0;

  for my $key ( sort @keywords ) {
    $self->_work_in_progress( sprintf "%d/%d keywords", scalar @known, $count++ );

    $self->_temp( <<ENDC );
typedef struct $key { int foo; } $key;
ENDC

    my $res = $self->_compile_temp;

    $res->{status} and push @known, $key;
  }

  $self->_work_done;

  if( @known ) {
    $self->_msg( "Your compiler recognizes the following special keywords:" );
    $self->_wrapped_list( sort @known );
  }
  else {
    $self->_msg( "None." );
  }

  $self->_debug( Data::Dumper->Dump( [\@known], ['*known'] ) );

  my $remap = join '|', @remap;

  return { map { ( $_ => (/^_*($remap)_*$/ ? $1 : undef) ) } @known }
}

sub _get_invalid_keywords
{
  my $self = shift;

  $self->_msg( "\nTrying to find out which keywords your compiler doesn't know..." );


  my @keywords = qw( inline restrict auto const double enum extern float long
                     register short signed static unsigned void volatile );

  my @invalid;
  my $count = 0;

  for my $key ( sort @keywords ) {
    $self->_work_in_progress( sprintf "%d/%d keywords", scalar @invalid, $count++ );

    $self->_temp( <<ENDC );
typedef struct $key { int foo; } $key;
ENDC

    my $res = $self->_compile_temp;

    $res->{status} == 0 and push @invalid, $key;
  }

  $self->_work_done;

  if( @invalid ) {
    $self->_msg( "Your compiler doesn't recognize the following keywords:" );
    $self->_wrapped_list( sort @invalid );
  }
  else {
    $self->_msg( "Your compiler recognizes all keywords." );
  }

  $self->_debug( Data::Dumper->Dump( [\@invalid], ['*invalid'] ) );

  \@invalid;
}

sub _get_preasserted
{
  my $self = shift;
  my $assert = shift;

  $self->_msg( "\nChecking for assertions (this may take a while)..." );

  my $code;

  for my $pred ( keys %$assert ) {
    for my $ans ( @{$assert->{$pred}} ) {
      $code .= <<ENDC;
#if #$pred($ans)
"$pred($ans)";
#endif
ENDC
    }
  }

  $self->_temp( $code );

  my $res = $self->_runpp_temp;

  if( $res->{status} ) {
    $self->_msg( "Your compiler doesn't seem to like assertions." );
    return {};
  }

  my %results;

  for my $line ( @{$res->{stdout}} ) {
    chomp $line;
    next if $line =~ /^\s*#/;
    next if $line =~ /^\s*$/;
    $line =~ /"\s*([^"]+?)\s*"\s*;/ or next;
    $results{$1} = 1;
  }

  if( my $count = keys %results ) {
    my $what = $count > 1 ? "these $count assertions" : "this assertion";
    $self->_msg( "Your compiler makes $what:" );
    $self->_wrapped_list( sort keys %results );
  }
  else {
    $self->_msg( "Your compiler doesn't seem to assert anything." );
  }

  \%results;
}

sub _get_predefined
{
  my $self = shift;
  my $names = shift;
  my $pos = 0;

  my @stdnames = qw( __LINE__ __FILE__ __DATE__ __TIME__ __STDC__
                     _Pragma __STDC_VERSION__ __STDC_HOSTED__ );

  $self->_msg( "\nChecking for predefined macros (this may take a while)..." );

  my %defs;

  for my $name ( &_preset_names ) {
    my @words = map { ("$_", "_$_", "__$_", "__${_}__" ) }
                    $name, uc($name), lc($name);
    @defs{@words} = (1)x@words;
  }

  my %results = ();
  my $count = 0;
  my $max = @$names;

  while(1) {
    delete @defs{@stdnames};

    $self->_work_in_progress( "($count) $pos/$max" );

    my $code;

    for my $def ( keys %defs ) {
      $code .= <<ENDC;
#ifdef $def
"$def";
($def);
#endif
ENDC
    }

    $self->_temp( $code );

    my $res = $self->_runpp_temp;

    if( $res->{status} ) {
      $self->_work_done;
      $self->_msg( "Your compiler exited unexpectedly:" );
      $self->_out( '| ', @{$res->{stderr}} );
      return {};
    }

    my $out = join '', @{$res->{stdout}};

    while( $out =~ /"\s*([^\s"]+)\s*"\s*;\s*\(\s*([^\r\n]+?)\s*\)\s*;/g ) {
      $results{$1} = $2;
    }

    $count = keys %results;

    %defs = ();

    last if $pos >= @$names;

    my $last = $pos+999;
    $last = $#$names if $last > $#$names;
    @defs{@{$names}[$pos..$last]} = (1)x($last-$pos+1);
    $pos = $last+1;
  }

  delete @results{@stdnames};

  $self->_work_done;

  if( my $count = keys %results ) {
    my $what = $count > 1 ? "these $count symbols" : "this symbol";
    $self->_msg( "Your compiler defines $what:" );
    $self->_wrapped_list( sort keys %results );
  }
  else {
    $self->_msg( "Your compiler doesn't seem to define anything." );
  }

  $self->_debug( Data::Dumper->Dump( [\%results], ['*results'] ) );

  \%results;
}

sub _incpath_main
{
  my $self = shift;
  my @headers = @_;
  my %resolve;

  for my $hdr ( @headers ) {
    $self->_work_in_progress;

    $self->_temp( <<TEMP );
#include <$hdr>
TEMP
    my $res = $self->_runpp_temp;

    if( $res->{status} ) {
      $self->_work_done;
      $self->_msg( "Compiler choked on including '$hdr'. Maybe a missing ANSI header..." );
      next;
    }

    for my $line ( @{$res->{stdout}} ) {
      if( $line =~ $self->{ppline} ) {
        my $file = $2;
        if( $file =~ /^(.*)\Q$hdr\E$/ ) {
          my $inc = $1;
          $inc =~ y{\\}{/}s;
          $resolve{$hdr} = [$inc];
          last;
        }
      }
    }
  }

  %resolve;
}

sub _get_files
{
  my($dir, $rex) = @_;
  local *DIR;

  opendir DIR, $dir or return ();
  my @files = readdir DIR;
  closedir DIR;

  if( defined $rex ) {
    return grep $_ =~ $rex, @files;
  }

  @files;
}

sub _run_incpath
{
  my $self = shift;
  my(@inc,@newhdr,%resolve);
  my @headers = @{$self->{headers}};

  $self->_msg( "\nTrying to determine include path..." );

  %resolve = $self->_incpath_main( @headers );
  @inc = _unique( map $_->[0], values %resolve );

  if( @inc > 1 ) {
    my @files;
    for my $path ( @inc ) {
      push @files, grep !-d $path.$_, _get_files( $path );
    }

    for my $hdr ( _unique( @files ) ) {
      my @f = grep { -e "$_$hdr" } @inc;
      @f > 1 && push @newhdr, $hdr;
    }

    push @headers, @newhdr;
    %resolve = ( %resolve, $self->_incpath_main( @newhdr ) );

    for my $hdr ( @headers ) {
      for my $path ( @inc ) {
        next unless exists $resolve{$hdr};
        next if $path eq $resolve{$hdr}[0];
        -e $path.$hdr and push @{$resolve{$hdr}}, $path;
      }
    }

    $self->_debug( Data::Dumper->Dump( [\%resolve], ['*resolve'] ) );

    my($i,$j);
    my @h = grep { @{$resolve{$_}} > 1 } keys %resolve;

    for( $i = 0; $i < @inc; ++$i ) {
      for( $j = $i+1; $j < @inc; ++$j ) {
        for my $h ( @h ) {
          my($a,$b) = @inc[$i,$j];
          my @r = @{$resolve{$h}};
          $b eq $r[0] or next;
          for( my $k = 1; $k < @r; ++$k ) {
            $r[$k] eq $a and @inc[$i,$j] = @inc[$j,$i];
          }
        }
      }
    }
  }

  $self->_work_done;

  $self->_debug( Data::Dumper->Dump( [\@inc], ['*inc'] ) );

  $self->_msg( "The include path appears to be:" );
  $self->_msg( "  ($_) $inc[$_-1]" ) for 1 .. @inc;

  \@inc;
}

sub _names
{
  my $self = shift;
  my $inc_path = shift;
  my @ppkey = qw( define undef include line error pragma if ifdef ifndef defined elif else endif );
  my %files;
  my %names;
  my %asserts;

  $self->_msg( "\nSearching macro names and assertions..." );

  my @files = map { my $p = $_; map { $p.$_ } _get_files( $p, qr/\.[hH]$/ ) } @$inc_path;
  my $ff = 0;

  while( @files ) {
    my $file = shift @files;
    -e $file or next;
    exists $files{$file} and next;
    $files{$file} = 1;
    $ff = keys %files;
    $self->_work_in_progress( "$ff files found" );
    my $fh = new IO::File $file;
    next unless defined $fh;
    while( <$fh> ) {
      if( /^\s*#\s*include\s*[<"]([^>"]+)[>"]/ ) {
        for( '', @$inc_path ) {
          my $f = $_.$1;
          exists $files{$f} or push @files, $f;
        }
      }
    }
  }

  $self->_debug( Data::Dumper->Dump([\%files], ['*files']) );

  $ff = keys %files;
  my $fs = 0;

  for my $name ( keys %files ) {
    my $count = keys %names;
    $fs++;
    $self->_work_in_progress( "($count) $fs/$ff files scanned" );
    -e $name or next;
    my $fh = new IO::File $name;
    next unless defined $fh;
    my $file = do { local $/; <$fh> };
    $file =~ s{\\\s*$/}{}g;
    while( $file =~ /\b([A-Za-z_]\w*)\b/g ) {
      $names{$1} ||= 1;
    }
    for my $line ( $file =~ /^\s*#(?:el)?if(.*)/gm ) {
      while( $line =~ /#\s*(\w+)\s*\(\s*(\w+)\s*\)/g ) {
        $asserts{$1}{$2} ||= 1;
      }
    }
  }

  delete @names{@ppkey};

  my @names = keys %names;

  my $assertions = 0;
  for( keys %asserts ) {
    $assertions += keys %{$asserts{$_}};
  }

  # merge assertions with fixed assertions from _assert()
  my $asserts = _assert();
  for my $q ( keys %$asserts ) {
    for my $a ( @{$asserts->{$q}} ) {
      $asserts{$q}{$a} ||= 1;
    }
  }

  for( keys %asserts ) {
    $asserts{$_} = [sort keys %{$asserts{$_}}];
  }

  $self->_work_done;
  $self->{debug} and $self->_debug( Data::Dumper->Dump([\@names, \%asserts], [qw(*names *asserts)]) );

  $assertions = $assertions ? " and $assertions potential assertions" : '';
  $self->_msg( sprintf "Found %d potential macro names$assertions.", scalar @names );

  (\@names, \%asserts);
}

sub _basename
{
  my $self = shift;
  my($base) = fileparse( $self->{temp}, '\.[cC][^.]*' );
  $base;
}

sub _configure
{
  my $self = shift;
  my $res;

  $self->_msg( "Checking if your compiler works..." );

  my $line = '"Very useful, no doubt, that was to Saruman; yet it seems that he was not content.";';

  $self->_temp( <<TEMP );
$line
TEMP

  my $ccfg = {
    cc    => [ 'cc', 'gcc', 'icc' ],
    ppout => [ '-E' ],
  };

  if( exists $self->{ccflags} ) {
    $ccfg->{ccflags} = $self->{ccflags};
  }
  else {
    $self->{ccflags} = [];
  }

  $^O eq 'MSWin32' and unshift @{$ccfg->{cc}}, 'cl';

  my $tcfg = {};

  for my $c ( qw( cc ppout ) ) {
    if( exists $self->{$c} ) {
      $tcfg->{$c} = $self->{$c};
      @{$ccfg->{$c}} = grep $_ ne $self->{$c}, @{$ccfg->{$c}};
      unshift @{$ccfg->{$c}}, $self->{$c};
    }
  }

  $self->_debug( Data::Dumper->Dump([$tcfg,$ccfg], ['*tcfg','*ccfg']) );

  $self->{ppout} = shift @{$ccfg->{ppout}};

  my $didnotrun;

  do {
    my $ccname = shift @{$ccfg->{cc}};
    my $fullcc = which( $ccname );
    $self->{cc} = $fullcc || $ccname;
    $res = $self->_runpp_temp;
    $didnotrun = $res->{didnotrun};

    if( $didnotrun and defined $tcfg->{cc} and $tcfg->{cc} eq $ccname ) {
      if( defined $fullcc ) {
        $self->_msg( "It seems your compiler '$self->{cc}' did not run." );
      }
      else {
        $self->_msg( "I could not find your compiler '$self->{cc}'." );
      }
      $self->_msg( "\nI'll try to run some other compilers..." );
    }
  } while( $didnotrun && @{$ccfg->{cc}} );

  if( $didnotrun ) {
    $self->_msg( "None of the compilers I know seemed to run." );
    $self->_quit;
  };

  $self->_msg( "Found a working compiler at $self->{cc}\n" );

  my @ppout = ($self->{ppout}, @{$ccfg->{ppout}});
  my($have_source, $have_ppline);
  my $modified = 0;

  while(1) {
    $have_source = 0;
    $have_ppline = 0;

    $res = $self->_runpp_temp;

    for( @{$res->{stdout}} ) {
      /\Q$line/                                        and $have_source = 1;
      $_ =~ $self->{ppline} && $2 =~ /\Q$self->{temp}/ and $have_ppline = 1;
    }
    $have_source and $have_ppline and last;

    $modified = 1;

    if( @{$ccfg->{ppout}} ) {
      $self->{ppout} = shift @{$ccfg->{ppout}};
    }
    elsif( @{$self->{ccflags}} ) {
      $self->{ccflags} = [];
      $ccfg->{ppout} = [@ppout];
      $self->{ppout} = shift @{$ccfg->{ppout}};
    }
    else {
      $self->_msg( "I couldn't figure out how to get preprocessor output from the compiler." );
      $self->_quit;
    }
  };

  if( $modified ) {
    $self->_msg( "I had to modify the compiler flags to get preprocessor output:" );
    $self->_msg( "  ccflags: @{$self->{ccflags}}" );
    $self->_msg( "  ppout  : $self->{ppout}" );
  }

  my $base = $self->_basename;
  $self->{exe} = $base;
  $self->{obj} = $base;

  my $windows = $^O eq 'MSWin32' || $^O eq 'cygwin';

  $self->{exe} .= '.exe' if $windows;
  $self->{obj} .= $windows ? '.obj' : '.o';

  $self->_temp( <<TEMP );
extern int i;
TEMP

  $res = $self->_compile_temp;

  $self->{can_compile} = $res->{didnotrun} == 0 && $res->{status} == 0;

  if( $self->{can_compile} ) {
    $self->_msg("I can compile object files with $self->{cc}.");
  }
  else {
    $self->_msg("I cannot compile object files.");
  }

  if( $self->{run} ) {
    $self->_temp( <<TEMP );
#include <stdio.h>
int main()
{
  printf("Hello World\\n");
  return 0;
}
TEMP

    $res = $self->_build_temp;

    $self->{can_build} = -e $self->{exe} && $res->{didnotrun} == 0 && $res->{status} == 0;

    if( $self->{can_build} ) {
      $self->_msg("I can build executable files.");
    }
    else {
      $self->_msg("But I cannot build executable files.");
    }

    if( $self->{can_build} ) {
      $res = $self->_run_temp;

      $self->{can_run} = $res->{didnotrun} == 0 && $res->{status} == 0
                         && grep /Hello World/, @{$res->{stdout}};

      if( $self->{can_run} ) {
        $self->_msg("I can also run the executables.");
      }
      else {
        $self->_msg("But I cannot run the executables.");
      }
    }
    else {
      $self->{can_run} = 0;
    }
  }
  else {
    $self->{can_build} = 0;
    $self->{can_run}   = 0;
  }
}

sub _temp
{
  my $self = shift;
  $self->_debug( "creating temporary file '$self->{temp}'\n" );
  if( -e $self->{temp} ) {
    unlink $self->{temp}
      or croak "Could not remove temporary file '$self->{temp}': $!\n";
  }
  my $f = new IO::File ">$self->{temp}";
  defined $f
    or croak "Could not open temporary file '$self->{temp}': $!\n";
  $f->print( @_ );
}

sub _quit
{
  my $self = shift;
  $self->_msg( "Sorry, cannot continue." );
  $self->cleanup;
  exit(1);
}

sub _run_temp
{
  my $self = shift;
  $self->_runprog( "./$self->{exe}" );
}

sub _build_temp
{
  my $self = shift;
  unlink $self->{exe};  # make sure exe is removed
  $self->_runcc( '-o', $self->{exe}, $self->{temp} );
}

sub _compile_temp
{
  my $self = shift;
  unlink $self->{obj};  # make sure obj is removed
  $self->_runcc( '-o', $self->{obj}, '-c', $self->{temp} );
}

sub _runpp_temp
{
  my $self = shift;
  $self->_runpp( $self->{temp} );
}

sub _runpp
{
  my $self = shift;
  $self->_runcc( $self->{ppout}, @_ );
}

sub _runcc
{
  my $self = shift;
  $self->_runprog( $self->{cc}, @{$self->{ccflags}}, @_ );
}

sub _runprog
{
  my $self = shift;
  my $prog = shift;
  my @args = @_;

  eval { alarm 10; alarm 0; };
  my $has_alarm = $@ eq '';

  $self->_debug( "running '$prog @args'\n" );

  my(@sout, @serr);
  local(*W, *S, *E);

  my $pid = open3(\*W, \*S, \*E, $prog, @args);

  eval {
    local $SIG{ALRM};

    if( $has_alarm ) {
      $SIG{ALRM} = sub { die "TIMEOUT\n" };
      alarm $self->{timeout};
    }

    @sout = <S>;
    @serr = <E>;

    waitpid($pid, 0);

    $has_alarm and alarm 0;
  };

  $@ eq "TIMEOUT\n" and kill $pid;

  my %rval = (
    status => $? >> 8,
    stdout => \@sout,
    stderr => \@serr,
  );

  $rval{didnotrun} = 0;

  if( @serr && $serr[0] =~ /^Can't exec "\Q$prog\E":/ ) {
    $rval{didnotrun} = 1;
  }

  if( $^O eq 'MSWin32' && $rval{status} == 1 ) {
    $rval{didnotrun} = 1;
  }

  if( $rval{didnotrun} and $self->{fatal} ) {
    croak "could not run '$prog @args'\n";
  }

  $? & 128 and $rval{core}   = 1;
  $? & 127 and $rval{signal} = $? & 127;

  $self->{debug} and $self->_debug( Data::Dumper->Dump( [\%rval], ['*rval'] ) );

  if( $self->{__int__} ) {
    $self->_msg( "\n\nInterrupted..." );
    $self->_quit;
  }

  \%rval;
}

sub _work_in_progress
{
  my $self = shift;
  $self->{quiet} and return;
  $self->{status} or return;
  my @prog = qw(
    ----------
    >---------
    *>--------
    +*>-------
    -+*>------
    --+*>-----
    ---+*>----
    ----+*>---
    -----+*>--
    ------+*>-
    -------+*>
    --------+*
    ---------+
    ----------
    ---------<
    --------<*
    -------<*+
    ------<*+-
    -----<*+--
    ----<*+---
    ---<*+----
    --<*+-----
    -<*+------
    <*+-------
    *+--------
    +---------
  );
  my $index = 0;
  my @t = times;
  my $t = $t[0]+$t[1]+$t[2]+$t[3];
  if( exists $self->{__progress__} ) {
    $t - $self->{__progress__} < 0.1 and return;
    $index = ++$self->{__prog_index__} % @prog;
  }
  print STDERR "\r", $prog[$index];
  if( @_ ) {
    my $str = ' ' . join( '', @_ );
    $str .= ' 'x(40-length($str));
    print STDERR $str;
  }
  if( $self->{__int__} ) {
    $self->_msg( "\n\nInterrupted..." );
    $self->_quit;
  }
  $self->{__progress__} = $t;
}

sub _work_done
{
  my $self = shift;
  $self->{quiet} and return;
  $self->{status} or return;
  delete $self->{__progress__};
  delete $self->{__prog_index__};
  print STDERR "\r", ' 'x50, "\r";
}

sub _msg
{
  my $self = shift;
  $self->{quiet} and return;
  if( $self->{debug} ) {
    my (undef,undef,$line,$sub) = caller 1;
    print STDERR "($sub:$line): ";
  }
  print STDERR @_, "\n";
}

sub _wrapped_list
{
  my $self = shift;
  $self->{quiet} and return;
  my $string = "[@_]\n";
  print STDERR wrap( '  ', '   ', $string );
}

sub _out
{
  my $self = shift;
  $self->{quiet} and return;
  my $pre = shift;
  my @args = @_;
  for( @args ) {
    s/^/$pre/gms;
    /[\r\n]+$/ or s/$/\n/;
  }
  print STDERR @args;
}

sub _debug
{
  my $self = shift;
  $self->{debug} or return;
  my @args = @_;
  my (undef,undef,$line,$sub) = caller 1;
  s/^/DEBUG | /gms for @args;
  print STDERR "DEBUG @ $sub:$line\n", @args;
}

sub which
{
  my $command = shift;
  my(@PATH, @PATHEXT, $cfg);

  my @config = (
    { os => 'MSWin32|dos|os2', path_sep => ';' , file_sep => '\\', var => 'PATH'     },
    { os => 'MacOS'          , path_sep => '\,', file_sep => ':' , var => 'Commands' },
    { os => '.*'             , path_sep => ':' , file_sep => '/' , var => 'PATH'     },
  );

  for( @config ) {
    if( $^O =~ /^(?:$_->{os})$/ ) {
      $cfg = $_;
      last;
    }
  }

  if( index( $command, $cfg->{file_sep} ) >= 0 ) {
    my $full;

    if( $^O eq 'MacOS' ) {
      -e $command and return $command;
    }
    else {
      -x $command and return $command;
      for my $ext ( @PATHEXT ) {
        -x "$command$ext" and return "$command$ext";
      }
    }
  }
  else {
    if( exists $ENV{$cfg->{var}} ) {
      my %uni;
      @PATH = grep !$uni{$_}++,
              split /$cfg->{path_sep}/, $ENV{$cfg->{var}};
    }

    if( exists $ENV{PATHEXT} ) {
      my %uni;
      @PATHEXT = grep !$uni{$_}++,
                 split /$cfg->{path_sep}/, $ENV{PATHEXT};
    }

    for my $dir ( @PATH ) {
      my $full;

      if( $^O eq 'MacOS' ) {
        $full = "$dir$command";
        -e $full and return $full;
      }
      else {
        $full = "$dir$cfg->{file_sep}$command";
        -x $full and return $full;
        for my $ext ( @PATHEXT ) {
          -x "$full$ext" and return "$full$ext";
        }
      }
    }
  }

  return undef;
}


__END__

=head1 NAME

ccconfig - Get Convert::Binary::C configuration for a compiler

=head1 SYNOPSIS

ccconfig I<options> [-- compiler-options]

I<options>:

  -c         compiler
  --cc       compiler    compiler executable to test
                         default: auto-determined
  
  -p
  --ppout    flag        compiler option for sending
                         preprocessor output to stdout
                         default: -E
  
  -t
  --temp     file        name of the temporary test file
                         default: _t_e_s_t.c
  
  --nodelete             don't delete temporary files
  
  --norun                don't try to run executables
  
  --quiet                don't display anything
  --nostatus             don't display status indicator
  
  --version              print version number
  
  --debug                debug mode

=head1 DESCRIPTION

C<ccconfig> will try to determine a usable configuration for
Convert::Binary::C from testing a compiler executable.
It is not necessary that the binaries generated by the compiler
can be executed, so C<ccconfig> can be used for cross-compilers.

The tool is still experimental, and you should neither rely
on its results without checking, nor expect it to work in your
environment.

=head1 OPTIONS

=head2 --cc compiler

This option allows you to explicitly specify a compiler
executable. This is especially useful if you don't want
to use your system compiler.

=head2 --ppout flag

This option tells C<ccconfig> which flag must be used to
make the compiler write the preprocessor output to standard
output. The default is C<-E>, which is correct for many
compilers.

=head2 --temp

Allows you to change the name of the temporary test file.

=head2 --nodelete

Don't attempt to delete temporary files that have been created
by the compiler. Normally, C<ccconfig> will look for all files
with the same basename as the temporary test file and delete
them.

=head2 --norun

You can specify this option if the executables generated
by your compiler cannot be run on your machine, i.e. if
you have a cross-compiler. However, C<ccconfig> will
automatically find out that it cannot run the executables.

When this option is set, a different set of algorithms is
used to determine a couple of configuration settings. These
algorithms are all based upon placing a special signature
in the object file. They are less reliable that the standard
algorithms, so you shouldn't use them unless you have to.

=head2 --quiet

Don't display anything except for the final configuration.

=head2 --nostatus

Hide the status indicator. Recommended if you want to
redirect the script output to a file:

  ccconfig --nostatus >config.pl 2>ccconfig.log

=head2 --version

Writes the program name, version and path to standard
output.

=head2 --debug

Generate tons of debug output. Don't use unless you know
what you're doing.

=head1 EXAMPLES

Normally, a simple

  ccconfig

without arguments is enough if you want the configuration for
your system compiler. While C<ccconfig> is running, it will
write lots of status information to C<stderr>. When it's done,
it will write a Perl hash table to C<stdout> which can be
directly used as a configuration for Convert::Binary::C.

If you want the configuration for a different compiler,
or C<ccconfig> cannot determine your system compiler
automatically, use

  ccconfig -c gcc32

if your compiler's name is C<gcc32>.

If you want to pass additional options to the compiler, you
can do so after a double-dash on the commandline:

  ccconfig -- -g -DDEBUGGING

or

  ccconfig -c gcc32 -- -ansi -fshort-enums

=head1 COPYRIGHT

Copyright (c) 2002-2003 Marcus Holland-Moritz. All rights reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

See L<Convert::Binary::C>.

=cut


__END__
:endofperl
