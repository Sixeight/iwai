package Iwai::Controller::List;

use strict;
use warnings;

sub index {
  my ($class, $c) = @_;
  $c->render_text("index");
}

sub create {
  my ($class, $c) = @_;
  $c->render_text("add");
}

sub update {
  my ($class, $c) = @_;
  $c->render_text("update");
}

sub delete {
  my ($class, $c) = @_;
  $c->render_text("remove");
}

1;
