-- influx Hud
influxhudconfig = influxhudconfig or {}
local cfg = influxhudconfig

local Subnum = 0
local Addnum = 0
local ActiveBars = 0
local AddIconnum = 0

function InfluxAddBar( func, number, color, id, icon )
	Addnum = number
	local number = number - 1
	influx.RoundedBox( 5, 5 + (30 * number ), ScrH() - 134, 25, 106, Color( 25, 25, 25, 255 ) )
	influx.RoundedBox( 2, 5 + (30 * number ) + 4, ScrH() - 130 + 25, 17, 98 - 25, Color( 75, 75, 75, 255 ) )
	influx.RoundedBar( 2, 5 + (30 * number ) + 4, ScrH() - 130 + 25, 17, 98 - 25, func, 100, Color( color.r, color.g, color.b, color.a ), id)
	influx.Icon( 5 + (30 * number ), ScrH() - 134, 25, 25, Material( icon ), Color( 255, 255, 255, 255 ) )
	influx.RoundedBox( 5, 5 + (30 * number ), ScrH() - 25, 25, 20, Color( 25, 25, 25, 255 ) )
	influx.RoundedBox( 5, 5 + (30 * number ) + 2, ScrH() - 23, 21, 16, Color( 75, 75, 75, 255 ) )
	influx.Text( func, "Trebuchet18", 17 + (30 * number ), ScrH() - 23, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
end

function InfluxAddIcon( icon, number, color )
	AddIconnum = number
	local number = number - 1
	influx.Circle( 25 + (45 * number ), ScrH() - (160), 21, Color( 25, 25, 25, 255 ))
	influx.Circle( 25 + (45 * number ), ScrH() - (160), 18, Color( 75, 75, 75, 255 ))
	influx.Icon( 13 + (45 * number ), ScrH() - 173, 25, 25, Material( icon ), Color( color.r, color.g, color.b, color.a ) )

end

function influxhud.PlayerStats()
	Addnum = 0
	AddIconnum = 0
	influx.RoundedBox( 5, 3, ScrH() - 136, 245 + (30 * (ActiveBars) ) + 4, 134, cfg.GetColor() )
	if localplayer:Health() > 0 then
		InfluxAddBar( localplayer:Health(), Addnum + 1, Color( 255, 75, 75, 255 ), "Health", "materials/influxicons/25/health.png" )
		if localplayer:Armor() > 0 then
			InfluxAddBar( localplayer:Armor(), Addnum + 1, Color( 75, 75, 255, 255 ), "Armor", "materials/influxicons/25/armor.png" )
		end
		if localplayer:getDarkRPVar("Energy") != nil then
			if localplayer:getDarkRPVar("Energy") > 0 then
				InfluxAddBar( localplayer:getDarkRPVar("Energy"), Addnum + 1, Color( 255, 255, 75, 255 ), "Energy", "materials/influxicons/25/food.png" )
			end
		end
	end
	ActiveBars = Addnum

	-- Player Info
		influx.RoundedBox( 5, 5 + (30 * (ActiveBars) ), ScrH() - 104, 245, 98, Color( 25, 25, 25, 255 ) )
		influx.RoundedBox( 5, 5 + (30 * (ActiveBars) ), ScrH() - 134, 245, 28, Color( 25, 25, 25, 255 ) )

		surface.SetFont( "Trebuchet24" )
		local TextW, TextH = surface.GetTextSize( localplayer:Nick() ) -- (5 + (30 * (ActiveBars) ) + 40 )
		if (5 + ((30 * (ActiveBars) ) + 40) + TextW ) > 245 then
			LocalName = string.sub(localplayer:Nick(), 1, string.len(localplayer:Nick()) - (((5 + ((30 * (ActiveBars) ) + 40) + TextW ) - 245) / 5) )
			LocalName = LocalName.."..."
		else
			LocalName = localplayer:Nick()
		end

		influx.Icon( 7 + (30 * (ActiveBars) + 2 ), ScrH() - 135, 28, 28, Material( "materials/influxicons/28/user.png" ), Color( 255, 255, 255, 255 ) )
		influx.Text( LocalName, "Trebuchet24", (5 + (30 * (ActiveBars) ) + 40 ), ScrH() - 132, Color( 255, 255, 255, 255 ) )

		influx.Icon( 5 + (30 * (ActiveBars) + 2 ), ScrH() - 102, 32, 32, Material( "materials/influxicons/32/wallet.png" ), Color( 255, 255, 255, 255 ) )
		influx.Text( DarkRP.formatMoney(localplayer:getDarkRPVar( "money" )), "Trebuchet24", (5 + (30 * (ActiveBars) ) + 40 ), ScrH() - 98, Color( 255, 255, 255, 255 ) )

		influx.Icon( 5 + (30 * (ActiveBars) + 2 ), ScrH() - 70, 32, 32, Material( "materials/influxicons/32/job.png" ), Color( 255, 255, 255, 255 ) )
		influx.Text( localplayer:getDarkRPVar( "job" ), "Trebuchet24", (5 + (30 * (ActiveBars) ) + 40 ), ScrH() - 66, Color( 255, 255, 255, 255 ) )

		influx.Icon( 5 + (30 * (ActiveBars) + 2 ), ScrH() - 38, 32, 32, Material( "materials/influxicons/32/salary.png" ), Color( 255, 255, 255, 255 ) )
		influx.Text( DarkRP.formatMoney(localplayer:getDarkRPVar( "salary" )), "Trebuchet24", (5 + (30 * (ActiveBars) ) + 40 ), ScrH() - 34, Color( 255, 255, 255, 255 ) )
	-- Player Info End

	if localplayer:getDarkRPVar( "HasGunlicense" ) then
		InfluxAddIcon( "materials/influxicons/25/license.png", AddIconnum + 1, Color( 255, 255, 255, 255 ) )
	end
	if localplayer:isWanted() then
		InfluxAddIcon( "materials/influxicons/25/Wanted.png", AddIconnum + 1, Color( 255, 255, 255, 255 ) )
	end
end