! Copyright (C) 2009 Woo-Kyoung Noh.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel strings sequences math math.parser prettyprint arrays calendar
hashtables byte-arrays io.binary io.encodings.utf8 io.encodings.string 
words.symbol accessors combinators fry lists splitting math.functions assocs ;
USING: bert.constants bert.encoder ;
IN: bert.encoder

GENERIC: write-any-raw ( obj -- byte-array )

USING: regexp regexp.ast ;

M: regexp write-any-raw ( regexp -- )
    [ raw>> ]
    [ options>> on>> [ {
        { case-insensitive [ caseless ] }
        { unix-lines [ dollar_endonly ] }
        [ ]
      } case ] map reversed-regexp swap remove ]
    bi '[ bert regex _ _ 4array ] call write-tuple ;
