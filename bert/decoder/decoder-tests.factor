USING: tools.test syntax bert bert.decoder bert.constants sequences lists kernel calendar namespaces ;
IN: bert.decoder.tests

[ 1 ] [ B{ 131 97 1 } bert> ] unit-test
[ 1234 ] [ B{ 131 98 0 0 4 210 } bert> ] unit-test
[ 1234567890 ] [ B{ 131 110 4 0 210 2 150 73 } bert> ] unit-test
[ -1234567890 ] [ B{ 131 110 4 1 210 2 150 73 } bert> ] unit-test
[ { } ] [ B{ 131 106 } bert> ] unit-test

[ nil ] [ B{ 131 104 2 100 0 4 98 101 114 116 100 0 3 110 105 108 } bert> ] unit-test

[ t ] [ B{ 131 104 2 100 0 4 98 101 114 116 100 0 4 116 114 117 101 } bert> ] unit-test
[ f ] [ B{ 131 104 2 100 0 4 98 101 114 116 100 0 5 102 97 108 115 101 } bert> ] unit-test

[ "a" ] [ B{ 131 107 0 1 97 } bert> ] unit-test
[ "abc" ] [ B{ 131 107 0 3 97 98 99 } bert> ] unit-test
[ "ㄱ" ] [ B{ 131 107 0 3 227 132 177 } bert> ] unit-test

[ { 1 } ] [ B{ 131 108 0 0 0 1 97 1 106 } bert> ] unit-test

"bert.decoder.tests" bert-vocab set-global

SYMBOL: foo
[ foo ] [ B{ 131 100 0 3 102 111 111 } bert> ] unit-test

SYMBOL: ㄱ
[ ㄱ ] [ B{ 131 100 0 3 227 132 177 } bert> ] unit-test

[ H{ } ] [ B{ 131 104 3 100 0 4 98 101 114 116 100 0 4 100 105 99 116 106 } bert> ] unit-test

SYMBOL: a
[ H{ { a 1 } } ] [ B{ 131 104 3 100 0 4 98 101 114 116 100 0 4 100 105 99 116 108 0 0 0 1 108 0 0 0 2 100 0 1 97 97 1 106 106 } bert> ] unit-test

[ B{ } ] [ B{ 131 109 0 0 0 0 } bert> ] unit-test

2009 11 3 23 19 1 instant <timestamp> [ ] curry
[ B{ 131 104 5 100 0 4 98 101 114 116 100 0 4 116 105 109 101 98 0 0 4 233 98 0 4 110 37 97 0 } bert> ] unit-test
