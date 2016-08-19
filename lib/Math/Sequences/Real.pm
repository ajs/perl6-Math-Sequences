# Real sequences

unit module Math::Sequences::Real;

class Reals is Range is export {
    method new { nextwith :min(-Inf), :max(Inf) }
    method iterator { (-Inf, {fail "Reals are uncountable"} ... Inf).iterator }
    method of { ::Num }
    # This is a slight lie, it's actually 2^ℵ0
    method Numeric { Inf }
    method Str { "ℝ" }
    method is-int { False }
    method infinite { True }
}

my constant \ℝ is export = Reals.new;

# vim: sw=4 softtabstop=4 expandtab ai ft=perl6
