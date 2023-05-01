#
# prompt.zsh
# prompt config
#

COLOR_ROOT="%F{red}"
COLOR_USER="%F{cyan}"
COLOR_NORMAL="%F{white}"
COLOR_VIM="%F{yellow}"

COLOR_CLEAN="%F{green}"
COLOR_DIRTY="%F{red}"

ICO_AHEAD="↑"
ICO_BEHIND="↓"
ICO_DIVERGED="↕"
ICO_DIRTY="*"


# allow functions in the prompt
setopt PROMPT_SUBST

# init colors
autoload -Uz colors && colors


# prompt accent color
function set-prompt() {
  if [[ "$EUID" -ne "0" ]]
  then  # if user is not root
    COLOR_ACCENT="${COLOR_USER}"
  else # root!
    COLOR_ACCENT="${COLOR_ROOT}"
  fi
}

# switch colors when in vi mode
function zle-line-init zle-keymap-select {
  case ${KEYMAP} in
    (vicmd)      COLOR_ACCENT="${COLOR_VIM}" ;;
    (*)          set-prompt ;;
  esac

  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Show hostname if it's an SSH session
HOSTNAME() {
  if [[ -z $SSH_CLIENT ]] && [[ -z $SSH_TTY ]] && [[ -z $SSH_CONNECTION ]]; then
    return
  fi

  echo "${COLOR_ACCENT}[${COLOR_NORMAL}%m${COLOR_ACCENT}]─"
}

# Show current directory
CURR_DIR() {
  if [[ -n $DIRENV_DIR ]]; then
    direnv_label="(direnv) "
  else
    direnv_label=""
  fi

  echo "${COLOR_ACCENT}[${COLOR_NORMAL}$direnv_label%~${COLOR_ACCENT}]"
}

# git prompt
GIT_PROMPT() {
  is_git_directory=$(git rev-parse --is-inside-work-tree 2> /dev/null)

  if [[ ! $is_git_directory ]] || [[ $SHOW_GIT_PROMPT == "false" ]]; then
    return
  fi

  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules)"
  }

  ref=$(git name-rev --name-only HEAD | sed 's!remotes/!!' 2> /dev/null)
  stat=$(git status | sed -n 2p)

  if is_dirty; then
    COLOR_GIT=$COLOR_DIRTY
  else
    COLOR_GIT=$COLOR_CLEAN
  fi

  case "$stat" in
    *ahead*)
      stat=$ICO_AHEAD
    ;;
    *behind*)
      stat=$ICO_BEHIND
    ;;
    *diverged*)
      stat=$ICO_DIVERGED
    ;;
    *)
      stat=""
    ;;
  esac

  echo "${COLOR_ACCENT}─[${COLOR_GIT}"${ref}${stat}"${COLOR_ACCENT}]"
}

PROMPT='$(HOSTNAME)$(CURR_DIR)$(GIT_PROMPT) » %f'
