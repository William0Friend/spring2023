package Apache::TestConfig; #not TestConfigC on purpose

use strict;
use warnings FATAL => 'all';

use Config;
use Apache::TestConfig ();
use Apache::TestConfigPerl ();
use Apache::TestTrace;
use File::Find qw(finddepth);

sub cmodule_find {
    my($self, $mod) = @_;

    return unless $mod =~ /^mod_(\w+)\.c$/;
    my $sym = $1;

    my $dir = $File::Find::dir;
    my $file = catfile $dir, $mod;

    unless ($self->{APXS}) {
        $self->{cmodules_disabled}->{$mod} = "no apxs configured";
        return;
    }

    my $fh = Symbol::gensym();
    open $fh, $file or die "open $file: $!";
    my $v = <$fh>;
    if ($v =~ /^\#define\s+HTTPD_TEST_REQUIRE_APACHE\s+(\d+)/) {
        unless ($self->{server}->{rev} == $1) {
            my $reason = "requires Apache version $1";
            $self->{cmodules_disabled}->{$mod} = $reason;
            notice "$mod $reason, skipping.";
            return;
        }
    }
    close $fh;

    push @{ $self->{cmodules} }, {
        name => "mod_$sym",
        sym => "${sym}_module",
        dir  => $dir,
        subdir => basename $dir,
    };
}

sub cmodules_configure {
    my($self, $dir) = @_;

    $self->{cmodules_disabled} = {}; #for have_module to check

    $dir ||= catfile $self->{vars}->{top_dir}, 'c-modules';

    unless (-d $dir) {
        return;
    }

    $self->{cmodules_dir} = $dir;

    finddepth(sub { cmodule_find($self, $_) }, $dir);

    unless ($self->{APXS}) {
        warning "cannot build c-modules without apxs";
        return;
    }

    $self->cmodules_generate_include;
    $self->cmodules_write_makefiles;
    $self->cmodules_compile;
    $self->cmodules_httpd_conf;
}

sub cmodules_makefile_vars {
    return <<EOF;
MAKE = $Config{make}
EOF
}

my %lib_dir = (1 => "", 2 => ".libs/");

sub cmodules_build_so {
    my($self, $name) = @_;
    $name = "mod_$name" unless $name =~ /^mod_/;
    my $libdir = $self->server->version_of(\%lib_dir);
    my $lib = "$libdir$name.so";
}

sub cmodules_write_makefiles {
    my $self = shift;

    my $modules = $self->{cmodules};

    for (@$modules) {
        $self->cmodules_write_makefile($_);
    }

    my $file = catfile $self->{cmodules_dir}, 'Makefile';
    my $fh = Symbol::gensym();
    open $fh, ">$file" or die "open $file: $!";

    print $fh $self->cmodules_makefile_vars;

    my @dirs = map { $_->{subdir} } @$modules;

    my @targets = qw(clean);
    my @libs;

    for my $dir (@dirs) {
        for my $targ (@targets) {
            print $fh "$dir-$targ:\n\t-cd $dir && \$(MAKE) $targ\n\n";
        }

        my $lib = $self->cmodules_build_so($dir);
        my $cfile = "$dir/mod_$dir.c";
        push @libs, "$dir/$lib";
        print $fh "$libs[-1]: $cfile\n\t-cd $dir && \$(MAKE) $lib\n\n";
    }

    for my $targ (@targets) {
        print $fh "$targ: ", (map { "$_-$targ " } @dirs), "\n\n";
    }

    print $fh "all: @libs\n\n";

    close $fh or die "close $file: $!";
}

sub cmodules_write_makefile {
    my($self, $mod) = @_;

    my $dversion = $self->server->dversion;
    my $name = $mod->{name};
    my $makefile = "$mod->{dir}/Makefile";
    debug "writing $makefile";

    my $lib = $self->cmodules_build_so($name);

    my $fh = Symbol::gensym();
    open $fh, ">$makefile" or die "open $makefile: $!";

    print $fh <<EOF;
APXS=$self->{APXS}
all: $lib

$lib: $name.c
	\$(APXS) $dversion -I$self->{cmodules_dir} -c $name.c

clean:
	-rm -rf $name.o $name.lo $name.slo $name.la .libs
EOF

    close $fh or die "close $makefile: $!";
}

sub cmodules_make {
    my $self = shift;
    my $targ = shift || 'all';

    my $cmd = "cd $self->{cmodules_dir} && $Config{make} $targ";
    debug $cmd;
    system $cmd;
}

sub cmodules_compile {
    shift->cmodules_make('all');
}

sub cmodules_httpd_conf {
    my $self = shift;

    my @args;

    for my $mod (@{ $self->{cmodules} }) {
        my $dir = $mod->{dir};
        my $lib = $self->cmodules_build_so($mod->{name});
        my $so  = "$dir/$lib";

        next unless -e $so;

        $self->preamble(LoadModule => "$mod->{sym} $so");

        my $cname = "$mod->{name}.c";
        my $cfile = "$dir/$cname";
        $self->{modules}->{$cname} = 1;

        $self->add_module_config($cfile, \@args);
    }

    $self->postamble(\@args) if @args;
}

sub cmodules_clean {
    my $self = shift;

    my $dir = $self->{cmodules_dir};
    return unless $dir and -e "$dir/Makefile";

    unless ($self->{clean_level} > 1) {
        #skip t/TEST -conf
        warning "skipping rebuild of c-modules; run t/TEST -clean to force";
        return;
    }

    $self->cmodules_make('clean');

    for my $mod (@{ $self->{cmodules} }) {
        my $makefile = "$mod->{dir}/Makefile";
        debug "unlink $makefile";
        unlink $makefile;
    }

    unlink "$dir/Makefile";
}

#try making it easier for test modules to compile with both 1.x and 2.x
sub cmodule_define_name {
    my $name = shift;
    $name eq 'NULL' ? $name : "APACHE_HTTPD_TEST_\U$name";
}

sub cmodule_define {
    my $hook = cmodule_define_name(@_);
    "#ifndef $hook\n#define $hook NULL\n#endif\n";
}

my @cmodule_config_names = qw(per_dir_create per_dir_merge
                              per_srv_create per_srv_merge
                              commands);

my @cmodule_config_defines = map {
    cmodule_define($_);
} @cmodule_config_names;

my $cmodule_config_hooks = join ",\n    ", map {
    cmodule_define_name($_);
} @cmodule_config_names;

my @cmodule_phases = qw(post_read_request translate_name header_parser
                        access_checker check_user_id auth_checker
                        type_checker fixups handler log_transaction
                        child_init);

my $cmodule_hooks_1 = join ",\n    ", map {
    cmodule_define_name($_);
} qw(translate_name check_user_id auth_checker access_checker
     type_checker fixups log_transaction header_parser
     child_init NULL post_read_request);

my $cmodule_template_1 = <<"EOF",
static const handler_rec name ## _handlers[] =
{
    {#name, APACHE_HTTPD_TEST_HANDLER}, /* ok if handler is NULL */
    {NULL}
};

module MODULE_VAR_EXPORT name ## _module =
{
    STANDARD_MODULE_STUFF,
    NULL,			/* initializer */
    $cmodule_config_hooks,
    name ## _handlers,	        /* handlers */
    $cmodule_hooks_1
}
EOF

my @cmodule_hooks = map {
    my $hook = cmodule_define_name($_);
    <<EOF;
    if ($hook != NULL)
        ap_hook_$_($hook,
                   NULL, NULL,
                   APACHE_HTTPD_TEST_HOOK_ORDER);
EOF
} @cmodule_phases;

my @cmodule_hook_defines = map {
    cmodule_define($_);
} @cmodule_phases;

my $cmodule_template_2 = <<"EOF";
static void name ## _register_hooks(apr_pool_t *p)
{
@cmodule_hooks
}

module AP_MODULE_DECLARE_DATA name ## _module = {
    STANDARD20_MODULE_STUFF,
    $cmodule_config_hooks,
    name ## _register_hooks, /* register hooks */
}
EOF

my %cmodule_templates = (1 => $cmodule_template_1, 2 => $cmodule_template_2);

sub cmodules_module_template {
    my $self = shift;
    my $template = $self->server->version_of(\%cmodule_templates);
    chomp $template;

    $template =~ s,$, \\,mg;
    $template =~ s, \\$,,s;

    local $" = ', ';

    return <<EOF;
#define APACHE_HTTPD_TEST_MODULE(name) \\
    $template
EOF
}

sub cmodules_generate_include {
    my $self = shift;

    my $file = "$self->{cmodules_dir}/apache_httpd_test.h";
    my $fh = $self->genfile($file);

    while (read Apache::TestConfigC::DATA, my $buf, 1024) {
        print $fh $buf;
    }

    print $fh @cmodule_hook_defines, @cmodule_config_defines;

    print $fh $self->cmodules_module_template;

    close $fh;
}

package Apache::TestConfigC; #Apache/TestConfig.pm also has __DATA__
1;
__DATA__
#ifndef APACHE_HTTPD_TEST_H
#define APACHE_HTTPD_TEST_H

/* headers present in both 1.x and 2.x */
#include "httpd.h"
#include "http_config.h"
#include "http_protocol.h"
#include "http_request.h"
#include "http_log.h"
#include "http_main.h"
#include "http_core.h"
#include "ap_config.h"

#ifdef APACHE1
#define AP_METHOD_BIT  1
typedef size_t apr_size_t;
typedef array_header apr_array_header_t;
#endif /* APACHE1 */

#ifdef APACHE2
#ifndef APACHE_HTTPD_TEST_HOOK_ORDER
#define APACHE_HTTPD_TEST_HOOK_ORDER APR_HOOK_MIDDLE
#endif
#include "ap_compat.h"
#endif /* APACHE2 */

#endif /* APACHE_HTTPD_TEST_H */

