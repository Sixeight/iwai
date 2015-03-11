package Iwai::Controller::List;

use strict;
use warnings;
use utf8;

use Iwai::Service::Wishlist;
use Iwai::Service::UserWishlist;
use Iwai::Util::ListInfoFetcher;
use Iwai::Error;
use Iwai::Util;

sub index {
  my ($class, $c) = @_;
  $c->render_html("index");
}

sub json {
  my ($class, $c) = @_;
  my $lists = Iwai::Service::UserWishlist->all_wishlists_by_user_id($c->user->id);
  $c->render_json([map { $_->to_hash_ref } @$lists]);
}

sub create {
  my ($class, $c) = @_;
  my $params = $c->request->parameters;
  my $url = $params->{url};
  $url =~ s/^https/http/;

  my $wishlist = Iwai::Service::Wishlist->find_by_url($url);
  unless ($wishlist) {
    # FIXME: I wanna fech last_insert_id
    $class->create_wish_list($url);
    $wishlist = Iwai::Service::Wishlist->find_by_url($url);
  }
  Iwai::Service::UserWishlist->create($c->user->id, $wishlist->id);
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

sub create_wish_list {
  my ($class, $url) = @_;

  my $info = Iwai::Util::ListInfoFetcher->fetch($url)
    or die Iwai::Error->new(code => 404);

  my $title = $info->{title};
  my $name  = $info->{name};
  my $birth = $info->{birth};
  my $desc  = $info->{desc};
  $title = [split(":", $title)]->[-1];
  if ($birth) {
    my $ptn = q[(\d{1,2})月 (\d{1,2})日];
    $birth =~ m/$ptn/;
    $birth = Iwai::Util->time_from_string(sprintf("1970-%02d-%02d", $1, $2));
  }
  Iwai::Service::Wishlist->create({
    url     => $url,
    title   => $title,
    name    => $name,
    birth   => $birth,
    desc    => $desc,
  });
}

1;
