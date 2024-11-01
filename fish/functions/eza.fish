function list-dirs --wraps "eza -lD"
    eza -lD $argv
end
function list-files
    eza -lf --color=always | grep -v /
end
