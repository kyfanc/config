#!/bin/bash

set -e

link_file ()
{
	src=$1
	dst=$2
	echo "linking $src as $dst"
	ln -f "$src" "$dst"
}

link_folder()
{
	src=$1
	dst=$2
	echo "linking $src as $dst"
	ln -sf "$src" "$dst"
}

echo "updating configs"
mkdir -p ~/.config

link_file $(pwd)/.gitconfig ~/.gitconfig
link_file $(pwd)/fish/config.fish ~/.config/fish/config.fish
link_folder $(pwd)/functions ~/.config/fish/functions
link_file $(pwd)/starship/starship.toml ~/.config/starship.toml
link_folder $(pwd)/helix ~/.config/
link_folder $(pwd)/zellij ~/.config/
link_folder $(pwd)/gitui ~/.config/

echo "all configs are updated"
