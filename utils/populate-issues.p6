#!/usr/bin/env perl6

# example usage:
#   ./populate-issues.p6 "I know what I'm doing" YOUR-ACCESS-TOKEN A000005 A000007

# Based on this script: https://github.com/perl6/ecosystem-unbitrot/blob/master/scripts/populate-issues.p6

my $repo = ‘ajs/perl6-Math-Sequences’;
my $url  = “https://api.github.com/repos/$repo/issues”;

sub body-template($entry, $short-name) {
    qq:to/TEMPLATE/
    [{$entry.ID} / {$entry.name}](https://oeis.org/{$entry.ID})

    The sequence is not implemented yet.

    <code>
    {$entry.sequence}
    </code>
    TEMPLATE
}

multi MAIN(‘I know what I'm doing’, $token, *@seqs) {
    use Math::Sequences::Integer;
    my %short-names = %oeis-core.map({.value.name.substr(1) => .key});
    my $ignored-keywords = <allocated changed new probation recycled uned>.Set;
    for @seqs {
        use OEIS;
        my $entry = OEIS::lookup($_);
        exit unless $entry;
        my $short-name =%short-names{$entry.ID};
        $short-name //= $entry.name;
        my @keywords = ($entry.keywords».Str ∖ $ignored-keywords).keys.sort;
        # This can fail if a label is not created yet
        my $number = submit-issue :$token,
                     title  => “{$entry.ID} / $short-name”,
                     body   => body-template($entry, $short-name),
                     labels => @keywords,
                     ;
        put “$number, $_”;
        sleep 5;
    }
}

multi MAIN(*@) {
    note ‘Exiting… Please confirm your intentions.’;
}

sub submit-issue(:$token, :$title, :$body, :@labels) {
    my %body = %(:$title, :$body, :@labels,);

    use Cro::HTTP::Client;
    my $resp = await Cro::HTTP::Client.post: $url,
          headers => [
              User-Agent => ‘perl6 squashathon’,
              Authorization => “token $token”,
          ],
          content-type => ‘application/json’,
          body => %body,
    ;

    return (await $resp.body)<number> # issue number
}
