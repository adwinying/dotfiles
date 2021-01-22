#!/usr/bin/env bash

#
# macos.sh
# Install and configure commonly used apps in macOS.
#

echox() {
  echo ">> "$1
}

echo " "
echo "# "
echo "# macos.sh"
echo "# "

# Pre-install configuration
echox " "
echox "Starting preconfig..."

echox " "
echox "Searching and installing macOS updates..."
softwareupdate -i -a

echox " "
echox "Installing Xcode command-based tools..."
xcode-select --install

echox " "
echox "Preconfig done."

# Install stuff
echox " "
echox "Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echox " "
echox "Updating homebrew..."
brew update
brew doctor

echox " "
echox "Installing zsh..."
brew install zsh

echox " "
echox "Installing fzf..."
brew install fzf

echox " "
echox "Installing lazygit..."
brew install lazygit

echox " "
echox "Installing powerline font..."
brew tap homebrew/cask-fonts
brew install --cask font-inconsolata-for-powerline

echox " "
echox "Installing vim..."
brew install macvim

echox " "
echox "Installing tmux..."
brew install tmux

echox " "
echox "Installing yarn..."
brew install yarn

echox " "
echox "Installing GUI programs..."
brew install --cask brave-browser iterm2 flux rectangle sublime-text karabiner-elements
brew install --cask cyberduck mpv the-unarchiver discord messenger

echox " "
echox "macOS script done."
sleep 1
