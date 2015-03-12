package Iwai::Util;

use strict;
use warnings;

use DateTime;
use DateTime::Format::Pg;

use Iwai::Config;

sub now {
  my $now = DateTime->now(time_zone => config->param("db")->{time_zone});
  $now->set_formatter(DateTime::Format::Pg->new);
  $now;
}

sub time_from_string {
  my ($class, $string) = @_;
  return unless $string;
  my $dt = DateTime::Format::Pg->parse_datetime($string);
  $dt->set_time_zone(config->param("db")->{time_zone});
  $dt->set_formatter(DateTime::Format::Pg->new);
  $dt;
}

sub time_to_string {
  my ($class, $time) = @_;
  return unless $time;
  $time->set_time_zone(config->param("db")->{time_zone});
  $time->set_formatter(DateTime::Format::Pg->new);
  "" . $time;
}

1;
