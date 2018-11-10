if SERVER then
	AddCSLuaFile()

	util.AddNetworkString("tttRsTellPre")
	util.AddNetworkString("tttRsTellPost")
	util.AddNetworkString("tttRsDeathNotify")
else
	hook.Add("Initialize", "TTTInitRS", function()
		LANG.AddToLanguage("English", "ttt_rs_preText", "0%There are %1%{traits} traitors%0%, %2%{innos} innocents%0% and %3%{specs} spectators%0% this round.")
		LANG.AddToLanguage("English", "ttt_rs_postText", "The role distribution this round:")
		LANG.AddToLanguage("English", "ttt_rs_killText", "0%You were killed by %1%{killer}%0%. Role: %2%{role}%0%.")
		LANG.AddToLanguage("English", "ttt_rs_suicideText", "0%You were killed by someone called yourself...")
		LANG.AddToLanguage("English", "ttt_rs_worldKillText", "0%You were killed by the world.")

		LANG.AddToLanguage("Deutsch", "ttt_rs_preText", "0%Es gibt %1%{traits} Verräter%0%, %2%{innos} Unschuldige%0% und %3%{specs} Zuschauer%0% diese Runde.")
		LANG.AddToLanguage("Deutsch", "ttt_rs_postText", "Die Rollenverteilung diese Runde:")
		LANG.AddToLanguage("Deutsch", "ttt_rs_killText", "0%Du wurdest von %1%{killer}%0% getötet. Rolle: %2%{role}%0%.")
		LANG.AddToLanguage("Deutsch", "ttt_rs_suicideText", "0%Du hast dich selbst getötet!")
		LANG.AddToLanguage("Deutsch", "ttt_rs_worldKillText", "0%Du wurdest von der Welt getötet.")
	end)

	local defcolor = Color(255, 255, 255, 255)
	local namecolor = Color(255, 255, 0, 255)

	net.Receive("tttRsTellPre", function(len)
		local PT = LANG.GetParamTranslation
		local roles = net.ReadTable()
		local spectators = net.ReadUInt(9)

		local txt = PT("ttt_rs_preText", {traits = roles[ROLE_TRAITOR], innos = roles[ROLE_INNOCENT], specs = spectators})
		local arr = string.Explode("%", txt)

		for k, v in ipairs(arr) do
			if v == "0" then
				arr[k] = defcolor
			elseif v == "1" then
				arr[k] = TTT2 and TRAITOR.color or not TTT2 and Color(180, 50, 40, 255)
			elseif v == "2" then
				arr[k] = TTT2 and INNOCENT.color or not TTT2 and Color(55, 170, 50, 255)
			elseif v == "3" then
				arr[k] = team.GetColor(TEAM_SPEC)
			end
		end

		chat.AddText(unpack(arr)) -- convert table to list of vars
	end)

	net.Receive("tttRsDeathNotify", function(len)
		local T = LANG.GetTranslation
		local PT = LANG.GetParamTranslation

		local rolecolor = defcolor
		local txt = ""

		local killerType = net.ReadUInt(4)

		if killerType == 1 then
			local role = net.ReadUInt(ROLE_BITS)
			local killer = net.ReadEntity()

			local rolename = "unknown"

			if not ROLES then
				if role == ROLE_INNOCENT then
					rolename = T("innocent")
					rolecolor = TTT2 and INNOCENT.color or not TTT2 and Color(55, 170, 50, 255)
				elseif role == ROLE_TRAITOR then
					rolename = T("traitor")
					rolecolor = TTT2 and TRAITOR.color or not TTT2 and Color(180, 50, 40, 255)
				elseif role == ROLE_DETECTIVE then
					rolename = T("detective")
					rolecolor = TTT2 and DETECTIVE.color or not TTT2 and Color(50, 60, 180, 255)
				end
			else
				rolename = T(GetRoleByIndex(role).name)
				rolecolor = GetRoleByIndex(role).color
			end

			txt = PT("ttt_rs_killText", {killer = killer:Nick(), role = rolename})
		elseif killerType == 2 then
			txt = T("ttt_rs_suicideText")
		elseif killerType == 3 then
			txt = T("ttt_rs_worldKillText")
		end

		local arr = string.Explode("%", txt)

		for k, v in ipairs(arr) do
			if v == "0" then
				arr[k] = defcolor
			elseif v == "1" then
				arr[k] = namecolor
			elseif v == "2" then
				arr[k] = rolecolor
			end
		end

		chat.AddText(unpack(arr))
	end)

	net.Receive("tttRsTellPost", function(len)
		local T = LANG.GetTranslation

		local rolesnames = net.ReadTable()
		local rolecolor = defcolor

		local txt = T("ttt_rs_postText")

		chat.AddText(defcolor, txt)

		for k, v in pairs(rolesnames) do
			if v then
				for _, w in ipairs do
					w = "%1%" .. w .. "%0%"
				end

				if not TTT2 then
					if k == ROLE_INNOCENT then
						txt = ("2%" .. T("innocent") .. "%0%: " .. v)
						rolecolor = TTT2 and INNOCENT.color or not TTT2 and Color(55, 170, 50, 255)
					elseif k == ROLE_TRAITOR then
						txt = ("2%" .. T("traitor") .. "%0%: " .. v)
						rolecolor = TTT2 and TRAITOR.color or not TTT2 and Color(180, 50, 40, 255)
					elseif k == ROLE_DETECTIVE then
						txt = ("2%" .. T("detective") .. "%0%: " .. v)
						rolecolor = TTT2 and DETECTIVE.color or not TTT2 and Color(50, 60, 180, 255)
					end
				else
					local rd = GetRoleByIndex(k)

					txt = ("2%" .. T(rd.name) .. "%0%: " .. v)
				end
			end

			local arr = string.Explode("%", txt)

			for k2, v2 in ipairs(arr) do
				if v2 == "0" then
					arr[k2] = defcolor
				elseif v2 == "1" then
					arr[k2] = namecolor
				elseif v2 == "2" then
					arr[k2] = rolecolor
				end
			end

			chat.AddText(unpack(arr))
		end
	end)
end
