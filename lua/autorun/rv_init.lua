CreateConVar('ttt_rolesetup_tell_pre_roles', 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar('ttt_rolesetup_tell_killer', 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar('ttt_rolesetup_killer_popup', 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar('ttt_rolesetup_killer_popup_time', 10, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar('ttt_rolesetup_tell_after_roles', 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})

hook.Add('TTTUlxInitCustomCVar', 'TTTRolesetupInitRWCVar', function(name)
	ULib.replicatedWritableCvar('ttt_rolesetup_tell_pre_roles', 'rep_ttt_rolesetup_tell_pre_roles', GetConVar('ttt_rolesetup_tell_pre_roles'):GetInt(), true, false, name)
	ULib.replicatedWritableCvar('ttt_rolesetup_tell_killer', 'rep_ttt_rolesetup_tell_killer', GetConVar('ttt_rolesetup_tell_killer'):GetInt(), true, false, name)
	ULib.replicatedWritableCvar('ttt_rolesetup_killer_popup', 'rep_ttt_rolesetup_killer_popup', GetConVar('ttt_rolesetup_killer_popup'):GetInt(), true, false, name)
	ULib.replicatedWritableCvar('ttt_rolesetup_killer_popup_time', 'rep_ttt_rolesetup_killer_popup_time', GetConVar('ttt_rolesetup_killer_popup_time'):GetInt(), true, false, name)
	ULib.replicatedWritableCvar('ttt_rolesetup_tell_after_roles', 'rep_ttt_rolesetup_tell_after_roles', GetConVar('ttt_rolesetup_tell_after_roles'):GetInt(), true, false, name)
end)

if SERVER then
	AddCSLuaFile()

	util.AddNetworkString('tttRsTellPre')
	util.AddNetworkString('tttRsTellPost')
	util.AddNetworkString('tttRsDeathNotify')
	util.AddNetworkString('tttRsDeathNotifyEnhanced')
else
	hook.Add('TTTUlxModifySettings', 'TTTRolesetupModifySettings', function(name)
		local tttrspnl = xlib.makelistlayout{w = 415, h = 318, parent = xgui.null}

		local tttrsclp = vgui.Create('DCollapsibleCategory', tttrspnl)
		tttrsclp:SetSize(390, 100)
		tttrsclp:SetExpanded(1)
		tttrsclp:SetLabel('Rolesetup')

		local tttrslst = vgui.Create('DPanelList', tttrsclp)
		tttrslst:SetPos(5, 25)
		tttrslst:SetSize(390, 100)
		tttrslst:SetSpacing(5)

		local tttrsdh = xlib.makecheckbox{label = 'Tell Roles at Roundstart (Def. 1)', repconvar = 'rep_ttt_rolesetup_tell_pre_roles', parent = tttrslst}
		tttrslst:AddItem(tttrsdh)

		local tttrsdh2 = xlib.makecheckbox{label = 'Tell Killerinfo in Chat (Def. 1)', repconvar = 'rep_ttt_rolesetup_tell_killer', parent = tttrslst}
		tttrslst:AddItem(tttrsdh2)

		local tttrsdh3 = xlib.makecheckbox{label = 'Show Killerinfo Popup (Def. 1)', repconvar = 'rep_ttt_rolesetup_killer_popup', parent = tttrslst}
		tttrslst:AddItem(tttrsdh3)

		local tttrsdh4 = xlib.makecheckbox{label = 'Tell Roles at Roundend (Def. 1)', repconvar = 'rep_ttt_rolesetup_tell_after_roles', parent = tttrslst}
		tttrslst:AddItem(tttrsdh4)

		xgui.hookEvent('onProcessModules', nil, tttrspnl.processModules)
		xgui.addSubModule('Rolesetup', tttrspnl, nil, name)
	end)

	hook.Add('Initialize', 'TTTInitRS', function()
		-- ENGLISH
		LANG.AddToLanguage('English', 'ttt_rs_preText', '0%There are %1%{traits} traitors%0%, %2%{innos} innocents%0% and %3%{specs} spectators%0% this round.')
		LANG.AddToLanguage('English', 'ttt_rs_postText', 'The role distribution this round:')
		LANG.AddToLanguage('English', 'ttt_rs_killText', '0%You were killed by %1%{killer}%0%. Role: %2%{role}%0%. (type: {killtype})')
		LANG.AddToLanguage('English', 'ttt_rs_suicideText', '0%You were killed by someone called yourself... (type: killtype})')
		LANG.AddToLanguage('English', 'ttt_rs_worldKillText', '0%You were killed by the world.')

		LANG.AddToLanguage('English', 'ttt_rs_killtype_unknown', 'unknown')
		LANG.AddToLanguage('English', 'ttt_rs_killtype_propkill', 'propkill')
		LANG.AddToLanguage('English', 'ttt_rs_killtype_falldamage', 'falldamage')
		LANG.AddToLanguage('English', 'ttt_rs_killtype_firedamage', 'firedamage')
		LANG.AddToLanguage('English', 'ttt_rs_killtype_explosion', 'explosion')
		LANG.AddToLanguage('English', 'ttt_rs_killtype_drowned', 'drowned')

		-- GERMAN
		LANG.AddToLanguage('Deutsch', 'ttt_rs_preText', '0%Es gibt %1%{traits} Verräter%0%, %2%{innos} Unschuldige%0% und %3%{specs} Zuschauer%0% diese Runde.')
		LANG.AddToLanguage('Deutsch', 'ttt_rs_postText', 'Die Rollenverteilung diese Runde:')
		LANG.AddToLanguage('Deutsch', 'ttt_rs_killText', '0%Du wurdest von %1%{killer}%0% getötet. Rolle: %2%{role}%0%. (type: {killtype}')
		LANG.AddToLanguage('Deutsch', 'ttt_rs_suicideText', '0%Du hast dich selbst getötet! (type: {killtype}')
		LANG.AddToLanguage('Deutsch', 'ttt_rs_worldKillText', '0%Du wurdest von der Welt getötet.')

		LANG.AddToLanguage('Deutsch', 'ttt_rs_killtype_unknown', 'unbekannt')
		LANG.AddToLanguage('Deutsch', 'ttt_rs_killtype_propkill', 'Propkill')
		LANG.AddToLanguage('Deutsch', 'ttt_rs_killtype_falldamage', 'Fallschaden')
		LANG.AddToLanguage('Deutsch', 'ttt_rs_killtype_firedamage', 'Feuerschaden')
		LANG.AddToLanguage('Deutsch', 'ttt_rs_killtype_explosion', 'Explosion')
		LANG.AddToLanguage('Deutsch', 'ttt_rs_killtype_drowned', 'ertrunken')
	end)

if CLIENT then
	net.Receive('tttRsTellPre', function(len)
		local PT = LANG.GetParamTranslation
		local tblSize = net.ReadUInt(ROLE_BITS)
		local rls = {}

		for i = 1, tblSize do
			rls[net.ReadUInt(ROLE_BITS)] = net.ReadUInt(32)
		end

		local spectators = net.ReadUInt(9)
		local txt = PT('ttt_rs_preText', {traits = rls[ROLE_TRAITOR], innos = rls[ROLE_INNOCENT], specs = spectators})
		local arr = string.Explode('%', txt)

		for k, v in ipairs(arr) do
			if v == '0' then
				arr[k] = Color(255, 255, 255, 255)
			elseif v == '1' then
				arr[k] = GetRoleByIndex(1).color --traitor
			elseif v == '2' then
				arr[k] = GetRoleByIndex(0).color --innocent
			elseif v == '3' then
				arr[k] = team.GetColor(TEAM_SPEC) --spectator
			end
		end

		chat.AddText(unpack(arr)) -- convert table to list of vars
	end)

	net.Receive('tttRsDeathNotify', function(len)
		-- how long should the panel be displayed
		local display_time = net.ReadUInt(16)

		local killer_text = net.ReadBool()
		local killer_popup = net.ReadBool()
		
		-- damage type: https://wiki.garrysmod.com/page/Enums/DMG
		local damage_type = net.ReadUInt(32)
		local damage_type_icon_path = 'vgui/ttt/icon_skull' -- TODO get description from confirm panel
		local damage_type_name_lang = 'ttt_rs_killtype_unknown'
		if bit.band(damage_type, DMG_CRUSH) == DMG_CRUSH then
			damage_type_icon_path = 'vgui/ttt/icon_rock'
			damage_type_name_lang = 'ttt_rs_killtype_propkill'
		end
		if bit.band(damage_type, DMG_FALL) == DMG_FALL then
			damage_type_icon_path = 'vgui/ttt/icon_fall'
			damage_type_name_lang = 'ttt_rs_killtype_falldamage'
		end
		if bit.band(damage_type, DMG_BURN) == DMG_BURN then
			damage_type_icon_path = 'vgui/ttt/icon_fire'
			damage_type_name_lang = 'ttt_rs_killtype_firedamage'
		end
		if bit.band(damage_type, DMG_BLAST) == DMG_BLAST then
			damage_type_icon_path = 'vgui/ttt/icon_splode'
			damage_type_name_lang = 'ttt_rs_killtype_explosion'
		end
		if bit.band(damage_type, DMG_DROWN) == DMG_DROWN then
			damage_type_icon_path = 'vgui/ttt/icon_drown'
			damage_type_name_lang = 'ttt_rs_killtype_drowned'
		end
		KILLER_INFO:RegisterDamageType(damage_type_icon_path, damage_type_name_lang)
		
		-- check killer type before displaying UI element
		local killer_type = net.ReadUInt(2)
		if killer_type == 3 then
			if killer_popup then KILLER_INFO:DisplayPopupWorld(display_time) end
			if killer_text then KILLER_INFO:PrintWorld() end
			return
		end

		if killer_type == 2 then
			if killer_popup then KILLER_INFO:DisplayPopupSelf(display_time) end
			if killer_text then KILLER_INFO:PrintSelf() end
			return
		end

		local killer_ent = net.ReadEntity()
		local killer_role_id = net.ReadUInt(ROLE_BITS)

		local killer_nick = killer_ent:Nick()
		local killer_sid64 = killer_ent:SteamID64()
		local killer_role = GetRoleByIndex(killer_role_id).abbr
		local killer_role_lang = GetRoleByIndex(killer_role_id).name
		local killer_role_color = GetRoleByIndex(killer_role_id).color

		local killer_health = killer_ent:Health()
		local killer_health_max = killer_ent:GetMaxHealth()
		
		KILLER_INFO:RegisterKiller(killer_nick, killer_sid64, killer_role, killer_role_lang, killer_role_color, killer_health, killer_health_max)

		local wep_class = net.ReadEntity()
		if not IsValid(wep_class) then
			if killer_popup then KILLER_INFO:DisplayPopupKillerNoWeapon(display_time) end
			if killer_text then KILLER_INFO:PrintKillerNoWeapon() end
			return
		end

		local wep_clip = net.ReadInt(16)
		local wep_clip_max = net.ReadInt(16)
		local wep_ammo = net.ReadInt(16)
		local was_headshot = net.ReadBool()

		local wep_name = ''
		if wep_class['GetPrintName'] == nil then
			wep_name = wep_class.PrintName or wep_class:GetClass() or '...'
		else
			wep_name = wep_class:GetPrintName() or wep_class.PrintName or wep_class:GetClass() or '...'
		end

		KILLER_INFO:RegisterWeapon(wep_name, wep_clip, wep_clip_max, wep_ammo, wep_class.Icon or 'vgui/ttt/icon_nades', was_headshot)
		if killer_popup then KILLER_INFO:DisplayPopupKillerWeapon(display_time) end
		if killer_text then KILLER_INFO:PrintKillerWeapon() end
	end)

	net.Receive('tttRsTellPost', function(len)
		local T = LANG.GetTranslation
		local rolesnames = {}
		local rolecolor = defcolor
		local txt = T('ttt_rs_postText')
		local roles_size = net.ReadUInt(ROLE_BITS)

		for i = 1, roles_size do
			rolesnames[net.ReadUInt(ROLE_BITS)] = net.ReadString()
		end

		chat.AddText(defcolor, txt)

		for k, v in pairs(rolesnames) do
			txt = ''
			if v then
				local list = string.Explode(',', v)

				for k2, v2 in ipairs(list) do
					local temp = '%1%' .. v2 .. '%0%'

					if k2 > 1 then
						v = v .. ',' .. temp
					elseif k2 == 1 then
						v = temp
					end
				end

				if not TTT2 then
					if k == ROLE_INNOCENT then
						txt = ('2%' .. T('innocent') .. '%0%: ' .. v)
						rolecolor = GetRoleByIndex(0).color
					elseif k == ROLE_TRAITOR then
						txt = ('2%' .. T('traitor') .. '%0%: ' .. v)
						rolecolor = GetRoleByIndex(1).color
					elseif k == ROLE_DETECTIVE then
						txt = ('2%' .. T('detective') .. '%0%: ' .. v)
						rolecolor = GetRoleByIndex(2).color
					end
				else
					local rd = GetRoleByIndex(k)

					rolecolor = rd.color

					txt = ('2%' .. T(rd.name) .. '%0%: ' .. v)
				end
			end

			local arr = string.Explode('%', txt)

			for k2, v2 in ipairs(arr) do
				if v2 == '0' then
					arr[k2] = defcolor
				elseif v2 == '1' then
					arr[k2] = namecolor
				elseif v2 == '2' then
					arr[k2] = rolecolor
				end
			end

			chat.AddText(unpack(arr))
		end
	end)
end
