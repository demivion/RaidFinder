local addonInfo, privateVars = ...

function EnKai.ui.nkInfoText(name, parent) 

	local infoText = UI.CreateFrame ('Frame', name, parent)
	local label = UI.CreateFrame ('Text', name .. 'label', infoText)
	local texture = UI.CreateFrame ('Texture', name .. 'texture', infoText)
	
	local properties = {}

	function infoText:SetValue(property, value)
		properties[property] = value
	end
	
	function infoText:GetValue(property)
		return properties[property]
	end

	local fontColor = { 1, 1, 1, 1 }
	local fontSize = 12
	
	infoText:SetWidth(100)
	infoText:SetHeight(20)
	
	texture:SetPoint("CENTERLEFT", infoText, "CENTERLEFT")
	texture:SetWidth(20)
	texture:SetHeight(20)
	
	label:SetPoint("CENTERLEFT", infoText, "CENTERLEFT", texture:GetWidth(), 0)
	label:SetFontSize(fontSize)
	label:SetFontColor(fontColor[1], fontColor[2], fontColor[3], fontColor[4])
	label:SetHeight(fontSize + 4)
	label:SetWordwrap(true)
	
	function infoText:SetText(newText)
		label:SetText(newText, true)
		label:ClearWidth()
		if label:GetWidth() > infoText:GetWidth() - texture:GetWidth() then label:SetWidth(infoText:GetWidth() - texture:GetWidth()) end
		label:ClearHeight()
		if label:GetWidth() > infoText:GetHeight() then label:SetHeight(infoText:GetHeight()) end
	end
	
	function infoText:SetType(infoType)
		if infoType == 'warning' then
			texture:SetTextureAsync('EnKai', 'gfx/iconWarning.png')
		else
			texture:SetTextureAsync('EnKai', 'gfx/iconInfo.png')
		end
	end
	
	function infoText:SetFontSize(newFontSize)
		label:SetFontSize(newFontSize)
		label:SetHeight(newFontSize+4)
		
		texture:SetWidth(math.floor(20 * (newFontSize / 12)))
		texture:SetHeight(math.floor(20 * (newFontSize / 12)))
		
		label:ClearWidth()
		if label:GetWidth() > infoText:GetWidth() - texture:GetWidth() then label:SetWidth(infoText:GetWidth() - texture:GetWidth()) end
	end	
	
	local oSetWidth, oSetHeight = infoText.SetWidth, infoText.SetHeight
	
	function infoText:SetWidth(newWidth)		
		oSetWidth(self, newWidth)
		label:ClearWidth()
		label:SetWidth(newWidth - texture:GetWidth())		
	end
	
	function infoText:SetHeight(newHeight)
		oSetHeight(self, newHeight)
		label:SetHeight(newHeight)
	end
	
	function infoText:SetIconAlign(newAlign, x, y)
		local left, top, right, bottom = texture:GetBounds()
		
		texture:ClearAll()
		texture:SetWidth(right-left)
		texture:SetHeight(bottom-top)
	
		if newAlign == "top" then
			texture:SetPoint("TOPLEFT", infoText, "TOPLEFT", 0, 2)
		elseif newAlign == "center" then
			texture:SetPoint("CENTERLEFT", infoText, "CENTERLEFT")
		else
			texture:SetPoint("BOTTOMLEFT", infoText, "BOTTOMLEFT", 0, -2)
		end
	end
	
	function infoText:SetFontColor(r, g, b, a)
		fontColor = { r, g, b, a }
		label:SetFontColor(r, g, b, a)
	end
	
	return infoText
	
end