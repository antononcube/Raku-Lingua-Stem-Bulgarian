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

`BulStem` also works with lists of words:

```perl6
say BulStem('Покълването на посевите се очаква с търпение, пиене и сланина.'.words)
```

The function `bg-word-stem` can be used as synonym of `BulStem`.

-------

## Command Line Interface (CLI)

The package provides the CLI function `BulStem`:

```shell
> BulStem Какви
Какв
  
> BulStem "Какви са стъблата на тези думи"
# ["Какв", "с", "стъблат", "н", "тез", "дум"]

> BulStem Какви са стъблата на тези думи 
# Какв с стъблат н тез дум
```

-------

## Other implementations

[C#](https://github.com/tbmihailov/bulstem-cs),
[GATE plugin (Java)](https://gate.ac.uk/gate/plugins/Lang_Bulgarian/src/gate/bulstem/BulStemPR.java)
[Java (JDK 1.4)](http://people.ischool.berkeley.edu/~nakov/bulstem/Stemmer.java),
[Perl (Original)](http://people.ischool.berkeley.edu/~nakov/bulstem/apply_stem.pl),
[Python2](https://github.com/peio/PyBulStem),
[Python3](https://github.com/mhardalov/bulstem-py),
[Ruby](https://github.com/tbmihailov/bulstem)


-------

## Implementation notes

- The resource files are essential for the implementation of `BulStem`.

- The resource files are used to make the Bulgarian stemming rules.

- The stemming rules `Hash` object is made at compile time.


-------

## TODO

- [ ] Respected the word case in the returned result. 

   - `BulStem('ТАБЛА')` should return `'ТАБЛ'`. 
   - (Not `'табл'` as it currently does.) 

-------

## References

[PN1] Preslav Nakov, 
["BulStem: Design and evaluation of inflectional stemmer for Bulgarian"](http://lml.bas.bg/~nakov/bulstem/index.html), 
In Workshop on Balkan Language Resources and Tools (Balkan Conference in Informatics).