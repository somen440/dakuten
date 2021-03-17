#!/usr/bin/env perl
use v5.24.1;
use Mojolicious::Lite -signatures;
use Data::Dumper;
use Mojo::JSON qw(decode_json encode_json);
use DateTime;
use Digest::SHA qw(hmac_sha256_hex);

sub is_local {
  my $env = $ENV{APP_ENV};
  if ($env == '') {
    # 特に指定がなければローカル扱い
    return 1;
  }

  return $env == 'local';
}

sub is_verify {
  my ($request_body, $headers, $logger) = @_;

  if (is_local()) {
    # ローカルではめんどくさいので検証済みとする
    return 1;
  }
  # クラウド環境での Slack 検証
  # @see https://api.slack.com/authentication/verifying-requests-from-slack

  my $timestamp = $headers->header('x-slack-request-timestamp');
  my $interval_minutes = 5;
  if (Dakuten::Calc::has_passed(DateTime->now, DateTime->from_epoch(epoch => $timestamp), $interval_minutes)) {
    # リクエストから5分経過
    # リプレイ攻撃の可能性があるので無視推奨とのこと
    return 0;
  }

  # v0 はバージョンで固定らしい
  my $slack_signature = $headers->header('x-slack-signature');
  my $slack_signing_secret = $ENV{SLACK_SIGNING_SECRET};
  my $sig_basestring = "v0:$timestamp:$request_body";
  my $my_signature = "v0=" . hmac_sha256_hex($sig_basestring, $slack_signing_secret);

  $logger->debug(Dumper {
    timestamp => $timestamp,
    slack_signature => $slack_signature,
    my_signatur => $my_signature,
  });

  return $slack_signature == $my_signature;
}

post '/ping' => sub {
  my $c = shift;

  my $req = $c->req;
  my $params = $req->params;
  my $headers = $req->headers;

  my $res = {text => '', response_type => 'in_channel'};
  unless (is_verify($params->to_string, $headers, $c->log)) {
    $c->render(json => $res);
    $c->log->debug('unless verify');
    return
  }

  $res->{text} = $params->param('text');
  $c->render(json => $res);
};
post '/hoge' => sub {
  my $c = shift;
  my $data = $c->req->json;
  my $hoge = $data->{'hoge'};
  $c->render(text => "Response: $hoge");
};
get '/hello' => sub {
  my $c = shift;
  my $user = $c->param('user');
  unless (defined $user) {
    $c->render(text => "Hello unknown");
    return
  }
  $c->render(text => "Hello $user");
};

my $port = $ENV{PORT};
if ($port eq '') {
  $port = '8080';
}

app->start('daemon', '-l', "http://*:$port");
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome';
<h1>Welcome to the Mojolicious real-time web framework!</h1>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>
