#
# source.zsh
# source files
#

# load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Source .localrc if available
if [[ -s "$HOME/.localrc" ]]; then
  source "$HOME/.localrc"
fi
