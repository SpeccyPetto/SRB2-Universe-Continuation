addHook("PreThinkFrame",function()
	if universe -- If a universe gametype..
		for player in players.iterate
			local mapvisited = false
			if player.mapsvisited == nil then player.mapsvisited = {1} end
			for i=1, #player.mapsvisited do
				if player.mapsvisited[i] == gamemap then mapvisited = true end
			end
			if not mapvisited then
				table.insert(player.mapsvisited, gamemap, gamemap)
			end
			-- Initialize the players
			if player.suinitialized == nil then
				--player.buttonhistory = player.cmd.buttons
				SU.InitPlayer(player)
				player.suinitialized = true
			end
		end
	end
end)

addHook("PlayerThink", function(player)
	if universe
		SU.GameplayStuff(player)
		
		if (player.cmd.buttons & BT_ATTACK)
			SU.FiringCode(player)
		end
	end
end)

addHook("JumpSpecial", function(player)
	if universe
		return SU.doJump(player)
	end
end)

addHook("PlayerSpawn", SU.PlayerRebirth)
addHook("MobjDeath", SU.PlayerDeath, MT_PLAYER)