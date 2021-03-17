use strict;
use warnings FATAL => 'all';
use Test::More;

use lib './lib';
use Dakuten::Util;

subtest 'sample test' => sub {
  is(length('perl'), 4, 'length test');
  is(Dakuten::Util::sum(1, 2), 3, 'sum test');
};

done_testing();
