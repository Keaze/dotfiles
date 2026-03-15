source /usr/share/cachyos-fish-config/cachyos-config.fish
starship init fish | source
zoxide init fish | source

if status is-interactive
	tv init fish | source
end


alias cd=z
# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
