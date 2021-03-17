#!/usr/bin/env perl
use v5.24.1;
use Mojolicious::Lite -signatures;
use Data::Dumper;
use Mojo::JSON qw(decode_json encode_json);

sub is_local {
  my $env = $ENV{APP_ENV};

  return $env == 'local';
}

sub is_verify {
  my ($request_body, $timestamp, $logger) = @_;
  my $duration = DateTime->now - DateTime->from_epoch(epoch => $timestamp);
  $logger->debug(Dumper $duration->strftime("%T"));

  if (is_local()) {
    return 1
  }

  my $slack_signing_secret = $ENV{SLACK_SIGNING_SECRET};

  return 0;
}

post '/ping' => sub {
  my $c = shift;

  my $req = $c->req;
  my $params = $req->params;
  my $headers = $req->headers;
  my $timestamp = $headers->header('x-slack-request-timestamp');
  $c->log->debug(Dumper {params => $params->to_string, timestamp => $timestamp, localtime => localtime($timestamp)});

  my $res = {text => '', response_type => 'in_channel'};
  unless (is_verify($params->to_string, $timestamp, $c->log)) {
    $c->render(json => $res);
    $c->log->debug('unless verify');
    return
  }

  $res->{text} = 'pong';
  $c->render(json => $res);

  $c->log->info('success');
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
