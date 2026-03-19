source /usr/share/cachyos-fish-config/cachyos-config.fish
set -Ux EDITOR nvim

starship init fish | source
zoxide init fish | source
thefuck --alias | source

if status is-interactive
    tv init fish | source
end

abbr -a pacman "sudo pacman"
abbr -a pac "sudo pacman"
abbr -a pacu "sudo pacman -Syu"
abbr -a cd z
abbr -a vi nvim
abbr -a vim nvim
abbr -a chze "chezmoi edit"
abbr -a chza "chezmoi apply"
abbr -a chzadd "chezmoi add"
abbr -a chzu "chezmoi update"
abbr -a gll "git log --pretty=oneline"
# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
export PATH="$HOME/.local/bin:$PATH"
