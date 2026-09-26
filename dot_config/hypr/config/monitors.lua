-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Device-specific monitor rules live in config/local.lua (not tracked by chezmoi).

-- Fallback for every monitor without its own rule
hl.monitor({
    output    = "",
    mode      = "preferred",
    position  = "auto",
    scale     = "auto",
})
