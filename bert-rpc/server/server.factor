! Copyright (C) 2009 Woo-Kyoung Noh.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors kernel math threads io io.sockets sequences quotations math
io.encodings.binary io.streams.duplex debugger tools.time io.binary 
concurrency.promises generalizations words combinators classes.tuple
namespaces arrays continuations destructors present ;
USING: bert bert.encoder bert.decoder ;
USE: bert-rpc
IN: bert-rpc.server

SYMBOL: bert-dispatch
DEFER: handle-call

<PRIVATE

SYMBOL: bert-server

: handle-error ( bert-request -- bert-error )
    drop 
    { 
      T{ bert-atom f "error" }
      T{ bert-tuple f
        { T{ bert-atom f "server" } 0 } 
      }
    } <bert-tuple> ;

: handle-reply ( bert-request -- bert-tuple )
    [
      1array [
        [ args>> >quotation ]
        [ [ fun>> ] [ mod>> ] bi lookup 1quotation ]
        bi compose call
      ] map { reply } prepend
    ]
    [ 
      { 
        T{ bert-atom f "error" }
        T{ bert-tuple f
          { T{ bert-atom f "user" } 0 } 
        }
      }
    ] recover <bert-tuple> ; inline

: handle-request ( byte-array -- byte-array )
    bert> dup first {
      { "call" [ bert-request prefix >tuple handle-call ] }
      ! { "cast" [ bert-request prefix >tuple handle-cast ] }
    } case ; inline

: server-loop ( server -- )
    dup accept drop [
      [ 4 read be> read handle-request >bert >berp [ write1 ] each flush ] with-stream
    ] curry "server-loop" spawn drop server-loop ;

PRIVATE>


: handle-call ( bert-request -- obj )
    dup [ fun>> ] [ mod>> ] bi 2array 1quotation
    [ [ present ] map ] prepose [ = ] compose 
    [ bert-dispatch get ] dip any?
    [ handle-reply ] [ handle-error ] if ; inline


: start-bert-server ( inet -- )
    1quotation 
    [ binary <server> dup bert-server set 
      "bert-server started" print flush
      [ server-loop ] with-disposal 
    ] compose ignore-errors ; inline

! : stop-bert-server ( -- )
!    bert-server get dispose ;
