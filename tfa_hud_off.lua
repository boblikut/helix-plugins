local PLUGIN = PLUGIN

PLUGIN.name = "TFA HUD offer"
PLUGIN.description = "Off tfa dynamic HUD and TFA crosshair"
PLUGIN.schema = "Any"

function PLUGIN:PlayerInitialSpawn(ply, trans)
  ply:SendLua(string.format([[RunConsoleCommand("cl_tfa_hud_crosshair_enable_custom",0)]]))
  ply:SendLua(string.format([[RunConsoleCommand("cl_tfa_hud_enabled",0)]]))
  ply:SendLua(string.format([[RunConsoleCommand("cl_tfa_hud_fallback_enabled",0)]]))
  ply:SendLua(string.format([[RunConsoleCommand("cl_tfa_hud_keybindhints_enabled",0)]]))
end
