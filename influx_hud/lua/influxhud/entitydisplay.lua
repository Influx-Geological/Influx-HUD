-- influx Hud 
influxhudconfig = influxhudconfig or {}
local cfg = influxhudconfig

local InfluxTextCount = 0
local DisplayAlpha = 255

function InfluxUppercase(text)
    return (text:gsub("^%l", string.upper))
end

function InfluxAddText(ply, func, number, color)
	InfluxTextCount = number
	local TextFunc = func or "ERROR"
	surface.SetFont( "InfluxEnitiyDisplay" )
	local TextW, TextH = surface.GetTextSize( TextFunc )
	influx.RoundedBox( 5, 180, 155 + ( 55 * ( InfluxTextCount - 1 ) ), 10 + TextW, TextH, Color( 25, 25, 25, DisplayAlpha )  )
	influx.Text( func, "InfluxEnitiyDisplay", 185, 155 + ( 55 * ( InfluxTextCount - 1 ) ), Color( color.r, color.g, color.b, color.a ), TEXT_ALIGN_LEFT )
end

function influxhudpost.EnitiyDisplay(ply)
	InfluxTextCount = 0
	local offset = Vector( 0, 0, 85 )
	local ang = localplayer:EyeAngles()
	local pos = ply:GetPos() + offset + ang:Up()
 	local traceent = localplayer:GetEyeTrace().Entity

 	if ply == localplayer then return end
 	if localplayer:InVehicle() then return end
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )
 	if localplayer:GetPos():Distance( ply:GetPos() ) < 400 then
 		if localplayer:GetPos():Distance( ply:GetPos() ) < 50 then 
 			DisplayAlpha = 50
 		else
 			DisplayAlpha = 255
 		end
		cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.1 )
			if traceent == ply then
				InfluxAddText(ply, ply:Nick(), InfluxTextCount + 1, Color( 255, 255, 255, DisplayAlpha ) )
				InfluxAddText(ply, ply:getDarkRPVar( "job" ), InfluxTextCount + 1, Color( 75, 255, 75, DisplayAlpha ) )
				if ply:getDarkRPVar( "HasGunlicense" ) then
					InfluxAddText(ply, "Licensed", InfluxTextCount + 1, Color( 75, 255, 75, DisplayAlpha ) )
				end
				if ply:isWanted() then
					InfluxAddText(ply, "Wanted", InfluxTextCount + 1, Color( 255, 75, 75, DisplayAlpha ) )
				end
				if ply:GetFriendStatus() != "error_nofriendid" and ply:GetFriendStatus() != "none" then
					InfluxAddText(ply, "Steam "..ply:GetFriendStatus(), InfluxTextCount + 1, Color( 75, 75, 255, DisplayAlpha ) )
				end
				if cfg.EnableOHDRanks then
					local clr = Color( 255, 255, 255, DisplayAlpha )
					for k, v in pairs(cfg.Ranks) do
						rank = table.KeyFromValue( cfg.Ranks, v )
						if rank == ply:GetUserGroup() then
							clr = Color( v.r, v.g, v.b, clr.a )
						end
					end
					InfluxAddText(ply, InfluxUppercase(ply:GetUserGroup()), InfluxTextCount + 1, clr )
				end
				influx.RoundedBox( 5, 140, 155, 35, 50 + ( 55 * ( InfluxTextCount - 1 ) ), Color( 25, 25, 25, DisplayAlpha )  )
				influx.RoundedBox( 2, 145, 160, 25, 40 + ( 55 * ( InfluxTextCount - 1 ) ), Color( 75, 75, 75, DisplayAlpha ) )
				influx.RoundedBar( 2, 145, 160, 25, 40 + ( 55 * ( InfluxTextCount - 1 ) ), ply:Health(), 100, Color( 255, 75, 75, DisplayAlpha ), ply:SteamID())
			end
		cam.End3D2D()					
	end
end