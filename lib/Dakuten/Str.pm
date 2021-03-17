package Dakuten::Str;

use strict;
use warnings FATAL => 'all';
use Encode;

my $dakuten_hash = {
  'あ' => 'あ"', 'い' => 'い"', 'う' => 'う"', 'え' => 'え"', 'お' => 'お"',
  'か' => 'が', 'き' => 'ぎ', 'く' => 'ぐ', 'け' => 'げ', 'こ' => 'ご',
  'さ' => 'ざ', 'し' => 'じ', 'す' => 'ず', 'せ' => 'ぜ', 'そ' => 'ぞ',
  'た' => 'だ', 'ち' => 'ぢ', 'つ' => 'づ', 'て' => 'で', 'と' => 'ど',
  'は' => 'ば', 'ひ' => 'び', 'ふ' => 'ぶ', 'へ' => 'べ', 'ほ' => 'ぼ',
  'ん' => 'ん"',
  'ぁ' => 'ぁ"', 'ぃ' => 'ぃ"', 'ぅ' => 'ぅ"', 'ぇ' => 'ぇ"', 'ぉ' => 'ぉ"',
};

sub conv_dakuten {
  my $result = '';
  my $str = shift;
  utf8::decode($str); # 日本語として分割するために utf8 として認識させる必要がある
  foreach my $ch(split //, $str) {
    utf8::encode($ch);
    if (exists $dakuten_hash->{$ch}) {
      $result .= $dakuten_hash->{$ch};
    } else {
      $result .= $ch;
    }
  }
  return $result;
};

1;