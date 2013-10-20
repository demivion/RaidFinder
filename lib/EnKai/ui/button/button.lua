local addonInfo, privateVars = ...

function EnKai.ui.nkButton(name, parent) 

	local button = UI.CreateFrame ('Frame', name, parent)
	local texture = UI.CreateFrame ('Texture', name .. 'texture', button)
	local tint = UI.CreateFrame ('Frame', name .. 'tint', button)
	local label = UI.CreateFrame ('Text', name .. 'label', button)
	
	local properties = {}

	function button:SetValue(property, value)
		properties[property] = value
	end
	
	function button:GetValue(property)
		return properties[property]
	end
	
	local tintColor = { .8, .8, .8 }	
	local labelColor = { 0.2, 0.2, 0.2, 1 }
	local scale = 1
	
	button:SetWidth(123)
	button:SetHeight(33)
	
	texture:SetTextureAsync ("EnKai", "gfx/button.png")
	texture:SetPoint("TOPLEFT", button, "TOPLEFT")
	texture:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT")
	texture:SetLayer(1)
	
	tint:SetPoint("TOPLEFT", button, "TOPLEFT")
	tint:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT")
	tint:SetLayer(2)
	tint:SetBackgroundColor(tintColor[1], tintColor[2], tintColor[3], 0.6)
	
	label:SetPoint("CENTER", button, "CENTER")
	label:SetFontSize(16)
	label:SetFontColor(labelColor[1], labelColor[2], labelColor[3], labelColor[4] )
	label:SetHeight(18)
	label:SetLayer(3)
	
	label:SetEffectGlow({ offsetX = 0, offsetY = 2, colorR = 0.8, colorG = 0.8, colorB = 0.8})
		
	function button:SetText(newText)
		label:SetText(newText)
		label:ClearAll()
		label:SetPoint("CENTER", button, "CENTER")
		if label:GetWidth() > button:GetWidth() - (10  / scale) then label:SetWidth(button:GetWidth() - ( 10 / scale) ) end
	end
	
	function button:SetColor(r, g, b)
		tintColor = { r, g, b }
		tint:SetBackgroundColor(r, g, b, 0.6)
	end
	
	function button:SetFontColor(r, g, b)
		labelColor = { r, g, b, 1 }
		label:SetFontColor(labelColor[1], labelColor[2], labelColor[3], labelColor[4] )
	end
	
	function button:SetScale(newScale)
		scale = newScale
		button:SetWidth(123 * newScale)
		button:SetHeight(33 * newScale)
		label:SetFontSize(16 * newScale)
		label:SetHeight (20 * newScale)
		
		if label:GetWidth() > button:GetWidth() - (10  / scale) then label:SetWidth(button:GetWidth() - ( 10 / scale) ) end
	
	end
	
	button:EventAttach(Event.UI.Input.Mouse.Cursor.In, function ()
		tint:SetVisible(false)
	end, name .. "_Cursor_In")	
		
	button:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function ()
		tint:SetVisible(true)
	end, name .. "_Cursor_out")	
	
	button:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		EnKai.eventHandlers[name]["Clicked"]()
	end, name .. "_Left_Click")

	EnKai.eventHandlers[name] = {}
	EnKai.events[name] = {}
	EnKai.eventHandlers[name]["Clicked"], EnKai.events[name]["Clicked"] = Utility.Event.Create(addonInfo.identifier, name .. "Clicked")
		
	return button
	
end