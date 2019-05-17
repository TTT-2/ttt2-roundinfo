if CLIENT then
	hook.Add('Initialize', 'TTTInitRS', function()
		-- ENGLISH
		LANG.AddToLanguage('English', 'ttt_rs_preText', '0%There are %1%{traits} traitors%0%, %2%{innos} innocents%0% and %3%{specs} spectators%0% this round.')
		LANG.AddToLanguage('English', 'ttt_rs_postText', 'The role distribution this round:')
		LANG.AddToLanguage('English', 'ttt_rs_killText', '0%You were killed by %1%{killer}%0%. Role: %2%{role}%0%. (type: {killtype})')
		LANG.AddToLanguage('English', 'ttt_rs_suicideText', '0%You were killed by someone called yourself... (type: {killtype})')
		LANG.AddToLanguage('English', 'ttt_rs_worldKillText', '0%You were killed by the world.')

		LANG.AddToLanguage('English', 'ttt_rs_killtype_unknown', 'unknown')
		LANG.AddToLanguage('English', 'ttt_rs_killtype_propkill', 'propkill')
		LANG.AddToLanguage('English', 'ttt_rs_killtype_falldamage', 'falldamage')
		LANG.AddToLanguage('English', 'ttt_rs_killtype_firedamage', 'firedamage')
		LANG.AddToLanguage('English', 'ttt_rs_killtype_explosion', 'explosion')
        LANG.AddToLanguage('English', 'ttt_rs_killtype_drowned', 'drowned')
        
        LANG.AddToLanguage('English', 'ttt_rs_you_were_killed', 'you were killed by')
        LANG.AddToLanguage('English', 'ttt_rs_killer_yourself', 'yourself')
        LANG.AddToLanguage('English', 'ttt_rs_killer_world', 'world')

		-- GERMAN
		LANG.AddToLanguage('Deutsch', 'ttt_rs_preText', '0%Es gibt %1%{traits} Verräter%0%, %2%{innos} Unschuldige%0% und %3%{specs} Zuschauer%0% diese Runde.')
		LANG.AddToLanguage('Deutsch', 'ttt_rs_postText', 'Die Rollenverteilung diese Runde:')
		LANG.AddToLanguage('Deutsch', 'ttt_rs_killText', '0%Du wurdest von %1%{killer}%0% getötet. Rolle: %2%{role}%0%. (Art: {killtype})')
		LANG.AddToLanguage('Deutsch', 'ttt_rs_suicideText', '0%Du hast dich selbst getötet! (Art: {killtype})')
		LANG.AddToLanguage('Deutsch', 'ttt_rs_worldKillText', '0%Du wurdest von der Welt getötet.')

		LANG.AddToLanguage('Deutsch', 'ttt_rs_killtype_unknown', 'unbekannt')
		LANG.AddToLanguage('Deutsch', 'ttt_rs_killtype_propkill', 'Propkill')
		LANG.AddToLanguage('Deutsch', 'ttt_rs_killtype_falldamage', 'Fallschaden')
		LANG.AddToLanguage('Deutsch', 'ttt_rs_killtype_firedamage', 'Feuerschaden')
		LANG.AddToLanguage('Deutsch', 'ttt_rs_killtype_explosion', 'Explosion')
        LANG.AddToLanguage('Deutsch', 'ttt_rs_killtype_drowned', 'ertrunken')
        
        LANG.AddToLanguage('Deutsch', 'ttt_rs_you_were_killed', 'du wurdest getötet von')
        LANG.AddToLanguage('Deutsch', 'ttt_rs_killer_yourself', 'du selbst')
        LANG.AddToLanguage('Deutsch', 'ttt_rs_killer_world', 'Welt')
	end)
end