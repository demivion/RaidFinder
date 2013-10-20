local addonInfo, privateVars = ...

if not EnKai then EnKai = {} end
if not EnKai.coroutines then EnKai.coroutines = {} end

privateVars.coRoutines = {}

function EnKai.coroutines.add ( info )

	table.insert(privateVars.coRoutines, info )

end

function EnKai.coroutines.process ()

	if #privateVars.coRoutines > 0 then
		for idx = 1, #privateVars.coRoutines, 1 do
			if privateVars.coRoutines[idx].active == true then
				local go = true
				if privateVars.coRoutines[idx].delay ~= nil then
					if privateVars.coRoutines[idx].timeStamp == nil then
						privateVars.coRoutines[idx].timeStamp = Inspect.Time.Real()
					end
					
					if EnKai.tools.math.round((Inspect.Time.Real() - privateVars.coRoutines[idx].timeStamp), 1) < privateVars.coRoutines[idx].delay then 
						go = false
					else
						privateVars.coRoutines[idx].delay = nil						
					end					
				end			
			
				if go == true then
					local status, value = coroutine.resume(privateVars.coRoutines[idx].func, privateVars.coRoutines[idx].para1, privateVars.coRoutines[idx].para2)
					
					if status == false then 
						print ('error in coroutine: ' .. value)
						privateVars.coRoutines[idx].active = false
					elseif value == nil or value >= privateVars.coRoutines[idx].counter or status == false then
						privateVars.coRoutines[idx].active = false
					end
				end
			end
		end		
	end	

end