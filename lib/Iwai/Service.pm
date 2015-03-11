package Iwai::Service;

use strict;
use warnings;

use Plack::Util;
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
  } or die "Cannot connect databse server: $@";
}

sub model_name {
  my $class = shift;
  my @parts = split "::", $class;
  my $name = pop @parts;
  pop @parts;
  my $model_name = join "::", @parts, "Model", $name;
  Plack::Util::load_class($model_name);
  $model_name;
}

sub table_name {
  my $class = shift;
  my @parts = split "::", $class;
  my $name = lc $parts[-1];
  $name . "s"
}

1;
