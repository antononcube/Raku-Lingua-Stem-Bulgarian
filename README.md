# Raku-Lingua-Stem-Bulgarian

## Introduction

This Raku package is for stemming Bulgarian words. 
It implements the BulStem algorithm presented in 
[[PN1](http://lml.bas.bg/~nakov/bulstem/)].

-------

## Usage examples

The `BulStem` function is used to find stems:

```perl6
use Lingua::Stem::Bulgarian;
say BulStem('покълване')
```
```
# покълв
```

`BulStem` also works with lists of words:

```perl6
say BulStem('Покълването на посевите се очаква с търпение, пиене и сланина.'.words)
```
```
# (Покълване на посеви се очакв с търпени пи и слани)
```

The function `bg-word-stem` can be used as a synonym of `BulStem`.

-------

## Command Line Interface (CLI)

The package provides the CLI function `BulStem`. Here is its usage message:

```shell
> BulStem --help                                                   
Usage:
  BulStem [--splitter=<Str>] [--format=<Str>] <text> -- Finds stems of Bulgarian words in text.
  BulStem [--format=<Str>] [<words> ...] -- Finds stems of Bulgarian words.
  BulStem [--format=<Str>] -- Finds stems of Bulgarian words in (pipeline) input.
  
    <text>              Text to spilt and its words stemmed.
    --splitter=<Str>    String to make a split regex with. [default: '\W+']
    --format=<Str>      Output format one of 'text', 'lines', or 'raku'. [default: 'text']
    [<words> ...]       Words to be stemmed.
```

Here are example shell commands of using the CLI function `BulStem`:

```shell
> BulStem Какви
Какв
  
> BulStem --format=raku "Какви са стъблата на тези думи"
# ["Какв", "с", "стъблат", "н", "тез", "дум"]

> BulStem Какви са стъблата на тези думи 
# Какв с стъблат н тез дум
```

Here is a pipeline example using the CLI function `GetTokens` of the package 
["Grammar::TokenProcessing"](https://github.com/antononcube/Raku-Grammar-TokenProcessing),
[AAp1]:

```shell
GetTokens ./RecommenderPhrases-template | BulStem --format=raku
# ("colnames", "rownames", "агрегац", "агрегир", "ан", "аномал", "аномал", "близос", 
# "взем", "внуш", "глобал", "глобалн", "гъстот", "докаж", "доказателств", "доказателств",
# "елемент", "етик", "заред", "изполва", "индексира", "истор", "консума", "латент", 
# "латентн", "локал", "локалн", "матриц", "матриц", "напречн", "нещ", "нещ", 
# "номализац", "нормализато", "нормализира", "обед", "обедин", "обработ", "обрат", 
# "обратн", "обясн", "обясн", "обясн", "повечет", "подход", "подход", "пр", "пр", 
# "препор", "препор", "препоръч", "препоръч", "препоръча", "препоръч", "препоръч", 
# "препоръчителк", "препоръчк", "препоръчк", "при", "проф", "размер", "разреденос", 
# "редиц", "свидетелств", "свидетелств", "свойств", "свойств", "семантич", "съсед", 
# "терм", "функци", "характеристи", "характеристи", "честот", "чре")
```

**Remark:** These kind of tokens (literals) transformations are used in the package 
["DSL::Bulgarian"](https://github.com/antononcube/Raku-DSL-Bulgarian),
[AAp2].

-------

## Other implementations

[C#](https://github.com/tbmihailov/bulstem-cs),
[GATE plugin (Java)](https://gate.ac.uk/gate/plugins/Lang_Bulgarian/src/gate/bulstem/BulStemPR.java)
[Java (JDK 1.4)](http://lml.bas.bg/~nakov/bulstem/Stemmer.java),
[Perl (Original)](http://lml.bas.bg/~nakov/bulstem/apply_stem.pl),
[Python2](https://github.com/peio/PyBulStem),
[Python3](https://github.com/mhardalov/bulstem-py),
[Ruby](https://github.com/tbmihailov/bulstem)


-------

## Implementation notes

- The resource files are essential for the implementation of `BulStem`.

   - I had problems ingesting the stem-rules files in [PNp1] with my OS/IDE setup, 
     so I used the files in [MHp1].

- The resource files are used to make the Bulgarian stemming rules.

- The stemming rules `Hash` object is made at compile time.

- There are 120765 stemming rules with frequencies (counts) ≥ 1. 
   
   - By default rules with count ≥ 2 are loaded used.
   

-------

## TODO

- [ ] Respected the word case in the returned result. 

   - `BulStem('ТАБЛА')` should return `'ТАБЛ'`. 
   - (Not `'табл'` as it currently does.) 

-------

## References

### Articles

[PN1] Preslav Nakov, 
["BulStem: Design and evaluation of inflectional stemmer for Bulgarian"](http://lml.bas.bg/~nakov/bulstem/index.html), 
In Workshop on Balkan Language Resources and Tools (Balkan Conference in Informatics).

### Packages

[AAp1] Anton Antonov,
[Grammar::TokenProcessing Raku package](https://github.com/antononcube/Raku-Grammar-TokenProcessing),
(2022),
[GitHub/antononcube](https://github.com/antononcube).

[AAp2] Anton Antonov,
[DSL::Bulgarian Raku package](https://github.com/antononcube/Raku-DSL-Bulgarian),
(2022),
[GitHub/antononcube](https://github.com/antononcube).

[MHp1] Momchil Hardalov,
[bulstem-py Python package](https://github.com/mhardalov/bulstem-py),
(2020), (Release: v0.3.3),
[GitHub/mhardalov](https://github.com/mhardalov).

[PNp1] Preslav Nakov,
[BulStem: Inflectional Stemmer for Bulgarian](http://lml.bas.bg/~nakov/bulstem/index.html),
(2002),
http://lml.bas.bg/~nakov.
