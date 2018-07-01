#!/usr/bin/env bash

# Close all open System Preferences panes
osascript -e 'tell application "System Preferences" to quit'

readonly HOSTNAME="muffintosh"

sudo scutil --set ComputerName ${HOSTNAME}
sudo scutil --set HostName ${HOSTNAME}
sudo scutil --set LocalHostName ${HOSTNAME}
sudo hostname ${HOSTNAME}

# Disable audio feedback when volume is changed
defaults write com.apple.sound.beep.feedback -bool false

# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -bool true

# Disable the "Are you sure oyu want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Check for software updates daily
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Expand save panel
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###
#  Finder
###

# Show all files
defaults write com.apple.Finder AppleShowAllFiles -bool true

# Show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show ~/Library
chflags nohidden ~/Library


###
#  Input
###

# Trackpad: enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###
#  Screen
###

# Save screenshots to Pictures/Screenshots
mkdir -p ~/Desktop/Screenshots
defaults write com.apple.screencapture location -string "$HOME/Desktop/Screenshots"
