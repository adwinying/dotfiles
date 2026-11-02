#
# .zshenv
# environment variables
#

# unmatched globs and =word pass through literally (agents write bash-style commands)
setopt no_nomatch no_equals
# agent shells (non-interactive) also expect bash-style splitting of unquoted $VAR
[[ -o interactive ]] || setopt sh_word_split

# PATHs
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# mise for non-interactive shells (agents, scripts); interactive shells run `mise activate` in plugins.zsh
export PATH=$HOME/.zinit/plugins/mise:$HOME/.local/share/mise/shims:$PATH

# set delay to vi mode to 0.1s
export KEYTIMEOUT=1

# preferred editor for local and remote sessions
export EDITOR=vim
export VISUAL=vim
