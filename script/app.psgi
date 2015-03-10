use strict;
use warnings;
use lib "lib";

use Plack::Builder;
use File::RotateLogs;

use Iwai;

my $app = Iwai->as_psgi;
my $logger = File::RotateLogs->new(
  logfile      => "log/access.log.%Y%m%d%H%M",
  linkname     => "log/access.log",
  rotationtime => 86400, # 1day
  maxage       => 691200, # 1week + 1day
);

builder {
  enable "Static", (
    path => qr(^/(?:images|js|css)/),
    root => "public"
  );
  enable "AxsLog", (
    ltsv          => 1,
    response_time => 1,
    logger        => sub { $logger->print(@_) },
  );
  enable "Session::Cookie", secret => "sakura";
  enable "TwitterOAuth", (
    consumer_key    => "R3Wx7PhmdtojJYL4nRyETW9bw",
    consumer_secret => "YsAf1TRdcQu2vLhRkExCXoBhBFJoO3jgg3IA7tCmAEIArWP1t3",
    login_path      => "/login",
    logout_path     => "/logout"
  );
  $app;
};
