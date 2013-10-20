local addonInfo, privateVars = ...

function EnKai.ui.nkGridHeaderCell(name, parent) 

	-- pre-define ui elements --
	
	local headerCell = UI.CreateFrame ('Frame', name, parent)
	local inner = UI.CreateFrame ('Frame', name .. 'inner', headerCell)
	local label = UI.CreateFrame ('Text', name .. 'label', inner)

	local properties = {}

	function headerCell:SetValue(property, value)
		properties[property] = value
	end
	
	function headerCell:GetValue(property)
		return properties[property]
	end
	
	-- default values --
	
	local borderColor = { 1, 1, 1, 1 }
	local bodyColor = { 0, 0, 0, 1 }
	local labelColor = { 1, 1, 1, 1 }
	local fontSize = 13
	local height = fontSize + 7
	local width = 50 
	local align = "center"
	local orientation = "CENTERLEFT"
	
	-- fill ui elements with live --
	
	headerCell:SetWidth(width)
	headerCell:SetHeight(height)
	headerCell:SetBackgroundColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
	
	inner:SetPoint ("TOPLEFT", headerCell, "TOPLEFT", 1, 1)
	inner:SetPoint ("BOTTOMRIGHT", headerCell, "BOTTOMRIGHT", -1, -1)
	inner:SetBackgroundColor(bodyColor[1], bodyColor[2], bodyColor[3], bodyColor[4])
	
	label:SetPoint ("CENTER", inner, "CENTER")
	--label:SetWidth (width)
	label:SetFontColor (labelColor[1], labelColor[2], labelColor[3], labelColor[4])
	label:SetFontSize (fontSize)
	label:SetHeight (height - 2)
	if inner:GetWidth() < label:GetWidth() then label:SetWidth(inner:GetWidth()) end
	
	function headerCell:SetText(text)
		if text ~= nil then label:SetText(text) end
	end
	
	function headerCell:SetLabelColor(r, g, b, a)
		label:SetFontColor(r, g, b, a)
	end
	
	function headerCell:SetBorderColor(r, g, b, a)
		headerCell:SetBackgroundColor(r, g, b, a)
	end
	
	function headerCell:SetBodyColor(r, g, b, a)
		inner:SetBackgroundColor(r, g, b, a)
	end
	
	function headerCell:SetAlign(newAlign)
		align = newAlign
		
		if align == 'center' then
			orientation = "CENTER"
		else
			orientation = "CENTERLEFT"
		end
		
		label:ClearAll()
		label:SetPoint (orientation, inner, orientation)
		if inner:GetWidth() < label:GetWidth() then label:SetWidth(inner:GetWidth()) end
	end
	
	function headerCell:SetFontSize(newFontSize)
	
		if height == fontSize + 7 then height = newFontSize + 7 end
	
		fontSize = newFontSize
		label:SetFontSize(fontSize)
		headerCell:SetHeight(height)
		if inner:GetWidth() < label:GetWidth() then label:SetWidth(inner:GetWidth()) end
	end
	
	local oSetWidth, oSetHeight = headerCell.SetWidth, headerCell.SetHeight
	
	function headerCell:SetWidth(newWidth)
		width = newWidth
		oSetWidth(self, width)
		--label:SetWidth(width)
		if inner:GetWidth() < label:GetWidth() then label:SetWidth(inner:GetWidth()) end
	end
	
	function headerCell:SetHeight(newHeight)
		height = newHeight
		oSetHeight(self, height)
		--label:SetHeight(height-2)
	end
		
	return headerCell
	
end
