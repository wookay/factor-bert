! Copyright (C) 2009 Woo-Kyoung Noh.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel ;
IN: bert-rpc

TUPLE: bert-request kind mod fun args ;
: <bert-request> ( kind mod fun args -- bert-request ) bert-request boa ;

TUPLE: bert-error type code class detail backtrace ;

SYMBOL: reply
