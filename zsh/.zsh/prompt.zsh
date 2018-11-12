#
# prompt.zsh
# prompt config
#

COLOR_ROOT="%F{red}"
COLOR_USER="%F{cyan}"
COLOR_NORMAL="%F{white}"

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


# prompt color
if [[ "$EUID" -ne "0" ]]
then  # if user is not root
  COLOR_ACCENT="${COLOR_USER}"
else # root!
  COLOR_ACCENT="${COLOR_ROOT}"
fi

# Show hostname if it's an SSH session
HOSTNAME() {
  if [[ -z $SSH_CLIENT ]] && [[ -z $SSH_TTY ]] && [[ -z $SSH_CONNECTION ]]; then
    return
  fi

  echo "${COLOR_ACCENT}[${COLOR_NORMAL}%m${COLOR_ACCENT}]─"
}

# Show current directory
CURR_DIR() {
  echo "${COLOR_ACCENT}[${COLOR_NORMAL}%~${COLOR_ACCENT}]"
}

# git prompt
GIT_PROMPT() {
  is_git_directory=$(git rev-parse --is-inside-work-tree 2> /dev/null)

  if [[ ! $is_git_directory ]] || [[ $SHOW_GIT_PROMPT == "false" ]]; then
    return
  fi

  ref=$(git name-rev --name-only HEAD | sed 's!remotes/!!' 2> /dev/null)
  diff=$(git diff --shortstat 2> /dev/null | tail -n1) 
  stat=$(git status | sed -n 2p)

  if [[ $diff == "" ]]; then
    COLOR_GIT=$COLOR_CLEAN
  else
    COLOR_GIT=$COLOR_DIRTY
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
