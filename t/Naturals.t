use Math::Sequences::Integer;

use Test;

plan 3;

subtest {
    plan 10;

    is ℕ.elems, Inf, "Infinite naturals";
    is ℕ.of, ::Int, "Naturals are Ints";
    is ℕ.Str, "ℕ", "Naturals are named ℕ";
    is ℕ[1], 1, "Indexing ℕ";
    for ℕ -> $i {
        state $n = 0;
        is $i, $n, "ℕ[$n] should be $n";
        last if $n++ > 2;
    }
    is ℕ.min, 0, "ℕ.min zero";
    is ℕ.max, Inf, "ℕ.min infinite";
}, "ℕ";

subtest {
    plan 5;

    is $Wholes[0], 1, "Whole numbers[0]";
    is $Wholes[1], 2, "Whole numbers[1]";
    is $Wholes[2], 3, "Whole numbers[2]";
    is $Wholes.min, 1, "Wholes.min 1";
    is $Wholes.max, Inf, "Wholes.max infinite";
}, "Wholes";

is ℕ.from(20)[1], 21, "Arbitrary starting point";

# vim: sw=4 softtabstop=4 expandtab ai ft=perl6
