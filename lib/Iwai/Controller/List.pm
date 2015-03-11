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
  my $this_years = [];
  my $next_years = [];
  my $now = Iwai::Util->now->set(year => 1970);
  for my $list (@$lists) {
    if ($now < $list->birth) {
      push @$this_years, $list;
    } else {
      push @$next_years, $list;
    }
  }
  $lists = [(@$this_years, @$next_years)];
  $c->render_json([map { $_->to_hash_ref } @$lists]);
}

sub create {
  my ($class, $c) = @_;
  my $params = $c->request->parameters;
  my $url = $params->{url};
  $url =~ s/^https/http/;
  $url = [split(q{\?}, $url, 2)]->[0];
  $url =~ m{wishlist/([^/]+)};
  my $id = $1 or die Iwai::Error->new(code => 400);
  $url = "http://www.amazon.co.jp/wishlist/" . $id;

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
  my $params = $c->request->parameters;
  my $id = $params->{id};
  Iwai::Service::UserWishlist->remove($id);
  $c->render_text("ok");
}

sub check {
  my ($class, $c) = @_;
  my $params = $c->request->parameters;
  my $id = $params->{id};
  my $checked = $params->{checked};
  Iwai::Service::UserWishlist->check($id, $checked);
  $c->render_text("ok");
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
