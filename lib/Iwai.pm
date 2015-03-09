package Iwai;

use strict;
use warnings;

use Iwai::Context;

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
  $context->render_html("index");
  $context->response->finalize;
}

1;
