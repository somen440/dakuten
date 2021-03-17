package Dakuten::Time;
use strict;
use warnings FATAL => 'all';

sub has_passed {
  my ($a, $b, $interval_minites) = @_;
  return $a->epoch >= $b->add(minutes => $interval_minites)->epoch;
}

1;