# Utilities for spelling out numbers as words

use v6.c;

sub as-words($number, :$lang='en') is export {
	&::('as-words-' ~ $lang)($number);
}

sub as-words-en($number is copy) {
	if $number != $number.Int {
		die "No handling for fractional numbers yet";
	}
	my @small = <
		zero one two three four five six seven eight nine ten eleven twelve
		thirteen fourteen fifteen sixteen seventeen eighteen nineteen>;
	my @tens = |['', ''],
		|<twenty thirty fourty fifty sixty seventy eighty ninety>;
	my @thousands-scale = <
		thousand million billion trillion quadrillion quintillion sextillion
		septillion octillion nonillion decillion undecillion duodecillion
		tredecillion quattuordecillion quindecillion sexdecillion
		septendecillion octodecillion novemdecillion vigintillion
		unvigintillion duovigintillion UNDEFINED>;

	join ' ', gather while $number {
		given +$number {
			when * < 0 {
				take 'negative';
				$number = -$number;
			}
			when * < 20 {
				take @small[$_];
				$number = 0;
			}
			when * < 100 {
				take @tens[$_ div 10];
				$number %= 10;
			}
			when * < 1_000 {
				take @small[$_ div 100];
				take 'hundred';
				$number %= 100;
			}
			default {
				for ^+@thousands-scale -> $k {
					if @thousands-scale[$k] eq 'UNDEFINED' {
						die "Sorry, number is out of range: $number";
					}
					my $pos = 1_000 ** ($k+1);
					my $next = 1_000 ** ($k+2);
					if $_ < $next {
						take as-words-en($_ div $pos);
						take @thousands-scale[$k];
						$number %= $pos;
						last;
					}
				}
			}
		}
	}
}