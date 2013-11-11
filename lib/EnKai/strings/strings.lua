local addonInfo, privateVars = ...

if not EnKai then EnKai = {} end
if not EnKai.strings then EnKai.strings = {} end

-- ========== STRING HANDLING ==========

function EnKai.strings.split(text, delimiter)
  
  local result = { }
  local from = 1

  local delim_from, delim_to = string.find( text, delimiter, from )
  
  while delim_from do
    table.insert( result, string.sub( text, from , delim_from-1 ) )
    from = delim_to + 1
    delim_from, delim_to = string.find( text, delimiter, from )
  end
  table.insert( result, string.sub( text, from ) )
  return result
  
end

function EnKai.strings.left (value, delimiter)

	local pos = string.find ( value, delimiter)
	return string.sub ( value, 1, pos)

end

function EnKai.strings.leftBack (value, delimiter)

	local temp = EnKai.strings.split(value, delimiter)
	
	local pos = string.find ( value, temp[#temp])
	return string.sub ( value, 1, pos - string.len(delimiter))

end

function EnKai.strings.rightBack (value, delimiter)

	local temp = EnKai.strings.split(value, delimiter)
	
	local pos = string.find ( value, temp[#temp])
	return string.sub ( value, pos)

end

function EnKai.strings.right (value, delimiter)

	local pos = string.find ( value, delimiter)
	return string.sub ( value, pos + string.len(delimiter))

end

function EnKai.strings.formatNumber (value)
	
	local formatted, k = value, nil
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then break end
	end
	return formatted
	
end