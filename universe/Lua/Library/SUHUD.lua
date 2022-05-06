-- Hud drawing

SU.Hud = function(v, player, c)
	--if not v or not v.valid return end
	--if not p or not v.valid return end
	--if not c or not c.valid return end
	
	hud.disable("score")
	hud.disable("rings")
	hud.disable("time")
	hud.disable("lives")
	hud.disable("weaponrings")
	hud.disable("nightslink")
	hud.disable("nightsdrill")
	hud.disable("nightsrings")
	hud.disable("nightsscore")
	hud.disable("nightstime")
	hud.disable("nightsrecords")
	
	-- Cache what needs to be cached
	local suhudcolors = {}
	local suhudbg = v.cachePatch("SUHUDBG")
	local suhudsmall = v.cachePatch("SUHUDSM")
	for i = 1, 9 do
		local su_patchstr = "SUHUD"..i
		suhudcolors[i] = v.cachePatch(su_patchstr)
	end
	
	-- Table offsets
	local suhudinfo = {	HUD_SUBG 			= { x = 8*v.dupx(),  y = 16*v.dupy()	},
						HUD_SUHEALTH 		= { x = 60*v.dupx(), y = 3*v.dupy() 	},
						HUD_SUHEALTHBAR		= { x = 30*v.dupx(), y = 8*v.dupx() 	},
						HUD_SUMAGIC			= { x = 55*v.dupx(), y = 13*v.dupy() 	},
						HUD_SUMAGICBAR		= { x = 26*v.dupx(), y = 18*v.dupx() 	},
						HUD_SULEVEL			= { x = 33*v.dupx(), y = 23*v.dupy() 	},
						HUD_SUNAME			= { x = 46*v.dupx(), y = 25*v.dupy() 	},
						HUD_SUCOLOR			= { x = 9*v.dupx(),  y = 7*v.dupy() 	},
						HUD_SUSMALLBG		= { x = 0*v.dupx(),  y = 3*v.dupy() 	},
						HUD_SUSMALLHEALTHBAR= { x = 14*v.dupx(), y = 2*v.dupy() 	},
						HUD_SUSMALLLEVEL	= { x = 40*v.dupx(), y = 6*v.dupy() 	},
						HUD_SUSMALLNAME		= { x = 12*v.dupx(), y = 15*v.dupy() 	},
						HUD_SUSMALLCOLOR	= { x = 3*v.dupx(),  y = 2*v.dupy() 	}
				}
	local vidflags = V_NOSCALESTART|V_SNAPTOTOP|V_SNAPTOLEFT
	
	// HUD background
	v.drawScaled(suhudinfo.HUD_SUBG.x*FRACUNIT, 
					suhudinfo.HUD_SUBG.y*FRACUNIT,
					FRACUNIT,
					suhudbg,
					vidflags)
	v.drawScaled((suhudinfo.HUD_SUBG.x + suhudinfo.HUD_SUCOLOR.x)*FRACUNIT, 
					(suhudinfo.HUD_SUBG.y + suhudinfo.HUD_SUCOLOR.y)*FRACUNIT, 
					FRACUNIT,
					suhudcolors[#player+1],
					vidflags)

	// HUD numbers
	local health = player.suhp or 0
	local magic = player.sutp or 0
	local level = (player.sulevel%1000) or 0

	// Name parse
	// Only use the first part of the name... "John Snow" becomes just "John"
	// Max 10 characters
	local pname = string.sub(player.name, 1, string.find(player.name, " "))
	--string.match(pname, "%S+")
	if pname and (string.len(pname) > 10)
		pname = string.sub($, 1, 10)
	end

	// Draw the numbers and the name.
	v.drawString(suhudinfo.HUD_SUBG.x + suhudinfo.HUD_SUHEALTH.x, suhudinfo.HUD_SUBG.y + suhudinfo.HUD_SUHEALTH.y, health, vidflags, "small-right") 
	v.drawString(suhudinfo.HUD_SUBG.x + suhudinfo.HUD_SUMAGIC.x, suhudinfo.HUD_SUBG.y + suhudinfo.HUD_SUMAGIC.y, magic, vidflags, "small-right") 
	v.drawString(suhudinfo.HUD_SUBG.x + suhudinfo.HUD_SULEVEL.x, suhudinfo.HUD_SUBG.y + suhudinfo.HUD_SULEVEL.y, level, vidflags, "small-right") 
	v.drawString(suhudinfo.HUD_SUBG.x + suhudinfo.HUD_SUNAME.x, suhudinfo.HUD_SUBG.y + suhudinfo.HUD_SUNAME.y, pname, vidflags|V_YELLOWMAP|V_ALLOWLOWERCASE, "small") 

	// Health Bar and Magic Bars
	local length = 44*v.dupx()
	local lengthsmall = 32*v.dupx()
	local hpAmount, tpAmount
	
	// How much "HP" does the player have?
	if player.suhp
		hpAmount = player.sumaxhp - player.suhp
		hpAmount = ($ * length)/player.sumaxhp
	else
		hpAmount = player.sumaxhp
	end
	
	if (hpAmount > 0)
		v.drawFill(suhudinfo.HUD_SUBG.x + suhudinfo.HUD_SUHEALTHBAR.x + length - hpAmount, 
					suhudinfo.HUD_SUBG.y + suhudinfo.HUD_SUHEALTHBAR.y, 
					hpAmount, 3*v.dupy(), 105|vidflags)
	end
	
	// How much "TP" does the player have?
	if player.sutp
		tpAmount = player.sumaxtp - player.sutp
		tpAmount = ($ * length)/player.sumaxtp
	else
		tpAmount = player.sumaxtp
	end
	
	if (tpAmount > 0)
		v.drawFill(suhudinfo.HUD_SUBG.x + suhudinfo.HUD_SUMAGICBAR.x + length - tpAmount,
					suhudinfo.HUD_SUBG.y + suhudinfo.HUD_SUMAGICBAR.y,
					tpAmount, 3*v.dupy(), 157|vidflags)
	end
	
	-- Draw the rest of your party
	local y = suhudinfo.HUD_SUBG.y + suhudinfo.HUD_SUNAME.y + 30 --15
	for p in players.iterate
		if p and p.valid and not p.spectator
			if p == player -- Skip us
				continue
			end
			
			v.drawScaled((suhudinfo.HUD_SUBG.x + suhudinfo.HUD_SUSMALLBG.x)*FRACUNIT, 
						y*FRACUNIT,
						FRACUNIT,
						suhudsmall,
						vidflags)
			v.drawScaled((suhudinfo.HUD_SUBG.x + suhudinfo.HUD_SUSMALLBG.x + 3*v.dupx())*FRACUNIT, 
						(y + suhudinfo.HUD_SUSMALLCOLOR.y)*FRACUNIT, 
						FRACUNIT,
						suhudcolors[#p+1],
						vidflags)
						
			// Hud Numbers
			local phealth = p.suhp
			local plevel = p.sulevel
			
			// Name parse
			// Only use the first part of the name... "John Snow" becomes just "John"
			// Max 10 characters
			local mpname = string.sub(p.name, 1, string.find(p.name, " "))
			--string.match(pname, "%S+")
			if mpname and (string.len(pname) > 10)
				mpname = string.sub($, 1, 10)
			end
			
			// Draw the numbers and the name.
			v.drawString(suhudinfo.HUD_SUBG.x + suhudinfo.HUD_SUSMALLBG.x + suhudinfo.HUD_SUSMALLLEVEL.x, 
						y + suhudinfo.HUD_SUSMALLLEVEL.y, 
						level, vidflags, "small-right") 
			v.drawString(suhudinfo.HUD_SUBG.x + suhudinfo.HUD_SUSMALLBG.x + suhudinfo.HUD_SUSMALLNAME.x,
						y + suhudinfo.HUD_SUSMALLNAME.y, 
						mpname, vidflags|V_YELLOWMAP|V_ALLOWLOWERCASE, "small") 
		
			// How much "HP" does the player have?
			if p.suhp
				hpAmount = p.sumaxhp - p.suhp
				hpAmount = ($ * lengthsmall)/p.sumaxhp
			else
				hpAmount = p.sumaxhp
			end
	
			if (hpAmount > 0)
				v.drawFill(suhudinfo.HUD_SUBG.x + suhudinfo.HUD_SUSMALLBG.x + suhudinfo.HUD_SUSMALLHEALTHBAR.x + lengthsmall - hpAmount, 
							y + suhudinfo.HUD_SUSMALLHEALTHBAR.y, 
							hpAmount, 3*v.dupy(), 105|vidflags)
			end
			
			y = $ + suhudinfo.HUD_SUBG.y + suhudinfo.HUD_SUNAME.y + 30
		end
	end
end
