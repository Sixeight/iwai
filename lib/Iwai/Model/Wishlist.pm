package Iwai::Model::Wishlist;

use strict;
use warnings;

# CREATE TABLE IF NOT EXISTS wishlists (
#   id    SERIAL PRIMARY KEY,
#   url   VARCHAR(64) NOT NULL UNIQUE,
#   title VARCHAR(64) NOT NULL,
#   memo  VARCHAR(255),
#   created_at TIMESTAMP NOT NULL,
#   updatd_at TIMESTAMP NOT NULL
# );
# /* CREATE INDEX has no IF NOT EXISTS */
# CREATE INDEX wishlists_user_id_index ON wishlists (user_id);


use Class::Accessor::Lite::Lazy (
  ro      => [qw( id url title name birth description )],
  ro_lazy => [qw( created_at updated_at )],
  new     => 1,
);

use Iwai::Util;

sub _build_created_at {
  my $self = shift;
  $self->{_created_at} ||= eval {
    Iwai::Util->time_from_string($self->{created_at});
  };
}

sub _build_updated_at {
  my $self = shift;
  $self->{_updated_at} ||= eval {
    Iwai::Util->time_from_string($self->{updated_at});
  };
}

sub to_hash_ref {
  my $self = shift;
  {
    id         => $self->id,
    url        => $self->url,
    title      => $self->title,
    name       => $self->name,
    birth      => $self->birth,
    desc       => $self->description,
    created_at => $self->{created_at},
    updated_at => $self->{updated_at},
  }
}

1;
