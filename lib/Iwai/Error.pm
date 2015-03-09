package Iwai::Error;

use strict;
use warnings;

use HTTP::Status "status_message";

use Class::Accessor::Lite (
  rw  => [qw( code )],
  new => 1,
);

sub message {
  my $self = shift;
  if (@_ == 1) {
    $self->{message} = $_[0];
  }
  $self->{message} ||= eval {
    status_message($self->code) || "";
  };
}

1;
