local addonInfo, privateVars = ...

function EnKai.ui.nkMenuEntry(name, parent) 

	local menuEntry = UI.CreateFrame ('Frame', name, parent)	
	local label = UI.CreateFrame ('Text', name .. '.label', menuEntry)	
	
	local properties = {}

	function menuEntry:SetValue(property, value)
		properties[property] = value
	end
	
	function menuEntry:GetValue(property)
		return properties[property]
	end
	
	local labelColor = { 1, 1, 1, 1 }
	local backgroundColor = { 0, 0, 0, 1 }
	local fontSize = 13
	
	menuEntry:SetBackgroundColor(backgroundColor[1], backgroundColor[2], backgroundColor[3], backgroundColor[4])
	menuEntry:SetSecureMode('restricted')
	
	label:SetPoint("CENTERLEFT", menuEntry, "CENTERLEFT")
	label:SetFontColor(labelColor[1], labelColor[2], labelColor[3], labelColor[4])
	label:SetFontSize(fontSize)
	label:SetHeight(fontSize+4)
	label:SetSecureMode('restricted')
		
	function menuEntry:SetFontColor(r, g, b, a)
		labelColor = { r, g, b, a}
		label:SetFontColor (r, g, b, a)
	end
	
	function menuEntry:SetFontSize(newFontSize)
		fontSize = newFontSize
		label:SetFontSize(newFontSize)
		label:SetHeight(newFontSize+6)
	end
	
	function menuEntry:SetText(text)
		label:ClearWidth()
		label:SetText(text)
		
		if menuEntry:GetWidth() < (label:GetWidth()+4) then
			menuEntry:SetWidth(label:GetWidth() + 4)
			return label:GetWidth() + 4
		end

		return nil		
	end
	
	local oSetWidth = menuEntry.SetWidth
	
	function menuEntry:SetWidth(newWidth)
		if newWidth < label:GetWidth() then
			label:SetWidth(newWidth)
		end
		
		oSetWidth(self, newWidth)
	end
	
	local oSetBackgroundColor = menuEntry.SetBackgroundColor
	
	function menuEntry:SetBackgroundColor(r, g, b, a)
		backgroundColor = { r, g, b, a }
		oSetBackgroundColor(self, r, g, b, a)
	end
			
	menuEntry:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		EnKai.eventHandlers[name]["Clicked"]()
	end, name .. ".Left.Click")	
	
	menuEntry:EventAttach(Event.UI.Input.Mouse.Cursor.In, function()
		oSetBackgroundColor(menuEntry, labelColor[1], labelColor[2], labelColor[3], labelColor[4])
		label:SetFontColor(backgroundColor[1], backgroundColor[2], backgroundColor[3], backgroundColor[4])
	end, name .. ".Mouse.Cursor.In")
	
	menuEntry:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function()
		label:SetFontColor(labelColor[1], labelColor[2], labelColor[3], labelColor[4])
		oSetBackgroundColor(menuEntry, backgroundColor[1], backgroundColor[2], backgroundColor[3], backgroundColor[4])
	end, name .. ".Mouse.Cursor.Out")
	
	EnKai.eventHandlers[name] = {}
	EnKai.events[name] = {}
	EnKai.eventHandlers[name]["Clicked"], EnKai.events[name]["Clicked"] = Utility.Event.Create(addonInfo.identifier, name .. "Clicked")
	
	return menuEntry
	
end