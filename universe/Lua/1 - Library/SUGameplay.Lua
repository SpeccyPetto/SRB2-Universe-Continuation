-- Gameplay functions
-- Enemy handlers

SU.EnemyDropStuff = function(target)
	local mo

	if (target.flags & MF_ENEMY)
		mo = P_SpawnMobj(target.x, target.y,
				P_FloorzAtPos(target.x, target.y, target.z, target.height),
				MT_SUDROP)
		mo.fuse = TICRATE/3 -- Countdown the fuse so we know what to spawn below
		return true
	elseif (target.flags & MF_BOSS)
		mo = P_SpawnMobj(target.x, target.y,
				P_FloorzAtPos(target.x, target.y, target.z, target.height),
				MT_SUBOSSDROP)
		mo.fuse = TICRATE/3 -- Countdown the fuse so we know what to spawn below
		return true
	else
		return false
	end
end

// Trigger some functions for when the Mobj's fuse runs out.
SU.Fuse = function(mobj)
	local prandom
	local mo
	local lastangle
	
	if ((mobj.type == MT_SUDROP) or (mobj.type == MT_SUBOSSDROP))
		prandom = P_RandomRange(1, 100) -- 1 - 100
		if ((mobj.type == MT_SUBOSSDROP and prandom < 80) // 80% chance of item if a boss.
			or prandom < 30) // 30% chance of item if not a boss.
			mo = P_SpawnMobj(mobj.x, mobj.y, mobj.z + 24*FRACUNIT, MT_SUMONEY)
			mo.health = P_RandomRange(1, 100)
			mo.color = SKINCOLOR_GOLD // Gold money
		else
			// Lower rarity = more common
			prandom = 0
			repeat
				mobj.health = P_RandomRange(itm_invalid+1, #suitemtype_t) -- Pick an item. Any item.
				prandom = $ + 1

				if (prandom > 100)
					break // Breakout code
				end
			until ((suitems[mobj.health].rarity == 0) or (P_RandomRange(1, 100) > suitems[mobj.health].rarity))
			
			mo = P_SpawnMobj(mobj.x, mobj.y, mobj.floorz, MT_SUITEM)
			mo.scale = 2*FRACUNIT
			mo.health = mobj.health
			
			if (suitems[mo.health].sutype & SUT_SPECIAL) or (suitems[mo.health].rarity < 10)
				mo.color = SKINCOLOR_RED // Red rare items!
			elseif (suitems[mo.health].sutype & SUT_WEAPON)
				mo.color = SKINCOLOR_BLUE // Blue weapons
			elseif (suitems[mo.health].sutype & SUT_BARRIER)
					or (suitems[mo.health].sutype & SUT_FRAME)
					or (suitems[mo.health].sutype & SUT_SLOT)
				mo.color = SKINCOLOR_ORANGE // Orange barriers and armor
			else
				mo.color = SKINCOLOR_GREEN // Green other items
			end
		end
		P_SetMobjStateNF(mobj,S_NULL)
		return true

	// Teleporter
	elseif (mobj.type == MT_STARTTELEPORT) 
	or (mobj.type == MT_ENDTELEPORT)
	or (mobj.type == MT_TELEPIPE)
		// Create teleport sparkles to mark your location...
		if mobj.lastlook
			mo = P_SpawnMobj(mobj.x, mobj.y, mobj.z, MT_TELESPARK1)
			lastangle = mobj.movedir
		else
			mo = P_SpawnMobj(mobj.x, mobj.y, mobj.z, MT_TELESPARK2)
			lastangle = mobj.threshold
		end

		mo.target = mobj // Make it circle you
		mo.fuse = TICRATE + P_RandomKey(2)*TICRATE // It will randomly disappear after a second. Or two. Or three.
		mobj.fuse = (2*TICRATE)/12 // Make about 12 sparkles at a time. (6 of each type)
		
		// Make it start at the last point in the circle plus an angle...
		mo.angle = lastangle + ANG60 + (P_RandomKey(2)*ANG30)
		
		if (mobj.type == MT_STARTTELEPORT)
			mo.color = SKINCOLOR_BLUE
		elseif (mobj.type == MT_ENDTELEPORT)
			mo.color = SKINCOLOR_RED
		else
			mo.color = mobj.friction
		end
		
		// Set the last angle for this type of sparkle to the new angle.
		if (mobj.lastlook)
			mobj.movedir = mo.angle
		else
			mobj.threshold = mo.angle
		end
		
		mobj.lastlook = !mobj.lastlook // Toggle what you'll make next.
		return true
	else
		return false
	end
end

SU.DoSpawn = function(mobj)
	if universe
		if mobj and mobj.valid
			if (mobj.flags & MF_ENEMY)
				mobj.health = $ * 15
			elseif (mobj.flags & MF_BOSS)
				mobj.health = $ * 8
			end
		end
	end
end

SU.MobjProg = function(mobj)
	if mobj and mobj.valid
		local gravityadd = -gravity/4
		
		if ((mobj.type == MT_STARTTELEPORT) or (mobj.type == MT_ENDTELEPORT))
			if (mobj.fuse == 0)
				mobj.fuse = TICRATE/4
			end
			return false -- Proceed with normal fuse behavior here.
		
		elseif ((mobj.type == MT_TELESPARK1) or (mobj.type == MT_TELESPARK2))
			if not mobj.target
				return true
			end
			
			// The TELESPARK mobj angle is already "fine" because it's not used for anything else.
			// Unless someone makes an edit of the sprites that gives them an actual angle, of course.
			// But that'd probably just look cool. :O
			
			// 4 seconds, go full circle
			mobj.angle = ( $ + ((5*ANG1)/2) )
			
			if (mobj.z < mobj.target.z)
				mobj.z = mobj.target.z
			end
			
			P_TryMove(mobj,
							mobj.target.x + FixedMul(cos(mobj.angle), mobj.target.radius),
							mobj.target.y + FixedMul(sin(mobj.angle), mobj.target.radius)
							)

			mobj.momx = 0
			mobj.momy = 0
			
			if (mobj.type == MT_TELESPARK1)
				// Make this sparkle bounce!
				--P_SetObjectMomZ(mobj, FRACUNIT, true)
				if ((mobj.z - 16*FRACUNIT) <= mobj.target.z)
					P_SetObjectMomZ(mobj, FRACUNIT + P_RandomKey(5)*FRACUNIT, false)
				elseif (mobj.momz > -3*FRACUNIT)
					P_SetObjectMomZ(mobj, gravityadd, true)
				end
			end
			
			return false -- It's OK to proceed with normal behavior here.
			
		elseif (mobj.type == MT_SUDROP) or (mobj.type == MT_SUBOSSDROP)
			return false
		elseif (mobj.type == MT_SUMONEY)
		or (mobj.type == MT_SUITEM)
			// Gently rotate and stay on the floor
			mobj.angle = $ - ANG10
			if (mobj.z > mobj.floorz)
				mobj.z = mobj.floorz
			end
			return true
		else
			return false
		end
	else
		return false
	end
end

SU.SpecialItems = function(special, toucher)

	local player = toucher.player
	local dummymo

	/*if special.type == MT_PAYMACHINE // Pay Machine Exchange rings for items!
		if (!player)
			return true

		if (toucher.subsector.sector == special.subsector.sector
			or !toucher.player.mfjumped)
				return true

		if (!universe)
		
			if (!(toucher.player.health >= special.health))
				return true

			// Mark the player as 'pull into the capsule'
			toucher.player.capsule = special
			toucher.player.capsule.reactiontime = 1
			return true
		end
		if (!(toucher.player.sumoney >= (unsigned)special.health))
			return true

		// Mark the player as 'pull into the capsule'
		toucher.player.capsule = special
		toucher.player.capsule.reactiontime = 1
		return true*/

	if (special.type == MT_SUMONEY)
		if not player
			return true
		elseif (player and player.powers[pw_flashing]) or (player.bot and gametype == GT_COOP)
			return true
		end
			
		dummymo = P_SpawnMobj(special.x,special.y,special.z, MT_SPARK)
		if (mariomode)
			dummymo.momz = special.momz
		end

		player.sumoney = $ + special.health

		if (player == consoleplayer)
			CONS_Printf(player, "* Collected "+special.health+" Meseta!")
		end
		return false

	elseif (special.type == MT_SUITEM)
		if not player
			return true
		elseif (player and player.powers[pw_flashing]) or (player.bot and gametype == GT_COOP)
			return true
		end

		special.health = $ - 1 -- Was set up by 1 since items with a health of 0 are un-collectable.

		dummymo = P_SpawnMobj(special.x,special.y,special.z, MT_SPARK)
		if (mariomode)
			dummymo.momz = special.momz
		end

		-- Weird "nil" check.
		if player.suitems[special.health]
			player.suitems[special.health] = $ + 1
		else
			player.suitems[special.health] = 1
		end
		
		if (player == consoleplayer and suitems[special.health].name)
			CONS_Printf(player, "* Collected a "+suitems[special.health].name)
		end
		return false
	elseif (special.type == MT_STARTTELEPORT) and (player.cmd.buttons & BT_TOSSFLAG)
		--player.cmd.buttons = $ & ~(BT_TOSSFLAG)
		--SU_Teleport2LastMenu
		return true
	elseif (special.type == MT_ENDTELEPORT) and (player.cmd.buttons & BT_TOSSFLAG)
		--player.cmd.buttons = $ & ~(BT_TOSSFLAG)
		--SU_Teleport2NextMenu
		return true
	elseif (special.type == MT_TELEPIPE) and (player.cmd.buttons & BT_TOSSFLAG)
		--player.cmd.buttons = $ & ~(BT_TOSSFLAG)
		--SU_Teleport2HUBMenu
		return true
	end
end

SU.TouchSpecial = function(special, toucher)
	if toucher and toucher.valid
		and special and special.valid
		and toucher.player and toucher.player.valid and not toucher.player.spectator
		local player = toucher.player
		
		if (special.flags & (MF_ENEMY|MF_BOSS)) and not (special.flags & MF_MISSILE)
			if player.suatk
				if (toucher.eflags & MFE_VERTICALFLIP) and (toucher.momz > 0)
					P_SetObjectMomZ(toucher, (toucher.momz), false)
				elseif (toucher.momz < 0)
					P_SetObjectMomZ(toucher, -(toucher.momz), false)
				end

				P_DamageMobj(special, toucher, toucher, 1)
				return true
			end
		elseif (special.type == MT_RING)
			if player.suhp and (player.suhp > 0) and (player.suhp < player.sumaxhp)
				player.suhp = $ + 1 -- Increase by a marginal amount
			end
			return false -- Normal Behavior
		elseif (special.type == MT_SUMONEY) or (special.type == MT_SUITEM)
			if SU.SpecialItems(special, toucher)
				return true
			else
				return false
			end
		end
	else
		return false
	end
end

SU.CalcDamage = function(target, source, damage)
	if (damage > 0)
		// Original damage setting for players
		if (source.player)
			if (source.player.equipweapon
			--and source.player.equipweapon < NUMSUITEMS
			and suitems[source.player.equipweapon].damage > 0)
				damage = suitems[source.player.equipweapon].damage + source.player.sulevel + 1
			else
				damage = source.player.sulevel + 1
			end
		// Original damage setting for enemys and other crap
		else
			--print("Source info:",mobjinfo[source.type].sumobjinfo, mobjinfo[source.type].sumobjinfo.damage) -- Visual for "Does it exist?"
			
			if (mobjinfo[source.type].sumobjinfo and mobjinfo[source.type].sumobjinfo.damage)
				damage = mobjinfo[source.type].sumobjinfo.damage
			elseif (source.info.spawnhealth)
				damage = source.info.spawnhealth*3
			else
				return false
			end
		end
	end

	// Damage randomness and armor.
	if (target.player)
		// Add randomness to the damage...
		damage = $ + (3+P_RandomRange(1,8))

		// Subtract damage for player level...
		damage = $ - target.player.sulevel*(1+(P_RandomRange(1,2)))

		// Subtract damage for barrier...
		if (target.player.equipbarrier)
			damage = $ - suitems[target.player.equipbarrier].damage
		end

		// Subtract damage for armor...
		if (target.player.equiparmor)
			damage = $ - suitems[target.player.equiparmor].damage
		end
	else
		damage = $ + 5+(P_RandomRange(1,5))
		--print("Target info:", mobjinfo[target.type].sumobjinfo, mobjinfo[target.type].sumobjinfo.level) -- Visual for "Does it exist?"
		
		if (mobjinfo[target.type].sumobjinfo and mobjinfo[target.type].sumobjinfo.level)
			damage = $ - P_RandomRange(mobjinfo[target.type].sumobjinfo.level, mobjinfo[target.type].sumobjinfo.level+20)
		else
			damage = $ - P_RandomRange(1, 10)
		end
	end

	// Hehe, oops, subtracted too much damage!
	if (damage <= 0)
		damage = 1
	end

	return damage
end

-- Here's the biiiiig code
SU.DamageMobj = function(target, inflictor, source, damage)
	local ang
	local player

	-- TODO: -1 dmg is instakill (DMG_INSTAKILL)
	damage = SU.CalcDamage(target, source, damage)
	
	if (target.flags & MF_ENEMY)
	
		if (target.flags2 & MF2_FRET) // Invincible
			return false
		end

		if ((target.health - damage) > 0)
			if (inflictor)
				ang = R_PointToAngle2(inflictor.x, inflictor.y, target.x, target.y)
			else
				ang = R_PointToAngle2(source.x, source.y, target.x, target.y)
			end

			if (target.info.painsound) then S_StartSound(target, target.info.painsound) end
			
			target.state = target.info.painstate
			target.sprite = states[target.info.spawnstate].sprite
			target.tics = TICRATE
			target.flags2 = $|MF2_FRET
			
			P_SetObjectMomZ(target, FixedDiv(source.momz,27*FRACUNIT/20), true)
			if (target.momz < 5*FRACUNIT and target.momz >= 0)
				target.momz = 5*FRACUNIT
			elseif (target.momz > -5*FRACUNIT and target.momz < 0)
				target.momz = -5*FRACUNIT
			end

			P_InstaThrust(target, ang, target.momz)
			
			-- Subtract the Damage
			target.health = $ - damage
		else
			P_KillMobj(target, inflictor, source)
			/*if (target.info.deathsound) then S_StartSound(target, target.info.deathsound) end
			target.state = target.info.deathstate
			target.momx = 0
			target.momy = 0
			target.momz = 0*/
			if (source.player) -- Source is a player? Give experience.
				local exp = ((mobjinfo[target.type].sumobjinfo) and (mobjinfo[target.type].sumobjinfo.level)*(mobjinfo[target.type].sumobjinfo.damage*20)) 
							or 100
				SU.LevelUp(source.player, exp)
				CONS_Printf(source.player, "* Experience awarded: "+exp)
			end
		end

		if (source.player)
			if (source.player.pflags & PF_JUMPED)
				if (P_MobjFlip(source)*source.momz < 5*FRACUNIT)
					P_SetObjectMomZ(source, FixedMul(5*FRACUNIT,27*FRACUNIT/20), false)
				elseif (P_MobjFlip(source)*source.momz < 0)
					P_SetObjectMomZ(source, -(source.momz), false)
				end
			end
			if (source.player.suatk)
				ang = R_PointToAngle2(target.x, target.y, source.x, source.y)

				// If you have infinitive hits on your sword...
				if (source.player.dashspeed == 1)
					// Don't do anything to stop you yet. Instead just get the flashing from the hit.
					source.player.powers[pw_flashing] = TICRATE
				
				// If you have 2 hits using this sword...
				elseif (source.player.dashspeed == 2)
					// This is your first hit, so turn the attack into a single-hit now.
					source.player.dashspeed = 0
				else
					source.player.suatk = 0
					source.player.powers[pw_flashing] = TICRATE
					source.z = $ + 1
					if (source.eflags & MFE_UNDERWATER)
						P_SetObjectMomZ(source, FixedDiv(10511*FRACUNIT,2600*FRACUNIT), false)
					else
						P_SetObjectMomZ(source, FixedDiv(69*FRACUNIT,10*FRACUNIT), false)
					end
					P_InstaThrust(source, ang, 4*FRACUNIT)
					
					source.state = S_PLAY_FALL
					source.player.panim = PA_FALL -- Animate properly
				end
			end
		end
		return true
	elseif (target.flags & MF_BOSS)
		if ((target.health - damage) > 0)
			target.flags2 = $ | MF2_FRET

			if (source.player)
				if (source.player.suatk)
				
					ang = R_PointToAngle2(source.x, source.y, target.x, target.y)

					source.player.suatk = 0
					source.player.powers[pw_flashing] = TICRATE
					source.z = $ + 1
					if (source.eflags & MFE_UNDERWATER)
						P_SetObjectMomZ(source, FixedDiv(10511*FRACUNIT,2600*FRACUNIT), false)
					else
						P_SetObjectMomZ(source, FixedDiv(69*FRACUNIT,10*FRACUNIT), false)
					end
					P_InstaThrust(source, ang-ANGLE_180, 4*FRACUNIT)
					
					source.state = S_PLAY_FALL
					source.player.panim = PA_FALL -- Animate properly
				end
			end
		end
	elseif (target.player)
		player = target.player

		if (player and (player.exiting or player.powers[pw_flashing] or player.powers[pw_invulnerability]))
			return false
		end

		if (player) // Player is the target
			-- NIGHTS MODE NOT SUPPORTED YET BYE
			if (maptol & TOL_NIGHTS) then return false end

			if (inflictor and (inflictor.flags & MF_FIRE))
				if (player.powers[pw_shield] & SH_FLAMEAURA)
					return false // Invincible to fire objects
				end

				if (((gametype == GT_COOP) or (gametype == GT_RACE)) and source and source.player)
					return false // Don't get hurt by fire generated from friends.
				end
			end

			if (source and source.player) // Player hits another player
				if (source == target) // You can't kill yourself, idiot...
					return false
				else
					if not cv_friendlyfire.value and ((gametype == GT_COOP) or (gametype == GT_RACE))
						return false
					end

					if (((gametype == GT_MATCH) or (gametype == GT_TAG) or (gametype == GT_CTF))
						and not player.powers[pw_flashing] and not player.powers[pw_invulnerability])
						damage = -1 // Instant-death!
					end
				end
			end

			if (player.pflags & PF_GODMODE)
				return false
			elseif (damage == -1)
				P_RemoveShield(player)
				player.mo.momx = 0
				player.mo.momy = 0

				if not (player.powers[pw_underwater]) // Don't jump up when drowning
					P_SetObjectMomZ(player.mo, 18*FRACUNIT, false)
				else
					P_SetObjectMomZ(player.mo, FRACUNIT, true)
				end

				--P_ForceFeed(player, 40, 10, TICRATE, 40 + min(damage, 100)*2)

				if (source and source.type == MT_NULL and source.threshold == 42) // drowned
					S_StartSound(target, sfx_drown)
				else
					P_PlayDeathSound(target)
				end

				if (gametype == GT_CTF and (player.gotflag & MF_REDFLAG or player.gotflag & MF_BLUEFLAG))
					P_PlayerFlagBurst(player, false)
				end
				if (source and source.player)
					SU.LevelUp(source.player, 100)
				end
				
				P_KillMobj(player, inflictor, source)
				return true
			elseif (player.powers[pw_invulnerability] or player.powers[pw_flashing]
				or player.powers[pw_super]) // ignore bouncing & such in invulnerability
			
				if (inflictor and (inflictor.flags & MF_MISSILE)
					and (inflictor.flags2 & MF2_SUPERFIRE)
					and player.powers[pw_super])
				
					local fallbackspeed

					--P_ForceFeed(player, 40, 10, TICRATE, 40 + min(damage, 100)*2)
					damage = 0 // Don't take rings away
					player.mo.z = $ + 1

					if (player.mo.eflags & MF_UNDERWATER)
						player.mo.momz = FixedDiv(10511*FRACUNIT,2600*FRACUNIT)
					else
						player.mo.momz = FixedDiv(69*FRACUNIT,10*FRACUNIT)
					end

					ang = R_PointToAngle2(inflictor.x,	inflictor.y, target.x, target.y)

					// explosion and rail rings send you farther back, making it more difficult
					// to recover
					if (inflictor.flags2 & MF2_EXPLOSION)
						if (inflictor.flags2 & MF2_RAILRING)
							fallbackspeed = 24*FRACUNIT // 6x
						else
							fallbackspeed = 16*FRACUNIT // 4x
						end
					elseif (inflictor.flags2 & MF2_RAILRING)
						fallbackspeed = 12*FRACUNIT // 3x
					else
						fallbackspeed = 4*FRACUNIT // the usual amount of force
					end

					P_InstaThrust(target, ang, fallbackspeed)

					--P_SetPlayerMobjState(target, S_PLAY_SUPERHIT)
					player.mo.state = S_PLAY_PAIN
					player.panim = PA_PAIN --Animate properly
					//target.player.powers[pw_flashing] = flashingtics
					player.powers[pw_flashing] = TICRATE

					--player.mo.flags = (player.mo.flags & ~MF_TRANSLATION)
					--					| ((player.skincolor)<<MF_TRANSSHIFT)

					SU.ResetPlayer(player)
					return true
				else
					return false
				end
			elseif (player.powers[pw_shield])  // If Shield
				if (player.powers[pw_shield] & SH_ARMAGEDDON) // Give them what's coming to them!
					player.pflags = ($ | PF_USEDOWN)
				end
				
				P_RemoveShield(player) // Get rid of shield
				
				damage = 0 // Don't take rings away

				if (player.mo.eflags & MFE_UNDERWATER)
					P_SetObjectMomZ(player.mo, FixedDiv(10511*FRACUNIT,2600*FRACUNIT), false)
				else
					P_SetObjectMomZ(player.mo, FixedDiv(69*FRACUNIT,10*FRACUNIT), false)
				end

				if (inflictor == nil)
					P_InstaThrust(player.mo, player.mo.angle-ANGLE_180, 4*FRACUNIT)
				else
					local fallbackspeed

					ang = R_PointToAngle2(inflictor.x,	inflictor.y, target.x, target.y)

					// explosion and rail rings send you farther back, making it more difficult
					// to recover
					if (inflictor.flags2 & MF2_EXPLOSION)
						if (inflictor.flags2 & MF2_RAILRING)
							fallbackspeed = 24*FRACUNIT // 6x
						else
							fallbackspeed = 16*FRACUNIT // 4x
						end
					elseif (inflictor.flags2 & MF2_RAILRING)
						fallbackspeed = 12*FRACUNIT // 3x
					else
						fallbackspeed = 4*FRACUNIT // the usual amount of force
					end

					P_InstaThrust(target, ang, fallbackspeed)
				end

				player.mo.state = S_PLAY_PAIN
				player.panim = PA_PAIN
				//target.player.powers[pw_flashing] = flashingtics
				player.powers[pw_flashing] = TICRATE

				SU.ResetPlayer(player)

				if (source and (source.type == MT_SPIKE or source.type == MT_WALLSPIKE) and source.threshold == 43) // spikes
					S_StartSound(target, sfx_spkdth)
				else
					S_StartSound(target, sfx_shldls) // Ba-Dum! Shield loss.
				end

				if (gametype == GT_CTF and (player.gotflag & MF_REDFLAG or player.gotflag & MF_BLUEFLAG))
					P_PlayerFlagBurst(player, false)
				end
				if (source and source.player)
					SU.LevelUp(source.player, 50)
				end
				return true
			elseif (player.rings) // No shield but have rings.
				//damage = player.mo.health - 1
				player.powers[pw_shield] = $ & ~(SH_FIREFLOWER)

				if (player.mo.eflags & MFE_UNDERWATER)
					P_SetObjectMomZ(player.mo, FixedDiv(10511*FRACUNIT,2600*FRACUNIT), false)
				else
					P_SetObjectMomZ(player.mo, FixedDiv(69*FRACUNIT,10*FRACUNIT), false)
				end

				if (inflictor == nil)
					P_InstaThrust(player.mo, player.mo.angle-ANGLE_180, 4*FRACUNIT)
				else
					local fallbackspeed
					ang = R_PointToAngle2(inflictor.x,	inflictor.y, target.x, target.y)

					// explosion and rail rings send you farther back, making it more difficult
					// to recover
					if (inflictor.flags2 & MF2_EXPLOSION)
						if (inflictor.flags2 & MF2_RAILRING)
							fallbackspeed = 24*FRACUNIT // 6x
						else
							fallbackspeed = 16*FRACUNIT // 4x
						end
					elseif (inflictor.flags2 & MF2_RAILRING)
						fallbackspeed = 12*FRACUNIT // 3x
					else
						fallbackspeed = 4*FRACUNIT // the usual amount of force
					end

					P_InstaThrust(target, ang, fallbackspeed)
				end

				SU.ResetPlayer(player)

				if (source and (source.type == MT_NULL or source.type == MT_SPIKE) and source.threshold == 43) // spikes
					S_StartSound(target, sfx_spkdth)
				end

				// Ring loss sound plays despite hitting spikes
				S_StartSound (target, sfx_shldls) // Ba-Dum! Shield loss.
				//P_PlayRinglossSound(target) // Ringledingle!

				if (gametype == GT_CTF and ((player.gotflag & MF_REDFLAG) or (player.gotflag & MF_BLUEFLAG)) )
					P_PlayerFlagBurst(player, false)
				end
				if (source and source.player)
					SU.LevelUp(source.player, 50)
				end
			else // No shield, no rings, no invincibility.
				//damage = 1
				P_SetObjectMomZ(player.mo, 18*FRACUNIT, false)
				player.mo.momx = 0
				player.mo.momy = 0

				player.powers[pw_shield] = $ & ~(SH_FIREFLOWER)

				player.mo.state = S_PLAY_PAIN
				player.panim = PA_PAIN -- Animate properly

				SU.ResetPlayer(player)

				if (source and (source.type == MT_NULL or source.type == MT_SPIKE) and source.threshold == 43) // Spikes
					S_StartSound(target, sfx_spkdth)
				else
					P_PlayDeathSound(target)
				end

				if (gametype == GT_CTF and ((player.gotflag & MF_REDFLAG) or (player.gotflag & MF_BLUEFLAG)) )
					P_PlayerFlagBurst(player, false)
				end
				if (source and source.player)
					SU.LevelUp(source.player, 100)
				end
				
			end
		end

		// do the damage
		// player specific
		if (player)
			player.suhp = $ - damage // Subtract the Damage

			if (player.suhp < 0)
				player.suhp = 0
			end

			if (damage > 0 and player.suhp > 0) and not player.powers[pw_flashing]
				//target.player.powers[pw_flashing] = flashingtics
				player.powers[pw_flashing] = TICRATE
			end
			
			if (player.suhp <= 0)
				player.mo.state = S_PLAY_DEAD
				P_KillMobj(target, inflictor, source)
				return true
			else
				player.mo.state = S_PLAY_PAIN
				player.panim = PA_PAIN
				SU.ResetPlayer(player)
			end
		end

		return true -- Override default behavior
	end
end

SU.EnemyHotfix = function(mo)
	if universe then
		if mo and mo.valid then
			if (mo.flags & MF_ENEMY)
			and (mo.state == mo.info.painstate)
			and (mo.flags2 & MF2_FRET)
			and (mo.tics == 1) then
				mo.flags2 = $ & ~(MF2_FRET)
			end
		end
	end
end

SU.DoDeath = function(target, inflictor, source)
	if SU.EnemyDropStuff(target)
		return -- Drop stuff but don't override behavior
	end
end

SU.MapLoad = function(mapnum)
	if gamemap == SULOBBYMAP or gamemap == SUHUBMAP then return end
	for mthing in mapthings.iterate
		if (mthing.type == 1)
			-- Spawn the start teleporter behind player 1
			local x = mthing.x << FRACBITS
			local y = mthing.y << FRACBITS
			local ss = R_PointInSubsector(x, y)
			local z
			if (mthing.options >> 5)
				z = ss.sector.floorheight + ((mthing.options >> 5) << FRACBITS)
			else
				z = mthing.z << FRACBITS
			end
			
			local mo = P_SpawnMobj(x, y, z, MT_STARTTELEPORT)
			mo.spawnpoint = mthing
			
			local dist = 1024
			while (dist > 0)
				x = mo.x + P_ReturnThrustX(mo, mthing.angle*ANG1, -dist*FRACUNIT)
				y = mo.y + P_ReturnThrustY(mo, mthing.angle*ANG1, -dist*FRACUNIT)
				
				if (R_PointInSubsectorOrNil(x, y) != nil) -- Valid sector
				and (R_PointInSubsector(x - mo.radius, y - mo.radius).sector == R_PointInSubsector(mthing.x, mthing.y).sector)
				and (R_PointInSubsector(x + mo.radius, y + mo.radius).sector == R_PointInSubsector(mthing.x, mthing.y).sector)
					P_TeleportMove(mo, x, y, z)
					break
				else
					dist = $ - 1
				end
			end
			--print(dist)
			--print("Object spawned at:"+x/FRACUNIT+" "+y/FRACUNIT+" "+z/FRACUNIT)
		end
	end
end

SU.FiringCode = function(player)
	if (player.equipweapon
		and (suitems[player.equipweapon].sutype & SUT_WEAPON)
		and (gamemap ~= SULOBBYMAP)
		and (gamemap ~= SUHUBMAP)
		and not (player.pflags & PF_ATTACKDOWN)
		and not player.weapondelay
		and not player.suatk
		and not player.exiting
		and not (player.playerstate == PST_DEAD)
		and not (player.pflags & PF_THOKKED)
		and not player.powers[pw_flashing])
	
		local weapon = suitems[player.equipweapon].sutype
		if (weapon & SUT_SPECIAL)
			// Special-use weapons.
			--SU.UseSpecialWeapon(player, player.equipweapon)
		elseif ((weapon & SUW_HANDGUN)
			or (weapon & SUW_RIFLE)
			or (weapon & SUW_PUNCH))
		
			if (weapon & SUW_HANDGUN)
				player.weapondelay = TICRATE/4
			else
				player.weapondelay = TICRATE/2
			end

			if (suitems[player.equipweapon].firetype)
				P_SpawnPlayerMissile(player.mo, suitems[player.equipweapon].firetype)
			end
		elseif ((weapon & SUW_SABER)
			or (weapon & SUW_CANE)
			or (weapon & SUW_CLAW)
			or (weapon & SUW_KNUCKLE)
			or (weapon & SUW_SWORD)
			or (weapon & SUW_ROD)
			or (weapon & SUW_DAGGER)
			or (weapon & SUW_WAND)
			or (weapon & SUW_DOUBLESABER))
		
			--P_InstaThrust(player.mo, player.mo.angle, 40*FRACUNIT)
			--player.running = 1

			// Short range single target weapons
			if ((weapon & SUW_SABER)
			or (weapon & SUW_CANE)
			or (weapon & SUW_CLAW)
			or (weapon & SUW_KNUCKLE))
			
				player.suatk = 5
				player.dashspeed = 0
			// Medium range multiple target weapons
			elseif ((weapon & SUW_SWORD)
				or (weapon & SUW_ROD))
			
				player.suatk = 7
				player.dashspeed = 1
			// Long range two-hit weapons
			elseif ((weapon & SUW_DAGGER)
				or (weapon & SUW_WAND)
				or (weapon & SUW_DOUBLESABER))
			
				player.suatk = 9
				player.dashspeed = 2
			end

			player.mo.state = S_PLAY_RUN
			player.panim = PA_RUN
			S_StartSound(player.mo, sfx_zoom)
			--print(player.suatk, player.dashspeed)
		end
		
		if (player.mo.z > player.mo.floorz)
			player.pflags = ($|PF_THOKKED)
		end
	elseif not (suitems[player.equipweapon].sutype & SUT_WEAPON)
		player.equipweapon = 0
	end
	player.pflags = $|PF_ATTACKDOWN
end