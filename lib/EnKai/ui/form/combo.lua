local addonInfo, privateVars = ...

function EnKai.ui.nkCombobox(name, parent) 

	local elementColor = {1, 1, 1, 1}
	local labelColor = {1, 1, 1, 1}
	
	local isActive = true
	--local displayWidth = 100

	local combo = UI.CreateFrame ('Frame', name, parent)
	local comboLabel = UI.CreateFrame ('Text', name .. '.comboLabel', combo)
	
	local display = UI.CreateFrame ('Frame', name .. '.display', combo)
	local displayInner = UI.CreateFrame ('Frame', name .. '.displayInner', display)
	local icon = UI.CreateFrame ('Texture', name .. '.icon', displayInner)
	local label = UI.CreateFrame ('Text', name .. '.label', displayInner)
	
	local arrowBox = UI.CreateFrame ('Frame', name .. '.arrowBox', displayInner)
	local arrowBoxInner = UI.CreateFrame ('Frame', name .. '.arrowBoxInner', arrowBox)
	local arrowText = UI.CreateFrame ('Text', name .. '.arrowText', arrowBoxInner)
	local selFrame = UI.CreateFrame ('Frame', name .. '.selFrame', combo)
	local selFrameInner = UI.CreateFrame ('Frame', name .. '.selFrameInner', selFrame)
	
	local selFrameSlider = EnKai.uiCreateFrame('nkScrollbox', name .. '.selFrameSlider', selFrame)
	
	local selItems = {}	
	
	for idx = 1, 5, 1 do
		local selItemFrame = UI.CreateFrame ('Frame', name .. 'selItemFrame' .. idx, selFrameInner)
		local selItemLabel = UI.CreateFrame ('Text', name .. 'selItemLabel' .. idx, selItemFrame)
		local selItemIcon = UI.CreateFrame ('Texture', name .. 'selItemIcon' .. idx, selItemFrame)
		
		selItemFrame:EventAttach(Event.UI.Input.Mouse.Cursor.In, function ()
			combo:RowHighlight(idx, true)
		end, name .. "selItemFrame" .. idx .. "_Cursor_In")	
		
		selItemFrame:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function ()
			combo:RowHighlight(idx, false)
		end, name .. "selItemFrame" .. idx .. "_Cursor_out")	
		
		selItemFrame:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
			local selValue = combo:GetValue('selection')[idx + combo:GetValue('counter') - 1]			
			combo:SetSelectedValue ( selValue.value )
			EnKai.eventHandlers[name]["ComboChanged"](selValue)
		end, name .. "selItemFrame" .. idx .. "_Left_Click")
		
		table.insert(selItems, { frame = selItemFrame, label = selItemLabel, icon = selItemIcon })		
	end
	
	local properties = {}

	function combo:SetValue(property, value)
		properties[property] = value
	end
	
	function combo:GetValue(property)
		return properties[property]
	end

	combo:SetValue("name", name)
	combo:SetValue("parent", parent)
	combo:SetValue("open", false)
	combo:SetValue("icons", false)
	combo:SetValue("counter", 1)
	
	combo:SetWidth(200)
	combo:SetHeight(20)
	
	comboLabel:SetPoint("CENTERLEFT", combo, "CENTERLEFT")
	comboLabel:SetWidth(100)
	comboLabel:SetFontColor(labelColor[1], labelColor[2], labelColor[3], labelColor[4])
		
	display:SetPoint ("CENTERLEFT", comboLabel, "CENTERRIGHT")
	display:SetBackgroundColor(elementColor[1], elementColor[2], elementColor[3], elementColor[4])
	display:SetHeight(20)
	display:SetWidth(100)
	
	displayInner:SetBackgroundColor(0, 0, 0, 1)
	displayInner:SetPoint ("TOPLEFT", display, "TOPLEFT", 1, 1)
	displayInner:SetPoint ("BOTTOMRIGHT", display, "BOTTOMRIGHT", -1, -1)
	
	icon:SetVisible(false)
	icon:SetWidth(18)
	icon:SetHeight(18)	
	
	label:SetPoint("CENTERLEFT", displayInner, "CENTERLEFT", 2, 0)
	label:SetFontColor (1, 1, 1, 1)
	label:SetWordwrap(false)
	label:SetHeight(18)
	label:SetFontSize(13)
	label:SetWidth(displayInner:GetHeight()-20)
		
	arrowBox:SetBackgroundColor(elementColor[1], elementColor[2], elementColor[3], elementColor[4])
	arrowBox:SetPoint ("TOPRIGHT", display, "TOPRIGHT")
	arrowBox:SetWidth (20)
	arrowBox:SetHeight (20)
	
	arrowBoxInner:SetBackgroundColor(0, 0, 0, 1)
	arrowBoxInner:SetPoint ("TOPLEFT", arrowBox, "TOPLEFT", 1, 1)
	arrowBoxInner:SetPoint ("BOTTOMRIGHT", arrowBox, "BOTTOMRIGHT", -1, -1)
	
	arrowText:SetFontColor (elementColor[1], elementColor[2], elementColor[3], elementColor[4])
	arrowText:SetPoint("CENTER", arrowBox, "CENTER")
	arrowText:SetText("v")
	
	selFrame:SetBackgroundColor(elementColor[1], elementColor[2], elementColor[3], elementColor[4])
	selFrame:SetPoint("TOPLEFT", display, "BOTTOMLEFT", 0, -1)
	selFrame:SetHeight (102)
	selFrame:SetWidth (100)
	selFrame:SetVisible (false)
	
	selFrameInner:SetBackgroundColor(0, 0, 0, 1)
	selFrameInner:SetPoint ("TOPLEFT", selFrame, "TOPLEFT", 1, 1)
	selFrameInner:SetPoint ("BOTTOMRIGHT", selFrame, "BOTTOMRIGHT", -1, -1)
	selFrameInner:SetLayer(1)
	
	selFrameSlider:SetPoint("TOPRIGHT", selFrame, "TOPRIGHT")
	selFrameSlider:SetLayer(2)
	selFrameSlider:SetColor(elementColor[1], elementColor[2], elementColor[3], elementColor[4])
	selFrameSlider:SetHeight(101)
	
	arrowBox:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		if isActive == false then return end
		combo:ToggleSelFrame()
	end, name .. "arrowBox_LeftClick")	
	
	selFrameInner:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function ()
		if #combo:GetValue('selection') < 5 then return end
		combo:SetValue('counter', combo:GetValue('counter') - 1)
		if combo:GetValue('counter') <= 0 then combo:SetValue('counter', 1) end		
		selFrameSlider:AdjustValue (combo:GetValue('counter'))
	end, name .. "selFrameInner_Wheel_Forward")
	
	
	selFrameInner:EventAttach(Event.UI.Input.Mouse.Wheel.Back, function ()
		if #combo:GetValue('selection') < 5 then return end
		combo:SetValue('counter', combo:GetValue('counter') + 1)
		if combo:GetValue('counter') > #combo:GetValue('selection') - 4 then combo:SetValue('counter', #combo:GetValue('selection') - 4) end		
		selFrameSlider:AdjustValue (combo:GetValue('counter'))
	end, name .. "selFrameInner_Wheel_Back")
	
	local eventName = name .. '.selFrameSlider'
	
	Command.Event.Attach(EnKai.events[eventName].ScrollboxChanged, function ()		
		combo:SetValue('counter', math.floor(selFrameSlider:GetValue('value')))
		combo:ShowValues()
	end, name .. 'selFrameSlider.ScrollboxChanged')
	
	local object = selFrameInner
	local to = "TOPLEFT"
	
	for idx = 1, 5, 1 do
		selItems[idx].frame:SetPoint ("TOPLEFT", object, to)

		object = selItems[idx].frame
		to = "BOTTOMLEFT"
		
		selItems[idx].frame:SetWidth(selFrameInner:GetWidth())
		selItems[idx].frame:SetHeight(20)
		
		selItems[idx].icon:SetVisible(false)
		selItems[idx].icon:SetWidth(18)
		selItems[idx].icon:SetHeight(18)
		
		selItems[idx].label:SetFontSize(13)
		selItems[idx].label:SetFontColor(labelColor[1], labelColor[2], labelColor[3], labelColor[4])
		selItems[idx].label:SetWordwrap(false)
		selItems[idx].label:SetHeight(14)
	end
	
	
	function combo:ToggleSelFrame(newFlag)
		
		local flag = combo:GetValue("open")
		if newFlag ~= nil then 
			flag = newFlag 
		elseif flag == false then flag = true else flag = false end

		combo:SetValue("open", flag)
		if (flag == true) then combo:ShowValues() end
		selFrame:SetVisible(flag)
	end
	
	function combo:SetSelection(selection)
		
		if selection == nil or #selection == 0 then
			EnKai.tools.error.display (addonInfo.identifier, string.format("EnKai.ui.nkCombobox - invalid number of parameters\nexpecting: selection (table)\nreceived: %s", EnKai.tools.table.serialize (selection))) 
			return 
		end
		
		table.sort (selection, function (a, b) return (a.label < b.label) end )
		
		-- rebuild selection list to show correct items
		
		local hasIcons = combo:GetValue('icons')		
		if selection[1].iconPath ~= nil then hasIcons = true end
		combo:SetValue('icons', hasIcons)
		
		if hasIcons == true then
			icon:SetPoint ("CENTERLEFT", displayInner, "CENTERLEFT")
			icon:SetVisible(true)
			label:SetPoint ("CENTERLEFT", icon, "CENTERRIGHT", 2, 0)			
			label:SetWidth(displayInner:GetWidth() - 40) -- 20 due to arrow box and 20 due to icon (18 + 2 distance)
		else
			label:SetPoint ("CENTERLEFT", displayInner, "CENTERLEFT")
			label:SetWidth(displayInner:GetWidth() - 20)
			icon:SetVisible(false)			
		end

		local visible = true
		
		for idx = 1, 5, 1 do
			if idx > #selection then visible = false end -- make sure to only show lines needed but still build them in case of more items later
			
			selItems[idx].frame:SetVisible(visible)
			
			if hasIcons == true then
				selItems[idx].icon:SetPoint("CENTERLEFT", selItems[idx].frame, "CENTERLEFT")
				selItems[idx].label:SetPoint("CENTERLEFT", selItems[idx].icon, "CENTERRIGHT", 2, 0)
				selItems[idx].label:SetWidth(selItems[idx].frame:GetWidth() - 20) -- 20 due to icon (18 + 2 distance)
			else
				selItems[idx].label:SetPoint("CENTERLEFT", selItems[idx].frame, "CENTERLEFT")
				selItems[idx].icon:SetPoint("CENTERLEFT", selItems[idx].label, "CENTERRIGHT")
				selItems[idx].label:SetWidth(selItems[idx].frame:GetWidth() )
			end
		end
		
		combo:SetValue('selection', selection)		
		combo:SetSelectedValue (combo:GetValue('selectedValue'))
		
	end
	
	function combo:ShowValues()
	
		local selection = combo:GetValue('selection')
		
		if selection == nil or selection == 0 then return end

		if #selection > 5 then
			local maxRange = #selection - 4
			selFrameSlider:SetRange(1, maxRange)
			selFrameSlider:SetVisible(true)
		else
			selFrameSlider:SetVisible(false)
		end

		local counter = combo:GetValue('counter')
		
		for idx = counter, counter + 4, 1 do
			if idx > #selection then 
				selItems[idx-counter+1].icon:SetVisible(false)
				selItems[idx-counter+1].label:SetVisible(false)
			else
				if combo:GetValue('icons') == true then 
					selItems[idx-counter+1].icon:SetVisible(true)
					if selection[idx].iconPath == '' or selection[idx].iconType == '' then
						selItems[idx-counter+1].icon:SetVisible(false)
					else
						selItems[idx-counter+1].icon:SetVisible(true)
						selItems[idx-counter+1].icon:SetTextureAsync(selection[idx].iconType, selection[idx].iconPath)
					end
				end
				
				selItems[idx-counter+1].label:SetVisible(true)
				selItems[idx-counter+1].label:SetText(selection[idx].label)
			end
		end
		
	end
	
	function combo:RowHighlight (row, active)
	
		local element = selItems[row]	

		if active == true then
			selItems[row].frame:SetBackgroundColor(labelColor[1], labelColor[2], labelColor[3], labelColor[4])
			selItems[row].label:SetFontColor (0, 0, 0, 1)
		else
			selItems[row].frame:SetBackgroundColor(0, 0, 0 ,1)
			selItems[row].label:SetFontColor (labelColor[1], labelColor[2], labelColor[3], labelColor[4])
		end
	
	end
	
	function combo:SetSelectedValue (selectedValue)
	
		if (selectedValue == nil) then return end

		combo:SetValue("selectedValue", selectedValue)
		local selection = combo:GetValue("selection")
		
		if selection == nil then return end
	
		for k, v in pairs (selection) do
			if selectedValue == v.value then			
				label:SetText(v.label)
				
				if combo:GetValue("icons") == true then
					if v.iconPath == '' or v.iconType == '' then
						icon:SetVisible(false)
					else
						icon:SetVisible(true)
						icon:SetTextureAsync(v.iconType, v.iconPath)
					end
				end
			end
		end
	
		combo:ToggleSelFrame(false)
	
	end
	
	function combo:SetSelectedLabel (selectedLabel)
	
		if (selectedLabel == nil) then return end
		local selection = combo:GetValue("selection")
		if selection == nil then return end
	
		for k, v in pairs (selection) do
			if selectedLabel == v.label then			
				label:SetText(v.label)
				combo:SetValue("selectedValue", v.value)
				
				if combo:GetValue("icons") == true then
					if v.iconPath == '' or v.iconType == '' then
						icon:SetVisible(false)
					else
						icon:SetVisible(true)
						icon:SetTextureAsync(v.iconType, v.iconPath)
					end
				end
			end
		end
	
		combo:ToggleSelFrame(false)
	
	end
	
	function combo:GetSelectedValue ()
		return combo:GetValue("selectedValue")
	end
	
	function combo:GetSelectedLabel ()
		local selectedValue = combo:GetValue("selectedValue")
		local selection = combo:GetValue("selection")
				
		if selection == nil or selectedValue == nil then return nil end
		
		for k, v in pairs (selection) do
			if selectedValue == v.value then			
				return v.label
			end
		end
	end
	
	function combo:SetLabelColor(r, g, b, a) 
		labelColor = {r, g, b, a}
		label:SetFontColor (r, g, b, a) 
		comboLabel:SetFontColor (r, g, b, a) 
		
		for idx = 1, 5, 1 do
			selItems[idx].label:SetFontColor(r, g, b, a)
		end
	end
	
	function combo:SetColor(r, g, b, a) 
		elementColor = {r, g, b, a}
	
		display:SetBackgroundColor(r, g, b, a)
		arrowBox:SetBackgroundColor(r, g, b, a)
		selFrame:SetBackgroundColor(r, g, b, a)		
		arrowText:SetFontColor(r, g, b, a)
		
		selFrameSlider:SetColor(r, g, b, a)
	end
	
	function combo:SetActive(flag)
		if flag == true then
			combo:SetAlpha(1)
		else
			combo:SetAlpha(.5)
		end
		isActive = flag
	end
	
	function combo:SetText(text) comboLabel:SetText(text) end	
	
	function combo:SetLabelWidth(newLabelWidth)
		comboLabel:SetWidth(newLabelWidth)
		display:SetWidth(combo:GetWidth() - newLabelWidth)
		selFrame:SetWidth(combo:GetWidth() - newLabelWidth)
		
		for idx = 1, 5, 1 do
			selItems[idx].frame:SetWidth(selFrameInner:GetWidth())
		end
		
		if icon:GetVisible() == true then
			label:SetWidth(displayInner:GetWidth() - 40) 
		else
			label:SetWidth(displayInner:GetWidth() - 20) 
		end
	end
	
	local oSetWidth, oSetHeight = combo.SetWidth, combo.SetHeight
	
	function combo:SetWidth(newWidth)		
		oSetWidth(self, newWidth)
		display:SetWidth(newWidth - comboLabel:GetWidth())
		selFrame:SetWidth(newWidth - comboLabel:GetWidth())
		
		for idx = 1, 5, 1 do
			selItems[idx].frame:SetWidth(selFrameInner:GetWidth())
		end
		
		if icon:GetVisible() == true then
			label:SetWidth(displayInner:GetWidth() - 40) 
		else
			label:SetWidth(displayInner:GetWidth() - 20) 
		end
	end
	
	function combo:SetHeight(newHeight)		
		--oSetHeight(self, newHeight)
		display:SetHeight(newHeight)
		icon:SetHeight(newHeight-2)
		label:SetHeight(newHeight-2)
		local newFontSize = math.floor( (1 / 20 * newHeight) * 13 )
		label:SetFontSize(newFontSize)
		arrowBox:SetHeight(newHeight)
	end
	
	function combo:SetComboVisible(flag)
		display:SetVisible(flag)
	end
	
	EnKai.eventHandlers[name] = {}
	EnKai.events[name] = {}
	EnKai.eventHandlers[name]["ComboChanged"], EnKai.events[name]["ComboChanged"] = Utility.Event.Create(addonInfo.identifier, name .. "ComboChanged")
	
	return combo
	
end