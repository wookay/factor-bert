! Copyright (C) 2009 Woo-Kyoung Noh.
! See http://factorcode.org/license.txt for BSD license.
USING: io.streams.byte-array kernel io.encodings.binary io io.binary sequences combinators kernel prettyprint math math.parser arrays assocs strings fry accessors ;
USING: regexp regexp.ast ;
USING: bert.decoder bert.constants ;
IN: bert.decoder

M: sequence read-regex ( seq -- obj )
    2 tail* first2
    [ <regexp> ]
    [ [ {
          { caseless [ case-insensitive ] }
          { dollar_endonly [ unix-lines ] }
          [ ]
        } case ] map <optioned-regexp> ]
   if-empty ;
