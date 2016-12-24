use Math::Sequences::Integer; # -*- mode: perl6 -*-

use Test;

plan(5);

is ℤ.elems, Inf, "Infinite integers";
is ℤ.of, ::Int, "Integers are Ints";
is ℤ.Str, "ℤ", "Integers are named ℤ";

#A few more tests would be needed
is @sequence-Fibonacci[5], 5, "Fibonacci is OK up to 5";
is @sequence-Lucas[8], 47, "Lucas is OK up to 8";

done-testing;
# vim: sw=4 softtabstop=4 expandtab ai ft=perl6
