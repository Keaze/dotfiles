-- Auto-start config
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart

hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("env LC_TIME=en_GB.UTF-8 noctalia") -- English weekday/month names in the bar (system LC_TIME is de_AT)
    hl.exec_cmd("xhost +SI:localuser:root")
    hl.exec_cmd("xembedsniproxy") -- X11/Wine tray icons (e.g. Battle.net) into the Noctalia tray; from plasma-workspace
end)

-- Silence Noctalia popups (OSD incl. mic/volume, notifications) while the gaming workspace is visible
local gamingQuiet = false
local function updateGamingQuiet()
    local visible = false
    for _, m in ipairs(hl.get_monitors()) do
        local ws = m.active_workspace
        if ws and ws.name == "gaming" then visible = true end
    end
    if visible == gamingQuiet then return end
    gamingQuiet = visible
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/gaming-quiet.sh " .. (visible and "on" or "off"))
end
hl.on("workspace.active", updateGamingQuiet)
hl.on("monitor.focused", updateGamingQuiet)

-- Leave the gaming workspace once its last window closes (Hyprland keeps an empty workspace alive while it is shown).
-- Deferred so the closed window is no longer counted.
local gamingLeaveTimer
hl.on("window.destroy", function ()
    gamingLeaveTimer = hl.timer(function ()
        local ws = hl.get_workspace("name:gaming")
        if ws and ws.visible and ws.windows == 0 then
            hl.dispatch(hl.dsp.focus({ workspace = "previous" }))
        end
    end, { timeout = 200, type = "oneshot" })
end)
