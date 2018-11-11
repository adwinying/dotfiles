#
# plugins.zsh
# plugins powered by zgen
#

# install zgen if ~/.zgen does not exist
if [[ ! -d ~/.zgen ]]; then
  git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

# load zgen
source "${HOME}/.zgen/zgen.zsh"


if ! zgen saved; then
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search

  # fuzzy navigation
  zgen load changyuheng/fz
  zgen load rupa/z

  # nvm
  zgen load lukechilds/zsh-nvm

  # generate the init script from plugins above
  zgen save
fi