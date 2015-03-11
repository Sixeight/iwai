package Iwai;

use strict;
use warnings;

use Plack::Util;
use Try::Tiny;

use Iwai::Context;
use Iwai::Config;
use Iwai::Error;

sub as_psgi {
  my $class = shift;
  sub {
    my $env = shift;
    $class->run($env);
  }
}

sub run {
  my ($class, $env) = @_;
  my $context = Iwai::Context->new($env);
  $context->user; # load user
  try {
    my $match = $context->router->match($env);
    $match or die Iwai::Error->new(code => 404);
    if (exists $match->{redirect}) {
      $context->redirect($match->{redirect});
      return;
    }
    my $controller = $match->{controller};
    my $action     = $match->{action};
    $controller = join "::", "Iwai", "Controller", $controller;
    Plack::Util::load_class($controller);
    $controller->$action($context);
  } catch {
    my $error = $_;
    if (ref $error ne "Iwai::Error") {
      $error = Iwai::Error->new(code => 500);
      $error->message($_) unless config->is_production;
    }
    $context->render_error($error);
  };
  $context->response->finalize;
}

1;
