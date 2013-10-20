local addonInfo, privateVars = ...

function EnKai.ui.nkCheckbox(name, parent) 

	local labelColor = {1, 1, 1, 1}
	local elementColor = {1, 1, 1, 1}	

	local checkBox = UI.CreateFrame ('Frame', name, parent)
	local label = UI.CreateFrame ('Text', name, checkBox)
	local boxOuter = UI.CreateFrame ('Frame', name, checkBox)
	local boxInner = UI.CreateFrame ('Frame', name, boxOuter)
	local boxMark = UI.CreateFrame ('Frame', name, boxInner)
	
	local properties = {}

	function checkBox:SetValue(property, value)
		properties[property] = value
	end
	
	function checkBox:GetValue(property)
		return properties[property]
	end
	
	checkBox:SetValue("name", name)
	checkBox:SetValue("parent", parent)

	checkBox:SetValue("checked", false)
	
	local isActive = true
	local boxWidth = 13
	local boxHeight= 13
	
	checkBox:SetHeight(13)
	checkBox:SetWidth(113)
	
	boxOuter:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		if isActive == false then return end
		checkBox:toggle()
	end, name .. "boxOutter_LeftClick")	
	
	label:SetPoint("CENTERLEFT", checkBox, "CENTERLEFT")
	label:SetWidth(100)
	label:SetFontSize(13)
	label:SetFontColor(labelColor[1], labelColor[2], labelColor[3], labelColor[4])
	
	--label:SetText(checkBox:GetValue("label"))
	
	boxOuter:SetPoint("CENTERLEFT", label, "CENTERRIGHT")
	boxOuter:SetWidth(13)
	boxOuter:SetHeight(13)
		
	boxOuter:SetBackgroundColor(elementColor[1], elementColor[2], elementColor[3], elementColor[4])
	
	boxInner:SetPoint("TOPLEFT", boxOuter, "TOPLEFT", 1, 1)
	boxInner:SetPoint("BOTTOMRIGHT", boxOuter, "BOTTOMRIGHT", -1, -1)
	boxInner:SetBackgroundColor(0, 0, 0, 1)	
	
	boxMark:SetPoint("TOPLEFT", boxInner, "TOPLEFT", 2, 2)
	boxMark:SetPoint("BOTTOMRIGHT", boxInner, "BOTTOMRIGHT", -2, -2)
	boxMark:SetBackgroundColor(elementColor[1], elementColor[2], elementColor[3], elementColor[4])
	
	function checkBox:toggle ()
		local checked = self:GetValue('checked')
		if checked == true then checked = false else checked = true end
		self:SetChecked(checked)
	end

	function checkBox:SetChecked(flag, silent)
		self:SetValue('checked', flag)
		boxMark:SetVisible(flag)
		if silent ~= true then EnKai.eventHandlers[name]["CheckboxChanged"]( flag ) end
	end
	
	EnKai.eventHandlers[name] = {}
	EnKai.events[name] = {}
	EnKai.eventHandlers[name]["CheckboxChanged"], EnKai.events[name]["CheckboxChanged"] = Utility.Event.Create(addonInfo.identifier, name .. "CheckboxChanged")
		
	function checkBox:GetChecked () return self:GetValue('checked') end

	function checkBox:SetLabelInFront(flag)

		self:SetValue("labelInFront", flag)
			
		if flag == true then
			label:SetPoint("CENTERLEFT", checkBox, "CENTERLEFT")
			boxOuter:SetPoint("CENTERLEFT", label, "CENTERRIGHT", 5, 0)
		else
			boxOuter:SetPoint("CENTERLEFT", checkBox, "CENTERLEFT")
			label:SetPoint("CENTERLEFT", boxOuter, "CENTERRIGHT", 5, 0)
		end

	end

	function checkBox:SetLabelColor(r, g, b, a) 
		labelColor = { r, g, b, a}
		label:SetFontColor (r, g, b, a) 
	end
	
	function checkBox:SetColor(r, g, b, a) 
		elementColor = { r, g, b, a }
		boxOuter:SetBackgroundColor (r, g, b, a) 		
		boxMark:SetBackgroundColor (r, g, b, a) 
	end

	function checkBox:SetText(text) label:SetText(text) end	
	function checkBox:GetText() return label:GetText() end
	
	function checkBox:SetLabelWidth(width)
		checkBox:SetWidth(width + boxWidth + 5)
		label:SetWidth(width)
	end
	
	local oSetWidth, oSetHeight = checkBox.SetWidth, checkBox.SetHeight
	
	function checkBox:SetWidth(newWidth)		
		oSetWidth(self, newWidth)
		label:SetWidth(newWidth-boxWidth-5)
	end
	
	function checkBox:SetBoxWidth(newBoxWidth)
		boxOuter:SetWidth(newBoxWidth)
		boxWidth = newBoxWidth
		label:SetWidth(checkBox:GetWidth()-boxWidth-5)
	end
	
	function checkBox:SetBoxHeight(newBoxHeight)
		boxOuter:SetHeight(newBoxHeight)
		boxHeight= newBoxHeight
	end
	
	function checkBox:AutoSizeLabel()
		label:ClearWidth()
		checkBox:SetLabelWidth(label:GetWidth())
	end
	
	function checkBox:SetActive(flag)
		if flag == true then
			checkBox:SetAlpha(1)
		else
			checkBox:SetAlpha(.5)
		end
		isActive = flag
	end
	
	return checkBox
	
end