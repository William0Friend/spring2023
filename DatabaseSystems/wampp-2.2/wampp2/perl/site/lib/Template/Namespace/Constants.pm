#================================================================= -*-Perl-*- 
#
# Template::Namespace::Constants
#
# DESCRIPTION
#   Plugin compiler module for performing constant folding at compile time
#   on variables in a particular namespace.
#
# AUTHOR
#   Andy Wardley   <abw@andywardley.com>
#
# COPYRIGHT
#   Copyright (C) 1996-2002 Andy Wardley.  All Rights Reserved.
#   Copyright (C) 1998-2002 Canon Research Centre Europe Ltd.
#
#   This module is free software; you can redistribute it and/or
#   modify it under the same terms as Perl itself.
#
# REVISION
#   $Id: Constants.pm,v 1.14 2002/11/04 19:46:52 abw Exp $
#
#============================================================================

package Template::Namespace::Constants;

use strict;
use Template::Base;
use Template::Config;
use Template::Directive;
use Template::Exception;

use base qw( Template::Base );
use vars qw( $VERSION $DEBUG );

$VERSION = sprintf("%d.%02d", q$Revision: 1.14 $ =~ /(\d+)\.(\d+)/);
$DEBUG   = 0 unless defined $DEBUG;


sub _init {
    my ($self, $config) = @_;
    $self->{ STASH } = Template::Config->stash($config)
	|| return $self->error(Template::Config->error());
    return $self;
}



#------------------------------------------------------------------------
# ident(\@ident)                                             foo.bar(baz)
#------------------------------------------------------------------------

sub ident {
    my ($self, $ident) = @_;
    my @save = @$ident;

    # discard first node indicating constants namespace
    splice(@$ident, 0, 2);

    my $nelems = @$ident / 2;
    my ($e, $result);
    local $" = ', ';

    print STDERR "constant ident [ @$ident ] " if $DEBUG;

    foreach $e (0..$nelems-1) {
	# node name must be a constant
	unless ($ident->[$e * 2] =~ s/^'(.+)'$/$1/s) {
	    $self->DEBUG(" * deferred (non-constant item: ", $ident->[$e * 2], ")\n")
		if $DEBUG;
	    return Template::Directive->ident(\@save);
	}

	# if args is non-zero then it must be eval'ed 
	if ($ident->[$e * 2 + 1]) {
	    my $args = $ident->[$e * 2 + 1];
	    my $comp = eval "$args";
	    if ($@) {
		$self->DEBUG(" * deferred (non-constant args: $args)\n") if $DEBUG;
		return Template::Directive->ident(\@save);
	    }
	    $self->DEBUG("($args) ") if $comp && $DEBUG;
	    $ident->[$e * 2 + 1] = $comp;
	}
    }


    $result = $self->{ STASH }->get($ident);

    if (! length $result || ref $result) {
	my $reason = length $result ? 'reference' : 'no result';
	$self->DEBUG(" * deferred ($reason)\n") if $DEBUG;
	return Template::Directive->ident(\@save);
    }

    $result =~ s/'/\\'/g;

    $self->DEBUG(" * resolved => '$result'\n") if $DEBUG;

    return "'$result'";
}

1;

__END__


#------------------------------------------------------------------------
# IMPORTANT NOTE
#   This documentation is generated automatically from source
#   templates.  Any changes you make here may be lost.
# 
#   The 'docsrc' documentation source bundle is available for download
#   from http://www.template-toolkit.org/docs.html and contains all
#   the source templates, XML files, scripts, etc., from which the
#   documentation for the Template Toolkit is built.
#------------------------------------------------------------------------

=head1 NAME

Template::Namespace::Constants - Compile time constant folding

=head1 SYNOPSIS

    # easy way to define constants
    use Template;

    my $tt = Template->new({
	CONSTANTS => {
	    pi => 3.14,
	    e  => 2.718,
	},
    });

    # nitty-gritty, hands-dirty way
    use Template::Namespace::Constants;

    my $tt = Template->new({
	NAMESPACE => {
	    constants => Template::Namespace::Constants->new({
		pi => 3.14,
	        e  => 2.718,
            },
	},
    });

=head1 DESCRIPTION

The Template::Namespace::Constants module implements a namespace handler
which is plugged into the Template::Directive compiler module.  This then
performs compile time constant folding of variables in a particular namespace.

=head1 PUBLIC METHODS

=head2 new(\%constants)

The new() constructor method creates and returns a reference to a new
Template::Namespace::Constants object.  This creates an internal stash
to store the constant variable definitions passed as arguments.

    my $handler = Template::Namespace::Constants->new({
	pi => 3.14,
	e  => 2.718,
    });

=head2 ident(\@ident)

Method called to resolve a variable identifier into a compiled form.  In this
case, the method fetches the corresponding constant value from its internal
stash and returns it.

=head1 AUTHOR

Andy Wardley E<lt>abw@andywardley.comE<gt>

L<http://www.andywardley.com/|http://www.andywardley.com/>




=head1 VERSION

1.14, distributed as part of the
Template Toolkit version 2.09, released on 23 April 2003.

=head1 COPYRIGHT

  Copyright (C) 1996-2002 Andy Wardley.  All Rights Reserved.
  Copyright (C) 1998-2002 Canon Research Centre Europe Ltd.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Template::Directive|Template::Directive>