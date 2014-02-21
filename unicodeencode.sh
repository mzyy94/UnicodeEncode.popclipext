#!/bin/bash

#support UTF-8 characters
export LANG="en_US.UTF-8"
string=$(iconv -f UTF-8-MAC -t UTF-8 <<< $POPCLIP_TEXT)

for ((i = 0; i < ${#string}; i++)) {

    char=${string:$i:1}

    utf8_raw="0x$(xxd -ps <<< $char)"
    digit_raw=$(printf "%d" $utf8_raw)

    #remove '0a'
    digit=$(expr $digit_raw / 256)

    if [ $digit -lt 256 ]; then
        unicode=$digit
    elif [ $digit -lt 65536 ]; then
        unicode=$(expr \( $digit / 256 - 192 \) \* 64 + \
            $digit % 256 - 128 )
    elif [ $digit -lt 16777216 ]; then
        unicode=$(expr \( $digit / 65536 - 224 \) \* 4096 + \
            \( \( $digit / 256 \) % 256 - 128 \) \* 64 + \
            $digit % 256 - 128 )
    else
        unicode=$(expr \( $digit / 16777216 - 240 \) \* 262144 + \
            \( \( $digit / 65536 \) % 256 - 128 \) \* 4096 + \
            \( \( $digit / 256 \) % 256 - 128 \) \* 64 + \
            $digit % 256 - 128 )
    fi

    printf "\\u%04x" $unicode

}
