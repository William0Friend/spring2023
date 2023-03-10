# $Id: SSH2.pm,v 1.34 2001/10/04 20:29:08 btrott Exp $

package Net::SSH::Perl::SSH2;
use strict;

use Net::SSH::Perl::Kex;
use Net::SSH::Perl::ChannelMgr;
use Net::SSH::Perl::Packet;
use Net::SSH::Perl::Buffer;
use Net::SSH::Perl::Constants qw( :protocol :msg2
                                  CHAN_INPUT_CLOSED CHAN_INPUT_WAIT_DRAIN );
use Net::SSH::Perl::Cipher;
use Net::SSH::Perl::AuthMgr;
use Net::SSH::Perl::Comp;
use Net::SSH::Perl::Util qw( :hosts );

use Net::SSH::Perl;
use base qw( Net::SSH::Perl );

use Carp qw( croak );

sub select_class { 'IO::Select' }

sub _dup {
    my($fh, $mode) = @_;
    my $dup = Symbol::gensym;
    my $str = "${mode}&$fh";
    open $dup, $str;
    $dup;
}

sub version_string {
    my $class = shift;
    sprintf "Net::SSH::Perl Version %s, protocol version %s.%s.",
        $class->VERSION, PROTOCOL_MAJOR_2, PROTOCOL_MINOR_2;
}

sub _proto_init {
    my $ssh = shift;
    unless ($ssh->{config}->get('user_known_hosts')) {
        $ssh->{config}->set('user_known_hosts', "$ENV{HOME}/.ssh/known_hosts2");
    }
    unless ($ssh->{config}->get('global_known_hosts')) {
        $ssh->{config}->set('global_known_hosts', "/etc/ssh_known_hosts2");
    }
    unless (my $if = $ssh->{config}->get('identity_files')) {
        $ssh->{config}->set('identity_files', [ "$ENV{HOME}/.ssh/id_dsa" ]);
    }

    for my $a (qw( password dsa kbd_interactive )) {
        $ssh->{config}->set("auth_$a", 1)
            unless defined $ssh->{config}->get("auth_$a");
    }
}

sub kex { $_[0]->{kex} }

sub register_handler {
    my($ssh, $type, $sub, @extra) = @_;
    $ssh->{client_handlers}{$type} = { code => $sub, extra => \@extra };
}

sub login {
    my $ssh = shift;
    $ssh->SUPER::login(@_);
    $ssh->_login or $ssh->fatal_disconnect("Permission denied");

    $ssh->debug("Login completed, opening dummy shell channel.");
    my $cmgr = $ssh->channel_mgr;
    my $channel = $cmgr->new_channel(
        ctype => 'session', local_window => 0,
        local_maxpacket => 0, remote_name => 'client-session');
    $channel->open;

    my $packet = Net::SSH::Perl::Packet->read_expect($ssh,
        SSH2_MSG_CHANNEL_OPEN_CONFIRMATION);
    $cmgr->input_open_confirmation($packet);

    $ssh->debug("Got channel open confirmation, requesting shell.");
    $channel->request("shell", 0);
}

sub _login {
    my $ssh = shift;

    my $kex = Net::SSH::Perl::Kex->new($ssh);
    $kex->exchange;

    my $amgr = Net::SSH::Perl::AuthMgr->new($ssh);
    $amgr->authenticate;
}

sub _session_channel {
    my $ssh = shift;
    my $cmgr = $ssh->channel_mgr;

    my $channel = $cmgr->new_channel(
        ctype => 'session', local_window => 32*1024,
        local_maxpacket => 16*1024, remote_name => 'client-session',
        rfd => _dup('STDIN', '<'), wfd => _dup('STDOUT', '>'),
        efd => _dup('STDERR', '>'));

    $channel;
}

sub _make_input_channel_req {
    my($r_exit) = @_;
    return sub {
        my($channel, $packet) = @_;
        my $rtype = $packet->get_str;
        my $reply = $packet->get_int8;
        $channel->{ssh}->debug("input_channel_request: rtype $rtype reply $reply");
        if ($rtype eq "exit-status") {
            $$r_exit = $packet->get_int32;
        }
        if ($reply) {
            my $r_packet = $channel->{ssh}->packet_start(SSH2_MSG_CHANNEL_SUCCESS);
            $r_packet->put_int($channel->{remote_id});
            $r_packet->send;
        }
    };
}

sub cmd {
    my $ssh = shift;
    my($cmd, $stdin) = @_;
    my $cmgr = $ssh->channel_mgr;
    my $channel = $ssh->_session_channel;
    $channel->open;

    $channel->register_handler(SSH2_MSG_CHANNEL_OPEN_CONFIRMATION, sub {
        my($channel, $packet) = @_;
        $channel->{ssh}->debug("Sending command: $cmd");
        my $r_packet = $channel->request_start("exec", 0);
        $r_packet->put_str($cmd);
        $r_packet->send;

        if ($stdin) {
            $channel->send_data($stdin);

            $channel->drain_outgoing;
            $channel->{istate} = CHAN_INPUT_WAIT_DRAIN;
            $channel->send_eof;
            $channel->{istate} = CHAN_INPUT_CLOSED;
        }
    });

    my($exit);
    $channel->register_handler(SSH2_MSG_CHANNEL_REQUEST,
        _make_input_channel_req(\$exit));

    my $h = $ssh->{client_handlers};
    my($stdout, $stderr);
    if (my $r = $h->{stdout}) {
        $channel->register_handler("_output_buffer",
            $r->{code}, @{ $r->{extra} });
    }
    else {
        $channel->register_handler("_output_buffer", sub {
            $stdout .= $_[1]->bytes;
        });
    }
    if (my $r = $h->{stderr}) {
        $channel->register_handler("_extended_buffer",
            $r->{code}, @{ $r->{extra} });
    }
    else {
        $channel->register_handler("_extended_buffer", sub {
            $stderr .= $_[1]->bytes;
        });
    }

    $ssh->debug("Entering interactive session.");
    $ssh->client_loop;

    ($stdout, $stderr, $exit);
}

sub shell {
    my $ssh = shift;
    my $cmgr = $ssh->channel_mgr;
    my $channel = $ssh->_session_channel;
    $channel->open;

    $channel->register_handler(SSH2_MSG_CHANNEL_OPEN_CONFIRMATION, sub {
        my($channel, $packet) = @_;
        my $r_packet = $channel->request_start('pty-req', 0);
        my($term) = $ENV{TERM} =~ /(\w+)/;
        $r_packet->put_str($term);
        $r_packet->put_int32(0) for 1..4;
        $r_packet->put_str("");
        $r_packet->send;
        $channel->{ssh}->debug("Requesting shell.");
        $channel->request("shell", 0);
    });

    my($exit);
    $channel->register_handler(SSH2_MSG_CHANNEL_REQUEST,
        _make_input_channel_req(\$exit));

    $channel->register_handler("_output_buffer", sub {
        syswrite STDOUT, $_[1]->bytes;
    });
    $channel->register_handler("_extended_buffer", sub {
        syswrite STDERR, $_[1]->bytes;
    });

    $ssh->debug("Entering interactive session.");
    $ssh->client_loop;
}

sub open2 {
    my $ssh = shift;
    my($cmd) = @_;

    require Net::SSH::Perl::Handle::SSH2;

    my $cmgr = $ssh->channel_mgr;
    my $channel = $ssh->_session_channel;
    $channel->open;

    $channel->register_handler(SSH2_MSG_CHANNEL_OPEN_CONFIRMATION, sub {
        my($channel, $packet) = @_;
        $channel->{ssh}->debug("Sending command: $cmd");
        my $r_packet = $channel->request_start("exec", 1);
        $r_packet->put_str($cmd);
        $r_packet->send;
    });

    my $exit;
    $channel->register_handler(SSH2_MSG_CHANNEL_REQUEST, sub {
	my($channel, $packet) = @_;
	my $rtype = $packet->get_str;
	my $reply = $packet->get_int8;
	$channel->{ssh}->debug("input_channel_request: rtype $rtype reply $reply");
	if ($rtype eq "exit-status") {
	    $exit = $packet->get_int32;
	}
	if ($reply) {
	    my $r_packet = $channel->{ssh}->packet_start(SSH2_MSG_CHANNEL_SUCCESS);
	    $r_packet->put_int($channel->{remote_id});
	    $r_packet->send;
	}
    });

    my $reply = sub {
        my($channel, $packet) = @_;
        if ($packet->type == SSH2_MSG_CHANNEL_FAILURE) {
            $channel->{ssh}->fatal_disconnect("Request for " .
                "exec failed on channel '" . $packet->get_int32 . "'");
        }
        $channel->{ssh}->break_client_loop;
    };

    $cmgr->register_handler(SSH2_MSG_CHANNEL_FAILURE, $reply);
    $cmgr->register_handler(SSH2_MSG_CHANNEL_SUCCESS, $reply);

    $ssh->client_loop;

    local(*READ, *WRITE);
    tie *READ, 'Net::SSH::Perl::Handle::SSH2', 'r', $channel, \$exit;
    tie *WRITE, 'Net::SSH::Perl::Handle::SSH2', 'w', $channel, \$exit;

    (\*READ, \*WRITE);
}

sub break_client_loop { $_[0]->{_cl_quit_pending} = 1 }
sub restore_client_loop { $_[0]->{_cl_quit_pending} = 0 }
sub _quit_pending { $_[0]->{_cl_quit_pending} }

sub client_loop {
    my $ssh = shift;
    my $cmgr = $ssh->channel_mgr;

    my $h = $cmgr->handlers;
    my $select_class = $ssh->select_class;

    CLOOP:
    $ssh->{_cl_quit_pending} = 0;
    while (!$ssh->_quit_pending) {
        while (my $packet = Net::SSH::Perl::Packet->read_poll($ssh)) {
            if (my $code = $h->{ $packet->type }) {
                $code->($cmgr, $packet);
            }
            else {
                $ssh->debug("Warning: ignore packet type " . $packet->type);
            }
        }
        last if $ssh->_quit_pending;

        $cmgr->process_output_packets;

        my $rb = $select_class->new;
        my $wb = $select_class->new;
        $rb->add($ssh->sock);
        $cmgr->prepare_channels($rb, $wb);

        #last unless $cmgr->any_open_channels;
        my $oc = grep { defined } @{ $cmgr->{channels} };
        last unless $oc > 1;

        my($rready, $wready) = $select_class->select($rb, $wb);
        $cmgr->process_input_packets($rready, $wready);

        for my $a (@$rready) {
            if ($a == $ssh->{session}{sock}) {
                my $buf;
                my $len = sysread $a, $buf, 8192;
                $ssh->break_client_loop if $len == 0;
                ($buf) = $buf =~ /(.*)/s;  ## Untaint data. Anything allowed.
                $ssh->incoming_data->append($buf);
            }
        }
    }
}

sub channel_mgr {
    my $ssh = shift;
    unless (defined $ssh->{channel_mgr}) {
        $ssh->{channel_mgr} = Net::SSH::Perl::ChannelMgr->new($ssh);
    }
    $ssh->{channel_mgr};
}

1;
__END__

=head1 NAME

Net::SSH::Perl::SSH2 - SSH2 implementation

=head1 SYNOPSIS

    use Net::SSH::Perl;
    my $ssh = Net::SSH::Perl->new($host, protocol => 2);

=head1 DESCRIPTION

I<Net::SSH::Perl::SSH2> implements the SSH2 protocol. It is a
subclass of I<Net::SSH::Perl>, and implements the interface
described in the documentation for that module. In fact, your
usage of this module should be completely transparent; simply
specify the proper I<protocol> value (C<2>) when creating your
I<Net::SSH::Perl> object, and the SSH2 implementation will be
loaded automatically.

NOTE: Of course, this is still subject to protocol negotiation
with the server; if the server doesn't support SSH2, there's
not much the client can do, and you'll get a fatal error if
you use the above I<protocol> specification (C<2>).

=head2 AUTHOR & COPYRIGHTS

Please see the Net::SSH::Perl manpage for author, copyright,
and license information.

=cut
