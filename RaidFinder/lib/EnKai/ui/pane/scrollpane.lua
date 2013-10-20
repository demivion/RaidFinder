local addonInfo, privateVars = ...

function EnKai.ui.nkScrollpane(name, parent)

	local elementColor = {1, 1, 1, 1}
	local labelColor = {1, 1, 1, 1}

	local scrollPane = UI.CreateFrame('Mask', name, parent)
	
	local content = UI.CreateFrame('Frame', name .. '.content', scrollPane)
	content:SetPoint("TOPLEFT", scrollPane, "TOPLEFT")
	
	local scrollLane = EnKai.uiCreateFrame("nkScrollbox", name .. ".scrollbox", scrollPane)
	
	scrollLane:SetPoint("TOPRIGHT", scrollPane, "TOPRIGHT")
	scrollLane:SetColor(elementColor[1], elementColor[2], elementColor[3], elementColor[4])
	scrollLane:SetVisible(false)
	
	local eventName = name .. '.scrollbox'
	
	Command.Event.Attach(EnKai.events[eventName].ScrollboxChanged, function ()
		local newValue = math.floor(scrollLane:GetValue('value'))
		scrollPane:SetPosition (-(newValue))		
	end, name .. 'scrollbox.ScrollboxChanged')
	
	scrollPane:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function ()
		local thisValue = scrollLane:GetValue('value')
		if thisValue == nil then return end
		if thisValue-10 < scrollLane:GetValue("range")[1] then return end
		scrollLane:AdjustValue(thisValue-10) 
	end, name .. ".Mouse.Wheel.Forward")
	
	scrollPane:EventAttach(Event.UI.Input.Mouse.Wheel.Back, function ()
		local thisValue = scrollLane:GetValue('value')
		if thisValue == nil then return end
		if thisValue+10 > scrollLane:GetValue("range")[2] then return end
		scrollLane:AdjustValue(thisValue+10)		
	end, name .. ".Mouse.Wheel.Back")
	
	
	local range = nil	
	
	function scrollPane:SetPosition (ypos)
		local left, top, width, height = content:GetLeft(), content:GetTop(), content:GetHeight(), content:GetWidth()
		content:ClearAll()		
		content:SetPoint("TOPLEFT", scrollPane, "TOPLEFT", 0, ypos)
		content:SetHeight(height)
		content:SetWidth(width)
	end
	
	function scrollPane:SetContent(widget)
	
		local height, width = widget:GetHeight(), widget:GetWidth()
	
		widget:ClearAll()
		widget:SetParent(content)		
		widget:SetPoint("TOPLEFT", content, "TOPLEFT")
		widget:SetHeight(height)
		widget:SetWidth(width)
		
		content:SetHeight(widget:GetHeight())
		
		scrollLane:SetRange(0, widget:GetHeight() - scrollPane:GetHeight())
		
		if scrollPane:GetHeight() < widget:GetHeight() then
			scrollLane:AdjustValue(1)		
			scrollLane:SetVisible(true)
		else
			scrollPane:SetPosition(0)
			scrollLane:SetVisible(false)
		end

		--content:SetPoint("TOPLEFT", pane, "TOPLEFT")			
	end
	
	local oSetHeight, oSetWidth = scrollPane.SetHeight, scrollPane.SetWidth
		
	function scrollPane:SetHeight(newHeight)
		oSetHeight(self, newHeight)
		scrollLane:SetHeight(newHeight)
	end
	
	function scrollPane:SetWidth(newWidth)
		oSetWidth(self, newWidth)
		content:SetWidth(newWidth - scrollLane:GetWidth())
	end
	
	function scrollPane:SetColor(r, g, b, a)
		scrollLane:SetColor(r, g, b, a)
	end
	
	return scrollPane

end