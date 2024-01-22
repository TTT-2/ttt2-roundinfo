CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = "submenu_server_addons_roundinfo_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local chatmsgs = vgui.CreateTTT2Form(parent, "header_addons_roundinfo_chat")

	chatmsgs:MakeCheckBox({
		serverConvar = "ttt_roundinfo_pre_announce_distribution",
		label = "label_roundinfo_pre_announce_distribution"
	})

	chatmsgs:MakeCheckBox({
		serverConvar = "ttt_roundinfo_post_announce_distribution",
		label = "label_roundinfo_post_announce_distribution"
	})

	chatmsgs:MakeCheckBox({
		serverConvar = "ttt_roundinfo_announce_killer",
		label = "label_roundinfo_announce_killer"
	})

	local popup = vgui.CreateTTT2Form(parent, "header_addons_roundinfo_popup")

	local killer = popup:MakeCheckBox({
		serverConvar = "ttt_roundinfo_popup_killer",
		label = "label_roundinfo_popup_killer"
	})

	popup:MakeSlider({
		serverConvar = "ttt_roundinfo_popup_killer_time",
		label = "label_roundinfo_popup_killer_time",
		min = 1,
		max = 100,
		decimal = 0,
		master = killer,
	})
end
