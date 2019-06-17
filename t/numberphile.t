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
);

plan 2 + %canned;

cmp-ok topologically-ordered-numbers[^5], '~~', [1, 4, 8, 48, 88], "topologically-ordered-numbers";
is topologically-ordered-numbers(:radix(16))[4], :16<88>, "base 16 topologically-ordered-numbers";
for %canned.sort.Hash.kv -> $seq, ($results, $desc) {
	cmp-ok @::($seq)[^10], '~~', $results, "$seq\[1-10]: $desc";
}
