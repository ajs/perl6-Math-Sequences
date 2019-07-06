use v6.c;

use Test;

use Math::Sequences::Integer :support;

sub postfix:<!>($n) { [*] 1..$n }

plan 34;

is 10 choose 3, 10! / (3! * (10-3)!), "choose";
is 10 ichoose 3, 10! div (3! * (10-3)!), "choose";
# euler-up-down($i)
# binpart($n)

is factors(2), (2), "factors(10)";
is factors(4), (2,2), "factors(4)";
is factors(10), (2,5), "factors(10)";
is factors(12), (2,2,3), "factors(12)";
is factors(13), (13), "factors(13)";

is-deeply prime-factors(1), (), "prime-factors(1)";
is-deeply prime-factors(2), factors(2), "prime-factors(2)";
is-deeply prime-factors(4), factors(4), "prime-factors(4)";
is-deeply prime-factors(10), factors(10), "prime-factors(10)";
is-deeply prime-factors(12), factors(12), "prime-factors(12)";
is-deeply prime-factors(13), factors(13), "prime-factors(13)";

is-deeply prime-signature(1), bag(), "prime-signature(1)";
is-deeply prime-signature(2), bag(1), "prime-signature(2)";
is-deeply prime-signature(3), bag(1), "prime-signature(3)";
is-deeply prime-signature(4), bag(2), "prime-signature(4)";
is-deeply prime-signature(5), bag(1), "prime-signature(5)";
is-deeply prime-signature(6), bag(1,1), "prime-signature(6)";
is-deeply prime-signature(12), bag(1,2), "prime-signature(12)";
is-deeply prime-signature(16), bag(4), "prime-signature(16)";
is-deeply prime-signature(18), bag(2,1), "prime-signature(18)";
is-deeply prime-signature(30), bag(1,1,1), "prime-signature(30)";
is-deeply prime-signature(40), bag(3,1), "prime-signature(40)";
is-deeply prime-signature(100), bag(2,2), "prime-signature(100)";

is divisors(2), (1,2), "divisors(2)";
is divisors(4), (1,2,4), "divisors(4)";
is divisors(10), (1,2,5,10), "divisors(10)";
is divisors(13), (1,13), "divisors(13)";

is sigma(1), 1, "sigma(1)";
is sigma(2), 3, "sigma(2)";
is sigma(3), 4, "sigma(3)";
is sigma(4), 7, "sigma(4)";
cmp-ok strict-partitions(10).sort, &infix:<~~>,
    sort(
        [10], [9,1], [8,2], [7,3], [6,4], [7,2,1], [6,3,1], [5,4,1],
        [5,3,2], [4,3,2,1]), "strict-partitions(10)"
