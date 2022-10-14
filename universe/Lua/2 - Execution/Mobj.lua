addHook("TouchSpecial", function(special, toucher)
	if universe then
		return SU.TouchSpecial(special, toucher)
	else
		return false
	end
end)

addHook("MobjCollide", SU.TelepipeCollide, MT_STARTTELEPORT)
addHook("MobjCollide", SU.TelepipeCollide, MT_ENDTELEPORT)
addHook("MobjCollide", SU.TelepipeCollide, MT_TELEPIPE)

addHook("MobjDamage", function(mobj, inflictor, source, damage)
	if (universe) then
		-- Mobj Damage
		-- Must have a source, must have a target(mobj)
		if source and source.valid and mobj and mobj.valid then
			--if (damage != 10000)
				return SU.DamageMobj(mobj, inflictor, source, damage)
			--else
			--	return SU.DamageMobj(mobj, inflictor, source, -1)
			--end
		else
			return false
		end
	else
		return false
	end
end)

for i = 1, #mobjinfo-1 do
	if (mobjinfo[i].flags & (MF_ENEMY|MF_BOSS)) then
		addHook("MobjSpawn", SU.DoSpawn, i)
		addHook("MobjThinker", SU.EnemyHotfix, i)
	end
end

addHook("MobjDeath", function(target, inflictor, source)
	if (universe) then
		return SU.DoDeath(target, inflictor, source)
	else
		return false
	end
end)

addHook("MobjFuse", function(mobj)
	if (universe) then
		return SU.Fuse(mobj)
	end
end)

addHook("MobjThinker", function(mobj)
	if (universe)
		return SU.MobjProg(mobj)
	end
end)