# make package manager installed app discoverable
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/coreutils/libexec/gnubin
fish_add_path /opt/homebrew/opt/gnu-sed/libexec/gnubin
fish_add_path /opt/homebrew/opt/gawk/libexec/gnubin
fish_add_path /opt/homebrew/opt/findutils/libexec/gnubin
fish_add_path /opt/homebrew/opt/grep/libexec/gnubin
fish_add_path ~/go/bin
fish_add_path ~/.cargo/bin

# add custom fish function folder
set -Up fish_function_path ~/.config/fish/functions/custom

# key-bind
# avoid accidentally killing fish shell
bind \cd end-of-line

# alias
alias ls "eza --all --long --group --group-directories-first --icons --header --time-style long-iso"

# editor
set -Ux EDITOR hx
set -Ux VISUAL hx

# brew
set -Ux HOMEBREW_NO_AUTO_UPDATE 1

# rg config path
set -Ux RIPGREP_CONFIG_PATH ~/.ripgreprc

# env specific config
if test -e ~/.config/fish/config.custom.fish
    source ~/.config/fish/config.custom.fish
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    eval (zellij setup --generate-auto-start fish | string collect)
end

# enable shell toolings
starship init fish | source
zoxide init fish | source
