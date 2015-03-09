package Iwai::Config;

use strict;
use warnings;

use Config::ENV "PLACK_ENV", export => "config";
use YAML::XS ();

my $db_yaml = YAML::XS::LoadFile("config/database.yml");

config db => +{
  time_zone => "UTC",
};

config test => +{
  db => +{
    parent("db"),
    %{$db_yaml->{test}},
  }
};

config development => +{
  db => +{
    parent("db"),
    %{$db_yaml->{development}},
  }
};

config production => +{
  db => +{
    parent("db"),
    %{$db_yaml->{production}},
  }
};
1;
