-- SU Specific Structures
-- Define our tables and our items here

-- Get the list of names
createEnum(suitemtype_t, {
	"itm_invalid",
	
	-- Weapons: Sabers (Sword type)
	"itm_saber",
	"itm_brand",
	"itm_buster",
	"itm_pallasch",
	"itm_gladius",

	-- Weapons: Swords (Longsword type)
	"itm_sword",
	"itm_gigush",
	"itm_breaker",
	"itm_claymore",
	"itm_calibur",

	-- Weapons: Daggers (Double-hit Sword type)
	"itm_dagger",
	"itm_knife",
	"itm_blade",
	"itm_edge",
	"itm_ripper",

	-- Weapons: Partisans (Longsword type)
	"itm_partisan",
	"itm_halibert",
	"itm_glaive",
	"itm_berdys",
	"itm_gungnir",

	-- Weapons: Slicers (Shoot type)
	"itm_slicer",
	"itm_spinner",
	"itm_cutter",
	"itm_sawcer",
	"itm_diska",

	-- Weapons: Handguns (Shoot type)
	"itm_handgun",
	"itm_autogun",
	"itm_lockgun",
	"itm_railgun",

	-- Weapons: Rifles (Shoot type)
	"itm_rifle",
	"itm_sniper",
	"itm_blaster",
	"itm_beam",
	"itm_laser",

	-- Weapons: Mechguns (Triple-Shot Double-Gun type)
	"itm_mechgun",
	"itm_assault",
	"itm_repeater",
	"itm_gatling",
	"itm_vulcan",

	-- Weapons: Shot (Triple-Spread type)
	"itm_shot",
	"itm_spread",
	"itm_cannon",
	"itm_launcher",
	"itm_arms",

	-- Weapons: Cane (Sword type)
	"itm_cane",
	"itm_stick",
	"itm_mace",
	"itm_club",

	-- Weapons: Rod (Longsword type)
	"itm_rod",
	"itm_pole",
	"itm_pillar",
	"itm_striker",

	-- Weapons: Wand (Double-hit sword type)
	"itm_wand",
	"itm_staff",
	"itm_baton",
	"itm_scepter",

	-- Weapons: Claws (Sword type)
	"itm_photonclaw",
	"itm_silenceclaw",
	"itm_neisclaw",

	-- Weapons: Knuckles (Sword type)
	"itm_braveknuckle",
	"itm_angryfist",
	"itm_godhand",
	"itm_sonicknuckle",

	-- Weapons: Red photon class
	"itm_redsaber",
	"itm_redsword",
	"itm_reddagger",
	"itm_redpartisan",
	"itm_redslicer",
	"itm_redhandgun",
	"itm_redmechgun",

	-- Weapons: Rare
	"itm_doublesaber",
	"itm_twinbrand",
	"itm_spreadneedle",
	"itm_holyray",
	"itm_psychogun",
	"itm_heavenpunisher",

	-- Weapons: Silly
	"itm_akikosfryingpan",
	"itm_eggblaster",
	"itm_ancientsaber",
	"itm_battlefan",
	"itm_toyhammer",
	"itm_crazytune",
	"itm_rocketpunch",
	"itm_sambamaracas",
	"itm_drilllauncher",
	"itm_strikerofchao",
	"itm_masterbeam",
	"itm_gamemagazine",
	"itm_flowerbouquet",

	-- Basic barriers", by level
	"itm_barrier",
	"itm_shield",
	"itm_coreshield",
	"itm_gigashield",
	"itm_soulbarrier",
	"itm_hardshield",
	"itm_bravebarrier",
	"itm_solidshield",
	"itm_flamebarrier",
	"itm_plasmabarrier",
	"itm_freezebarrier",
	"itm_psychicbarrier",
	"itm_generalshield",
	"itm_protectbarrier",
	"itm_gloriousshield",
	"itm_imperialbarrier",
	"itm_guardiansword",
	"itm_divinitybarrier",
	"itm_ultimateshield",
	"itm_spiritualshield",
	"itm_celestialshield",

	-- Special barriers
	"itm_invisibleguard",
	"itm_sacredguard",

	-- Sparts...
	"itm_spartsver116",
	"itm_spartsver201",

	-- Walls...
	"itm_forcewall",
	"itm_rangerwall",
	"itm_hunterwall",
	"itm_attributewall",

	-- Gear barriers...
	"itm_secretgear",
	"itm_combatgear",
	"itm_protoregenegear",
	"itm_regenerategear",
	"itm_regenegearadv",

	-- Custom barrier?...
	"itm_custombarrierver00",

	-- Um...
	"itm_tripolicshield",
	"itm_standstillshield",
	"itm_saftyheart",
	"itm_kasamibracer",

	-- Rings.
	"itm_redring",
	"itm_bluering",
	"itm_yellowring",
	"itm_purplering",
	"itm_greenring",
	"itm_blackring",
	"itm_whitering",

	--Basic frames", by level.
	"itm_frame",
	"itm_armor",
	"itm_psyarmor",
	"itm_gigaframe",
	"itm_soulframe",
	"itm_crossarmor",
	"itm_solidframe",
	"itm_bravearmor",
	"itm_hyperframe",
	"itm_grandarmor",
	"itm_shockframe",
	"itm_kingsframe",
	"itm_dragonframe",
	"itm_absorbarmor",
	"itm_protectframe",
	"itm_generalarmor",
	"itm_perfectframe",
	"itm_valiantframe",
	"itm_imperialarmor",
	"itm_holinessarmor",
	"itm_guardianarmor",
	"itm_divinityarmor",
	"itm_ultimateframe",
	"itm_celestialarmor",

	-- Class specific protection fields
	"itm_hunterfield",
	"itm_rangerfield",
	"itm_forcefield",

	-- Rare armor
	"itm_revivalgarment",
	"itm_spiritgarment",
	"itm_stinkframe",
	"itm_senseplate",
	"itm_gravitonplate",
	"itm_attributeplate",
	"itm_customframev00",
	"itm_guardwave",

	-- Special armor
	"itm_luminousfield",
	"itm_chuchufever",
	"itm_loveheart",
	"itm_flamegarment",
	"itm_brightnesscircle",
	"itm_aurafield",
	"itm_electroframe",
	"itm_sacredcloth",
	"itm_smokingplate",
	
})

createEnum(suinfotype_t, {
	"info_invalid",
	
	"info_saber",
	"info_sword",
	"info_dagger",
	"info_partisan",
	"info_slicer",
	"info_handgun",
	"info_rifle",
	"info_mechgun",
	"info_shot",
	"info_cane",
	"info_rod",
	"info_wand",
	"info_photonclaw",
	"info_braveknuckle",
	"info_barrier",
	"info_frame",
	"info_rare",
	"info_quest"
})

createFlags(sutype_t, {
	"SUT_WEAPON",
	"SUT_BARRIER",
	"SUT_FRAME",
	"SUT_SLOT",
	"SUT_MAG",
	"SUT_SPECIAL",

	"SUW_SABER",
	"SUW_SWORD",
	"SUW_DAGGER",
	"SUW_PARTISAN",
	"SUW_SLICER",
	"SUW_HANDGUN",
	"SUW_RIFLE",
	"SUW_MECHGUN",
	"SUW_SHOT",
	"SUW_CANE",
	"SUW_ROD",
	"SUW_WAND",
	"SUW_CLAW",
	"SUW_KNUCKLE",
	"SUW_DOUBLESABER",
	"SUW_SPREAD",
	"SUW_PUNCH"
})

for i = 1, #suitemtype_t do
	-- Just create the 'struct' for now, we'll assign these in another file
	suitems[i] = {	name = nil,
					sutype = nil,
					firetype = nil,
					playertracer = nil,
					damage = 0,
					buyprice = 0,
					sellprice = 0,
					rarity = 0,
					usesound = 0
				}
	--print(suitemtype_t[i].value..': '..suitemtype_t[i].string)
end

for i = 1, #suinfotype_t do
	-- Just create the 'struct' for now, we'll assign these in another file
	iteminfo[i] = {
					damage = { minimum = 0, maximum = 0 },
					rarity = { minimum = 0, maximum = 0 },
					first = 0, -- Reference the suitemtype_t table
					last = 0 -- Reference the suitemtype_t table
				}
	--print(suinfotype_t[i].value..': '..suinfotype_t[i].string)
end

/*for a,b in ipairs(suitems)
	print(a+": "+b.name)
	--for c,d in pairs(b)
	--	print(c+": "+d)
	--end
end*/