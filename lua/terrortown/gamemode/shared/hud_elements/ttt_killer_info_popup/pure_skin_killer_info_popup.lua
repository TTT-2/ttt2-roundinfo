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

	local materialHealth = Material("vgui/ttt/hud_health.vmt")
	local materialHealthLow = Material("vgui/ttt/hud_health_low.vmt")

	local mat_tid_ammo = Material("vgui/ttt/tid/tid_ammo")

	local colorHeadshot = Color(240, 80, 45, 180)
	local colorHealth = Color(234, 41, 41)
	local colorAmmo = Color(238, 151, 0)
	local colorShadow = Color(0, 0, 0, 90)

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

	local materialArmorDefault = Material("vgui/ttt/hud_armor.vmt")
	local materialArmorReinforced = Material("vgui/ttt/hud_armor_reinforced.vmt")

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
		local paddingEdge = 39 * self.scale
		local paddingInner = 14 * self.scale
		local paddingSmall = 5 * self.scale

		local sizeColorBar2 = 78 * self.scale

		local sizeWeaponIcon = 32 * self.scale
		local sizeKillerIcon = 64 * self.scale
		local sizeHeadshotIcon = 24 * self.scale
		local sizeRoleIcon = 40 * self.scale

		local offsetColorBar2 = 32 * self.scale
		local offsetColorBar3 = 124 * self.scale
		local offsetKillerIcon = 46 * self.scale
		local offsetX = 42 * self.scale
		local offsetContentX = x + paddingEdge + sizeColorBar2 + paddingInner

		local heightBar = 26 * self.scale
		local widthBar = x + w - offsetContentX - paddingInner

		local sizeBarIcon = heightBar - 11 * self.scale
		local xBarIcon = offsetContentX + 0.5 * sizeBarIcon
		local xBarText = xBarIcon + sizeBarIcon + paddingSmall

		local yHealthBar = y + paddingEdge + sizeColorBar2 - heightBar - paddingInner
		local yHealthBarContent = yHealthBar + paddingSmall

		local yAmmoBar = y + h - paddingInner - heightBar
		local yAmmoBarContent = yAmmoBar + paddingSmall

		local colorTextBase = util.GetDefaultColor(self.basecolor)
		local colorHealthContent = util.GetDefaultColor(colorHealth)
		local colorAmmoContent = util.GetDefaultColor(colorAmmo)

		-- draw bg
		draw.Box(x, y, w, h, self.basecolor)
		draw.AdvancedText(
			string.upper(LANG.GetTranslation("ttt_rs_you_were_killed")),
			"PureSkinBar",
			x + paddingEdge + sizeColorBar2 + paddingInner,
			y + paddingInner - 4 * self.scale,
			colorTextBase,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_TOP,
			true,
			self.scale
		)

		draw.Box(x, y + paddingEdge, w, sizeColorBar2, colorShadow)
		draw.Box(x + paddingEdge, y, sizeColorBar2, offsetColorBar2, KILLER_INFO.data.killer_role_color)
		draw.Box(x + paddingEdge, y + paddingEdge, sizeColorBar2, sizeColorBar2, KILLER_INFO.data.killer_role_color)
		draw.Box(x + paddingEdge, y + offsetColorBar3, sizeColorBar2, h - offsetColorBar3, KILLER_INFO.data.killer_role_color)

		draw.FilteredTexture(x + offsetKillerIcon, y + offsetKillerIcon, sizeKillerIcon, sizeKillerIcon, KILLER_INFO.data.killer_icon)

		self:DrawLines(x + paddingEdge, y + paddingEdge, sizeColorBar2, sizeColorBar2, self.basecolor.a)
		self:DrawLines(x + offsetKillerIcon, y + offsetKillerIcon, sizeKillerIcon, sizeKillerIcon, self.basecolor.a)

		-- killer name
		draw.AdvancedText(
			string.upper(KILLER_INFO.data.killer_name),
			"PureSkinBar",
			offsetContentX,
			y + paddingEdge + paddingInner - 4 * self.scale,
			colorTextBase,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_TOP,
			true,
			self.scale
		)

		local materialHealth = materialHealth

		if KILLER_INFO.data.killer_health <= KILLER_INFO.data.killer_max_health * 0.25 then
			materialHealth = materialHealthLow
		end

		-- killer hp
		self:DrawBar(
			offsetContentX,
			yHealthBar,
			widthBar,
			heightBar,
			colorHealth,
			KILLER_INFO.data.killer_health / KILLER_INFO.data.killer_max_health,
			self.scale
		)

		draw.FilteredShadowedTexture(xBarIcon, yHealthBarContent, sizeBarIcon, sizeBarIcon, materialHealth, colorHealthContent.a, colorHealthContent, self.scale)
		draw.AdvancedText(
			KILLER_INFO.data.killer_health,
			"PureSkinBar",
			xBarText,
			yHealthBar + 0.5 * heightBar - 1 * self.scale,
			colorHealthContent,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_CENTER,
			true,
			self.scale
		)

		-- draw armor information
		if not GetGlobalBool("ttt_armor_classic", false) and KILLER_INFO.data.killer_armor > 0 then
			local materialArmor = LocalPlayer():ArmorIsReinforced() and materialArmorReinforced or materialArmorDefault

			local xArmorIcon = offsetContentX + widthBar - 65 * self.scale
			local xArmorText = xArmorIcon + sizeBarIcon + paddingSmall

			draw.FilteredShadowedTexture(xArmorIcon, yHealthBarContent, sizeBarIcon, sizeBarIcon, materialArmor, colorHealthContent.a, colorHealthContent, self.scale)
			draw.AdvancedText(
				KILLER_INFO.data.killer_armor,
				"PureSkinBar",
				xArmorText,
				yHealthBar + 0.5 * heightBar - 1 * self.scale,
				colorHealthContent,
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_CENTER,
				true,
				self.scale
			)
		end

		-- killer role
		if KILLER_INFO.data.mode ~= "killer_world" then
			draw.FilteredShadowedTexture(
				x + paddingEdge + 0.5 * (sizeColorBar2 - sizeRoleIcon),
				y + paddingEdge + sizeColorBar2 + paddingInner,
				sizeRoleIcon,
				sizeRoleIcon,
				KILLER_INFO.data.killer_role_icon,
				colorTextBase.a,
				colorTextBase,
				self.scale
			)
		end

		if KILLER_INFO.data.mode == "killer_self_no_weapon" or KILLER_INFO.data.mode == "killer_no_weapon" or KILLER_INFO.data.mode == "killer_world" then
			local xWeapon = x + paddingEdge + sizeColorBar2 + paddingInner
			local yWeapon = y + paddingEdge + sizeColorBar2 + paddingInner

			draw.FilteredTexture(xWeapon, yWeapon, sizeWeaponIcon, sizeWeaponIcon, KILLER_INFO.data.damage_type_icon)
			self:DrawLines(xWeapon, yWeapon, sizeWeaponIcon, sizeWeaponIcon, self.basecolor.a * 0.75)

			draw.AdvancedText(
				string.upper(KILLER_INFO.data.damage_type_name),
				"PureSkinBar",
				xWeapon + offsetX,
				yWeapon + 5 * self.scale,
				colorTextBase,
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_TOP,
				true,
				self.scale
			)

			return
		end

		-- killer weapon info
		local xWeapon = x + paddingEdge + sizeColorBar2 + paddingInner
		local yWeapon = y + paddingEdge + sizeColorBar2 + paddingInner

		-- killer weapon icon
		draw.FilteredTexture(xWeapon, yWeapon, sizeWeaponIcon, sizeWeaponIcon, KILLER_INFO.data.killer_weapon_icon)
		self:DrawLines(xWeapon, yWeapon, sizeWeaponIcon, sizeWeaponIcon, self.basecolor.a * 0.75)

		-- killer weapon name
		draw.AdvancedText(
			string.upper(KILLER_INFO.data.killer_weapon_name),
			"PureSkinBar",
			xWeapon + offsetX,
			yWeapon + 5 * self.scale,
			colorTextBase,
			TEXT_ALIGN_LEFT,
			TEXT_ALIGN_TOP,
			true,
			self.scale
		)

		-- killer weapon headshot
		if KILLER_INFO.data.killer_weapon_head then
			draw.FilteredShadowedTexture(
				x + w - paddingInner - sizeHeadshotIcon,
				yWeapon + 3 * self.scale,
				sizeHeadshotIcon,
				sizeHeadshotIcon,
				self.icon_headshot,
				colorHeadshot.a,
				colorHeadshot
			)
		end

		-- killer ammo
		if KILLER_INFO.data.killer_weapon_clip >= 0 then
			local ammo_type = string.lower( game.GetAmmoTypes()[KILLER_INFO.data.killer_weapon_ammo_type] or "" )
			local materialArmor = BaseClass.BulletIcons[ammo_type] or mat_tid_ammo

			self:DrawBar(
				offsetContentX,
				yAmmoBar,
				widthBar,
				heightBar,
				colorAmmo,
				KILLER_INFO.data.killer_weapon_clip / KILLER_INFO.data.killer_weapon_clip_max,
				self.scale
			)

			draw.FilteredShadowedTexture(xBarIcon, yAmmoBarContent, sizeBarIcon, sizeBarIcon, materialArmor, colorAmmoContent.a, colorAmmoContent, self.scale)
			draw.AdvancedText(
				string.format("%i + %02i", KILLER_INFO.data.killer_weapon_clip, KILLER_INFO.data.killer_weapon_ammo),
				"PureSkinBar",
				xBarText,
				yAmmoBar + 0.5 * heightBar - 1 * self.scale,
				colorAmmoContent,
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_CENTER,
				true,
				self.scale
			)
		end
	end
end
