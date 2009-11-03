USING: tools.test bert ;
IN: bert.tests

[ "<<1>>"   ] [ B{ 1 } ebin   ] unit-test
[ "<<1,2>>" ] [ B{ 1 2 } ebin ] unit-test

[ "<<0,0,0,20,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20>>" ] [ B{ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 } berp ebin ] unit-test


USING: bert.encoder bert.decoder ;
[ 1        ] [ 1 >bert bert>        ] unit-test
[ 3.14     ] [ 3.14 >bert bert>     ] unit-test
[ -3.014e3 ] [ -3.014e3 >bert bert> ] unit-test
[ { }      ] [ { } >bert bert>      ] unit-test
[ { t f }  ] [ { t f } >bert bert>  ] unit-test
[ "abc"    ] [ "abc" >bert bert>    ] unit-test
[ H{ }     ] [ H{ } >bert bert>     ] unit-test

[ H{ { "key" "value" } } ] [ H{ { "key" "value" } } >bert bert> ] unit-test
