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

-- old functions to be replaced a one point when I made sure they are no longer in use

function string:split(delimiter)
  
  local result = { }
  local from = 1

  local delim_from, delim_to = string.find( self, delimiter, from )
  
  while delim_from do
    table.insert( result, string.sub( self, from , delim_from-1 ) )
    from = delim_to + 1
    delim_from, delim_to = string.find( self, delimiter, from )
  end
  table.insert( result, string.sub( self, from ) )
  return result
  
end

function string:strRight (value)

	local pos, len = string.find ( self, value)
	if pos == nil then return value end
	
	pos = pos + len
	return string.sub ( self, pos)

end

function string:strRightRegEx (value)

	local pos, len = string.find ( self, value)
	if pos == nil then return value end
	
	pos = pos + len
	return string.sub ( self, pos)

end

function string:strLeft (value)

	local pos = string.find ( self, value)
	return string.sub ( self, 1, pos)

end