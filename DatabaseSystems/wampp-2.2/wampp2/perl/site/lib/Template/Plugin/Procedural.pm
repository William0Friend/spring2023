#==============================================================================
# 
# Template::Plugin::Procedural
#
# DESCRIPTION
#
# A Template Plugin to provide a Template Interface to Data::Dumper
#
# AUTHOR
#   Mark Fowler <mark@twoshortplanks.com>
#
# COPYRIGHT
#
#   Copyright (C) 2002 Mark Fowler.  All Rights Reserved
#
#   This module is free software; you can redistribute it and/or
#   modify it under the same terms as Perl itself.
#
#------------------------------------------------------------------------------
#
# $Id: Procedural.pm,v 1.3 2002/11/04 19:47:14 abw Exp $
# 
#==============================================================================

package Template::Plugin::Procedural;

require 5.004;

use strict;

use vars qw( $VERSION $DEBUG $AUTOLOAD );
use base qw( Template::Plugin );

$VERSION = sprintf("%d.%02d", q$Revision: 1.3 $ =~ /(\d+)\.(\d+)/);
$DEBUG   = 0 unless defined $DEBUG;

#------------------------------------------------------------------------
# load
#------------------------------------------------------------------------

sub load
{
  my ($class, $context) = @_;

  # create a proxy namespace that will be used for objects
  my $proxy = "Template::Plugin::" . $class;

  # okay, in our proxy create the autoload routine that will
  # call the right method in the real class
  no strict "refs";
  *{ $proxy . "::AUTOLOAD" } =
    sub
    {
      # work out what the method is called
      $AUTOLOAD =~ s!^.*::!!;

      print STDERR "Calling '$AUTOLOAD' in '$class'\n"
	if $DEBUG;

      # look up the sub for that method (but in a OO way)
      my $uboat = $class->can($AUTOLOAD);

      # if it existed call it as a subroutine, not as a method
      if ($uboat)
      {
	shift @_;
	return $uboat->(@_);
      }

      print STDERR "Eeek, no such method '$AUTOLOAD'\n"
	if $DEBUG;

      return "";
    };

  # create a simple new method that simply returns a blessed
  # scalar as the object.
  *{ $proxy . "::new" } =
    sub
    {
      my $this;
      return bless \$this, $_[0];
    };

  return $proxy;
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

Template::Plugin::Procedural - Base class for procedural plugins

=head1 SYNOPSIS

    package Template::Plugin::LWPSimple;
    use base qw(Template::Plugin::Procedural);
    use LWP::Simple;  # exports 'get'
    1;

    [% USE LWPSimple %]
    [% LWPSimple.get("http://www.tt2.org/") %]

=head1 DESCRIPTION

B<Template::Plugin::Procedural> is a base class for Template Toolkit
plugins that causes defined subroutines to be called directly rather
than as a method.  Essentially this means that subroutines will not
receive the class name or object as its first argument.

This is most useful when creating plugins for modules that normally
work by exporting subroutines that do not expect such additional
arguments.

Despite the fact that subroutines will not be called in an OO manner,
inheritance still function as normal.  A class that uses
B<Template::Plugin::Procedural> can be subclassed and both subroutines
defined in the subclass and subroutines defined in the original class
will be available to the Template Toolkit and will be called without
the class/object argument.

=head1 AUTHOR

Mark Fowler E<lt>mark@twoshortplanks.comE<gt>

L<http://www.twoshortplanks.com|http://www.twoshortplanks.com>




=head1 VERSION

1.03, distributed as part of the
Template Toolkit version 2.09, released on 23 April 2003.

=head1 COPYRIGHT


Copyright (C) 2002 Mark Fowler E<lt>mark@twoshortplanks.comE<gt>

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Template|Template>, L<Template::Plugin|Template::Plugin>