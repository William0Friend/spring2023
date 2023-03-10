package File::Spec::OS2;

use strict;
use vars qw(@ISA $VERSION);
require File::Spec::Unix;

$VERSION = '1.1';

@ISA = qw(File::Spec::Unix);

sub devnull {
    return "/dev/nul";
}

sub case_tolerant {
    return 1;
}

sub file_name_is_absolute {
    my ($self,$file) = @_;
    return scalar($file =~ m{^([a-z]:)?[\\/]}is);
}

sub path {
    my $path = $ENV{PATH};
    $path =~ s:\\:/:g;
    my @path = split(';',$path);
    foreach (@path) { $_ = '.' if $_ eq '' }
    return @path;
}

my $tmpdir;
sub tmpdir {
    return $tmpdir if defined $tmpdir;
    my $self = shift;
    my @dirlist = ( @ENV{qw(TMPDIR TEMP TMP)}, qw(/tmp /) );
    {
	no strict 'refs';
	if (${"\cTAINT"}) { # Check for taint mode on perl >= 5.8.0
	    require Scalar::Util;
	    @dirlist = grep { ! Scalar::Util::tainted $_ } @dirlist;
	}
    }
    foreach (@dirlist) {
	next unless defined && -d;
	$tmpdir = $_;
	last;
    }
    $tmpdir = '' unless defined $tmpdir;
    $tmpdir =~ s:\\:/:g;
    $tmpdir = $self->canonpath($tmpdir);
    return $tmpdir;
}

=item canonpath

No physical check on the filesystem, but a logical cleanup of a
path. On UNIX eliminated successive slashes and successive "/.".

=cut

sub canonpath {
    my ($self,$path) = @_;
    $path =~ s/^([a-z]:)/\l$1/s;
    $path =~ s|\\|/|g;
    $path =~ s|([^/])/+|$1/|g;                  # xx////xx  -> xx/xx
    $path =~ s|(/\.)+/|/|g;                     # xx/././xx -> xx/xx
    $path =~ s|^(\./)+(?=[^/])||s;		# ./xx      -> xx
    $path =~ s|/\Z(?!\n)||
             unless $path =~ m#^([a-z]:)?/\Z(?!\n)#si;# xx/       -> xx
    return $path;
}

=item splitpath

    ($volume,$directories,$file) = File::Spec->splitpath( $path );
    ($volume,$directories,$file) = File::Spec->splitpath( $path, $no_file );

Splits a path into volume, directory, and filename portions. Assumes that 
the last file is a path unless the path ends in '/', '/.', '/..'
or $no_file is true.  On Win32 this means that $no_file true makes this return 
( $volume, $path, '' ).

Separators accepted are \ and /.

Volumes can be drive letters or UNC sharenames (\\server\share).

The results can be passed to L</catpath> to get back a path equivalent to
(usually identical to) the original path.

=cut

sub splitpath {
    my ($self,$path, $nofile) = @_;
    my ($volume,$directory,$file) = ('','','');
    if ( $nofile ) {
        $path =~ 
            m{^( (?:[a-zA-Z]:|(?:\\\\|//)[^\\/]+[\\/][^\\/]+)? ) 
                 (.*)
             }xs;
        $volume    = $1;
        $directory = $2;
    }
    else {
        $path =~ 
            m{^ ( (?: [a-zA-Z]: |
                      (?:\\\\|//)[^\\/]+[\\/][^\\/]+
                  )?
                )
                ( (?:.*[\\\\/](?:\.\.?\Z(?!\n))?)? )
                (.*)
             }xs;
        $volume    = $1;
        $directory = $2;
        $file      = $3;
    }

    return ($volume,$directory,$file);
}


=item splitdir

The opposite of L<catdir()|File::Spec/catdir()>.

    @dirs = File::Spec->splitdir( $directories );

$directories must be only the directory portion of the path on systems 
that have the concept of a volume or that have path syntax that differentiates
files from directories.

Unlike just splitting the directories on the separator, leading empty and 
trailing directory entries can be returned, because these are significant
on some OSs. So,

    File::Spec->splitdir( "/a/b//c/" );

Yields:

    ( '', 'a', 'b', '', 'c', '' )

=cut

sub splitdir {
    my ($self,$directories) = @_ ;
    split m|[\\/]|, $directories, -1;
}


=item catpath

Takes volume, directory and file portions and returns an entire path. Under
Unix, $volume is ignored, and this is just like catfile(). On other OSs,
the $volume become significant.

=cut

sub catpath {
    my ($self,$volume,$directory,$file) = @_;

    # If it's UNC, make sure the glue separator is there, reusing
    # whatever separator is first in the $volume
    $volume .= $1
        if ( $volume =~ m@^([\\/])[\\/][^\\/]+[\\/][^\\/]+\Z(?!\n)@s &&
             $directory =~ m@^[^\\/]@s
           ) ;

    $volume .= $directory ;

    # If the volume is not just A:, make sure the glue separator is 
    # there, reusing whatever separator is first in the $volume if possible.
    if ( $volume !~ m@^[a-zA-Z]:\Z(?!\n)@s &&
         $volume =~ m@[^\\/]\Z(?!\n)@      &&
         $file   =~ m@[^\\/]@
       ) {
        $volume =~ m@([\\/])@ ;
        my $sep = $1 ? $1 : '/' ;
        $volume .= $sep ;
    }

    $volume .= $file ;

    return $volume ;
}


sub abs2rel {
    my($self,$path,$base) = @_;

    # Clean up $path
    if ( ! $self->file_name_is_absolute( $path ) ) {
        $path = $self->rel2abs( $path ) ;
    } else {
        $path = $self->canonpath( $path ) ;
    }

    # Figure out the effective $base and clean it up.
    if ( !defined( $base ) || $base eq '' ) {
        $base = Cwd::sys_cwd() ;
    } elsif ( ! $self->file_name_is_absolute( $base ) ) {
        $base = $self->rel2abs( $base ) ;
    } else {
        $base = $self->canonpath( $base ) ;
    }

    # Split up paths
    my ( undef, $path_directories, $path_file ) =
        $self->splitpath( $path, 1 ) ;

    my $base_directories = ($self->splitpath( $base, 1 ))[1] ;

    # Now, remove all leading components that are the same
    my @pathchunks = $self->splitdir( $path_directories );
    my @basechunks = $self->splitdir( $base_directories );

    while ( @pathchunks && 
            @basechunks && 
            lc( $pathchunks[0] ) eq lc( $basechunks[0] ) 
          ) {
        shift @pathchunks ;
        shift @basechunks ;
    }

    # No need to catdir, we know these are well formed.
    $path_directories = CORE::join( '/', @pathchunks );
    $base_directories = CORE::join( '/', @basechunks );

    # $base_directories now contains the directories the resulting relative
    # path must ascend out of before it can descend to $path_directory.  So, 
    # replace all names with $parentDir

    #FA Need to replace between backslashes...
    $base_directories =~ s|[^\\/]+|..|g ;

    # Glue the two together, using a separator if necessary, and preventing an
    # empty result.

    #FA Must check that new directories are not empty.
    if ( $path_directories ne '' && $base_directories ne '' ) {
        $path_directories = "$base_directories/$path_directories" ;
    } else {
        $path_directories = "$base_directories$path_directories" ;
    }

    return $self->canonpath( 
        $self->catpath( "", $path_directories, $path_file ) 
    ) ;
}


sub rel2abs {
    my ($self,$path,$base ) = @_;

    if ( ! $self->file_name_is_absolute( $path ) ) {

        if ( !defined( $base ) || $base eq '' ) {
            $base = Cwd::sys_cwd() ;
        }
        elsif ( ! $self->file_name_is_absolute( $base ) ) {
            $base = $self->rel2abs( $base ) ;
        }
        else {
            $base = $self->canonpath( $base ) ;
        }

        my ( $path_directories, $path_file ) =
            ($self->splitpath( $path, 1 ))[1,2] ;

        my ( $base_volume, $base_directories ) =
            $self->splitpath( $base, 1 ) ;

        $path = $self->catpath( 
            $base_volume, 
            $self->catdir( $base_directories, $path_directories ), 
            $path_file
        ) ;
    }

    return $self->canonpath( $path ) ;
}

1;
__END__

=head1 NAME

File::Spec::OS2 - methods for OS/2 file specs

=head1 SYNOPSIS

 require File::Spec::OS2; # Done internally by File::Spec if needed

=head1 DESCRIPTION

See File::Spec::Unix for a documentation of the methods provided
there. This package overrides the implementation of these methods, not
the semantics.
