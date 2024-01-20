#!/bin/bash

set -e

link_conf ()
{
	src=$1
	dst=$2
	echo "linking $src as $dst"
	ln -f "$src" "$dst"
}

echo "updating configs"
link_conf ./tmux/.tmux.conf ~/.tmux.conf
link_conf ./fish/config.fish ~/.config/fish/config.fish
echo "linking $(pwd)/nvim as ~/.config/nvim"
ln -sf $(pwd)/nvim ~/.config/nvim
echo "linking $(pwd)/helix as ~/.config/helix"
ln -sf $(pwd)/helix ~/.config/helix
echo "linking $(pwd)/zellij as ~/.config/zellij"
ln -sf $(pwd)/zellij ~/.config/zellij 
echo "all configs are updated"
