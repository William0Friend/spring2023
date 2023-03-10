#!/usr/bin/perl
###########################################
use warnings;
use strict;

package Log::Log4perl::Config::Watch;

our $NEXT_CHECK_TIME;

###########################################
sub new {
###########################################
    my($class, %options) = @_;

    my $self = { file            => "",
                 check_interval  => 30,
                 %options,
                 _last_checked_at => 0,
                 _last_timestamp  => 0,
               };

    bless $self, $class;

        # Just called to initialize
    $self->change_detected();

    return $self;
}

###########################################
sub file {
###########################################
    my($self) = @_;

    return $self->{file};
}

###########################################
sub check_interval {
###########################################
    my($self) = @_;

    return $self->{check_interval};
}

###########################################
sub change_detected {
###########################################
    my($self, $time) = @_;

    $time = time() unless defined $time;

        # Do we need to check?
    if($self->{_last_checked_at} + 
       $self->{check_interval} > $time) {
        return ""; # don't need to check, return false
    }
       
    my $new_timestamp = (stat($self->{file}))[9];
    $self->{_last_checked_at} = $time;

    # Set global var for optimizations in case we just have one watcher
    # (like in Log::Log4perl)
    $NEXT_CHECK_TIME = $time + $self->{check_interval};

    if($new_timestamp > $self->{_last_timestamp}) {
        $self->{_last_timestamp} = $new_timestamp;
        return 1; # Has changed
    }
       
    return "";  # Hasn't changed
}

1;

__END__

=head1 NAME

Log::Log4perl::Config::Watch - Detect file changes

=head1 SYNOPSIS

    use Log::Log4perl::Config::Watch;

    my $watcher = Log::Log4perl::Config::Watch->new(
                          file            => "/data/my.conf",
                          check_interval  => 30,
                  );

    while(1) {
        if($watcher->change_detected()) {
            print "Change detected!\n";
            sleep(1);
        }
    }

=head1 DESCRIPTION

This module helps detecting changes in files. Although it comes with the
C<Log::Log4perl> distribution, it can be used independly.

The constructor defines the file to be watched and the check interval 
in seconds. Subsequent calls to C<change_detected()> will 

=over 4

=item *

return a false value immediately without doing physical file checks
if C<check_interval> hasn't elapsed.

=item *

perform a physical test on the specified file if the number
of seconds specified in C<check_interval> 
have elapsed since the last physical check. If the file's modification
date has changed since the last physical check, it will return a true 
value, otherwise a false value is returned.

Bottom line: C<check_interval> allows you to call the function
C<change_detected()> as often as you like, without paying the performing
a significant performance penalty because file system operations 
are being performed (however, you pay the price of not knowing about
file changes until C<check_interval> seconds have elapsed).

The module clearly distinguishes system time from file system time. 
If your (e.g. NFS mounted) file system is off by a constant amount
of time compared to the executing computer's clock, it'll just
work fine.

To disable the resource-saving delay feature, just set C<check_interval> 
to 0 and C<change_detected()> will run a physical file test on
every call.

If you already have the current time available, you can pass it
on to C<change_detected()> as an optional parameter, like in

    change_detected($time)

which then won't trigger a call to C<time()>, but use the value
provided.

=back

=head1 SEE ALSO

=head1 AUTHOR

    Mike Schilli, <log4perl@perlmeister.com>

=cut

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Mike Schilli E<lt>m@perlmeister.comE<gt> and Kevin Goess
E<lt>cpan@goess.orgE<gt>.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
