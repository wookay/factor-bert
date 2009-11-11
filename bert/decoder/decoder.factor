! Copyright (C) 2009 Woo-Kyoung Noh.
! See http://factorcode.org/license.txt for BSD license.
USING: io.streams.byte-array kernel io.encodings.binary io io.binary sequences combinators kernel math math.parser arrays assocs strings fry accessors lists io.encodings.utf8 io.encodings.string hashtables calendar namespaces eval classes byte-arrays ;
USING: bert.constants bert ;
IN: bert.decoder


GENERIC: read-regex ( seq -- obj )

<PRIVATE

DEFER: read-any-raw

: read-byte-array ( byte-array -- obj )
    binary [ read-any-raw ]  with-byte-reader ;

: eval-symbol ( seq -- symbol )
    bert-vocab get-global
    [ ]
    [ "IN: " prepend  [ dup " SYMBOL:" -rot 3array " " join ] dip prepend 
      eval( -- symbol ) ] if-empty ;

: read-atom ( length -- obj )
    read utf8 decode
    {
       { "bert" [ bert ] }
       { "true" [ true ] }
       { "false" [ false ] }
       { "dict" [ dict ] }
       { "time" [ time ] }
       { "regex" [ regex ] }
       { "nil" [ \ nil ] }
       [ eval-symbol ]
    } case ;

: read-time ( seq -- obj )
    3 tail* first3 [ 1000000 * 1000000 * ] [ 1000000 * ] [ ] tri* + + micros>timestamp ;

: read-normal-tuple ( seq -- obj )
    [ dup class {
      { byte-array [ read-byte-array ] }
      [ drop ]
    } case ] map ;

: read-tuple ( length -- obj )
    >array [ drop read-any-raw ] map 
    {
      { { bert true } [ t ] }
      { { bert false } [ f ] }
      { { bert nil } [ \ nil ] }
      [ dup length 2 >
        [ dup first2 2array
          {
            { { bert dict } [ last >hashtable ] }
            { { bert time } [ read-time ] }
            { { bert regex } [ read-regex ] }
            [ drop read-normal-tuple ]
          } case ]
        [ ] if ]
    } case ;

: read-bignum ( length -- obj )
    [ 1 read be> 1 = [ -1 ] [ 1 ] if ] keep read swapd
    [ >array ] dip zip [ first2 swap 8 * shift ] [ + ] map-reduce * ;

: read-float ( length -- obj )
    read [ CHAR: \0 = not ] filter string>float ;

: read-string ( length -- obj )
    read utf8 decode ;

: read-list ( length -- obj )
    >array [ drop read-any-raw ] map ;

: read-bin ( length -- obj )
    dup zero? [ B{ } nip ] [ read ] if ;

: read-any-raw ( -- obj )
    1 read be>
    {
      { SMALL_INT [ 1 read be> ] }
      { INT [ 4 read be> ] }
      { SMALL_BIGNUM [ 1 read be> read-bignum ] }
      { LARGE_BIGNUM [ 4 read be> read-bignum ] }
      { FLOAT [ 31 read-float ] } 
      { NIL [ { } ] }
      { SMALL_TUPLE [ 1 read be> read-tuple ] }
      { LARGE_TUPLE [ 4 read be> read-tuple ] }
      { ATOM [ 2 read be> read-atom ] }
      { STRING [ 2 read be> read-string ] }
      { LIST [ 4 read be> read-list ] }
      { BIN [ 4 read be> read-bin ] }
      [ ]
    } case ;

PRIVATE>

: bert> ( byte-array -- obj )
    1 cut swap be>
    {
      { VERSION [ read-byte-array ] }
      [ drop ]
    } case ;
