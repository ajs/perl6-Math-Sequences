use v6.c;

use Test;

use Math::Sequences::Numberphile :ALL;

plan 16;

cmp-ok topologically-ordered-numbers[^5], '~~', [1, 4, 8, 48, 88], "topologically-ordered-numbers";
is topologically-ordered-numbers(:radix(16))[4], :16<88>, "base 16 topologically-ordered-numbers";
cmp-ok @A249572[^10], '~~', [1, 4, 8, 48, 88, 488, 888, 4888, 8888, 48888];
