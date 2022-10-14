-- Player related functions

SU.ResetPlayer = function(p)
	P_ResetPlayer(p)
	p.suatk = 0
	p.dashspeed = 0
end

SU.PlayerDeath = function(p)
	if (netgame or splitscreen) then return end
	G_SetCustomExitVars(SUHUBMAP, 1)
	G_ExitLevel()
end

SU.PlayerRebirth = function(p)
	if (gamemap ~= SUHUBMAP) then return end
	if (p.suhp <= 0) then
		P_TeleportMove(p.mo, 256*FRACUNIT, 160*FRACUNIT, 520*FRACUNIT)
		p.suhp = p.sumaxhp
		p.mo.angle = ANGLE_180
		p.drawangle = p.mo.angle
		S_ChangeMusic("MEDI", true, p)
	else
		if p.telepiped then
			P_TeleportMove(p.mo, 2176*FRACUNIT, 640*FRACUNIT, 512*FRACUNIT)
			p.mo.angle = ANGLE_270
			p.drawangle = p.mo.angle
			p.telepiped = 0
		end
	end
end

SU.InitPlayer = function(player)
	player.sulevel = 0
	player.suexp = 0

	player.sumaxhp = 1
	player.sumaxtp = 1

	player.suhp = 0
	player.sutp = 0
	player.sumoney = 0
	player.suitems = {} --[NUMSUITEMS]
	player.supipe = 0
	player.supipemenu = false
	player.supipemenuchoices = {}
	player.mapsvisited = {1}
	player.telepiped = false

	player.equipweapon = nil
	player.equipbarrier = nil
	player.equiparmor = nil
	player.equipslot = {nil, nil, nil, nil} --[4]
	--player.equipmag = nil
	
	player.suatk = 0 -- Attack time
	--player.dashspeed = 0

	player.normalspeed = $ / 2
	player.runspeed = $ / 2
	player.actionspd = $ / 2
	player.mindash = $ / 2
	player.maxdash = $ / 2
	--player.thrustfactor = $ / 2
	--player.accelstart = ($*2)/3
	--player.acceleration = ($*2)/3
	player.jumpfactor = (2*($)/ 3)
	player.charflags = $|SF_NOJUMPSPIN|SF_NOJUMPDAMAGE
	player.charability = CA_NONE
	player.charability2 = CA2_NONE
end

SU.LevelUp = function(player, amount)
	if not universe
		return
	end

	player.suexp = $ + amount
	while(player.sulevel < 200
		and player.suexp >= (600*player.sulevel))
		
		player.suexp = $ - 600*player.sulevel
		player.sulevel = $ + 1

		if (player == consoleplayer)
			CONS_Printf(player, "* Level up! New Level "..player.sulevel)
		else
			CONS_Printf(player, "* Level up! "..player.name.." is now level "..player.sulevel)
		end
		
		S_ChangeMusic("sulvl", false)
		
		for p in players.iterate
			if not p.spectator
				p.powers[pw_extralife] = 3*TICRATE
			end
		end

		player.sumaxhp = $ + P_RandomRange(3,8)
		player.sumaxtp = $ + P_RandomRange(3,8)
		player.suhp =  player.sumaxhp
		player.sutp = player.sumaxtp
	end
end

SU.GameplayStuff = function(player)
	if not universe
		return
	end

	///////////////////////
	// SU BOT MANAGEMENT //
	///////////////////////
	// Bots always have their owner's stats and items and whatnot P
	// Well, actually, they don't carry items or money, but they still have the same stuff equipped...
	if (player.bot and gametype == GT_COOP)
		player.sulevel = consoleplayer.sulevel
		player.sumaxhp = consoleplayer.sumaxhp
		player.sumaxtp = consoleplayer.sumaxtp
		player.suexp = 0
		player.sumoney = 0

		player.equipweapon = consoleplayer.equipweapon
		player.equipbarrier = consoleplayer.equipbarrier
		player.equiparmor = consoleplayer.equiparmor
		--player.equipmag = players[#consoleplayer].equipmag
		for i = 1, 4 do
			player.equipslot[i] = consoleplayer.equipslot[i]
		end
		return
	end
	
	/////////////////////////
	// SU LEVEL MANAGEMENT //
	/////////////////////////

	// Just started? Lets hook you up with a n00b pack!
	if (player.sulevel < 1)
		player.sulevel = 1
		player.suexp = 0

		// Random HP from 30 to 100, but only even tens.
		player.sumaxhp = P_RandomRange(3,10)*10

		// TP is the inverse of HP + 30, so having 30 HP gives you 100 TP and vice versa.
		player.sumaxtp = 130 - player.sumaxhp

		player.suhp = player.sumaxhp
		player.sutp = player.sumaxtp

		player.suitems[itm_saber] = 1
		player.suitems[itm_frame] = 1
		//player.suitems[itm_mag] = 1
		player.equipweapon = itm_saber
		player.equiparmor = itm_frame
		//player.equipmag = itm_mag
	end

	if (gamemap ~= SUHUBMAP) or (gamemap ~= SULOBBYMAP) then 
		if player.telepiped then
			if (player.telepiped == 1) and leveltime < 2 then
				for mobj in mobjs.iterate() do
					if (mobj.type == MT_ENDTELEPORT) then
						P_TeleportMove(player.mo, mobj.x, mobj.y, mobj.z)
						player.telepiped = 0
					end
				end
			end
		end
	end

	player.exiting = 0 -- Always have it be 0, you shouldn't be exiting from anything BUT telepipes.

	--if (leveltime&1)
	--	player.suhp = $ - 1
	--	player.sutp = $ - 1
	--end

	// Exceeding the ABSOLUTE MAXIMUM hp or tp? Set it to the absolute max, then...
	if (player.sulevel > 200)
		player.sulevel = 200
	end
	if (player.sumaxhp > 9999)
		player.sumaxhp = 9999
	end
	if (player.sumaxtp > 9999)
		player.sumaxtp = 9999
	end

	// Exceeding your level's max hp or tp? Set it to the current max, then...
	if (player.suhp > player.sumaxhp)
		player.suhp = player.sumaxhp
	elseif (player.suhp < 0)
		player.suhp = 0
	end
	if (player.sutp > player.sumaxtp)
		player.sutp = player.sumaxtp
	elseif player.sutp < 0
		player.sutp = 0
	end

	// Some sparkle goodies
	if player.powers[pw_extralife] then
		if player.mo and player.mo.valid then
			if not (leveltime % 3) then
				local mo = player.mo
				local r = (mobjinfo[mo.type].radius*3/2)>>FRACBITS
				local sparkle = P_SpawnMobj(mo.x + (P_RandomRange(r, -r)<<FRACBITS),
											mo.y + (P_RandomRange(r, -r)<<FRACBITS),
											mo.z + (P_RandomKey(mobjinfo[mo.type].height>>FRACBITS)<<FRACBITS),
											MT_NIGHTSPARKLE)
				if (mo.eflags & MFE_VERTICALFLIP)
					sparkle.eflags = $ | MFE_VERTICALFLIP
				end
				P_SetObjectMomZ(sparkle, FRACUNIT, false)
				P_SetMobjStateNF(sparkle, S_NIGHTSPARKLE2)
			end
		end
	end


	//////////////////////
	// SWORD MANAGEMENT //
	//////////////////////
	// While you have your sword out, dash around swinging it like a madman!
	if (player.suatk > 0)
		// Fly around, whee!!
		P_InstaThrust(player.mo, player.mo.angle, 40*FRACUNIT)
		--player.rmomx = player.mo.momx
		--player.rmomy = player.mo.momy
		if (player.mo.momz < 0)
			player.mo.momz = 0
		end
		
		// Hrm? Not running for some reason? No problem, just start now!
		if not (player.panim & PA_RUN)
			player.mo.state = S_PLAY_RUN
			player.panim = PA_RUN
		end
	end

	-- Didn't hit anything? Oh well...
	if (player.suatk == 1)
		if (player.mo.z > player.mo.floorz) -- In the air? Fall!
			player.mo.state = S_PLAY_FALL
			player.panim = PA_FALL
			P_InstaThrust(player.mo, player.mo.angle, player.normalspeed*FRACUNIT)
		elseif player.dashspeed
			-- Got dashspeed? Ie. a 1 hit weapon? 
			-- Wouldn't want to go backwards into any enemys you just hit!
			P_InstaThrust(player.mo, player.mo.angle, player.normalspeed*FRACUNIT)
		else
			P_InstaThrust(player.mo, player.mo.angle - ANGLE_180, 10*FRACUNIT)
		end


		if (player.mo.z <= player.mo.floorz) -- Animate properly!
			player.mo.state = S_PLAY_WALK
			player.panim = PA_WALK
		end
		player.powers[pw_flashing] = TICRATE/2 // Just in case you were only a liiiiittle too far away...
		player.weapondelay = TICRATE // And no using it lots of times at once, mister!
		player.dashspeed = 0 // Reset the dashspeed thingy... Just in case, I guess.
		player.pflags = $ & ~(PF_SPINNING|PF_JUMPED) 
	end

	// Decrease each tic.
	if (player.suatk > 0)
		player.suatk = $ - 1
	end

	/////////////////////////
	// TELEPIPE MANAGEMENT //
	/////////////////////////

	if not player.supipemenu then
		player.supipe = 0 -- Set this to 0 every tic if not in a telepipe menu-
		player.supipemenucur = 1
	end

	if (player.supipemenu) then
		player.supipemenuchoices = {}

		if player.supipe == 1 then
			table.insert(player.supipemenuchoices, {})

			local value = gamemap-1
			if value < 1 then value = SUHUBMAP end
			if mapheaderinfo[value].lvlttl ~= mapheaderinfo[gamemap].lvlttl then value = SUHUBMAP end
			player.supipemenuchoices[#player.supipemenuchoices].value = value

			local name = mapheaderinfo[value].lvlttl
			if not (mapheaderinfo[value].levelflags & LF_NOZONE) then name = $ .. " Zone " end
			if mapheaderinfo[value].actnum then name = $ .. " " .. tostring(mapheaderinfo[value].actnum) end
			player.supipemenuchoices[#player.supipemenuchoices].name = name
			player.telepiped = 1
		elseif player.supipe == 2 then
			table.insert(player.supipemenuchoices, {})

			local value = gamemap+1
			if value > 1035 then value = SUHUBMAP end
			if mapheaderinfo[value].lvlttl ~= mapheaderinfo[gamemap].lvlttl then value = SUHUBMAP end
			player.supipemenuchoices[#player.supipemenuchoices].value = value

			local name = mapheaderinfo[value].lvlttl
			if not (mapheaderinfo[value].levelflags & LF_NOZONE) then name = $ .. " Zone " end
			if mapheaderinfo[value].actnum then name = $ .. " " .. tostring(mapheaderinfo[value].actnum) end
			player.supipemenuchoices[#player.supipemenuchoices].name = name
			player.telepiped = 2
		elseif player.supipe == 3 then
			table.insert(player.supipemenuchoices, {})

			local value = SUHUBMAP
			if (gamemap == SUHUBMAP) then value = SULOBBYMAP end
			player.supipemenuchoices[#player.supipemenuchoices].value = value

			local name = mapheaderinfo[value].lvlttl
			if not (mapheaderinfo[value].levelflags & LF_NOZONE) then name = $ .. " Zone " end
			if mapheaderinfo[value].actnum then name = $ .. " " .. tostring(mapheaderinfo[value].actnum) end
			player.supipemenuchoices[#player.supipemenuchoices].name = name
		elseif player.supipe == 4 then
			for i=1, player.mapsvisited do
				if (player.mapsvisited[i] == SUHUBMAP) or (player.mapsvisited[i] == SULOBBYMAP) then continue end
				table.insert(player.supipemenuchoices, {})

				local value = player.mapsvisited[i]
				player.supipemenuchoices[#player.supipemenuchoices].value = value

				local name = mapheaderinfo[value].lvlttl
				if not (mapheaderinfo[value].levelflags & LF_NOZONE) then name = $ .. " Zone" end
				if mapheaderinfo[value].actnum then name = $ .. " " .. tostring(mapheaderinfo[value].actnum) end
				player.supipemenuchoices[#player.supipemenuchoices].name = name
			end
		end

		player.pflags = $|PF_FULLSTASIS
		player.powers[pw_flashing] = TICRATE

		if (player.cmd.buttons & BT_JUMP) then
			if not (netgame or splitscreen) then 
				player.supipemenu = false
				G_SetCustomExitVars(player.supipemenuchoices[player.supipemenucur].value, 1) 
				G_ExitLevel() 
			end
		end
	end
end

SU.doJump = function(player)
	-- No jumping around in lobby maps
	if (gamemap == SULOBBYMAP) or (gamemap == SUHUBMAP) then return true end

	if player and player.valid
	and player.mo and player.mo.valid
	and not (player.pflags & PF_JUMPED)
	and not (player.pflags & PF_JUMPDOWN)
	and P_IsObjectOnGround(player.mo) then
		P_SetObjectMomZ(player.mo, 5*FRACUNIT/4, true)
		return false
	end
end 