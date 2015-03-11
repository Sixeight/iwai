package Iwai::Service::Wishlist;

use strict;
use warnings;

use parent "Iwai::Service";

sub create {
  my ($class, $params) = @_;
  my $url        = $params->{url};
  my $title      = $params->{title};
  my $name       = $params->{name}  || undef;
  my $birth      = $params->{birth} || undef;
  my $desc       = $params->{desc}  || undef;
  my $created_at = Iwai::Util->now;
  my $updated_at = Iwai::Util->now;
  my $sql = <<EOS
    INSERT INTO wishlists (
      url, title, name, birth, description, created_at, updated_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?)
EOS
;
  $class->dbh->query(
    $sql, $url, $title, $name, $birth, $desc, $created_at, $updated_at);
}

sub find_by_url {
  my ($class, $url) = @_;
  my $sql = "SELECT * FROM wishlists WHERE url = ? LIMIT 1";
  my $row = $class->dbh->select_row($sql, $url);
  return undef unless $row;
  $class->model_name->new($row);
}

1;
