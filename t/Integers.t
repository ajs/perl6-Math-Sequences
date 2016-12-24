use Math::Sequences::Integer; # -*- mode: perl6 -*-

use Test;

plan(3);

is ℤ.elems, Inf, "Infinite integers";
is ℤ.of, ::Int, "Integers are Ints";
is ℤ.Str, "ℤ", "Integers are named ℤ";

#A few more tests would be needed
is $sequence-Fibonacci[5], 5, "Fibonacci is OK up to 5";

# vim: sw=4 softtabstop=4 expandtab ai ft=perl6
