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
echo $DOTFILES_DIR

# macOS-specific stuff
if [[ $OSTYPE == "darwin"* ]]; then
  echox " "
  echox "macOS detected. Running macOS-specific commands"

  sleep 1

  source $DOTFILES_DIR/macos.sh
else
  echox " "
  echox "non-macOS install detected."

  if [[ -x "$(command -v zsh)" ]]; then
    echox "zsh install detected."
    sleep 1
  else
    echox "Please install zsh before proceeding."
    return 1
  fi
fi

echox " "
echox "Changing default shell to zsh..."
chsh -s /bin/zsh

if [[ -f $HOME/.zshrc && ! -L $HOME/.zshrc ]]; then
  echox " "
  echox ".zshrc exists. Renaming to .localrc..."
  mv $HOME/.zshrc $HOME/.localrc
fi

echox " "
echox "Symlinking .zshrc..."
for rcfile in $DOTFILES_DIR/prezto/runcoms/*; do
  ln -s "$rcfile" "$HOME/."`basename "$rcfile"`
done
rm -rf $HOME/.README.md

echox " "
echox "Symlinking .gitconfig..."
ln -s $DOTFILES_DIR/modules/.gitconfig $HOME/.gitconfig

#symlink vimrc?
