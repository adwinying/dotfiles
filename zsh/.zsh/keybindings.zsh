#
# keybindings.zsh
# keybindings
#

# vi mode
bindkey -v

# ^O to run command
bindkey '^O' accept-line-and-down-history

# zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down


