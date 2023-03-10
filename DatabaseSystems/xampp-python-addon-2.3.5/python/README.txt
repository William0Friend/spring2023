This is Python version 2.3.5
============================

Copyright (c) 2001, 2002, 2003, 2004, 2005 Python Software Foundation.
All rights reserved.

Copyright (c) 2000 BeOpen.com.
All rights reserved.

Copyright (c) 1995-2001 Corporation for National Research Initiatives.
All rights reserved.

Copyright (c) 1991-1995 Stichting Mathematisch Centrum.
All rights reserved.


License information
-------------------

See the file "LICENSE" for information on the history of this
software, terms & conditions for usage, and a DISCLAIMER OF ALL
WARRANTIES.

This Python distribution contains no GNU General Public Licensed
(GPLed) code so it may be used in proprietary projects just like prior
Python distributions.  There are interfaces to some GNU code but these
are entirely optional.

All trademarks referenced herein are property of their respective
holders.


What's new in this release?
---------------------------

See the file "Misc/NEWS".


If you don't read instructions
------------------------------

Congratulations on getting this far. :-)

To start building right away (on UNIX): type "./configure" in the
current directory and when it finishes, type "make".  This creates an
executable "./python"; to install in /usr/local, first do "su root"
and then "make install".

The section `Build instructions' below is still recommended reading,
especially the part on customizing Modules/Setup.


What is Python anyway?
----------------------

Python is an interpreted object-oriented programming language suitable
(amongst other uses) for distributed application development,
scripting, numeric computing and system testing.  Python is often
compared to Tcl, Perl, Java, JavaScript, Visual Basic or Scheme.  To
find out more about what Python can do for you, point your browser to
http://www.python.org/.


How do I learn Python?
----------------------

The official tutorial is still a good place to start; see
http://www.python.org/doc/ for online and downloadable versions, as
well as a list of other introductions, and reference documentation.

There's a quickly growing set of books on Python.  See
http://www.python.org/cgi-bin/moinmoin/PythonBooks for a list.


Documentation
-------------

All documentation is provided online in a variety of formats.  In
order of importance for new users: Tutorial, Library Reference,
Language Reference, Extending & Embedding, and the Python/C API.  The
Library Reference is especially of immense value since much of
Python's power is described there, including the built-in data types
and functions!

All documentation is also available online at the Python web site
(http://www.python.org/doc/, see below).  It is available online for
occasional reference, or can be downloaded in many formats for faster
access.  The documentation is available in HTML, PostScript, PDF, and
LaTeX formats; the LaTeX version is primarily for documentation
authors, translators, and people with special formatting requirements.

The best documentation for the new (in Python 2.2) type/class
unification features is Guido's tutorial introduction, at

    http://www.python.org/2.2.1/descrintro.html


Web sites
---------

New Python releases and related technologies are published at
http://www.python.org/.  Come visit us!

There's also a Python community web site at
http://starship.python.net/.


Newsgroups and Mailing Lists
----------------------------

Read comp.lang.python, a high-volume discussion newsgroup about
Python, or comp.lang.python.announce, a low-volume moderated newsgroup
for Python-related announcements.  These are also accessible as
mailing lists: see http://www.python.org/psa/MailingLists.html for an
overview of the many Python-related mailing lists.

Archives are accessible via the Google Groups usenet archive; see
http://groups.google.com/.  The mailing lists are also archived, see
http://www.python.org/psa/MailingLists.html for details.


Bug reports
-----------

To report or search for bugs, please use the Python Bug
Tracker at http://sourceforge.net/bugs/?group_id=5470.


Patches and contributions
-------------------------

To submit a patch or other contribution, please use the Python Patch
Manager at http://sourceforge.net/patch/?group_id=5470.  Guidelines
for patch submission may be found at http://www.python.org/patches/.

If you have a proposal to change Python, it's best to submit a Python
Enhancement Proposal (PEP) first.  All current PEPs, as well as
guidelines for submitting a new PEP, are listed at
http://python.sourceforge.net/peps/.


Questions
---------

For help, if you can't find it in the manuals or on the web site, it's
best to post to the comp.lang.python or the Python mailing list (see
above).  If you specifically don't want to involve the newsgroup or
mailing list, send questions to help@python.org (a group of volunteers
who answer questions as they can).  The newsgroup is the most
efficient way to ask public questions.


Build instructions
==================

Before you can build Python, you must first configure it.
Fortunately, the configuration and build process has been automated
for Unix and Linux installations, so all you usually have to do is
type a few commands and sit back.  There are some platforms where
things are not quite as smooth; see the platform specific notes below.
If you want to build for multiple platforms sharing the same source
tree, see the section on VPATH below.

Start by running the script "./configure", which determines your
system configuration and creates the Makefile.  (It takes a minute or
two -- please be patient!)  You may want to pass options to the
configure script -- see the section below on configuration options and
variables.  When it's done, you are ready to run make.

To build Python, you normally type "make" in the toplevel directory.
If you have changed the configuration, the Makefile may have to be
rebuilt.  In this case you may have to run make again to correctly
build your desired target.  The interpreter executable is built in the
top level directory.

Once you have built a Python interpreter, see the subsections below on
testing and installation.  If you run into trouble, see the next
section.

Previous versions of Python used a manual configuration process that
involved editing the file Modules/Setup.  While this file still exists
and manual configuration is still supported, it is rarely needed any
more: almost all modules are automatically built as appropriate under
guidance of the setup.py script, which is run by Make after the
interpreter has been built.


Troubleshooting
---------------

See also the platform specific notes in the next section.

If you run into other trouble, see section 3 of the FAQ
(http://www.python.org/cgi-bin/faqw.py or
http://www.python.org/doc/FAQ.html) for hints on what can go wrong,
and how to fix it.

If you rerun the configure script with different options, remove all
object files by running "make clean" before rebuilding.  Believe it or
not, "make clean" sometimes helps to clean up other inexplicable
problems as well.  Try it before sending in a bug report!

If the configure script fails or doesn't seem to find things that
should be there, inspect the config.log file.  When you fix a
configure problem, be sure to remove config.cache!

If you get a warning for every file about the -Olimit option being no
longer supported, you can ignore it.  There's no foolproof way to know
whether this option is needed; all we can do is test whether it is
accepted without error.  On some systems, e.g. older SGI compilers, it
is essential for performance (specifically when compiling ceval.c,
which has more basic blocks than the default limit of 1000).  If the
warning bothers you, edit the Makefile to remove "-Olimit 1500" from
the OPT variable.

If you get failures in test_long, or sys.maxint gets set to -1, you
are probably experiencing compiler bugs, usually related to
optimization.  This is a common problem with some versions of gcc, and
some vendor-supplied compilers, which can sometimes be worked around
by turning off optimization.  Consider switching to stable versions
(gcc 2.95.2, or contact your vendor.)

From Python 2.0 onward, all Python C code is ANSI C.  Compiling using
old K&R-C-only compilers is no longer possible.  ANSI C compilers are
available for all modern systems, either in the form of updated
compilers from the vendor, or one of the free compilers (gcc).


Unsupported systems
-------------------

A number of features are not supported in Python 2.3 anymore. Some
support code is still present, but will be removed in Python 2.4.
If you still need to use current Python versions on these systems,
please send a message to python-dev@python.org indicating that you
volunteer to support this system.

More specifically, the following systems are not supported any
longer:
- SunOS 4
- DYNIX
- dgux
- Minix
- Irix 4 and --with-sgi-dl
- Linux 1
- Systems defining __d6_pthread_create (configure.in)
- Systems defining PY_PTHREAD_D4, PY_PTHREAD_D6,
  or PY_PTHREAD_D7 in thread_pthread.h
- Systems using --with-dl-dld
- Systems using --without-universal-newlines


Platform specific notes
-----------------------

(Some of these may no longer apply.  If you find you can build Python
on these platforms without the special directions mentioned here,
submit a documentation bug report to SourceForge (see Bug Reports
above) so we can remove them!)

Unix platforms: If your vendor still ships (and you still use) Berkeley DB
	1.85 you will need to edit Modules/Setup to build the bsddb185
	module and add a line to sitecustomize.py which makes it the
	default.  In Modules/Setup a line like

	    bsddb185 bsddbmodule.c

	should work.  (You may need to add -I, -L or -l flags to direct the
	compiler and linker to your include files and libraries.)  You can
	then force it to be the version people import by adding

	    import bsddb185 as bsddb

	in sitecustomize.py.

64-bit platforms: The modules audioop, imageop and rgbimg don't work.
	The setup.py script disables them on 64-bit installations.
	Don't try to enable them in the Modules/Setup file.  They
	contain code that is quite wordsize sensitive.  (If you have a
	fix, let us know!)

Solaris: When using Sun's C compiler with threads, at least on Solaris
	2.5.1, you need to add the "-mt" compiler option (the simplest
	way is probably to specify the compiler with this option as
	the "CC" environment variable when running the configure
	script).

        When using GCC on Solaris, beware of binutils 2.13 or GCC
        versions built using it.  This mistakenly enables the
        -zcombreloc option which creates broken shared libraries on
        Solaris.  binutils 2.12 works, and the binutils maintainers
        are aware of the problem.  Binutils 2.13.1 only partially
        fixed things.  It appears that 2.13.2 solves the problem
        completely.  This problem is known to occur with Solaris 2.7
        and 2.8, but may also affect earlier and later versions of the
        OS.

	When the dynamic loader complains about errors finding shared
	libraries, such as

	ld.so.1: ./python: fatal: libstdc++.so.5: open failed: 
	No such file or directory 

	you need to first make sure that the library is available on
	your system. Then, you need to instruct the dynamic loader how
	to find it. You can choose any of the following strategies:

	1. When compiling Python, set LD_RUN_PATH to the directories
	   containing missing libraries.
	2. When running Python, set LD_LIBRARY_PATH to these directories.
	3. Use crle(8) to extend the search path of the loader.
	4. Modify the installed GCC specs file, adding -R options into the
	   *link: section.

Linux:  A problem with threads and fork() was tracked down to a bug in
	the pthreads code in glibc version 2.0.5; glibc version 2.0.7
	solves the problem.  This causes the popen2 test to fail;
	problem and solution reported by Pablo Bleyer.

	Under Linux systems using GNU libc 2 (aka libc6), the crypt
	module now needs the -lcrypt option.  The setup.py script
	takes care of this automatically.

Red Hat Linux: Red Hat 9 built Python2.2 in UCS-4 mode and hacked
	Tcl to support it. To compile Python2.3 with Tkinter, you will
	need to pass --enable-unicode=ucs4 flag to ./configure. 

	There's an executable /usr/bin/python which is Python
	1.5.2 on most older Red Hat installations; several key Red Hat tools
	require this version.  Python 2.1.x may be installed as
	/usr/bin/python2.  The Makefile installs Python as
	/usr/local/bin/python, which may or may not take precedence
	over /usr/bin/python, depending on how you have set up $PATH.

FreeBSD 3.x and probably platforms with NCurses that use libmytinfo or
	similar: When using cursesmodule, the linking is not done in
	the correct order with the defaults.  Remove "-ltermcap" from
	the readline entry in Setup, and use as curses entry: "curses
	cursesmodule.c -lmytinfo -lncurses -ltermcap" - "mytinfo" (so
	called on FreeBSD) should be the name of the auxiliary library
	required on your platform.  Normally, it would be linked
	automatically, but not necessarily in the correct order.

BSDI:	BSDI versions before 4.1 have known problems with threads,
	which can cause strange errors in a number of modules (for
	instance, the 'test_signal' test script will hang forever.)
	Turning off threads (with --with-threads=no) or upgrading to
	BSDI 4.1 solves this problem.

DEC Unix: Run configure with --with-dec-threads, or with
	--with-threads=no if no threads are desired (threads are on by
	default).  When using GCC, it is possible to get an internal
	compiler error if optimization is used.  This was reported for
	GCC 2.7.2.3 on selectmodule.c.  Manually compile the affected
	file without optimization to solve the problem.

DEC Ultrix: compile with GCC to avoid bugs in the native compiler,
	and pass SHELL=/bin/sh5 to Make when installing.

AIX:	A complete overhaul of the shared library support is now in
	place.  See Misc/AIX-NOTES for some notes on how it's done.
	(The optimizer bug reported at this place in previous releases
	has been worked around by a minimal code change.) If you get
	errors about pthread_* functions, during compile or during
	testing, try setting CC to a thread-safe (reentrant) compiler,
	like "cc_r".  For full C++ module support, set CC="xlC_r" (or
	CC="xlC" without thread support).

HP-UX:	When using threading, you may have to add -D_REENTRANT to the
	OPT variable in the top-level Makefile; reported by Pat Knight,
	this seems to make a difference (at least for HP-UX 10.20)
	even though pyconfig.h defines it. This seems unnecessary when
	using HP/UX 11 and later - threading works "out of the box".

HP-UX ia64: When building on the ia64 (Itanium) platform using HP's 
        compiler, some experience has shown that the compiler's
        optimiser produces a completely broken version of python
        (see http://www.python.org/sf/814976). To work around this,
        edit the Makefile and remove -O from the OPT line.

HP PA-RISC 2.0: A recent bug report (http://www.python.org/sf/546117)
	suggests that the C compiler in this 64-bit system has bugs
	in the optimizer that break Python.  Compiling without
	optimization solves the problems.

SCO:	The following apply to SCO 3 only; Python builds out of the box
	on SCO 5 (or so we've heard).

	1) Everything works much better if you add -U__STDC__ to the
	defs.  This is because all the SCO header files are broken.
	Anything that isn't mentioned in the C standard is
	conditionally excluded when __STDC__ is defined.

	2) Due to the U.S. export restrictions, SCO broke the crypt
	stuff out into a separate library, libcrypt_i.a so the LIBS
	needed be set to:

		LIBS=' -lsocket -lcrypt_i'

UnixWare: There are known bugs in the math library of the system, as well as
        problems in the handling of threads (calling fork in one
        thread may interrupt system calls in others). Therefore, test_math and
        tests involving threads will fail until those problems are fixed.

SunOS 4.x: When using the SunPro C compiler, you may want to use the
	'-Xa' option instead of '-Xc', to enable some needed non-ANSI
	Sunisms.
	THIS SYSTEM IS NO LONGER SUPPORTED.

NeXT:   Not supported anymore. Start with the MacOSX/Darwin code if you
	want to revive it.

QNX:	Chris Herborth (chrish@qnx.com) writes:
	configure works best if you use GNU bash; a port is available on
	ftp.qnx.com in /usr/free.  I used the following process to build,
	test and install Python 1.5.x under QNX:

	1) CONFIG_SHELL=/usr/local/bin/bash CC=cc RANLIB=: \
	    ./configure --verbose --without-gcc --with-libm=""

	2) edit Modules/Setup to activate everything that makes sense for
	   your system... tested here at QNX with the following modules:

		array, audioop, binascii, cPickle, cStringIO, cmath,
		crypt, curses, errno, fcntl, gdbm, grp, imageop,
		_locale, math, md5, new, operator, parser, pcre,
		posix, pwd, readline, regex, reop, rgbimg, rotor,
		select, signal, socket, soundex, strop, struct,
		syslog, termios, time, timing, zlib, audioop, imageop, rgbimg

	3) make SHELL=/usr/local/bin/bash

	   or, if you feel the need for speed:

	   make SHELL=/usr/local/bin/bash OPT="-5 -Oil+nrt"

	4) make SHELL=/usr/local/bin/bash test

	   Using GNU readline 2.2 seems to behave strangely, but I
	   think that's a problem with my readline 2.2 port.  :-\

	5) make SHELL=/usr/local/bin/bash install

	If you get SIGSEGVs while running Python (I haven't yet, but
	I've only run small programs and the test cases), you're
	probably running out of stack; the default 32k could be a
	little tight.  To increase the stack size, edit the Makefile
	to read: LDFLAGS = -N 48k

BeOS:	See Misc/BeOS-NOTES for notes about compiling/installing
	Python on BeOS R3 or later.  Note that only the PowerPC
	platform is supported for R3; both PowerPC and x86 are
	supported for R4.

Cray T3E: Mark Hadfield (m.hadfield@niwa.co.nz) writes:
	Python can be built satisfactorily on a Cray T3E but based on
	my experience with the NIWA T3E (2002-05-22, version 2.2.1)
	there are a few bugs and gotchas. For more information see a
	thread on comp.lang.python in May 2002 entitled "Building
	Python on Cray T3E".

        1) Use Cray's cc and not gcc. The latter was reported not to
           work by Konrad Hinsen. It may work now, but it may not.

        2) To set sys.platform to something sensible, pass the
           following environment variable to the configure script:

             MACHDEP=unicosmk

	2) Run configure with option "--enable-unicode=ucs4".

	3) The Cray T3E does not support dynamic linking, so extension
	   modules have to be built by adding (or uncommenting) lines
	   in Modules/Setup. The minimum set of modules is

	     posix, new, _sre, unicodedata

	   On NIWA's vanilla T3E system the following have also been
	   included successfully:

	     _codecs, _locale, _socket, _symtable, _testcapi, _weakref
	     array, binascii, cmath, cPickle, crypt, cStringIO, dbm
	     errno, fcntl, grp, math, md5, operator, parser, pcre, pwd
	     regex, rotor, select, struct, strop, syslog, termios
	     time, timing, xreadlines

	4) Once the python executable and library have been built, make
	   will execute setup.py, which will attempt to build remaining
	   extensions and link them dynamically. Each of these attempts
	   will fail but should not halt the make process. This is
	   normal.

	5) Running "make test" uses a lot of resources and causes
	   problems on our system. You might want to try running tests
	   singly or in small groups.

SGI:	SGI's standard "make" utility (/bin/make or /usr/bin/make)
	does not check whether a command actually changed the file it
	is supposed to build.  This means that whenever you say "make"
	it will redo the link step.  The remedy is to use SGI's much
	smarter "smake" utility (/usr/sbin/smake), or GNU make.  If
	you set the first line of the Makefile to #!/usr/sbin/smake
	smake will be invoked by make (likewise for GNU make).

	WARNING: There are bugs in the optimizer of some versions of
	SGI's compilers that can cause bus errors or other strange
	behavior, especially on numerical operations.  To avoid this,
	try building with "make OPT=".

OS/2:   If you are running Warp3 or Warp4 and have IBM's VisualAge C/C++
        compiler installed, just change into the pc\os2vacpp directory
        and type NMAKE.  Threading and sockets are supported by default
        in the resulting binaries of PYTHON15.DLL and PYTHON.EXE.

Monterey (64-bit AIX): The current Monterey C compiler (Visual Age)
        uses the OBJECT_MODE={32|64} environment variable to set the
        compilation mode to either 32-bit or 64-bit (32-bit mode is
        the default).  Presumably you want 64-bit compilation mode for
        this 64-bit OS.  As a result you must first set OBJECT_MODE=64
        in your environment before configuring (./configure) or
        building (make) Python on Monterey.

Reliant UNIX: The thread support does not compile on Reliant UNIX, and
        there is a (minor) problem in the configure script for that
        platform as well.  This should be resolved in time for a
        future release.

MacOSX: The tests will crash on both 10.1 and 10.2 with SEGV in
        test_re and test_sre due to the small default stack size.  If
        you set the stack size to 2048 before doing a "make test" the
        failure can be avoided.  If you're using the tcsh (the default
        on OSX), or csh shells use "limit stacksize 2048" and for the
        bash shell, use "ulimit -s 2048".

        On naked Darwin you may want to add the configure option
        "--disable-toolbox-glue" to disable the glue code for the Carbon
        interface modules. The modules themselves are currently only built
        if you add the --enable-framework option, see below.

        On a clean OSX /usr/local does not exist. Do a
        "sudo mkdir -m 775 /usr/local"
        before you do a make install. It is probably not a good idea to
        do "sudo make install" which installs everything as superuser,
        as this may later cause problems when installing distutils-based
        additions.
        
        Some people have reported problems building Python after using "fink"
        to install additional unix software. Disabling fink (remove all references
        to /sw from your .profile or .login) should solve this.

        You may want to try the configure option "--enable-framework"
        which installs Python as a framework. The location can be set
        as argument to the --enable-framework option (default
        /Library/Frameworks). A framework install is probably needed if you
        want to use any Aqua-based GUI toolkit (whether Tkinter, wxPython,
        Carbon, Cocoa or anything else).
        
        See Mac/OSX/README for more information on framework builds.

Cygwin: With recent (relative to the time of writing, 2001-12-19)
        Cygwin installations, there are problems with the interaction
        of dynamic linking and fork().  This manifests itself in build
        failures during the execution of setup.py.

        There are two workarounds that both enable Python (albeit
        without threading support) to build and pass all tests on
        NT/2000 (and most likely XP as well, though reports of testing
        on XP would be appreciated).

        The workarounds:

        (a) the band-aid fix is to link the _socket module statically
        rather than dynamically (which is the default).

        To do this, run "./configure --with-threads=no" including any
        other options you need (--prefix, etc.).  Then in Modules/Setup
        uncomment the lines:

        #SSL=/usr/local/ssl
        #_socket socketmodule.c \
        #	-DUSE_SSL -I$(SSL)/include -I$(SSL)/include/openssl \
        #	-L$(SSL)/lib -lssl -lcrypto

        and remove "local/" from the SSL variable.  Finally, just run
        "make"!

        (b) The "proper" fix is to rebase the Cygwin DLLs to prevent
        base address conflicts.  Details on how to do this can be
        found in the following mail:

           http://sources.redhat.com/ml/cygwin/2001-12/msg00894.html

        It is hoped that a version of this solution will be
        incorporated into the Cygwin distribution fairly soon.

        Two additional problems:

        (1) Threading support should still be disabled due to a known
        bug in Cygwin pthreads that causes test_threadedtempfile to
        hang.

        (2) The _curses module does not build.  This is a known
        Cygwin ncurses problem that should be resolved the next time
        that this package is released.

        On older versions of Cygwin, test_poll may hang and test_strftime
        may fail.

        The situation on 9X/Me is not accurately known at present.
        Some time ago, there were reports that the following
        regression tests failed:

            test_pwd
            test_select (hang)
            test_socket

        Due to the test_select hang on 9X/Me, one should run the
        regression test using the following:

            make TESTOPTS='-l -x test_select' test

        News regarding these platforms with more recent Cygwin
        versions would be appreciated!

AtheOS: From Octavian Cerna <tavy at ylabs.com>:

	Before building:

	    Make sure you have shared versions of the libraries you
	    want to use with Python. You will have to compile them
	    yourself, or download precompiled packages.

	    Recommended libraries:

		ncurses-4.2
		readline-4.2a
		zlib-1.1.4

	Build:

	    $ ./configure --prefix=/usr/python
	    $ make

	    Python is always built as a shared library, otherwise
	    dynamic loading would not work.

	Testing:

	    $ make test

	Install:

	    # make install
	    # pkgmanager -a /usr/python


	AtheOS issues:

	    - large file support: due to a stdio bug in glibc/libio,
	      access to large files may not work correctly.  fseeko()
	      tries to seek to a negative offset.  ftello() returns a
	      negative offset, it looks like a 32->64bit
	      sign-extension issue.  The lowlevel functions (open,
	      lseek, etc) are OK.
	    - sockets: AF_UNIX is defined in the C library and in
	      Python, but not implemented in the system.
	    - select: poll is available in the C library, but does not
	      work (It does not return POLLNVAL for bad fds and
	      hangs).
              (Believed fixed, unverified - autoconf check for broken poll)
	    - posix: statvfs and fstatvfs always return ENOSYS.
	    - disabled modules:
		- mmap: not yet implemented in AtheOS
		- nis: broken (on an unconfigured system
		  yp_get_default_domain() returns junk instead of
		  error)
		- dl: dynamic loading doesn't work via dlopen()
		- resource: getrimit and setrlimit are not yet
		  implemented

	    - if you are getting segmentation faults, you probably are
	      low on memory.  AtheOS doesn't handle very well an
	      out-of-memory condition and simply SEGVs the process.

	Tested on:

	    AtheOS-0.3.7
	    gcc-2.95
	    binutils-2.10
	    make-3.78


Configuring the bsddb and dbm modules
-------------------------------------

Beginning with Python version 2.3, the PyBsddb package
<http://pybsddb.sf.net/> was adopted into Python as the bsddb package,
exposing a set of package-level functions which provide
backwards-compatible behavior.  Only versions 3.1 through 4.1 of
Sleepycat's libraries provide the necessary API, so older versions
aren't supported through this interface.  The old bsddb module has
been retained as bsddb185, though it is not built by default.  Users
wishing to use it will have to tweak Modules/Setup to build it.  The
dbm module will still be built against the Sleepycat libraries if
other preferred alternatives (ndbm, gdbm) are not found, though
versions of the Sleepycat library prior to 3.1 are not considered.


Configuring threads
-------------------

As of Python 2.0, threads are enabled by default.  If you wish to
compile without threads, or if your thread support is broken, pass the
--with-threads=no switch to configure.  Unfortunately, on some
platforms, additional compiler and/or linker options are required for
threads to work properly.  Below is a table of those options,
collected by Bill Janssen.  We would love to automate this process
more, but the information below is not enough to write a patch for the
configure.in file, so manual intervention is required.  If you patch
the configure.in file and are confident that the patch works, please
send in the patch.  (Don't bother patching the configure script itself
-- it is regenerated each time the configure.in file changes.)

Compiler switches for threads
.............................

The definition of _REENTRANT should be configured automatically, if
that does not work on your system, or if _REENTRANT is defined
incorrectly, please report that as a bug.

    OS/Compiler/threads                     Switches for use with threads
    (POSIX is draft 10, DCE is draft 4)     compile & link

    SunOS 5.{1-5}/{gcc,SunPro cc}/solaris   -mt
    SunOS 5.5/{gcc,SunPro cc}/POSIX         (nothing)
    DEC OSF/1 3.x/cc/DCE                    -threads
	    (butenhof@zko.dec.com)
    Digital UNIX 4.x/cc/DCE                 -threads
	    (butenhof@zko.dec.com)
    Digital UNIX 4.x/cc/POSIX               -pthread
	    (butenhof@zko.dec.com)
    AIX 4.1.4/cc_r/d7                       (nothing)
	    (buhrt@iquest.net)
    AIX 4.1.4/cc_r4/DCE                     (nothing)
	    (buhrt@iquest.net)
    IRIX 6.2/cc/POSIX                       (nothing)
	    (robertl@cwi.nl)


Linker (ld) libraries and flags for threads
...........................................

    OS/threads                          Libraries/switches for use with threads

    SunOS 5.{1-5}/solaris               -lthread
    SunOS 5.5/POSIX                     -lpthread
    DEC OSF/1 3.x/DCE                   -lpthreads -lmach -lc_r -lc
	    (butenhof@zko.dec.com)
    Digital UNIX 4.x/DCE                -lpthreads -lpthread -lmach -lexc -lc
	    (butenhof@zko.dec.com)
    Digital UNIX 4.x/POSIX              -lpthread -lmach -lexc -lc
	    (butenhof@zko.dec.com)
    AIX 4.1.4/{draft7,DCE}              (nothing)
	    (buhrt@iquest.net)
    IRIX 6.2/POSIX                      -lpthread
	    (jph@emilia.engr.sgi.com)


Building a shared libpython
---------------------------

Starting with Python 2.3, the majority of the interpreter can be built
into a shared library, which can then be used by the interpreter 
executable, and by applications embedding Python. To enable this feature,
configure with --enable-shared. 

If you enable this feature, the same object files will be used to create
a static library.  In particular, the static library will contain object
files using position-independent code (PIC) on platforms where PIC flags
are needed for the shared library.


Configuring additional built-in modules
---------------------------------------

Starting with Python 2.1, the setup.py script at the top of the source
distribution attempts to detect which modules can be built and
automatically compiles them.  Autodetection doesn't always work, so
you can still customize the configuration by editing the Modules/Setup
file; but this should be considered a last resort.  The rest of this
section only applies if you decide to edit the Modules/Setup file.
You also need this to enable static linking of certain modules (which
is needed to enable profiling on some systems).

This file is initially copied from Setup.dist by the configure script;
if it does not exist yet, create it by copying Modules/Setup.dist
yourself (configure will never overwrite it).  Never edit Setup.dist
-- always edit Setup or Setup.local (see below).  Read the comments in
the file for information on what kind of edits are allowed.  When you
have edited Setup in the Modules directory, the interpreter will
automatically be rebuilt the next time you run make (in the toplevel
directory).

Many useful modules can be built on any Unix system, but some optional
modules can't be reliably autodetected.  Often the quickest way to
determine whether a particular module works or not is to see if it
will build: enable it in Setup, then if you get compilation or link
errors, disable it -- you're either missing support or need to adjust
the compilation and linking parameters for that module.

On SGI IRIX, there are modules that interface to many SGI specific
system libraries, e.g. the GL library and the audio hardware.  These
modules will not be built by the setup.py script.

In addition to the file Setup, you can also edit the file Setup.local.
(the makesetup script processes both).  You may find it more
convenient to edit Setup.local and leave Setup alone.  Then, when
installing a new Python version, you can copy your old Setup.local
file.


Setting the optimization/debugging options
------------------------------------------

If you want or need to change the optimization/debugging options for
the C compiler, assign to the OPT variable on the toplevel make
command; e.g. "make OPT=-g" will build a debugging version of Python
on most platforms.  The default is OPT=-O; a value for OPT in the
environment when the configure script is run overrides this default
(likewise for CC; and the initial value for LIBS is used as the base
set of libraries to link with).

When compiling with GCC, the default value of OPT will also include
the -Wall and -Wstrict-prototypes options.

Additional debugging code to help debug memory management problems can
be enabled by using the --with-pydebug option to the configure script.


Profiling
---------

If you want C profiling turned on, the easiest way is to run configure
with the CC environment variable to the necessary compiler
invocation.  For example, on Linux, this works for profiling using
gprof(1):

    CC="gcc -pg" ./configure

Note that on Linux, gprof apparently does not work for shared
libraries.  The Makefile/Setup mechanism can be used to compile and
link most extension modules statically.


Testing
-------

To test the interpreter, type "make test" in the top-level directory.
This runs the test set twice (once with no compiled files, once with
the compiled files left by the previous test run).  The test set
produces some output.  You can generally ignore the messages about
skipped tests due to optional features which can't be imported.
If a message is printed about a failed test or a traceback or core
dump is produced, something is wrong.  On some Linux systems (those
that are not yet using glibc 6), test_strftime fails due to a
non-standard implementation of strftime() in the C library. Please
ignore this, or upgrade to glibc version 6.

IMPORTANT: If the tests fail and you decide to mail a bug report,
*don't* include the output of "make test".  It is useless.  Run the
failing test manually, as follows:

	./python ./Lib/test/test_whatever.py

(substituting the top of the source tree for '.' if you built in a
different directory).  This runs the test in verbose mode.


Installing
----------

To install the Python binary, library modules, shared library modules
(see below), include files, configuration files, and the manual page,
just type

	make install

This will install all platform-independent files in subdirectories of
the directory given with the --prefix option to configure or to the
`prefix' Make variable (default /usr/local).  All binary and other
platform-specific files will be installed in subdirectories if the
directory given by --exec-prefix or the `exec_prefix' Make variable
(defaults to the --prefix directory) is given.

If DESTDIR is set, it will be taken as the root directory of the
installation, and files will be installed into $(DESTDIR)$(prefix),
$(DESTDIR)$(exec_prefix), etc.

All subdirectories created will have Python's version number in their
name, e.g. the library modules are installed in
"/usr/local/lib/python<version>/" by default, where <version> is the
<major>.<minor> release number (e.g. "2.1").  The Python binary is
installed as "python<version>" and a hard link named "python" is
created.  The only file not installed with a version number in its
name is the manual page, installed as "/usr/local/man/man1/python.1"
by default.

If you have a previous installation of Python that you don't
want to replace yet, use

	make altinstall

This installs the same set of files as "make install" except it
doesn't create the hard link to "python<version>" named "python" and
it doesn't install the manual page at all.

The only thing you may have to install manually is the Python mode for
Emacs found in Misc/python-mode.el.  (But then again, more recent
versions of Emacs may already have it.)  Follow the instructions that
came with Emacs for installation of site-specific files.

On Mac OS X, if you have configured Python with --enable-framework, you
should use "make frameworkinstall" to do the installation. Note that this
installs the Python executable in a place that is not normally on your
PATH, you may want to set up a symlink in /usr/local/bin.


Configuration options and variables
-----------------------------------

Some special cases are handled by passing options to the configure
script.

WARNING: if you rerun the configure script with different options, you
must run "make clean" before rebuilding.  Exceptions to this rule:
after changing --prefix or --exec-prefix, all you need to do is remove
Modules/getpath.o.

--with(out)-gcc: The configure script uses gcc (the GNU C compiler) if
	it finds it.  If you don't want this, or if this compiler is
	installed but broken on your platform, pass the option
	--without-gcc.  You can also pass "CC=cc" (or whatever the
	name of the proper C compiler is) in the environment, but the
	advantage of using --without-gcc is that this option is
	remembered by the config.status script for its --recheck
	option.

--prefix, --exec-prefix: If you want to install the binaries and the
	Python library somewhere else than in /usr/local/{bin,lib},
	you can pass the option --prefix=DIRECTORY; the interpreter
	binary will be installed as DIRECTORY/bin/python and the
	library files as DIRECTORY/lib/python/*.  If you pass
	--exec-prefix=DIRECTORY (as well) this overrides the
	installation prefix for architecture-dependent files (like the
	interpreter binary).  Note that --prefix=DIRECTORY also
	affects the default module search path (sys.path), when
	Modules/config.c is compiled.  Passing make the option
	prefix=DIRECTORY (and/or exec_prefix=DIRECTORY) overrides the
	prefix set at configuration time; this may be more convenient
	than re-running the configure script if you change your mind
	about the install prefix.

--with-readline: This option is no longer supported.  GNU
	readline is automatically enabled by setup.py when present.

--with-threads: On most Unix systems, you can now use multiple
	threads, and support for this is enabled by default.  To
	disable this, pass --with-threads=no.  If the library required
	for threads lives in a peculiar place, you can use
	--with-thread=DIRECTORY.  IMPORTANT: run "make clean" after
	changing (either enabling or disabling) this option, or you
	will get link errors!  Note: for DEC Unix use
	--with-dec-threads instead.

--with-sgi-dl: On SGI IRIX 4, dynamic loading of extension modules is
	supported by the "dl" library by Jack Jansen, which is
	ftp'able from ftp://ftp.cwi.nl/pub/dynload/dl-1.6.tar.Z.
	This is enabled (after you've ftp'ed and compiled the dl
	library) by passing --with-sgi-dl=DIRECTORY where DIRECTORY
	is the absolute pathname of the dl library.  (Don't bother on
	IRIX 5, it already has dynamic linking using SunOS style
	shared libraries.)  THIS OPTION IS UNSUPPORTED.

--with-dl-dld: Dynamic loading of modules is rumored to be supported
	on some other systems: VAX (Ultrix), Sun3 (SunOS 3.4), Sequent
	Symmetry (Dynix), and Atari ST.  This is done using a
	combination of the GNU dynamic loading package
	(ftp://ftp.cwi.nl/pub/dynload/dl-dld-1.1.tar.Z) and an
	emulation of the SGI dl library mentioned above (the emulation
	can be found at
	ftp://ftp.cwi.nl/pub/dynload/dld-3.2.3.tar.Z).  To
	enable this, ftp and compile both libraries, then call
	configure, passing it the option
	--with-dl-dld=DL_DIRECTORY,DLD_DIRECTORY where DL_DIRECTORY is
	the absolute pathname of the dl emulation library and
	DLD_DIRECTORY is the absolute pathname of the GNU dld library.
	(Don't bother on SunOS 4 or 5, they already have dynamic
	linking using shared libraries.)  THIS OPTION IS UNSUPPORTED.

--with-libm, --with-libc: It is possible to specify alternative
	versions for the Math library (default -lm) and the C library
	(default the empty string) using the options
	--with-libm=STRING and --with-libc=STRING, respectively.  For
	example, if your system requires that you pass -lc_s to the C
	compiler to use the shared C library, you can pass
	--with-libc=-lc_s. These libraries are passed after all other
	libraries, the C library last.

--with-libs='libs': Add 'libs' to the LIBS that the python interpreter
	is linked against.

--with-cxx=<compiler>: Some C++ compilers require that main() is
        compiled with the C++ if there is any C++ code in the application.
        Specifically, g++ on a.out systems may require that to support
        construction of global objects. With this option, the main() function
        of Python will be compiled with <compiler>; use that only if you
        plan to use C++ extension modules, and if your compiler requires
        compilation of main() as a C++ program.


--with-pydebug:  Enable additional debugging code to help track down
	memory management problems.  This allows printing a list of all
	live objects when the interpreter terminates.
	
--with(out)-universal-newlines: enable reading of text files with
	foreign newline convention (default: enabled). In other words,
	any of \r, \n or \r\n is acceptable as end-of-line character.
	If enabled import and execfile will automatically accept any newline
	in files. Python code can open a file with open(file, 'U') to
	read it in universal newline mode. THIS OPTION IS UNSUPPORTED.


Building for multiple architectures (using the VPATH feature)
-------------------------------------------------------------

If your file system is shared between multiple architectures, it
usually is not necessary to make copies of the sources for each
architecture you want to support.  If the make program supports the
VPATH feature, you can create an empty build directory for each
architecture, and in each directory run the configure script (on the
appropriate machine with the appropriate options).  This creates the
necessary subdirectories and the Makefiles therein.  The Makefiles
contain a line VPATH=... which points to a directory containing the
actual sources.  (On SGI systems, use "smake -J1" instead of "make" if
you use VPATH -- don't try gnumake.)

For example, the following is all you need to build a minimal Python
in /usr/tmp/python (assuming ~guido/src/python is the toplevel
directory and you want to build in /usr/tmp/python):

	$ mkdir /usr/tmp/python
	$ cd /usr/tmp/python
	$ ~guido/src/python/configure
	[...]
	$ make
	[...]
	$

Note that configure copies the original Setup file to the build
directory if it finds no Setup file there.  This means that you can
edit the Setup file for each architecture independently.  For this
reason, subsequent changes to the original Setup file are not tracked
automatically, as they might overwrite local changes.  To force a copy
of a changed original Setup file, delete the target Setup file.  (The
makesetup script supports multiple input files, so if you want to be
fancy you can change the rules to create an empty Setup.local if it
doesn't exist and run it with arguments $(srcdir)/Setup Setup.local;
however this assumes that you only need to add modules.)


Building on non-UNIX systems
----------------------------

For Windows (2000/NT/ME/98/95), assuming you have MS VC++ 6.0, the
project files are in PCbuild, the workspace is pcbuild.dsw.  See
PCbuild\readme.txt for detailed instructions.

For other non-Unix Windows compilers, in particular Windows 3.1 and
for OS/2, enter the directory "PC" and read the file "readme.txt".

For the Mac, a separate source distribution will be made available,
for use with the CodeWarrior compiler.  If you are interested in Mac
development, join the PythonMac Special Interest Group
(http://www.python.org/sigs/pythonmac-sig/, or send email to
pythonmac-sig-request@python.org).

Of course, there are also binary distributions available for these
platforms -- see http://www.python.org/.

To port Python to a new non-UNIX system, you will have to fake the
effect of running the configure script manually (for Mac and PC, this
has already been done for you).  A good start is to copy the file
pyconfig.h.in to pyconfig.h and edit the latter to reflect the actual
configuration of your system.  Most symbols must simply be defined as
1 only if the corresponding feature is present and can be left alone
otherwise; however the *_t type symbols must be defined as some
variant of int if they need to be defined at all.

For all platforms, it's important that the build arrange to define the
preprocessor symbol NDEBUG on the compiler command line in a release
build of Python (else assert() calls remain in the code, hurting
release-build performance).  The Unix, Windows and Mac builds already
do this.


Miscellaneous issues
====================

Emacs mode
----------

There's an excellent Emacs editing mode for Python code; see the file
Misc/python-mode.el.  Originally written by the famous Tim Peters, it
is now maintained by the equally famous Barry Warsaw (it's no
coincidence that they now both work on the same team).  The latest
version, along with various other contributed Python-related Emacs
goodies, is online at http://www.python.org/emacs/python-mode.  And
if you are planning to edit the Python C code, please pick up the
latest version of CC Mode http://www.python.org/emacs/cc-mode; it
contains a "python" style used throughout most of the Python C source
files.  (Newer versions of Emacs or XEmacs may already come with the
latest version of python-mode.)


Tkinter
-------

The setup.py script automatically configures this when it detects a
usable Tcl/Tk installation.  This requires Tcl/Tk version 8.0 or
higher.

For more Tkinter information, see the Tkinter Resource page:
http://www.python.org/topics/tkinter/

There are demos in the Demo/tkinter directory, in the subdirectories
guido, matt and www (the matt and guido subdirectories have been
overhauled to use more recent Tkinter coding conventions).

Note that there's a Python module called "Tkinter" (capital T) which
lives in Lib/lib-tk/Tkinter.py, and a C module called "_tkinter"
(lower case t and leading underscore) which lives in
Modules/_tkinter.c.  Demos and normal Tk applications import only the
Python Tkinter module -- only the latter imports the C _tkinter
module.  In order to find the C _tkinter module, it must be compiled
and linked into the Python interpreter -- the setup.py script does
this.  In order to find the Python Tkinter module, sys.path must be
set correctly -- normal installation takes care of this.


Distribution structure
----------------------

Most subdirectories have their own README files.  Most files have
comments.

.cvsignore	Additional filename matching patterns for CVS to ignore
BeOS/		Files specific to the BeOS port
Demo/           Demonstration scripts, modules and programs
Doc/		Documentation sources (LaTeX)
Grammar/        Input for the parser generator
Include/        Public header files
LICENSE		Licensing information
Lib/            Python library modules
Mac/            Macintosh specific resources
Makefile.pre.in Source from which config.status creates the Makefile.pre
Misc/           Miscellaneous useful files
Modules/        Implementation of most built-in modules
Objects/        Implementation of most built-in object types
PC/             Files specific to PC ports (DOS, Windows, OS/2)
PCbuild/	Build directory for Microsoft Visual C++
Parser/         The parser and tokenizer and their input handling
Python/         The byte-compiler and interpreter
README          The file you're reading now
Tools/          Some useful programs written in Python
pyconfig.h.in   Source from which pyconfig.h is created (GNU autoheader output)
configure       Configuration shell script (GNU autoconf output)
configure.in    Configuration specification (input for GNU autoconf)
install-sh      Shell script used to install files

The following files will (may) be created in the toplevel directory by
the configuration and build processes:

Makefile        Build rules
Makefile.pre    Build rules before running Modules/makesetup
buildno         Keeps track of the build number
config.cache    Cache of configuration variables
pyconfig.h      Configuration header
config.log      Log from last configure run
config.status   Status from last run of the configure script
getbuildinfo.o	Object file from Modules/getbuildinfo.c
libpython<version>.a	The library archive
python          The executable interpreter
tags, TAGS      Tags files for vi and Emacs


That's all, folks!
------------------


--Guido van Rossum (home page: http://www.python.org/~guido/)
