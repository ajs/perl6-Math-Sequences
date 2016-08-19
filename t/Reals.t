use Math::Sequences::Real;

use Test;

plan(3);

is ℝ.elems, Inf, "Infinite reals";
is ℝ.of, ::Real, "Reals get Real";
is ℝ.Str, "ℝ", "Reals are named ℝ";

# vim: sw=4 softtabstop=4 expandtab ai ft=perl6
