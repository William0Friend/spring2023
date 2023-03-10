#============================================================= -*-Perl-*-
#
# Pod::POM::Node
#
# DESCRIPTION
#   Base class for a node in a Pod::POM tree.
#
# AUTHOR
#   Andy Wardley   <abw@kfs.org>
#
# COPYRIGHT
#   Copyright (C) 2000, 2001 Andy Wardley.  All Rights Reserved.
#
#   This module is free software; you can redistribute it and/or
#   modify it under the same terms as Perl itself.
#
# REVISION
#   $Id: Node.pm,v 1.3 2002/02/06 16:45:23 abw Exp $
#
#========================================================================

package Pod::POM::Node;

require 5.004;

use strict;
use Pod::POM::Nodes;
use Pod::POM::Constants qw( :status );
use vars qw( $VERSION $DEBUG $ERROR $NODES $NAMES $AUTOLOAD );

$VERSION = sprintf("%d.%02d", q$Revision: 1.3 $ =~ /(\d+)\.(\d+)/);
$DEBUG   = 0 unless defined $DEBUG;
$NODES   = {
    pod      => 'Pod::POM::Node::Pod',
    head1    => 'Pod::POM::Node::Head1',
    head2    => 'Pod::POM::Node::Head2',
    head3    => 'Pod::POM::Node::Head3',
    head4    => 'Pod::POM::Node::Head4',
    over     => 'Pod::POM::Node::Over',
    item     => 'Pod::POM::Node::Item',
    begin    => 'Pod::POM::Node::Begin',
    for      => 'Pod::POM::Node::For',
    text     => 'Pod::POM::Node::Text',
    code     => 'Pod::POM::Node::Code',
    verbatim => 'Pod::POM::Node::Verbatim',
};
$NAMES = {
    map { ( $NODES->{ $_ } => $_ ) } keys %$NODES,
};

# overload stringification to present node via a view
use overload '""' => 'present';

# alias meta() to metadata()
*meta = \*metadata;


#------------------------------------------------------------------------
# new($pom, @attr)
# 
# Constructor method.  Returns a new Pod::POM::Node::* object or undef
# on error.  First argument is the Pod::POM parser object, remaining 
# arguments are node attributes as specified in %ATTRIBS in derived class
# package.
#------------------------------------------------------------------------

sub new {
    my $class = shift;
    my $pom   = shift;
    my ($type, $attribs, $accept, $key, $value, $default);

    $type = $NAMES->{ $class };

    {
	no strict qw( refs );
        $attribs = \%{"$class\::ATTRIBS"} || [ ];
	$accept  = \@{"$class\::ACCEPT"}  || [ ];
	unless (defined (%{"$class\::ACCEPT"})) {
	    %{"$class\::ACCEPT"} = ( 
		map { ( $_ => $NODES->{ $_ } ) } @$accept,
	    );
	}
    }

    # create object with slots for each acceptable child and overall content
    my $self = bless {
	type      => $type,
	content   => bless([ ], 'Pod::POM::Node::Content'),
	map { ($_ => bless([ ], 'Pod::POM::Node::Content')) } 
	      (@$accept, 'code'),
    }, $class;

    # set attributes from arguments
    keys %$attribs;	    # reset hash iterator
    while(my ($key, $default) = each %$attribs) {
	$value = shift || $default;
	return $class->error("$type expected a $key")
	    unless $value;
	$self->{ $key } = $value;
    }

    return $self;
}


#------------------------------------------------------------------------
# add($pom, $type, @attr)
#
# Adds a new node as a child element (content) of the current node.
# First argument is the Pod::POM parser object.  Second argument is the
# child node type specified by name (e.g. 'head1') which is mapped via
# the $NODES hash to a class name against which new() can be called.
# Remaining arguments are attributes passed to the child node constructor.
# Returns a reference to the new node (child was accepted) or one of the 
# constants REDUCE (child terminated node, e.g. '=back' terminates an
# '=over' node), REJECT (child rejected, e.g. '=back' expected to terminate
# '=over' but something else found instead) or IGNORE (node didn't expect
# child and is implicitly terminated).
#------------------------------------------------------------------------

sub add {
    my $self  = shift;
    my $pom   = shift;
    my $type  = shift;
    my $class = ref $self;
    my ($name, $attribs, $accept, $expect, $nodeclass, $node);

    $name = $NAMES->{ $class }
	|| return $self->error("no name for $class");
    {
	no strict qw( refs );
	$accept  = \%{"$class\::ACCEPT"};
	$expect  =  ${"$class\::EXPECT"};
    }

    # SHIFT: accept indicates child nodes that can be accepted; a
    # new node is created, added it to content list and node specific
    # list, then returned by reference.

    if ($nodeclass = $accept->{ $type }) {
	defined($node = $nodeclass->new($pom, @_))
	    || return $self->error($nodeclass->error())
	    unless defined $node;
	push(@{ $self->{ $type   } }, $node);
	push(@{ $self->{ content } }, $node);
	return $node;
    }

    # REDUCE: expect indicates the token that should terminate this node
    if (defined $expect && ($type eq $expect)) {
	DEBUG("$name terminated by expected $type\n");
	return REDUCE;
    }

    # REJECT: expected terminating node was not found
    if (defined $expect) {
	DEBUG("$name rejecting $type, expecting a terminating $expect\n");
	$self->error("$name expected a terminating $expect");
	return REJECT;
    }

    # IGNORE: don't know anything about this node
    DEBUG("$name ignoring $type\n");
    return IGNORE;
}


#------------------------------------------------------------------------
# present($view)
#
# Present the node by making a callback on the appropriate method against 
# the view object passed as an argument.  $Pod::POM::DEFAULT_VIEW is used
# if $view is unspecified.
#------------------------------------------------------------------------

sub present {
    my ($self, $view, @args) = @_;
    $view    ||= $Pod::POM::DEFAULT_VIEW;
    my $type   = $self->{ type };
    my $method = "view_$type";
    DEBUG("presenting method $method\n");
    return $view->$method($self, @args);
}


#------------------------------------------------------------------------
# metadata()
# metadata($key)
# metadata($key, $value)
#
# Returns the metadata hash when called without any arguments.  Returns
# the value of a metadata item when called with a single argument.  
# Sets a metadata item to a value when called with two arguments.
#------------------------------------------------------------------------

sub metadata {
    my ($self, $key, $value) = @_;
    my $metadata = $self->{ METADATA } ||= { };

    return $metadata unless defined $key;

    if (defined $value) {
	$metadata->{ $key } = $value;
    }
    else {
	$value = $self->{ METADATA }->{ $key };
	return defined $value ? $value 
	    : $self->error("no such metadata item: $key");
    }
}


#------------------------------------------------------------------------
# error()
# error($msg, ...)
# 
# May be called as a class or object method to set or retrieve the 
# package variable $ERROR (class method) or internal member 
# $self->{ _ERROR } (object method).  The presence of parameters indicates
# that the error value should be set.  Undef is then returned.  In the
# abscence of parameters, the current error value is returned.
#------------------------------------------------------------------------

sub error {
    my $self = shift;
    my $errvar;
#   use Carp;

    { 
	no strict qw( refs );
	if (ref $self) {
#	    my ($pkg, $file, $line) = caller();
#	    print STDERR "called from $file line $line\n";
#	    croak "cannot get/set error in non-hash: $self\n"
#		unless UNIVERSAL::isa($self, 'HASH');
	    $errvar = \$self->{ ERROR };
	}
	else {
	    $errvar = \${"$self\::ERROR"};
	}
    }
    if (@_) {
	$$errvar = ref($_[0]) ? shift : join('', @_);
	return undef;
    }
    else {
	return $$errvar;
    }
}


#------------------------------------------------------------------------
# AUTOLOAD
#------------------------------------------------------------------------

sub AUTOLOAD {
    my $self = shift;
    my $name = $AUTOLOAD;
    my $item;

    $name =~ s/.*:://;
    return if $name eq 'DESTROY';

#    my ($pkg, $file, $line) = caller();
#    print STDERR "called from $file line $line to return ", ref($item), "\n";

    return $self->error("can't manipulate \$self")
	unless UNIVERSAL::isa($self, 'HASH');
    return $self->error("no such member: $name")
	unless defined ($item = $self->{ $name });

    return wantarray ? ( UNIVERSAL::isa($item, 'ARRAY') ? @$item : $item ) 
		     : $item;
}


#------------------------------------------------------------------------
# DEBUG(@msg)
#------------------------------------------------------------------------

sub DEBUG {
    print STDERR "DEBUG: ", @_ if $DEBUG;
}

1;



=head1 NAME

Pod::POM::Node - base class for a POM node

=head1 SYNOPSIS

    package Pod::POM::Node::Over;
    use base qw( Pod::POM::Node );
    use vars qw( %ATTRIBS @ACCEPT $EXPECT $ERROR );

    %ATTRIBS =   ( indent => 4 );
    @ACCEPT  = qw( over item begin for text verbatim );
    $EXPECT  =  q( back );

    package main;
    my $list = Pod::POM::Node::Over->new(8);
    $list->add('item', 'First Item');
    $list->add('item', 'Second Item');
    ...

=head1 DESCRIPTION

This documentation describes the inner workings of the Pod::POM::Node
module and gives a brief overview of the relationship between it and
its derived classes.  It is intended more as a guide to the internals
for interested hackers than as general user documentation.  See 
L<Pod::POM> for information on using the modules.

This module implements a base class node which is subclassed to
represent different elements within a Pod Object Model. 

    package Pod::POM::Node::Over;
    use base qw( Pod::POM::Node );

The base class implements the new() constructor method to instantiate 
new node objects.  

    my $list = Pod::POM::Node::Over->new();

The characteristics of a node can be specified by defining certain
variables in the derived class package.  The C<%ATTRIBS> hash can be
used to denote attributes that the node should accept.  In the case of
an C<=over> node, for example, an C<indent> attribute can be specified
which otherwise defaults to 4.

    package Pod::POM::Node::Over;
    use base qw( Pod::POM::Node );
    use vars qw( %ATTRIBS $ERROR );

    %ATTRIBS = ( indent => 4 );

The new() method will now expect an argument to set the indent value, 
or will use 4 as the default if no argument is provided.

    my $list = Pod::POM::Node::Over->new(8);	# indent: 8
    my $list = Pod::POM::Node::Over->new( );	# indent: 4

If the default value is undefined then the argument is mandatory.

    package Pod::POM::Node::Head1;
    use base qw( Pod::POM::Node );
    use vars qw( %ATTRIBS $ERROR );

    %ATTRIBS = ( title => undef );

    package main;
    my $head = Pod::POM::Node::Head1->new('My Title');

If a mandatory argument isn't provided then the constructor will
return undef to indicate failure.  The $ERROR variable in the derived
class package is set to contain a string of the form "$type expected a
$attribute".

    # dies with error: "head1 expected a title"
    my $head = Pod::POM::Node::Head1->new()
	|| die $Pod::POM::Node::Head1::ERROR;

For convenience, the error() subroutine can be called as a class
method to retrieve this value.

    my $type = 'Pod::POM::Node::Head1';
    my $head = $type->new()
	|| die $type->error();

The C<@ACCEPT> package variable can be used to indicate the node types
that are permitted as children of a node.

    package Pod::POM::Node::Head1;
    use base qw( Pod::POM::Node );
    use vars qw( %ATTRIBS @ACCEPT $ERROR );

    %ATTRIBS =   ( title => undef );
    @ACCEPT  = qw( head2 over begin for text verbatim );

The add() method can then be called against a node to add a new child
node as part of its content.

    $head->add('over', 8);

The first argument indicates the node type.  The C<@ACCEPT> list is
examined to ensure that the child node type is acceptable for the
parent node.  If valid, the constructor for the relevant child node
class is called passing any remaining arguments as attributes.  The 
new node is then returned.

    my $list = $head->add('over', 8);

The error() method can be called against the I<parent> node to retrieve
any constructor error generated by the I<child> node.

    my $list = $head->add('over', 8);
    die $head->error() unless defined $list;

If the child node is not acceptable to the parent then the add()
method returns one of the constants IGNORE, REDUCE or REJECT, as
defined in Pod::POM::Constants.  These return values are used by the
Pod::POM parser module to implement a simple shift/reduce parser.  

In the most common case, IGNORE is returned to indicate that the
parent node doesn't know anything about the new child node.  The 
parser uses this as an indication that it should back up through the
parse stack until it finds a node which I<will> accept this child node.
Through this mechanism, the parser is able to implicitly terminate
certain POD blocks.  For example, a list item initiated by a C<=item>
tag will I<not> accept another C<=item> tag, but will instead return IGNORE.
The parser will back out until it finds the enclosing C<=over> node 
which I<will> accept it.  Thus, a new C<=item> implicitly terminates any
previous C<=item>.

The C<$EXPECT> package variable can be used to indicate a node type
which a parent expects to terminate itself.  An C<=over> node, for 
example, should always be terminated by a matching C<=back>.  When 
such a match is made, the add() method returns REDUCE to indicate 
successful termination.

    package Pod::POM::Node::Over;
    use base qw( Pod::POM::Node );
    use vars qw( %ATTRIBS @ACCEPT $EXPECT $ERROR );

    %ATTRIBS =   ( indent => 4 );
    @ACCEPT  = qw( over item begin for text verbatim );
    $EXPECT  =  q( back );

    package main;
    my $list = Pod::POM::Node::Over->new();
    my $item = $list->add('item');
    $list->add('back');			# returns REDUCE

If a child node isn't specified in the C<@ACCEPT> list or doesn't match 
any C<$EXPECT> specified then REJECT is returned.  The parent node sets
an internal error of the form "$type expected a terminating $expect".
The parser uses this to detect missing POD tags.  In nearly all cases
the parser is smart enough to fix the incorrect structure and downgrades
any errors to warnings.

    # dies with error 'over expected terminating back'
    ref $list->add('head1', 'My Title')	    # returns REJECT
        || die $list->error();

Each node contains a 'type' field which contains a simple string
indicating the node type, e.g. 'head1', 'over', etc.  The $NODES and
$NAMES package variables (in the base class) reference hash arrays
which map these names to and from package names (e.g. head1 E<lt>=E<gt>
Pod::POM::Node::Head1).  

    print $list->{ type };	# 'over'

An AUTOLOAD method is provided to access to such internal items for
those who don't like violating an object's encapsulation.

    print $list->type();

Nodes also contain a 'content' list, blessed into the
Pod::POM::Node::Content class, which contains the content (child
elements) for the node.  The AUTOLOAD method returns this as a list
reference or as a list of items depending on the context in which it
is called.

    my $items = $list->content();
    my @items = $list->content();

Each node also contains a content list for each individual child node
type that it may accept.

    my @items = $list->item();
    my @text  = $list->text();
    my @vtext = $list->verbatim();

The present() method is used to present a node through a particular view.
This simply maps the node type to a method which is then called against the 
view object.  This is known as 'double dispatch'.

    my $view = 'Pod::POM::View::HTML';
    print $list->present($view);

The method name is constructed from the node type prefixed by 'view_'.  
Thus the following are roughly equivalent.

    $list->present($view);

    $view->view_list($list);

The benefit of the former over the latter is, of course, that the
caller doesn't need to know or determine the type of the node.  The 
node itself is in the best position to determine what type it is.

=head1 AUTHOR

Andy Wardley E<lt>abw@kfs.orgE<gt>

=head1 COPYRIGHT

Copyright (C) 2000, 2001 Andy Wardley.  All Rights Reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

Consult L<Pod::POM> for a general overview and examples of use.

