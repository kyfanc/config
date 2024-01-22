# make package manager installed app discoverable
fish_add_path /opt/homebrew/bin
fish_add_path ~/go/bin
fish_add_path ~/Library/Python/3.9/bin
fish_add_path ~/.cargo/bin

# editor
set -U EDITOR "hx"
# short cut
alias e="$EDITOR"

if status is-interactive
    # Commands to run in interactive sessions can go here
    eval (zellij setup --generate-auto-start fish | string collect)
end
