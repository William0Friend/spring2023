
# This is CPAN.pm's systemwide configuration file. This file provides
# defaults for users, and the values can be changed in a per-user
# configuration file. The user-config file is being looked for as
# ~/.cpan/CPAN/MyConfig.pm.

$CPAN::Config = {
  'build_cache' => q[10],
  'build_dir' => q[C:\.cpan\build],
  'cache_metadata' => q[1],
  'cpan_home' => q[C:\.cpan],
  'ftp' => q[C:\WINDOWS\system32\ftp.EXE],
  'ftp_proxy' => q[],
  'getcwd' => q[cwd],
  'gzip' => q[D:\Cygwin\bin\gzip.EXE],
  'http_proxy' => q[],
  'inactivity_timeout' => q[0],
  'index_expire' => q[1],
  'inhibit_startup_message' => q[0],
  'keep_source_where' => q[C:\.cpan\sources],
  'lynx' => q[D:\Cygwin\bin\lynx.EXE],
  'make' => q[C:\VStudio\VC98\bin\nmake.EXE],
  'make_arg' => q[],
  'make_install_arg' => q[UNINST=1],
  'makepl_arg' => q[],
  'ncftpget' => q[D:\Cygwin\bin\ncftpget.EXE],
  'no_proxy' => q[],
  'pager' => q[D:\Cygwin\bin\less.EXE],
  'prerequisites_policy' => q[ask],
  'scan_cache' => q[atstart],
  'shell' => q[],
  'tar' => q[D:\Cygwin\bin\tar.EXE],
  'term_is_latin' => q[1],
  'unzip' => q[D:\Cygwin\bin\unzip.EXE],
  'urllist' => [q[ftp://theoryx5.uwinnipeg.ca/pub/CPAN/], q[ftp://cpan.sunsite.ualberta.ca/pub/CPAN/], q[ftp://ftp.nrc.ca/pub/CPAN/], q[ftp://cpan.chebucto.ns.ca/pub/CPAN/]],
  'wait_list' => [q[wait://ls6-www.informatik.uni-dortmund.de:1404]],
  'wget' => q[D:\Cygwin\bin\wget.EXE],
};
1;
__END__
