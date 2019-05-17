print("---------------------------------------------------- convars ---------------------------------------------------------")

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
end

if CLIENT then
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
end