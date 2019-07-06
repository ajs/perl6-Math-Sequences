use v6.c;

use Math::Util::SpellNumbers;

use Test;

my %tests = (
	10 => 'ten',
	1252 => 'one thousand, two hundred fifty-two',
	86_000_000 => 'eighty-six million',
	-1 => 'negative one',
	0 => 'zero',
);

plan %tests.elems;

for %tests.kv -> $number, $name {
	is as-words($number, :lang<en>), $name, $name;
}
