-- Mobj Info and SU specific info

-- What Freeslots are being used here?
-- Mobj Things
freeslot(
	"MT_SUDROP",
	"MT_SUBOSSDROP",
	"MT_SUITEM",
	"MT_SUMONEY",
	"MT_SUSHOT",
	"MT_STARTTELEPORT",
	"MT_ENDTELEPORT",
	"MT_TELEPIPE",
	"MT_TELESPARK1",
	"MT_TELESPARK2"
)

-- States
freeslot(
	"S_SUITEM",
	"S_SUMONEY",
	"S_TELESPARK1",
	"S_TELESPARK2",
	"S_DUMMY_PAIN"
)

freeslot(
	"SPR_UITM",
	"SPR_UMON",
	"SPR_UPIP"
)

-- Let's get started!
local thing

local function sumobjinfoSet(mo, lvl, dmg, rt, rtr)
	mobjinfo[mo].sumobjinfo.level = lvl
	mobjinfo[mo].sumobjinfo.damage = dmg
	mobjinfo[mo].sumobjinfo.raretype = rt
	mobjinfo[mo].sumobjinfo.rarity = rtr
end

thing = S_DUMMY_PAIN
states[thing].sprite = SPR_THOK -- Dummy sprite. Will be replaced.
states[thing].frame = A
states[thing].tics = TICRATE
states[thing].nextstate = S_SPAWNSTATE

for i = 0, #mobjinfo-1 do
	-- Initialize the table for all Mobjs.
	mobjinfo[i].sumobjinfo = {
								level = $ or 0,
								damage = $ or 0,
								raretype = $ or 0,
								rarity = $ or 0
							}

	if (mobjinfo[i].flags & MF_ENEMY)
		if (mobjinfo[i].painstate == S_NULL)
			mobjinfo[i].painstate = S_DUMMY_PAIN
		end
		if not (mobjinfo[i].painsound)
			mobjinfo[i].painsound = sfx_dmpain
		end
	end

	if (i == MT_BLUECRAWLA)
		sumobjinfoSet(i, 1, 5, MT_REDCRAWLA, 25)
	elseif (i == MT_REDCRAWLA)
		sumobjinfoSet(i, 2, 15, MT_BLUECRAWLA, 255)
	elseif (i == MT_GFZFISH)
		sumobjinfoSet(i, 3, 30, MT_NULL, 255)
	elseif (i == MT_GOLDBUZZ)
		sumobjinfoSet(i, 3, 10, MT_REDBUZZ, 25)
	elseif (i == MT_REDBUZZ)
		sumobjinfoSet(i, 4, 20, MT_GOLDBUZZ, 255)
	elseif (i == MT_JETTGUNNER)
		sumobjinfoSet(i, 5, 30, MT_JETTBOMBER, 25)
	elseif (i == MT_JETTBOMBER)
		sumobjinfoSet(i, 6, 35, MT_JETTGUNNER, 255)
	elseif (i == MT_CRAWLACOMMANDER)
		sumobjinfoSet(i, 7, 25, MT_DETON, 255)
	elseif (i == MT_EGGMOBILE)
		sumobjinfoSet(i, 10, 50, MT_EGGMOBILE2, 255)
	elseif (i == MT_EGGMOBILE2)
		sumobjinfoSet(i, 10, 50, MT_EGGMOBILE, 255)
	end
end

thing = MT_STARTTELEPORT
mobjinfo[thing].spawnstate = S_INVISIBLE	
mobjinfo[thing].radius = 32*FRACUNIT
mobjinfo[thing].height = 96*FRACUNIT
mobjinfo[thing].flags = MF_NOSECTOR|MF_NOGRAVITY--|MF_SPECIAL

thing = MT_ENDTELEPORT
mobjinfo[thing].spawnstate = S_INVISIBLE
mobjinfo[thing].radius = 32*FRACUNIT
mobjinfo[thing].height = 96*FRACUNIT
mobjinfo[thing].flags = MF_NOSECTOR|MF_NOGRAVITY--|MF_SPECIAL

thing = MT_TELEPIPE
mobjinfo[thing].spawnstate = S_NULL	
mobjinfo[thing].radius = 32*FRACUNIT
mobjinfo[thing].height = 96*FRACUNIT
mobjinfo[thing].flags = MF_NOSECTOR|MF_NOGRAVITY--|MF_SPECIAL

thing = MT_TELESPARK1
mobjinfo[thing].spawnstate = S_TELESPARK1
mobjinfo[thing].radius = 16*FRACUNIT
mobjinfo[thing].height = 32*FRACUNIT
mobjinfo[thing].flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIP

thing = MT_TELESPARK2
mobjinfo[thing].spawnstate = S_TELESPARK2
mobjinfo[thing].radius = 2*FRACUNIT
mobjinfo[thing].height = 56*FRACUNIT
mobjinfo[thing].flags = MF_NOBLOCKMAP|MF_NOGRAVITY|MF_NOCLIP

thing = MT_SUDROP
mobjinfo[thing].spawnstate = S_INVISIBLE
mobjinfo[thing].radius = 16*FRACUNIT
mobjinfo[thing].height = 24*FRACUNIT
mobjinfo[thing].flags = MF_NOBLOCKMAP

thing = MT_SUBOSSDROP
mobjinfo[thing].spawnstate = S_INVISIBLE
mobjinfo[thing].radius = 16*FRACUNIT
mobjinfo[thing].height = 24*FRACUNIT
mobjinfo[thing].flags = MF_NOBLOCKMAP

thing = MT_SUITEM
mobjinfo[thing].spawnstate = S_SUITEM
mobjinfo[thing].radius = 16*FRACUNIT
mobjinfo[thing].height = 24*FRACUNIT
mobjinfo[thing].flags = MF_SPECIAL|MF_NOGRAVITY

thing = MT_SUMONEY
mobjinfo[thing].spawnstate = S_SUMONEY
mobjinfo[thing].radius = 16*FRACUNIT
mobjinfo[thing].height = 24*FRACUNIT
mobjinfo[thing].flags = MF_SPECIAL|MF_NOGRAVITY

thing = MT_SUSHOT
mobjinfo[thing].doomednum = -1
mobjinfo[thing].spawnstate = S_ROCKET
mobjinfo[thing].spawnhealth = 1000
mobjinfo[thing].seestate = S_NULL
mobjinfo[thing].seesound = sfx_rlaunc
mobjinfo[thing].reactiontime = 8
mobjinfo[thing].painstate = S_NULL
--mobjinfo[thing].deathsound = sfx_rxplod
mobjinfo[thing].speed = 50*FRACUNIT
mobjinfo[thing].radius = 11*FRACUNIT
mobjinfo[thing].height = 8*FRACUNIT
mobjinfo[thing].mass = 100
mobjinfo[thing].damage = 20
mobjinfo[thing].flags = MF_NOBLOCKMAP|MF_MISSILE|MF_NOGRAVITY
mobjinfo[thing].raisestate = S_NULL


-- States
thing = S_SUITEM
states[thing].sprite = SPR_UITM
states[thing].frame = A--|FF_ANIMATE
states[thing].tics = -1
states[thing].var1 = 7
states[thing].var2 = 3
states[thing].nextstate = S_SUITEM

thing = S_SUMONEY
states[thing].sprite = SPR_UMON
states[thing].frame = A
states[thing].tics = -1
states[thing].nextstate = S_SUMONEY

thing = S_TELESPARK1
states[thing].sprite = SPR_UPIP
states[thing].frame = 0|FF_FULLBRIGHT|FF_TRANS40
states[thing].tics = -1

thing = S_TELESPARK2
states[thing].sprite = SPR_UPIP
states[thing].frame = 1|FF_FULLBRIGHT|FF_TRANS40
states[thing].tics = -1

---

-- SU SPECIFIC ITEMS BELOW --
SU.CalcInc = function(base, maximum, num, maxnum)
	local inc = (maximum - base) / maxnum+1
	local val = (base + (inc*num))
	if (val >= maximum)
		val = maximum
	end
	return val
end

SU.CalcDec = function(base, maximum, num, maxnum)
	local inc = (maximum - base) / maxnum
	local val = (maximum - (inc*num))
	if (val <= base)
		val = base
	end
	return val
end


SU.CalcItemDamage = function(i)
	local info
	
	-- Damage already set.
	if (suitems[i].damage)
		return suitems[i].damage
	end
	
	-- Find Weapon Type
	if (suitems[i].sutype & SUW_SABER)
		info = iteminfo[info_saber]
	elseif (suitems[i].sutype & SUW_SWORD)
		info = iteminfo[info_sword]
	elseif (suitems[i].sutype & SUW_DAGGER)
		info = iteminfo[info_dagger]
	elseif (suitems[i].sutype & SUW_PARTISAN)
		info = iteminfo[info_partisan]
	elseif (suitems[i].sutype & SUT_BARRIER)
		info = iteminfo[info_barrier]
	elseif (suitems[i].sutype & SUT_FRAME)
		info = iteminfo[info_frame]
	// Not found? No damage.
	else
		return 0
	end
	
	-- Not in the autogenerated list...
	if (i > info.last) or (i < info.first)
		return 0 -- Not valid
	end
	
	-- Do some calculations
	return SU.CalcInc(info.damage.minimum, info.damage.maximum,
						i - info.first, info.last - info.first)
end


SU.CalcItemRarity = function(i)
	local info
	
	-- Rarity already set
	if (suitems[i].rarity)
		return suitems[i].rarity
	end
	
	-- Find Weapon Type
	if (suitems[i].sutype & SUW_SABER)
		info = iteminfo[info_saber]
	elseif (suitems[i].sutype & SUW_SWORD)
		info = iteminfo[info_sword]
	elseif (suitems[i].sutype & SUW_DAGGER)
		info = iteminfo[info_dagger]
	elseif (suitems[i].sutype & SUW_PARTISAN)
		info = iteminfo[info_partisan]
	elseif (suitems[i].sutype & SUT_BARRIER)
		info = iteminfo[info_barrier]
	elseif (suitems[i].sutype & SUT_FRAME)
		info = iteminfo[info_frame]
	// Not found? No damage.
	else
		return 0
	end
	
	-- Not in the autogenerated list...
	if (i > info.last) or (i < info.first)
		return 0 -- Not valid
	end
	
	return SU.CalcDec(info.rarity.minimum, info.rarity.maximum,
						i - info.first, info.last - info.first)
end

-- Initialize all the items.
SU.InitItems = function()
	local info
	local itm

	// Sabers
	info = iteminfo[info_saber]
	info.first = itm_saber
	info.last = itm_gladius
	info.damage.minimum = 10
	info.damage.maximum = 80
	info.rarity.minimum = 20
	info.rarity.maximum = 99

	// Swords
	info = iteminfo[info_sword]
	info.first = itm_sword
	info.last = itm_calibur
	info.damage.minimum = 8
	info.damage.maximum = 60
	info.rarity.minimum = 40
	info.rarity.maximum = 90

	// Daggers
	info = iteminfo[info_dagger]
	info.first = itm_dagger
	info.last = itm_ripper
	info.damage.minimum = 6
	info.damage.maximum = 50
	info.rarity.minimum = 30
	info.rarity.maximum = 80

	// Partisans
	info = iteminfo[info_partisan]
	info.first = itm_partisan
	info.last = itm_gungnir
	info.damage.minimum = 6
	info.damage.maximum = 50
	info.rarity.minimum = 40
	info.rarity.maximum = 90

	// Barriers
	info = iteminfo[info_barrier]
	info.first = itm_barrier
	info.last = itm_celestialshield
	info.damage.minimum = 10
	info.damage.maximum = 500
	info.rarity.minimum = 1
	info.rarity.maximum = 90

	// Frames
	info = iteminfo[info_frame]
	info.first = itm_frame
	info.last = itm_celestialarmor
	info.damage.minimum = 10
	info.damage.maximum = 500
	info.rarity.minimum = 10
	info.rarity.maximum = 99

	// Item-specific details
	for i = 1, #suitems do
		itm = suitems[i]
		itm.name = nil
		itm.sutype = SUT_SPECIAL
		itm.firetype = MT_NULL
		itm.playertracer = MT_NULL
		itm.usesound = sfx_None

		// Sabers
		if (i == itm_saber)
			itm.name = "saber"
			itm.sutype = SUT_WEAPON|SUW_SABER
		//end
		elseif (i == itm_brand)
			itm.name = "brand"
			itm.sutype = SUT_WEAPON|SUW_SABER
		//end
		elseif (i == itm_buster)
			itm.name = "buster"
			itm.sutype = SUT_WEAPON|SUW_SABER
		//end
		elseif (i == itm_pallasch)
			itm.name = "pallasch"
			itm.sutype = SUT_WEAPON|SUW_SABER
		//end
		elseif (i == itm_gladius)
			itm.name = "gladius"
			itm.sutype = SUT_WEAPON|SUW_SABER
		//end

		// Swords
		elseif (i == itm_sword)
			itm.name = "sword"
			itm.sutype = SUT_WEAPON|SUW_SWORD
		//end
		elseif (i == itm_gigush)
			itm.name = "gigush"
			itm.sutype = SUT_WEAPON|SUW_SWORD
		//end
		elseif (i == itm_breaker)
			itm.name = "breaker"
			itm.sutype = SUT_WEAPON|SUW_SWORD
		//end
		elseif (i == itm_claymore)
			itm.name = "claymore"
			itm.sutype = SUT_WEAPON|SUW_SWORD
		//end
		elseif (i == itm_calibur)
			itm.name = "calibur"
			itm.sutype = SUT_WEAPON|SUW_SWORD
		//end

		// Daggers
		elseif (i == itm_dagger)
			itm.name = "dagger"
			itm.sutype = SUT_WEAPON|SUW_DAGGER
		//end
		elseif (i == itm_knife)
			itm.name = "knife"
			itm.sutype = SUT_WEAPON|SUW_DAGGER
		//end
		elseif (i == itm_blade)
			itm.name = "blade"
			itm.sutype = SUT_WEAPON|SUW_DAGGER
		//end
		elseif (i == itm_edge)
			itm.name = "edge"
			itm.sutype = SUT_WEAPON|SUW_DAGGER
		//end
		elseif (i == itm_ripper)
			itm.name = "ripper"
			itm.sutype = SUT_WEAPON|SUW_DAGGER
		//end

		// Partisans
		elseif (i == itm_partisan)
			itm.name = "partisan"
			itm.sutype = SUT_WEAPON|SUW_PARTISAN
		//end
		elseif (i == itm_halibert)
			itm.name = "halibert"
			itm.sutype = SUT_WEAPON|SUW_PARTISAN
		//end
		elseif (i == itm_glaive)
			itm.name = "glaive"
			itm.sutype = SUT_WEAPON|SUW_PARTISAN
		//end
		elseif (i == itm_berdys)
			itm.name = "berdys"
			itm.sutype = SUT_WEAPON|SUW_PARTISAN
		//end
		elseif (i == itm_gungnir)
			itm.name = "gungnir"
			itm.sutype = SUT_WEAPON|SUW_PARTISAN
		//end

		// Slicers
		elseif (i == itm_slicer)
			itm.name = "slicer"
			itm.sutype = SUT_WEAPON|SUW_SLICER
		//end
		elseif (i == itm_spinner)
			itm.name = "spinner"
			itm.sutype = SUT_WEAPON|SUW_SLICER
		//end
		elseif (i == itm_cutter)
			itm.name = "cutter"
			itm.sutype = SUT_WEAPON|SUW_SLICER
		//end
		elseif (i == itm_sawcer)
			itm.name = "sawcer"
			itm.sutype = SUT_WEAPON|SUW_SLICER
		//end
		elseif (i == itm_diska)
			itm.name = "diska"
			itm.sutype = SUT_WEAPON|SUW_SLICER
		//end

		// Handguns
		elseif (i == itm_handgun)
			itm.name = "handgun"
			itm.sutype = SUT_WEAPON|SUW_HANDGUN
		//end
		elseif (i == itm_autogun)
			itm.name = "autogun"
			itm.sutype = SUT_WEAPON|SUW_HANDGUN
		//end
		elseif (i == itm_lockgun)
			itm.name = "lockgun"
			itm.sutype = SUT_WEAPON|SUW_HANDGUN
		//end
		elseif (i == itm_railgun)
			itm.name = "railgun"
			itm.sutype = SUT_WEAPON|SUW_HANDGUN
		//end

		// Rifles
		elseif (i == itm_rifle)
			itm.name = "rifle"
			itm.sutype = SUT_WEAPON|SUW_RIFLE
		//end
		elseif (i == itm_sniper)
			itm.name = "sniper"
			itm.sutype = SUT_WEAPON|SUW_RIFLE
		//end
		elseif (i == itm_blaster)
			itm.name = "blaster"
			itm.sutype = SUT_WEAPON|SUW_RIFLE
		//end
		elseif (i == itm_beam)
			itm.name = "beam"
			itm.sutype = SUT_WEAPON|SUW_RIFLE
		//end
		elseif (i == itm_laser)
			itm.name = "laser"
			itm.sutype = SUT_WEAPON|SUW_RIFLE
		//end

		// Mechguns
		elseif (i == itm_mechgun)
			itm.name = "mechgun"
			itm.sutype = SUT_WEAPON|SUW_MECHGUN
		//end
		elseif (i == itm_assault)
			itm.name = "assault"
			itm.sutype = SUT_WEAPON|SUW_MECHGUN
		//end
		elseif (i == itm_repeater)
			itm.name = "assault"
			itm.sutype = SUT_WEAPON|SUW_MECHGUN
		//end
		elseif (i == itm_gatling)
			itm.name = "gatling"
			itm.sutype = SUT_WEAPON|SUW_MECHGUN
		//end
		elseif (i == itm_vulcan)
			itm.name = "vulcan"
			itm.sutype = SUT_WEAPON|SUW_MECHGUN
		//end

		// Shots
		elseif (i == itm_shot)
			itm.name = "shot"
			itm.sutype = SUT_WEAPON|SUW_SHOT
		//end
		elseif (i == itm_spread)
			itm.name = "spread"
			itm.sutype = SUT_WEAPON|SUW_SHOT
		//end
		elseif (i == itm_cannon)
			itm.name = "cannon"
			itm.sutype = SUT_WEAPON|SUW_SHOT
		//end
		elseif (i == itm_launcher)
			itm.name = "launcher"
			itm.sutype = SUT_WEAPON|SUW_SHOT
		//end
		elseif (i == itm_arms)
			itm.name = "arms"
			itm.sutype = SUT_WEAPON|SUW_SHOT
		//end

		// Canes
		elseif (i == itm_cane)
			itm.name = "cane"
			itm.sutype = SUT_WEAPON|SUW_CANE
		//end
		elseif (i == itm_stick)
			itm.name = "stick"
			itm.sutype = SUT_WEAPON|SUW_CANE
		//end
		elseif (i == itm_mace)
			itm.name = "mace"
			itm.sutype = SUT_WEAPON|SUW_CANE
		//end
		elseif (i == itm_club)
			itm.name = "club"
			itm.sutype = SUT_WEAPON|SUW_CANE
		//end

		// Rods
		elseif (i == itm_rod)
			itm.name = "rod"
			itm.sutype = SUT_WEAPON|SUW_ROD
		//end
		elseif (i == itm_pole)
			itm.name = "pole"
			itm.sutype = SUT_WEAPON|SUW_ROD
		//end
		elseif (i == itm_pillar)
			itm.name = "pillar"
			itm.sutype = SUT_WEAPON|SUW_ROD
		//end
		elseif (i == itm_striker)
			itm.name = "striker"
			itm.sutype = SUT_WEAPON|SUW_ROD
		//end

		// Wands
		elseif (i == itm_wand)
			itm.name = "wand"
			itm.sutype = SUT_WEAPON|SUW_WAND
		//end
		elseif (i == itm_staff)
			itm.name = "staff"
			itm.sutype = SUT_WEAPON|SUW_WAND
		//end
		elseif (i == itm_baton)
			itm.name = "baton"
			itm.sutype = SUT_WEAPON|SUW_WAND
		//end
		elseif (i == itm_scepter)
			itm.name = "scepter"
			itm.sutype = SUT_WEAPON|SUW_WAND
		//end

		// Claws
		elseif (i == itm_photonclaw)
			itm.name = "photon claw"
			itm.sutype = SUT_WEAPON|SUW_CLAW
		//end
		elseif (i == itm_silenceclaw)
			itm.name = "silence claw"
			itm.sutype = SUT_WEAPON|SUW_CLAW
		//end
		elseif (i == itm_neisclaw)
			itm.name = "nei's claw"
			itm.sutype = SUT_WEAPON|SUW_CLAW
		//end

		// Knuckles
		elseif (i == itm_braveknuckle)
			itm.name = "brave knuckle"
			itm.sutype = SUT_WEAPON|SUW_KNUCKLE
		//end
		elseif (i == itm_angryfist)
			itm.name = "angry fist"
			itm.sutype = SUT_WEAPON|SUW_KNUCKLE
		//end
		elseif (i == itm_godhand)
			itm.name = "god hand"
			itm.sutype = SUT_WEAPON|SUW_KNUCKLE
		//end
		elseif (i == itm_sonicknuckle)
			itm.name = "sonic knuckle"
			itm.sutype = SUT_WEAPON|SUW_KNUCKLE
		//end

		// Red weapons
		elseif (i == itm_redsaber)
			itm.name = "red saber"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_SABER
		//end
		elseif (i == itm_redsword)
			itm.name = "red sword"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_SWORD
		//end
		elseif (i == itm_reddagger)
			itm.name = "red dagger"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_DAGGER
		//end
		elseif (i == itm_redpartisan)
			itm.name = "red partisan"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_PARTISAN
		//end
		elseif (i == itm_redslicer)
			itm.name = "red slicer"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_SLICER
		//end
		elseif (i == itm_redhandgun)
			itm.name = "red handgun"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_HANDGUN
		//end
		elseif (i == itm_redmechgun)
			itm.name = "red mechgun"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_MECHGUN
		//end

		// Special items, Set 1
		elseif (i == itm_doublesaber)
			itm.name = "double saber"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_DOUBLESABER
		//end
		elseif (i == itm_twinbrand)
			itm.name = "twin brand"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_DOUBLESABER
		//end
		elseif (i == itm_spreadneedle)
			itm.name = "spread needle"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_SPREAD
		//end
		elseif (i == itm_holyray)
			itm.name = "holy ray"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_HANDGUN
		//end
		elseif (i == itm_psychogun)
			itm.name = "psychogun"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_HANDGUN
		//end
		elseif (i == itm_heavenpunisher)
			itm.name = "heaven punisher"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_HANDGUN
		//end

		// Special items, Set 2 (Saber types)
		elseif (i == itm_akikosfryingpan)
			itm.name = "akiko's frying pan"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_SABER
		//end
		elseif (i == itm_ancientsaber)
			itm.name = "ancient saber"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_SABER
		//end
		elseif (i == itm_battlefan)
			itm.name = "battle fan"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_SABER
		//end
		elseif (i == itm_toyhammer)
			itm.name = "toy hammer"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_SABER
		//end
		elseif (i == itm_crazytune)
			itm.name = "crazy tune"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_SABER
		//end
		elseif (i == itm_gamemagazine)
			itm.name = "game magazine"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_SABER
		//end
		elseif (i == itm_flowerbouquet)
			itm.name = "flower bouquet"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_SABER
		//end

		// Special items, Set 3 (Punch)
		elseif (i == itm_rocketpunch)
			itm.name = "rocket punch"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_SABER
		//end
		elseif (i == itm_drilllauncher)
			itm.name = "drill launcher"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_SABER
		//end

		// Special items, Set 4 (Other)
		elseif (i == itm_eggblaster)
			itm.name = "egg blaster"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_HANDGUN
		//end
		elseif (i == itm_sambamaracas)
			itm.name = "samba maracas"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_MECHGUN
		//end
		elseif (i == itm_strikerofchao)
			itm.name = "striker of chao"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_SWORD
		//end
		elseif (i == itm_masterbeam)
			itm.name = "master beam"
			itm.sutype = SUT_SPECIAL|SUT_WEAPON|SUW_RIFLE
		//end

		// Barriers
		elseif (i == itm_barrier)
			itm.name = "barrier"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_shield)
			itm.name = "shield"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_coreshield)
			itm.name = "core shield"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_gigashield)
			itm.name = "giga shield"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_soulbarrier)
			itm.name = "soul barrier"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_hardshield)
			itm.name = "hard shield"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_bravebarrier)
			itm.name = "brave barrier"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_solidshield)
			itm.name = "solid shield"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_flamebarrier)
			itm.name = "flame barrier"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_plasmabarrier)
			itm.name = "plasma barrier"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_freezebarrier)
			itm.name = "freeze barrier"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_psychicbarrier)
			itm.name = "psychic barrier"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_generalshield)
			itm.name = "general shield"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_protectbarrier)
			itm.name = "protect barrier"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_gloriousshield)
			itm.name = "glorious shield"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_imperialbarrier)
			itm.name = "imperial barrier"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_guardiansword)
			// Yes. Guardian sword is a BARRIER.
			itm.name = "guardian sword"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_divinitybarrier)
			itm.name = "divinity barrier"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_ultimateshield)
			itm.name = "ultimate shield"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_spiritualshield)
			itm.name = "spiritual shield"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_celestialshield)
			itm.name = "celestial shield"
			itm.sutype = SUT_BARRIER
		//end

		// Special barriers
		elseif (i == itm_invisibleguard)
			itm.name = "invisible guard"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_sacredguard)
			itm.name = "sacred guard"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_spartsver116)
			itm.name = "s-parts ver1.16"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_spartsver201)
			itm.name = "s-parts ver2.01"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_forcewall)
			itm.name = "force wall"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_rangerwall)
			itm.name = "ranger wall"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_hunterwall)
			itm.name = "hunter wall"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_attributewall)
			itm.name = "attribute wall"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_secretgear)
			itm.name = "secret gear"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_combatgear)
			itm.name = "combat gear"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_protoregenegear)
			itm.name = "proto regene gear"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_regenerategear)
			itm.name = "regenerate gear"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_regenegearadv)
			itm.name = "regene gear adv."
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_custombarrierver00)
			itm.name = "custom barrier ver00"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_tripolicshield)
			itm.name = "tripolic shield"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_standstillshield)
			itm.name = "standstill shield"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_saftyheart)
			itm.name = "safty heart"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_kasamibracer)
			itm.name = "kasami bracer"
			itm.sutype = SUT_BARRIER
		//end

		// God's shields
		elseif (i == itm_godsshieldSUZAKU)
			itm.name = "god's shield SUZAKU"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_godsshieldGENBU)
			itm.name = "god's shield GENBU"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_godsshieldBYAKKO)
			itm.name = "god's shield BYAKKO"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_godsshieldSEIRYU)
			itm.name = "god's shield SEIRYU"
			itm.sutype = SUT_BARRIER
		//end

		// Rings
		elseif (i == itm_redring)
			itm.name = "red ring"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_bluering)
			itm.name = "blue ring"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_yellowring)
			itm.name = "yellow ring"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_purplering)
			itm.name = "purple ring"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_greenring)
			itm.name = "green ring"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_blackring)
			itm.name = "black ring"
			itm.sutype = SUT_BARRIER
		//end
		elseif (i == itm_whitering)
			itm.name = "white ring"
			itm.sutype = SUT_BARRIER
		//end

		// Frames
		elseif (i == itm_frame)
			itm.name = "frame"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_armor)
			itm.name = "armor"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_psyarmor)
			itm.name = "psy armor"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_gigaframe)
			itm.name = "giga frame"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_soulframe)
			itm.name = "soul frame"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_crossarmor)
			itm.name = "cross armor"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_solidframe)
			itm.name = "solid frame"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_bravearmor)
			itm.name = "brave armor"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_hyperframe)
			itm.name = "hyper frame"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_grandarmor)
			itm.name = "grand armor"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_shockframe)
			itm.name = "shock frame"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_kingsframe)
			itm.name = "king's frame"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_dragonframe)
			itm.name = "dragon frame"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_absorbarmor)
			itm.name = "absorb armor"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_protectframe)
			itm.name = "protect frame"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_generalarmor)
			itm.name = "general armor"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_perfectframe)
			itm.name = "perfect frame"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_valiantframe)
			itm.name = "valiant frame"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_imperialarmor)
			itm.name = "imperial armor"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_holinessarmor)
			itm.name = "holiness armor"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_guardianarmor)
			itm.name = "guardian armor"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_divinityarmor)
			itm.name = "divinity armor"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_ultimateframe)
			itm.name = "ultimate frame"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_celestialarmor)
			itm.name = "celestial armor"
			itm.sutype = SUT_FRAME
		//end

		// Fields
		elseif (i == itm_hunterfield)
			itm.name = "hunter field"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_rangerfield)
			itm.name = "ranger field"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_forcefield)
			itm.name = "force field"
			itm.sutype = SUT_FRAME
		//end

		// Special frames
		elseif (i == itm_revivalgarment)
			itm.name = "revival garment"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_spiritgarment)
			itm.name = "spirit garment"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_stinkframe)
			itm.name = "stink frame"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_senseplate)
			itm.name = "sense plate"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_gravitonplate)
			itm.name = "graviton plate"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_attributeplate)
			itm.name = "attribute plate"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_customframev00)
			itm.name = "custom frame v00"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_guardwave)
			itm.name = "guard wave"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_luminousfield)
			itm.name = "luminousfield"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_chuchufever)
			itm.name = "chu chu fever"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_loveheart)
			itm.name = "love heart"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_flamegarment)
			itm.name = "flame garment"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_brightnesscircle)
			itm.name = "brightness circle"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_aurafield)
			itm.name = "aura field"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_electroframe)
			itm.name = "electro frame"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_sacredcloth)
			itm.name = "sacred cloth"
			itm.sutype = SUT_FRAME
		//end
		elseif (i == itm_smokingplate)
			itm.name = "smoking plate"
			itm.sutype = SUT_FRAME
		end
		
		// Slope calculation
		itm.damage = SU.CalcItemDamage(i)
		itm.rarity = SU.CalcItemRarity(i)

		// Comment this out when the slope calculation isn't buggy! X_x
		if (itm.name and itm.damage and itm.rarity)
			--print("Item: "+itm.name+" | Damage: "+itm.damage+" | Rarity: "+itm.rarity)
			print(string.format("Item: %21s | Damage: %3s | Rarity: %3s", itm.name, itm.damage, itm.rarity))
		end
	end

	-- Debugging info
	/*for i = 1, #iteminfo
		print(iteminfo[i])
	end*/
	--for i = 1, #suitems
	--	print("Name:   "+suitems[i].name)
	--	print("Damage: "+suitems[i].damage)
	--	print("Rarity: "+suitems[i].rarity+"%")
	--end
end

SU.InitItems()