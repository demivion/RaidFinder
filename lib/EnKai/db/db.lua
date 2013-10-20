local addonInfo, privateVars = ...
 
EnKai.db = {}

privateVars.dbTable = {}

function EnKai.db.open (tableName )

	if privateVars.dbTable[tableName] ~= nil then return end

	privateVars.dbTable[tableName] = { index = {}, data = {} }

end

function EnKai.db.close (tableName)

	if privateVars.dbTable[tableName] == nil then return end
	
	privateVars.dbTable[tableName] = nil

end

function EnKai.db.create ( tableName, data )

	if privateVars.dbTable[tableName] == nil then return end

	for k, v in pairs(data) do
		--privateVars.dbTable[tableName][k] = v
		table.insert(privateVars.dbTable[tableName].data, data)
		privateVars.dbTable[tableName].index[data.key] = #privateVars.dbTable[tableName]		
	end	
	
end

function EnKai.db.get (tableName, start, count)

	if privateVars.dbTable[tableName] == nil then return end

	if start and count then
		local retTable = {}

		for idx = start, count, 1 do			
			table.insert(retTable, privateVars.dbTable[tableName].data[idx])
		end
		
		return retTable
	else
		return EnKai.tools.table.copy(privateVars.dbTable[tableName].data)
	end

end