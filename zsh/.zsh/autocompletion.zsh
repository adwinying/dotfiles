#
# autocompletion.zsh
# autocomplete
#

# highlight select
zstyle ':completion:*' menu select

# case insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'