package Iwai;

use strict;
use warnings;

use Plack::Request;

sub as_psgi {
  my $class = shift;
  sub {
    my $env = shift;
    $class->run($env);
  }
}

sub run {
  my ($class, $env) = @_;
  my $req = Plack::Request->new($env);
  $req->new_response(200)->finalize;
}

1;
