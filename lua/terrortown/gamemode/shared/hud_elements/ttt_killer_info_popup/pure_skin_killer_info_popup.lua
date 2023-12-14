local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then -- CLIENT
	local const_defaults = {
		basepos = {x = 0, y = 0},
		size = {w = 400, h = 213},
		minsize = {w = 350, h = 213}
	}

	HUDELEMENT.icon_headshot = Material("vgui/ttt/huds/icon_headshot")

	local icon_health = Material("vgui/ttt/hud_health.vmt")
	local icon_health_low = Material("vgui/ttt/hud_health_low.vmt")

	local mat_tid_ammo = Material("vgui/ttt/tid/tid_ammo")

	local color_headshot = Color(240, 80, 45, 180)
	local color_health = Color(234, 41, 41)
	local color_ammoBar = Color(238, 151, 0)
	local color_shadow = Color(0, 0, 0, 90)

	function HUDELEMENT:PreInitialize()
		BaseClass.PreInitialize(self)

		local hud = huds.GetStored("pure_skin")
		if hud then
			hud:ForceElement(self.id)
		end

		-- set as fallback default, other skins have to be set to true!
		self.disabledUnlessForced = false
	end

	function HUDELEMENT:Initialize()
		self.scale = 1.0
		self.basecolor = self:GetHUDBasecolor()

		BaseClass.Initialize(self)
	end

	function HUDELEMENT:PerformLayout()
		self.basecolor = self:GetHUDBasecolor()
		self.scale = appearance.GetGlobalScale()

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = {x = math.Round(ScrW() - (110 * self.scale + self.size.w)), y = math.Round(ScrH() * 0.5 - self.size.h * 0.5)}

		return const_defaults
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, false
	end

	function HUDELEMENT:ShouldDraw()
		return KILLER_INFO.data.render or HUDEditor.IsEditing
	end
	-- parameter overwrites end

	local icon_armor = Material("vgui/ttt/hud_armor.vmt")
	local icon_armor_rei = Material("vgui/ttt/hud_armor_reinforced.vmt")

	function HUDELEMENT:Draw()
		local pos = self:GetPos()
		local size = self:GetSize()
		local x, y = pos.x, pos.y
		local w, h = size.w, size.h

		self:DrawHelper(x, y, w, h)

		-- draw border and shadow
		self:DrawLines(x, y, w, h, self.basecolor.a)
	end

	-- added to a helper function to use return instead of nested ifs
	function HUDELEMENT:DrawHelper(x, y, w, h)
		-- params
		local edge_padding = 39 * self.scale
		local box_size = 78 * self.scale
		local inner_padding = 14 * self.scale

		local offsetColorBar2 = 32 * self.scale
		local offsetColorBar3 = 124 * self.scale
		local offsetKillerIcon = 46 * self.scale
		local offsetX = 42 * self.scale

		local sizeWeaponIcon = 32 * self.scale
		local sizeKillerIcon = 64 * self.scale
		local sizeHeadshotIcon = 24 * self.scale
		local sizeRoleIcon = 40 * self.scale

		-- draw bg
		self:DrawBg(x, y, w, h, self.basecolor)

		local ix = x + edge_padding + box_size + inner_padding
		local iy = y + inner_padding - 4 * self.scale

		local ywkb = string.upper(LANG.GetTranslation("ttt_rs_you_were_killed"))
		draw.AdvancedText(ywkb, "PureSkinBar", ix, iy, util.GetDefaultColor(self.basecolor), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, true, self.scale)

		draw.Box(x, y + edge_padding, w, box_size, color_shadow)
		draw.Box(x + edge_padding, y, box_size, offsetColorBar2, KILLER_INFO.data.killer_role_color)
		draw.Box(x + edge_padding, y + edge_padding, box_size, box_size, KILLER_INFO.data.killer_role_color)
		draw.Box(x + edge_padding, y + offsetColorBar3, box_size, h - offsetColorBar3, KILLER_INFO.data.killer_role_color)

		draw.FilteredTexture(x + offsetKillerIcon, y + offsetKillerIcon, sizeKillerIcon, sizeKillerIcon, KILLER_INFO.data.killer_icon)

		self:DrawLines(x + edge_padding, y + edge_padding, box_size, box_size, self.basecolor.a)
		self:DrawLines(x + offsetKillerIcon, y + offsetKillerIcon, sizeKillerIcon, sizeKillerIcon, self.basecolor.a)

		-- killer name
		local nx = x + edge_padding + box_size + inner_padding
		local ny = y + edge_padding + inner_padding - 4 * self.scale

		local killer_name = string.upper(KILLER_INFO.data.killer_name)
		draw.AdvancedText(killer_name, "PureSkinBar", nx, ny, util.GetDefaultColor(self.basecolor), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, true, self.scale)

		local health_icon = icon_health

		if KILLER_INFO.data.killer_health <= KILLER_INFO.data.killer_max_health * 0.25 then
			health_icon = icon_health_low
		end

		-- killer hp
		local bh = 26 * self.scale --  bar height
		local bx = nx
		local by = y + edge_padding + box_size - bh - inner_padding
		local bw = w - (bx - x) - inner_padding -- bar width

		self:DrawBar(bx, by, bw, bh, color_health, KILLER_INFO.data.killer_health / KILLER_INFO.data.killer_max_health, self.scale)

		local a_size = bh - 11 * self.scale
		local a_pad = 5 * self.scale

		local a_pos_y = by + a_pad
		local a_pos_x = bx + 0.5 * a_size

		local at_pos_y = by + 1 * self.scale
		local at_pos_x = a_pos_x + a_size + a_pad

		draw.FilteredShadowedTexture(a_pos_x, a_pos_y, a_size, a_size, health_icon, 255, COLOR_WHITE, self.scale)
		draw.AdvancedText(KILLER_INFO.data.killer_health, "PureSkinBar", at_pos_x, at_pos_y, util.GetDefaultColor(color_health), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, true, self.scale)

		-- draw armor information
		if not GetGlobalBool("ttt_armor_classic", false) and KILLER_INFO.data.killer_armor > 0 then
			local icon_mat = LocalPlayer():ArmorIsReinforced() and icon_armor_rei or icon_armor

			a_pos_x = nx + bw - 65 * self.scale
			at_pos_x = a_pos_x + a_size + a_pad

			draw.FilteredShadowedTexture(a_pos_x, a_pos_y, a_size, a_size, icon_mat, 255, COLOR_WHITE, self.scale)

			draw.AdvancedText(KILLER_INFO.data.killer_armor, "PureSkinBar", at_pos_x, at_pos_y, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, true, self.scale)
		end

		-- killer role
		if KILLER_INFO.data.mode ~= "killer_world" then
			draw.FilteredShadowedTexture(x + edge_padding + 0.5 * (box_size - sizeRoleIcon), y + edge_padding + box_size + inner_padding, sizeRoleIcon, sizeRoleIcon, KILLER_INFO.data.killer_role_icon, 255, COLOR_WHITE, self.scale)
		end

		if KILLER_INFO.data.mode == "killer_self_no_weapon" or KILLER_INFO.data.mode == "killer_no_weapon" or KILLER_INFO.data.mode == "killer_world" then
			local wx = x + edge_padding + box_size + inner_padding
			local wy = y + edge_padding + box_size + inner_padding

			draw.FilteredShadowedTexture(wx, wy, sizeWeaponIcon, sizeWeaponIcon, KILLER_INFO.data.damage_type_icon)
			self:DrawLines(wx, wy, sizeWeaponIcon, sizeWeaponIcon, self.basecolor.a * 0.75)

			local damage_type_name = string.upper(KILLER_INFO.data.damage_type_name)
			draw.AdvancedText(damage_type_name, "PureSkinBar", wx + offsetX, wy + 5 * self.scale, util.GetDefaultColor(self.basecolor), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, true, self.scale)
			return
		end

		-- killer weapon info
		local wx = x + edge_padding + box_size + inner_padding
		local wy = y + edge_padding + box_size + inner_padding

		-- killer weapon icon
		draw.FilteredTexture(wx, wy, sizeWeaponIcon, sizeWeaponIcon, KILLER_INFO.data.killer_weapon_icon)
		self:DrawLines(wx, wy, sizeWeaponIcon, sizeWeaponIcon, self.basecolor.a * 0.75)

		-- killer weapon name
		local weapon_name = string.upper(KILLER_INFO.data.killer_weapon_name)
		draw.AdvancedText(weapon_name, "PureSkinBar", wx + offsetX, wy + 5 * self.scale, util.GetDefaultColor(self.basecolor), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, true, self.scale)

		-- killer weapon headshot
		if KILLER_INFO.data.killer_weapon_head then
			draw.FilteredShadowedTexture(x + w - inner_padding - sizeHeadshotIcon, wy + 3 * self.scale, sizeHeadshotIcon, sizeHeadshotIcon, self.icon_headshot, color_headshot.a, color_headshot)
		end

		-- killer ammo
		local ah = 26 * self.scale -- bar height
		local ax = wx
		local ay = y + h - inner_padding - ah
		local aw = w - (wx - x) - inner_padding  -- bar width

		if KILLER_INFO.data.killer_weapon_clip >= 0 then
			local text = string.format("%i + %02i", KILLER_INFO.data.killer_weapon_clip, KILLER_INFO.data.killer_weapon_ammo)
			local icon_mat = BaseClass.BulletIcons[ammo_type] or mat_tid_ammo

			self:DrawBar(ax, ay, aw, ah, color_ammoBar, KILLER_INFO.data.killer_weapon_clip / KILLER_INFO.data.killer_weapon_clip_max, self.scale)

			a_pos_x = nx + 0.5 * a_size
			a_pos_y = ay + a_pad
			at_pos_y = ay + 1 * self.scale
			at_pos_x = a_pos_x + a_size + a_pad

			draw.FilteredShadowedTexture(a_pos_x, a_pos_y, a_size, a_size, icon_mat, 255, COLOR_WHITE, self.scale)
			draw.AdvancedText(text, "PureSkinBar", at_pos_x, at_pos_y, util.GetDefaultColor(color_ammoBar), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, true, self.scale)
		end
	end
end
