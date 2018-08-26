#!/usr/bin/env bash

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
brew tap caskroom/fonts
brew cask install font-inconsolata-for-powerline

echox " "
echox "Installing vim..."
brew install macvim --with-override-system-vim

echox " "
echox "Installing tmux..."
brew install tmux

echox " "
echox "Installing GUI programs..."
brew cask install google-chrome iterm2 flux sublime-text
brew cask install goofy discord skype
brew cask install dropbox cyberduck iina the-unarchiver
brew cask install spotify soundcleod kodi
brew cask install tunnelblick

echox " "
echox "Creating subl symlink..."
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl

echox " "
echox "macOS script done."
sleep 1
