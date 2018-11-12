#
# qkeybindings.zsh
# keybindings
# appended 'q' as a shitty hack to load this after plugins.zsh
#

# zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
