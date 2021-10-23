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

echox " "
echox "Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echox " "
echox "Updating homebrew..."
brew update
brew doctor

echox " "
echox "macOS script done."
sleep 1
