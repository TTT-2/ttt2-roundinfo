CreateConVar('ttt_roleinfo_pre_announce_distribution', 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar('ttt_roleinfo_announce_killer', 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar('ttt_roleinfo_popup_killer', 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar('ttt_roleinfo_popup_killer_time', 10, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar('ttt_roleinfo_post_announce_distribution', 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})

hook.Add('TTTUlxInitCustomCVar', 'TTTRolesetupInitRWCVar', function(name)
	ULib.replicatedWritableCvar('ttt_roleinfo_pre_announce_distribution', 'rep_ttt_roleinfo_pre_announce_distribution', GetConVar('ttt_roleinfo_pre_announce_distribution'):GetInt(), true, false, name)
	ULib.replicatedWritableCvar('ttt_roleinfo_announce_killer', 'rep_ttt_roleinfo_announce_killer', GetConVar('ttt_roleinfo_announce_killer'):GetInt(), true, false, name)
	ULib.replicatedWritableCvar('ttt_roleinfo_popup_killer', 'rep_ttt_roleinfo_popup_killer', GetConVar('ttt_roleinfo_popup_killer'):GetInt(), true, false, name)
	ULib.replicatedWritableCvar('ttt_roleinfo_popup_killer_time', 'rep_ttt_roleinfo_popup_killer_time', GetConVar('ttt_roleinfo_popup_killer_time'):GetInt(), true, false, name)
	ULib.replicatedWritableCvar('ttt_roleinfo_post_announce_distribution', 'rep_ttt_roleinfo_post_announce_distribution', GetConVar('ttt_roleinfo_post_announce_distribution'):GetInt(), true, false, name)
end)

if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	hook.Add('TTTUlxModifySettings', 'TTTRolesetupModifySettings', function(name)
		local tttrspnl = xlib.makelistlayout{w = 415, h = 318, parent = xgui.null}

		-- Chat Messages 
		local tttrsclp = vgui.Create('DCollapsibleCategory', tttrspnl)
		tttrsclp:SetSize(390, 80)
		tttrsclp:SetExpanded(1)
		tttrsclp:SetLabel('Chat Massages')

		local tttrslst = vgui.Create('DPanelList', tttrsclp)
		tttrslst:SetPos(5, 25)
		tttrslst:SetSize(390, 80)
		tttrslst:SetSpacing(5)

		local tttrsdh1 = xlib.makecheckbox{label = 'ttt_roleinfo_pre_announce_distribution (Def. 1)', repconvar = 'rep_ttt_roleinfo_pre_announce_distribution', parent = tttrslst}
		tttrslst:AddItem(tttrsdh1)

		local tttrsdh2 = xlib.makecheckbox{label = 'ttt_roleinfo_announce_killer (Def. 1)', repconvar = 'rep_ttt_roleinfo_announce_killer', parent = tttrslst}
		tttrslst:AddItem(tttrsdh2)

		local tttrsdh3 = xlib.makecheckbox{label = 'ttt_roleinfo_post_announce_distribution (Def. 1)', repconvar = 'rep_ttt_roleinfo_post_announce_distribution', parent = tttrslst}
		tttrslst:AddItem(tttrsdh3)

		-- Popup
		local tttrsclp2 = vgui.Create('DCollapsibleCategory', tttrspnl)
		tttrsclp2:SetSize(390, 60)
		tttrsclp2:SetExpanded(1)
		tttrsclp2:SetLabel('Popup')

		local tttrslst2 = vgui.Create('DPanelList', tttrsclp2)
		tttrslst2:SetPos(5, 25)
		tttrslst2:SetSize(390, 60)
		tttrslst2:SetSpacing(5)

		local tttrsdh4 = xlib.makecheckbox{label = 'ttt_roleinfo_popup_killer (Def. 1)', repconvar = 'rep_ttt_roleinfo_popup_killer', parent = tttrslst}
		tttrslst2:AddItem(tttrsdh4)

		local tttrsdh5 = xlib.makeslider{label = 'ttt_roleinfo_popup_killer_time (Def. 10)', repconvar = 'rep_ttt_roleinfo_popup_killer_time', min = 1, max = 100, decimal = 0, parent = tttrslst}
		tttrslst2:AddItem(tttrsdh5)

		xgui.hookEvent('onProcessModules', nil, tttrspnl.processModules)
		xgui.addSubModule('Roleinfo', tttrspnl, nil, name)
    end)
end