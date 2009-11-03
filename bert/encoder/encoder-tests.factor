USING: tools.test syntax bert bert.encoder sequences ;
IN: bert.encoder.tests

! CONSTANT: SMALL_INT 97
! CONSTANT: INT 98
! CONSTANT: ATOM 100
! CONSTANT: SMALL_TUPLE 104
! CONSTANT: LARGE_TUPLE 105
! CONSTANT: NIL 106
! CONSTANT: STRING 107
! CONSTANT: LIST 108
! CONSTANT: BIN 109
! CONSTANT: SMALL_BIGNUM 110
! CONSTANT: VERSION 131

[ B{ 131 97 1 } ] [ 1 >bert ] unit-test
[ "<<131,97,1>>" ] [ 1 >bert ebin ] unit-test
[ "<<131,98,0,0,4,210>>" ] [ 1234 >bert ebin ] unit-test
[ "<<131,110,4,0,210,2,150,73>>" ] [ 1234567890 >bert ebin ] unit-test
[ B{ 131 106 } ] [ "" >bert ] unit-test
[ B{ 131 106 } ] [ { } >bert ] unit-test
[ B{ 131 107 0 1 97 } ] [ "a" >bert ] unit-test
[ B{ 131 107 0 3 97 98 99 } ] [ "abc" >bert ] unit-test
[ "<<131,107,0,3,97,98,99>>" ] [ "abc" >bert ebin ] unit-test
[ "<<131,107,0,3,227,132,177>>" ] [ "ㄱ" >bert ebin ] unit-test
[ B{ 131 106 } ] [ { } >bert ] unit-test
[ "<<131,108,0,0,0,1,97,1,106>>" ] [ { 1 } >bert ebin ] unit-test

SYMBOL: foo
[ "<<131,100,0,3,102,111,111>>" ] [ foo >bert ebin ] unit-test

SYMBOL: ㄱ
[ "<<131,100,0,3,227,132,177>>" ] [ ㄱ >bert ebin ] unit-test

USE: lists
[ "<<131,104,2,100,0,4,98,101,114,116,100,0,3,110,105,108>>" ] [ nil >bert ebin ] unit-test

[ "<<131,104,2,100,0,4,98,101,114,116,100,0,4,116,114,117,101>>" ] [ t >bert ebin ] unit-test
[ "<<131,104,2,100,0,4,98,101,114,116,100,0,5,102,97,108,115,101>>" ] [ f >bert ebin ] unit-test
[ "<<131,99,51,46,49,52,48,48,48,48,48,48,48,48,48,48,48,48,48,101,43,48,48,0,0,0,0,0,0,0,0,0,0>>" ] [ 3.14 >bert ebin ] unit-test

[ "<<131,104,3,100,0,4,98,101,114,116,100,0,4,100,105,99,116,106>>" ] [ H{ } >bert ebin ] unit-test

SYMBOL: a
[ "<<131,104,3,100,0,4,98,101,114,116,100,0,4,100,105,99,116,108,0,0,0,1,108,0,0,0,2,100,0,1,97,97,1,106,106>>" ] [ H{ { a 1 } } >bert ebin ] unit-test

[ "<<131,109,0,0,0,0>>" ] [ B{ } >bert ebin ] unit-test
