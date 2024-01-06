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

echo "all tools installed"

bash ./update_config.sh
