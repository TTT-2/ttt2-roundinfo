if SERVER then
	AddCSLuaFile()
    
    util.AddNetworkString("tttRsTellPre")
    util.AddNetworkString("tttRsTellPost")
else
    hook.Add("Initialize", "TTTInitRS", function()
        LANG.AddToLanguage("English", "ttt_rs_preText", "There are {traits} traitors, {innos} innocents and {specs} spectators this round.")
        LANG.AddToLanguage("English", "ttt_rs_postText", "The role distribution this round:")
        
        LANG.AddToLanguage("Deutsch", "ttt_rs_preText", "Es gibt {traits} Verräter, {innos} Unschuldige und {specs} Zuschauer diese Runde.")
        LANG.AddToLanguage("Deutsch", "ttt_rs_postText", "Die Rollenverteilung diese Runde:")
    end)
    
	net.Receive("tttRsTellPre", function(len)
        local PT = LANG.GetParamTranslation
		local roles = net.ReadTable()
        local spectators = net.ReadUInt(9)

        local txt = PT("ttt_rs_preText", {traits = roles[ROLE_TRAITOR], innos = roles[ROLE_INNOCENT], specs = spectators})
        
		chat.AddText(Color(255, 255, 0), txt)
	end)

	net.Receive("tttRsTellPost", function(len)
        local T = LANG.GetTranslation
    
		local rolesnames = net.ReadTable()

        local txt = T("ttt_rs_postText")
        
		chat.AddText(Color(255, 255, 0), txt)
        
        for k, v in pairs(rolesnames) do
            if v then
                if not ROLES then
                    if k == ROLE_INNOCENT then
                        txt = (T("innocent") .. ": " .. v)
                    elseif k == ROLE_TRAITOR then
                        txt = (T("traitor") .. ": " .. v)
                    elseif K == ROLE_DETECTIVE then
                        txt = (T("detective") .. ": " .. v)
                    end
                else
                    local rd = GetRoleByIndex(k)
                    
                    txt = (T(rd.name) .. ": " .. v)
                end
            end
        
            chat.AddText(Color(255, 255, 0), txt)
        end
	end)
end
