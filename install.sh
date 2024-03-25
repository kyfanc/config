#!/bin/bash

set -e

# install brew
if [ ! $(which brew) ]; then
	echo "installing brew..."
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

#
# install brew packages
#
brew bundle install --file=brewfile
 
#
# zellij plugins
#
echo "downloading zellij plugins"
mkdir -p zellij/plugins
curl -L https://github.com/dj95/zjstatus/releases/download/v0.13.0/zjstatus.wasm > zellij/plugins/zjstatus.wasm
echo "zellij plugins are downloaded"
echo "!! ACTION_ITEM: might require granting permission on first launch!"

echo "all tools are installed"

bash ./update_config.sh

#
#  fish
#
echo "configuring fish"
chsh -s $(which fish)
echo $(which fish) >> /etc/shells
echo "set fish as default shell"
echo "fish is ready"

#
#  screenshots
mkdir -p ~/Screenshots
defaults write com.apple.screencapture ~/Screenshots

ehco "!! ACTION_ITEMS:"
echo "- import custom.iterm.json profile to iterm2"

echo "done"

