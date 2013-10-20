local addonInfo, privateVars = ...

if not EnKai then EnKai = {} else return end
if not EnKai.manager then EnKai.ui = {} end

EnKai.eventHandlers = {}
EnKai.events = {}

function EnKai.settingsHandler()
	
	local settings = {
		mmButtonX = - 231,
		mmButtonY = 37,
		locked = true
	}
	
	if EnKaiSetup == nil then
		if nkManagerSettings ~= nil then		
			EnKaiSetup = nkManagerSettings
		else
			EnKaiSetup = settings
		end
	else
		for k, v in pairs (settings) do if EnKaiSetup[k] == nil then EnKaiSetup[k] = v end end
	end
		
end

Command.Event.Attach(Event.Addon.SavedVariables.Load.End, EnKai.settingsHandler, "EnKai.settingsHandler.SavedVariables.Load.End")