package Mojo::IOLoop::Resolver::NDN;
use Mojo::Base 'Mojo::IOLoop::Resolver';

use Net::DNS::Native 0.13;
use Scalar::Util 'weaken';
use Socket 'IPPROTO_TCP';

has ndn => sub { Net::DNS::Native->new(pool => 5, extra_thread => 1) };

$ENV{MOJO_RESOLVER} ||= 'Mojo::IOLoop::Resolver::NDN';

sub DESTROY {
  my $self = shift;
  return unless my $reactor = $self->reactor;
  if (my $dns = delete $self->{dns}) { $reactor->remove($dns) }
}

sub getaddrinfo {
  my ($self, $address, $port, $cb) = @_;

  my $handle = $self->{dns}
    = $self->ndn->getaddrinfo($address, $port, {protocol => IPPROTO_TCP});

  weaken $self;
  $self->reactor->io(
    $handle => sub {
      my $reactor = shift;

      $reactor->remove($self->{dns});
      my ($err, @res) = $self->ndn->get_result(delete $self->{dns});

      $self->$cb($err, \@res);
    }
  )->watch($handle, 1, 0);
}

1;
