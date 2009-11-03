! Copyright (C) 2009 Woo-Kyoung Noh.
! See http://factorcode.org/license.txt for BSD license.
USING: io.streams.byte-array kernel io.encodings.binary io io.binary sequences combinators kernel prettyprint math math.parser arrays assocs strings fry accessors lists io.encodings.utf8 io.encodings.string hashtables ;
USE: bert.constants
IN: bert.decoder


<PRIVATE

DEFER: read-any-raw

: read-atom ( length -- obj )
    read utf8 decode
    {
       { "bert" [ bert ] }
       { "true" [ true ] }
       { "false" [ false ] }
       { "dict" [ dict ] }
       { "nil" [ \ nil ] }
       [ ]
    } case ;

: read-tuple ( length -- obj )
    >array [ drop read-any-raw ] map 
    {
      { { bert true } [ t ] }
      { { bert false } [ f ] }
      { { bert nil } [ \ nil ] }
      [ dup length 3 =
        [ dup first2 2array { bert dict } = [ last >hashtable ] [ ] if ] 
        [ ] if ]
    } case ;

: read-bignum ( length -- obj )
    [ 1 read be> 1 = [ -1 ] [ 1 ] if ] keep read swapd
    [ >array ] dip zip [ first2 swap 8 * shift ] [ + ] map-reduce * ;

: read-string ( length -- obj )
    read utf8 decode ;

: read-list ( length -- obj )
    >array [ drop read-any-raw ] map ;

: read-bin ( length -- obj )
    read ;

: read-any-raw ( -- obj )
    1 read be>
    {
      { SMALL_INT [ 1 read be> ] }
      { INT [ 4 read be> ] }
      { SMALL_BIGNUM [ 1 read be> read-bignum ] }
      { LARGE_BIGNUM [ 4 read be> read-bignum ] }
      { NIL [ { } ] }
      { SMALL_TUPLE [ 1 read be> read-tuple ] }
      { LARGE_TUPLE [ 4 read be> read-tuple ] }
      { ATOM [ 2 read be> read-atom ] }
      { STRING [ 2 read be> read-string ] }
      { LIST [ 4 read be> read-list ] }
      { BIN [ 4 read be> read-bin ] }
      [ 8 nip ]
    } case ;

PRIVATE>


: bert> ( byte-array -- obj )
    binary [ 1 read be> VERSION = [ read-any-raw ] [ 5 ] if ] with-byte-reader ;
