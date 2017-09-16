/*
//=========================================\\
||    _______        __ _            __    ||
||   / /_   _|      / _| |           \ \   ||
||  / /  | |  _ __ | |_| |_   ___  __ \ \  ||
|| < <   | | | '_ \|  _| | | | \ \/ /  > > ||
||  \ \ _| |_| | | | | | | |_| |>  <  / /  ||
||   \_\_____|_| |_|_| |_|\__,_/_/\_\/_/   ||
|| 	     ____             __ _       	   ||
||	   / ____|           / _(_)      	   ||
||	  | |     ___  _ __ | |_ _  __ _ 	   ||
||	  | |    / _ \| '_ \|  _| |/ _` |	   ||
||	  | |___| (_) | | | | | | | (_| |	   ||
||	   \_____\___/|_| |_|_| |_|\__, |	   ||
||	                            __/ |	   ||
||	                           |___/	   ||
\\=========================================//
*/

-- *Don't touch these lines of code* 
influxhudconfig = influxhudconfig or {}
local cfg = influxhudconfig

-- Config start.

cfg.EnableOHD = true -- Over Head Display.
cfg.EnableOHDRanks = false -- Shows a players rank in the OHD.
cfg.UseWeaponsHud = true -- Set to false if you are using a sweps hud. Example CW 2.0's hud
cfg.UseJobColor = false -- Replaces cfg.MainHudColor

-- Over Head Display.
cfg.Ranks = {
	-- Format / GroupName = Color( red, green, blue )
	user = Color( 25, 255, 25 ),
	admin = Color( 255, 25, 25 ),
}

-- Hud Color Customization
cfg.MainHudColor = Color( 25, 25, 25, 175 ) -- Base color of the hud.