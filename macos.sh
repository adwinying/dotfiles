#!/usr/bin/env bash

echo " "
echo "# "
echo "# macos.sh"
echo "# "

# Pre-install configuration
echox " "
echox "Starting preconfig..."

echox " "
echox "Installing Xcode command-based tools..."
xcode-select --install

echox " "
echox "Searching and installing macOS updates..."
softwareupdate -i -a

echox " "
echox "Preconfig done."

# Install stuff
echox " "
echox "Installing homebrew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echox " "
echox "Updating homebrew..."
brew update
brew doctor

echox " "
echox "Installing zsh..."
brew install zsh

echox " "
echox "Installing powerline font..."
curl -o /Library/Fonts/Inconsolata.otf -k "https://github.com/powerline/fonts/blob/master/Inconsolata/Inconsolata%20for%20Powerline.otf"

echox " "
echox "Installing node..."
brew install node

echox " "
echox "Installing vim..."
brew install macvim --override-system-vim

echox " "
echox "Installing tmux..."
brew install tmux

echox " "
echox "Installing brew cask..."
brew tap caskroom/cask

echox " "
echox "Installing GUI programs..."
brew cask install google-chrome iterm2 flux sublime-text
brew cask install goofy discord skype
brew cask install dropbox cyberduck iina the-unarchiver
brew cask install spotify soundcleod kodi

echox " "
echox "macOS script done."
sleep 1
