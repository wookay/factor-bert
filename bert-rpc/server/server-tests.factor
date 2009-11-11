USE: math
IN: calc
: add ( x y -- n ) + ;


USING: tools.test syntax io.sockets threads kernel namespaces concurrency.promises math words classes.tuple sequences vocabs.loader ;
USING: bert.encoder bert.decoder accessors ;
USE: bert
USE: bert-rpc
USE: bert-rpc.server
IN: bert-rpc.server.tests

{ { add "calc" } } bert-dispatch set

[ T{ bert-tuple f { reply 3 } } ]
[ "call" "calc" "add" { 1 2 } <bert-request> handle-call ] unit-test

! [ { "error" "server" 0 } ]
! [ "call" "calc" "subtract" { 1 2 } <bert-request> handle-call seq>> ] unit-test

"127.0.0.1" 8000 <inet4> start-bert-server
