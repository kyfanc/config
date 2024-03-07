# make package manager installed app discoverable
fish_add_path /opt/homebrew/bin
fish_add_path ~/go/bin
fish_add_path ~/Library/Python/3.9/bin
fish_add_path ~/.cargo/bin

# use vi binding for command editing
set -g fish_key_bindings fish_vi_key_bindings

# editor
set -Ux EDITOR "hx"
set -Ux VISUAL "hx"

if status is-interactive
    # Commands to run in interactive sessions can go here
    eval (zellij setup --generate-auto-start fish | string collect)
end

# enable fish
starship init fish | source
