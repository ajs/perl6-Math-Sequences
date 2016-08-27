use Math::Sequences::Integer;

use Test;

plan 3;

subtest {
    plan 10;

    is I.elems, Inf, "Infinite naturals";
    is I.of, ::Int, "Naturals are Ints";
    is I.Str, "I", "Naturals are named ℕ";
    is I[1], 1, "Indexing ℕ";
    for I -> $i {
        state $n = 0;
        is $i, $n, "ℕ[$n] should be $n";
        last if $n++ > 2;
    }
    is I.min, 0, "I.min zero";
    is I.max, Inf, "I.min infinite";
}, "I";

subtest {
    plan 5;

    is ℕ[0], 1, "Whole numbers[0]";
    is ℕ[1], 2, "Whole numbers[1]";
    is ℕ[2], 3, "Whole numbers[2]";
    is ℕ.min, 1, "Wholes.min 1";
    is ℕ.max, Inf, "Wholes.max infinite";
}, "ℕ";

is I.from(20)[1], 21, "Arbitrary starting point";

# vim: sw=4 softtabstop=4 expandtab ai ft=perl6
