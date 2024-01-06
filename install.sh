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
		brew install nvim
	fi
	echo "$app is installed"
}

ensure_brew_installed fish
ensure_brew_installed tmux
ensure_brew_installed nvim
ensure_brew_installed tree
ensure_brew_installed htop

echo "all tools are installed"

bash ./update_config.sh

#
#  fish
#
echo "configuring fish"
chsh -s $(which fish)
echo "set fish as default shell"
echo "fish is ready"

#
# tmux
#
echo "configuring tmux"

echo "installing tpm"
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "installing tpm plugins"
~/.tmux/plugins/tpm/scripts/install_plugins.sh

./setup_mac_terminal.sh

echo "tmux is ready"


