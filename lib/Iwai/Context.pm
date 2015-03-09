package Iwai::Context;

use strict;
use warnings;

use Plack::Request;

use Class::Accessor::Lite::Lazy (
  ro_lazy => [qw( request response )],
  ro      => [qw( env )],
  new => 0,
);

sub new ($) {
  my ($class, $env) = @_;
  bless {env => $env}, $class;
}

sub _build_request {
  my $self = shift;
  Plack::Request->new($self->env);
}

sub _build_response {
  my $self = shift;
  $self->request->new_response(200);
}

sub render_text {
  my $self = shift;
  my $res = $self->response;
  $res->code(200);
  $res->content_type("text/plane");
  $res->content(@_);
}

1;
