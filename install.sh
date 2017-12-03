#!/usr/bin/env bash

echo " "
echo "# "
echo "# Adwin's terminal configurator"
echo "# "

echox() {
  echo ">> "$1
}

# Configuring dotfiles dir
export DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# macOS-specific stuff
if [[ $OSTYPE == "darwin"* ]]; then
  echox " "
  echox "macOS detected. Running macOS-specific commands"

  sleep 1

  source $DOTFILES_DIR/macos.sh
else
  echox " "
  echox "non-macOS install detected."

  echo -n ">> Did you install zsh & vim? [y/N]"
  read choice
  if [[ "$choice" == y || "$choice" == Y ]]; then
    echox " "
  else
    echox "Please install zsh & vim before proceeding."
    return 1
  fi
fi

echox " "
echox "Changing default shell to zsh..."
chsh -s /bin/zsh

if [[ -e $HOME/.zshrc ]]; then
  echox " "
  echox ".zshrc exists. Renaming to .localrc..."
  mv $HOME/.zshrc $HOME/.localrc
fi

echox " "
echox "Symlinking .zshrc..."
setopt EXTENDED_GLOB
for rcfile in $DOTFILES_DIR/prezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "$HOME/."`basename "$rcfile"`
done

echox " "
echox "Symlinking .gitconfig..."
ln -s $DOTFILES_DIR/git/.gitconfig $HOME/.gitconfig

#symlink vimrc?
#config term color + font?
#do smth bout system/* files