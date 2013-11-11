--Variables

local addonInfo, RaidFinder = ...
local rf = RaidFinder

rf.uiElements = {}
rf.uiElements.context = UI.CreateContext("RaidFinder")
rf.uiElements.context:SetSecureMode("restricted")

rf.needsbroadcast = false
rf.needstext = false
rf.needsupdate = {}
rf.lastbroadcast = 0
rf.lasttext = 0
rf.lastupdate = {}
rf.updateindex = 0
rf.broadcastdata = ""
rf.broadcasting = false
rf.broadcasttype = ""
rf.visible = false
rf.playerframe = {}
rf.raidframe = {}
rf.statusframe = {}
rf.secure = false
rf.statusflash = false
rf.statustext = false
rf.raidflash = false
rf.raidtext = false
rf.activetab = 1
rf.dialog = false
rf.debug = false
rf.EU = nil
rf.alerttext = ""

RaidFinder.gridData = {
	headers = {	
		['players'] = {	
			{align = 'left', header = "Player Name", width = 165 },
			{header = "Class:", width = 55},
			{header = "Roles:", width = 60},
			{header = "Experience:", width = 100},
			{header = "Hit:", width = 35},
			{header = "Looking For:", width = 145},
			{header = "Note:", width = 320},
		},
		['raids'] = {	
			{align = 'left', header = "Leader Name:", width = 185 },
			{header = "Type:", width = 75},
			{header = "Loot Type:", width = 85},
			{header = "Need:", width = 60},
			{header = "Note:", width = 425},
			{header = "Size:", width = 50},
		},
	},
	selectionheaders = {	
		['players'] = {	
			{align = 'left', header = "Player Name", width = 165 },
			{header = "Class:", width = 55},
			{header = "Roles:", width = 60},
			{header = "Experience:", width = 100},
			{header = "Hit:", width = 35},
			{header = "Note:", width = 320},
			{header = "Status:", width = 145},
			{header = "", width = 0},
		},
		['raids'] = {	
			{align = 'left', header = "Leader Name:", width = 185 },
			{header = "Type:", width = 75},
			{header = "Loot Type:", width = 85},
			{header = "Need:", width = 60},
			{header = "Note:", width = 330},
			{header = "Status:", width = 145},
			{header = "", width = 0},
		},
	},
	selection = {
		['Class'] = {
			{label = "Cleric", value = 'Cleric'},
			{label = "Mage", value = 'Mage'},
			{label = "Rogue", value = 'Rogue'},
			{label = "Warrior", value = 'Warrior'},
			{label = "All", value = 'All'},
		},
		['Role'] = {
			{label = "Tank", value = 'Tank'},
			{label = "Healer", value = 'Healer'},
			{label = "DPS", value = 'DPS'},
			{label = "Support", value = 'Support'},
			{label = "All", value = 'All'},			
		},
		['Type'] = {
			{label = "Expert", value = 'exp'},
			{label = "Great Hunt", value = 'gh'},
			{label = "Stronghold", value = 'sh'},
			{label = "World Boss", value = 'wb'},
			{label = "TDQ", value = 'tdq'},
			{label = "FT", value = 'ft'},
			{label = "EE", value = 'ee'},
			{label = "GA", value = 'ga'},
			{label = "IG", value = 'ig'},
			{label = "PB", value = 'pb'},
			{label = "Warfront", value = 'wf'},
			{label = "Old World", value = 'old'},
			{label = "Conquest", value = 'cq'},
			{label = "Raid Rift", value = 'drr'},
			{label = "MISC", value = 'misc'},
			{label = "All", value = 'All'},	
		},
		['RaidType'] = {
			{label = "Expert", value = 'exp'},
			{label = "Great Hunt", value = 'gh'},
			{label = "Stronghold", value = 'sh'},
			{label = "World Boss", value = 'wb'},
			{label = "TDQ", value = 'tdq'},
			{label = "FT", value = 'ft'},
			{label = "EE", value = 'ee'},
			{label = "GA", value = 'ga'},
			{label = "IG", value = 'ig'},
			{label = "PB", value = 'pb'},
			{label = "Warfront", value = 'wf'},
			{label = "Old World", value = 'old'},
			{label = "Conquest", value = 'cq'},
			{label = "Raid Rift", value = 'drr'},
			{label = "MISC", value = 'misc'},
		},
		['Loot'] = {
			{label = "Open Roll", value = 'Open Roll'},
			{label = "Reserved", value = 'Res'},
			{label = "All", value = 'All'},
			{label = "Some Reserved", value = 'Some Res'},
			{label = "Relic Reserved", value = 'Relic Res'},
			{label = "Greaters Res.", value = 'Greaters Res'},
			{label = "PDKP", value = 'PDKP'},
		},
		['RaidLoot'] = {
			{label = "Open Roll", value = 'Open Roll'},
			{label = "All Res.", value = 'All Res.'},
			{label = "Some Res.", value = 'Some Res.'},
			{label = "Relic Res.", value = 'Relic Res.'},
			{label = "Greaters Res.", value = 'Greaters Res.'},
			{label = "PDKP", value = 'PDKP'},
		},
	},
	puggerdata = {
	},
	raiddata = {
	},
	playerappdata = {
	},
	raidappdata = {
	},
}

function rf.settings() 
	
	local settings = {
		broadcastraid = false,
		broadcastplayer = false,
		aButtonX = 0,
		aButtonY = 0,
		aButtonS = 1,
		UIlock = false,
		flash = true,
		textnotify = false,
		playerdata = {
			name = "",
			hit = 0,
			class = "",
			roles = {tank = false, dps = false, heal = false, support = false},
			achiev = {tdq = 0, ft = 0, ee = 0, ga = 0, ig = 0, pb = 0},
			lookingfor = {tdq = false, ft = false, ee = false, ga = false, ig = false, pb = false, old = false, exp = false, drr = false, gh = false, sh = false, wb = false, wf = false, cq = false, misc = false},
			note = "Note.",
			type = "",
			},
		raiddata = {
			name = "",
			raidtype = "MISC",
			loot = "Open Roll",
			roles = {tank = false, dps = false, heal = false, support = false},
			note = "Note.",
			type = "",
			channel = "",
			size = "",
			},
	}
	
	if rfsettings == nil then
		rfsettings = settings
	else
		for k, v in pairs (settings) do

			if rfsettings[k] == nil then
				rfsettings[k] = v 
			end
			if type(settings[k])=="table" then
				for k2,v2 in pairs(settings[k]) do

					if rfsettings[k][k2] == nil then
						rfsettings[k] = v
					end
					if type(settings[k][k2]) == "table" then
						for k3,v3 in pairs(settings[k][k2]) do

							if rfsettings[k][k2][k3] == nil then
								rfsettings[k] = v
							end
						end
					end	
				end
			end
		end
	end
	
	
end

--Main

function rf.main(_, addon)

	if (addon == addonInfo.toc.Identifier) then		
		print ("Raid Finder Loaded v" .. addonInfo.toc.Version)
	
		
	table.insert(Event.System.Update.Begin, 		{rf.onupdate, 		"RaidFinder", "OnUpdate" })
	rf.updateindex = #Event.System.Update.Begin
	Event.System.Update.Begin[rf.updateindex][1] = rf.onupdate	
	
	Command.Message.Accept("channel", "raidfinder")
	Command.Message.Accept("tell", "raidfinder")
	
	rf.UI:addonButton()
	
	EnKai.version.init(addonInfo.toc.Identifier, addonInfo.toc.Version)
	
	end	
	
	


	
end

function rf.channelcheck()

	local consoles = {}
	local detail = {}
	local crossevents = false
	local shard = string.lower(Inspect.Shard().name)

	
	consoles = Inspect.Console.List()

	for k,v in pairs(consoles) do
		detail = Inspect.Console.Detail(k).channel
		if detail ~= nil then
		
			if (shard == 'faeblight' or shard == 'laethys' or shard == 'hailol' or shard == 'wolfsbane' or shard == 'deepwood' or shard == 'greybriar' or shard == 'seastone') then rf.EU = false end
			if (shard == 'bloodiron' or shard == 'brutwacht' or shard == 'trübkopf' or shard == 'brutmutter' or shard == 'brisesol' or shard == 'phynnious' or shard == 'gelidra' or shard == 'zaviel') then rf.EU = true end
			
			for k2,v2 in pairs(detail) do
				
				local channel = string.lower(k2)
				
				if ((shard == 'faeblight' or shard == 'brutwacht') and channel == 'crossevents' and v2 == true) then
					crossevents = true

					break
				elseif (rf.EU == false and channel == 'crossevents@faeblight' and v2 == true) then
					crossevents = true

					break
				elseif (rf.EU == true and channel == 'crossevents@brutwacht' and v2 == true) then
					crossevents = true

					break
				else
					
				end
			end
		end
	end
	
	if crossevents == false	then
		if rf.EU == false then
			print("Please type /join CrossEvents@Faeblight")
		elseif rf.EU == true then
			print("Please type /join CrossEvents@Brutwacht")
		end
	end
	
	return crossevents
	
end

function rf.alerts(now)	

	if rfsettings.textnotify == true then	
		if rf.lasttext == 0 then
			rf.lasttext = now
		elseif now - rf.lasttext < 15 then
			rf.needstext = false
		elseif now - rf.lasttext >= 15 then
			rf.needstext = true		
		end
	end

	if (rfsettings.textnotify == true and (rf.raidtext == true or rf.statustext == true) and rf.needstext == true) then
		print(rf.alerttext)
		rf.lasttext = now
	end
		
	if rf.activetab == 4 and rf.visible == true then 
		rf.statusflash = false
		rf.statustext = false
		end
		
	if rf.activetab == 2 and rf.visible == true then
		rf.raidflash = false
		rf.raidtext = false
	end
	
	if ((rf.statusflash or rf.raidflash) and rfsettings.flash) then
		rf.UI.flashtexture:SetAlpha(math.abs(math.sin(string.sub(string.format("%.1f",Inspect.Time.Frame()), -3))))
		Command.System.Flash(true)		
	else
		rf.UI.flashtexture:SetAlpha(0)
		Command.System.Flash(false)		
	end
	
end

function rf.onupdate()
	local now = Inspect.Time.Frame()
	
	rf.alerts(now)
	
	if rf.lastbroadcast == 0 then
		rf.lastbroadcast = now
	elseif now - rf.lastbroadcast < 15 then
		rf.needsbroadcast = false
	elseif now - rf.lastbroadcast >= 15 then
		rf.needsbroadcast = true		
	end
	
	if rf.needsbroadcast == true 
	then
		if rf.broadcasting == true then
			rf.lastbroadcast = now
			if rf.broadcasttype == "raid" then
				rf.raiddata()
			elseif rf.broadcasttype == "player" then
				rf.playerdata()
			end
			rf.broadcast(rf.broadcastdata)

		end
	end
end

function rf.gridupdate(type)
	if rf.needsupdate.raid == nil then rf.needsupdate.raid = false end
	if rf.needsupdate.player == nil then rf.needsupdate.player = false end
	if rf.needsupdate.playerapp == nil then rf.needsupdate.playerapp = false end
	if rf.needsupdate.raidapp == nil then rf.needsupdate.raidapp = false end
	
	if rf.lastupdate.raid == nil then rf.lastupdate.raid = 0 end
	if rf.lastupdate.player == nil then rf.lastupdate.player = 0 end
	if rf.lastupdate.playerapp == nil then rf.lastupdate.playerapp = 0 end
	if rf.lastupdate.raidapp == nil then rf.lastupdate.raidapp = 0 end
	
	local now = Inspect.Time.Frame()
	
	if type == "raid" then
	
		if now - rf.lastupdate.raid < 14 then
			rf.needsupdate.raid = false
		elseif now - rf.lastupdate.raid >= 14 then
			rf.needsupdate.raid = true		
		end
		
		if rf.needsupdate.raid == true then
			rf.lastupdate.raid = now
			if rf.raidframe.grid ~= nil then
				rf.RaidgridUpdate(rf.UI.frame.paneRaidTab, rf.raidframe.grid)
			end
		end
	elseif type == "player" then
		
		if now - rf.lastupdate.player < 14	then
			rf.needsupdate.player = false
		elseif now - rf.lastupdate.player >= 14 then
			rf.needsupdate.player = true		
		end
		
		if rf.needsupdate.player == true then
			rf.lastupdate.player = now
			if rf.playerframe.grid ~= nil then
				rf.PlayergridUpdate(rf.UI.frame.panePlayerTab, rf.playerframe.grid)
			end	
		end	
	elseif type == "raidApplying" then
		
		if now - rf.lastupdate.raidapp < 1	then
			rf.needsupdate.raidapp = false
		elseif now - rf.lastupdate.raidapp >= 1 then
			rf.needsupdate.raidapp = true		
		end
		
		if rf.needsupdate.raidapp == true then
			rf.lastupdate.raidapp = now
			if rf.statusframe.raidgrid ~= nil then
				rf.StatusgridUpdate(rf.UI.frame.paneStatusTab, rf.statusframe.raidgrid)
			end	
		end	
	elseif type == "playerApplying" then
		
		if now - rf.lastupdate.playerapp < 1	then
			rf.needsupdate.playerapp = false
		elseif now - rf.lastupdate.playerapp >= 1 then
			rf.needsupdate.playerapp = true		
		end
		
		if rf.needsupdate.playerapp == true then
			rf.lastupdate.playerapp = now
			if rf.statusframe.grid ~= nil then
				rf.StatusgridUpdate(rf.UI.frame.paneStatusTab, rf.statusframe.grid)
			end	
		end	
			
	end
end


	
function rf.playerdata()

	local playername = Inspect.Unit.Detail("player").name
	local shard = Inspect.Shard().name
	local data = {
			name = (playername .. "@" .. shard),
			hit = Inspect.Stat("hitUnbuffed"),
			class = (Inspect.Unit.Detail("player").calling:gsub("^%l", string.upper)),
			roles = {tank = rfsettings.playerdata.roles.tank, dps = rfsettings.playerdata.roles.dps, heal = rfsettings.playerdata.roles.heal, support = rfsettings.playerdata.roles.support},
			achiev = {
				tdq = 0,
				ft = 0,
				ee = 0,
				ga = 0,
				ig = 0,
				pb = 0,
				},
			lookingfor = rfsettings.playerdata.lookingfor,
			note = rfsettings.playerdata.note,
			type = "",
			}		
	

	local achtable = {
		"cFFFFC17D5891885E",
		"cFFFFC1793A5DBF7D",
		"cFFFFC170A4F381DA",
		"cFFFFB5BE2E4980FA",
		"cFFFFB9AD7B33B648",
		"cFFFFC17C6834FC50",
		"c6BA539348BCCC18F",
		"cFFFFC55688BA67F6",
		"cFFFFB9ACC6D2EB40",
		"cFFFFB9AAE8BFBC89",
		"cFFFFD8EDB8102D80",
		"cFFFFB9AEA7CE0F0E",
		"cFFFF9E3E27232B1B",
		"cFBFB7ECC84D5E282",
		"cFFFFC55189A83A6C",
		"cFFFFC561537B85BD",
		"cFFFFD8F0941DF90F",
		"cFFFFC5609AA63503",
		"c5B0C39B3D48325B4",
		"c310FF4908EEA4444",
		"cFFFFC17599F01EC7",
		"cFFFFB5B73F690280",
		"cFFFF9E4CA580A7FA",
		"cFFFFB9AB82CE2B87",
		"cFFFFB5BB7A5777CC",
		"cFFFFC55A5FC0FDE5",
		"cFFFF9E3F984A1069",
		"cFFFFC55FA4D3CF89",
		"cFFFF9E4E90D38778",
	}
				
	for k, v in pairs (achtable) do
		local achieve = Inspect.Achievement.Detail(v)
		local achname = achieve.name
		--TDQ
		if achname == "The Family Joules" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.tdq = (data.achiev.tdq + 1)
			end
		elseif achname == "No Rings, No Strings." then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.tdq = (data.achiev.tdq + 1)
			end
		elseif achname == "Not So Grand" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.tdq = (data.achiev.tdq + 1)
			end
		elseif achname == "Exit the dragon" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.tdq = (data.achiev.tdq + 1)
			end
		--FT
		elseif achname == "Requiem for a Queen" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ft = (data.achiev.ft + 1)
			end
		elseif achname == "Watch the Throne" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ft = (data.achiev.ft + 1)
			end
		elseif achname == "Deconstructed" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ft = (data.achiev.ft + 1)
			end
		elseif achname == "She's Frigid" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ft = (data.achiev.ft + 1)
			end
		--EE
		elseif achname == "Pentakill" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ee = (data.achiev.ee + 1)
			end		
		elseif achname == "Hypochondriac" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ee = (data.achiev.ee + 1)
			end
		elseif achname == "It's About Time" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ee = (data.achiev.ee + 1)
			end
		elseif achname == "Kain Wasn't Able" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ee = (data.achiev.ee + 1)
			end
		elseif achname == "Pop, Goloch, and Drop It" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ee = (data.achiev.ee + 1)
			end
		--GA
		elseif achname == "No More Monkey Business" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ga = (data.achiev.ga + 1)
			end
		elseif achname == "Going Down" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ga = (data.achiev.ga + 1)
			end
		elseif achname == "Dancing with the Demons" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ga = (data.achiev.ga + 1)
			end
		elseif achname == "Devil Has His Due" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ga = (data.achiev.ga + 1)
			end
		--IG
		elseif achname == "Rad-off" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ig = (data.achiev.ig + 1)
			end				
		elseif achname == "Grim Brothers" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ig = (data.achiev.ig + 1)
			end
		elseif achname == "The Harder They Fall" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ig = (data.achiev.ig + 1)
			end
		--PB
		elseif achname == "Egg Drop" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.pb = (data.achiev.pb + 1)
			end		
		elseif achname == "No Pro" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.pb = (data.achiev.pb + 1)
			end
		elseif achname == "Headhunter" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.pb = (data.achiev.pb + 1)
			end
		elseif achname == "Jailbreak" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.pb = (data.achiev.pb + 1)
			end
		elseif achname == "Inyr Face" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.pb = (data.achiev.pb + 1)
			end
		--HM
		elseif achname == "Not So Nice Cube" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ft = (data.achiev.ft + 1)
			end
		elseif achname == "Spin Cycle" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ft = (data.achiev.ft + 1)
			end
		elseif achname == "Ebon Corruption" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ee = (data.achiev.ee + 1)
			end	
		elseif achname == "Raining Blood" then
			local complete = achieve.complete
			if achieve.complete ~= nil then
				data.achiev.ee = (data.achiev.ee + 1)
			end
		else
		end
	end

	rfsettings.playerdata = data
	
	if rf.broadcasttype == "player" then
		rf.playerpost()
	end
	
end	

function rf.raiddata()
	
	local playername = Inspect.Unit.Detail("player").name
	local shard = Inspect.Shard().name
	local groupsize = 0
	
	if rfsettings.raiddata.raidtype == "wf" or rfsettings.raiddata.raidtype == "exp" then
		groupsize = 5
	elseif rfsettings.raiddata.raidtype == "tdq" or rfsettings.raiddata.raidtype == "ga" then
		groupsize = 10
	else
		groupsize = 20
	end
	
	local currentgroup = LibSRM.GroupCount()
	
	if currentgroup == 0 then 
		currentgroup = 1
	end
	
	local data = {
			name = (playername .. "@" .. shard),
			raidtype = rfsettings.raiddata.raidtype,
			loot = rfsettings.raiddata.loot,
			roles = {tank = rfsettings.raiddata.roles.tank, dps = rfsettings.raiddata.roles.dps, heal = rfsettings.raiddata.roles.heal, support = rfsettings.raiddata.roles.support},
			note = rfsettings.raiddata.note,
			type = "",
			channel = rfsettings.raiddata.channel,
			size = ("[" .. currentgroup .. "/" .. groupsize .. "]")
			}	
			
	rfsettings.raiddata = data
	
	if rf.broadcasttype == "raid" then
		rf.raidpost()
	end

	
end
	
function rf.playerpost()	
	

	if rf.channelcheck() == false then return end

	
	rfsettings.playerdata.type = "player"
	local data = rfsettings.playerdata
	
	local serialized = Utility.Serialize.Inline(data)
	local compressed = zlib.deflate()(serialized, "finish")

	
	
	rf.broadcastdata = compressed
	rf.broadcasting = true
	

end

function rf.raidpost()
	
	if rf.channelcheck() == false then return end
	
	rfsettings.raiddata.type = "raid"
	local data = rfsettings.raiddata

	
	local serialized = Utility.Serialize.Inline(data)
	local compressed = zlib.deflate()(serialized, "finish")
	
	rf.broadcastdata = compressed
	rf.broadcasting = true
	

end

function rf.broadcast(data)

	local channel = "channel"
	local shard = Inspect.Shard().name
	

	if (shard == "Faeblight" or shard == "Brutwacht") then
		channel = "CrossEvents"
	elseif rf.EU == false then
		channel = "CrossEvents@Faeblight"
	elseif rf.EU == true then
		channel = "CrossEvents@Brutwacht"
	end


	Command.Message.Broadcast("channel", channel, "raidfinder", data)

	
end

function rf.send(name, data)

	local shard = Inspect.Shard().name
	local nameshard = string.match(name, "%a+", string.find(name, "%@"))
	local failed = "none"
	local nameclean
	
	
	if nameshard == shard then
		nameclean = string.match(name, "%a+")
	else
		nameclean = name
	end
	
	if rf.debug then 
	print("player send = ",nameclean)
	end

	rf.sendtest(nameclean,data,failed)

end

function rf.sendtest(vname, vdata, vfailed)
	
	if vfailed == "none" then
		Command.Message.Broadcast("tell", vname, "raidfinder", vdata, function(failure, message)
			if failure == true then
				failed = "broadfailed"
				rf.sendtest(vname,vdata,failed)
			end
			
			if rf.debug then print("broadcast ", failure, " ", message) end 
		end)
			
	elseif vfailed == "broadfailed" then
		Command.Message.Send(vname, "raidfinder", vdata, function(failure, message)
			if failure == true then
				failed = "sendfailed"
				rf.sendtest(vname,vdata,failed)
			end
			if rf.debug then print("send ", failure, " ", message) end
		end)
		
	else
		rf.failpost(vname, vdata)
	end
end

function rf.failpost(name, incoming)
	
	if rf.channelcheck() == false then return end
	local data = {}
	
	local decompressed = zlib.inflate()(incoming, "finish")
	local deserialize = loadstring("return " .. decompressed)()

		
	data = deserialize
	
	
	data.personal = name
	
	
	local serialized = Utility.Serialize.Inline(data)
	local compressed = zlib.deflate()(serialized, "finish")

	if rf.debug then print("Sent Fail-safe mode. BAD!") end
	
	rf.broadcast(compressed)
	

end

function rf.apply(type, name)

	if type == "player" then
		rf.raiddata()
		
		rf.gridData.playerappdata[name] = rf.gridData.puggerdata[name]
		if rf.gridData.playerappdata[name].status ~= "You Applied to Invite..." then
			rf.gridData.playerappdata[name].status = "You Applied to Invite..."
				
			local data = rfsettings.raiddata
			
			data.status = "Join Raid?"
			
			data.type = "raidApplying"
			local serialized = Utility.Serialize.Inline(data)
			local compressed = zlib.deflate()(serialized, "finish")
			print("Applied!")
		
			rf.send(name, compressed)	
		end
		
	if rf.statusframe.grid ~= nil then
		rf.StatusgridUpdate(rf.UI.frame.paneStatusTab, rf.statusframe.grid)	
	end
	
	elseif type == "raid" then
	
		rf.playerdata()
		
		rf.gridData.raidappdata[name] = rf.gridData.raiddata[name]
		if rf.gridData.raidappdata[name].status ~= "You Applied to Join..." then
			rf.gridData.raidappdata[name].status = "You Applied to Join..."
				
			local data = rfsettings.playerdata
			
			data.status = "Accept Player?"
			
			data.type = "playerApplying"
			local serialized = Utility.Serialize.Inline(data)
			local compressed = zlib.deflate()(serialized, "finish")
			print("Applied!")
		
			rf.send(name, compressed)
		end
		
		if rf.statusframe.raidgrid ~= nil then
			rf.StatusgridUpdate(rf.UI.frame.paneStatusTab, rf.statusframe.raidgrid)
		end
		
	end

end

function rf.deny(type, name)

	if type == "player" then
		
		
			
			
		if rf.gridData.playerappdata[name].status ~= "Declined." then
			local data = rfsettings.raiddata
			
			data.status = "Declined."
			
			data.type = "raidApplying"
			local serialized = Utility.Serialize.Inline(data)
			local compressed = zlib.deflate()(serialized, "finish")

		
			rf.send(name, compressed)
		
		end
		
		rf.gridData.playerappdata[name] = nil
	if rf.statusframe.grid ~= nil then
		rf.StatusgridUpdate(rf.UI.frame.paneStatusTab, rf.statusframe.grid)	
	end
	
	elseif type == "raid" then
		if rf.gridData.raidappdata[name].status ~= "Declined." then
			
			local data = rfsettings.playerdata
			
			data.status = "Declined."
			
			data.type = "playerApplying"
			local serialized = Utility.Serialize.Inline(data)
			local compressed = zlib.deflate()(serialized, "finish")
		
			rf.send(name, compressed)	
		end
		
		rf.gridData.raidappdata[name] = nil
		if rf.statusframe.raidgrid ~= nil then
			rf.StatusgridUpdate(rf.UI.frame.paneStatusTab, rf.statusframe.raidgrid)
		end
		
	end

end

function rf.approve(type, name)
	
	if type == "player" then
		

			
--[[
		if rf.gridData.playerappdata[name].status == "Accept Player?" then

			local data = rfsettings.raiddata
			
			data.status = "Ready for Invite?"
			
			data.type = "raidApplying"
			local serialized = Utility.Serialize.Inline(data)
			local compressed = zlib.deflate()(serialized, "finish")

		
			rf.send(name, compressed)
		
		
		rf.gridData.playerappdata[name].status = "Confirming..."

		elseif rf.gridData.playerappdata[name].status == "Ready for Invite!" or rf.gridData.playerappdata[name].status == "Invite Sent." then --]]

		if rf.gridData.playerappdata[name].status == "Accept Player?" or rf.gridData.playerappdata[name].status == "Invite Sent." or rf.gridData.playerappdata[name].status == "Ready for Invite!" then
		
			local macro = ("invite " .. name)
			if rf.debug then print(macro) end
				rf.UI.frame.paneStatusTab.approveButton:EventMacroSet(Event.UI.Input.Mouse.Left.Click, macro)
				rf.gridData.playerappdata[name].status = "Invite Sent."
			
			end
		
		
			local data = rfsettings.raiddata
			
			data.status = "Invite has been sent!"
			
			data.type = "raidApplying"
			local serialized = Utility.Serialize.Inline(data)
			local compressed = zlib.deflate()(serialized, "finish")

		
			rf.send(name, compressed)		
		
		
		
			if rf.statusframe.grid ~= nil then

				rf.StatusgridUpdate(rf.UI.frame.paneStatusTab, rf.statusframe.grid)	
			end
		
		
	
	elseif type == "raid" then

		if rf.gridData.raidappdata[name].status == "Ready for Invite?" or rf.gridData.raidappdata[name].status == "Join Raid?"  then
			local data = rfsettings.playerdata

			data.status = "Ready for Invite!"

			data.type = "playerApplying"
			local serialized = Utility.Serialize.Inline(data)
			local compressed = zlib.deflate()(serialized, "finish")

			rf.send(name, compressed)	

			rf.gridData.raidappdata[name].status = "Waiting on Invite..."
			
			local macro = ("partyleave")
			if rf.debug then print(macro) end
			rf.UI.frame.paneStatusTab.approveButton:EventMacroSet(Event.UI.Input.Mouse.Left.Click, macro)
	
			
			--rf.UI.frame.paneStatusTab.dialog:SetVisible(true)
		
--[[		elseif rf.gridData.raidappdata[name].status == "Invite has been sent!" then
		
			local macro = ("partyleave")
			if rf.debug then print(macro) end
			rf.UI.frame.paneStatusTab.approveButton:EventMacroSet(Event.UI.Input.Mouse.Left.Click, macro)		--]]	
			
		end
		
		if rf.statusframe.raidgrid ~= nil then
			rf.StatusgridUpdate(rf.UI.frame.paneStatusTab, rf.statusframe.raidgrid)
		end
		
	end
	
	

end

function rf.receive(from, type, channel, identifier, incoming)
	local player = Inspect.Unit.Detail("player").name
	local shard = Inspect.Shard().name
	local name = (player .. "@" .. shard)
	local accept = false
	local raids = {}
	
	local now = Inspect.Time.Frame()
	if identifier == "raidfinder" then
		local decompressed = zlib.inflate()(incoming, "finish")

		local data = {}
		
			local deserialize = loadstring("return " .. decompressed)()

		
		local data = deserialize
		
		if data.personal == nil then
			accept = true
		elseif data.personal == name then
			accept = true
			if rf.debug then print("Recieved fail-safe message from ", from,", BAD!") end
		else
			accept = false
		end
		
		
		if accept == true then
		
			if data.type == "player" then
			
				rf.gridData.puggerdata[data.name] = {
												name = data.name,
												hit = data.hit,
												class = data.class,
												roles = {tank = data.roles.tank, dps = data.roles.dps, heal = data.roles.heal, support = data.roles.support},
												achiev = {tdq = data.achiev.tdq, ft = data.achiev.ft, ee = data.achiev.ee, ga = data.achiev.ga, ig = data.achiev.ig, pb = data.achiev.pb},
												lookingfor = data.lookingfor,
												note = data.note,
												time = now
												}
				
			elseif data.type == "raid" then
			
						
				if rf.gridData.raiddata[data.name] == nil and rfsettings.notifyme == true and rf.broadcasttype == "player" and rf.broadcasting == true then
					for k,v in pairs(rfsettings.playerdata.lookingfor) do
						if v == true then
							if data.raidtype == k then
								if rfsettings.flash == true then rf.raidflash = true end
								if rfsettings.textnotify == true then 
									rf.raidtext = true
									rf.alerttext = "Raid Forming that you might be interested in."
								end
							end
						end
					end						
				end

				rf.gridData.raiddata[data.name] = {
												name = data.name,
												raidtype = data.raidtype,
												loot = data.loot,
												roles = {tank = data.roles.tank, dps = data.roles.dps, heal = data.roles.heal, support = data.roles.support},
												note = data.note,
												time = now,
												size = data.size,
												}
											
			elseif data.type == "raidApplying" then
						if rf.gridData.raidappdata[data.name] == nil then
							if rfsettings.flash then rf.statusflash = true end
							if rfsettings.textnotify then 
								rf.statustext = true
								rf.alerttext = "New Raid Invite"
							end								
						elseif rf.gridData.raidappdata[data.name].status ~= data.status then 
							if rfsettings.flash then rf.statusflash = true end
							if rfsettings.textnotify then 
								rf.statustext = true
								rf.alerttext = "Raid's Status Updated"
							end 
						end
						
						if data.status == "Declined." then
							rf.statusflash = false
							rf.statustext = false
						end
						
						rf.gridData.raidappdata[data.name] = {
												name = data.name,
												type = data.raidtype,
												loot = data.loot,
												roles = {tank = data.roles.tank, dps = data.roles.dps, heal = data.roles.heal, support = data.roles.support},
												note = data.note,
												time = now,
												status = data.status,
												}
						if rf.debug then print(data.name, "status =", rf.gridData.raidappdata[data.name].status) end
												
			elseif data.type == "playerApplying" then
						if rf.gridData.playerappdata[data.name] == nil then 
							if rfsettings.flash then rf.statusflash = true end
							if rfsettings.textnotify then 
								rf.statustext = true
								rf.alerttext = "New Player Join Request"
							end
						elseif rf.gridData.playerappdata[data.name].status ~= data.status then 
							if rfsettings.flash then rf.statusflash = true end
							if rfsettings.textnotify then 
								rf.statustext = true
								rf.alerttext = "Player's Status Updated"
							end
						end						
						
						if data.status == "Declined." then 
							rf.statusflash = false
							rf.statustext = false
						end
						
						rf.gridData.playerappdata[data.name] = {
												name = data.name,
												hit = data.hit,
												class = data.class,
												roles = {tank = data.roles.tank, dps = data.roles.dps, heal = data.roles.heal, support = data.roles.support},
												achiev = {tdq = data.achiev.tdq, ft = data.achiev.ft, ee = data.achiev.ee, ga = data.achiev.ga, ig = data.achiev.ig, pb = data.achiev.pb},
												lookingfor = data.lookingfor,
												note = data.note,
												time = now,
												status = data.status,
												}
						if rf.debug then print(data.name, "status =", rf.gridData.playerappdata[data.name].status) end						
												
			end
		
			rf.gridupdate(data.type)
		
		end
	end

end
--[[
function rf.raidfound(name)


	local raid = ""
	for k2,v2 in pairs(name) do
		for k,v in pairs(rf.gridData.selection["RaidType"]) do
			if EnKai.tools.table.isMember(v, v2) then
				raid = rf.gridData.selection["RaidType"][k].label
				print(raid .. " Raid Forming.")
			end
		end
	end

end
--]]


--UI

rf.UI = {}

function rf.open()

	if rf.uiElements.window == nil then 
		rf.uiElements.window = rf.UI:createUI()
	end
	rf.visible = true
	rf.uiElements.window:SetVisible(true)
	
	if rf.secure ~= true and rf.UI.frame.paneStatusTab.approveButton ~= nil and rf.activetab == 4 then
		rf.UI.frame.paneStatusTab.approveButton:SetVisible(true)
	end
	
	if rf.secure ~= true and rf.UI.frame.panePostTab.btRaidPost ~= nil and rf.activetab == 1 then
		rf.UI.frame.panePostTab.btRaidPost:SetVisible(true)
	end	
	
	if rf.activetab == 4 then
		rf.statusflash = false
		rf.statustext = false
	end
	if rf.activetab == 2 then 
		rf.raidflash = false
		rf.raidtext = false
	end
	
	
end

function rf.UI:closeUI()
	rf.visible = false
	rf.uiElements.window:SetVisible(false)
	if rf.secure ~= true and rf.UI.frame.paneStatusTab.approveButton ~= nil then 
	rf.UI.frame.paneStatusTab.approveButton:SetVisible(false)
	end
	if rf.secure ~= true and rf.UI.frame.panePostTab.btRaidPost ~= nil then
	rf.UI.frame.panePostTab.btRaidPost:SetVisible(false)
	end
end

function rf.UI:createUI()

	rf.UI.frame = EnKai.ui.nkWindow('RFMainWindow', rf.uiElements.context)
	rf.UI.frame:SetLayer(1)
	rf.UI.frame:SetWidth(975)
	rf.UI.frame:SetHeight(600)
	rf.UI.frame:SetTitle(addonInfo.toc.Identifier .. ' v' .. addonInfo.toc.Version)
	rf.UI.frame:SetPoint("CENTER", UIParent,"CENTER")
	rf.UI.frame:SetDragable(true)
	rf.UI.frame:SetCloseable(false)
	rf.UI.frame:SetVisible(true)		

	rf.UI.frame.closeButton = UI.CreateFrame('Texture', 'MainClose', rf.UI.frame)
	rf.UI.frame.closeButton:SetTextureAsync('RaidFinder', 'lib/EnKai/gfx/btnClose.png')
	rf.UI.frame.closeButton:SetPoint("TOPRIGHT", rf.UI.frame, "TOPRIGHT", -12, 18)
	rf.UI.frame.closeButton:SetLayer(2)
	
	rf.UI.frame.closeButton:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		rf.UI.closeUI()
	end, "RaidTabClose.Left.Click")
	
																						
	rf.UI.frame.panePostTab = UI.CreateFrame ('Frame', 'RFPostTab', rf.UI.frame)
	rf.UI.frame.paneRaidTab = UI.CreateFrame ('Frame', 'RFRaidTab', rf.UI.frame)
	rf.UI.frame.panePlayerTab = UI.CreateFrame ('Frame', 'RFPlayerTab', rf.UI.frame)
	rf.UI.frame.paneStatusTab = UI.CreateFrame ('Frame', 'RFStatusTab', rf.UI.frame)
	rf.UI.frame.paneSettingsTab = UI.CreateFrame ('Frame', 'RFSettingsTab', rf.UI.frame)
	rf.UI.frame.paneInstructionsTab = UI.CreateFrame ('Frame', 'RFInstructionsTab', rf.UI.frame)
	
	rf.UI.frame.tabPane = EnKai.ui.nkTabpane('RFFrameTabPane', rf.UI.frame)
	rf.UI.frame.tabPane:SetBodyTexture('RaidFinder','gfx/tabPaneBG.png')
	rf.UI.frame.tabPane:SetWidth(928)
	rf.UI.frame.tabPane:SetHeight(512.5)
	rf.UI.frame.tabPane:SetHeaderTexture (true, 'RaidFinder', 'gfx/tabPaneHorizActive.png', 113, 28)
	rf.UI.frame.tabPane:SetHeaderTexture (false, 'RaidFinder', 'gfx/tabPaneHorizInActive.png', 113, 28)
	rf.UI.frame.tabPane:SetPoint("BOTTOMLEFT", rf.UI.frame,"BOTTOMLEFT",23,-20)
	rf.UI.frame.tabPane:SetVertical(false, true)
	rf.UI.frame.tabPane:SetLayer(1)
	
	
	rf.UI.frame.tabPane:AddPane({frame = rf.UI.frame.panePostTab, label = "Post", initFunc = function () rf.UI:setupPostTab() end})		
	rf.UI.frame.tabPane:AddPane({frame = rf.UI.frame.paneRaidTab, label = "Raids", initFunc = function () rf.UI:setupRaidTab() end})										
	rf.UI.frame.tabPane:AddPane({frame = rf.UI.frame.panePlayerTab, label = "Players", initFunc = function () rf.UI:setupPlayerTab() end})										
	rf.UI.frame.tabPane:AddPane({frame = rf.UI.frame.paneStatusTab, label = "Status", initFunc = function () rf.UI:setupStatusTab() end})
	rf.UI.frame.tabPane:AddPane({frame = rf.UI.frame.paneSettingsTab, label = "Settings", initFunc = function () rf.UI:setupSettingsTab() end})
	rf.UI.frame.tabPane:AddPane({frame = rf.UI.frame.paneInstructionsTab, label = "Instructions", initFunc = function () rf.UI:setupInstructionsTab() end})	
	
	rf.UI.frame.tabPane:UpdatePanes()
	
	
	
	Command.Event.Attach(EnKai.events['RFFrameTabPane'].TabPaneChanged, function (_, newValue)
	
		rf.activetab = newValue
		
		if rf.secure == true then return end
		
		if newValue == 4 then
			if rf.statusframe.grid ~= nil then rf.UI.frame.paneStatusTab.approveButton:SetVisible(true) end
			rf.UI.frame.panePostTab.btRaidPost:SetVisible(false)
		elseif newValue == 1 then
			rf.UI.frame.panePostTab.btRaidPost:SetVisible(true)
			if rf.statusframe.grid ~= nil then rf.UI.frame.paneStatusTab.approveButton:SetVisible(false) end
		else
			rf.UI.frame.panePostTab.btRaidPost:SetVisible(false)
			if rf.statusframe.grid ~= nil then rf.UI.frame.paneStatusTab.approveButton:SetVisible(false) end
		end
		
	end, 'RFFrameTabPane.TabPaneChanged')
		
	
	
	
	return rf.UI.frame
	
	
	
	
	
	
end

function rf.UI:setupPlayerTab()

	local frame = self.frame.panePlayerTab
	
	--Grid Background
	frame.gridBG = UI.CreateFrame('Texture', 'RFPlayerGridBack', frame)
	frame.gridBG:SetLayer(1)
	frame.gridBG:SetTextureAsync('RaidFinder', 'gfx/databaseGridBG.png')
	frame.gridBG:SetWidth(910)
	frame.gridBG:SetHeight(400)
	frame.gridBG:SetPoint("TOPLEFT", frame, "TOPLEFT", 7, 36)

	--Grid
	frame.grid = EnKai.uiCreateFrame("nkGrid", 'RFPlayerGrid', frame)
		
	frame.grid:SetPoint("TOPLEFT", frame.gridBG, "TOPLEFT", 13, 0)
	frame.grid:SetHeaderLabeLColor(0.925, 0.894, 0.741, 1)
	frame.grid:SetBorderColor(0, 0, 0, 1)
	frame.grid:SetBodyColor(.133, .133, .133, 1)
	frame.grid:SetBodyHighlightColor(.266, .266, .266, 1)
	frame.grid:SetLabelHighlightColor(1, 1, 1, 1)
	frame.grid:SetTransparentHeader()
	frame.grid:SetSelectable(true)
	frame.grid:SetLayer(3)
	frame.grid:SetHeaderHeight(25)
	frame.grid:SetHeaderFontSize(15)
	frame.grid:SetFontSize(13)
	
	frame.grid:SetSortable(true)

	local gridRows = 19
	
	local cols = rf.gridData.headers['players']
	
	frame.grid:SetVisible(false)	
	frame.grid:Layout (cols, gridRows)
	
	Command.Event.Attach(EnKai.events['RFPlayerGrid'].GridFinished, function ()
		rf.PlayergridUpdate(frame, frame.grid)
		frame.grid:SetVisible(true)
	end, 'RFPlayerGrid.GridFinished')
	 
	Command.Event.Attach(EnKai.events['RFPlayerGrid'].WheelForward, function (_, rowPos)
		frame.slider:AdjustValue (rowPos)
		
	 end, 'RFPlayerGrid.Grid.WheelForward')
	
	Command.Event.Attach(EnKai.events['RFPlayerGrid'].WheelBack, function (_, rowPos)
		frame.slider:AdjustValue (rowPos)

	 end, 'RFPlayerGrid.Grid.WheelBack')

	--apply
	
	frame.applybutton = EnKai.ui.nkButton("playerapply", frame)
	frame.applybutton:SetText("Apply to Invite")
	frame.applybutton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, -5)
	frame.applybutton:SetColor(.20, .65, .20, 1)
	frame.applybutton:SetFontColor( 0, 0, 0, 1 )
	frame.applybutton:SetLayer(5)

	local playerkey = nil

	frame.applybutton:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		local playername = Inspect.Unit.Detail("player").name
		local shard = Inspect.Shard().name
		local name = (playername .. "@" .. shard)
		
		playerkey = frame.grid:GetKey(frame.grid:GetSelectedRow())

		if playerkey == nil then print("You must select a player to invite.") return end
		if playerkey == name then print("You can't invite yourself!") return end 
		
		rf.apply("player",playerkey)		
		
	end, "playerapply.Left.Click")
	
	frame.applybutton:EventAttach(Event.UI.Input.Mouse.Left.Down, function (self)		
		frame.applybutton:SetScale(.95)
	end, "applybutton.button.Left.Down")
	
	frame.applybutton:EventAttach(Event.UI.Input.Mouse.Left.Up, function (self)		
		frame.applybutton:SetScale(1)
		frame.applybutton:SetText("Apply to Invite")
	end, "applybutton.button.Left.Up")
	
	frame.applybutton:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, function (self)		
		frame.applybutton:SetScale(1)
		frame.applybutton:SetText("Apply to Invite")
	end, "applybutton.button.Left.Upoutside")		
	
	
	
	--Slider
	
	frame.slider = EnKai.uiCreateFrame("nkScrollbox", 'RFPlayerGridSlider', frame)	
		
	frame.slider:SetPoint("TOPLEFT", frame.gridBG, "TOPRIGHT", -18, 25)
	frame.slider:SetHeight(frame.grid:GetHeight() - 25)
	frame.slider:SetRange(1, 1)
	frame.slider:SetVisible(false)
	frame.slider:SetLayer(2)
	frame.slider:SetColor( 0.925, 0.894, 0.741, 1 )
	
	Command.Event.Attach(EnKai.events['RFPlayerGridSlider'].ScrollboxChanged, function ()		
		frame.grid:SetRowPos(math.floor(frame.slider:GetValue('value')), true)
	end, 'RFPlayerGridSlider.ScrollboxChanged')	
	
	--Search
	
	frame.editSearchLabel = UI.CreateFrame ('Text', 'RFPlayerSearchLabel', frame)
	frame.editSearchLabel:SetText("Search")
	frame.editSearchLabel:SetFontColor(0.925, 0.894, 0.741, 1)
	frame.editSearchLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, 5)
	frame.editSearchLabel:SetWidth(70)
	frame.editSearchLabel:SetFontSize(13)
	frame.editSearchLabel:SetLayer(2)
	
	frame.editSearch = EnKai.uiCreateFrame("nkTextfield", 'RFPlayerSearch', frame)	
	frame.editSearch:SetPoint("CENTERLEFT", frame.editSearchLabel, "CENTERRIGHT")
	frame.editSearch:SetWidth(150)
	frame.editSearch:SetHeight(22)
	frame.editSearch:SetColor(0.925, 0.894, 0.741, 1)
	frame.editSearch:SetText( "" )
	frame.editSearch:SetLayer(2)
	
	Command.Event.Attach(EnKai.events['RFPlayerSearch'].TextfieldChanged, function (_, newValue)		
		rf.search(frame, frame.grid, false)
	end, 'RFPlayerSearch.TextfieldChanged')
	
	frame.resetSearch = UI.CreateFrame('Texture', 'RFPlayerSearchReset', frame)
	frame.resetSearch:SetTextureAsync("RaidFinder", "gfx/iconCancel.png")
	frame.resetSearch:SetPoint("CENTERLEFT", frame.editSearch, "CENTERRIGHT", 5, 0)
	frame.resetSearch:SetLayer(2)
	
	frame.resetSearch:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		rf.search(frame, frame.grid, true)
	end, "RFPlayerSearchReset.Left.Click")
	
	--Class
	local classselection = rf.gridData.selection["Class"]
		
	frame.classSelect = EnKai.uiCreateFrame("nkCombobox", 'SelPlayerClass', frame)
	frame.classSelect:SetPoint("CENTERLEFT", frame.editSearch, "CENTERRIGHT", 30, 1)
	frame.classSelect:SetWidth(100)
	frame.classSelect:SetLabelWidth(0)
	frame.classSelect:SetSelection(classselection)
	frame.classSelect:SetSelectedValue("All")
	frame.classSelect:SetColor (0.925, 0.894, 0.741, 1 )
	frame.classSelect:SetLabelColor(0.925, 0.894, 0.741, 1)
	frame.classSelect:SetLayer(4)
	
	Command.Event.Attach(EnKai.events['SelPlayerClass'].ComboChanged, function (_, newValue)
		rf.PlayergridUpdate(frame, frame.grid)
	end, 'SelPlayerClass.ComboChanged')

	--Role
	local roleselection = rf.gridData.selection["Role"]
		
	frame.roleSelect = EnKai.uiCreateFrame("nkCombobox", 'SelPlayerRole', frame)
	frame.roleSelect:SetPoint("CENTERLEFT", frame.classSelect, "CENTERRIGHT", 15, 0)
	frame.roleSelect:SetWidth(100)
	frame.roleSelect:SetLabelWidth(0)
	frame.roleSelect:SetSelection(roleselection)
	frame.roleSelect:SetSelectedValue("All")
	frame.roleSelect:SetColor (0.925, 0.894, 0.741, 1 )
	frame.roleSelect:SetLabelColor(0.925, 0.894, 0.741, 1)
	frame.roleSelect:SetLayer(4)
	
	Command.Event.Attach(EnKai.events['SelPlayerRole'].ComboChanged, function (_, newValue)
		rf.PlayergridUpdate(frame, frame.grid)
	end, 'SelPlayerRole.ComboChanged')

	--lookingfor
	local typeselection = rf.gridData.selection["Type"]
		
	frame.typeselection = EnKai.uiCreateFrame("nkCombobox", 'SelPlayerType', frame)
	frame.typeselection:SetPoint("CENTERLEFT", frame.roleSelect, "CENTERRIGHT", 15, 0)
	frame.typeselection:SetWidth(100)
	frame.typeselection:SetLabelWidth(0)
	frame.typeselection:SetSelection(typeselection)
	frame.typeselection:SetSelectedValue("All")
	frame.typeselection:SetColor (0.925, 0.894, 0.741, 1 )
	frame.typeselection:SetLabelColor(0.925, 0.894, 0.741, 1)
	frame.typeselection:SetLayer(4)
	
	Command.Event.Attach(EnKai.events['SelPlayerType'].ComboChanged, function (_, newValue)
		rf.PlayergridUpdate(frame, frame.grid)
	end, 'SelPlayerType.ComboChanged')	
	
	--Friends check
	frame.friendsCheckbox = EnKai.uiCreateFrame("nkCheckbox", 'cbFriends', frame)
	frame.friendsCheckbox:SetText("Friends Only")
	frame.friendsCheckbox:SetChecked(false)
	frame.friendsCheckbox:SetPoint("CENTERLEFT", frame.typeselection, "CENTERRIGHT", 10, 0)
	frame.friendsCheckbox:SetColor (0.925, 0.894, 0.741, 1 )
	frame.friendsCheckbox:SetLabelColor(0.925, 0.894, 0.741, 1 )
	frame.friendsCheckbox:SetLayer(2)
	
	Command.Event.Attach(EnKai.events['cbFriends'].CheckboxChanged, function (_, newValue) rf.PlayergridUpdate(frame, frame.grid) end, 'cbFriends.CheckboxChanged')
	
	--close
											
	frame.closeButton = UI.CreateFrame("RiftButton", 'PlayerTabClose', frame)
	frame.closeButton:SetText("Close")
	frame.closeButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, -5)
	frame.closeButton:SetLayer(2)
	
	frame.closeButton:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		rf.UI.closeUI()
	end, "PlayerTabClose.Left.Click")
	
	
	rf.playerframe = frame	
end

function rf.UI:setupRaidTab()

	local frame = self.frame.paneRaidTab
	
	--Grid Background
	frame.gridBG = UI.CreateFrame('Texture', 'RFRaidGridBack', frame)
	frame.gridBG:SetLayer(1)
	frame.gridBG:SetTextureAsync('RaidFinder', 'gfx/databaseGridBG.png')
	frame.gridBG:SetWidth(910)
	frame.gridBG:SetHeight(400)
	frame.gridBG:SetPoint("TOPLEFT", frame, "TOPLEFT", 7, 36)

	--Grid
	frame.grid = EnKai.uiCreateFrame("nkGrid", 'RFRaidGrid', frame)
		
	frame.grid:SetPoint("TOPLEFT", frame.gridBG, "TOPLEFT", 13, 0)
	frame.grid:SetHeaderLabeLColor(0.925, 0.894, 0.741, 1)
	frame.grid:SetBorderColor(0, 0, 0, 1)
	frame.grid:SetBodyColor(.133, .133, .133, 1)
	frame.grid:SetTransparentHeader()
	frame.grid:SetSelectable(true)
	frame.grid:SetLayer(3)
	frame.grid:SetHeaderHeight(25)
	frame.grid:SetHeaderFontSize(15)
	frame.grid:SetFontSize(13)
	
	frame.grid:SetSortable(true)

	local gridRows = 19
	
	local cols = rf.gridData.headers['raids']
	
	frame.grid:SetVisible(false)	
	frame.grid:Layout (cols, gridRows)
	
	Command.Event.Attach(EnKai.events['RFRaidGrid'].GridFinished, function ()
		rf.RaidgridUpdate(frame, frame.grid)
		frame.grid:SetVisible(true)
	end, 'RFRaidGrid.GridFinished')
	 
	Command.Event.Attach(EnKai.events['RFRaidGrid'].WheelForward, function (_, rowPos)
		frame.slider:AdjustValue (rowPos)
		
	 end, 'RFRaidGrid.Grid.WheelForward')
	
	Command.Event.Attach(EnKai.events['RFRaidGrid'].WheelBack, function (_, rowPos)
		frame.slider:AdjustValue (rowPos)

	 end, 'RFRaidGrid.Grid.WheelBack')

	--Slider
	
	frame.slider = EnKai.uiCreateFrame("nkScrollbox", 'RFRaidGridSlider', frame)	
		
	frame.slider:SetPoint("TOPLEFT", frame.gridBG, "TOPRIGHT", -18, 25)
	frame.slider:SetHeight(frame.grid:GetHeight() - 25)
	frame.slider:SetRange(1, 1)
	frame.slider:SetVisible(false)
	frame.slider:SetLayer(2)
	frame.slider:SetColor( 0.925, 0.894, 0.741, 1 )
	
	Command.Event.Attach(EnKai.events['RFRaidGridSlider'].ScrollboxChanged, function ()		
		frame.grid:SetRowPos(math.floor(frame.slider:GetValue('value')), true)
	end, 'RFRaidGridSlider.ScrollboxChanged')	
	
	--Search
	
	frame.editSearchLabel = UI.CreateFrame ('Text', 'RFRaidSearchLabel', frame)
	frame.editSearchLabel:SetText("Search")
	frame.editSearchLabel:SetFontColor(0.925, 0.894, 0.741, 1)
	frame.editSearchLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, 5)
	frame.editSearchLabel:SetWidth(70)
	frame.editSearchLabel:SetFontSize(13)
	frame.editSearchLabel:SetLayer(2)
	
	frame.editSearch = EnKai.uiCreateFrame("nkTextfield", 'RFRaidSearch', frame)	
	frame.editSearch:SetPoint("CENTERLEFT", frame.editSearchLabel, "CENTERRIGHT")
	frame.editSearch:SetWidth(150)
	frame.editSearch:SetHeight(22)
	frame.editSearch:SetColor(0.925, 0.894, 0.741, 1)
	frame.editSearch:SetText( "" )
	frame.editSearch:SetLayer(2)
	
	Command.Event.Attach(EnKai.events['RFRaidSearch'].TextfieldChanged, function (_, newValue)		
		rf.search(frame, frame.grid, false)
	end, 'RFRaidSearch.TextfieldChanged')
	
	frame.resetSearch = UI.CreateFrame('Texture', 'RFRaidSearchReset', frame)
	frame.resetSearch:SetTextureAsync("RaidFinder", "gfx/iconCancel.png")
	frame.resetSearch:SetPoint("CENTERLEFT", frame.editSearch, "CENTERRIGHT", 5, 0)
	frame.resetSearch:SetLayer(2)
	
	frame.resetSearch:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		rf.search(frame, frame.grid, true)
	end, "RFRaidSearchReset.Left.Click")
	
	--Class
	local typeselection = rf.gridData.selection["Type"]
		
	frame.typeSelect = EnKai.uiCreateFrame("nkCombobox", 'SelRaidtype', frame)
	frame.typeSelect:SetPoint("CENTERLEFT", frame.editSearch, "CENTERRIGHT", 30, 1)
	frame.typeSelect:SetWidth(100)
	frame.typeSelect:SetLabelWidth(0)
	frame.typeSelect:SetSelection(typeselection)
	frame.typeSelect:SetSelectedValue("All")
	frame.typeSelect:SetColor (0.925, 0.894, 0.741, 1 )
	frame.typeSelect:SetLabelColor(0.925, 0.894, 0.741, 1)
	frame.typeSelect:SetLayer(4)
	
	Command.Event.Attach(EnKai.events['SelRaidtype'].ComboChanged, function (_, newValue)
		rf.RaidgridUpdate(frame, frame.grid)
	end, 'SelRaidtype.ComboChanged')
	
	--loot
	local lootselection = rf.gridData.selection["Loot"]
		
	frame.lootSelect = EnKai.uiCreateFrame("nkCombobox", 'SelRaidloot', frame)
	frame.lootSelect:SetPoint("CENTERLEFT", frame.typeSelect, "CENTERRIGHT", 20, 1)
	frame.lootSelect:SetWidth(100)
	frame.lootSelect:SetLabelWidth(0)
	frame.lootSelect:SetSelection(lootselection)
	frame.lootSelect:SetSelectedValue("All")
	frame.lootSelect:SetColor (0.925, 0.894, 0.741, 1 )
	frame.lootSelect:SetLabelColor(0.925, 0.894, 0.741, 1)
	frame.lootSelect:SetLayer(4)
	
	Command.Event.Attach(EnKai.events['SelRaidloot'].ComboChanged, function (_, newValue)
		rf.RaidgridUpdate(frame, frame.grid)
	end, 'SelRaidloot.ComboChanged')

	--Role
	local roleselection = rf.gridData.selection["Role"]
		
	frame.roleSelect = EnKai.uiCreateFrame("nkCombobox", 'SelRaidRole', frame)
	frame.roleSelect:SetPoint("CENTERLEFT", frame.lootSelect, "CENTERRIGHT", 20, 1)
	frame.roleSelect:SetWidth(100)
	frame.roleSelect:SetLabelWidth(0)
	frame.roleSelect:SetSelection(roleselection)
	frame.roleSelect:SetSelectedValue("All")
	frame.roleSelect:SetColor (0.925, 0.894, 0.741, 1 )
	frame.roleSelect:SetLabelColor(0.925, 0.894, 0.741, 1)
	frame.roleSelect:SetLayer(4)
	
	Command.Event.Attach(EnKai.events['SelRaidRole'].ComboChanged, function (_, newValue)
		rf.RaidgridUpdate(frame, frame.grid)
	end, 'SelRaidRole.ComboChanged')

	--apply
	
	frame.applybutton = EnKai.ui.nkButton("RFraidapply", frame)
	frame.applybutton:SetText("Apply To Join")
	frame.applybutton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, -5)
	frame.applybutton:SetColor(.20, .65, .20, 1)
	frame.applybutton:SetFontColor( 0, 0, 0, 1 )
	frame.applybutton:SetLayer(5)

	local raidkey = nil
	
	frame.applybutton:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		local playername = Inspect.Unit.Detail("player").name
		local shard = Inspect.Shard().name
		local name = (playername .. "@" .. shard)
		
		 
		
		raidkey = frame.grid:GetKey(frame.grid:GetSelectedRow())
	
		if raidkey == nil then print("You must select a Raid to join.") return end
		if raidkey == name then print("You can't invite yourself!") return end
		
		rf.apply("raid",raidkey)		
		
	end, "RFraidapply.Left.Click")
	
	frame.applybutton:EventAttach(Event.UI.Input.Mouse.Left.Down, function (self)		
		frame.applybutton:SetScale(.95)
	end, "applybutton.button.Left.Down")
	
	frame.applybutton:EventAttach(Event.UI.Input.Mouse.Left.Up, function (self)		
		frame.applybutton:SetScale(1)
		frame.applybutton:SetText("Apply To Join")
	end, "applybutton.button.Left.Up")
	
	frame.applybutton:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, function (self)		
		frame.applybutton:SetScale(1)
		frame.applybutton:SetText("Apply To Join")
	end, "applybutton.button.Left.Upoutside")	
	
	
	--close
											
	frame.closeButton = UI.CreateFrame("RiftButton", 'RaidTabClose', frame)
	frame.closeButton:SetText("Close")
	frame.closeButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, -5)
	frame.closeButton:SetLayer(2)
	
	frame.closeButton:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		rf.UI.closeUI()
	end, "RaidTabClose.Left.Click")
	rf.raidframe = frame	
end

function rf.UI:setupSettingsTab()

	local frame = self.frame.paneSettingsTab

	frame.AboutBG = UI.CreateFrame('Texture', 'RFAboutBG', frame)
	frame.AboutBG:SetLayer(1)
	frame.AboutBG:SetTexture('RaidFinder', 'gfx/TabPaneBG.png')
	frame.AboutBG:SetWidth(655)
	frame.AboutBG:SetHeight(400)
	frame.AboutBG:SetPoint("TOPLEFT", frame, "TOPLEFT", 7, 36)	
	
	frame.SettingsBG = UI.CreateFrame('Texture', 'RFSettingsBG', frame)
	frame.SettingsBG:SetLayer(1)
	frame.SettingsBG:SetTexture('RaidFinder', 'gfx/TabPaneBG.png')
	frame.SettingsBG:SetWidth(255)
	frame.SettingsBG:SetHeight(400)
	frame.SettingsBG:SetPoint("TOPLEFT", frame.AboutBG, "TOPRIGHT", 0, 0)	

--About
	
	frame.addonName = UI.CreateFrame("Text", "RF.UI.About.addonName", frame.AboutBG)
	frame.version = UI.CreateFrame("Text", "RF.UI.About.version", frame.AboutBG)
	frame.writtenBy = UI.CreateFrame("Text", "RF.UI.About.writteBy", frame.AboutBG)
	frame.copyright = UI.CreateFrame("Text", "RF.UI.About.copyright", frame.AboutBG)
	frame.modules = UI.CreateFrame("Text", "RF.UI.About.modules", frame.AboutBG)
	frame.instructions = UI.CreateFrame("Text", "RF.UI.About.instructions", frame.AboutBG)
	frame.instructions2 = UI.CreateFrame("Text", "RF.UI.About.instructions2", frame.AboutBG)
	frame.thanks = UI.CreateFrame("Text", "RF.UI.About.thanks", frame.AboutBG)

	
	
	frame.addonName:SetPoint("TOPCENTER", frame.AboutBG, "TOPCENTER", 0, 40)
	frame.addonName:SetText(addonInfo.toc.Identifier)
	frame.addonName:SetFontSize(30)
	frame.addonName:SetFontColor(0.906, 0.784, 0.471, 1)
	frame.addonName:SetEffectGlow({ offsetX = 2, offsetY = 2})
	
	frame.version:SetPoint("TOPCENTER", frame.addonName, "BOTTOMCENTER")
	frame.version:SetText("Version " .. addonInfo.toc.Version)
	frame.version:SetFontSize(18)
	frame.version:SetFontColor(0.906, 0.784, 0.471, 1)
	frame.version:SetEffectGlow({ offsetX = 2, offsetY = 2})

	frame.writtenBy:SetPoint("TOPCENTER", frame.version, "BOTTOMCENTER", 0, 10)
	frame.writtenBy:SetText("Written By Redcruxs (Vexxx@Greybriar)")
	frame.writtenBy:SetFontSize(16)
	frame.writtenBy:SetFontColor(1, 1, 1, 1)
	
	frame.instructions:SetPoint("TOPCENTER", frame.thanks, "BOTTOMCENTER", 0, 40)
	frame.instructions:SetText("Please spread the word about this addon.")
	frame.instructions:SetFontSize(20)
	frame.instructions:SetFontColor(0.906, 0.784, 0.471, 1)
	frame.instructions:SetEffectGlow({ offsetX = 2, offsetY = 2})

	
	frame.instructions2:SetPoint("TOPCENTER", frame.instructions, "BOTTOMCENTER", 0, 0)
	frame.instructions2:SetText("The more people who use it, the better it will be!")
	frame.instructions2:SetFontSize(20)
	frame.instructions2:SetFontColor(0.906, 0.784, 0.471, 1)
	frame.instructions2:SetEffectGlow({ offsetX = 2, offsetY = 2})

	

	frame.thanks:SetPoint("TOPCENTER", frame.writtenBy, "BOTTOMCENTER", 0, 10)
	frame.thanks:SetText("Special Thanks to Naifu for the EnKai Library!")
	frame.thanks:SetFontSize(14)
	frame.thanks:SetFontColor(1, 1, 1, 1)
	
	--Settings
		--lock
	frame.lockCheckbox = EnKai.uiCreateFrame("nkCheckbox", 'cblock', frame.SettingsBG)
	frame.lockCheckbox:SetText("Lock Button")
	frame.lockCheckbox:SetChecked(rfsettings.UIlock)
	frame.lockCheckbox:SetPoint("TOPLEFT", frame.SettingsBG, "TOPLEFT", 10, 50)
	frame.lockCheckbox:SetColor (0.925, 0.894, 0.741, 1 )
	frame.lockCheckbox:SetLabelColor(0.925, 0.894, 0.741, 1 )
	frame.lockCheckbox:SetLayer(2)
	frame.lockCheckbox:SetLabelInFront(false)
	frame.lockCheckbox:AutoSizeLabel()
	
	Command.Event.Attach(EnKai.events['cblock'].CheckboxChanged, function (_, newValue)
		if frame.lockCheckbox:GetChecked() == true then
			rfsettings.UIlock = true
		else
			rfsettings.UIlock = false
		end
	end, 'cblock.CheckboxChanged')
		
	--flash
	frame.flashCheckbox = EnKai.uiCreateFrame("nkCheckbox", 'cbflash', frame.SettingsBG)
	frame.flashCheckbox:SetText("Enable Button Flash")
	frame.flashCheckbox:SetChecked(rfsettings.flash)
	frame.flashCheckbox:SetPoint("TOPLEFT", frame.lockCheckbox, "TOPLEFT", 0, 30)
	frame.flashCheckbox:SetColor (0.925, 0.894, 0.741, 1 )
	frame.flashCheckbox:SetLabelColor(0.925, 0.894, 0.741, 1 )
	frame.flashCheckbox:SetLayer(2)
	frame.flashCheckbox:SetLabelInFront(false)
	frame.flashCheckbox:AutoSizeLabel()
	
	Command.Event.Attach(EnKai.events['cbflash'].CheckboxChanged, function (_, newValue)
		if frame.flashCheckbox:GetChecked() == true then
			rfsettings.flash = true
		else
			rfsettings.flash = false
		end
	end, 'cbflash.CheckboxChanged')
	
	--text
	frame.textCheckbox = EnKai.uiCreateFrame("nkCheckbox", 'cbtext', frame.SettingsBG)
	frame.textCheckbox:SetText("Enable Text-based Alerts")
	frame.textCheckbox:SetChecked(rfsettings.textnotify)
	frame.textCheckbox:SetPoint("TOPLEFT", frame.flashCheckbox, "TOPLEFT", 0, 30)
	frame.textCheckbox:SetColor (0.925, 0.894, 0.741, 1 )
	frame.textCheckbox:SetLabelColor(0.925, 0.894, 0.741, 1 )
	frame.textCheckbox:SetLayer(2)
	frame.textCheckbox:SetLabelInFront(false)
	frame.textCheckbox:AutoSizeLabel()
	
	Command.Event.Attach(EnKai.events['cbtext'].CheckboxChanged, function (_, newValue)
		if frame.textCheckbox:GetChecked() == true then
			rfsettings.textnotify = true
		else
			rfsettings.textnotify = false
		end
	end, 'cbtext.CheckboxChanged')
	
	--close
											
	frame.closeButton = UI.CreateFrame("RiftButton", 'RaidTabClose', frame)
	frame.closeButton:SetText("Close")
	frame.closeButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, -5)
	frame.closeButton:SetLayer(2)
	
	frame.closeButton:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		rf.UI.closeUI()
	end, "RaidTabClose.Left.Click")
	
end

function rf.UI:setupInstructionsTab()

	local frame = self.frame.paneInstructionsTab

	local instmanual = EnKai.docEmbedded("Instructions", frame)
	
	instmanual:SetPoint("TOPLEFT", frame, "TOPLEFT",7,35)
	instmanual:SetWidth(925)
	
	instmanual:Layout(21)
		
	local manual = { { 	parent = nil,
						title = ") Adjusting the UI",
						content = {	{	type = 'text',
										text = 'To move the button, unlock it in the settings, then hold down right click and drag it. \n\n To adjust the size of the button simply scroll the middle wheel of your mouse while hovering over the button while it is unlocked.',
									},
								},
					},
					{ 	parent = nil,
						title = ") To Form a Raid",
						content = {	{	type = 'header',
										text = 'Step 1 - ',
									},
									{	type = 'text',
										text = 'First, in the Post tab, setup your raids preferences in the bottom panel including type, loot options, the roles you are looking for. Make sure to press Enter to save your raids note.',
									},
									{	type = 'header',
										text = 'Step 2 - ',
									},
									{	type = 'text',
										text = 'Press the LFM - Post button to start broadcasting your raid across all shards. If you would like to stop broadcasting, press the Stop Posting button at the bottom.',
									},
									{	type = 'header',
										text = 'Step 3 - ',
									},
									{	type = 'text',
										text = 'Next you wait. If you would like to browse and invite players who are looking for raids simply search through the Players tab for the players who might be interested in your raid. Click Apply to Invite button if you want to ask a player to join you.',
									},
									{	type = 'header',
										text = 'Step 4 - ',
									},
									{	type = 'text',
										text = 'If a player wants to join you, or if you select a player you would like to invite, you can manage the status of their invites in the status tab. The RF button will flash if a player is added to your status tab or gets updated. In the status tab you can manage your invitations with the Deny/Clear and Approve/Invite buttons. When a player is ready for invite, clicking the Approve/Invite button will invite them, there is no need to manually invite players.',
									},
								},
					},
					{ 	parent = nil,
						title = ") To Find a Raid",
						content = {	{	type = 'header',
										text = 'Step 1 - ',
									},
									{	type = 'text',
										text = 'First, in the Post tab, setup your preferences in the top panel including the roles you play and the raids are looking for. Make sure to press Enter to save your note.',
									},
									{	type = 'header',
										text = 'Step 2 - ',
									},
									{	type = 'text',
										text = 'Press the LFG - Post button to start broadcasting yourself across all shards. If you would like to stop broadcasting, press the Stop Posting button at the bottom.',
									},
									{	type = 'header',
										text = 'Step 3 - ',
									},
									{	type = 'text',
										text = 'Next you wait. If you would like to browse through raids and ask them to invite you simply search through the Raids tab for the raids who might be interested in you. Click Apply to Join button if you want to ask a raid to invite you.',
									},
									{	type = 'header',
										text = 'Step 4 - ',
									},
									{	type = 'text',
										text = 'If a raid wants to invite you, or if you select a raid you would like to join, you can manage the status of these invites in the status tab. The RF button will flash if a raid is added to your status tab or gets updated. In the status tab you can manage your invitations with the Deny/Clear and Approve/Invite buttons.',
									},
								},
					},
					{ 	parent = nil,
						title = ") Understanding the Status tab",
						content = {	{	type = 'text',
										text = ("The purpose of the status tab is to manage the back and forth communications between players and raids to streamline the invitation process." ..
										"\n\n<u>As a raid leader:</u>" ..
										"\n<u>To Invite a Player:</u>" ..
										"\n1. Leader selects player in player tab, clicks Apply to Invite." ..
										"\n2. Player sees raids invite in the status tab and clicks Approve/Invite." .. 
										--"\n3. Player agrees that they are 100% ready for invite (aka not in group) by clicking Approve/Invite." .. 
										"\n3. Leader sees players status as *Ready for Invite* and then clicks Approve/Invite." .. 
										"\n4. Player gets invited." .. 
										"\n<u>If a Player wants to Join you:</u>" .. 
										"\n1. Leader sees Players application in the status tab and clicks Approve/Invite." .. 
										--"\n2. Player agrees that they are 100% ready for invite (aka not in group) by clicking Approve/Invite." .. 
										--"\n3. Leader sees players status as *Ready for Invite* and then clicks Approve/Invite." .. 
										"\n2. Player gets invited." .. 										
										"\n\n<u>As a player:</u>" .. 
										"\n<u>To Join a Raid:</u>" .. 
										"\n1. Player selects raid in Raid Tab ..  click Apply to Join." .. 
										"\n2. Leader will see your invite in the status tab and click Approve/Invite." .. 
										--"\n3. You will agree that you are 100% ready for invite (aka not in group) by clicking Approve/Invite." .. 
										"\n3. You will then receive an invite shortly." .. 								
										"\n<u>If a raid wants to invite you:</u>" .. 
										"\n1. You will click Approve/Invite if you want to join them." .. 
										"\n2. Leader will see you as Ready for Invite and you will receive an invite shortly." .. 
										"\n\n Clicking the Deny/Clear button at any time will remove them from your status tab and remove you from their status tab silently.")
									},
								},
					},
				}
	
	
	
	
	for _, chapter in pairs (manual) do
		instmanual:AddChapter(chapter.parent, chapter.title, chapter.content, true)		
	end

	

	
	--close
											
	frame.closeButton = UI.CreateFrame("RiftButton", 'RaidTabClose', frame)
	frame.closeButton:SetText("Close")
	frame.closeButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, -5)
	frame.closeButton:SetLayer(2)
	
	frame.closeButton:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		rf.UI.closeUI()
	end, "RaidTabClose.Left.Click")
	
end

function rf.UI:setupPostTab()
	rf.playerdata()
	rf.raiddata()
	
	local frame = rf.UI.frame.panePostTab
	local tank =  ""
	local dps = ""
	local support = ""
	local heal =  ""
	

	frame.PostPlayerBG = UI.CreateFrame('Texture', 'RFPostPlayerBack', frame)
	frame.PostPlayerBG:SetLayer(1)
	frame.PostPlayerBG:SetTexture('RaidFinder', 'gfx/TabPaneBG.png')
	frame.PostPlayerBG:SetWidth(910)
	frame.PostPlayerBG:SetHeight(200)
	frame.PostPlayerBG:SetPoint("TOPLEFT", frame, "TOPLEFT", 7, 36)
	
	
	frame.PostRaidBG = UI.CreateFrame('Texture', 'RFPostRaidBack', frame)
	frame.PostRaidBG:SetLayer(1)
	frame.PostRaidBG:SetTexture('RaidFinder', 'gfx/TabPaneBG.png')
	frame.PostRaidBG:SetWidth(910)
	frame.PostRaidBG:SetHeight(200)
	frame.PostRaidBG:SetPoint("TOPLEFT", frame.PostPlayerBG, "BOTTOMLEFT", 0, 1)
	
	--Player Setup
	frame.namehead = UI.CreateFrame("Text", "RFpostplayername", frame.PostPlayerBG)
	
	frame.namehead:SetPoint("TOPLEFT", frame.PostPlayerBG, "TOPLEFT",20,20)
	frame.namehead:SetText("Name:")
	frame.namehead:SetFontSize(16)
	frame.namehead:SetFontColor(0.906, 0.784, 0.471, 1)
	frame.namehead:SetEffectGlow({ offsetX = 2, offsetY = 2})	
	frame.namehead:SetLayer(2)
	
	frame.nametext = UI.CreateFrame("Text", "RFplayernametext", frame.PostPlayerBG)
	
	frame.nametext:SetPoint("TOPLEFT", frame.namehead, "TOPRIGHT", 5, 0)
	frame.nametext:SetText(rfsettings.playerdata.name)
	frame.nametext:SetFontSize(14)
	frame.nametext:SetFontColor(1, 1, 1, 1)
	frame.nametext:SetLayer(2)
	
	
	
	frame.classhead = UI.CreateFrame("Text", "RFpostplayerclass", frame.PostPlayerBG)
	
	frame.classhead:SetPoint("TOPLEFT", frame.namehead, "BOTTOMLEFT",0,5)
	frame.classhead:SetText("Class:")
	frame.classhead:SetFontSize(16)
	frame.classhead:SetFontColor(0.906, 0.784, 0.471, 1)
	frame.classhead:SetEffectGlow({ offsetX = 2, offsetY = 2})
	frame.classhead:SetLayer(2)
	
	frame.classtext = UI.CreateFrame("Text", "RFplayerclasstext", frame.PostPlayerBG)
	
	frame.classtext:SetPoint("TOPLEFT", frame.classhead, "TOPRIGHT", 5, 0)
	frame.classtext:SetText(rfsettings.playerdata.class)
	frame.classtext:SetFontSize(14)
	frame.classtext:SetFontColor(1, 1, 1, 1)
	frame.classtext:SetLayer(2)
	
	frame.exphead = UI.CreateFrame("Text", "RFpostplayerexp", frame.PostPlayerBG)
	
	frame.exphead:SetPoint("TOPLEFT", frame.classhead, "BOTTOMLEFT",0,5)
	frame.exphead:SetText("Experience:")
	frame.exphead:SetFontSize(16)
	frame.exphead:SetFontColor(0.906, 0.784, 0.471, 1)
	frame.exphead:SetEffectGlow({ offsetX = 2, offsetY = 2})
	
	frame.exptext = UI.CreateFrame("Text", "RFplayerexptext", frame.PostPlayerBG)
	
	frame.exptext:SetPoint("TOPLEFT", frame.exphead, "TOPRIGHT", 5, 0)
	frame.exptext:SetText("[" .. (rfsettings.playerdata.achiev.tdq + rfsettings.playerdata.achiev.ft + rfsettings.playerdata.achiev.ee) .. "/13]" .. "[" .. (rfsettings.playerdata.achiev.ga + rfsettings.playerdata.achiev.ig + rfsettings.playerdata.achiev.pb) .. "/12]")
	frame.exptext:SetFontSize(14)
	frame.exptext:SetFontColor(1, 1, 1, 1)
	
	frame.hithead = UI.CreateFrame("Text", "RFpostplayerhit", frame.PostPlayerBG)
	
	frame.hithead:SetPoint("TOPLEFT", frame.exphead, "BOTTOMLEFT",0,5)
	frame.hithead:SetText("Hit:")
	frame.hithead:SetFontSize(16)
	frame.hithead:SetFontColor(0.906, 0.784, 0.471, 1)
	frame.hithead:SetEffectGlow({ offsetX = 2, offsetY = 2})
	
	frame.hittext = UI.CreateFrame("Text", "RFplayerhittext", frame.PostPlayerBG)
	
	frame.hittext:SetPoint("TOPLEFT", frame.hithead, "TOPRIGHT", 5, 0)
	frame.hittext:SetText(tostring(Inspect.Stat("hitUnbuffed")))
	frame.hittext:SetFontSize(14)
	frame.hittext:SetFontColor(1, 1, 1, 1)
	
	
	frame.rolehead = UI.CreateFrame("Text", "RFpostplayerrole", frame.PostPlayerBG)
	
	frame.rolehead:SetPoint("TOPLEFT", frame.hithead, "BOTTOMLEFT",0,5)
	frame.rolehead:SetText("Roles:")
	frame.rolehead:SetFontSize(16)
	frame.rolehead:SetFontColor(0.906, 0.784, 0.471, 1)
	frame.rolehead:SetEffectGlow({ offsetX = 2, offsetY = 2})
	
	frame.tank = EnKai.uiCreateFrame("nkCheckbox", 'tank', frame.PostPlayerBG)
	frame.tank:SetText("Tank")
	frame.tank:SetChecked(rfsettings.playerdata.roles.tank)
	frame.tank:SetPoint("TOPLEFT", frame.rolehead, "TOPRIGHT", 10, 0)
	frame.tank:SetColor (0.925, 0.894, 0.741, 1 )
	frame.tank:SetLabelColor(1, 1, 1, 1 )
	frame.tank:SetLayer(2)
	frame.tank:SetLabelWidth(40)	
	Command.Event.Attach(EnKai.events['tank'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'tank.CheckboxChanged')
	
	frame.heal = EnKai.uiCreateFrame("nkCheckbox", 'heal', frame.PostPlayerBG)
	frame.heal:SetText("Heal")
	frame.heal:SetChecked(rfsettings.playerdata.roles.heal)
	frame.heal:SetPoint("TOPLEFT", frame.tank, "TOPRIGHT", 10, 0)
	frame.heal:SetColor (0.925, 0.894, 0.741, 1 )
	frame.heal:SetLabelColor(1, 1, 1, 1 )
	frame.heal:SetLayer(2)
	frame.heal:SetLabelWidth(55)	
	Command.Event.Attach(EnKai.events['heal'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'heal.CheckboxChanged')	
	
	frame.dps = EnKai.uiCreateFrame("nkCheckbox", 'dps', frame.PostPlayerBG)
	frame.dps:SetText("DPS")
	frame.dps:SetChecked(rfsettings.playerdata.roles.dps)
	frame.dps:SetPoint("TOPLEFT", frame.rolehead, "TOPRIGHT", 10, 20)
	frame.dps:SetColor (0.925, 0.894, 0.741, 1 )
	frame.dps:SetLabelColor(1, 1, 1, 1 )
	frame.dps:SetLayer(2)
	frame.dps:SetLabelWidth(40)	
	Command.Event.Attach(EnKai.events['dps'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'dps.CheckboxChanged')
	
	frame.support = EnKai.uiCreateFrame("nkCheckbox", 'support', frame.PostPlayerBG)
	frame.support:SetText("Support")
	frame.support:SetChecked(rfsettings.playerdata.roles.support)
	frame.support:SetPoint("TOPLEFT", frame.dps, "TOPRIGHT", 10, 0)
	frame.support:SetColor (0.925, 0.894, 0.741, 1 )
	frame.support:SetLabelColor(1, 1, 1, 1 )
	frame.support:SetLayer(2)
	frame.support:SetLabelWidth(55)	
	Command.Event.Attach(EnKai.events['support'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'support.CheckboxChanged')		
	
	frame.lookingforhead = UI.CreateFrame("Text", "RFpostplayerlookingfor", frame.PostPlayerBG)
	
	frame.lookingforhead:SetPoint("TOPLEFT", frame.PostPlayerBG, "TOPLEFT",250,20)
	frame.lookingforhead:SetText("Looking For:")
	frame.lookingforhead:SetFontSize(16)
	frame.lookingforhead:SetFontColor(0.906, 0.784, 0.471, 1)
	frame.lookingforhead:SetEffectGlow({ offsetX = 2, offsetY = 2})	
	
	frame.LFTDQ = EnKai.uiCreateFrame("nkCheckbox", 'LFTDQ', frame.PostPlayerBG)
	frame.LFTDQ:SetText("TDQ")
	frame.LFTDQ:SetChecked(rfsettings.playerdata.lookingfor.tdq)
	frame.LFTDQ:SetPoint("TOPLEFT", frame.lookingforhead, "BOTTOMLEFT", 0, 5)
	frame.LFTDQ:SetColor (0.925, 0.894, 0.741, 1 )
	frame.LFTDQ:SetLabelColor(1, 1, 1, 1 )
	frame.LFTDQ:SetLayer(2)
	frame.LFTDQ:SetLabelWidth(40)
	Command.Event.Attach(EnKai.events['LFTDQ'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'LFTDQ.CheckboxChanged')
	
	frame.LFFT = EnKai.uiCreateFrame("nkCheckbox", 'LFFT', frame.PostPlayerBG)
	frame.LFFT:SetText("FT")
	frame.LFFT:SetChecked(rfsettings.playerdata.lookingfor.ft)
	frame.LFFT:SetPoint("TOPLEFT", frame.LFTDQ, "BOTTOMLEFT", 0, 5)
	frame.LFFT:SetColor (0.925, 0.894, 0.741, 1 )
	frame.LFFT:SetLabelColor(1, 1, 1, 1 )
	frame.LFFT:SetLayer(2)
	frame.LFFT:SetLabelWidth(40)
	Command.Event.Attach(EnKai.events['LFFT'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'LFFT.CheckboxChanged')
	
	frame.LFEE = EnKai.uiCreateFrame("nkCheckbox", 'LFEE', frame.PostPlayerBG)
	frame.LFEE:SetText("EE")
	frame.LFEE:SetChecked(rfsettings.playerdata.lookingfor.ee)
	frame.LFEE:SetPoint("TOPLEFT", frame.LFFT, "BOTTOMLEFT", 0, 5)
	frame.LFEE:SetColor (0.925, 0.894, 0.741, 1 )
	frame.LFEE:SetLabelColor(1, 1, 1, 1 )
	frame.LFEE:SetLayer(2)
	frame.LFEE:SetLabelWidth(40)
	Command.Event.Attach(EnKai.events['LFEE'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'LFEE.CheckboxChanged')
	
	frame.LFGA = EnKai.uiCreateFrame("nkCheckbox", 'LFGA', frame.PostPlayerBG)
	frame.LFGA:SetText("GA")
	frame.LFGA:SetChecked(rfsettings.playerdata.lookingfor.ga)
	frame.LFGA:SetPoint("TOPLEFT", frame.LFEE, "BOTTOMLEFT", 0, 5)
	frame.LFGA:SetColor (0.925, 0.894, 0.741, 1 )
	frame.LFGA:SetLabelColor(1, 1, 1, 1 )
	frame.LFGA:SetLayer(2)
	frame.LFGA:SetLabelWidth(40)
	Command.Event.Attach(EnKai.events['LFGA'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'LFGA.CheckboxChanged')
	
	frame.LFIG = EnKai.uiCreateFrame("nkCheckbox", 'LFIG', frame.PostPlayerBG)
	frame.LFIG:SetText("IG")
	frame.LFIG:SetChecked(rfsettings.playerdata.lookingfor.ig)
	frame.LFIG:SetPoint("TOPLEFT", frame.LFGA, "BOTTOMLEFT", 0, 5)
	frame.LFIG:SetColor (0.925, 0.894, 0.741, 1 )
	frame.LFIG:SetLabelColor(1, 1, 1, 1 )
	frame.LFIG:SetLayer(2)
	frame.LFIG:SetLabelWidth(40)
	Command.Event.Attach(EnKai.events['LFIG'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'LFIG.CheckboxChanged')
	
	frame.LFPB = EnKai.uiCreateFrame("nkCheckbox", 'LFPB', frame.PostPlayerBG)
	frame.LFPB:SetText("PB")
	frame.LFPB:SetChecked(rfsettings.playerdata.lookingfor.pb)
	frame.LFPB:SetPoint("TOPLEFT", frame.LFIG, "BOTTOMLEFT", 0, 5)
	frame.LFPB:SetColor (0.925, 0.894, 0.741, 1 )
	frame.LFPB:SetLabelColor(1, 1, 1, 1 )
	frame.LFPB:SetLayer(2)
	frame.LFPB:SetLabelWidth(40)
	Command.Event.Attach(EnKai.events['LFPB'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'LFPB.CheckboxChanged')
	
	frame.LFOLD = EnKai.uiCreateFrame("nkCheckbox", 'LFOLD', frame.PostPlayerBG)
	frame.LFOLD:SetText("Old World")
	frame.LFOLD:SetChecked(rfsettings.playerdata.lookingfor.old)
	frame.LFOLD:SetPoint("TOPLEFT", frame.LFPB, "BOTTOMLEFT", 0, 5)
	frame.LFOLD:SetColor (0.925, 0.894, 0.741, 1 )
	frame.LFOLD:SetLabelColor(1, 1, 1, 1 )
	frame.LFOLD:SetLayer(2)
	frame.LFOLD:SetLabelWidth(70)
	Command.Event.Attach(EnKai.events['LFOLD'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'LFOLD.CheckboxChanged')

	frame.LFEXP = EnKai.uiCreateFrame("nkCheckbox", 'LFEXP', frame.PostPlayerBG)
	frame.LFEXP:SetText("Experts")
	frame.LFEXP:SetChecked(rfsettings.playerdata.lookingfor.exp)
	frame.LFEXP:SetPoint("TOPLEFT", frame.LFTDQ, "TOPRIGHT", 10, 0)
	frame.LFEXP:SetColor (0.925, 0.894, 0.741, 1 )
	frame.LFEXP:SetLabelColor(1, 1, 1, 1 )
	frame.LFEXP:SetLayer(2)
	frame.LFEXP:SetLabelWidth(70)	
	Command.Event.Attach(EnKai.events['LFEXP'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'LFEXP.CheckboxChanged')
	
	frame.LFDRR = EnKai.uiCreateFrame("nkCheckbox", 'LFDRR', frame.PostPlayerBG)
	frame.LFDRR:SetText("DRR")
	frame.LFDRR:SetChecked(rfsettings.playerdata.lookingfor.drr)
	frame.LFDRR:SetPoint("TOPLEFT", frame.LFEXP, "BOTTOMLEFT", 0, 5)
	frame.LFDRR:SetColor (0.925, 0.894, 0.741, 1 )
	frame.LFDRR:SetLabelColor(1, 1, 1, 1 )
	frame.LFDRR:SetLayer(2)
	frame.LFDRR:SetLabelWidth(70)	
	Command.Event.Attach(EnKai.events['LFDRR'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'LFDRR.CheckboxChanged')
	
	frame.LFGH = EnKai.uiCreateFrame("nkCheckbox", 'LFGH', frame.PostPlayerBG)
	frame.LFGH:SetText("Great Hunt")
	frame.LFGH:SetChecked(rfsettings.playerdata.lookingfor.gh)
	frame.LFGH:SetPoint("TOPLEFT", frame.LFDRR, "BOTTOMLEFT", 0, 5)
	frame.LFGH:SetColor (0.925, 0.894, 0.741, 1 )
	frame.LFGH:SetLabelColor(1, 1, 1, 1 )
	frame.LFGH:SetLayer(2)
	frame.LFGH:SetLabelWidth(70)
	Command.Event.Attach(EnKai.events['LFGH'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'LFGH.CheckboxChanged')
	
	frame.LFSH = EnKai.uiCreateFrame("nkCheckbox", 'LFSH', frame.PostPlayerBG)
	frame.LFSH:SetText("Stronghold")
	frame.LFSH:SetChecked(rfsettings.playerdata.lookingfor.sh)
	frame.LFSH:SetPoint("TOPLEFT", frame.LFGH, "BOTTOMLEFT", 0, 5)
	frame.LFSH:SetColor (0.925, 0.894, 0.741, 1 )
	frame.LFSH:SetLabelColor(1, 1, 1, 1 )
	frame.LFSH:SetLayer(2)
	frame.LFSH:SetLabelWidth(70)
	Command.Event.Attach(EnKai.events['LFSH'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'LFSH.CheckboxChanged')
	
	frame.LFWB = EnKai.uiCreateFrame("nkCheckbox", 'LFWB', frame.PostPlayerBG)
	frame.LFWB:SetText("World Boss")
	frame.LFWB:SetChecked(rfsettings.playerdata.lookingfor.wb)
	frame.LFWB:SetPoint("TOPLEFT", frame.LFSH, "BOTTOMLEFT", 0, 5)
	frame.LFWB:SetColor (0.925, 0.894, 0.741, 1 )
	frame.LFWB:SetLabelColor(1, 1, 1, 1 )
	frame.LFWB:SetLayer(2)
	frame.LFWB:SetLabelWidth(70)
	Command.Event.Attach(EnKai.events['LFWB'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'LFWB.CheckboxChanged')
	
	frame.LFWF = EnKai.uiCreateFrame("nkCheckbox", 'LFWF', frame.PostPlayerBG)
	frame.LFWF:SetText("Warfront")
	frame.LFWF:SetChecked(rfsettings.playerdata.lookingfor.wf)
	frame.LFWF:SetPoint("TOPLEFT", frame.LFWB, "BOTTOMLEFT", 0, 5)
	frame.LFWF:SetColor (0.925, 0.894, 0.741, 1 )
	frame.LFWF:SetLabelColor(1, 1, 1, 1 )
	frame.LFWF:SetLayer(2)
	frame.LFWF:SetLabelWidth(70)
	Command.Event.Attach(EnKai.events['LFWF'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'LFWF.CheckboxChanged')
	
	frame.LFCQ = EnKai.uiCreateFrame("nkCheckbox", 'LFCQ', frame.PostPlayerBG)
	frame.LFCQ:SetText("CQ")
	frame.LFCQ:SetChecked(rfsettings.playerdata.lookingfor.cq)
	frame.LFCQ:SetPoint("TOPLEFT", frame.LFOLD, "TOPRIGHT", 10, 0)
	frame.LFCQ:SetColor (0.925, 0.894, 0.741, 1 )
	frame.LFCQ:SetLabelColor(1, 1, 1, 1 )
	frame.LFCQ:SetLayer(2)
	frame.LFCQ:SetLabelWidth(40)	
	Command.Event.Attach(EnKai.events['LFCQ'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'LFCQ.CheckboxChanged')
	
	frame.LFMISC = EnKai.uiCreateFrame("nkCheckbox", 'LFMISC', frame.PostPlayerBG)
	frame.LFMISC:SetText("MISC.")
	frame.LFMISC:SetChecked(rfsettings.playerdata.lookingfor.misc)
	frame.LFMISC:SetPoint("TOPLEFT", frame.LFEXP, "TOPRIGHT", 10, 0)
	frame.LFMISC:SetColor (0.925, 0.894, 0.741, 1 )
	frame.LFMISC:SetLabelColor(1, 1, 1, 1 )
	frame.LFMISC:SetLayer(2)
	frame.LFMISC:SetLabelWidth(50)
	Command.Event.Attach(EnKai.events['LFMISC'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'LFMISC.CheckboxChanged')
	
	frame.notehead = UI.CreateFrame("Text", "RFpostplayerNoteHead", frame.PostPlayerBG)
	
	frame.notehead:SetPoint("TOPLEFT", frame.PostPlayerBG, "TOPLEFT",550,20)
	frame.notehead:SetText("Note:")
	frame.notehead:SetFontSize(16)
	frame.notehead:SetFontColor(0.906, 0.784, 0.471, 1)
	frame.notehead:SetEffectGlow({ offsetX = 2, offsetY = 2})
	

	
	
	frame.notetext = EnKai.uiCreateFrame("nkTextfield", 'RFPlayerNotetext', frame)	
	frame.notetext:SetPoint("TOPLEFT", frame.notehead, "BOTTOMLEFT", 0, 5)
	frame.notetext:SetWidth(300)
	frame.notetext:SetHeight(22)
	frame.notetext:SetColor(0.925, 0.894, 0.741, 1)
	frame.notetext:SetText(rfsettings.playerdata.note)
	frame.notetext:SetLayer(2)
	
	Command.Event.Attach(EnKai.events['RFPlayerNotetext'].TextfieldChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'RFPlayerNotetext.TextfieldChanged')
	
	frame.noteinfo = EnKai.ui.nkInfoText("RFpostplayernoteinfo", frame.PostPlayerBG)
	frame.noteinfo:SetPoint("TOPLEFT", frame.notetext, "BOTTOMLEFT", 0, 5)
	frame.noteinfo:SetType("info")
	frame.noteinfo:SetText("Press 'Enter' to save note.")
	frame.noteinfo:SetWidth(200)

	frame.notifyme = EnKai.uiCreateFrame("nkCheckbox", 'notifyme', frame.PostPlayerBG)
	frame.notifyme:SetText("Notify me if a raid forms that I'm interested in.")
	frame.notifyme:SetChecked(rfsettings.notifyme)
	frame.notifyme:SetPoint("TOPLEFT", frame.noteinfo, "BOTTOMLEFT", 35, 35)
	frame.notifyme:SetColor (0.925, 0.894, 0.741, 1 )
	frame.notifyme:SetLabelColor(1, 1, 1, 1 )
	frame.notifyme:SetLayer(2)
	frame.notifyme:SetLabelWidth(285)
	--frame.notifyme:SetLabelInFront(false)
	
	Command.Event.Attach(EnKai.events['notifyme'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'notifyme.CheckboxChanged')

	--PlayerPost button
	
	
	frame.btPlayerPost = EnKai.ui.nkButton('RFbtPlayerPost', frame)

	frame.btPlayerPost:SetScale(.8)
	frame.btPlayerPost:SetText("LFG - Post")
	frame.btPlayerPost:SetPoint ("BOTTOMRIGHT", frame.PostPlayerBG, "BOTTOMRIGHT", -10, -20)
	frame.btPlayerPost:SetLayer(5)
	frame.btPlayerPost:SetColor(.20, .65, .20, 1)
	frame.btPlayerPost:SetFontColor(0,0,0,1)
	
	frame.btPlayerPost:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		frame.exptext:SetText("[" .. (rfsettings.playerdata.achiev.tdq + rfsettings.playerdata.achiev.ft + rfsettings.playerdata.achiev.ee) .. "/13]" .. "[" .. (rfsettings.playerdata.achiev.ga + rfsettings.playerdata.achiev.ig + rfsettings.playerdata.achiev.pb) .. "/12]")
		frame.hittext:SetText(tostring(Inspect.Stat("hitUnbuffed")))
		rf.playerdata()
		rf.playerpost()
		rf.broadcasttype = "player"
		print("Posted!")
	end, "RFbtPlayerPost.Left.Click")	
	
	frame.btPlayerPost:EventAttach(Event.UI.Input.Mouse.Left.Down, function (self)		
		frame.btPlayerPost:SetScale(.75)
	end, "RFbtPlayerPost.button.Left.Down")
	
	frame.btPlayerPost:EventAttach(Event.UI.Input.Mouse.Left.Up, function (self)		
		frame.btPlayerPost:SetScale(.8)
		frame.btPlayerPost:SetText("LFG - Post")
	end, "RFbtPlayerPost.button.Left.Up")
	
	frame.btPlayerPost:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, function (self)		
		frame.btPlayerPost:SetScale(.8)
		frame.btPlayerPost:SetText("LFG - Post")
	end, "RFbtPlayerPost.button.Left.Upoutside")
	
	
	
	--Raid Setup
	
	frame.raidnamehead = UI.CreateFrame("Text", "RFpostraidname", frame.PostRaidBG)
	
	frame.raidnamehead:SetPoint("TOPLEFT", frame.PostRaidBG, "TOPLEFT",20,20)
	frame.raidnamehead:SetText("Leader:")
	frame.raidnamehead:SetFontSize(16)
	frame.raidnamehead:SetFontColor(0.906, 0.784, 0.471, 1)
	frame.raidnamehead:SetEffectGlow({ offsetX = 2, offsetY = 2})	
	
	frame.raidnametext = UI.CreateFrame("Text", "RFraidnametext", frame.PostRaidBG)
	
	frame.raidnametext:SetPoint("TOPLEFT", frame.raidnamehead, "BOTTOMLEFT", 0, 5)
	frame.raidnametext:SetText(rfsettings.raiddata.name)
	frame.raidnametext:SetFontSize(14)
	frame.raidnametext:SetFontColor(1, 1, 1, 1)
	
	frame.raidrolehead = UI.CreateFrame("Text", "RFpostraidrole", frame.PostRaidBG)
	
	frame.raidrolehead:SetPoint("TOPLEFT", frame.raidnametext, "BOTTOMLEFT",0,5)
	frame.raidrolehead:SetText("Roles Needed:")
	frame.raidrolehead:SetFontSize(16)
	frame.raidrolehead:SetFontColor(0.906, 0.784, 0.471, 1)
	frame.raidrolehead:SetEffectGlow({ offsetX = 2, offsetY = 2})
	
	frame.raidtank = EnKai.uiCreateFrame("nkCheckbox", 'raidtank', frame.PostRaidBG)
	frame.raidtank:SetText("Tank")
	frame.raidtank:SetChecked(rfsettings.raiddata.roles.tank)
	frame.raidtank:SetPoint("TOPLEFT", frame.raidrolehead, "BOTTOMLEFT", 0, 5)
	frame.raidtank:SetColor (0.925, 0.894, 0.741, 1 )
	frame.raidtank:SetLabelColor(1, 1, 1, 1 )
	frame.raidtank:SetLayer(2)
	frame.raidtank:SetLabelWidth(40)	
	Command.Event.Attach(EnKai.events['raidtank'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'raidtank.CheckboxChanged')
	
	frame.raidheal = EnKai.uiCreateFrame("nkCheckbox", 'raidheal', frame.PostRaidBG)
	frame.raidheal:SetText("Heal")
	frame.raidheal:SetChecked(rfsettings.raiddata.roles.heal)
	frame.raidheal:SetPoint("TOPLEFT", frame.raidtank, "TOPRIGHT", 10, 0)
	frame.raidheal:SetColor (0.925, 0.894, 0.741, 1 )
	frame.raidheal:SetLabelColor(1, 1, 1, 1 )
	frame.raidheal:SetLayer(2)
	frame.raidheal:SetLabelWidth(55)	
	Command.Event.Attach(EnKai.events['raidheal'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'raidheal.CheckboxChanged')	
	
	frame.raiddps = EnKai.uiCreateFrame("nkCheckbox", 'raiddps', frame.PostRaidBG)
	frame.raiddps:SetText("DPS")
	frame.raiddps:SetChecked(rfsettings.raiddata.roles.dps)
	frame.raiddps:SetPoint("TOPLEFT", frame.raidtank, "BOTTOMLEFT", 0, 5)
	frame.raiddps:SetColor (0.925, 0.894, 0.741, 1 )
	frame.raiddps:SetLabelColor(1, 1, 1, 1 )
	frame.raiddps:SetLayer(2)
	frame.raiddps:SetLabelWidth(40)	
	Command.Event.Attach(EnKai.events['raiddps'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'raiddps.CheckboxChanged')
	
	frame.raidsupport = EnKai.uiCreateFrame("nkCheckbox", 'raidsupport', frame.PostRaidBG)
	frame.raidsupport:SetText("Support")
	frame.raidsupport:SetChecked(rfsettings.raiddata.roles.support)
	frame.raidsupport:SetPoint("TOPLEFT", frame.raiddps, "TOPRIGHT", 10, 0)
	frame.raidsupport:SetColor (0.925, 0.894, 0.741, 1 )
	frame.raidsupport:SetLabelColor(1, 1, 1, 1 )
	frame.raidsupport:SetLayer(2)
	frame.raidsupport:SetLabelWidth(55)	
	Command.Event.Attach(EnKai.events['raidsupport'].CheckboxChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'raidsupport.CheckboxChanged')	
	
	frame.typehead = UI.CreateFrame("Text", "RFpostraidtype", frame.PostRaidBG)
	
	frame.typehead:SetPoint("TOPLEFT", frame.PostRaidBG, "TOPLEFT",200,20)
	frame.typehead:SetText("Raid Type:")
	frame.typehead:SetFontSize(16)
	frame.typehead:SetFontColor(0.906, 0.784, 0.471, 1)
	frame.typehead:SetEffectGlow({ offsetX = 2, offsetY = 2})
	
	local typeselection = rf.gridData.selection["RaidType"]
		
	frame.typeselection = EnKai.uiCreateFrame("nkCombobox", 'PostRaidType', frame.PostRaidBG)
	frame.typeselection:SetPoint("TOPLEFT", frame.typehead, "BOTTOMLEFT", 0, 5)
	frame.typeselection:SetWidth(100)
	frame.typeselection:SetLabelWidth(0)
	frame.typeselection:SetSelection(typeselection)
	frame.typeselection:SetSelectedValue(rfsettings.raiddata.raidtype)
	frame.typeselection:SetColor (0.925, 0.894, 0.741, 1 )
	frame.typeselection:SetLabelColor(0.925, 0.894, 0.741, 1)
	frame.typeselection:SetLayer(20)
	Command.Event.Attach(EnKai.events['PostRaidType'].ComboChanged, function (_, newValue)	rf.lookingforupdate(frame) end, 'PostRaidType.ComboChanged')
	
	frame.loothead = UI.CreateFrame("Text", "RFpostraidloot", frame.PostRaidBG)
	
	frame.loothead:SetPoint("TOPLEFT", frame.typehead, "TOPRIGHT",40,0)
	frame.loothead:SetText("Loot Type:")
	frame.loothead:SetFontSize(16)
	frame.loothead:SetFontColor(0.906, 0.784, 0.471, 1)
	frame.loothead:SetEffectGlow({ offsetX = 2, offsetY = 2})
	
	local lootselection = rf.gridData.selection["RaidLoot"]
		
	frame.lootselection = EnKai.uiCreateFrame("nkCombobox", 'PostRaidLoot', frame.PostRaidBG)
	frame.lootselection:SetPoint("TOPLEFT", frame.loothead, "BOTTOMLEFT", 0, 5)
	frame.lootselection:SetWidth(100)
	frame.lootselection:SetLabelWidth(0)
	frame.lootselection:SetSelection(lootselection)
	frame.lootselection:SetSelectedValue(rfsettings.raiddata.loot)
	frame.lootselection:SetColor (0.925, 0.894, 0.741, 1 )
	frame.lootselection:SetLabelColor(0.925, 0.894, 0.741, 1)
	frame.lootselection:SetLayer(20)
	Command.Event.Attach(EnKai.events['PostRaidLoot'].ComboChanged, function (_, newValue)	rf.lookingforupdate(frame) end, 'PostRaidLoot.ComboChanged')
	
	frame.raidnotehead = UI.CreateFrame("Text", "RFpostraidNoteHead", frame.PostRaidBG)
	
	frame.raidnotehead:SetPoint("TOPLEFT", frame.PostRaidBG, "TOPLEFT",450,20)
	frame.raidnotehead:SetText("Note:")
	frame.raidnotehead:SetFontSize(16)
	frame.raidnotehead:SetFontColor(0.906, 0.784, 0.471, 1)
	frame.raidnotehead:SetEffectGlow({ offsetX = 2, offsetY = 2})
	
	frame.raidnotetext = EnKai.uiCreateFrame("nkTextfield", 'RFRaidNotetext', frame.PostRaidBG)	
	frame.raidnotetext:SetPoint("TOPLEFT", frame.raidnotehead, "BOTTOMLEFT", 0, 5)
	frame.raidnotetext:SetWidth(400)
	frame.raidnotetext:SetHeight(22)
	frame.raidnotetext:SetColor(0.925, 0.894, 0.741, 1)
	frame.raidnotetext:SetText(rfsettings.raiddata.note)
	frame.raidnotetext:SetLayer(2)
	
	Command.Event.Attach(EnKai.events['RFRaidNotetext'].TextfieldChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'RFRaidNotetext.TextfieldChanged')
	
	frame.raidnoteinfo = EnKai.ui.nkInfoText("RFpostraidnoteinfo", frame.PostRaidBG)
	frame.raidnoteinfo:SetPoint("TOPLEFT", frame.raidnotetext, "BOTTOMLEFT", 0, 5)
	frame.raidnoteinfo:SetType("info")
	frame.raidnoteinfo:SetText("Press 'Enter' to save note.")
	frame.raidnoteinfo:SetWidth(200)
	
	frame.channelhead = UI.CreateFrame("Text", "RFchannelhead", frame.PostRaidBG)
	
	frame.channelhead:SetPoint("TOPLEFT", frame.raidnoteinfo, "BOTTOMLEFT", 0, 15)
	frame.channelhead:SetText("Broadcast your raid in chat channel #:")
	frame.channelhead:SetFontSize(14)
	frame.channelhead:SetFontColor(1, 1, 1, 1)
	frame.channelhead:SetWordwrap(true)
	frame.channelhead:SetWidth(130)
	
	frame.channeltext = EnKai.uiCreateFrame("nkTextfield", 'RFchanneltext', frame.PostRaidBG)	
	frame.channeltext:SetPoint("TOPLEFT", frame.channelhead, "BOTTOMRIGHT", -10, -20)
	frame.channeltext:SetWidth(30)
	frame.channeltext:SetHeight(22)
	frame.channeltext:SetColor(0.925, 0.894, 0.741, 1)
	frame.channeltext:SetText(rfsettings.raiddata.channel)
	frame.channeltext:SetLayer(2)
	
	Command.Event.Attach(EnKai.events['RFchanneltext'].TextfieldChanged, function (_, newValue) rf.lookingforupdate(frame) end, 'RFchanneltext.TextfieldChanged')
	
	frame.channelinfo = EnKai.ui.nkInfoText("RFchannelinfo", frame.channeltext)
	frame.channelinfo:SetPoint("TOPLEFT", frame.channelhead, "BOTTOMLEFT", 0, 5)
	frame.channelinfo:SetType("info")
	frame.channelinfo:SetText("Press 'Enter' to save channel #")
	frame.channelinfo:SetWidth(200)
	
	--RaidPost button
	
	frame.btRaidPost = EnKai.ui.nkButton('RFbtRaidPost', rf.uiElements.context)

	frame.btRaidPost:SetScale(.8)
	frame.btRaidPost:SetText("LFM - Post")
	frame.btRaidPost:SetPoint ("BOTTOMRIGHT", frame.PostRaidBG, "BOTTOMRIGHT", -10, -20)
	frame.btRaidPost:SetLayer(5)
	frame.btRaidPost:SetColor(.20, .65, .20, 1)
	frame.btRaidPost:SetFontColor(0,0,0,1)
		
	frame.btRaidPost:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		rf.playerdata() 
		rf.raidpost()
		rf.broadcasttype = "raid"
		print("Posted!")
		
		local raid = frame.typeselection:GetSelectedLabel()
		local loot = frame.lootselection:GetSelectedLabel()
		
		local t = false
		local h = false
		local d = false
		local s = false

		if rfsettings.raiddata.roles.tank == true then
			tank = "Tank"
			t = true			
		end

		if rfsettings.raiddata.roles.heal == true and t == true then
			heal = "/Heal"
			h = true
		elseif rfsettings.raiddata.roles.heal == true then
			heal = "Heal"
			h = true
		end
		
		
		if rfsettings.raiddata.roles.dps == true and (h == true or t == true) then
			dps = "/DPS"
			d = true
		elseif rfsettings.raiddata.roles.dps == true then
			dps = "DPS"
			d = true
		end
			
		
		
		if rfsettings.raiddata.roles.support == true and (d == true or h == true or t == true) then
			support = "/Support"
			s = true
		elseif rfsettings.raiddata.roles.support == true then
			support = "Support"
			s = true
		end
		
		local note = rfsettings.raiddata.note
		
		local groupsize = 0
		
		if rfsettings.raiddata.raidtype == "wf" or rfsettings.raiddata.raidtype == "exp" then
			groupsize = 5
		elseif rfsettings.raiddata.raidtype == "tdq" or rfsettings.raiddata.raidtype == "ga" then
			groupsize = 10
		else
			groupsize = 20
		end
		
		local currentgroup = LibSRM.GroupCount()
		
		if currentgroup == 0 then 
			currentgroup = 1
		end		
		
		local room = (groupsize - currentgroup)
		
		local channel = frame.channeltext:GetText()
		
		if room == 0 then room = "" end
		
		local need = ". Need: "
		
		if t == false and d == false and h == false and s == false then
			need = ""
		end
		
		local macro = (channel .. " [RaidFinder] LF" .. room .. "M for " .. raid .. need .. tank .. heal .. dps .. support .. ".  Loot: " .. loot .. ". " .. note) 
		
		if (channel ~= nil and channel ~= "") then
			frame.btRaidPost:SetSecureMode("restricted")
			frame.btRaidPost:EventMacroSet(Event.UI.Input.Mouse.Left.Click, macro)
		else
			frame.btRaidPost:SetSecureMode("restricted")
			frame.btRaidPost:EventMacroSet(Event.UI.Input.Mouse.Left.Click, "")
		end
		
	end, "RFbtRaidPost.Left.Click")	
	
	frame.btRaidPost:EventAttach(Event.UI.Input.Mouse.Left.Down, function (self)		
		frame.btRaidPost:SetScale(.75)
	end, "RFbtRaidPost.button.Left.Down")
	
	frame.btRaidPost:EventAttach(Event.UI.Input.Mouse.Left.Up, function (self)		
		frame.btRaidPost:SetScale(.8)
		frame.btRaidPost:SetText("LFM - Post")
	end, "RFbtRaidPost.button.Left.Up")
	
	frame.btRaidPost:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, function (self)		
		frame.btRaidPost:SetScale(.8)
		frame.btRaidPost:SetText("LFM - Post")
	end, "RFbtRaidPost.button.Left.Upoutside")	

											
--stop

	frame.stopButton = EnKai.ui.nkButton("PostTabStop", frame)
	frame.stopButton:SetText("Stop Posting")
	frame.stopButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, -5)
	frame.stopButton:SetColor(.84, .42, .42, 1)
	frame.stopButton:SetFontColor( 0, 0, 0, 1 )
	frame.stopButton:SetLayer(5)
	
	frame.stopButton:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		rf.broadcasting = false
		rf.broadcasttype = ""
		
		print("Stopped All Posts")
	end, "PostTabStop.Left.Click")	
	
	frame.stopButton:EventAttach(Event.UI.Input.Mouse.Left.Down, function (self)		
		frame.stopButton:SetScale(.95)
	end, "stopButton.button.Left.Down")
	
	frame.stopButton:EventAttach(Event.UI.Input.Mouse.Left.Up, function (self)		
		frame.stopButton:SetScale(1)
		frame.stopButton:SetText("Stop Posting")
	end, "stopButton.button.Left.Up")
	
	frame.stopButton:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, function (self)		
		frame.stopButton:SetScale(1)
		frame.stopButton:SetText("Stop Posting")
	end, "stopButton.button.Left.Upoutside")	
	
	
	
	--close
											
	frame.closeButton = UI.CreateFrame("RiftButton", 'RaidTabClose', frame)
	frame.closeButton:SetText("Close")
	frame.closeButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, -5)
	frame.closeButton:SetLayer(2)
	
	frame.closeButton:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		rf.UI.closeUI()
	end, "RaidTabClose.Left.Click")
	

end

function rf.UI:setupStatusTab()
	
	local frame = rf.UI.frame.paneStatusTab

	frame.StatusPlayerBG = UI.CreateFrame('Texture', 'RFStatusPlayerBack', frame)
	frame.StatusPlayerBG:SetLayer(1)
	frame.StatusPlayerBG:SetTextureAsync('RaidFinder', 'gfx/databaseGridBG.png')
	frame.StatusPlayerBG:SetWidth(910)
	frame.StatusPlayerBG:SetHeight(200)
	frame.StatusPlayerBG:SetPoint("TOPLEFT", frame, "TOPLEFT", 7, 36)
	
	
	frame.StatusRaidBG = UI.CreateFrame('Texture', 'RFStatusRaidBack', frame)
	frame.StatusRaidBG:SetLayer(1)
	frame.StatusRaidBG:SetTextureAsync('RaidFinder', 'gfx/databaseGridBG.png')
	frame.StatusRaidBG:SetWidth(910)
	frame.StatusRaidBG:SetHeight(200)
	frame.StatusRaidBG:SetPoint("TOPLEFT", frame.StatusPlayerBG, "BOTTOMLEFT", 0, 1)	
	
	
	--Player Status

	--Grid
	frame.grid = EnKai.uiCreateFrame("nkGrid", 'RFPlayerstatusGrid', frame)
		
	frame.grid:SetPoint("TOPLEFT", frame.StatusPlayerBG, "TOPLEFT", 12, 12)
	frame.grid:SetHeaderLabeLColor(0.925, 0.894, 0.741, 1)
	frame.grid:SetBorderColor(0, 0, 0, 1)
	frame.grid:SetBodyColor(.133, .133, .133, 1)
	frame.grid:SetBodyHighlightColor(.266, .266, .266, 1)
	frame.grid:SetLabelHighlightColor(1, 1, 1, 1)
	frame.grid:SetSelectable(true)
	frame.grid:SetLayer(3)
	frame.grid:SetHeaderHeight(30)
	frame.grid:SetHeaderFontSize(15)
	frame.grid:SetFontSize(15)
	
	frame.grid:Sort(7)

	local gridRows = 7
	
	local cols = rf.gridData.selectionheaders['players']
	
	frame.grid:SetVisible(false)	
	frame.grid:Layout (cols, gridRows)
	
	Command.Event.Attach(EnKai.events['RFPlayerstatusGrid'].GridFinished, function ()
		rf.StatusgridUpdate(frame, frame.grid)
		frame.grid:SetVisible(true)
	end, 'RFPlayerstatusGrid.GridFinished')
	 
	Command.Event.Attach(EnKai.events['RFPlayerstatusGrid'].WheelForward, function (_, rowPos)
		frame.slider:AdjustValue (rowPos)
		
	 end, 'RFPlayerstatusGrid.Grid.WheelForward')
	
	Command.Event.Attach(EnKai.events['RFPlayerstatusGrid'].WheelBack, function (_, rowPos)
		frame.slider:AdjustValue (rowPos)

	 end, 'RFPlayerstatusGrid.Grid.WheelBack')

	Command.Event.Attach(EnKai.events['RFPlayerstatusGrid'].LeftClick, function (_, rowPos)
		frame.raidgrid:SetSelectable(false)
		frame.raidgrid:SetSelectable(true)
	 end, 'RFPlayerstatusGrid.Grid.LeftClick')
	
	
	
	--Slider
	
	frame.slider = EnKai.uiCreateFrame("nkScrollbox", 'RFPlayerstatusGridSlider', frame)	
		
	frame.slider:SetPoint("TOPLEFT", frame.StatusPlayerBG, "TOPRIGHT", -18, 25)
	frame.slider:SetHeight(frame.grid:GetHeight() - 25)
	frame.slider:SetRange(1, 1)
	frame.slider:SetVisible(false)
	frame.slider:SetLayer(2)
	frame.slider:SetColor( 0.925, 0.894, 0.741, 1 )
	
	Command.Event.Attach(EnKai.events['RFPlayerstatusGridSlider'].ScrollboxChanged, function ()		
		frame.grid:SetRowPos(math.floor(frame.slider:GetValue('value')), true)
	end, 'RFPlayerstatusGridSlider.ScrollboxChanged')	
		
	
	
	
	-- Raid Status
	
	--Grid
	frame.raidgrid = EnKai.uiCreateFrame("nkGrid", 'RFraidstatusGrid', frame)
		
	frame.raidgrid:SetPoint("TOPLEFT", frame.StatusRaidBG, "TOPLEFT", 12, 12)
	frame.raidgrid:SetHeaderLabeLColor(0.925, 0.894, 0.741, 1)
	frame.raidgrid:SetBorderColor(0, 0, 0, 1)
	frame.raidgrid:SetBodyColor(.133, .133, .133, 1)
	frame.raidgrid:SetBodyHighlightColor(.266, .266, .266, 1)
	frame.raidgrid:SetLabelHighlightColor(1, 1, 1, 1)
	frame.raidgrid:SetSelectable(true)
	frame.raidgrid:SetLayer(3)
	frame.raidgrid:SetHeaderHeight(30)
	frame.raidgrid:SetHeaderFontSize(15)
	frame.raidgrid:SetFontSize(15)
	
	frame.grid:Sort(6)

	local raidgridRows = 7
	
	local raidcols = rf.gridData.selectionheaders['raids']
	
	frame.raidgrid:SetVisible(false)	
	frame.raidgrid:Layout (raidcols, raidgridRows)
	
	Command.Event.Attach(EnKai.events['RFraidstatusGrid'].GridFinished, function ()
		rf.StatusgridUpdate(frame, frame.raidgrid)
		frame.raidgrid:SetVisible(true)
	end, 'RFraidstatusGrid.GridFinished')
	 
	Command.Event.Attach(EnKai.events['RFraidstatusGrid'].WheelForward, function (_, rowPos)
		frame.slider:AdjustValue (rowPos)
		
	 end, 'RFraidstatusGrid.Grid.WheelForward')
	
	Command.Event.Attach(EnKai.events['RFraidstatusGrid'].WheelBack, function (_, rowPos)
		frame.slider:AdjustValue (rowPos)

	 end, 'RFraidstatusGrid.Grid.WheelBack')

	Command.Event.Attach(EnKai.events['RFraidstatusGrid'].LeftClick, function (_, rowPos)
		frame.grid:SetSelectable(false)
		frame.grid:SetSelectable(true)
	 end, 'RFraidstatusGrid.Grid.LeftClick')	
	
	--Slider
	
	frame.raidslider = EnKai.uiCreateFrame("nkScrollbox", 'RFraidstatusGridSlider', frame)	
		
	frame.raidslider:SetPoint("TOPLEFT", frame.StatusRaidBG, "TOPRIGHT", -18, 25)
	frame.raidslider:SetHeight(frame.grid:GetHeight() - 25)
	frame.raidslider:SetRange(1, 1)
	frame.raidslider:SetVisible(false)
	frame.raidslider:SetLayer(2)
	frame.raidslider:SetColor( 0.925, 0.894, 0.741, 1 )
	
	Command.Event.Attach(EnKai.events['RFraidstatusGridSlider'].ScrollboxChanged, function ()		
		frame.grid:SetRowPos(math.floor(frame.raidslider:GetValue('value')), true)
	end, 'RFraidstatusGridSlider.ScrollboxChanged')	

	--deny
	
	frame.denyButton = EnKai.ui.nkButton("RFstatusdeny", frame)
	frame.denyButton:SetText("Deny/Clear")
	frame.denyButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -170, -5)
	frame.denyButton:SetColor(.84, .42, .42, 1)
	frame.denyButton:SetFontColor( 0, 0, 0, 1 )
	
	local playersel = nil
	local raidsel = nil
	
	Command.Event.Attach(EnKai.events['RFstatusdeny'].Clicked, function ()		
		local seltype = ""
		playersel = frame.grid:GetKey(frame.grid:GetSelectedRow())
		raidsel = frame.raidgrid:GetKey(frame.raidgrid:GetSelectedRow())
		local name = nil
		if playersel == nil then 
			seltype = "raid" 
			name = raidsel
		elseif raidsel == nil then 
			seltype = "player"
			name = playersel
		end

		if name == nil then print("You must select a player first.") return end
		
		rf.deny(seltype,name)

	end, 'RFstatusdeny.Clicked')
	
	frame.denyButton:EventAttach(Event.UI.Input.Mouse.Left.Down, function (self)		
		frame.denyButton:SetScale(.95)
	end, "denyButton.button.Left.Down")
	
	frame.denyButton:EventAttach(Event.UI.Input.Mouse.Left.Up, function (self)		
		frame.denyButton:SetScale(1)
		frame.denyButton:SetText("Deny/Clear")
	end, "denyButton.button.Left.Up")
	
	frame.denyButton:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, function (self)		
		frame.denyButton:SetScale(1)
		frame.denyButton:SetText("Deny/Clear")
	end, "denyButton.button.Left.Upoutside")		


--approve

	frame.approveButton = EnKai.ui.nkButton("RFstatusapprove", rf.uiElements.context)
	frame.approveButton:SetText("Approve/Invite")
	frame.approveButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, -5)
	frame.approveButton:SetColor(.20, .65, .20, 1)
	frame.approveButton:SetFontColor( 0, 0, 0, 1 )
	frame.approveButton:SetSecureMode("restricted")
	frame.approveButton:SetLayer(2)
	
	
	
	
	Command.Event.Attach(EnKai.events['RFstatusapprove'].Clicked, function ()
		rf.UI.frame.paneStatusTab.approveButton:EventMacroSet(Event.UI.Input.Mouse.Left.Click, "")
		local seltype = ""
		local playersel = frame.grid:GetKey(frame.grid:GetSelectedRow())
		local raidsel = frame.raidgrid:GetKey(frame.raidgrid:GetSelectedRow())
		local name = ""
		
		if playersel == nil and raidsel ~= nil then 
			seltype = "raid" 
			name = raidsel
		elseif raidsel == nil and playersel ~= nil then 
			seltype = "player"
			name = playersel
		else

		end
		if name == "" then print("You must select a player first.") return end
		
		rf.approve(seltype,name)
		

	end, 'RFstatusapprove.Clicked')	
	
	frame.approveButton:EventAttach(Event.UI.Input.Mouse.Left.Down, function (self)		
		frame.approveButton:SetScale(.95)
	end, "approveButton.button.Left.Down")
	
	frame.approveButton:EventAttach(Event.UI.Input.Mouse.Left.Up, function (self)		
		frame.approveButton:SetScale(1)
		frame.approveButton:SetText("Approve/Invite")
	end, "approveButton.button.Left.Up")
	
	frame.approveButton:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, function (self)		
		frame.approveButton:SetScale(1)
		frame.approveButton:SetText("Approve/Invite")
	end, "approveButton.button.Left.Upoutside")		
	
	
	
	
	frame.dialog = EnKai.ui.nkDialog("inviteconfirm", rf.uiElements.context)
	frame.dialog:SetType("confirm")
	frame.dialog:SetMessage("Are you 100% ready for an invite? If you are already in a group leave now.")
	frame.dialog:SetLayer(10)
	frame.dialog:SetWidth(320)
	frame.dialog:SetHeight(200)
	frame.dialog:SetVisible(false)
	
	
	--close
											
	frame.closeButton = UI.CreateFrame("RiftButton", 'RaidTabClose', frame)
	frame.closeButton:SetText("Close")
	frame.closeButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, -5)
	frame.closeButton:SetLayer(2)
	
	frame.closeButton:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		rf.UI.closeUI()
	end, "RaidTabClose.Left.Click")
	
	rf.statusframe = frame
	
end

function rf.StatusgridUpdate(frame, grid)
	
	local rawcontent = {}
	local values = {}
	if grid == frame.grid then
		
		rawcontent = rf.gridData.playerappdata

		for k, v in pairs(rawcontent) do
			local thisValue = {}
			local roleslist = ""
			local t = " |"
			local h = " |"
			local d = " |"
			local s = " "
			local achlist = ""
			
			
			table.insert (thisValue, {key = k, value = v.name, color = {1,1,1,1}})
			table.insert (thisValue, {key = k, value = v.class, color = {1,1,1,1}})
			
			if v.roles.tank == true then t = "T|" end
			if v.roles.heal == true then h = "H|" end
			if v.roles.dps == true then d = "D|" end
			if v.roles.support == true then s = "S" end
			
			roleslist = (t .. h .. d .. s)
		
			table.insert (thisValue, {key = k, value = roleslist, color = {1,1,1,1}})
			
			achlist = ("[" .. (v.achiev.tdq + v.achiev.ft + v.achiev.ee) .. "/13]" .. "[" .. (v.achiev.ga + v.achiev.ig + v.achiev.pb) .. "/12]")  
		
			table.insert (thisValue, {key = k, value = achlist, color = {1,1,1,1}})
			
			table.insert (thisValue, {key = k, value = v.hit, color = {1,1,1,1}})

			table.insert (thisValue, {key = k, value = v.note, color = {1,1,1,1}})
			
			table.insert (thisValue, {key = k, value = v.status, color = {1,1,1,1}})
			
			table.insert (thisValue, {key = k, value = v.time, color = {1,1,1,1}})
			if v.status ~= nil and v.status ~= "Declined." then	
				table.insert (values, thisValue)
			else
				rf.gridData.playerappdata[v.name] = nil
			end
		end

	elseif grid == frame.raidgrid then
		
		rawcontent = rf.gridData.raidappdata

		for k, v in pairs(rawcontent) do
			local thisValue = {}
			local roleslist = ""
			local t = " |"
			local h = " |"
			local d = " |"
			local s = " "
			local achlist = ""
			
			
			table.insert (thisValue, {key = k, value = v.name, color = {1,1,1,1}})
			table.insert (thisValue, {key = k, value = v.raidtype, color = {1,1,1,1}})
			table.insert (thisValue, {key = k, value = v.loot, color = {1,1,1,1}})
			
			
			if v.roles.tank == true then t = "T|" end
			if v.roles.heal == true then h = "H|" end
			if v.roles.dps == true then d = "D|" end
			if v.roles.support == true then s = "S" end
			
			roleslist = (t .. h .. d .. s)
		
			table.insert (thisValue, {key = k, value = roleslist, color = {1,1,1,1}})
			
			table.insert (thisValue, {key = k, value = v.note, color = {1,1,1,1}})
			
			table.insert (thisValue, {key = k, value = v.status, color = {1,1,1,1}})
			
			table.insert (thisValue, {key = k, value = v.time, color = {1,1,1,1}})

			if v.status ~= nil and v.status ~= "Declined." then
				table.insert (values, thisValue)
			else
				rf.gridData.raidappdata[v.name] = nil
			end
		end

	else
		return 
	end

	local maxCount = 0
	
	grid:SetRowPos(1, false)
	grid:SetCellValues(values)
	
	maxCount = #values

		
	if (maxCount-18) > 0 then
		frame.slider:SetRange (1, maxCount-18)
		frame.slider:SetVisible(true)
	else
		frame.slider:SetVisible(false)
	end

end

function rf.lookingforupdate(frame)



	--player
	
	rfsettings.playerdata.lookingfor.tdq = frame.LFTDQ:GetChecked()
	rfsettings.playerdata.lookingfor.ft = frame.LFFT:GetChecked()
	rfsettings.playerdata.lookingfor.ee = frame.LFEE:GetChecked()
	rfsettings.playerdata.lookingfor.ga = frame.LFGA:GetChecked()
	rfsettings.playerdata.lookingfor.ig = frame.LFIG:GetChecked()
	rfsettings.playerdata.lookingfor.pb = frame.LFPB:GetChecked()
	rfsettings.playerdata.lookingfor.old = frame.LFOLD:GetChecked()
	rfsettings.playerdata.lookingfor.exp = frame.LFEXP:GetChecked()
	rfsettings.playerdata.lookingfor.drr = frame.LFDRR:GetChecked()
	rfsettings.playerdata.lookingfor.gh = frame.LFGH:GetChecked()
	rfsettings.playerdata.lookingfor.sh = frame.LFSH:GetChecked()
	rfsettings.playerdata.lookingfor.wb = frame.LFWB:GetChecked()
	rfsettings.playerdata.lookingfor.wf = frame.LFWF:GetChecked()
	rfsettings.playerdata.lookingfor.cq = frame.LFCQ:GetChecked()
	rfsettings.playerdata.lookingfor.misc = frame.LFMISC:GetChecked()
	
	rfsettings.notifyme = frame.notifyme:GetChecked()
	
	rfsettings.playerdata.roles.tank = frame.tank:GetChecked()
	rfsettings.playerdata.roles.heal = frame.heal:GetChecked()
	rfsettings.playerdata.roles.dps = frame.dps:GetChecked()
	rfsettings.playerdata.roles.support = frame.support:GetChecked()
	
	rfsettings.playerdata.note = frame.notetext:GetText()
	
	frame.hittext:SetText(tostring(Inspect.Stat("hitUnbuffed")))
	frame.exptext:SetText("[" .. (rfsettings.playerdata.achiev.tdq + rfsettings.playerdata.achiev.ft + rfsettings.playerdata.achiev.ee) .. "/13]" .. "[" .. (rfsettings.playerdata.achiev.ga + rfsettings.playerdata.achiev.ig + rfsettings.playerdata.achiev.pb) .. "/12]")
	
	--raid
	
	rfsettings.raiddata.loot = frame.lootselection:GetSelectedValue()
	rfsettings.raiddata.raidtype = frame.typeselection:GetSelectedValue()
	
	rfsettings.raiddata.roles.tank = frame.raidtank:GetChecked()
	rfsettings.raiddata.roles.heal = frame.raidheal:GetChecked()
	rfsettings.raiddata.roles.dps = frame.raiddps:GetChecked()
	rfsettings.raiddata.roles.support = frame.raidsupport:GetChecked()
	
	rfsettings.raiddata.note = frame.raidnotetext:GetText()
	rfsettings.raiddata.channel = frame.channeltext:GetText()
	
end

function rf.PlayergridUpdate(frame, grid)

	local pane = frame

		local classSelect = pane.classSelect:GetSelectedValue()
		local roleSelect = pane.roleSelect:GetSelectedValue()
		local typeSelect = pane.typeselection:GetSelectedValue()
		local typeitems = {}
		local classitems = {}
		local roleitems = {}
		local friendDisplay = pane.friendsCheckbox:GetChecked()
		local list = {}
		local rawcontent = rf.gridData.puggerdata
		local content = {}
		local currenttime = Inspect.Time.Frame()
		
		for k,v in pairs(rawcontent) do
			if (currenttime - v.time) <= 20 then
				content[k] = rawcontent[k]
			else
				rawcontent[k] = nil
			end
		end

		for k,v in pairs(content) do
			if classSelect == v.class or classSelect == "All" or classSelect == "" then
				classitems[k] = content[k]
			end
		end
		
		for k,v in pairs(classitems) do
			for k2,v2 in pairs(v.lookingfor) do
				if ((typeSelect == k2 and v2 == true) or typeSelect == "All" or typeSelect == "") then
					typeitems[k] = classitems[k]
				end
			end
		end
		
		for k,v in pairs(typeitems) do
			
			local t = ""
			local h = ""
			local d = ""
			local s = ""
			
			
			if v.roles.tank == true then t = "T" end
			if v.roles.heal == true then h = "H" end
			if v.roles.dps == true then d = "D" end
			if v.roles.support == true then s = "S" end
		
		
			if roleSelect == "Tank" then
				if v.roles.tank then
				roleitems[k] = classitems[k]
				end
			elseif roleSelect == "Healer" then
				if v.roles.heal then
				roleitems[k] = classitems[k]
				end
			elseif roleSelect == "DPS" then
				if v.roles.dps then
				roleitems[k] = classitems[k]
				end
			elseif roleSelect == "Support" then
				if v.roles.support then
				roleitems[k] = classitems[k]
				end
			else
				roleitems[k] = classitems[k]
			end
		end
		
		for k,v in pairs(roleitems) do
			if friendDisplay then
				local friends = EnKai.tools.table.serialize (Inspect.Social.Friend.List())
				local name = string.match(v.name, "(%a+)@%a+")
				if name == nil then return end
				if string.match(friends, name) ~= nil then
					list[k] = roleitems[k] 
				end
			else
				list[k] = roleitems[k]
			end
		end
		
		
		local values = {}

		for k, v in pairs(list) do
			local thisValue = {}
			local roleslist = ""
			local t = " |"
			local h = " |"
			local d = " |"
			local s = " "
			local achlist = ""
			
			
			table.insert (thisValue, {key = k, value = v.name, color = {1,1,1,1}})
			table.insert (thisValue, {key = k, value = v.class, color = {1,1,1,1}})
			
			if v.roles.tank == true then t = "T|" end
			if v.roles.heal == true then h = "H|" end
			if v.roles.dps == true then d = "D|" end
			if v.roles.support == true then s = "S" end
			
			roleslist = (t .. h .. d .. s)
		
			table.insert (thisValue, {key = k, value = roleslist, color = {1,1,1,1}})
			
			achlist = ("[" .. (v.achiev.tdq + v.achiev.ft + v.achiev.ee) .. "/13]" .. "[" .. (v.achiev.ga + v.achiev.ig + v.achiev.pb) .. "/12]")  
			

			table.insert (thisValue, {key = k, value = achlist, color = {1,1,1,1}})
			
			

			table.insert (thisValue, {key = k, value = v.hit, color = {1,1,1,1}})
						
			local lfgtable = {}
			for k,val in pairs(v.lookingfor) do
				if val then
					table.insert(lfgtable, string.upper(k))
				end
			end
			

			local lfg = string.gsub(EnKai.tools.table.serialize (lfgtable), [["]], "")

			
			table.insert (thisValue, {key = k, value = lfg, color = {1,1,1,1}})

			table.insert (thisValue, {key = k, value = v.note, color = {1,1,1,1}})
			
			for k,v in pairs(thisValue) do
				if v.value == nil then v.value = "" end
			end
			
			table.insert (values, thisValue)

		end


	local maxCount = 0
	
	grid:SetRowPos(1, false)
	grid:SetCellValues(values)
	
	maxCount = #values

		
	if (maxCount-18) > 0 then
		frame.slider:SetRange (1, maxCount-18)
		frame.slider:SetVisible(true)
	else
		frame.slider:SetVisible(false)
	end

end

function rf.RaidgridUpdate(frame, grid)

	local pane = frame


		local typeSelect = pane.typeSelect:GetSelectedValue()
		local lootSelect = pane.lootSelect:GetSelectedValue()
		local roleSelect = pane.roleSelect:GetSelectedValue()
		local typeitems = {}
		local lootitems = {}
		local roleitems = {}
		local rawcontent = rf.gridData.raiddata
		local content = {}
		local currenttime = Inspect.Time.Frame()
		
		for k,v in pairs(rawcontent) do
			if (currenttime - v.time) <= 20 then
				content[k] = rawcontent[k]
			else
				rawcontent[k] = nil
			end
		end
		
		

		for k,v in pairs(content) do
			if typeSelect == v.raidtype or typeSelect == "All" or typeSelect == "" then
				typeitems[k] = content[k]

			end
		end

		
		for k,v in pairs(typeitems) do
			if lootSelect == v.loot or lootSelect == "All" or lootSelect == "" then
				lootitems[k] = typeitems[k]

			end
		end

		
		for k,v in pairs(lootitems) do
			
			local t = ""
			local h = ""
			local d = ""
			local s = ""
			
			if v.roles.tank == true then t = "T" end
			if v.roles.heal == true then h = "H" end
			if v.roles.dps == true then d = "D" end
			if v.roles.support == true then s = "S" end
		
		
			if roleSelect == "Tank" then
				if v.roles.tank then
				roleitems[k] = lootitems[k]
				end
			elseif roleSelect == "Heal" then
				if v.roles.heal then
				roleitems[k] = lootitems[k]
				end
			elseif roleSelect == "DPS" then
				if v.roles.dps then
				roleitems[k] = lootitems[k]
				end
			elseif roleSelect == "Support" then
				if v.roles.support then
				roleitems[k] = lootitems[k]
				end
			else
				roleitems[k] = lootitems[k]

			end
		end		

		local values = {}

		for k, v in pairs(roleitems) do
			local thisValue = {}
			local roleslist = ""
			local t = " |"
			local h = " |"
			local d = " |"
			local s = ""
			local achlist = ""
			
			
			table.insert (thisValue, {key = k, value = v.name, color = {1,1,1,1}})
			
			local typelabel = ""
			
			for k2,v2 in pairs(rf.gridData.selection["Type"]) do
				if EnKai.tools.table.isMember(v2, v.raidtype) then
					typelabel = rf.gridData.selection["Type"][k2].label
				end
			end
			
			if typelabel == nil then typelabel = "" end
			table.insert (thisValue, {key = k, value = typelabel, color = {1,1,1,1}})
			
			
			table.insert (thisValue, {key = k, value = v.loot, color = {1,1,1,1}})
			
			
			if v.roles.tank == true then t = "T|" end
			if v.roles.heal == true then h = "H|" end
			if v.roles.dps == true then d = "D|" end
			if v.roles.support == true then s = "S" end
			
			roleslist = (t .. h .. d .. s)

			table.insert (thisValue, {key = k, value = roleslist, color = {1,1,1,1}})

			table.insert (thisValue, {key = k, value = v.note, color = {1,1,1,1}})
			
			table.insert (thisValue, {key = k, value = v.size, color = {1,1,1,1}})
			
			for k,v in pairs(thisValue) do
				if v.value == nil then v.value = "" end
			end
			
			table.insert (values, thisValue)


		end


	local maxCount = 0
	
	grid:SetRowPos(1, false)
	grid:SetCellValues(values)

	maxCount = #values

		
	if (maxCount-18) > 0 then
		frame.slider:SetRange (1, maxCount-18)
		frame.slider:SetVisible(true)
	else
		frame.slider:SetVisible(false)
	end

end

function rf.search (frame, grid, reset)

	frame.editSearch:Leave()
	
	local searchValue = frame.editSearch:GetText()
	grid:filter (searchValue, 1, reset)
	
	local gridValues = grid:GetCellValues()
	
	if gridValues ~= nil and (#gridValues-18) > 0 then
		frame.slider:SetRange (1, #gridValues-17)
		frame.slider:SetVisible(true)
	else
		frame.slider:SetVisible(false)
	end
	
	if reset then frame.editSearch:SetText("") end
	
end

function rf.UI:addonButton()

	
	rf.UI.button = UI.CreateFrame ('Texture', 'RFButton', rf.uiElements.context)
	local button = rf.UI.button
	button:SetTextureAsync('RaidFinder', 'lib/EnKai/gfx/actionButton.png')
	button:SetWidth(35 * rfsettings.aButtonS)
	button:SetHeight(35 * rfsettings.aButtonS)
	button:SetPoint ("CENTER", UIParent, "CENTER", rfsettings.aButtonX, rfsettings.aButtonY)
	button:SetLayer(2)

	
	rf.UI.texture = UI.CreateFrame ('Texture', 'RFbtnTexture', rf.uiElements.context)
	local texture = rf.UI.texture
	texture:SetTextureAsync("RaidFinder", "gfx/rflogo.png")
	texture:SetPoint("TOPLEFT", button, "TOPLEFT")
	texture:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT")
	texture:SetVisible(true)
	texture:SetLayer(3)
	
	rf.UI.flashtexture = UI.CreateFrame ('Texture', 'RFflashTexture', rf.uiElements.context)
	local flashtexture = rf.UI.flashtexture
	flashtexture:SetTextureAsync("RaidFinder", "gfx/buttonflash.png")
	flashtexture:SetPoint("TOPLEFT", button, "TOPLEFT", (-5* rfsettings.aButtonS),(-5* rfsettings.aButtonS))
	flashtexture:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT",(5* rfsettings.aButtonS),(5* rfsettings.aButtonS))
	flashtexture:SetAlpha(0)
	flashtexture:SetVisible(true)
	flashtexture:SetLayer(3)

	
	local items = {}
	local subMenus
	
	button:EventAttach(Event.UI.Input.Mouse.Left.Click, function (self)
			if rf.visible == true then 
				rf.UI:closeUI()
			elseif rf.visible == false then
				rf.open()
			end
	end, "RFbutton.Left.Click")	
	
	local startY = rfsettings.aButtonY
	local startX = rfsettings.aButtonX
	local rightDown = false
	
	button:EventAttach(Event.UI.Input.Mouse.Right.Down, function (self)
		if rfsettings.UIlock == true then return end
		rightDown = true
		local mouseData = Inspect.Mouse()
		startX, startY = mouseData.x, mouseData.y
		
	end, "RaidFinder.Right.Down")	
	
	button:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function(self, _, x, y)
		if rfsettings.UIlock == true then return end
		if rightDown ~= true then return end
		
		local curdivX = x - startX
		local curdivY = y - startY
		
		button:SetPoint("CENTER", UIParent, "CENTER", rfsettings.aButtonX + curdivX, rfsettings.aButtonY + curdivY )
	end, "RaidFinder.Mouse.Cursor.Move")	
	
	button:EventAttach(Event.UI.Input.Mouse.Right.Up, function(self, _)	
		if rfsettings.UIlock == true then return end
		if rightDown ~= true then return end
		
		rightDown = false
		
		if startX == nil or startY == nil then return end
				
		local mouseData = Inspect.Mouse()
		local curdivX = mouseData.x - startX
		local curdivY = mouseData.y - startY	
			
		rfsettings.aButtonX = rfsettings.aButtonX + curdivX
		rfsettings.aButtonY = rfsettings.aButtonY + curdivY
		

	end, "RaidFinder.Right.Up")	
	
	button:EventAttach(Event.UI.Input.Mouse.Right.Upoutside, function(self)
		if rfsettings.UIlock == true then return end
		if rightDown ~= true then return end
		
		rightDown = false
		
		local mouseData = Inspect.Mouse()
		local curdivX = mouseData.x - startX
		local curdivY = mouseData.y - startY	
			
		rfsettings.aButtonX = rfsettings.aButtonX + curdivX
		rfsettings.aButtonY = rfsettings.aButtonY + curdivY
	end, "RaidFinder.Right.Upoutside")
	
	button:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function(self)
		if rfsettings.UIlock == true then return end
		
		rfsettings.aButtonS = rfsettings.aButtonS - 0.1	
		
		button:SetWidth(35 * rfsettings.aButtonS)
		button:SetHeight(35 * rfsettings.aButtonS)
		
		
	end, "RaidFinder.Wheel.Forward")
	
	button:EventAttach(Event.UI.Input.Mouse.Wheel.Back, function(self)
		if rfsettings.UIlock == true then return end
		
		rfsettings.aButtonS = rfsettings.aButtonS + 0.1	
		
		button:SetWidth(35 * rfsettings.aButtonS)
		button:SetHeight(35 * rfsettings.aButtonS)
		
		
	end, "RaidFinder.Wheel.Back")	
	
	
end

-- Utilities

function rf.testtable()


end


function rf.slash(params)
	local args = {}
	local argnumber = 0
	for argument in string.gmatch(params, "[^%s]+") do
		args[argnumber] = argument
		argnumber = argnumber + 1
	end
		
	if args[0] == nil then
		rf.open()
	elseif args[0] == "test" and argnumber == 1	then
		rf.broadcast(rf.broadcastdata)
	elseif args[0] == "debug" and argnumber == 1	then
		rf.debug = true
	elseif args[0] == "testtable" and argnumber == 1	then
		rf.testtable()
	else
	end
end

Command.Event.Attach(Event.Addon.Load.End, rf.main, "RaidFinder.Addon.Load.End")
Command.Event.Attach(Event.System.Secure.Enter, function() rf.secure = true end, "nkManager.Ssytem.Secure.Enter")
Command.Event.Attach(Event.System.Secure.Leave, function() rf.secure = false end, "nkManager.Ssytem.Secure.Leave")
table.insert(Event.Addon.SavedVariables.Load.End, 	{rf.settings, 			"RaidFinder", "VaiablesLoaded"})
table.insert(Event.Message.Receive, 				{rf.receive, 			"RaidFinder", "Received Message"})
table.insert(Command.Slash.Register("rf"), 			{rf.slash, 				"RaidFinder", "Slash Cmd"})
table.insert(Command.Slash.Register("RaidFinder"), 	{rf.slash, 				"RaidFinder", "Slash Cmd"})
