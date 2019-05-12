function TellRoles()
	local rolesnames = {}
	local rls = {}
	local printrls = {}
	local spectators = 0
	
	if not TTT2 then
		rls[ROLE_INNOCENT] = 0
		rls[ROLE_TRAITOR] = 0
		
		rolesnames[ROLE_INNOCENT] = {}
		rolesnames[ROLE_TRAITOR] = {}
		rolesnames[ROLE_DETECTIVE] = {}
	else
		for _, v in pairs(GetRoles()) do
			rls[v.index] = 0
			printrls[v.index] = false
			
			rolesnames[v.index] = {}
		end
	end
	
	printrls[ROLE_INNOCENT] = true
	printrls[ROLE_TRAITOR] = true
	

	for _, v in ipairs(player.GetAll()) do
		if not v:Alive() or not v:IsTerror() then
			spectators = spectators + 1
		else
			local role = v:GetRole() -- in TTT2 return BaseRole

			table.insert(rolesnames[role], v:Nick())

			rls[role] = (rls[role] or 0) + 1
		end
	end

	hook.Run("TTTAModifyRolesTable", rls, printrls)

	--add non used roles to innocent
	for role, do_print in pairs(printrls) do
		if not do_print then
			rls[ROLE_INNOCENT] = rls[ROLE_INNOCENT] + (rls[role] or 0)
		end
	end
	
	rolesnamestext = {}

	for role, nicks in pairs(rolesnames) do
		if nicks and #nicks > 0 then
			rolesnamestext[role] = table.concat(nicks, ", ")
		end
	end

	if not GetConVar("ttt_rolesetup_tell_pre_roles"):GetBool() then return end

	net.Start("tttRsTellPre")
	net.WriteUInt(table.Count(rls), ROLE_BITS)

	for role, amount in pairs(rls) do
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

------------------------

function TellKillerEnhanced(victim, attacker, dmg)
	local killer = dmg:GetAttacker()

	if not GetConVar("ttt_rolesetup_killer_popup"):GetBool()
	or IsValid(killer) and killer:IsPlayer() and killer.IsGhost and killer:IsGhost()
	or IsValid(victim) and victim:IsPlayer() and victim.IsGhost and victim:IsGhost() and not victim.NOWINASC
	then return end

	-- start network transmission
	net.Start("tttRsDeathNotifyEnhanced")

	-- killed by world
	if not IsValid(killer) or not killer:IsPlayer() then
		net.WriteUInt(3, 2)
		net.Send(victim)
		return
	end
	
	-- killed by yourself
	if killer == victim then
		net.WriteUInt(2, 2)

		-- send damage type (WORKAROUND, codeduplication)
		net.WriteInt(dmg:GetDamageType(), 32)
		net.Send(victim)
		return
	end

	-- killed by killer
	net.WriteUInt(1, 2)

	-- send damage type
	local damage_type = dmg:GetDamageType()
	net.WriteInt(damage_type, 32)

	net.WriteEntity(killer)
	net.WriteUInt(killer:GetSubRole(), ROLE_BITS)

	-- no weapon was used
	if not dmg:IsDamageType(DMG_BULLET) then
		net.Send(victim)
		return 
	end

	--local wep_class = attacker:GetActiveWeapon()
	local wep_class = util.WeaponFromDamage(dmg)

	if not IsValid(wep_class) then
		net.Send(victim)
		return
	end

	local was_headshot = victim.was_headshot and dmg:IsBulletDamage()
	local wep_clip = wep_class:Clip1() -1
	local wep_ammo = wep_class:Ammo1()

	net.WriteEntity(wep_class)
	net.WriteUInt(wep_clip, 8)
	net.WriteUInt(wep_ammo, 8)
	net.WriteBool(was_headshot)

	net.Send(victim)
end
hook.Add("DoPlayerDeath", "TTTChatStatsEnhanced", TellKillerEnhanced)

---------------------------------

function TellRolesNames()
	if not GetConVar("ttt_rolesetup_tell_after_roles"):GetBool() or not rolesnamestext then return end

	for _, v in ipairs(player.GetAll()) do
		net.Start("tttRsTellPost")
		net.WriteUInt(table.Count(rolesnamestext), ROLE_BITS)

		for role, nicks in pairs(rolesnamestext) do
			net.WriteUInt(role, ROLE_BITS)
			net.WriteString(nicks)
		end

		net.Send(v)
	end
end
hook.Add("TTTEndRound", "TTTChatStats", TellRolesNames)
