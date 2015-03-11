package Iwai::Model::Wishlist;

use strict;
use warnings;
use utf8;

# CREATE TABLE IF NOT EXISTS wishlists (
#   id      SERIAL PRIMARY KEY,
#   url     VARCHAR(64) NOT NULL,
#   title   VARCHAR(64) NOT NULL,
#   name    VARCHAR(32),
#   birth   DATE,
#   description VARCHAR(255),
#
#   created_at TIMESTAMP NOT NULL,
#   updated_at  TIMESTAMP NOT NULL
# );

use Class::Accessor::Lite (
  ro      => [qw( id url title name description )],
  new     => 1,
);

use Iwai::Util;

sub birth {
  my $self = shift;
  $self->{_birth} ||= eval {
    Iwai::Util->time_from_string($self->{birth});
  };
}

sub created_at {
  my $self = shift;
  $self->{_created_at} ||= eval {
    Iwai::Util->time_from_string($self->{created_at});
  };
}

sub updated_at {
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
    birth      => $self->birth->strftime("%m月%d日"),
    desc       => $self->description,
    created_at => $self->{created_at},
    updated_at => $self->{updated_at},
  }
}

1;
