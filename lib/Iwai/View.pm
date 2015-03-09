package Iwai::View;

use strict;
use warnings;

use Text::Xslate;
use Encode "encode_utf8";

use Iwai::Config;

my $tx = Text::Xslate->new(
  cache => 0,
  path => config->root->subdir("template"),
);

sub new {
  my ($class, $c) = @_;
  bless { c => $c }, $class;
}

sub render_html {
  my $self = shift;
  my $name = shift;
  if ($name !~ qr/\.html\.tx$/) {
    $name .= ".html.tx";
  }
  my $vars = (c => $self->{c},  @_);
  encode_utf8 $tx->render($name, {$vars});
}
