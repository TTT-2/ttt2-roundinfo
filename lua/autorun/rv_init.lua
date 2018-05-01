if SERVER then
	AddCSLuaFile()
    
    util.AddNetworkString("tttRsTellPre")
    util.AddNetworkString("tttRsTellPost")
    util.AddNetworkString("tttRsDeathNotify")
else
    hook.Add("Initialize", "TTTInitRS", function()
        LANG.AddToLanguage("English", "ttt_rs_preText", "There are {traits} traitors, {innos} innocents and {specs} spectators this round.")
        LANG.AddToLanguage("English", "ttt_rs_postText", "The role distribution this round:")
        LANG.AddToLanguage("English", "ttt_rs_killText", "{col1}You were killed by {col2}{killer}{col1}. Role: {col2}{role}{col1}.")
        LANG.AddToLanguage("English", "ttt_rs_suicideText", "You were killed by someone called yourself...")
        LANG.AddToLanguage("English", "ttt_rs_worldKillText", "You were killed by the world.")
        
        LANG.AddToLanguage("Deutsch", "ttt_rs_preText", "Es gibt {traits} Verräter, {innos} Unschuldige und {specs} Zuschauer diese Runde.")
        LANG.AddToLanguage("Deutsch", "ttt_rs_postText", "Die Rollenverteilung diese Runde:")
        LANG.AddToLanguage("Deutsch", "ttt_rs_killText", "{col1}Du wurdest von {col2}{killer} {col1}getötet. Rolle: {col2}{role}{col1}.")
        LANG.AddToLanguage("English", "ttt_rs_suicideText", "Du hast dich selbst getötet!")
        LANG.AddToLanguage("English", "ttt_rs_worldKillText", "Du wurdest von der Welt getötet.")
    end)
    
	net.Receive("tttRsTellPre", function(len)
        local PT = LANG.GetParamTranslation
		local roles = net.ReadTable()
        local spectators = net.ReadUInt(9)

        local txt = PT("ttt_rs_preText", {traits = roles[ROLE_TRAITOR], innos = roles[ROLE_INNOCENT], specs = spectators})
        
		chat.AddText(Color(255, 255, 0), txt)
	end)
    
    net.Receive("tttRsDeathNotify", function(len)
        local T = LANG.GetTranslation
        local PT = LANG.GetParamTranslation
        
        local roleColors = {}
    
        if not ROLES then
            roleColors = {
				[ROLE_TRAITOR] = Color(200, 25, 25),
				[ROLE_DETECTIVE] = Color(25, 25, 200),
				[ROLE_INNOCENT] = Color(25, 200, 25),
				[ROLE_NONE] = Color(100, 100, 100)
			}
        else
            roleColors[ROLE_NONE] = Color(100, 100, 100)
        
            for _, v in pairs(ROLES) do
                roleColors[v.index] = v.color
            end
        end
        
        local default = Color(205, 155, 0, 255)
        local killerType = net.ReadInt(4)

        if killerType == 1 then
            local role = net.ReadUInt(ROLE_BITS) + 1
            local killer = net.ReadEntity()
            
            local color = roleColors[role] or roleColors[ROLE_NONE]
            
            local rolename = "unknown"
            
            if not ROLES then
                if role == ROLE_INNOCENT then
                    rolename = T("innocent")
                elseif role == ROLE_TRAITOR then
                    rolename = T("traitor")
                elseif role == ROLE_DETECTIVE then
                    rolename = T("detective")
                end
            else
                rolename = T(GetRoleByIndex(role).name)
            end
            
            local txt = PT("ttt_rs_killText", {
                col1 = default, 
                col2 = color,
                killer = killer:Nick(),
                role = rolename
            })
            
            chat.AddText(default, txt)
        elseif killerType == 2 then
            chat.AddText(default, T("ttt_rs_suicideText"))
        elseif killerType == 3 then
            chat.AddText(default, T("ttt_rs_worldKillText"))
        end
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
