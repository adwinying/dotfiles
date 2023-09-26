#
# plugins.zsh
# plugins powered by zinit
#

# install zinit if ~/.zinit does not exist
if [[ ! -d ~/.zinit ]]; then
  mkdir ~/.zinit
  git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi

# load zinit
source ~/.zinit/bin/zinit.zsh


# syntax highlighting
zinit ice wait lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zinit load zdharma-continuum/fast-syntax-highlighting

# suggestions on tab
zinit ice wait lucid blockf
zinit load zsh-users/zsh-completions

# fish-like autosuggestions
zinit ice wait lucid atload"!_zsh_autosuggest_start"
zinit load zsh-users/zsh-autosuggestions

# subtring search
zinit ice wait lucid atload" \
bindkey '^[[A' history-substring-search-up && \
bindkey '^[[B' history-substring-search-down && \
bindkey '^P' history-substring-search-up && \
bindkey '^N' history-substring-search-down && \
bindkey -M vicmd 'k' history-substring-search-up && \
bindkey -M vicmd 'j' history-substring-search-down \
"
zinit load zsh-users/zsh-history-substring-search

# cli fuzzy finder
zinit pack"binary" for fzf

# fuzzy navigation
zinit ice wait lucid
zinit load agkozak/zsh-z

# nvm
export NVM_SYMLINK_CURRENT=true
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true
zinit light lukechilds/zsh-nvm

# docker completions
zinit ice wait lucid as"completion"
zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker
zinit ice wait lucid as"completion"
zinit snippet https://github.com/docker/compose/tree/v1/contrib/completion/zsh/_docker-compose
