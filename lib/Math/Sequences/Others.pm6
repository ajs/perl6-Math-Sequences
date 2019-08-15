# Sequences that have get used or referenced frequently, but are not
# in the other lists, here.

use Math::Sequences::Integer :support, :DEFAULT;

# Squares that are not squares of squares
my @low-squares = (2..200).grep(-> $n {$n.sqrt.Int² != $n}).map: *²;

# See https://en.wikipedia.org/wiki/Carmichael_number and
# https://oeis.org/A002997
# Using the method of A. Korselt 1899
# If :strict is passed, will not rely on .is-prime, though that means
# that the run-time is-carmichael($n) where $n is prime may be MUCH
# larger. This can be useful if you wish to have absolute certainty
# that the number is a Carmichael number.
sub is-carmichael(Cool:D $n, :$strict --> Bool) is export(:support) {
	# Our high-pass filter in decreasing order of how many inputs
	# would satisfy each test and thus reject the value:
	return False if
		$n.narrow !~~ Int or $n <= 1 or $n %% 2 or
		(!$strict and $n.is-prime) or
		@low-squares.grep: -> $s { $n %% $s };

	my @prime-factors = prime-factors($n);
	# is-prime even if $strict
	return False if @prime-factors.elems == 1;
	# This would imply that the number is not square-free:
	return False if Set.new(@prime-factors).elems != @prime-factors.elems;
	# for all prime divisors p of n, it is true that (p-1)|(n-1)
	for @prime-factors -> $p {
		return False if ($n-1) !%% ($p-1);
	}
	return True;
}

our @A002997 is export = ℕ.grep: -> $n { is-carmichael($n) };
