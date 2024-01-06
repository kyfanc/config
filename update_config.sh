#!/bin/bash

link_conf ()
{
	src=$1
	dst=$2
	echo "linking $src -> $dst"
	ln -f "$src" "$dst"
}

link_conf ./tmux/.tmux.conf ~/.tmux.conf
link_conf ./fish/config.fish ~/.config/fish/config.fish
link_conf ./nvim/init.lua ~/.config/nvim/init.lua

