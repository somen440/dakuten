use strict;
use warnings FATAL => 'all';
use Test::More;
use DateTime;
use Digest::SHA qw(hmac_sha256_hex);

use lib './lib';
use Dakuten::Calc;
use Dakuten::Time;
use Dakuten::Str;

subtest 'sample test' => sub {
  is(length('perl'), 4, 'length test');
  is(Dakuten::Calc::sum(1, 2), 3, 'sum test');
};

subtest 'array_hash' => sub {
  my @tests = (
    {title => 'case_1', 'a' => 1, 'b' => 2, 'expected' => 3},
    {title => 'case_2', 'a' => 11, 'b' => 22, 'expected' => 33},
  );
  foreach my $tt(@tests) {
    is(Dakuten::Calc::sum($tt->{'a'}, $tt->{'b'}), $tt->{'expected'}, $tt->{'title'});
  }
};

subtest 'datetime' => sub {
  my $dt = DateTime->new(
    year => 1964,
    month => 10,
    day => 16,
    hour => 16,
    minute => 12,
    second => 47,
  );
  is($dt->datetime, '1964-10-16T16:12:47', 'date format');

  my $dt2 = DateTime->from_epoch(epoch => 1615897110);
  is($dt2->datetime, '2021-03-16T12:18:30', 'from epoch');

  my @tests = (
    {title => '5 分経過した', add => 10, interval => 5, expected => 1},
    {title => '5 分経過した（境界）', add => 5, interval => 5, expected => 1},
    {title => '5 分経過してない', add => 4, interval => 5, expected => 0},
  );
  foreach my $tt(@tests) {
    my $a_dt = $dt->clone;
    my $b_dt = $a_dt->clone;
    $a_dt->add(minutes => $tt->{add});
    if ($tt->{expected}) {
      ok(Dakuten::Time::has_passed($a_dt, $b_dt, $tt->{interval}), $tt->{title})
    } else {
      ok(!Dakuten::Time::has_passed($a_dt, $b_dt, $tt->{interval}), $tt->{title})
    }
  }
};

subtest 'hmac sha256' => sub {
  my $base_text = 'hoge';
  my $test_secret = 'test_secret';

  my $hash = hmac_sha256_hex($base_text, $test_secret);

  is($hash, '4a001ae370a61160141796e3f94c5ea01cbc79757e4c370e78a793f5b2dfcae8', 'hash');
};

subtest 'test dakuten' => sub {
  my @tests = (
    {str => 'ががぎぎぐぐげげごご', expected => 'ががぎぎぐぐげげごご', title => '全て濁点のまま'},
    {str => 'かかききくくけけここ', expected => 'ががぎぎぐぐげげごご', title => '変換して全て濁点へ'},
    {str => 'たのしいいい', expected => 'だのじい"い"い"', title => '変換ありなし両方あり'},
  );
  foreach my $tt(@tests) {
    my $actual = Dakuten::Str::conv_dakuten($tt->{str});
    is($actual, $tt->{expected}, $tt->{title});
  }
};

done_testing();
