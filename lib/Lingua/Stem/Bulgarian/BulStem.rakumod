use v6.d;

=head1 BulStem implementation
=begin para
BULSTEM: INFLECTIONAL STEMMER FOR BULGARIAN

This is the BulStem stemming algorithm. It follows the algorithm presented in

[PN1] Preslav Nakov, "BulStem: Design and evaluation of inflectional stemmer for Bulgarian.",
In Workshop on Balkan Language Resources and Tools (Balkan Conference in Informatics).

Preslav Nakov, the algorithm's inventor, maintains a web page about the algorithm at
    http://people.ischool.berkeley.edu/~nakov/bulstem/
which includes original Perl implementation, also a Java, and another Python version.

This text data was taken from the GitHub repository by Momchil Hardalov:
    https://github.com/mhardalov/bulstem-py
=end para

unit module Lingua::Stem::Bulgarian;

#| The Bulgarian stemming rules
my %bgStemRules;

#| The Bulgarian stemming rules counts
my %bgStemRuleCounts;

#| Vowels
my @vowels = <а ъ о у е и я ю>;

#| Current min count
my UInt $current-min-count = 0;

#| Get Bulgarian stemming rules
sub get-bulgarian-stem-rules( :$file = Whatever, Bool :$with-counts = False, UInt :$min-count = 0 -->Hash) is export {
    if $with-counts {

        if %bgStemRuleCounts.elems == 0 || $min-count != $current-min-count {
            if $file.isa(Whatever) {
                for 1 .. 3 -> $i {
                    %bgStemRuleCounts = %bgStemRuleCounts, ingest-bg-stem-rules-with-counts(%?RESOURCES{'stem_rules_context_' ~ $i ~ '_utf8.txt'});
                }
            } elsif ($file ~~ Str && $file.Int ~~ Int || $file ~~ Int) && 1 <= $file.Int <= 3 {
                %bgStemRuleCounts = ingest-bg-stem-rules-with-counts(%?RESOURCES{'stem_rules_context_' ~ $file ~ '_utf8.txt'});
            } else {
                warn "Do not know what to do with the value given to the named argument 'file': {$file}.";
                return %bgStemRuleCounts;
            }
        }

        $current-min-count = $min-count;

        if $min-count ~~ Int {
            %bgStemRuleCounts = %bgStemRuleCounts.grep({ $_.value ≥ $min-count });
        }

        return %bgStemRuleCounts;
    } else {
        %bgStemRules = get-bulgarian-stem-rules(:with-counts, :$min-count);
        %bgStemRules = %bgStemRules.map({ $_.key.split(':') }).map({ $_[0] => $_[1] });
        return %bgStemRules;
    }
}

#| Ingest Bulgarian stemming rules
sub ingest-bg-stem-rules($fileName --> Hash) {
    my $ruleLines = slurp($fileName).lines;
    $ruleLines = $ruleLines.map({ $_.subst('==>', '').words.head(2) });
    my %rules = $ruleLines.map({ $_[0] => $_[1] });
    return %rules;
}

#| Ingest Bulgarian stemming rules with counts
sub ingest-bg-stem-rules-with-counts( $fileName --> Hash) {

    my $ruleLines = slurp($fileName).lines;
    $ruleLines = $ruleLines.map({ $_.subst('==>', '').words }).List;
    my %rules = $ruleLines.map({ $_[0] ~ ':' ~ $_[1] => +$_[2] }).grep({ so $_.value ~~ Int });

    return %rules;
}

#| Ingest the rules
if %bgStemRules.elems == 0 {
    # This ingestion is done at compile time -- see the BEGIN block below.
    for 1 .. 3 -> $i {
        %bgStemRules = %bgStemRules, ingest-bg-stem-rules(%?RESOURCES{'stem_rules_context_' ~ $i ~ '_utf8.txt'});
    }
}

#| BulStem
proto BulStem($wordSpec) is export {*}

#| BulStem
multi BulStem(@words --> List) {
    return @words.map({ BulStem($_) }).List;
}

#| BulStem
multi BulStem(Str:D $word --> Str) {

    # The code in this function is very close to the original Perl code by Preslav Nakov.

    # 1. Find the word length
    my $wordLen = $word.chars;

    # 2. Return if no vowels are found
    $word.match( / ([<-[аъоуеияю]>*]) <[аъоуеияю]> / ):i;

    without $/ {
        return $word;
    }

    # 3. Try to match against the rules
    loop ( my $start = 1 + $0.chars; $start < $wordLen; $start++ ) {
        my $suffix = $word.substr($start);
        my $res = %bgStemRules{$suffix};
        with $res {
            # return $word.substr(0, $start) ~ $res;
            return $word.substr(0, $start) ~ $word.substr($start, $res.chars);
        }
    }

    # 4. No compatible rule - return
    return $word;
}

#| Synonym of BulStem
sub bg-word-stem($arg) is export {
    return BulStem($arg);
}

##=========================================================
## Optimization
##=========================================================
%bgStemRules = BEGIN {
    $current-min-count = 2;
    get-bulgarian-stem-rules(:!with-counts, file => Whatever, min-count => $current-min-count)
};
