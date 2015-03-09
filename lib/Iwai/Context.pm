package Iwai::Context;

use strict;
use warnings;

use Plack::Request;
use JSON::XS ();

use Class::Accessor::Lite::Lazy (
  ro_lazy => [qw( request response )],
  ro      => [qw( env )],
  new => 0,
);

use Iwai::View;

my $json_encoder = JSON::XS->new->utf8;

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

sub render_html {
  my $self = shift;
  my $res = $self->response;
  my $view = Iwai::View->new($self);
  my $html = $view->render_html(@_);
  $res->code(200);
  $res->content_type("text/html");
  $res->content($html);
}

sub render_json {
  my $self = shift;
  my $json = $json_encoder->encode(@_);
  my $res = $self->response;
  $res->code(200);
  $res->content_type("application/json");
  $res->content($json);
}

1;
