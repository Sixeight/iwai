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
  ro  => [qw( id url title name description checked )],
  rw  => [qw( readonly has )],
  new => 1,
);

use JSON::Types ();

use Iwai::Util;

sub birth {
  my $self = shift;
  $self->{_birth} ||= eval {
    Iwai::Util->time_from_string($self->{birth});
  };
}

sub birth_str {
  my $self = shift;
  return "" unless $self->birth;
  $self->birth->strftime("%m月%d日")
}

sub birth_remain_days {
  my $self = shift;
  return 365 unless $self->birth;
  my $now = Iwai::Util->now;
  my $birth = $self->birth->set(year => $now->year);
  my $d = $birth->delta_days($now);
  ($now < $birth) ? $d->delta_days : 365 - $d->delta_days;
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
  my $hash = {
    id         => $self->id,
    url        => $self->url,
    title      => $self->title,
    name       => $self->name,
    birth      => $self->birth_str,
    birth_rd   => $self->birth_remain_days,
    desc       => $self->description,
    created_at => $self->{created_at},
    updated_at => $self->{updated_at},
  };
  if ($self->readonly) {
    $hash->{has} = JSON::Types::bool $self->has;
    $hash->{wishlist_id} = $self->{list_id};
  } else {
    $hash->{checked} = JSON::Types::bool $self->checked;
  }
  $hash;
}

1;
