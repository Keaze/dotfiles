-- Auto-start config
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart

hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("env LC_TIME=en_GB.UTF-8 noctalia") -- English weekday/month names in the bar (system LC_TIME is de_AT)
    hl.exec_cmd("xhost +SI:localuser:root")
    hl.exec_cmd("xembedsniproxy") -- X11/Wine tray icons (e.g. Battle.net) into the Noctalia tray; from plasma-workspace
end)
