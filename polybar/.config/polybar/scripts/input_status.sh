#! /bin/bash

INPUT=$(ibus engine)
EN="xkb:us::eng"
JA="mozc-jp"
ZH="rime"

if [[ $INPUT == $EN ]]; then
  echo 'EN'
elif [[ $INPUT == $JA ]]; then
  echo 'JA'
elif [[ $INPUT == $ZH ]]; then
  echo 'ZH'
else
  echo '??'
fi
