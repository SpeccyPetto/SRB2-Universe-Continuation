addHook("PreThinkFrame",function()
	if universe -- If a universe gametype..
		for player in players.iterate
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