#
# Adwin's zsh config
# inspired by https://github.com/xero/dotfiles
#

# set collate
export LC_COLLATE=C

# load configs
for config (~/.zsh/*.zsh) source $config

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
