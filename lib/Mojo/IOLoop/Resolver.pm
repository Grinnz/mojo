package Mojo::IOLoop::Resolver;
use Mojo::Base -base;

use Carp 'croak';
use Mojo::IOLoop;

has reactor => sub { Mojo::IOLoop->singleton->reactor };

sub getaddrinfo { croak 'Method "getaddrinfo" not implemented by subclass' }

1;
