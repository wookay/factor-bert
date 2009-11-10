USING: tools.test syntax io.sockets ;
USE: bert-rpc.client
IN: bert-rpc.client.tests

SYMBOLS: calc add ;

[ 3 ] [ "localhost" 9999 <inet> [ 1 2 add calc ] call> ] unit-test
[ 5 ] [ "localhost" 9999 <inet> [ 2 3 add calc ] call> ] unit-test

[ 579 ] [ "localhost" 9999 <inet> [ 123 456 add calc ] call> ] unit-test

[ T{ bert-error f "server" 0 f "Undesignated" f } ]
[ "localhost" 9999 <inet> [ 123 456 add "errorcalc" ] call> ] unit-test

[ T{ bert-error f "user" 0 f f f } ]
[ "localhost" 9999 <inet> [ "{ 1 test { 5 6 7 } }" 456 add calc ] call> ] unit-test
