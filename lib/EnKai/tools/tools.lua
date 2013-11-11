local addonInfo, privateVars = ...

if not EnKai then EnKai = {} end
if not EnKai.tools then EnKai.tools = {} end

EnKai.tools.table = {}
EnKai.tools.math = {}
EnKai.tools.lang = {}
EnKai.tools.error = {}

EnKai.tools.color = {}		-- obsolete will be removed at some point
EnKai.tools.settings = {}	-- obsolete will be removed at some point
EnKai.tools.various = {}	-- obsolete will be removed at some point


privateVars.curLanguage = Inspect.System.Language()

-- ========== TABLE HANDLING ==========

function EnKai.tools.table.isMember (checkTable, element)
  
  for idx, value in pairs(checkTable) do
    if value == element then return true end
  end
  
  return false
  
end

function EnKai.tools.table.getTablePos (checkTable, element)

	for idx, value in pairs (checkTable) do
		if value == element then return idx end
	end
	
	return -1

end

function EnKai.tools.table.getSortedKeys (tableData)

	local tempTable = {}
    
    for k, data in pairs(tableData) do 
        table.insert(tempTable, k) 
    end
	
	table.sort(tempTable, function (a, b) return string.lower(a) < string.lower(b) end)
	return tempTable
	
end

function EnKai.tools.table.merge (table1, table2)

	for k, v in pairs (table2) do
		table.insert (table1, v)
	end

end

function EnKai.tools.table.mergeIndexed (table1, table2)

	for k, v in pairs (table2) do
		table1[k] = v
	end

end

function EnKai.tools.table.getKeyByValue (tableData, value)

	for k, v in pairs (tableData) do
		if v == value then return k end
	end
	
	return nil

end

function EnKai.tools.table.copy (tableToCopy)

    local lookup_table = {}
    local function _copy(tableToCopy)
        if type(tableToCopy) ~= "table" then
            return tableToCopy
        elseif lookup_table[tableToCopy] then
            return lookup_table[tableToCopy]
        end
        local new_table = {}
        lookup_table[tableToCopy] = new_table
        for index, value in pairs(tableToCopy) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(tableToCopy))
    end
    return _copy(tableToCopy)
end

function EnKai.tools.table.getSize (checkTable)

  local count = 0
  for _ in pairs(checkTable) do count = count + 1 end
  return count
  
end

function EnKai.tools.table.serialize (inTable)

	local retValue = ""
	local isFirst = true

	for k, v in pairs (inTable) do
		if isFirst == false then retValue = retValue .. ',' end
	
		if type(k) == 'string' then
			if string.find(k, " ") then
				retValue = retValue .. '["' .. k .. '"]='
			else
				retValue = retValue .. k .. '='
			end
		end
	
		if type(v) == 'table' then
			retValue = retValue .. "{" .. EnKai.tools.table.serialize (v) .. "}"
		elseif type(v) == 'string' then
			retValue = retValue .. '"' .. v .. '"'
		elseif type(v) == 'boolean' then
			if v == true then
				retValue = retValue .. "true"
			else
				retValue = retValue .. "false"
			end
		else
			retValue = retValue .. v
		end
		
		isFirst = false
	end
	
	return retValue
end

-- ========== MATH FUNCTIONS ==========

function EnKai.tools.math.round (num, idp)

	if num == nil then return nil end

	local mult = 10^(idp or 0)
	return math.floor(tonumber(num) * mult + 0.5) / mult
end

-- ========== LANGUAGE HANDLING ==========

function EnKai.tools.lang.getLanguage ()

	if EnKaiSetup == nil then
		return privateVars.curLanguage
	elseif EnKaiSetup.language == nil then 
		return privateVars.curLanguage
	else
		return EnKaiSetup.language
	end

end

function EnKai.tools.lang.getLanguageShort ()

	if EnKai.tools.lang.getLanguage() == 'German' then
		return 'DE'
	elseif EnKai.tools.lang.getLanguage() == 'French' then		
		return 'FR'
	elseif EnKai.tools.lang.getLanguage() == 'Russian' then		
		return 'RU'
	else
		return 'EN'
	end

end

function EnKai.tools.lang.setLanguage (language) 

	if EnKaiSetup == nil then EnKaiSetup = {} end
	EnKaiSetup.language = language
	privateVars.curLanguage = language 

end

function EnKai.tools.lang.resetLanguage()

	if EnKaiSetup == nil then EnKaiSetup = {} end
	EnKaiSetup.language = nil

end


-- ========== ERROR HANDLING ==========

function EnKai.tools.error.display (addon, message, level)

	local color, type
	if level == 1 then
		color = "#FF0000"
		type = "FATAL ERROR"
	elseif level == 2 then
		color = "#FF6A00"
		type = "ERROR"
	elseif level == 3 then
		color = "FFD800"
		type = "WARNING"		
	else
		color = "#FFFFFF"
		type = "INFO"
	end

	Command.Console.Display("general", true, string.format('<font color="%s">%s in %s: %s</font>', color, type, addon, message), true)

end



-- ********************** NO LONGER USED METHODS - WILL BE REMOVED AT SOME POINT **********************


-- ========== COLOR TOOLS ==========

function EnKai.tools.color.HexToRGB(hexValue)

	if type(hexValue) ~= "string" then return nil end
	if string.len(hexValue) < 6 then return nil end
	
	local retValue = {}
	
	for i = 1, 6, 2 do		
		local subString = string.sub(hexValue, i, (i+1))
		local decValue = tonumber(subString, 16)
		table.insert (retValue, (1 / 255 * decValue))
	end
	
	return retValue
	
end

function EnKai.tools.color.RGBToHex(red, green, blue)

	local redHex = EnKai.tools:DecToHex(red)
	local greenHex = EnKai.tools:DecToHex(green)
	local blueHex = EnKai.tools:DecToHex(blue)
	
	local retValue = ''
	
	if red == 0 then
		retValue = '00'
	elseif string.len(redHex) == 1 then
		retValue = '0' .. redHex
	else
		retValue = redHex
	end

	if green == 0 then
		retValue = retValue .. '00'
	elseif string.len(greenHex) == 1 then
		retValue = retValue .. '0' .. greenHex
	else
		retValue = retValue .. greenHex
	end
	
	if blue == 0 then
		retValue = retValue .. '00'
	elseif string.len(blueHex) == 1 then
		retValue = retValue .. '0' .. blueHex
	else
		retValue = retValue .. blueHex
	end

	return retValue
	
end

function EnKai.tools.color.DecToHex(value)

    local b,k,result,i,d=16,"0123456789ABCDEF","",0
	
    while value > 0 do
        i=i+1
        value,d = math.floor(value/b),math.mod(value,b)+1
        result=string.sub(k,d,d)..result
    end
	
    return result
	
end

function EnKai.tools.color.ColorAdjust(color, adjust)

	if type(color) ~= "string" then return nil end
	if string.len(color) < 6 then return nil end
	local newColor = ''
	
	for i = 1, 6, 2 do		
		local subString = string.sub(color, i, (i+1))
		local decValue = tonumber(subString, 16)
		decValue = decValue * adjust
		local hex = EnKai.tools:DecToHex(decValue)
		if string.len(hex) == 1 then hex = '0' .. hex end			
		newColor = newColor .. hex
	end
	
	return newColor

end

-- ========== VARIOUS FUNCTIONS ==========

function EnKai.tools.various.convertSeconds (seconds)

	if seconds == nil then return nil end

	if seconds <= 60 then return string.format ('%dS', seconds) end
	local minutes = seconds / 60
	return string.format ('%dM', EnKai.tools.math.round(minutes, 0))

end

function EnKai.tools.various.getSystemVersion ()

	local version = Inspect.System.Version()
	local tempArray = EnKai.strings.split(version.internal,'-')
	
	return tempArray[2]

end

-- ========== SETTINGS HANDLING ==========

function EnKai.tools.settings.checkSettings (savedVariable, defaultValues)

	if savedVariable == nil then 
		return EnKai.tools.table.copy(defaultValues)
	else
		local newTable = EnKai.tools.table.copy(savedVariable)
	
		for k, v in pairs (defaultValues) do
			if newTable[k] == nil then
				newTable[k] = EnKai.tools.table.copy(v)
			elseif type(v) == 'table' then
				for subK, subV in pairs (v) do
					if newTable[k][subK] == nil then 
						if type(subV) == 'table' then
							newTable[k][subK] = EnKai.tools.table.copy(subV)
						else
							newTable[k][subK] = subV 
						end
					end
				end
			end
		end
		
		return newTable
	end

end
