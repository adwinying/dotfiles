#
# source.zsh
# source files
#

# Source .localrc if available
if [[ -s "$HOME/.localrc" ]]; then
  source "$HOME/.localrc"
fi

# load directory-specific .profile
PROMPT_COMMAND='if [[ "$profile" != "$PWD" && "$PWD" != "$HOME" && -e .profile ]]; then profile="$PWD"; source .profile; fi'
precmd() { eval "$PROMPT_COMMAND" }
