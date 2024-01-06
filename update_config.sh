#!/bin/bash

set -e

link_conf ()
{
	src=$1
	dst=$2
	echo "linking $src -> $dst"
	ln -f "$src" "$dst"
}

echo "updating configs"
link_conf ./tmux/.tmux.conf ~/.tmux.conf
link_conf ./fish/config.fish ~/.config/fish/config.fish
link_conf ./nvim/init.lua ~/.config/nvim/init.lua
echo "all configs are updated"
