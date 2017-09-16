-- influx Hud 
local timer_delay = CurTime() + 5

function influxhud.Agenda()
    local agenda = localplayer:getAgendaTable()
    if not agenda then return end
    agendatext = agendatext or DarkRP.textWrap((localplayer:getDarkRPVar("agenda") or ""):gsub("//", "\n"):gsub("\\n", "\n"), "Trebuchet24", 440)

    if agendatext == "" then return end
    influx.RoundedBox( 5, 5, 5, 450, 23, Color( 25, 25, 25, 220 ) )
    influx.Text( "Agenda", "Trebuchet24", 10, 5, Color( 255, 255, 255, 255 ) )
	influx.RoundedBox( 5, 5, 30, 450, 125, Color( 25, 25, 25, 220 ) )
	draw.DrawText( agendatext, "Trebuchet24", 10, 35, Color( 255, 255, 255, 255 ) )
end

hook.Add( "Think", "Influx_Agenda_Update_Delay", function()
    if CurTime() < timer_delay then return end
    hook.Add("DarkRPVarChanged", "agendaHUD", function(ply, var, _, new)
        if ply ~= LocalPlayer() then return end
        if var == "agenda" and new then
            agendatext = DarkRP.textWrap(new:gsub("//", "\n"):gsub("\\n", "\n"), "Trebuchet24", 440)
        else
            agendatext = nil
        end
    end )
end )