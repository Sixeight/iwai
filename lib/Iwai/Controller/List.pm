package Iwai::Controller::List;

use strict;
use warnings;

sub index {
  my ($class, $c) = @_;
  $c->render_text("index");
}

sub json {
  my ($class, $c) = @_;
  my $lists = Iwai::Service::Wishlist->find_all_by_user_id($c->user->id);
  $c->render_json([map { $_->to_hash_ref } @$lists]);
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
