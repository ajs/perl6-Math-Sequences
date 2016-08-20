# Integer sequences
#
# This module is absolutely not meant to be exhausive.
# It should contain only those sequences that are frequently needed.

unit module Math::Sequences::Integer;

class Integers is Range is export {
    my $name = "ℤ";

    multi method new(
            :$min = -Inf,
            :$max = Inf,
            :$excludes-min = True,
            :$excludes-max = True) {
        say "MOO";
        nextwith :$min, :$max, :$excludes-min, :$excludes-max
    }

    method is-default {
        self.min == -Inf and self.max == Inf and
            self.excludes-min and self.excludes-max;
    }

    method gist {
        if self.is-default {
            self.name;
        } else {
            my $emin = self.excludes-min ?? '^' !! '';
            my $emax = self.excludes-max ?? '^' !! '';
            "{self.^name}({self.min}{$emin}..{$emax}{self.max})"
        }
    }

    method !params {
        <min max excludes-min excludes-max>.map: -> $param {
            ":{$param}(" ~ self."$param"() ~ ')'
        }
    }

    method perl {
        "Integers.new(" ~ self!params.join(",") ~ ")"
    }

    method !min-countable {
        self.min.succ > self.min;
    }

    # An iterator based on the current range (full of fail)
    method iterator {
        my $counter = self!min-countable ??
            { $^prev + 1 } !!
            { fail "Cannot count from infinity" };
        my $min = self.excludes-min ?? self.min.succ !! self.min;
        my $op = self.excludes-max ?? &infix:<...^> !! &infix:<...>;
        my $seq = $op((self.min, $counter), self.max);
        $seq.iterator
    }

    # All of the integers >= $n
    method from(Int $n) {
        my $min = $n;
        my $max = self.max;
        my $excludes-min = self.excludes-min;
        my $excludes-max = self.excludes-max;

        self.WHAT.new(:$min, :$max, :$excludes-min, :$excludes-max);
    }

    method of { ::Int }
    method Numeric { Inf }
    method is-int { True }
    method infinite { True }
    method elems { Inf }
    method Str { self.gist }
}

# Naturals can mean 1..Inf or 0..Inf. Since
# choosing 0..Inf lets us name the other
# "wholes" and cover all our bases, we go
# that way, but there is no "right" answer
# in mathematics.
class Naturals is Integers is export {
    my $name = 'ℕ';

    method new(
            :$min = 0,
            :$max = Inf,
            :$excludes-min = False,
            :$excludes-max = True) {
        nextwith :$min, :$max, :$excludes-min, :$excludes-max
    }

    method is-default {
        self.min == 0 and self.max == Inf and
            !self.excludes-min and self.excludes-max;
    }

    method from($n where * >= 0) { callsame }
}

our constant \ℤ is export = Integers.new;
our constant \ℕ is export = Naturals.new;
our $Wholes is export = ℕ.from(1);

#####
# Utilities for the OEIS entires:

# via:
# https://github.com/perl6/perl6-examples/blob/master/categories/best-of-rosettacode/binomial-coefficient.pl
sub infix:<choose> { [*] ($^n ... 0) Z/ 1 .. $^p }

# If we don't yet have a formula for a given sequence, we use &NOSEQ in a
# range to define where our canned data ends. Because we use "fail", the
# failure only happens if you try to use a value past the end of our known
# entries.
my &NOSEQ = { fail "This sequence has not yet been defined" };

# These are the "core" OEIS sequences as defined here:
# http://oeis.org/wiki/Index_to_OEIS:_Section_Cor
#

# groups
our @A000001 is export = 0, 1, 1, 1, 2, 1, 2, 1, 5, 2, 2, 1, &NOSEQ ... *;
# Kolakoski
our @A000002 is export = 1, 2, 2, 1, 1, 2, 1, 2, 2, 1, 2, 2, &NOSEQ ... *;
# A000004 / 0's
our @A000004 is export = 0 xx *;
# A000005 / divisors
our @A000005 is export = $Wholes.map: -> $n { (((1..$n) X (1..$n)).grep: -> ($a,$b) { $a*$b == $n }).elems };
# A000007 / 0^n
our @A000007 is export = ℕ.map: -> $n { 0 ** $n };
# A000009 / distinct partitions
our @A000009 is export = 1, 1, 1, 2, 2, 3, 4, 5, 6, 8, 10, 12, &NOSEQ ... *;
# A000010 / totient
our @A000010 is export = 1, 1, 2, 2, 4, 2, 6, 4, 6, 4, 10, 4, &NOSEQ ... *;
# A000012 / 1's
our @A000012 is export = 1 xx *;
# A000014 / series-reduced trees
our @A000014 is export = 0, 1, 1, 0, 1, 1, 2, 2, 4, 5, 10, 14, &NOSEQ ... *;
# A000019 / prim. perm. groups
our @A000019 is export = 1, 1, 2, 2, 5, 4, 7, 7, 11, 9, 8, 6, &NOSEQ ... *;
# A000027 / natural numbers
our @A000027 is export = ℕ;
# A000029 / necklaces
our @A000029 is export = 1, 2, 3, 4, 6, 8, 13, 18, 30, 46, 78, &NOSEQ ... *;
# A000031 / necklaces
our @A000031 is export = 1, 2, 3, 4, 6, 8, 14, 20, 36, 60, 108, &NOSEQ ... *;
# A000032 / Lucas
our @A000032 is export = 2, 1, * + * ... *;
# A000035 / 0101...
our @A000035 is export = |(0,1) xx *;
# A000040 / primes
our @A000040 is export = ℕ.grep: {.is-prime};
# A000041 / partitions
our @A000041 is export = 1, 1, 2, 3, 5, 7, 11, 15, 22, 30, 42, &NOSEQ ... *;
# A000043 / Mersenne
our @A000043 is export = ℕ.grep: { (2**$_-1).is-prime };
# A000045 / Fibonacci
our @A000045 is export = 0, 1, * + * ... *;
# A000048 / necklaces
our @A000048 is export = 1, 1, 1, 1, 2, 3, 5, 9, 16, 28, 51, &NOSEQ ... *;
# A000055 / trees
our @A000055 is export = 1, 1, 1, 1, 2, 3, 6, 11, 23, 47, 106, &NOSEQ ... *;
# A000058 / Sylvester
our @A000058 is export = 2, { $_**2 - $_ + 1 } ... *;
# A000069 / odious
our @A000069 is export = ℕ.grep: -> $n { ([+] $n.base(2).comb) !%% 2 };
# A000079 / 2^n
our @A000079 is export = 1, * * 2 ... *;
# A000081 / rooted trees
our @A000081 is export = 0, 1, 1, 2, 4, 9, 20, 48, 115, 286, &NOSEQ ... *;
# A000085 / self-inverse perms.
our @A000085 is export = 1, 1, -> $a,$b { state $n = 1; $b+($n++)*$a } ... *;
# A000088 / graphs
our @A000088 is export = 1, 1, 2, 4, 11, 34, 156, 1044, 12346, &NOSEQ ... *;
# A000105 / polyominoes
our @A000105 is export = 1, 1, 1, 2, 5, 12, 35, 108, 369, 1285, &NOSEQ ... *;
# A000108 / Catalan
our @A000108 is export = ℕ.map: {(2*$^n choose $^n)/($^n+1)};
# A000109 / polyhedra
our @A000109 is export = 1, 1, 1, 2, 5, 14, 50, 233, 1249, 7595, &NOSEQ ... *;
# A000110 / Bell
our @A000110 is export = 1, 1, 2, 5, 15, 52, 203, 877, 4140, &NOSEQ ... *;
# A000111 / Euler
# A000112 / posets
our @A000112 is export = 1, 1, 2, 5, 16, 63, 318, 2045, 16999, &NOSEQ ... *;
# A000120 / 1's in n
# A000123 / binary partitions
# A000124 / Lazy Caterer
# A000129 / Pell
# A000140 / Kendall-Mann
# A000142 / n!
# A000161 / partitions into 2 squares
# A000166 / derangements
# A000169 / labeled rooted trees
# A000182 / tangent
# A000203 / sigma
# A000204 / Lucas
# A000217 / triangular
# A000219 / planar partitions
# A000225 / 2^n-1
# A000244 / 3^n
# A000262 / sets of lists
# A000272 / n^(n-2)
# A000273 / directed graphs
# A000290 / n^2
# A000292 / tetrahedral
# A000302 / 4^n
# A000311 / Schroeder's fourth
# A000312 / mappings
# A000326 / pentagonal
# A000330 / square pyramidal
# A000364 / Euler or secant
# A000396 / perfect
# A000521 / j
# A000578 / n^3
# A000583 / n^4
# A000593 / sum odd divisors
# A000594 / Ramanujan tau
# A000602 / hydrocarbons
# A000609 / threshold functions
# A000670 / preferential arrangements
# A000688 / abelian groups
# A000720 / pi(n)
# A000793 / Landau
# A000796 / Pi
# A000798 / quasi-orders or topologies
# A000959 / Lucky
# A000961 / prime powers
# A000984 / binomial(2n,n)
our @A000984 is export = ℕ.map: {2*$^n choose $^n};
# A001003 / Schroeder's second problem
# A001006 / Motzkin
# A001034 / simple groups
# A001037 / irreducible polynomials
# A001045 / Jacobsthal
# A001055 / multiplicative partition function
# A001065 / sum of divisors
# A001057 / all integers
# A001097 / twin primes
# A001113 / e
# A001147 / double factorials
# A001157 / sum of squares of divisors
# A001190 / Wedderburn-Etherington
# A001221 / omega
# A001222 / Omega
# A001227 / odd divisors
# A001285 / Thue-Morse
# A001333 / sqrt(2)
# A001349 / connected graphs
# A001358 / semiprimes
# A001405 / binomial(n,n/2)
# A001462 / Golomb
# A001477 / integers
# A001478 / negatives
# A001481 / sums of 2 squares
# A001489 / negatives
# A001511 / ruler function
# A001615 / sublattices
# A001699 / binary trees
# A001700 / binomial(2n+1, n+1)
# A001519 / Fib. bisection
# A001764 / binomial(3n,n)/(2n+1)
# A001906 / Fib. bisection
# A001969 / evil
# A002033 / perfect partitions
# A002083 / Narayana-Zidek-Capell
# A002106 / transitive perm. groups
# A002110 / primorials
# A002113 / palindromes
# A002275 / repunits
# A002322 / psi
# A002378 / pronic
# A002426 / central trinomial coefficients
# A002487 / Stern
# A002530 / sqrt(3
# A002531 / sqrt(3
# A002572 / binary rooted trees
# A002620 / quarter-squares
# A002654 / re: sums of squares
# A002658 / 3-trees
# A002808 / composites
# A003094 / connected planar graphs
# A003136 / Loeschian
# A003418 / LCM
# A003484 / Hurwitz-Radon
# A004011 / D_4
# A004018 / square lattice
# A004526 / ints repeated
# A005036 / dissections
# A005100 / deficient
# A005101 / abundant
# A005117 / squarefree
# A005130 / Robbins
# A005230 / Stern
# A005408 / odd
# A005470 / planar graphs
# A005588 / binary rooted trees
# A005811 / runs in n
# A005843 / even
# A006318 / royal paths or Schroeder numbers
# A006530 / largest prime factor
# A006882 / n!!
# A006894 / 3-trees
# A006966 / lattices
# A007318 / Pascal's triangle
# A008275 / Stirling 1
# A008277 / Stirling 2
# A008279 / permutations k at a time
# A008292 / Eulerian
# A008683 / Moebius
# A010060 / Thue-Morse
# A018252 / nonprimes
# A020639 / smallest prime factor
# A020652 / fractal
# A020653 / fractal
# A027641 / Bernoulli
# A027642 / Bernoulli
# A035099 / j_2
# A038566 / fractal
# A038567 / fractal
# A038568 / fractal
# A038569 / fractal
# A049310 / Chebyshev
# A055512 / lattices
# A070939 / binary length
# A074206 / ordered factorizations
# A104725 / complementing systems
# A226898 / Hooley's Delta
# A246655 / prime powers



# vim: sw=4 softtabstop=4 expandtab ai ft=perl6
