#
# aliases.zsh
# aliases
#

# enable aliases with sudo
# -E preserves user env vars while in sudo mode
alias sudo="sudo -E  "

# search aliases
alias sa="alias | grep -i"

# navigation
alias ..="cd .."
alias ....="cd ../.."
alias ......="cd ../../.."
alias ls="ls -G"
alias ll="ls -lh"
alias la="ll -A"
alias fk='sudo $(fc -ln -1)'

# files & directories
alias rmrf="rm -rf"
alias mkdir="mkdir -p"
alias cp="cp -r"

# git
alias ga="git add"
alias gc="git commit"
alias gs="git status"
alias gd="git diff"
alias gf="git fetch"
alias gl="git log"
alias gm="git merge"
alias gr="git rebase"
alias gp="git push"
alias gcm="git commit -m"
alias gco="git checkout"

# tmux
alias tnew='tmux new -s'
alias tatt='tmux attach -t'
alias tkill='tmux kill-session -t'
alias tlist='tmux list-sessions'

# homebrew
alias brewi='brew install'
alias brewl='brew list'
alias brews='brew search'
alias brewu='brew update && brew upgrade'
alias brewx='brew remove'
alias caski='brew install --cask'
alias caskl='brew list --cask'
alias casku='brew upgrade --cask'
alias caskx='brew uninstall --cask'

# applications
alias emacs="vim"
alias dc="docker-compose"
alias vt="vagrant"
alias lg="lazygit"
alias ldc="lazydocker"
alias art="php artisan"

# ls after cd
chpwd() {
  emulate -L zsh
  ls -lh
}

# edit with neovim. If neovim not found use vim
v() {
  nvim "$@" 2> /dev/null || vim "$@"
}

# git Commit All with Message then Push to remote
gitcamp() {
  git add -A;
  git commit -am $1;
  git push origin master;
}

# watch youtube via mpv
# requires youtube-dl
# pip install youtube-dl
yt() {
  youtube-dl $1 -o - | mpv -;
}

# scratchpad
# opens vim for quick editing.
# contents will be saved to ~/.scratchpad/yyyy-mm-dd_HH:MM:SS.txt
# and output to stdout
sp() {
  ~/.dotfiles/scripts/scratchpad.sh
}
