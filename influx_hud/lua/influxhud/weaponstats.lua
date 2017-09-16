-- influx Hud 
influxhudconfig = influxhudconfig or {}
local cfg = influxhudconfig

function influxhud.WeaponStats()
	if cfg.UseWeaponsHud then
		if localplayer:Alive() == true then
			if localplayer:GetActiveWeapon() != NULL then   
				if localplayer:GetActiveWeapon():Clip1() != -1 and localplayer:GetActiveWeapon():IsValid() then
					influx.RoundedBoxEx( 5, ScrW() - 32, ScrH() - 136, 29, 133, cfg.GetColor(), false, true, true, true )
					influx.RoundedBox( 5, ScrW() - 30, ScrH() - 134, 25, 129, Color( 25, 25, 25, 255 ) )
					influx.RoundedBox( 2, ScrW() - 30 + 4, ScrH() - 130, 17, 121, Color( 75, 75, 75, 255 ) )
					if localplayer:GetActiveWeapon():Clip1() != 0 then
						influx.RoundedBar( 2, ScrW() - 30 + 4, ScrH() - 130, 17, 121, localplayer:GetActiveWeapon():Clip1(), localplayer:GetActiveWeapon():GetMaxClip1(), Color( 255, 155, 75, 255 ), "Ammo")
					end

					local RoundsLeft =  math.ceil( localplayer:GetActiveWeapon():Clip1() )
					surface.SetFont( "Trebuchet24" )
					local RoundsW, RoundsH = surface.GetTextSize( "Rounds (" .. RoundsLeft .. ")" )
					influx.RoundedBoxEx( 5, ScrW() - ( 47 + RoundsW ), ScrH() - 136, 15 + RoundsW, 29, cfg.GetColor(), true, false, true, false )
					influx.RoundedBox( 5, ScrW() - ( 45 + RoundsW ), ScrH() - 134, 10 + RoundsW, 25, Color( 25, 25, 25, 255 ) )
					influx.Text( "Rounds (" .. RoundsLeft .. ")", "Trebuchet24", ScrW() - 40, ScrH() - 135, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )

					local ClipsLeft =  math.ceil( localplayer:GetAmmoCount( localplayer:GetActiveWeapon():GetPrimaryAmmoType() ) / localplayer:GetActiveWeapon():GetMaxClip1() )
					surface.SetFont( "Trebuchet24" )		
					local ClipsW, ClipsH = surface.GetTextSize( "Clips (" .. ClipsLeft .. ")" )
					influx.RoundedBoxEx( 5, ScrW() - ( 47 + ClipsW ), ScrH() - 108, 15 + ClipsW, 29, cfg.GetColor(), true, false, true, false )
					influx.RoundedBox( 5, ScrW() - ( 45 + ClipsW ), ScrH() - 106, 10 + ClipsW, 25, Color( 25, 25, 25, 255 ) )
					influx.Text( "Clips (" .. ClipsLeft .. ")", "Trebuchet24", ScrW() - 40, ScrH() - 107, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
				end
			end
		end
	end
end