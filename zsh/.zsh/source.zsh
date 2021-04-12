#
# source.zsh
# source files
#

# Source .localrc if available
if [[ -s "$HOME/.localrc" ]]; then
  source "$HOME/.localrc"
fi
