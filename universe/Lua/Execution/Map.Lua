addHook("MapLoad", function(mapnum)
	if universe
		SU.MapLoad(mapnum)
	end
end)

addHook("MapThingSpawn", function(mobj, mapthing)
end)