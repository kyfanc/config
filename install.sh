#!/bin/bash

set -e

# install brew
if [ ! $(which brew) ]; then
	echo "installing brew..."
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

ensure_brew_installed() {
	app=$1
	if [ ! $(which "$app") ]; then
		echo "installing $app..."
		brew install $app
	fi
	echo "$app is installed"
}

ensure_brew_installed fish
ensure_brew_installed zellij
ensure_brew_installed starship
ensure_brew_installed tree
ensure_brew_installed htop
ensure_brew_installed git-delta
ensure_brew_installed bat
# for recording terminal
ensure_brew_installed asciinema
# for converting recording to gif
ensure_brew_installed agg
 
#
# zellij plugins
#
echo "downloading zellij plugins"
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
echo "set fish as default shell"
echo "fish is ready"

echo "installing font"
brew tap homebrew/cask-fonts
brew install --cask font-fira-code-nerd-font
ehco "!! ACTION_ITEM: import custom.iterm.json profile to iterm2"

echo "done"

