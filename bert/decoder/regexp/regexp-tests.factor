USING: tools.test syntax sequences accessors kernel classes regexp regexp.ast ;
USING: bert.decoder bert.encoder bert bert.decoder.regexp ;
IN: bert.decoder.regexp.tests

[ t ] [ B{ 131 104 4 100 0 4 98 101 114 116 100 0 5 114 101 103 101 120 106 106 } bert> class regexp = ] unit-test
[ { case-insensitive multiline } ] [ "<<131,104,4,100,0,4,98,101,114,116,100,0,5,114,101,103,101,120,106,108,0,0,0,2,100,0,8,99,97,115,101,108,101,115,115,100,0,9,109,117,108,116,105,108,105,110,101,106>>" ebin> bert> options>> on>> ] unit-test
[ { case-insensitive multiline } ] [ R/ /im options>> on>> ] unit-test
[ "^c(a*)t$" { case-insensitive } ] [ "<<131,104,4,100,0,4,98,101,114,116,100,0,5,114,101,103,101,120,107,0,8,94,99,40,97,42,41,116,36,108,0,0,0,1,100,0,8,99,97,115,101,108,101,115,115,106>>" ebin> bert> [ raw>> ] [ options>> on>> ] bi ] unit-test
