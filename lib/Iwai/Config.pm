package Iwai::Config;

use strict;
use warnings;

use Config::ENV "PLACK_ENV", export => "config";
use Text::Xslate;
use YAML::XS ();
use Path::Class "file";

our $DB_CONFIG_PATH = "config/database.yml";

my $tx = Text::Xslate->new(
  function => {
    ENV => sub {
      $ENV{$_[0]}
    },
  },
);
my $yaml = $tx->render($DB_CONFIG_PATH);
my $db_yaml = YAML::XS::Load($yaml);

my $root = file(__FILE__)->dir->parent->parent->absolute;

sub root {
  $root;
}

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
