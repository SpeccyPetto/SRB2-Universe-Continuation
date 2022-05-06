-- Console Commands

/*COM_AddCommand('testfunction', function(p, ...)
	if (...)
		for i = 1, #... do
			print(i) -- Prints only the length of the first arg
		end
		print(...) -- Prints the actual strings
	end
end)*/

/*	if (!universe)
		CONS_Printf(p, "This command is only for SRB2 Universe, sorry.\n")
		return
	else
		int slot
		if (COM_Argc() != 2)
			slot = lastslot
		else
			slot = lastslot = atoi(COM_Argv(1))
		end
		SU_SaveChar(slot)
	end
end

SU.Command.LoadChar = function(p)
	if (!universe)
		CONS_Printf(p, "This command is only for SRB2 Universe, sorry.\n")
		return
	else
		int slot
		byte *buf
		int len
		char name[256]

		if (COM_Argc() != 2)
			slot = lastslot
		else
			slot = lastslot = atoi(COM_Argv(1))

		sprintf(name, "SRB2Univ%d.chr", slot)
		len = FIL_ReadFile(name, &buf)
		if (!len)
			CONS_Printf(p, "Character file not found\n")
			return
		end
		
		if (netgame)
			SendNetXCmd(XD_LOADCHAR, buf, len)
		else
			SU_LoadChar(&buf, consoleplayer)
		end
	end
end*/

COM_AddCommand('inventory', function(p)
	if not universe -- Not in a universe level?
		CONS_Printf(p, "This command is only for SRB2 Universe, sorry.\n")
		return
	end
	
	CONS_Printf(p, "Inventory:\n")
	
	if (p.sumoney)
		CONS_Printf(p, "Meseta: "+p.sumoney)
	end
	
	for i = 0, #suitemtype_t-1 do
		if (p.suitems[i] and suitems[i].name)
			CONS_Printf(p, suitems[i].name + ": " + p.suitems[i] + "\n")
		end
	end
end)

COM_AddCommand('equip', function(p, ...)
	local arg1, arg2 = ...

	if not universe
		CONS_Printf(p, "This command is only for SRB2 Universe, sorry.\n")
		return
	end

	if (arg1 == nil)
		CONS_Printf(p, "Equipped items:\n")
		if (p.equipweapon)
			CONS_Printf(p, "Weapon: "+suitems[p.equipweapon].name+"\n")
		end
		if (p.equipbarrier)
			CONS_Printf(p, "Barrier: "+suitems[p.equipbarrier].name+"\n")
		end
		if (p.equiparmor)
			CONS_Printf(p, "Armor: "+suitems[p.equiparmor].name+"\n")
		end
		if (p.equipmag)
			CONS_Printf(p, "Mag: "+suitems[p.equipmag].name+"\n")
		end
		if not p.equipweapon
			and not p.equipbarrier
			and not p.equiparmor
			and not p.equipmag
			CONS_Printf(p, "None!\n")
		end
		return
	end
	
	local i = 1
	local itemnum = 0
	local itemname
	if arg2 != nil
		itemname = arg1 + " " + arg2
	else
		itemname = arg1
	end
	
	for k = 1, #suitemtype_t-1 do
		if suitems[k].name and (suitems[k].name == itemname)
			itemnum = k
			break
		end
		i = $ + 1
	end

	--print(itemnum, i)

	if (i == #suitemtype_t-1) -- i reached the table's end..
		CONS_Printf(p, "You don't have that item!\n")
		return
	end

	if not (p.suitems[itemnum])
		CONS_Printf(p, "You don't have that item!\n")
		return
	end

	if (suitems[itemnum].sutype & SUT_WEAPON)
		CONS_Printf(p, "Weapon equipped.\n")
		p.equipweapon = itemnum
	elseif(suitems[itemnum].sutype & SUT_BARRIER)
		CONS_Printf(p, "Barrier equipped.\n")
		p.equipbarrier = itemnum
	elseif(suitems[itemnum].sutype & SUT_FRAME)
		CONS_Printf(p, "Armor equipped.\n")
		p.equiparmor = itemnum
	elseif(suitems[itemnum].sutype & SUT_SLOT)
		for i = 1, 4 do
			if not p.equipslot[i]
				--CONS_Printf(p, "Slot "+i+" available.\n")
				p.equipslot[i] = itemnum
				break
			elseif i == 4
				CONS_Printf(p, "All slots are full!\n")
				return
			end
		end
		CONS_Printf(p, "Slot equipped.\n")
	--elseif(suitems[itemnum].sutype & SUT_MAG)
	--	CONS_Printf(p, "Mag equipped.\n")
	--	p.equipmag = itemnum
	else
		CONS_Printf(p, "Error: You can't equip that!\n")
	end
end)

--SU.InitCommands = function()
	--COM_AddCommand('equip', SU.Command.Equip(p))
	--COM_AddCommand('inventory', SU.Command.Inventory)
	--COM_AddCommand('savechar', SU.Command.SaveChar(p))
	--COM_AddCommand('loadchar', SU.Command.LoadChar(p))
--end