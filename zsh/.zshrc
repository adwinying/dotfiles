#
# Adwin's zsh config
# inspired by https://github.com/xero/dotfiles
#

# set collate
export LC_COLLATE=C

# disable software flow control (Enable C-Q/C-S in terminal)
stty -ixon

# load configs
for config (~/.zsh/*.zsh) source $config
