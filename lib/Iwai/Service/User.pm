package Iwai::Service::User;

use strict;
use warnings;

use parent "Iwai::Service";

sub create {
  my ($class, $params) = @_;
  my $name = $params->{name};
  my $twitter_id = $params->{twitter_id};
  my $joined_at = Iwai::Util->now;
  my $sql = "INSERT INTO users (name, twitter_id, joined_at) VALUES (?, ?, ?)";
  my $rc = $class->dbh->query($sql, $name, $twitter_id, $joined_at);
  return undef unless $rc;
  $class->find_by_twitter_id($twitter_id);
}

sub find_by_twitter_id {
  my ($class, $twitter_id) = @_;
  my $ret = $class->dbh->select_row("SELECT * FROM users WHERE twitter_id = ? LIMIT 1", $twitter_id);
  $ret ? $class->model_name->new($ret) : undef;
}

1;
