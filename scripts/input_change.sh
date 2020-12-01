#! /bin/bash

INPUT=$(ibus engine)
EN="xkb:us::eng"
JA="mozc-jp"
ZH="rime"

if [[ $INPUT == $EN ]]; then
  ibus engine $JA
elif [[ $INPUT == $JA ]]; then
  ibus engine $ZH
elif [[ $INPUT == $ZH ]]; then
  ibus engine $EN
fi
