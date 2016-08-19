use Math::Sequences::Integer;

use Test;

plan 3;

subtest "ℕ", {
    plan 8;

    is ℕ.elems, Inf, "Infinite naturals";
    is ℕ.of, ::Int, "Naturals are Ints";
    is ℕ.Str, "ℕ", "Naturals are named ℕ";
    is ℕ[1], 1, "Indexing ℕ";
    for ℕ -> $i {
        state $n = 0;
        is $i, $n, "ℕ[$n] should be $n";
        last if $n++ > 2;
    }
}

is $Wholes[0], 1, "Whole numbers from 1";
is ℕ.from(20)[1], 21, "Arbitrary starting point";

# vim: sw=4 softtabstop=4 expandtab ai ft=perl6
