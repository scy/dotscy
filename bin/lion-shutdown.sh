#!/bin/sh

defaults write com.apple.loginwindow TALLogoutSavesState 0
osascript -e 'tell application "System Events" to shut down'
