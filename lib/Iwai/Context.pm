package Iwai::Context;

use strict;
use warnings;

use Plack::Request;
use JSON::XS ();

use Class::Accessor::Lite::Lazy (
  ro_lazy => [qw( request response router user )],
  ro      => [qw( env )],
  new => 0,
);

use Iwai::View;
use Iwai::Route;
use Iwai::Error;
use Iwai::Service::User;

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

sub _build_router {
  Iwai::Route->mk_router;
}

sub _build_user {
  my $self = shift;
  my $twitter_id = $self->env->{"twitter.id"};
  my $name = $self->env->{"twitter.screen_name"};
  my $user = Iwai::Service::User->find_by_twitter_id($twitter_id);
  $user //= Iwai::Service::User->create({name => $name, twitter_id => $twitter_id});
  $user;
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
  my $view = Iwai::View->new($self);
  my $html = $view->render_html(@_);
  my $res = $self->response;
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

sub render_error {
  my ($self, $error) = @_;
  my $res = $self->response;
  $res->code($error->code);
  $res->content_type("text/plain");
  $res->content($error->message);
}

sub redirect {
  my ($self, $url) = @_;
  $self->response->redirect($url);
}

1;
