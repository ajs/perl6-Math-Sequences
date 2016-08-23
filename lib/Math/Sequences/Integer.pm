# Integer sequences
#
# This module is absolutely not meant to be exhausive.
# It should contain only those sequences that are frequently needed.

unit module Math::Sequences::Integer;

use nqp;

class Integers is Range is export {
    multi method new(
            $min = -Inf,
            $max = Inf,
            :$excludes-min = True,
            :$excludes-max = True) {
        #Seems as if this doesn't get passed on correctly...
        #nextwith $min, $max, :$excludes-min, :$excludes-max
        self.Range::new($min, $max, :$excludes-min, :$excludes-max);
    }

    method is-default {
        self.min == -Inf and self.max == Inf and
            self.excludes-min and self.excludes-max;
    }

    method symbol { "ℤ" }
    method gist {
        if self.is-default {
            self.symbol;
        } else {
            my $emin = self.excludes-min ?? '^' !! '';
            my $emax = self.excludes-max ?? '^' !! '';
            "{self.^name}({self.min}{$emin}..{$emax}{self.max})"
        }
    }

    method !params {
        self.min.perl, self.max.perl,
            |(<excludes-min excludes-max>.map: -> $param {
                ":{$param}(" ~ self."$param"() ~ ')'
            });
    }

    method perl {
        "Integers.new(" ~ self!params.join(",") ~ ")"
    }

    method !min-countable {
        self.min.succ > self.min;
    }

    # An iterator based on the current range (full of fail)
    method iterator {
        my $offset = self.excludes-min ?? 1 !! 0;
        my $countable = self!min-countable;
        my &endcmp = self.excludes-max ?? &infix:<< > >> !! &infix:<< >= >>;
        my &traverse = sub {
            my $count = (state $n = 0)++;

            my $next = self.min + $count + $offset;
            if endcmp($next, self.max) {
                IterationEnd;
            } elsif $count == 0 and $offset == 0 {
                self.min;
            } elsif !$countable {
                fail "Cannot count from non-finite starting point";
            } else {
                $next;
            }
        }
        class :: does Iterator {
            method new()      { nqp::create(self) }
            method pull-one() { traverse }
            method is-lazy()  { True  }
        }.new
    }

    # All of the integers >= $n
    method from(Int $n) {
        my $min = $n;
        my $max = self.max;
        my $excludes-min = self.excludes-min;
        my $excludes-max = self.excludes-max;

        self.WHAT.new($min, $max, :$excludes-min, :$excludes-max);
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
    method new(
            $min = 0,
            $max = Inf,
            :$excludes-min = False,
            :$excludes-max = True) {
        nextwith $min, $max, :$excludes-min, :$excludes-max
    }

    method symbol { 'ℕ' }
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
sub infix:<choose>($n, $p) { [*] ($n ... 0) Z/ 1 .. $p }
sub infix:<ichoose>($n,$p --> Int) { ($n choose $p).floor }

# Per OEIS A000111:
# 2*a(n+1) = Sum_{k=0..n} binomial(n, k)*a(k)*a(n-k).
sub euler-up-down($i) {
    given $i-1 {
        when * < 2 { 1 }
        default {
            my $sum = [+] (0..$_).map: -> $k {
                ($_ ichoose $k) * euler-up-down($k) * euler-up-down($_-$k) };
            $sum div 2;
        }
    }
}


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
our @A000040 is export = lazy ℕ.grep: {.is-prime};
# A000041 / partitions
our @A000041 is export = 1, 1, 2, 3, 5, 7, 11, 15, 22, 30, 42, &NOSEQ ... *;
# A000043 / Mersenne
our @A000043 is export = lazy ℕ.grep: { (2**$_-1).is-prime };
# A000045 / Fibonacci
our @A000045 is export = 0, 1, * + * ... *;
# A000048 / necklaces
our @A000048 is export = 1, 1, 1, 1, 2, 3, 5, 9, 16, 28, 51, &NOSEQ ... *;
# A000055 / trees
our @A000055 is export = 1, 1, 1, 1, 2, 3, 6, 11, 23, 47, 106, &NOSEQ ... *;
# A000058 / Sylvester
our @A000058 is export = 2, { $_**2 - $_ + 1 } ... *;
# A000069 / odious
our @A000069 is export = lazy ℕ.grep: -> $n { ([+] $n.base(2).comb) !%% 2 };
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
our @A000108 is export = lazy ℕ.map: {(2*$^n choose $^n)/($^n+1)};
# A000109 / polyhedra
our @A000109 is export = 1, 1, 1, 2, 5, 14, 50, 233, 1249, 7595, &NOSEQ ... *;
# A000110 / Bell
our @A000110 is export = 1, 1, 2, 5, 15, 52, 203, 877, 4140, &NOSEQ ... *;
# A000111 / Euler
our @A000111 is export = ℕ.map: {euler-up-down($_)};
# A000112 / posets
our @A000112 is export = 1, 1, 2, 5, 16, 63, 318, 2045, 16999, &NOSEQ ... *;
# A000120 / 1's in n
our @A000120 is export = 1, &NOSEQ ... *;
# A000123 / binary partitions
our @A000123 is export = 1, &NOSEQ ... *;
# A000124 / Lazy Caterer
our @A000124 is export = 1, &NOSEQ ... *;
# A000129 / Pell
our @A000129 is export = 1, &NOSEQ ... *;
# A000140 / Kendall-Mann
our @A000140 is export = 1, &NOSEQ ... *;
# A000142 / n!
our @A000142 is export = 1, &NOSEQ ... *;
# A000161 / partitions into 2 squares
our @A000161 is export = 1, &NOSEQ ... *;
# A000166 / derangements
our @A000166 is export = 1, &NOSEQ ... *;
# A000169 / labeled rooted trees
our @A000169 is export = 1, &NOSEQ ... *;
# A000182 / tangent
our @A000182 is export = 1, &NOSEQ ... *;
# A000203 / sigma
our @A000203 is export = 1, &NOSEQ ... *;
# A000204 / Lucas
our @A000204 is export = 1, &NOSEQ ... *;
# A000217 / triangular
our @A000217 is export = 1, &NOSEQ ... *;
# A000219 / planar partitions
our @A000219 is export = 1, &NOSEQ ... *;
# A000225 / 2^n-1
our @A000225 is export = 1, &NOSEQ ... *;
# A000244 / 3^n
our @A000244 is export = 1, &NOSEQ ... *;
# A000262 / sets of lists
our @A000262 is export = 1, &NOSEQ ... *;
# A000272 / n^(n-2)
our @A000272 is export = 1, &NOSEQ ... *;
# A000273 / directed graphs
our @A000273 is export = 1, &NOSEQ ... *;
# A000290 / n^2
our @A000290 is export = 1, &NOSEQ ... *;
# A000292 / tetrahedral
our @A000292 is export = 1, &NOSEQ ... *;
# A000302 / 4^n
our @A000302 is export = 1, &NOSEQ ... *;
# A000311 / Schroeder's fourth
our @A000311 is export = 1, &NOSEQ ... *;
# A000312 / mappings
our @A000312 is export = 1, &NOSEQ ... *;
# A000326 / pentagonal
our @A000326 is export = 1, &NOSEQ ... *;
# A000330 / square pyramidal
our @A000330 is export = 1, &NOSEQ ... *;
# A000364 / Euler or secant
our @A000364 is export = 1, &NOSEQ ... *;
# A000396 / perfect
our @A000396 is export = 1, &NOSEQ ... *;
# A000521 / j
our @A000521 is export = 1, &NOSEQ ... *;
# A000578 / n^3
our @A000578 is export = 1, &NOSEQ ... *;
# A000583 / n^4
our @A000583 is export = 1, &NOSEQ ... *;
# A000593 / sum odd divisors
our @A000593 is export = 1, &NOSEQ ... *;
# A000594 / Ramanujan tau
our @A000594 is export = 1, &NOSEQ ... *;
# A000602 / hydrocarbons
our @A000602 is export = 1, &NOSEQ ... *;
# A000609 / threshold functions
our @A000609 is export = 1, &NOSEQ ... *;
# A000670 / preferential arrangements
our @A000670 is export = 1, &NOSEQ ... *;
# A000688 / abelian groups
our @A000688 is export = 1, &NOSEQ ... *;
# A000720 / pi(n)
our @A000720 is export = 1, &NOSEQ ... *;
# A000793 / Landau
our @A000793 is export = 1, &NOSEQ ... *;
# A000796 / Pi
our @A000796 is export = 1, &NOSEQ ... *;
# A000798 / quasi-orders or topologies
our @A000798 is export = 1, &NOSEQ ... *;
# A000959 / Lucky
our @A000959 is export = 1, &NOSEQ ... *;
# A000961 / prime powers
our @A000961 is export = 1, &NOSEQ ... *;
# A000984 / binomial(2n,n)
our @A000984 is export = ℕ.map: {2*$^n choose $^n};
# A001003 / Schroeder's second problem
our @A001003 is export = 1, &NOSEQ ... *;
# A001006 / Motzkin
our @A001006 is export = 1, &NOSEQ ... *;
# A001034 / simple groups
our @A001034 is export = 1, &NOSEQ ... *;
# A001037 / irreducible polynomials
our @A001037 is export = 1, &NOSEQ ... *;
# A001045 / Jacobsthal
our @A001045 is export = 1, &NOSEQ ... *;
# A001055 / multiplicative partition function
our @A001055 is export = 1, &NOSEQ ... *;
# A001065 / sum of divisors
our @A001065 is export = 1, &NOSEQ ... *;
# A001057 / all integers
our @A001057 is export = 1, &NOSEQ ... *;
# A001097 / twin primes
our @A001097 is export = 1, &NOSEQ ... *;
# A001113 / e
our @A001113 is export = 1, &NOSEQ ... *;
# A001147 / double factorials
our @A001147 is export = 1, &NOSEQ ... *;
# A001157 / sum of squares of divisors
our @A001157 is export = 1, &NOSEQ ... *;
# A001190 / Wedderburn-Etherington
our @A001190 is export = 1, &NOSEQ ... *;
# A001221 / omega
our @A001221 is export = 1, &NOSEQ ... *;
# A001222 / Omega
our @A001222 is export = 1, &NOSEQ ... *;
# A001227 / odd divisors
our @A001227 is export = 1, &NOSEQ ... *;
# A001285 / Thue-Morse
our @A001285 is export = 1, &NOSEQ ... *;
# A001333 / sqrt(2)
our @A001333 is export = 1, &NOSEQ ... *;
# A001349 / connected graphs
our @A001349 is export = 1, &NOSEQ ... *;
# A001358 / semiprimes
our @A001358 is export = 1, &NOSEQ ... *;
# A001405 / binomial(n,n/2)
our @A001405 is export = 1, &NOSEQ ... *;
# A001462 / Golomb
our @A001462 is export = 1, &NOSEQ ... *;
# A001477 / integers
our @A001477 is export = 1, &NOSEQ ... *;
# A001478 / negatives
our @A001478 is export = 1, &NOSEQ ... *;
# A001481 / sums of 2 squares
our @A001481 is export = 1, &NOSEQ ... *;
# A001489 / negatives
our @A001489 is export = 1, &NOSEQ ... *;
# A001511 / ruler function
our @A001511 is export = 1, &NOSEQ ... *;
# A001615 / sublattices
our @A001615 is export = 1, &NOSEQ ... *;
# A001699 / binary trees
our @A001699 is export = 1, &NOSEQ ... *;
# A001700 / binomial(2n+1, n+1)
our @A001700 is export = 1, &NOSEQ ... *;
# A001519 / Fib. bisection
our @A001519 is export = 1, &NOSEQ ... *;
# A001764 / binomial(3n,n)/(2n+1)
our @A001764 is export = 1, &NOSEQ ... *;
# A001906 / Fib. bisection
our @A001906 is export = 1, &NOSEQ ... *;
# A001969 / evil
our @A001969 is export = 1, &NOSEQ ... *;
# A002033 / perfect partitions
our @A002033 is export = 1, &NOSEQ ... *;
# A002083 / Narayana-Zidek-Capell
our @A002083 is export = 1, &NOSEQ ... *;
# A002106 / transitive perm. groups
our @A002106 is export = 1, &NOSEQ ... *;
# A002110 / primorials
our @A002110 is export = 1, &NOSEQ ... *;
# A002113 / palindromes
our @A002113 is export = 1, &NOSEQ ... *;
# A002275 / repunits
our @A002275 is export = 1, &NOSEQ ... *;
# A002322 / psi
our @A002322 is export = 1, &NOSEQ ... *;
# A002378 / pronic
our @A002378 is export = 1, &NOSEQ ... *;
# A002426 / central trinomial coefficients
our @A002426 is export = 1, &NOSEQ ... *;
# A002487 / Stern
our @A002487 is export = 1, &NOSEQ ... *;
# A002530 / sqrt(3
our @A002530 is export = 1, &NOSEQ ... *;
# A002531 / sqrt(3
our @A002531 is export = 1, &NOSEQ ... *;
# A002572 / binary rooted trees
our @A002572 is export = 1, &NOSEQ ... *;
# A002620 / quarter-squares
our @A002620 is export = 1, &NOSEQ ... *;
# A002654 / re: sums of squares
our @A002654 is export = 1, &NOSEQ ... *;
# A002658 / 3-trees
our @A002658 is export = 1, &NOSEQ ... *;
# A002808 / composites
our @A002808 is export = 1, &NOSEQ ... *;
# A003094 / connected planar graphs
our @A003094 is export = 1, &NOSEQ ... *;
# A003136 / Loeschian
our @A003136 is export = 1, &NOSEQ ... *;
# A003418 / LCM
our @A003418 is export = 1, &NOSEQ ... *;
# A003484 / Hurwitz-Radon
our @A003484 is export = 1, &NOSEQ ... *;
# A004011 / D_4
our @A004011 is export = 1, &NOSEQ ... *;
# A004018 / square lattice
our @A004018 is export = 1, &NOSEQ ... *;
# A004526 / ints repeated
our @A004526 is export = 1, &NOSEQ ... *;
# A005036 / dissections
our @A005036 is export = 1, &NOSEQ ... *;
# A005100 / deficient
our @A005100 is export = 1, &NOSEQ ... *;
# A005101 / abundant
our @A005101 is export = 1, &NOSEQ ... *;
# A005117 / squarefree
our @A005117 is export = 1, &NOSEQ ... *;
# A005130 / Robbins
our @A005130 is export = 1, &NOSEQ ... *;
# A005230 / Stern
our @A005230 is export = 1, &NOSEQ ... *;
# A005408 / odd
our @A005408 is export = 1, &NOSEQ ... *;
# A005470 / planar graphs
our @A005470 is export = 1, &NOSEQ ... *;
# A005588 / binary rooted trees
our @A005588 is export = 1, &NOSEQ ... *;
# A005811 / runs in n
our @A005811 is export = 1, &NOSEQ ... *;
# A005843 / even
our @A005843 is export = 1, &NOSEQ ... *;
# A006318 / royal paths or Schroeder numbers
our @A006318 is export = 1, &NOSEQ ... *;
# A006530 / largest prime factor
our @A006530 is export = 1, &NOSEQ ... *;
# A006882 / n!!
our @A006882 is export = 1, &NOSEQ ... *;
# A006894 / 3-trees
our @A006894 is export = 1, &NOSEQ ... *;
# A006966 / lattices
our @A006966 is export = 1, &NOSEQ ... *;
# A007318 / Pascal's triangle
our @A007318 is export = 1, &NOSEQ ... *;
# A008275 / Stirling 1
our @A008275 is export = 1, &NOSEQ ... *;
# A008277 / Stirling 2
our @A008277 is export = 1, &NOSEQ ... *;
# A008279 / permutations k at a time
our @A008279 is export = 1, &NOSEQ ... *;
# A008292 / Eulerian
our @A008292 is export = 1, &NOSEQ ... *;
# A008683 / Moebius
our @A008683 is export = 1, &NOSEQ ... *;
# A010060 / Thue-Morse
our @A010060 is export = 1, &NOSEQ ... *;
# A018252 / nonprimes
our @A018252 is export = 1, &NOSEQ ... *;
# A020639 / smallest prime factor
our @A020639 is export = 1, &NOSEQ ... *;
# A020652 / fractal
our @A020652 is export = 1, &NOSEQ ... *;
# A020653 / fractal
our @A020653 is export = 1, &NOSEQ ... *;
# A027641 / Bernoulli
our @A027641 is export = 1, &NOSEQ ... *;
# A027642 / Bernoulli
our @A027642 is export = 1, &NOSEQ ... *;
# A035099 / j_2
our @A035099 is export = 1, &NOSEQ ... *;
# A038566 / fractal
our @A038566 is export = 1, &NOSEQ ... *;
# A038567 / fractal
our @A038567 is export = 1, &NOSEQ ... *;
# A038568 / fractal
our @A038568 is export = 1, &NOSEQ ... *;
# A038569 / fractal
our @A038569 is export = 1, &NOSEQ ... *;
# A049310 / Chebyshev
our @A049310 is export = 1, &NOSEQ ... *;
# A055512 / lattices
our @A055512 is export = 1, &NOSEQ ... *;
# A070939 / binary length
our @A070939 is export = 1, &NOSEQ ... *;
# A074206 / ordered factorizations
our @A074206 is export = 1, &NOSEQ ... *;
# A104725 / complementing systems
our @A104725 is export = 1, &NOSEQ ... *;
# A226898 / Hooley's Delta
our @A226898 is export = 1, &NOSEQ ... *;
# A246655 / prime powers
our @A246655 is export = 1, &NOSEQ ... *;



# vim: sw=4 softtabstop=4 expandtab ai ft=perl6
