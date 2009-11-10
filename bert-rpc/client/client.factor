USING: words.symbol quotations kernel arrays sequences accessors io.sockets math io concurrency.promises io.encodings.utf8 calendar namespaces io.timeouts io.encodings.ascii lists combinators accessors fry strings io.encodings.string io.binary bert.encoder bert.decoder bert.constants bert io.streams.byte-array destructors io.streams.duplex classes byte-arrays io.encodings.binary classes.tuple ;
IN: bert-rpc.client

USE: prettyprint 

TUPLE: bert-request args fun mod kind ;
TUPLE: bert-error type code class detail backtrace ;

<PRIVATE

: <bert-error> ( seq -- bert-error )
    5 f pad-tail bert-error prefix >tuple
    dup dup type>> {
     { "protocol" [ code>> {
         { 0 [ "Undesignated" ] }
         { 1 [ "Unable to read header" ] }
         { 2 [ "Unable to read data" ] }
       } case ] }
     { "server" [ code>> {
         { 0 [ "Undesignated" ] }
         { 1 [ "No such module" ] }
         { 2 [ "No such function" ] }
       } case ] }
     { "user" [ f nip ] }
     { "proxy" [ f nip ] }
   } case >>detail ;

: bert-response ( byte-array -- obj )
    bert> dup first {
      { "reply" [ second ] }
      { "noreply" [ nil nip ] } ! TODO: RPC asynchronously
      { "error" [ second <bert-error> ] }
      [ drop ]
    } case ;

: transport ( inet byte-array -- byte-array )
    [ binary ] dip
    [ [ write1 ] each flush 4 read be> read ] curry with-client ;

: bert-request ( seq -- byte-array )
    [ 3 head* 1array ] [ 3 tail* reverse ] bi prepend
    bert-tuple boa dup . >bert >berp ;

: service ( inet quot symbol -- obj )
    suffix array>> bert-request transport bert-response ;

SYMBOLS: cast call ;

PRIVATE>

: cast> ( inet quot -- obj )
    \ cast service ;

: call> ( inet quot -- obj )
    \ call service ;
