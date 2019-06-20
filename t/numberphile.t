use v6.c;

use Test;

use Math::Sequences::Numberphile :ALL;

my %canned = (
	A249572 => [
		[1, 4, 8, 48, 88, 488, 888, 4888, 8888, 48888],
		"typographical topology"],
	A087409 => [
		[61, 21, 82, 43, 3, 64, 24, 85, 46, 6], "6-shift"],
	A002904 => [
		[0, 0, 0, 0, 4, 9, 5, 1, 1, 0], "Roman"],
	A006933 => [
		[2, 4, 6, 30, 32, 34, 36, 40, 42, 44], "eban"],
	A006567 => [
		[13, 17, 31, 37, 71, 73, 79, 97, 107, 113], "emirps"],
	A002210 => [
		[2, 6, 8, 5, 4, 5, 2, 0, 0, 1], "Khintchine's constant"],
	alt-A001462 => [
		[1, 2, 2, 3, 3, 4, 4, 4, 5, 5], "Golomb's sequence"],
	A023811 => [
		[0, 1, 5, 27, 194, 1865, 22875, 342391, 6053444, 123456789],
		"Largest metadrome"],
	A010727 => [[7, 7, 7, 7, 7, 7, 7, 7, 7, 7], "All 7s"],
	A058883 => [[11, 67, 2, 4769, 67], "Wild numebrs"],
	A131645 => [
		[6661, 16661, 26669, 46663, 56663], # Short for performance
		"Beastly primes"],
	A232448 => [
		[0, 13, 42], # Anything larger takes a long time to test
		"Belphegor primes"],
	A125524 => [
		[13, 17, 43, 47, 67, 83, 97, 103, 107, 113], "Republican primes"],
	A125523 => [
		[29, 31, 59, 71, 79, 211, 229, 239, 241, 251], "Democratic primes"],
	A181391 => [
		[0, 0, 1, 0, 2, 0, 2, 2, 1, 6], "Van Eck's sequence"],
	A087019 => [
		[0, 1, 2, 3, 4, 5, 6, 7, 8, 9], "Lunar squares"],
);

plan 8 + %canned;

cmp-ok topologically-ordered-numbers[^5], '~~', [1, 4, 8, 48, 88], "topologically-ordered-numbers";
is topologically-ordered-numbers(:radix(16))[4], :16<88>, "base 16 topologically-ordered-numbers";
for %canned.sort.map(*.kv) -> ($seq, ($results, $desc)) {
	my @seq;
	try {
		@seq := @::($seq);
		CATCH {
			when X::NoSuchSymbol {
				require Math::Sequences::Integer;
				@seq := @::("Math::Sequences::Integer::" ~ $seq);
			}
		}
	}
	cmp-ok @seq[^(+$results)], '~~', $results, "$seq\[1-{+$results}]: $desc";
}

# These are the only known Wieferich primes even though they are trivial
# to test and there are believed to be infinitely many...
is @A001220[0], 1093, "Wieferich prime [0]";
is @A001220[1], 3511, "Wieferich prime [1]";
is lunar_add(234, 321), 334, "lunar_add two three-digit numbers";
is lunar_add(1,2,3,4), 4, "lunar_add four digits";
is lunar_mul(4,5), 4, "lunar_mul two digits";
is lunar_mul(234, 321), 23321, "lunar_mul two three-digit numbers";
