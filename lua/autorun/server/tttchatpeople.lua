function TellRoles()

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

	for role, nicks in pairs(rolesnames) do
		if nicks and #nicks > 0 then
			rolesnamestext[role] = table.concat(nicks, ", ")
		end
	end

	if not GetConVar("ttt_rolesetup_tell_pre_roles"):GetBool() then return end

	local roles_size = 0

	for _ in pairs(roles) do
		roles_size = roles_size + 1
	end

	net.Start("tttRsTellPre")
	net.WriteUInt(roles_size, ROLE_BITS)

	for role, amount in pairs(roles) do
		net.WriteUInt(role, ROLE_BITS)
		net.WriteUInt(amount, 32)
	end

	net.WriteUInt(spectators, 9)
	net.Broadcast()
end
hook.Add("TTTBeginRound", "TTTChatStats", TellRoles)

function TellKiller(victim, weapon, killer)
	if not GetConVar("ttt_rolesetup_tell_killer"):GetBool()
	or IsValid(killer) and killer:IsPlayer() and killer.IsGhost and killer:IsGhost()
	or IsValid(victim) and victim:IsPlayer() and victim.IsGhost and victim:IsGhost() and not victim.NOWINASC
	then return end

	net.Start("tttRsDeathNotify")

	if IsValid(killer) and killer:IsPlayer() then
		if killer ~= victim then
			net.WriteUInt(1, 4)

			if TTT2 then
				net.WriteUInt(killer:GetSubRole(), ROLE_BITS)
			else
				net.WriteUInt(killer:GetRole(), 2)
			end

			net.WriteEntity(killer)
		else
			net.WriteUInt(2, 4)
		end
	else
		net.WriteUInt(3, 4)
	end

	net.Send(victim)
end
hook.Add("PlayerDeath", "TTTChatStats", TellKiller)

function TellRolesNames()
	if not GetConVar("ttt_rolesetup_tell_after_roles"):GetBool() or not rolesnamestext then return end

	for _, v in ipairs(player.GetAll()) do
		local amount = 0

		for _ in pairs(rolesnamestext) do
			amount = amount + 1
		end

		net.Start("tttRsTellPost")
		net.WriteUInt(amount, ROLE_BITS)

		for role, nicks in pairs(rolesnamestext) do
			net.WriteUInt(role, ROLE_BITS)
			net.WriteString(nicks)
		end

		net.Send(v)
	end
end
hook.Add("TTTEndRound", "TTTChatStats", TellRolesNames)
