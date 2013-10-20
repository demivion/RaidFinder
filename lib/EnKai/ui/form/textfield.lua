local addonInfo, privateVars = ...

function EnKai.ui.nkTextfield(name, parent) 

	local borderColor = {1, 1, 1, 1}
	local focusColor = {1, 1, 1, 1}

	local textField = UI.CreateFrame ('Frame', name, parent)
	local textFieldInner = UI.CreateFrame ('Frame', name, textField)
	local textFieldEdit = UI.CreateFrame ('RiftTextfield', name, textFieldInner)

	local properties = {}

	function textField:SetValue(property, value)
		properties[property] = value
	end
	
	function textField:GetValue(property)
		return properties[property]
	end
	
	textField:SetValue("name", name)
	textField:SetValue("parent", parent)
	
	textField:SetValue("valueType", "text")
	textField:SetValue("restoreValue", false)
	textField:SetValue("backupValue", false)
	
	textField:SetWidth(100)
	textField:SetHeight(20)
	textField:SetBackgroundColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])
		
	textFieldInner:SetPoint("TOPLEFT", textField, "TOPLEFT", 1, 1)
	textFieldInner:SetPoint("BOTTOMRIGHT", textField, "BOTTOMRIGHT", -1, -1)
	textFieldInner:SetBackgroundColor(0, 0, 0, 1)
	
	textFieldEdit:SetPoint("TOPLEFT", textFieldInner, "TOPLEFT", 1, 1)
	textFieldEdit:SetPoint("BOTTOMRIGHT", textFieldInner, "BOTTOMRIGHT", -1, -1)
	
	function textField:SetText(text)
		textFieldEdit:SetText(tostring(text))
	end
	
	function textField:GetText()
		return textFieldEdit:GetText()
	end
	
	function textField:GetConvertedText()
		local tempText = textFieldEdit:GetText()
		
		if textField:GetValue('valueType') == 'number' then
			return tonumber(tempText)
		else
			return tempText
		end
	end
	
	function textField:SetValueType(valueType)
		if valueType == 'text' or valueType == 'number' then
			self:SetValue('valueType', valueType)
		end
	end
	
	function textField:SetFocusColor (r, g, b, a)
		focusColor = {r, g, b, a}
	end
	
	function textField:Leave()
		textFieldEdit:SetKeyFocus(false)
	end
	
	textFieldEdit:EventAttach(Event.UI.Input.Key.Down, function(_, _, key) 
		local code = string.byte(key)
		if tonumber(code) == 82 then
			textField:SetValue('restoreValue', false)
			textFieldEdit:SetKeyFocus(false)
			textField:SetBackgroundColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])		
			EnKai.eventHandlers[name]["TextfieldChanged"]()
		end
	end, "nkTextField_" .. name .. "_Key_Down")
	
	textFieldEdit:EventAttach(Event.UI.Input.Mouse.Left.Click, function() 
		
		textField:SetValue("backupValue", textFieldEdit:GetText())
		textField:SetValue("restoreValue", true)
		
		textField:SetBackgroundColor(focusColor[1], focusColor[2], focusColor[3], focusColor[4])
				
	end, "nkTextField_" .. name .. "_Left_Click")
	
	textFieldEdit:EventAttach(Event.UI.Input.Key.Focus.Loss, function() 
		
		if textField:GetValue("restoreValue") ~= false and textField:GetValue("backupValue") ~= nil then
			textFieldEdit:SetText(textField:GetValue("backupValue"))
		end
		
		textField:SetValue("backupValue", nil)
		textField:SetValue("restoreValue", false)
		
		textField:SetBackgroundColor(borderColor[1], borderColor[2], borderColor[3], borderColor[4])		
		
	end, "nkTextField_" .. name .. "_Key_FocusLoss")
	
	function textField:SetColor(r, g, b, a)
		
		borderColor = {r, g, b, a}
		textField:SetBackgroundColor(r, g, b, a)
		
	end
	
	function textField:SetSelection(startPos, endPos)
		textFieldEdit:SetSelection(startPos, endPos)
	end

	EnKai.eventHandlers[name] = {}
	EnKai.events[name] = {}
	EnKai.eventHandlers[name]["TextfieldChanged"], EnKai.events[name]["TextfieldChanged"] = Utility.Event.Create(addonInfo.identifier, name .. "TextfieldChanged")
	
	return textField
		
end