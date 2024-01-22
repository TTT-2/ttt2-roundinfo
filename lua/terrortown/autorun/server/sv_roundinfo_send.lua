if SERVER then
	local flags = {FCVAR_NOTIFY, FCVAR_ARCHIVE}
	CreateConVar("ttt_roundinfo_pre_announce_distribution", 1, flags)
	CreateConVar("ttt_roundinfo_announce_killer", 1, flags)
	CreateConVar("ttt_roundinfo_popup_killer", 1, flags)
	CreateConVar("ttt_roundinfo_popup_killer_time", 10, flags)
	CreateConVar("ttt_roundinfo_post_announce_distribution", 1, flags)

	util.AddNetworkString("tttRsTellPre")
	util.AddNetworkString("tttRsTellPost")
	util.AddNetworkString("tttRsDeathNotify")
	util.AddNetworkString("tttRsDeathNotifyEnhanced")
	util.AddNetworkString("tttRsPlayerRespawn")

	-- ROUND SETUP INFORMATION
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

		if not GetConVar("ttt_roundinfo_pre_announce_distribution"):GetBool() then return end

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

	-- KILLER INFORMATION
	function TellKiller(victim, attacker, dmg)
		local killer = dmg:GetAttacker()

		if not GetConVar("ttt_roundinfo_announce_killer"):GetBool() and not GetConVar("ttt_roundinfo_popup_killer"):GetBool()
			or IsValid(killer) and killer:IsPlayer() and killer.IsGhost and killer:IsGhost()
			or IsValid(victim) and victim:IsPlayer() and victim.IsGhost and victim:IsGhost() and not victim.NOWINASC
		then return end

		-- start network transmission
		net.Start("tttRsDeathNotify")
		net.WriteUInt(GetConVar("ttt_roundinfo_popup_killer_time"):GetInt(), 16)
		net.WriteBool(GetConVar("ttt_roundinfo_announce_killer"):GetBool())
		net.WriteBool(GetConVar("ttt_roundinfo_popup_killer"):GetBool())

		-- send damage type
		local damage_type = dmg:GetDamageType()
		net.WriteUInt(damage_type or DMG_GENERIC, 32)

		-- killed by world
		if not IsValid(killer) or not killer:IsPlayer() then
			-- special case: drowning and falldamage should be "killed by yourself"
			if dmg:IsDamageType(DMG_DROWN) or dmg:IsDamageType(DMG_FALL) then
				net.WriteUInt(2, 2)

				net.Send(victim)
				return
			end

			net.WriteUInt(3, 2)
			net.Send(victim)

			return
		end

		-- killed by yourself
		if killer == victim then
			net.WriteUInt(2, 2)
		else -- killed by killer
			net.WriteUInt(1, 2)

			net.WriteEntity(killer)
			net.WriteUInt(killer:GetSubRole(), ROLE_BITS)

			-- killer role color has to be read on server since the sidekick gets a dynamic color
			local killer_role_color = killer:GetRoleColor()
			net.WriteUInt(killer_role_color.r, 8)
			net.WriteUInt(killer_role_color.g, 8)
			net.WriteUInt(killer_role_color.b, 8)
			net.WriteUInt(killer_role_color.a, 8)

			-- send armor of killer
			net.WriteUInt(killer:GetArmor() or 0, 16)
			net.WriteUInt(killer:GetMaxArmor() or 0, 16)
		end

		--local wep_class = attacker:GetActiveWeapon()
		local wep_class = util.WeaponFromDamage(dmg)

		if not IsValid(wep_class) or not wep_class then
			net.WriteBool(false)
			net.Send(victim)
			return
		end

		local was_headshot, wep_clip, wep_clip_max, wep_ammo, wep_ammo_type

		if wep_class["Clip1"] == nil or wep_class["GetMaxClip1"] == nil or wep_class["Ammo1"] == nil then -- weapon without any clip like a thrown knife
			was_headshot = false
			wep_clip = -1
			wep_clip_max = -1
			wep_ammo_type = -1
		else -- default case
			was_headshot = victim.was_headshot and dmg:IsBulletDamage()
			wep_clip = wep_class:Clip1()
			wep_clip_max = wep_class:GetMaxClip1()
			wep_ammo = wep_class:Ammo1()
			wep_ammo_type = wep_class:GetPrimaryAmmoType()

			-- check if values are numbers (e.g. snowball has a boolean for ammo)
			if type(wep_clip) ~= "number" then wep_clip = -1 end
			if type(wep_clip_max) ~= "number" then wep_clip_max = -1 end
			if type(wep_ammo) ~= "number" then wep_ammo = -1 end
			if type(wep_ammo_type) ~= "number" then wep_ammo_type = -1 end

			-- make sure all values are integers
			wep_clip = math.floor(wep_clip -1)
			wep_clip_max = math.floor(wep_clip_max)
			wep_ammo = math.floor(wep_ammo)
			wep_ammo_type = math.floor(wep_ammo_type)
		end

		net.WriteBool(true)
		net.WriteString(wep_class:GetClass() or "undefined")
		net.WriteInt(wep_clip or 0, 16)
		net.WriteInt(wep_clip_max or 0, 16)
		net.WriteInt(wep_ammo or 0, 16)
		net.WriteInt(wep_ammo_type or 0, 16)
		net.WriteBool(was_headshot or false)

		net.Send(victim)
	end
	hook.Add("DoPlayerDeath", "TTTChatStats", TellKiller)

	-- ROUNDEND INFOTMATION
	function TellRolesNames()
		if not GetConVar("ttt_roundinfo_post_announce_distribution"):GetBool() or not rolesnamestext then return end

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

	-- SEND PLAYER SPAWN TO CLIENT TO CLOSE POPUP
	hook.Add("PlayerSpawn", "hide_popup_player_spawn", function(ply)
		net.Start("tttRsPlayerRespawn")
		net.Send(ply)
	end)
end
