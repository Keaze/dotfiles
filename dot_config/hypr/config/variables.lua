-- Hyprland default apps

TERMINAL     = "kitty -c " .. os.getenv("HOME") .. "/.config/kitty/hyprland.conf"
FILE_MANAGER = "dolphin"
BROWSER      = "zen-browser"
EDITOR       = "gnome-text-editor --new-window"
CALCULATOR   = "gnome-calculator"

-- Monitors (generic defaults; real names are set per device in config/local.lua)
MONITOR1 = ""
MONITOR2 = ""
MONITOR3 = ""

-- Device-specific overrides: config/local.lua is NOT tracked by chezmoi.
-- It may set MONITOR1-3, PRIMARY_MONITOR and hl.monitor() rules. Missing file is fine.
local ok, err = pcall(require, "config.local")
if not ok and not tostring(err):find("module 'config.local' not found", 1, true) then
    error(err)
end
PRIMARY_MONITOR = PRIMARY_MONITOR or MONITOR1

-- Workspaces
NUM_WPM = 3 -- Number of workspaces per monitor (Max 10)
