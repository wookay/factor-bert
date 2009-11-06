! Copyright (C) 2009 Woo-Kyoung Noh.
! See http://factorcode.org/license.txt for BSD license.
USING: math.parser sequences kernel io.binary ;
IN: bert

: ebin ( byte-array -- newseq )
    [ number>string ] { } map-as "," join "<<" ">>" surround ;

: berp ( byte-array -- byte-array )
    [ length 4 >be ] keep append ;
