! Copyright (C) 2009 Woo-Kyoung Noh.
! See http://factorcode.org/license.txt for BSD license.
USING: math.parser sequences kernel io.binary splitting ;
IN: bert


: >ebin ( byte-array -- newseq )
    [ number>string ] { } map-as "," join "<<" ">>" surround ;

: ebin> ( seq -- byte-array )
    2 tail 2 head* "," split [ string>number ] B{ } map-as ;

: >berp ( byte-array -- byte-array )
    [ length 4 >be ] keep append ;

: berp> ( byte-array -- byte-array )
    4 tail ;
