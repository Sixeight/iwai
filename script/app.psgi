use strict;
use warnings;
use lib "lib";

use Plack::Builder;
use File::RotateLogs;

use Iwai;

my $app = Iwai->as_psgi;
my $rotate_logger = File::RotateLogs->new(
  logfile      => "log/access.log.%Y%m%d%H%M",
  linkname     => "log/access.log",
  rotationtime => 86400, # 1day
  maxage       => 691200, # 1week + 1day
);

my $logger = sub { $rotate_logger->print(@_) };

# For heroku
if ($ENV{PLACK_ENV} eq "deployment") {
  $logger = sub { print STDOUT @_ };
}

builder {
  enable "Static", (
    path => qr(^/(?:images|js|css)/),
    root => "public"
  );
  enable "AxsLog", (
    ltsv          => 1,
    response_time => 1,
    logger        => $logger,
  );
  enable "Session::Cookie", secret => $ENV{COOKIE_SECRET};
  enable "TwitterOAuth", (
    consumer_key    => $ENV{CONSUMER_KEY},
    consumer_secret => $ENV{CONSUMER_SECRET},
    login_path      => "/login",
    logout_path     => "/logout"
  );
  $app;
};
