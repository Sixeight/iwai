package Iwai::Model::User;

use strict;
use warnings;

# CREATE TABLE IF NOT EXISTS users (
#   id         SERIAL PRIMARY KEY,
#   name       VARCHAR(32) NOT NULL UNIQUE,
#   twitter_id INT NOT NULL UNIQUE,
#   joined_at TIMESTAMP NOT NULL
# );
# /* CREATE INDEX has no IF NOT EXISTS */
# CREATE INDEX users_twitter_id_index ON users (twitter_id);

use Class::Accessor::Lite (
  ro      => [qw( id name twitter_id )],
  new     => 1
);

use Iwai::Util;

sub joined_at {
  my $self = shift;
  $self->{_joined_at} ||= eval {
    Iwai::Util->time_from_string($self->{joined_at});
  };
}

sub to_hash_ref {
  my $self = shift;
  {
    id        => $self->id,
    name      => $self->name,
    joined_at => $self->{joined_at},
  }
}

1;

__END__
