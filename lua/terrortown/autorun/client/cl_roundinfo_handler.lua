if CLIENT then
	KILLER_INFO = {}

	local KILLER_INFO_FALLBACK_DATA = {
		render = false,
		mode = "killer_self",
		killer_name = "KILLER_NAME",
		killer_sid64 = "",
		killer_icon = Material("vgui/ttt/avatar_killer_world"),
		killer_role = "inno",
		killer_role_lang = "",
		killer_role_color = Color(80,173,59),
		killer_role_icon = Material("vgui/ttt/dynamic/roles/icon_inno"),
		killer_health = 75,
		killer_max_health = 100,
		killer_armor = 30,
		killer_armor_max = 45,
		killer_weapon_name = "WEAPON_NAME",
		killer_weapon_clip = 3,
		killer_weapon_clip_max = 10,
		killer_weapon_ammo = 40,
		killer_weapon_ammo_type = "",
		killer_weapon_icon = Material("vgui/ttt/icon_nades"),
		killer_weapon_head = true,
		damage_type_name = "TYPE",
		damage_type_icon = Material("vgui/ttt/icon_skull")
	}

	KILLER_INFO_FALLBACK_DATA.__index = KILLER_INFO_FALLBACK_DATA

	function KILLER_INFO:Reset()
		KILLER_INFO.data = {}

		setmetatable(KILLER_INFO.data, KILLER_INFO_FALLBACK_DATA)
	end

	-- Initialize KILLER_INFO with default values
	KILLER_INFO:Reset()

	function KILLER_INFO:RegisterKiller(name, sid64, role, role_lang, role_color, health, health_max, armor, armor_max)
		self.data.killer_name = name
		self.data.killer_sid64 = tostring(sid64)
		self.data.killer_icon = draw.GetAvatarMaterial(self.data.killer_sid64, "medium", Material("vgui/ttt/icon_corpse"))
		self.data.killer_role = role
		self.data.killer_role_lang = role_lang
		self.data.killer_role_icon = Material("vgui/ttt/dynamic/roles/icon_" .. role)
		self.data.killer_role_color = role_color
		self.data.killer_health = health
		self.data.killer_health_max = health_max
		self.data.killer_armor = armor
		self.data.killer_armor_max = armor_max
	end

	function KILLER_INFO:RegisterWeapon(name, clip, clip_max, ammo, ammo_type, icon_path, headshot)
		self.data.killer_weapon_name = LANG.TryTranslation(name)
		self.data.killer_weapon_clip = clip
		self.data.killer_weapon_clip_max = clip_max
		self.data.killer_weapon_ammo = ammo
		self.data.killer_weapon_ammo_type = ammo_type
		self.data.killer_weapon_icon = Material(icon_path)
		self.data.killer_weapon_head = headshot
	end

	function KILLER_INFO:RegisterDamageType(damage_type_icon_path, damage_type_name_lang)
		self.data.damage_type_icon = Material(damage_type_icon_path)
		self.data.damage_type_name = LANG.GetTranslation(damage_type_name_lang)
	end

	function KILLER_INFO:DisplayPopupKillerWeapon(display_time)
		if GAMEMODE.round_state ~= ROUND_ACTIVE and GAMEMODE.round_state ~= ROUND_POST then return end

		self.data.render = true
		self.data.mode = "killer_weapon"

		-- set timer
		timer.Create("display_popup", display_time, 1, function() self:HidePopup() end)
	end

	function KILLER_INFO:DisplayPopupKillerNoWeapon(display_time)
		if GAMEMODE.round_state ~= ROUND_ACTIVE and GAMEMODE.round_state ~= ROUND_POST then return end

		self.data.render = true
		self.data.mode = "killer_no_weapon"

		-- set timer
		timer.Create("display_popup", display_time, 1, function() self:HidePopup() end)
	end

	function KILLER_INFO:DisplayPopupWorld(display_time)
		if GAMEMODE.round_state ~= ROUND_ACTIVE and GAMEMODE.round_state ~= ROUND_POST then return end

		self.data.render = true
		self.data.mode = "killer_world"

		self.data.killer_name = LANG.GetTranslation("ttt_rs_killer_world")
		self.data.killer_icon = Material("vgui/ttt/avatar_killer_world")
		self.data.killer_role_color = Color(222,222,222,150)

		-- hp of world is TTT2 release date
		self.data.killer_health = 20180509
		self.data.killer_health_max = 20180509

		-- set timer
		timer.Create("display_popup", display_time, 1, function() self:HidePopup() end)
	end

	function KILLER_INFO:DisplayPopupSelfNoWeapon(display_time)
		if GAMEMODE.round_state ~= ROUND_ACTIVE and GAMEMODE.round_state ~= ROUND_POST then return end

		self.data.render = true
		self.data.mode = "killer_self_no_weapon"

		-- set killer role to local player
		self.data.killer_name = LANG.GetTranslation("ttt_rs_killer_yourself")
		self.data.killer_sid64 = tostring(LocalPlayer():SteamID64())
		self.data.killer_icon = draw.GetAvatarMaterial(self.data.killer_sid64, "medium", Material("vgui/ttt/icon_corpse"))
		self.data.killer_role = GetRoleByIndex(LocalPlayer():GetSubRole()).abbr
		self.data.killer_role_icon = Material("vgui/ttt/dynamic/roles/icon_" .. self.data.killer_role)
		self.data.killer_role_color = LocalPlayer():GetRoleColor()
		self.data.killer_health = 0
		self.data.killer_health_max = 100
		self.data.killer_armor = LocalPlayer():GetArmor()
		self.data.killer_armor_max = LocalPlayer():GetMaxArmor()

		-- set timer
		timer.Create("display_popup", display_time, 1, function() self:HidePopup() end)
	end

	function KILLER_INFO:DisplayPopupSelfWeapon(display_time)
		if GAMEMODE.round_state ~= ROUND_ACTIVE and GAMEMODE.round_state ~= ROUND_POST then return end

		self.data.render = true
		self.data.mode = "killer_self_weapon"

		-- set killer role to local player
		self.data.killer_name = LANG.GetTranslation("ttt_rs_killer_yourself")
		self.data.killer_sid64 = tostring(LocalPlayer():SteamID64())
		self.data.killer_icon = draw.GetAvatarMaterial(self.data.killer_sid64, "medium", Material("vgui/ttt/icon_corpse"))
		self.data.killer_role = GetRoleByIndex(LocalPlayer():GetSubRole()).abbr
		self.data.killer_role_icon = Material("vgui/ttt/dynamic/roles/icon_" .. self.data.killer_role)
		self.data.killer_role_color = LocalPlayer():GetRoleColor()
		self.data.killer_health = 0
		self.data.killer_health_max = 100
		self.data.killer_armor = LocalPlayer():GetArmor()
		self.data.killer_armor_max = LocalPlayer():GetMaxArmor()

		-- set timer
		timer.Create("display_popup", display_time, 1, function() self:HidePopup() end)
	end

	function KILLER_INFO:HidePopup()
		self.data.render = false
		KILLER_INFO:Reset()

		if timer.Exists("display_popup") then
			timer.Remove("display_popup")
		end
	end

	hook.Add("TTTPrepareRound", "hide_popup_round_prepare", function() KILLER_INFO:HidePopup() end)
	hook.Add("TTTBeginRound", "hide_popup_round_begin", function() KILLER_INFO:HidePopup() end)

	function KILLER_INFO:PrintKillerWeapon()
		if GAMEMODE.round_state ~= ROUND_ACTIVE and GAMEMODE.round_state ~= ROUND_POST then return end

		local txt = LANG.GetParamTranslation("ttt_rs_killText", {killer = self.data.killer_name, role = LANG.GetTranslation(self.data.killer_role_lang), killtype = self.data.killer_weapon_name})
		self:PrintColor(txt)
	end

	function KILLER_INFO:PrintKillerNoWeapon()
		if GAMEMODE.round_state ~= ROUND_ACTIVE and GAMEMODE.round_state ~= ROUND_POST then return end

		local txt = LANG.GetParamTranslation("ttt_rs_killText", {killer = self.data.killer_name, role = LANG.GetTranslation(self.data.killer_role_lang), killtype = self.data.damage_type_name})
		self:PrintColor(txt)
	end

	function KILLER_INFO:PrintWorld()
		if GAMEMODE.round_state ~= ROUND_ACTIVE and GAMEMODE.round_state ~= ROUND_POST then return end

		local txt = LANG.GetTranslation("ttt_rs_worldKillText")
		self:PrintColor(txt)
	end

	function KILLER_INFO:PrintSelf()
		if GAMEMODE.round_state ~= ROUND_ACTIVE and GAMEMODE.round_state ~= ROUND_POST then return end

		local txt = LANG.GetParamTranslation("ttt_rs_suicideText", {killtype = self.data.killer_weapon_name ~= "WEAPON_NAME" and self.data.killer_weapon_name or self.data.damage_type_name})
		self:PrintColor(txt)
	end

	function KILLER_INFO:PrintColor(txt)
		local arr = string.Explode("%", txt)

		for k, v in ipairs(arr) do
			if v == "0" then
				arr[k] = Color(255, 255, 255, 255)
			elseif v == "1" then
				arr[k] = Color(255, 255, 0, 255)
			elseif v == "2" then
				arr[k] = self.data.killer_role_color
			end
		end

		chat.AddText(unpack(arr))
	end
end
