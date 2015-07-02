package Iwai::Util::ListInfoFetcher;

use strict;
use warnings;

use LWP::UserAgent;
use HTML::Selector::XPath "selector_to_xpath";
use HTML::TreeBuilder::XPath;
use Encode ();

my $ua = LWP::UserAgent->new;

sub fetch {
  my ($class, $url) = @_;
  my $res = $ua->get($url);
  unless ($res->is_success) {
    return {};
  }
  my $body = $res->decoded_content;
  my $tree = HTML::TreeBuilder::XPath->new;
  $tree->parse($body);
  my $title = $tree->findvalue(selector_to_xpath("#content-right .profile .profile-layout-aid-top .clip-text > span"));
  my $desc  = $tree->findvalue(selector_to_xpath("#wlDesc"));
  my $name  = $tree->findvalue(selector_to_xpath(".g-profile-name"));
  my $birth = $tree->findvalue(selector_to_xpath(".g-profile-birthday"));
  $tree->delete;
  {
    title => $title,
    desc  => $desc,
    name  => $name,
    birth => $birth,
  }
}

1;
