-- influx Hud 

if !InfluxAPIFailed then
	local ScreenPos = ScrH() - 200

	local Colors = {}
	Colors[ NOTIFY_GENERIC ] = Color( 52, 73, 94, 255 )
	Colors[ NOTIFY_ERROR ] = Color( 192, 57, 43, 255 )
	Colors[ NOTIFY_UNDO ] = Color( 41, 128, 185, 255 )
	Colors[ NOTIFY_HINT ] = Color( 39, 174, 96, 255 )
	Colors[ NOTIFY_CLEANUP ] = Color( 243, 156, 18, 255 )

	local LoadingColor = Color( 22, 160, 133, 255 )

	local Notifications = {}

	function Influx_DrawNotification( x, y, w, h, text, col, progress )
		influx.RoundedBox( 5, x + h, y, w - h, h, Color( 25, 25, 25, 255) )
		influx.RoundedBox( 2, x + h, y, 5, h, col )

		influx.Text( text, "Trebuchet24", x + 32 + 10, y + h / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

	end

	function notification.AddLegacy( text, type, time )
		surface.SetFont( "Trebuchet24" )

		local w = surface.GetTextSize( text ) + 20 + 32
		local h = 32
		local x = ScrW()
		local y = ScreenPos

		table.insert( Notifications, 1, {
			x = x,
			y = y,
			w = w,
			h = h,

			text = text,
			col = Colors[ type ],
			time = CurTime() + time,

			progress = false,
		} )
	end

	function notification.AddProgress( id, text )
		surface.SetFont( "Trebuchet24" )

		local w = surface.GetTextSize( text ) + 20 + 32
		local h = 32
		local x = ScrW()
		local y = ScreenPos

		table.insert( Notifications, 1, {
			x = x,
			y = y,
			w = w,
			h = h,

			id = id,
			text = text,
			col = LoadingColor,
			time = math.huge,

			progress = true,
		} )	
	end

	function notification.Kill( id )
		for k, v in ipairs( Notifications ) do
			if v.id == id then v.time = 0 end
		end
	end

	hook.Add( "HUDPaint", "Influx_DrawNotifications", function()
		for k, v in ipairs( Notifications ) do
			Influx_DrawNotification( math.floor( v.x ), math.floor( v.y ), v.w, v.h, v.text, v.col, v.progress )

			v.x = Lerp( FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - v.w - 10 or ScrW() + 1 )
			v.y = Lerp( FrameTime() * 10, v.y, ScreenPos - ( k - 1 ) * ( v.h + 5 ) )
		end

		for k, v in ipairs( Notifications ) do
			if v.x >= ScrW() and v.time < CurTime() then
				table.remove( Notifications, k )
			end
		end
	end )
end