USING: tools.test byte-arrays kernel bert ;
IN: bert.tests

[ "<<1>>"   ] [ B{ 1 } ebin   ] unit-test
[ "<<1,2>>" ] [ B{ 1 2 } ebin ] unit-test

[ "<<0,0,0,20,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20>>" ] [ B{ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 } berp ebin ] unit-test


USING: bert.encoder bert.decoder ;
[ 4        ] [ 4 >bert bert>        ] unit-test
[ 8.1516   ] [ 8.1516 >bert bert>   ] unit-test
[ -3.014e3 ] [ -3.014e3 >bert bert> ] unit-test

SYMBOL: foo
[ "foo"    ] [ foo >bert bert>      ] unit-test !

SYMBOL: coord
[ { "coord" 23 42 } ] [ { coord 23 42 } >bert bert>      ] unit-test !

[ { 1 2 3 }      ] [ { 1 2 3 } >bert bert>      ] unit-test

SYMBOL: a
[ { "a" { 1 2 } }      ] [ { a { 1 2 } } >bert bert>      ] unit-test

"Roses are red\0Violets are blue" >byte-array [ ] curry
[ "Roses are red\0Violets are blue" >byte-array >bert bert> ] unit-test
[ B{ } ] [ B{ } >bert bert> ] unit-test

[ { }      ] [ { } >bert bert>      ] unit-test
[ { t f }  ] [ { t f } >bert bert>  ] unit-test
[ "abc"    ] [ "abc" >bert bert>    ] unit-test
[ H{ }     ] [ H{ } >bert bert>     ] unit-test

[ H{ { "key" "value" } } ] [ H{ { "key" "value" } } >bert bert> ] unit-test


! TODO
! time	{bert, time, Megaseconds, Seconds, Microseconds}
! regex	{bert, regex, Source, Options}
