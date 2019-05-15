if CLIENT then
    KILLER_POPUP = {}

    KILLER_POPUP.data = {
        render = false,
        mode = 0,
        killer_name = 'KILLER_NAME',
        killer_sid64 = '',
        killer_icon = Material("vgui/ttt/icon_corpse"),
        killer_role = 'KILLER_ROLE',
        killer_role_color = Color(50,70,180,255),
        killer_role_icon = Material("vgui/ttt/dynamic/roles/icon_det"),
        killer_health = 75,
        killer_max_health = 100,
        killer_weapon_name = 'WEAPON_NAME',
        killer_weapon_clip = 17,
        killer_weapon_clip_max = 20,
        killer_weapon_ammo = 12,
        killer_weapon_icon = Material("vgui/ttt/icon_corpse"),
        killer_weapon_head = true
    }

    function KILLER_POPUP:RegisterKiller(name, sid64, role, role_color, health, health_max)
        self.data.killer_name = name
        self.data.killer_sid64 = sid64
        self.data.killer_icon = draw.GetAvatarMaterial("76561198047819379", "medium", Material("vgui/ttt/icon_corpse"))
        self.data.killer_role = role
        self.data.killer_role_icon = Material("vgui/ttt/dynamic/roles/icon_" .. role)
        self.data.killer_role_color = role_color
        self.data.killer_health = health
        self.data.killer_health_max = health_max
    end

    function KILLER_POPUP:RegisterWeapon(name, clip, clip_max, ammo, icon_path, headshot)
        self.data.killer_weapon_name = name
        self.data.killer_weapon_clip = clip
        self.data.killer_weapon_clip_max = clip_max
        self.data.killer_weapon_ammo = ammo
        self.data.killer_weapon_icon = Material(icon_path)
        self.data.killer_weapon_head = headshot
    end

    function KILLER_POPUP:DisplayPopupKillerWeapon(display_time)
        if (GAMEMODE.round_state ~= ROUND_ACTIVE and GAMEMODE.round_state ~= ROUND_POST) then return end
        
        self.data.render = true
        self.data.mode = 1

        -- set timer
        timer.Create("display_popup", display_time, 1, function() self:HidePopup() end)
    end

    function KILLER_POPUP:DisplayPopupKillerNoWeapon(display_time)
        if (GAMEMODE.round_state ~= ROUND_ACTIVE and GAMEMODE.round_state ~= ROUND_POST) then return end
        
        self.data.render = true
        self.data.mode = 2

        -- set timer
        timer.Create("display_popup", display_time, 1, function() self:HidePopup() end)
    end

    function KILLER_POPUP:DisplayPopupWorld(display_time)
        if (GAMEMODE.round_state ~= ROUND_ACTIVE and GAMEMODE.round_state ~= ROUND_POST) then return end
        
        self.data.render = true
        self.data.mode = 3

        -- set timer
        timer.Create("display_popup", display_time, 1, function() self:HidePopup() end)
    end

    function KILLER_POPUP:DisplayPopupSelf(display_time)
        if (GAMEMODE.round_state ~= ROUND_ACTIVE and GAMEMODE.round_state ~= ROUND_POST) then return end

        self.data.render = true
        self.data.mode = 4

        -- set timer
        timer.Create("display_popup", display_time, 1, function() self:HidePopup() end)
    end




    function KILLER_POPUP:HidePopup()
        self.data.render = false
        self.data.mode = 0

        if timer.Exists("display_popup") then
            timer.Remove("display_popup")
        end
    end

    hook.Add("TTTPrepareRound", "hide_popup_round_prepare", function() KILLER_POPUP:HidePopup() end)
    hook.Add("TTTBeginRound", "hide_popup_round_begin", function() KILLER_POPUP:HidePopup() end)
    hook.Add("PlayerSpawn", "hide_popup_player_spawn", function() KILLER_POPUP:HidePopup() end)
end