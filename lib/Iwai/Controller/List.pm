package Iwai::Controller::List;

use strict;
use warnings;

use Iwai::Service::Wishlist;
use Iwai::Util::ListInfoFetcher;
use Iwai::Error;

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
  my $params = $c->request->parameters;
  my $url = $params->{url};
  my $info = Iwai::Util::ListInfoFetcher->fetch($url)
    or die Iwai::Error->new(code => 404);

  my $title = $info->{title};
  my $name  = $info->{name};
  my $birth = $info->{birth};
  my $desc  = $info->{desc};
  $title = [split(":", $title)]->[-1];
  Iwai::Service::Wishlist->create({
    url     => $url,
    title   => $title,
    name    => $name,
    birth   => $birth,
    desc    => $desc,
    user_id => $c->user->id,
  });
  $c->render_text("ok");
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
