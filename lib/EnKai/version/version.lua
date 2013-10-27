local addonInfo, privateVars = ...

if not EnKai then EnKai = {} end
if not EnKai.version then EnKai.version = {} end

privateVars.playerStore = {}

local function checkVersion (myVersion, reportedVersion)

	-- returns false if the myVersion is smaller than reportedVersion

	local myVersionArray = EnKai.strings.split(myVersion, '%.')
	local reportedVersionArray = EnKai.strings.split(reportedVersion, '%.')
	
	if #myVersionArray ~= #reportedVersionArray then return false end
	
	for idx = 1, #myVersionArray, 1 do
		if tonumber(myVersionArray[idx]) == nil or tonumber(reportedVersionArray[idx]) == nil then return true end -- always report true if version number is not completely number
	
		if tonumber(myVersionArray[idx]) < tonumber(reportedVersionArray[idx]) then
			return false
		elseif tonumber(myVersionArray[idx]) > tonumber(reportedVersionArray[idx]) then			
			return true
		end
	end	

	return true	

end

function EnKai.version.init(addonName, addonVersion)	

	if EnKaiSetup.addonVersions [addonName] == nil then EnKaiSetup.addonVersions [addonName] = {} end

	EnKaiSetup.addonVersions [addonName].localVersion = addonVersion
	if EnKaiSetup.addonVersions [addonName].latestVersion == nil or checkVersion (addonVersion, EnKaiSetup.addonVersions [addonName].latestVersion) == true then 
		 EnKaiSetup.addonVersions [addonName].latestVersion = addonVersion
	end 
	
end

local function EventLoadSettings() 

	if EnKaiSetup == nil then EnKaiSetup = {} end
	if EnKaiSetup.addonVersions == nil then EnKaiSetup.addonVersions = {} end
end

local function EventStartupEnd () 
	for k, v in pairs (EnKaiSetup.addonVersions) do
		if v.localVersion ~= nil then
			local detail = Inspect.Addon.Detail(k)
			if detail == nil then
				--print ('deregister local version of ' .. k)
				EnKaiSetup.addonVersions[k].localVersion = nil
			end
		end
	end
end

local function EventUnitAvailable(_, units)

	if privateVars.playerUnit == nil then privateVars.playerUnit = Inspect.Unit.Detail('player') end
	if privateVars.playerUnit == nil or privateVars.playerUnit.availability == nil or privateVars.playerUnit.availability ~= "full" then
		privateVars.playerUnit = nil
		return
	end
	
	for k, v in pairs (units) do
		if k ~= privateVars.playerUnit.id and privateVars.playerStore[k] == nil then
			local details = Inspect.Unit.Detail(k)
			if details ~= nil and details.availability ~= nil and details.availability == "full" and details.player==true then
				privateVars.playerStore[k] = true
				Command.Message.Send(details.name, "EnKai.version", "getVersions", function() end)
			end
		end
	end

end

local function EventProcessMessage(_, from, type, channel, identifier, data)

	if identifier ~= "EnKai.version" then return end

	if data == "getVersions" then
	
		local reportTable = {}
		for k, v in pairs (EnKaiSetup.addonVersions) do
			reportTable[k] = v.latestVersion
		end
	
		local msgString = "info=" .. EnKai.tools.table.serialize (reportTable)		
		Command.Message.Send(from, "EnKai.version", msgString, function() end)
	elseif string.find(data, "info=") == 1 then
		local tempString = EnKai.strings.right (data, "info=")
		local versionsFunc = loadstring("return {".. tempString .. "}")
		local versions = versionsFunc()					
		if versions == nil then return end
		for k, v in pairs (versions) do
			if EnKaiSetup.addonVersions[k] == nil then
				EnKaiSetup.addonVersions[k] = {}
				EnKaiSetup.addonVersions[k].latestVersion = v
			elseif EnKaiSetup.addonVersions[k].localVersion ~= nil then
				if checkVersion(EnKaiSetup.addonVersions[k].latestVersion, v) == false then
					-- the highest known version is smaller than the reported version
					Command.Console.Display("general", true, string.format(privateVars.langTexts.addonUpdate, v, k), true)
					EnKaiSetup.addonVersions[k].latestVersion = v										
				elseif checkVersion(EnKaiSetup.addonVersions[k].localVersion, v) == false then
					-- the local version is smaller than the reported version 
					if EnKaiSetup.addonVersions[k].lastUserInfo == nil or Inspect.Time.Server() - EnKaiSetup.addonVersions[k].lastUserInfo > 86400 then
						-- only report once a day
						EnKaiSetup.addonVersions[k].lastUserInfo = Inspect.Time.Server()
						Command.Console.Display("general", true, string.format(privateVars.langTexts.addonUpdate, v, k), true)
					end
				end 
			end
		end		
	end

end

Command.Message.Accept(nil, "EnKai.version")
Command.Event.Attach(Event.Unit.Availability.Full, EventUnitAvailable, "EnKai.version.Unit.Availability.Full")
Command.Event.Attach(Event.Message.Receive, EventProcessMessage, "EnKai.version.Message.Receive")
Command.Event.Attach(Event.Addon.SavedVariables.Load.End, EventLoadSettings, "EnKai.version.SavedVariables.Load.End")
Command.Event.Attach(Event.Addon.Startup.End, EventStartupEnd, "EnKai.version.Startup.End")