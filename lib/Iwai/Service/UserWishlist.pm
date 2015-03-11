package Iwai::Service::UserWishlist;

use strict;
use warnings;

use parent "Iwai::Service";

use Iwai::Model::Wishlist;

sub create {
  my $class = shift;
  my ($user_id, $list_id) = @_;
  my $created_at = Iwai::Util->now;
  my $sql = "INSERT INTO users_wishlists (user_id, wishlist_id, created_at) VALUES (?, ?, ?)";
  $class->dbh->query($sql, $user_id, $list_id, $created_at);
}

sub remove {
  my ($class, $id) = @_;
  my $sql = "DELETE FROM users_wishlists WHERE id = ?";
  $class->dbh->query($sql, $id);
}

sub exists_by_user_id_and_list_id {
  my $class = shift;
  my ($user_id, $list_id) = @_;
  my $sql = "SELECT * FROM users_wishlists WHERE user_id = ? AND wishlist_id = ?";
  defined $class->dbh->select_row($sql, $user_id, $list_id);
}

sub all_wishlists_by_user_id {
  my ($class, $user_id) = @_;
  my $sql = <<EOS
    SELECT list.*
      FROM users_wishlists as map
      JOIN wishlists as list ON map.wishlist_id = list.id
      WHERE map.user_id = ?
EOS
;
  my $wishlists = $class->dbh->select_all($sql, $user_id);
  [map { Iwai::Model::Wishlist->new($_) } @$wishlists];
}

1;
