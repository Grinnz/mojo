package Mojo::IOLoop::Resolver::Dummy;
use Mojo::Base 'Mojo::IOLoop::Resolver';

use Scalar::Util 'weaken';

sub getaddrinfo {
  my ($self, $address, $port, $cb) = @_;
  weaken $self;
  $self->reactor->next_tick(sub { $self->$cb(undef, undef) });
}

1;
