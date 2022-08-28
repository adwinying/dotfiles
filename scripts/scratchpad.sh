#! /bin/bash
DIR=~/.scratchpad
FILE="$(date "+%Y-%m-%d_%H:%M:%S").txt"
FPATH=$DIR/$FILE

# use neovim if available; else use vim
if command -v nvim &> /dev/null
then
  VIM=nvim
else
  VIM=vim
fi

# create scratchpad directory if it doesn't exist
mkdir -p $DIR

# create new file in scratchpad directory
$VIM $FPATH

if [[ -f $FPATH ]]; then
  # if file exists print to stdout
  cat $FPATH

  # ... and copy to clipboard
  if [[ $OSTYPE == "darwin"* ]]; then pbcopy < $FPATH; fi
  if [[ $OSTYPE == "linux-gnu" ]]; then xclip < $FPATH; fi
fi
