# Test the man module

use Math::Sequences;

use Test;

plan(3);

ok ℤ.defined, "Integers defined";
ok ℕ.defined, "Positive integers defined";
ok I.defined, "Naturals defined";
ok ℝ.defined, "Reals defined";

# vim: sw=4 softtabstop=4 expandtab ai ft=perl6
