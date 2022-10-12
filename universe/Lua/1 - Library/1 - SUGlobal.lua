-- Global functions

rawset(_G, "universe", true)

rawset(_G, "SU", {}) -- Table that defines SU related functions. Eg. SU.xxx

rawset(_G, "suitemtype_t", {})
rawset(_G, "suinfotype_t", {})
rawset(_G, "sutype_t", {})

rawset(_G, "suitems", {})
rawset(_G, "iteminfo", {})

rawset(_G, "SULOBBYMAP", 22)
rawset(_G, "SUHUBMAP", 23)

rawset(_G, "createFlags", function(tname, t)
    for i = 1,#t do
		rawset(_G, t[i], 2^(i-1))
		table.insert(tname, {string = t[i], value = 2^(i-1)} )
    end
end)

rawset(_G, "createEnum", function(tname, t, from)
    if from == nil then from = 0 end
    for i = 1,#t do
		rawset(_G, t[i], from+(i-1))
		table.insert(tname, {string = t[i], value = from+(i-1)} )
    end
end)

addHook("NetVars", function(net)
	universe = net(universe)
end)