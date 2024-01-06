# !/bin/bash

set -e

echo "configuring terminal app"

echo "installing font-hack"
brew tap homebrew/cask-fonts
brew install font-hack

echo "setting font and font size"
osascript << EOF
tell application "Terminal"
	set ProfilesNames to name of every settings set
	repeat with ProfileName in ProfilesNames
		set font name of settings set ProfileName to "Hack Regular"
		set font size of settings set ProfileName to 18
	end repeat
end tell
EOF

echo "terminal app is configured"
