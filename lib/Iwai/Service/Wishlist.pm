package Iwai::Service::Wishlist;

use strict;
use warnings;

use parent "Iwai::Service";

sub create {
  my ($class, $params) = @_;
  my $url        = $params->{url};
  my $title      = $params->{title};
  my $memo       = $params->{memo};
  my $user_id    = $params->{user_id};
  my $created_at = Iwai::Util->now;
  my $updated_at = Iwai::Util->now;
  my $sql = "INSERT INTO wishlists (url, title, memo, user_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)";
  $class->dbh->query($sql, $url, $title, $memo, $user_id, $created_at, $updated_at);
}

sub find_all_by_user_id {
  my ($class, $user_id) = @_;
  my $sql = "SELECT * FROM wishlists WHERE user_id = ?";
  my $rows = $class->dbh->select_all($sql, $user_id);
  [map { $class->model_name->new($_) } @$rows];
}

1;
