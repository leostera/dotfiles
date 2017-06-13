#!/usr/bin/env bash

sudo -v

sudo scutil --set ComputerName "muffintosh"
sudo scutil --set HostName "muffintosh"
sudo scutil --set LocalHostName "muffintosh"

# Disable audio feedback when volume is changed
defaults write com.apple.sound.beep.feedback -bool false

# Show battery percentage
defaults write com.apple.menuextra.battery -bool true

# Disable the "Are you sure oyu want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Check for software updates daily
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

###
#  Input
###

# Trackpad: enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###
#  Screen
###

# Save screenshots to Pictures/Screenshots
mkdir -p ~/Desktop/Screenshots
defaults write com.apple.screencapture location -string "$HOME/Desktop/Screenshots"
