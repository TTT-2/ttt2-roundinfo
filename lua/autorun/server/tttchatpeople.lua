function TellRoles()
	if not GetConVar("ttt_rolesetup_tell_pre_roles"):GetBool() then return end
	local rolesnames = {}
	local roles = {}
	local spectators = 0

	if not TTT2 then
		roles[ROLE_INNOCENT] = 0
		roles[ROLE_TRAITOR] = 0
		roles[ROLE_DETECTIVE] = 0 -- not needed

		rolesnames[ROLE_INNOCENT] = {}
		rolesnames[ROLE_TRAITOR] = {}
		rolesnames[ROLE_DETECTIVE] = {}
	else
		for _, v in pairs(GetRoles()) do
			roles[v.index] = 0

			rolesnames[v.index] = {}
		end
	end

	for _, v in ipairs(player.GetAll()) do
		if not v:Alive() or not v:IsTerror() then
			spectators = spectators + 1
		else
			local role = v:GetRole() -- in TTT2 return BaseRole

			table.insert(rolesnames[role], v:Nick())

			role = role == ROLE_DETECTIVE and ROLE_INNOCENT or role

			roles[role] = (roles[role] or 0) + 1
		end
	end

	hook.Run("TTTAModifyRolesTable", roles)

	rolesnamestext = {}

	for k, v in pairs(rolesnames) do
		if v and #v > 0 then
			rolesnamestext[k] = table.concat(v, ", ")
		end
	end

	for _, v in ipairs(player.GetAll()) do
		net.Start("tttRsTellPre")
		net.WriteTable(roles)
		net.WriteUInt(spectators, 9)
		net.Send(v)
	end
end
hook.Add("TTTBeginRound", "TTTChatStats", TellRoles)

function TellKiller(victim, weapon, killer)
	if not GetConVar("ttt_rolesetup_tell_killer"):GetBool() or (killer.IsGhost and killer:IsGhost()) or (victim.IsGhost and killer:IsGhost()) then return end

	net.Start("tttRsDeathNotify")

	if killer:IsPlayer() and killer ~= victim then
		net.WriteUInt(1, 4)

		if TTT2 then
			net.WriteUInt(killer:GetSubRole(), ROLE_BITS)
		else
			net.WriteUInt(killer:GetRole(), 2)
		end

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
	if not GetConVar("ttt_rolesetup_tell_after_roles"):GetBool() then return end
	for _, v in pairs(player.GetAll()) do
		net.Start("tttRsTellPost")
		net.WriteTable(rolesnamestext)
		net.Send(v)
	end
end
hook.Add("TTTEndRound", "TTTChatStats", TellRolesNames)
