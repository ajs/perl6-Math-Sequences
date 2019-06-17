use v6.c;

use Test;

use Math::Sequences::Numberphile :ALL;

plan 6;

cmp-ok topologically-ordered-numbers[^5], '~~', [1, 4, 8, 48, 88], "topologically-ordered-numbers";
is topologically-ordered-numbers(:radix(16))[4], :16<88>, "base 16 topologically-ordered-numbers";
cmp-ok @A249572[^10], '~~', [1, 4, 8, 48, 88, 488, 888, 4888, 8888, 48888], "A249572[1-10]: typographical topology";
cmp-ok @A087409[^10], '~~', [61, 21, 82, 43, 3, 64, 24, 85, 46, 6], "A087409[1-10]: 6-shift";
cmp-ok @A002904[^10], '~~', [0, 0, 0, 0, 4, 9, 5, 1, 1, 0], "A002904[1-10]: Roman";
cmp-ok @A006933[^10], '~~', [2, 4, 6, 30, 32, 34, 36, 40, 42, 44], "A006933[1-10]: eban";
