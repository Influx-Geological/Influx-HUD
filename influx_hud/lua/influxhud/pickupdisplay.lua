-- influx Hud 

if !InfluxAPIFailed then
	timer.Simple( 5, function()
		local BackgroundColor = Color( 25, 25, 25, 255 )

		GAMEMODE.PickupHistory = {}
		GAMEMODE.PickupHistoryLast = 0
		GAMEMODE.PickupHistoryTop = ScrH() / 2
		GAMEMODE.PickupHistoryWide = 300
		GAMEMODE.PickupHistoryCorner = surface.GetTextureID( "gui/corner8" )

		function GAMEMODE:HUDWeaponPickedUp( wep )

			if ( !IsValid( localplayer ) || !localplayer:Alive() ) then return end
			if ( !IsValid( wep ) ) then return end
			if ( !isfunction( wep.GetPrintName ) ) then return end
				
			local pickup = {}
			pickup.time			= CurTime()
			pickup.name			= wep:GetPrintName()
			pickup.holdtime		= 5
			pickup.font			= "DermaDefaultBold"
			pickup.fadein		= 0.04
			pickup.fadeout		= 0.3
			pickup.color		= Color( 255, 200, 50, 255 )
			
			surface.SetFont( pickup.font )
			local w, h = surface.GetTextSize( pickup.name )
			pickup.height		= h
			pickup.width		= w

			if ( self.PickupHistoryLast >= pickup.time ) then
				pickup.time = self.PickupHistoryLast + 0.05
			end
			
			table.insert( self.PickupHistory, pickup )
			self.PickupHistoryLast = pickup.time

		end

		--[[---------------------------------------------------------
		   Name: gamemode:HUDItemPickedUp( itemname )
		   Desc: An item has been picked up..
		-----------------------------------------------------------]]
		function GAMEMODE:HUDItemPickedUp( itemname )

			if ( !IsValid( localplayer ) || !localplayer:Alive() ) then return end
			
			local pickup = {}
			pickup.time			= CurTime()
			pickup.name			= "#"..itemname
			pickup.holdtime		= 5
			pickup.font			= "DermaDefaultBold"
			pickup.fadein		= 0.04
			pickup.fadeout		= 0.3
			pickup.color		= Color( 180, 255, 180, 255 )
			
			surface.SetFont( pickup.font )
			local w, h = surface.GetTextSize( pickup.name )
			pickup.height		= h
			pickup.width		= w

			if ( self.PickupHistoryLast >= pickup.time ) then
				pickup.time = self.PickupHistoryLast + 0.05
			end
			
			table.insert( self.PickupHistory, pickup )
			self.PickupHistoryLast = pickup.time

		end

		--[[---------------------------------------------------------
		   Name: gamemode:HUDAmmoPickedUp( itemname, amount )
		   Desc: Ammo has been picked up..
		-----------------------------------------------------------]]
		function GAMEMODE:HUDAmmoPickedUp( itemname, amount )

			if ( !IsValid( localplayer ) || !localplayer:Alive() ) then return end
			
			-- Try to tack it onto an exisiting ammo pickup
			if ( self.PickupHistory ) then
			
				for k, v in pairs( self.PickupHistory ) do
			
					if ( v.name == "#" .. itemname .. "_ammo" ) then
					
						v.amount = tostring( tonumber( v.amount ) + amount )
						v.time = CurTime() - v.fadein
						return
						
					end
			
				end
			
			end
			
				
			local pickup = {}
			pickup.time			= CurTime()
			pickup.name			= "#" .. itemname .. "_ammo"
			pickup.holdtime		= 5
			pickup.font			= "DermaDefaultBold"
			pickup.fadein		= 0.04
			pickup.fadeout		= 0.3
			pickup.color		= Color( 180, 200, 255, 255 )
			pickup.amount		= tostring( amount )
			
			surface.SetFont( pickup.font )
			local w, h = surface.GetTextSize( pickup.name )
			pickup.height	= h
			pickup.width	= w
			
			local w, h = surface.GetTextSize( pickup.amount )
			pickup.xwidth	= w
			pickup.width	= pickup.width + w + 16

			if ( self.PickupHistoryLast >= pickup.time ) then
				pickup.time = self.PickupHistoryLast + 0.05
			end
			
			table.insert( self.PickupHistory, pickup )
			self.PickupHistoryLast = pickup.time

		end


		function GAMEMODE:HUDDrawPickupHistory()

			if ( self.PickupHistory == nil ) then return end
			
			local x, y = ScrW() - self.PickupHistoryWide - 20, self.PickupHistoryTop
			local tall = 0
			local wide = 0

			for k, v in pairs( self.PickupHistory ) do
			
				if ( !istable( v ) ) then
				
					Msg( tostring( v ) .."\n" )
					PrintTable( self.PickupHistory )
					self.PickupHistory[ k ] = nil
					return
				end
			
				if ( v.time < CurTime() ) then
				
					if ( v.y == nil ) then v.y = y end
					
					v.y = ( v.y * 5 + y ) / 6
					
					local delta = ( v.time + v.holdtime ) - CurTime()
					delta = delta / v.holdtime
					
					local alpha = 255
					local colordelta = math.Clamp( delta, 0.6, 0.7 )
					
					-- Fade in/out
					if ( delta > 1 - v.fadein ) then
						alpha = math.Clamp( ( 1.0 - delta ) * ( 255 / v.fadein ), 0, 255 )
					elseif ( delta < v.fadeout ) then
						alpha = math.Clamp( delta * ( 255 / v.fadeout ), 0, 255 )
					end
					
					v.x = x + self.PickupHistoryWide - (self.PickupHistoryWide * ( alpha / 255 ) )

					local rx, ry, rw, rh = math.Round( v.x - 4 ), math.Round( v.y - ( v.height / 2 ) - 4 ), math.Round( self.PickupHistoryWide + 9 ), math.Round( v.height + 8 )
					local bordersize = 8

					
					influx.RoundedBox( 5, rx + bordersize + v.height - 4, ry, rw - ( v.height - 12 ) - bordersize * 2, v.height + 8, Color( BackgroundColor.r * colordelta, BackgroundColor.g * colordelta, BackgroundColor.b * colordelta, alpha ) )
					influx.RoundedBox( 5, (rx + bordersize + v.height - 4) - 5, ry, 5, v.height + 8, Color( v.color.r, v.color.g, v.color.b, alpha/2 ) )

					influx.Text( v.name, v.font, v.x + v.height + 9, v.y - ( v.height / 2 ) + 1, Color( 0, 0, 0, alpha * 0.5 ) )
			
					influx.Text( v.name, v.font, v.x + v.height + 8, v.y - ( v.height / 2 ), Color( 255, 255, 255, alpha ) )
					
					if ( v.amount ) then

						influx.Text( v.amount, v.font, v.x + self.PickupHistoryWide + 1, v.y - ( v.height / 2 ) + 1, Color( 0, 0, 0, alpha * 0.5 ), TEXT_ALIGN_RIGHT )
						influx.Text( v.amount, v.font, v.x + self.PickupHistoryWide, v.y - ( v.height / 2 ), Color( 255, 255, 255, alpha ), TEXT_ALIGN_RIGHT )
					
					end
					
					y = y + ( v.height + 16 )
					tall = tall + v.height + 18
					wide = math.Max( wide, v.width + v.height + 24 )
					
					if ( alpha == 0 ) then self.PickupHistory[ k ] = nil end
				
				end
			
			end
			
			self.PickupHistoryTop = ( self.PickupHistoryTop * 5 + ( ScrH() * 0.75 - tall ) / 2 ) / 6
			self.PickupHistoryWide = ( self.PickupHistoryWide * 5 + wide ) / 6

		end
	end )
end