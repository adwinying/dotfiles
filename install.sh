#!/usr/bin/env bash

echo " "
echo "# "
echo "# Adwin's terminal configurator"
echo "# "

echox() {
  echo ">> "$1
}

# Configuring dotfiles dir
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echox " "
echox "\$DOTFILES_DIR: "$DOTFILES_DIR

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

  echox " "
  echox "Changing default shell to zsh..."
  chsh -s /bin/zsh
fi

if [[ -f $HOME/.zshrc && ! -L $HOME/.zshrc ]]; then
  echox " "
  echox ".zshrc exists. Renaming to .localrc..."
  mv $HOME/.zshrc $HOME/.localrc
fi

echox " "
echox "Cloning prezto..."
git clone --recursive https://github.com/sorin-ionescu/prezto.git $DOTFILES_DIR/prezto

echox " "
echox "Replacing runcoms folder in prezto..."
rm -rf $DOTFILES_DIR/prezto/runcoms
ln -s $DOTFILES_DIR/runcoms $DOTFILES_DIR/prezto/runcoms

echox " "
echox "Symlinking .zshrc..."
for rcfile in $DOTFILES_DIR/prezto/runcoms/*; do
  ln -s "$rcfile" "$HOME/."`basename "$rcfile"`
done

echox " "
echox "Symlinking .gitconfig..."
ln -s $DOTFILES_DIR/modules/.gitconfig $HOME/.gitconfig

echox " "
echox "Symlinking .vim..."
ln -s $DOTFILES_DIR/modules/vim $HOME/.vim

echox " "
echox "Symlinking .tmux.conf..."
ln -s $DOTFILES_DIR/modules/tmux/tmux.conf $HOME/.tmux.conf

echox " "
echox "install.sh done. Enjoy!"
sleep 2
