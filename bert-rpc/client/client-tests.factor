USING: tools.test syntax io.sockets accessors kernel ;
USING: bert-rpc bert-rpc.client ;
IN: bert-rpc.client.tests

! CONSTANT: PORT 9999
CONSTANT: PORT 8000

SYMBOLS: calc add ;

[ 3 ] [ "localhost" PORT <inet> [ 1 2 add calc ] call> ] unit-test
[ 5 ] [ "localhost" PORT <inet> [ 2 3 add calc ] call> ] unit-test

[ 579 ] [ "localhost" PORT <inet> [ 123 456 add calc ] call> ] unit-test

[ "server" 0 "Undesignated" ]
[ "localhost" PORT <inet> [ 123 456 add "errorcalc" ] call>
  [ type>> ] [ code>> ] [ detail>> ] tri ] unit-test

[ "user" 0 f ]
[ "localhost" PORT <inet> [ "{ 1 test { 5 6 7 } }" 456 add calc ] call>
  [ type>> ] [ code>> ] [ detail>> ] tri ] unit-test
