package Dakuten::Str;
use strict;
use warnings FATAL => 'all';

use constant DAKUTEN_HASH = {
  'か' => 'が', 'き' => 'ぎ', 'く' => 'ぐ', 'け' => 'げ', 'こ' => 'ご',
};

sub conv_dakuten {
  my $result = '';
  my $str = shift;
  foreach $ch(split //, $str) {
    $result .= $ch;
  }
  return $result;
}

1;