package Iwai::Service;

use strict;
use warnings;

use DBIx::Sunny;

use Iwai::Config;
use Iwai::Util;

my $dbh;

sub dbh {
  $dbh ||= eval {
    my $config = config->param("db");
    DBIx::Sunny->connect(
      $config->{dsn},
      $config->{user},
      $config->{pass},
      {
        AutoCommit => 1,
        RaiseError => 1,
      }
    );
  };
}

sub model_name {
  my $class = shift;
  my @parts = split "::", $class;
  my $name = pop @parts;
  pop @parts;
  join "::", @parts, "Model", $name;
}

sub table_name {
  my $class = shift;
  my @parts = split "::", $class;
  my $name = lc $parts[-1];
  $name . "s"
}

1;
