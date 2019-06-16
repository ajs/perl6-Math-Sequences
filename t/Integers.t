use Math::Sequences::Integer; # -*- mode: perl6 -*-

use Test;

plan(11);

is ℤ.elems, Inf, "Infinite integers";
is ℤ.of, ::Int, "Integers are Ints";
is ℤ.Str, "ℤ", "Integers are named ℤ";

#A few more tests would be needed
is %oeis-core<fibonacci>[5], 5, "Fibonacci is OK up to 5";
is %oeis-core<lucas>[8], 47, "Lucas is OK up to 8";
is @A085939[6], 2992, "Horadam-1 OK up to 6";
is %oeis-core<hofstadters-g>[10], 6, "Hofstadter's G up to 10";
is %oeis-core<hofstadters-h>[16], 11, "Hofstadter's H up to 11";
is OEIS('primes')[2], 5, "third prime (5)";
my %primes = OEIS('prime', :search);
my @prime-keys = <prime-powers primes-less-than-n primes prime-powers-from-zero>;
cmp-ok %primes.keys, '~~', set(@prime-keys), "Search for names of prime sequences";
cmp-ok %primes.map(*.value[0]), '~~', set(0,1,2,2), "Search for sequences 'prime'";

done-testing;
# vim: sw=4 softtabstop=4 expandtab ai ft=perl6
