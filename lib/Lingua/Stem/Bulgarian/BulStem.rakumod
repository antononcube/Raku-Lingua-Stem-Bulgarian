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

#| Get Bulgarian stemming rules
sub get-bulgarian-stem-rules(-->Hash) is export {
    return %bgStemRules;
}

#| Ingest Bulgarian stemming rules
sub get-bg-stem-rules($fileName --> Hash) {
    my $ruleLines = slurp($fileName).lines;
    $ruleLines = $ruleLines.map({ $_.subst('==>', '').split(/\W+/).head(2) });
    my %rules = $ruleLines.map({ $_[0] => $_[1] });
    return %rules;
}

#| Ingest the rules
if %bgStemRules.elems == 0 {
    # This ingestion is done at compile time -- see the BEGIN block below.
    for 1 .. 3 -> $i {
        %bgStemRules = %bgStemRules, get-bg-stem-rules(%?RESOURCES{'stem_rules_context_' ~ $i ~ '_utf8.txt'});
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

    for 0 ..^ ($word.chars - 1) -> $i {
        my $candidate = $word.substr($i, *- 1);
        my $res = %bgStemRules{$candidate.lc};
        with $res {
            return $word.substr(0, $i) ~ $res;
        }
    }

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
    my %res;
    for 1 .. 3 -> $i {
        %res = %res, get-bg-stem-rules(%?RESOURCES{'stem_rules_context_' ~ $i ~ '_utf8.txt'});
    }
    %res;
};
