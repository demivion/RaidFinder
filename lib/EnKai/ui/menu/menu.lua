local addonInfo, privateVars = ...

function EnKai.ui.nkMenu(name, parent) 

	local menu = UI.CreateFrame ('Frame', name, parent)	
	local menuInner = UI.CreateFrame ('Frame', name, menu)	
	
	local entries = {}
	
	local properties = {}

	function menu:SetValue(property, value)
		properties[property] = value
	end
	
	function menu:GetValue(property)
		return properties[property]
	end
	
	local fontSize = 13
	local labelColor = { 1, 1, 1, 1 }
	local borderColor = { 1, 1, 1, 1 }
	local backgroundColor = { 0, 0, 0, 1 }
	local menuHeight = 2
	
	menu:SetBackgroundColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
	menu:SetSecureMode('restricted')
	
	menuInner:SetPoint("TOPLEFT", menu, "TOPLEFT", 1, 1)
	menuInner:SetPoint("BOTTOMRIGHT", menu, "BOTTOMRIGHT", -1, -1)
	menuInner:SetBackgroundColor(backgroundColor[1], backgroundColor[2], backgroundColor[3], backgroundColor[4])
	menuInner:SetSecureMode('restricted')
	
	function menu:AddEntry (newEntry)
		local menuEntry = EnKai.uiCreateFrame('nkMenuEntry', name .. '.entry.' .. (#entries + 1), menuInner)
		
		menuEntry:SetWidth(menuInner:GetWidth())
		local newWidth = menuEntry:SetText(newEntry.label)
		menuEntry:SetFontColor(labelColor[1], labelColor[2], labelColor[3], labelColor[4] )
		menuEntry:SetFontSize(fontSize)
		menuEntry:SetHeight(fontSize+6)
		menuEntry:SetBackgroundColor(backgroundColor[1], backgroundColor[2], backgroundColor[3], backgroundColor[4])
		
		if #entries == 0 then
			menuEntry:SetPoint("TOPLEFT", menuInner, "TOPLEFT")
		else
			menuEntry:SetPoint("TOPLEFT", entries[#entries], "BOTTOMLEFT")
		end
		
		if newEntry.callBack ~= nil then		
			Command.Event.Attach(EnKai.events[name .. '.entry.' .. (#entries + 1)].Clicked, function ()
				newEntry.callBack()
			end, name .. '.entry.' .. (#entries + 1) .. 'Clicked')
		end
		
		if newEntry.macro ~= nil then
			menuEntry:EventMacroSet(Event.UI.Input.Mouse.Left.Click, newEntry.macro)
		end
		
		table.insert(entries, menuEntry)
		
		menuHeight = menuHeight + fontSize + 6
		menu:SetHeight (menuHeight)		
		if newWidth ~= nil then menu:SetWidth(newWidth) end
		
	end
	
	function menu:AddSeparator()
	
		local separator = UI.CreateFrame('Frame', name .. '.separator' .. (#entries + 1), menuInner)
		
		if #entries == 0 then
			separator:SetPoint("TOPLEFT", menuInner, "TOPLEFT")
		else
			separator:SetPoint("TOPLEFT", entries[#entries], "BOTTOMLEFT", 0, 4)
		end
		
		separator:SetBackgroundColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4] )
		separator:SetHeight(1)
		separator:SetWidth(menuInner:GetWidth())
		
		menuHeight = menuHeight + 7
		menu:SetHeight (menuHeight)
		
		table.insert(entries, separator)
		
	end
	
	function menu:SetFontSize(newFontSize)
		fontSize = newFontSize
	
		for k, v in pairs (entries) do
			v:SetFontSize(newFontSize)
		end
	end

	local oSetWidth, oSetHeight = menu.SetWidth, menu.SetHeight
	
	function menu:SetWidth(newWidth)
		oSetWidth(self, newWidth)			
		for k, v in pairs (entries) do
			v:SetWidth(menuInner:GetWidth())
		end
	end

	local oSetBackgroundColor = menu.SetBackgroundColor

	function menu:SetBorderColor(r, g, b, a)
		borderColor = { r, g, b, a }
		oSetBackgroundColor( self, r, g, b, a)
	end
	
	function menu:SetBackgroundColor(r, g, b, a)
		backgroundColor = { r, g, b, a }
		menuInner:SetBackgroundColor (r, g, b, a)
	end
	
	function menu:SetLabelColor (r, g, b, a)
		labelColor = { r, g, b, a }
		for k, v in pairs (entries) do
			v:SetLabelColor(r, g, b, a)
		end
	end
	
	
	function menu:GetEntryCount()
		return #entries
	end
	
	function menu:GetEntries()
		return entries
	end
	
	
	return menu
	
end