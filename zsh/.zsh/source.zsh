#
# source.zsh
# source files
#

# Source .localrc if available
if [[ -s "$HOME/.localrc" ]]; then
  source "$HOME/.localrc"
fi

# If .localrc is a directory, source all files in it
if [[ -d "$HOME/.localrc" ]]; then
  for file in "$HOME/.localrc"/*; do
    source "$file"
  done
fi

# load directory-specific .profile
PROMPT_COMMAND='if [[ "$profile" != "$PWD" && "$PWD" != "$HOME" && -e .profile ]]; then profile="$PWD"; source .profile; fi'
precmd() { eval "$PROMPT_COMMAND" }
