source /usr/share/cachyos-fish-config/cachyos-config.fish
set -Ux EDITOR nvim

starship init fish | source
zoxide init fish | source
thefuck --alias | source

if status is-interactive
    tv init fish | source
end

abbr -a pacman "sudo pacman"
abbr -a cd z
abbr -a vi nvim
abbr -a vim nvim

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
