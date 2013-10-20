local addonInfo, privateVars = ...

function EnKai.ui.nkGridCell(name, parent) 

	-- pre-define ui elements --
	
	local cell = UI.CreateFrame ('Frame', name, parent)
	local inner = UI.CreateFrame ('Frame', name .. 'inner', cell)
	local label = UI.CreateFrame ('Text', name .. 'label', inner)	
	local texture = nil
	
	local properties = {}

	function cell:SetValue(property, value)
		properties[property] = value
	end
	
	function cell:GetValue(property)
		return properties[property]
	end
	
	-- default values --
	
	local borderColor = { 1, 1, 1, 1 }
	local bodyColor = { 0, 0, 0, 1 }
	local labelColor = { 1, 1, 1, 1 }
	local fontSize = 13
	local height = fontSize + 7
	local width = 50 
	local isTexture = false
	local orientation = "CENTERLEFT"
	local align = 'left'
	local textureHeight, textureWidth = nil, nil
	
	-- fill ui elements with live --
	
	cell:SetWidth(width)
	cell:SetHeight(height)
	cell:SetBackgroundColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
	
	inner:SetPoint ("TOPLEFT", cell, "TOPLEFT", 1, 1)
	inner:SetPoint ("BOTTOMRIGHT", cell, "BOTTOMRIGHT", -1, -1)
	inner:SetBackgroundColor(bodyColor[1], bodyColor[2], bodyColor[3], bodyColor[4])
	
	label:SetPoint ("CENTER", inner, "CENTER")
	--label:SetWidth (width)
	label:SetFontColor (labelColor[1], labelColor[2], labelColor[3], labelColor[4])
	label:SetFontSize (fontSize)
	label:SetHeight (height - 2)
	if inner:GetWidth() < label:GetWidth() then label:SetWidth(inner:GetWidth()) end
	
	function cell:SetText(text)		
		label:SetText(text)
		cell:SetAlign(align)
--		
--		if label:GetWidth() > inner:GetWidth() then
--			label:SetWidth(inner:GetWidth())
--		end
	end
	
	function cell:SetLabelColor (r, g, b, a)
		labelColor = {r, g, b, a}
		label:SetFontColor (r, g, b, a)
	end
	
	function cell:SetBorderColor(r, g, b, a)
		borderColor = {r, g, b, a}
		cell:SetBackgroundColor(r, g, b, a)
	end
	
	function cell:SetBodyColor(r, g, b, a)
		bodyColor = {r, g, b, a}
		inner:SetBackgroundColor(r, g, b, a)
	end
	
	-- texture handling
	
	function cell:IsTexture()
		return isTexture
	end
	
	function cell:SetTexture(textureType, texturePath)
		if texture == nil then
			label:SetVisible(false)
			texture = UI.CreateFrame("Texture", name .. 'texture', inner)		
			texture:SetPoint ("CENTER", inner, "CENTER")
			
			if textureWidth ~= nil or textureHeight ~= nil then
				local width = textureWidth or textureHeight
				local height = textureHeight or textureWidth
				
				if width > inner:GetWidth() then 
					height = height * (width / inner:GetWidth())
					width = inner:GetWidth() 					
				end
				
				if height > inner:GetHeight() then 
					width = width * (height / inner:GetHeight())
					height = inner:GetHeight() 
				end
			else
				if inner:GetWidth() > inner:GetHeight() then
					texture:SetHeight(inner:GetHeight())
					texture:SetWidth(inner:GetHeight())
				else
					texture:SetHeight(inner:GetWidth())
					texture:SetWidth(inner:GetWidth())
				end
			end
			
		end
		
		if texturePath == nil then textureType, texturePath = 'EnKai', 'gfx/empty.png' end
		texture:SetTextureAsync(textureType, texturePath)
		isTexture = true
			
	end
	
	function cell:SetTextureWidth(newWidth)
		textureWidth = newWidth
		texture:SetWidth(textureWidth)
	end
	
	function cell:SetTextureHeight(newHeight)
		textureHeight = newHeight
		texture:SetHeight(textureHeight)
	end
	
	-- layout options
	
	function cell:GetOrientation()
		return orientation
	end
	
	function cell:SetAlign(newAlign)
		align = newAlign
		if align == 'center' then
			orientation = "CENTER"
		else
			orientation = "CENTERLEFT"
		end
		
		if cell:IsTexture() then
			texture:ClearAll()
			texture:SetPoint (orientation, inner, orientation)
			texture:SetHeight(inner:GetHeight())
			texture:SetWidth(inner:GetWidth())
		else
			label:ClearAll()
			label:SetPoint (orientation, inner, orientation)
			--label:SetWidth(inner:GetWidth())
			if inner:GetWidth() < label:GetWidth() then label:SetWidth(inner:GetWidth()) end
		end
	end
	
	function cell:SetFontSize(newFontSize)
		fontSize = newFontSize
		label:SetFontSize(fontSize)
		cell:SetHeight( fontSize + 7)
	end
	
	-- replacing original functions
	
	local oSetWidth, oSetHeight = cell.SetWidth, cell.SetHeight
	
	function cell:SetWidth(newWidth)
		width = newWidth
		oSetWidth(self, width)
		--label:SetWidth(width)
		if inner:GetWidth() < label:GetWidth() then label:SetWidth(inner:GetWidth()) end
	end
	
	function cell:SetHeight(newHeight)
		height = newHeight
		oSetHeight(self, height)
		label:SetHeight(height-2)
	end
	
	local oSetVisible = cell.SetVisible
	
	function cell:SetVisible(flag)
		label:SetVisible(flag)
		if cell:IsTexture() then texture:SetVisible(flag) end
	end
	
	-- Hier muss ich aufräumen und suchen, welche meiner Addons ein SetVisible auf Zellen machen. Dann SetHide auf SetVisible ändern
	
	function cell:SetHide(flag)
		oSetVisible(self, flag)
	end
	
		
	return cell
	
end
