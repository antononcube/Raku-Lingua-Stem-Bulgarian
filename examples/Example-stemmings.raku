#!/usr/bin/env raku
use v6.d;

use Lingua::Stem::Bulgarian;

# Single word
say BulStem('облизал');

# Many words
say BulStem('облизал си тази чиния с туршия и домати'.words);

my $text =
        'На фона на всичко това в завода са притеснени и от ефекта, който кризата ще има върху цените на природния газ, използван в производството.
През последните дни стойностите на синьото гориво на нидерландската борса от която зависят цените у нас, се повишиха с около 70%.
Днес се поуспокоиха, но е под въпрос дали заявеното от "Булгаргаз" поевтиняване за началото на март ще се случи.';

my $tstart = now;
my $res = BulStem($text.words>>.trim);
say "Stemming time {now - $tstart}.";

say $res.join(' ');

say get-bulgarian-stem-rules().elems;
