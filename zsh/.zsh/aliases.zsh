#
# aliases.zsh
# aliases
#

# search aliases
alias sa="alias | grep -i"

# navigation
alias ..="cd .."
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
alias tlist='tmux list-sessions'

# homebrew
alias brewi='brew install'
alias brewl='brew list'
alias brews='brew search'
alias brewu='brew update && brew upgrade'
alias brewx='brew remove'
alias cask='brew cask'
alias caski='brew cask install'
alias caskl='brew cask list'
alias caskx='brew cask uninstall'

# applications
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias emacs="nvim"
alias dc="docker-compose"
alias vt="vagrant"

# ls after cd
function chpwd() {
  emulate -L zsh
  ls -l
}

# git Commit All with Message then Push to remote
gitcamp() {
  git add -A;
  git commit -am $1;
  git push origin master;
}
