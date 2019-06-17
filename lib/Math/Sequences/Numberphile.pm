# Sequences that have been featured on Numberphile, but are not
# in the core sequences list.

use Math::Sequences::Integer :support, :DEFAULT;
use Math::Util::Roman;
use Math::Util::SpellNumbers;

# https://www.youtube.com/watch?v=OeGSQggDkxI

# A249572 - Least positive integer whose decimal digits divide the plane
# into n+1 regions. Otherwise read as the smallest positive integer that
# has n typographical holes in its digits.
# @ordering should contain the minimum, non-zero digit for each number of
# holes in its representation.
# $radix should contain the base to work in.
sub topologically-ordered-numbers(:@ordering=[<1 4 8>], :$radix=10) is export(:support) {
	lazy gather for 𝕀 -> $n {
		my $sum = 0;
		my $number = [~] reverse gather loop {
			my $order = min(@ordering.elems-1, $n-$sum);
			take @ordering[$order];
			$sum += $order;
			last if $sum == $n;
		};
		take parse-base($number, $radix);
	}
}

our @A249572 is export = topologically-ordered-numbers();

# A087409 - Multiples of 6 with digits grouped in pairs and leading
# zeros omitted.
sub digit-grouped-multiples(:$of, :$group=2) is export(:support) {
	lazy gather for ℕ.map({$^n * $of}) -> $multiple {
		state $accum = '';
		$accum ~= $multiple;
		if $accum.chars >= $group {
			take +$accum.substr(0,$group);
			$accum = $accum.substr($group);
		}
	}
}

our @A087409 is export = digit-grouped-multiples(:of(6), :group(2));

# A002904 - Delete all letters except c,d,i,l,m,v,x from n then read
# as Roman numeral if possible, otherwise 0.
our @A002904 is export = lazy gather for ℕ -> $n {
	my $name = as-words($n).subst(regex {<-[cdilmvx]>}, '', :i, :global);
	try {
		take from_roman($name);
		CATCH { when /'not valid'/ { take 0 }}
	}
}

# A006933 - 'Eban' numbers (the letter 'e' is banned!). 
sub contains-letters($number, $letters) is export(:support){
	return as-words(+$number).comb.grep: * ~~ $letters;
}
our @A006933 is export = ℕ.grep: {not contains-letters($^n, <e>)};

# A006567 - Emirps (primes whose reversal is a different prime).
our @A006567 is export = ℕ.grep: {
	my $rebmun = $^n.flip;
	$^n.is-prime and $^n ne $rebmun and $rebmun.is-prime };
