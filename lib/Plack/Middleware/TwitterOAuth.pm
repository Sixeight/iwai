package Plack::Middleware::TwitterOAuth;

use strict;
use warnings;

our $VERSION   = "0.0.1";

use parent "Plack::Middleware";

use Plack::Util::Accessor qw( consumer_key consumer_secret consumer login_path logout_path );

use Plack::Session;
use Plack::Request;

use OAuth::Lite::Consumer;
use JSON::XS;

sub prepare_app {
  my $self = shift;
  die "require consumer_key and consumer_secret"
    unless $self->consumer_key and $self->consumer_secret;

    $self->consumer(OAuth::Lite::Consumer->new(
        consumer_key       => $self->consumer_key,
        consumer_secret    => $self->consumer_secret,
        site               => q{https://api.twitter.com},
        request_token_path => q{/oauth/request_token},
        access_token_path  => q{/oauth/access_token},
        authorize_path     => q{/oauth/authorize},
    ));
}

sub call {
  my ($self, $env) = @_;
  my $session = Plack::Session->new($env);

  my $handlers = {
    $self->login_path => sub {
      my $env = shift;
      my $request = Plack::Request->new($env);
      my $response = $request->new_response(200);
      my $consumer = $self->consumer;
      my $verifier = $request->parameters->{"oauth_verifier"};
      if ($verifier) {
        my $access_token = $consumer->get_access_token(
          token    => $session->get("oauth_request_token"),
          verifier => $verifier,
        ) or die $consumer->errstr;
        $session->remove("oauth_request_token");

        {
          my $res = $consumer->request(
            method => "GET",
            url    => "https://api.twitter.com/1.1/account/verify_credentials.json",
            token  => $access_token,
          );
          $res->is_success or die;
          my $user_info = decode_json($res->decoded_content || $res->content);
          my $user_info = {
            screen_name => $user_info->{screen_name},
            id          => $user_info->{id},
          };
          $session->set(twitter_user_info => $user_info);
        }
        $response->redirect($session->get("oauth_location") || '/' );
        $session->remove("oauth_location");
      } else {
        my $request_token = $self->consumer->get_request_token(
          callback_url => [ split(/\?/, $request->uri, 2) ]->[0],
        ) or die $consumer->errstr;

        $session->set(oauth_request_token => $request_token);
        $session->set(oauth_location => $request->parameters->{location});
        $response->redirect($consumer->url_to_authorize(token => $request_token));

      }
      $response->finalize;
    },

    $self->logout_path => sub {
      my $env = shift;
      my $request = Plack::Request->new($env);
      my $response = $request->new_response(200);
      $session->remove("twitter_user_info");
      $response->redirect("/");
      $response->finalize;
    }
  };

  my $user_info = ($session->get("twitter_user_info") || {});
  $env->{"twitter.user_info"} = $user_info;
  ($handlers->{$env->{PATH_INFO}} || $self->app)->($env);
}

1;
