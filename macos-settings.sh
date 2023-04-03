#!/usr/bin/env bash

#
# macos-settings.sh
# Set sane settings for macOS.
# Commands obtained here:
# https://github.com/herrbischoff/awesome-macos-command-line
#

echox() {
  echo ">> "$1
}

echo " "
echo "# "
echo "# macos-settings.sh"
echo "# "

# Ask for admin password upfront
sudo -v

# Keep admin priviledges alive throughout the duration of the script
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


###############################################################################
# Mail
###############################################################################

# Show Attachments as Icons
defaults write com.apple.mail DisableInlineAttachmentViewing -bool yes


###############################################################################
# Safari
###############################################################################

# Enable devtools
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true && \
defaults write com.apple.Safari IncludeDevelopMenu -bool true && \
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true && \
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true && \
defaults write -g WebKitDeveloperExtras -bool true


###############################################################################
# Dock
###############################################################################

# Get rid of dock hide and show delay
defaults write com.apple.dock autohide-delay -float 0
defaults delete com.apple.dock autohide-time-modifier

# Hide Recent Apps
defaults write com.apple.dock show-recents -bool false


###############################################################################
# Disk Images
###############################################################################

# Disable Disk Image Verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true && \
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true && \
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true


###############################################################################
# Finder
###############################################################################

# Show All File Extensions
defaults write -g AppleShowAllExtensions -bool true

# Show ~/Library Directory
chflags nohidden ~/Library

# Expand Save Panel by Default
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true && \
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

# Show Path Bar
defaults write com.apple.finder ShowPathbar -bool true

# Show Status Bar
defaults write com.apple.finder ShowStatusBar -bool true

# Set save target to local disk (not iCloud) by default
defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false

# Set Current Folder as Default Search Scope
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable Creation of Metadata Files on Network Volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable Creation of Metadata Files on USB Volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true


###############################################################################
# Keyboard
###############################################################################

# Disable Auto-Correct
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# Enable Key Repeat
defaults write -g ApplePressAndHoldEnabled -bool false

# Set Key Repeat Rate
defaults write -g KeyRepeat -int 0.02

# Enable Tab in modal dialogs
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3


###############################################################################
# Launchpad
###############################################################################

# Reset Layout
defaults write com.apple.dock ResetLaunchPad -bool true


###############################################################################
# SSH
###############################################################################

# Enable SSH
sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist


###############################################################################
# Printing
###############################################################################

# Expand Print Panel by Default
defaults write -g PMPrintingExpandedStateForPrint -bool true && \
defaults write -g PMPrintingExpandedStateForPrint2 -bool true

# Quit Printer App After Print Jobs Complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true


###############################################################################
# Gatekeeper
###############################################################################

# Allow unsigned apps to run without prompt
sudo spctl --master-disable

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false


###############################################################################
# Time Machine
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# Alacritty
###############################################################################

# Enable thin fonts
defaults write org.alacritty AppleFontSmoothing -int 0 && \
defaults write alacritty AppleFontSmoothing -int 0

###############################################################################
# Cleanup
###############################################################################

# Kill affected applications
for app in "cfprefsd" "Dock" "Finder" "Mail" "Safari" "SizeUp" \
  "SystemUIServer" "Terminal"; do
  killall "${app}" > /dev/null 2>&1
done

echox "Done. Some of these changes require a logout/restart to take effect."

