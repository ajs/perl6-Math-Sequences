# Converted from original challenge at:
#
# https://perlweeklychallenge.org/blog/perl-weekly-challenge-010/
#
# By Aaron Sherman 2019

use v6.c;

# Some globals relevant to both encoding and decoding
our $rom = 'MDCLXVI';
our @rom = $rom.comb;
our @val = <1000 500 100 50 10 5 1>;
our $roman_regex = regex {
        'M'* 'CM'? 'CD'? 'D'? 'C' ** 0..3 'XC'? 'L'? 'XL'? 'X' ** 0..3 'IX'?
        'V'? 'IV'? 'I' ** 0..3};

# Return the Roman encoding of $n
sub as_roman($n is copy) is export {
    # We loop over an index, the numeric value at that index,
    # and the roman encoding at that index. We need the index
    # because we're going to do some lookahead.
    # After we get all of the values, we string-concatenate them
    # (via the [~] concatenation-reduction operator)
    return [~] gather for ^@val Z @val Z @rom -> ($i, $v, $r) {
        # First the easy par: get the number of times $n is
        # wholly divisible by the current value and add that
        # many copies of $r (from @rom) to the result.
        take $r x ($n div $v) if $n >= $v;
        $n %= $v;

        # Now check to see if the number is greater than the
        # prefixed form of the current roman letter (e.g. CD)
        # and adjust for the ones that skip forward two
        # (e.g. IX which skips over V)
        my $offset = $v == any(1000, 100, 10) ?? 2 !! 1;
        my ($voff, $roff) = @val[$i+$offset], @rom[$i+$offset];
        if $v > 1 and $n >= $v-$voff and $n > $voff {
            take $roff ~ $r if $v > 1 and $n >= $v-$voff;
            $n -= $v-$voff;
        }
    };
}

sub from_roman(Str $n) is export {
    sub value($c) { @val[$rom.index($c)] }
    die "'$n' is not valid" if $n.uc !~~ m:i{^$roman_regex$};
    return [+] gather for $n.uc ~~ m:g/CM|M|CD|D|XC|C|XL|L|IX|X|IV|V|I/ -> $r {
        if $r.chars == 1 {
            take value($r);
        } else {
            take value($r.substr(1,1)) - value($r.substr(0,1));
        }
    }
}
