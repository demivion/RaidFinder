nkGenie = {
	ExtButton = {},
	ExtCheckbox = {},
	ExtCombo = {},
	ExtDialog = {},
	ExtFrame = {},
	ExtGrid = {},
	ExtItemTooltip = {},
	ExtMenu = {},
	ExtRadioButton = {},
	ExtRiftButton = {},
	ExtRiftWindow = {},
	ExtScrollBox = {},
	ExtSlider = {},
	ExtTabPane = {},
	ExtText = {},
	ExtTextField = {},
	ExtTexture = {},
    ExtWindow = {},	
	Tools = {}
}

if ( Inspect.System.Language() == "German") then
	nkGenie.langTexts = {	yes  = 'Ja',
							no = 'Nein',
							ok = 'Ok',
							bop = 'Binden beim Aufheben',
							account = 'An Account gebunden',
							bound = 'Seelengebunden'}
else
	nkGenie.langTexts = {	yes  = 'Yes',
							no = 'No',
							ok = 'Ok',
							bop = 'Bind on Pickup',
							account = 'Account Bound',
							bound = 'Soldbound'}
end

nkGenie.UIElements = { 
	nkExtButton		= nkGenie.ExtButton,
	nkExtCheckbox 	= nkGenie.ExtCheckbox,
	nkExtCombo		= nkGenie.ExtCombo,
	nkExtDialog		= nkGenie.ExtDialog,
	nkExtFrame		= nkGenie.ExtFrame,
	nkExtGrid		= nkGenie.ExtGrid,
	nkExtItemTooltip= nkGenie.ExtItemTooltip,
	nkExtMenu		= nkGenie.ExtMenu,
	nkExtRadioButton= nkGenie.ExtRadioButton,
	nkExtRiftButton = nkGenie.ExtRiftButton,
	nkExtRiftWindow = nkGenie.ExtRiftWindow,
	nkExtSlider		= nkGenie.ExtSlider,
	nkExtScrollBox	= nkGenie.ExtScrollBox,
	nkExtTabPane	= nkGenie.ExtTabPane,
	nkExtText		= nkGenie.ExtText,
	nkExtTextField  = nkGenie.ExtTextField,
	nkExtTexture	= nkGenie.ExtTexture,
	nkExtWindow		= nkGenie.ExtWindow
}

nkGenie.context = UI.CreateContext("nkGenie")

local _UICreateFrame = UI.CreateFrame

UI.CreateFrame = function(type, name, parent, settings)

  if nkGenie.UIElements[type] ~= nil then
	local element = nkGenie.UIElements[type]:new (name, parent, settings)
	if settings ~= nil then element:update(settings) end
	return element
  else
    return _UICreateFrame(type, name, parent)
  end
  
end

function nkGenie.Tools:HexToRGB(hexValue)

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

function nkGenie.Tools:DecToHex(value)

    local b,k,result,i,d=16,"0123456789ABCDEF","",0
	
    while value > 0 do
        i=i+1
        value,d = math.floor(value/b),math.mod(value,b)+1
        result=string.sub(k,d,d)..result
    end
	
    return result
	
end

function nkGenie.Tools:ColorAdjust(color, adjust)

	if type(color) ~= "string" then return nil end
	if string.len(color) < 6 then return nil end
	local newColor = ''
	
	for i = 1, 6, 2 do		
		local subString = string.sub(color, i, (i+1))
		local decValue = tonumber(subString, 16)
		decValue = decValue * adjust
		local hex = nkGenie.Tools:DecToHex(decValue)
		if string.len(hex) == 1 then hex = '0' .. hex end			
		newColor = newColor .. hex
	end
	
	return newColor

end