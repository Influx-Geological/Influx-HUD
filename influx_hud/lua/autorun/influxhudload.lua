-- Loading Hud
local modules = file.Find( "influxhud/*.lua", "LUA" )
influxhud = influxhud or {}
influxhudpost = influxhudpost or {}
influxhudconfig = influxhudconfig or {}
local cfg = influxhudconfig

	-- Loading Modules
	if SERVER then
		for _, svfile in ipairs( modules ) do
			AddCSLuaFile( "influxhud/" .. svfile )
		end
	end

	if CLIENT then
		for _, clfile in ipairs( modules ) do
			include( "influxhud/" .. clfile )
		end
	end
	-- End of module loading

	-- Loading Config
	if SERVER then
		AddCSLuaFile( "influxhudconfig.lua" )
	end

	if CLIENT then
		include( "influxhudconfig.lua" )
	end
	-- End of config loading

-- End of loading

-- Drawing the hud
if CLIENT then
	surface.CreateFont( "InfluxEnitiyDisplay", {
		font = "Arial",
		extended = false,
		size = 50,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )
	if cfg.EnableOHD then
		Influxhide = {
			CHudBattery = true,
			CHudHealth = true,
		 	CHudAmmo = true,
		    CHudSecondaryAmmo = true,
		   	DarkRP_HUD = true,
		   	DarkRP_EntityDisplay = true,
		    DarkRP_LocalPlayerHUD = true,
		    DarkRP_Hungermod = true,
		    DarkRP_ZombieInfo = true
		}
	else
		Influxhide = {
			CHudBattery = true,
			CHudHealth = true,
		 	CHudAmmo = true,
		    CHudSecondaryAmmo = true,
		   	DarkRP_HUD = true,
		   	DarkRP_EntityDisplay = false,
		    DarkRP_LocalPlayerHUD = true,
		    DarkRP_Hungermod = true,
		    DarkRP_ZombieInfo = true
		}
	end
	hook.Add( "HUDShouldDraw", "InfluxHide", function( name )
		if ( Influxhide[ name ] ) then return false end
	end )

	function DrawInfluxHud()
		if InfluxApiLoaded == true then
			InfluxAPIFailed = false
			localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
			if IsValid(localplayer) then
				for k, v in pairs( influxhud ) do
					v()
				end
			end
		else
			InfluxAPIFailed = true
		end
	end
	hook.Add( "HUDPaint", "InfluxHudPaint", DrawInfluxHud )
	if cfg.EnableOHD then
		local function DrawInfluxPostPlayer( ply )
		 	if !ply:Alive() then return end
			if InfluxAPIFailed == false then
				localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer()
				if IsValid(localplayer) then
					for k, v in pairs( influxhudpost ) do
						v(ply)
					end
				end
			end
		 
		end
		hook.Add( "PostPlayerDraw", "DrawInfluxPostPlayer", DrawInfluxPostPlayer )
	end

	function cfg.GetColor()
		if cfg.UseJobColor then
			return team.GetColor( LocalPlayer():Team() )
		else
			return cfg.MainHudColor
		end
	end
end
-- End of drawing

InfluxHudLoaded = true

if CLIENT then
	timer.Simple( 7, function()
		if InfluxAPIFailed then
			chat.AddText( Color( 255, 25, 25 ), "[WARNING]", Color( 255, 255, 255 ), ": Influx API not present!" )
		end
	end )
end