local addonInfo, privateVars = ...

if not EnKai then EnKai = {} end
if not EnKai.fx then EnKai.fx = {} end

privateVars.fx = {}

function EnKai.fx.register (id, frame, effect)

	privateVars.fx[id] = { frame = frame, effect = effect }
	privateVars.fx[id].lastUpdate = Inspect.Time.Real()

end

function EnKai.fx.cancel (id)

	privateVars.fx[id] = nil

end

function EnKai.fx.updateTime (id)
	privateVars.fx[id].lastUpdate = Inspect.Time.Real()

end

function EnKai.fx.pauseEffect(id)
	privateVars.fx[id].lastUpdate = nil
end

function EnKai.fx.process()

	for id, details in pairs (privateVars.fx) do
		if details.effect.id == 'timedhide' then
			if privateVars.fx[id].lastUpdate ~= nil then
				if Inspect.Time.Real() - privateVars.fx[id].lastUpdate > details.effect.duration then
					privateVars.fx[id].lastUpdate = nil
					details.effect.callback()
				end	
			else
			end 
		end
	end

end