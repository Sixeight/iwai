package Iwai::Controller::List;

use strict;
use warnings;
use utf8;

use Iwai::Service::Wishlist;
use Iwai::Service::UserWishlist;
use Iwai::Util::ListInfoFetcher;
use Iwai::Error;
use Iwai::Util;
use Iwai::Config;

sub index {
  my ($class, $c, $m) = @_;
  my $user = $c->user;
  my $name = $m->{name};
  if ($name) {
    config->is_open_list or die Iwai::Error->new(code => 404);
    $user = Iwai::Service::User->find_by_name($name)
      or die Iwai::Error->new(code => 404);
  }
  $c->render_html("index", name => $name);
}

sub my_json {
  my ($class, $c) = @_;
  my $lists = Iwai::Service::UserWishlist->all_wishlists_by_user_id($c->user->id);
  render_json($c, $lists);
}

sub user_json {
  config->is_open_list or die Iwai::Error->new(code => 404);
  my ($class, $c, $m) = @_;
  my $name = $m->{name};
  my $user = Iwai::Service::User->find_by_name($name)
    or die Iwai::Error->new(code => 404);
  my $lists = Iwai::Service::UserWishlist->all_wishlists_by_user_id($user->id);
  my $wishlist_id_map = Iwai::Service::UserWishlist->wishlist_id_map_by_user_id($c->user->id);
  for my $list (@$lists) {
    $list->readonly(1);
    $list->has($wishlist_id_map->{$list->{list_id}});
  }
  render_json($c, $lists);
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
    create_wish_list($url);
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

sub copy {
  config->is_open_list or die Iwai::Error->new(code => 404);
  my ($class, $c) = @_;
  my $params = $c->request->parameters;
  my $wishlist_id = $params->{wishlist_id};
  Iwai::Service::UserWishlist->create($c->user->id, $wishlist_id);
  $c->render_text("ok");
}

# Utilties

sub render_json {
  my ($c, $lists) = @_;
  $lists = sort_wish_list($lists);
  $c->render_json([map { $_->to_hash_ref } @$lists]);
}

sub create_wish_list {
  my $url = shift;

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

sub sort_wish_list {
  my $lists = shift;
  my $this_years = [];
  my $next_years = [];
  my $now = Iwai::Util->now->set(year => 1970);
  for my $list (@$lists) {
    if ($list->birth && $now < $list->birth) {
      push @$this_years, $list;
    } else {
      push @$next_years, $list;
    }
  }
  [(@$this_years, @$next_years)];
}

1;
