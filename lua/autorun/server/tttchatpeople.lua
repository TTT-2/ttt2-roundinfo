function TellRoles()
    local rolesnames = {}
    local roles = {}
    local spectators = 0
    
    if not ROLES then
		roles[ROLE_INNOCENT] = 0
		roles[ROLE_TRAITOR] = 0
		roles[ROLE_DETECTIVE] = 0 -- not needed
	
        rolesnames[ROLE_INNOCENT] = {}
        rolesnames[ROLE_TRAITOR] = {}
        rolesnames[ROLE_DETECTIVE] = {}
    else
        for _, v in pairs(ROLES) do
			roles[v.index] = 0
		
            rolesnames[v.index] = {}
        end
    end

    for _, v in pairs(player.GetAll()) do
        if not (v:Alive() and v:IsTerror()) then
            spectators = spectators + 1
        else
            local role = v:GetRole()
            
            table.insert(rolesnames[role], v:Nick())
            
            if not ROLES then
                role = role == ROLE_DETECTIVE and ROLE_INNOCENT or role
            
                roles[role] = (roles[role] or 0) + 1
            else
                local rd = GetRoleByIndex(role)
                
                if rd.team == TEAM_TRAITOR then
                    roles[ROLE_TRAITOR] = roles[ROLE_TRAITOR] + 1
                elseif rd.team == TEAM_INNO then
                    roles[ROLE_INNOCENT] = roles[ROLE_INNOCENT] + 1
				else
					roles[role] = (roles[role] or 0) + 1
                end
            end
        end
    end
	
	hook.Run("TTTAModifyRolesTable", roles)
    
    rolesnamestext = {}
    
    for k, v in pairs(rolesnames) do
        if v and #v > 0 then
            rolesnamestext[k] = table.concat(v, ", ")
        end
    end

    for _, v in pairs(player.GetAll()) do
        net.Start("tttRsTellPre")
        net.WriteTable(roles)
        net.WriteUInt(spectators, 9)
        net.Send(v)
    end
end
hook.Add("TTTBeginRound", "TTTChatStats", TellRoles)

function TellKiller(victim, weapon, killer)
    net.Start("tttRsDeathNotify")
    
    if killer:IsPlayer() and killer ~= victim then
        net.WriteUInt(1, 4)
        net.WriteUInt(killer:GetRole() - 1, ROLE_BITS)
        net.WriteEntity(killer)
    elseif killer:IsPlayer() and killer == victim then
        net.WriteUInt(2, 4)
    else
        net.WriteUInt(3, 4)
    end
    
    net.Send(victim)
end
hook.Add("PlayerDeath", "TTTChatStats", TellKiller)

function TellRolesNames()
    for _, v in pairs(player.GetAll()) do
        net.Start("tttRsTellPost")
        net.WriteTable(rolesnamestext)
        net.Send(v)
    end
end
hook.Add("TTTEndRound", "TTTChatStats", TellRolesNames)
