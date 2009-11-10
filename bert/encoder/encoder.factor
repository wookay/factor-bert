! Copyright (C) 2009 Woo-Kyoung Noh.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel strings sequences math math.parser prettyprint arrays calendar
hashtables byte-arrays io.binary io.encodings.utf8 io.encodings.string 
words.symbol accessors combinators fry lists splitting math.functions assocs ;
USE: bert.constants
IN: bert.encoder

TUPLE: bert-tuple seq ;

GENERIC: write-any-raw ( obj -- byte-array )

: >bert ( obj -- byte-array )
    VERSION 1 >be [ write-any-raw ] dip prepend ;

: write-tuple ( seq -- byte-array )
    [ length dup 256 <
      [ '[ SMALL_TUPLE _ 2byte-array ] call ]
      [ '[ LARGE_TUPLE 1 >be _ 4 >be ] call append ] if ]
    [ [ write-any-raw ] [ append ] map-reduce ] bi append ;

<PRIVATE

: write-bignum-guts ( bignum -- byte-array )
   [ 0 >= [ 0 ] [ 1 ] if 1 >be ]
   [ abs 0 2array { } swap
    [ dup first2 8 * neg shift 256 mod dup zero? not ]
    [ 1array rot prepend swap first2 1 + 2array ] while 2drop [ 1 >be ] [ append ] map-reduce ] bi append ;


: MAX_INT ( -- n ) 1 27 shift 1 - ;
: MIN_INT ( -- n ) 1 27 shift neg ;

M: integer write-any-raw ( num -- )
    dup [ 0 >= ] [ 256 < ] bi and
      [ '[ SMALL_INT _ 2byte-array ] call ]
      [ dup [ MAX_INT <= ] [ MIN_INT >= ] bi and
          [ '[ INT 1 >be _ 4 >be ] call append ]
          [ >bignum write-any-raw ] if ] if ;

M: bignum write-any-raw ( bignum -- )
    [ >bin length 8.0 / ceiling >fixnum dup 
      256 <= [ '[ SMALL_BIGNUM 1 >be _ 1 >be ] call ]
             [ '[ LARGE_BIGNUM 1 >be _ 4 >be ] call ] if append
    ] [ write-bignum-guts ] bi append ;

M: string write-any-raw ( obj -- )
    [ NIL 1 >be ]
    [ STRING 1 >be [ utf8 encode [ length 2 >be ] [ ] bi append ] dip prepend ]
    if-empty ;

M: byte-array write-any-raw ( byte-array -- ) 
    BIN 1 >be [ [ length 4 >be ] [ ] bi append ] dip prepend ;

M: f write-any-raw ( f -- )
    { bert false } write-tuple nip ;

M: symbol write-any-raw ( obj -- )
    { { t [ { bert true } write-tuple ] } 
      [ name>> ATOM 1 >be 
        [ utf8 encode [ length 2 >be ] [ ] bi append ] dip prepend ] } case ;

M: sequence write-any-raw ( array -- ) 
    [ B{ } ]
    [ LIST 1 >be [ [ length 4 >be ] [ [ write-any-raw ] [ append ] map-reduce ] bi append ] dip prepend ] 
    if-empty NIL 1 >be append ;

M: bert-tuple write-any-raw ( bert-tuple -- ) 
    seq>> write-tuple ;

M: list write-any-raw ( list -- )
    {
      { nil [ B{ 104 2 100 0 4 98 101 114 116 100 0 3 110 105 108 } ] }
      [ list>array write-any-raw ]
    } case ;

M: hashtable write-any-raw ( hashtable -- )
    [ ] { } assoc-map-as '[ bert dict _ 3array ] call write-tuple ;

M: timestamp write-any-raw ( timestamp -- )
    timestamp>micros 
    [ 1000000 / [ 1000000 / >fixnum ] [ 1000000 mod >fixnum ] bi ] 
    [ 1000000 mod ] bi 3array { bert time } prepend write-tuple ;


! from John Benediktsson's formatting.factor
: pad-digits ( string digits -- string' )
    [ "." split1 ] dip [ CHAR: 0 pad-tail ] [ head-slice ] bi "." glue ;
: max-digits ( n digits -- n' )
    10^ [ * round ] keep / ; inline
: >exp ( x -- exp base )
    [ abs 0 swap [ dup [ 10.0 >= ] [ 1.0 < ] bi or ]
        [ dup 10.0 >= [ 10.0 / [ 1 + ] dip ] [ 10.0 * [ 1 - ] dip ] if ] while
    ] keep 0 < [ neg ] when ;
: exp>string ( exp base digits -- string )
    [ max-digits ] keep -rot
    [ [ 0 < "-" "+" ? ] [ abs number>string 2 CHAR: 0 pad-head ] bi
        "e" -rot 3append ] [ number>string ] bi* rot pad-digits prepend ;

M: real write-any-raw ( num -- )
    FLOAT 1 >be [ >exp 15 exp>string 31 CHAR: \0 pad-tail ] dip prepend ;

PRIVATE>
