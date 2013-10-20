local addonInfo, privateVars = ...

function EnKai.ui.nkSlider(name, parent) 

	local elementColor = {1, 1, 1, 1}
	local labelColor = {1, 1, 1, 1}
	local labelText = nil

	local slider = UI.CreateFrame ('Frame', name, parent)
	
	local sliderLabel = UI.CreateFrame('Text', name .. '.label', slider)
	local sliderLane = UI.CreateFrame ('Frame', name .. '.lane', slider)
	local sliderLaneInner = UI.CreateFrame ('Frame', name .. '.inner', sliderLane)
	local sliderPos = UI.CreateFrame ('Frame', name .. '.pos', sliderLaneInner)

	local properties = {}

	function slider:SetValue(property, value)
		properties[property] = value
	end
	
	function slider:GetValue(property)
		return properties[property]
	end
	
	local isActive = true
	local precision = 1
	local origValue = nil
	
	slider:SetValue("name", name)
	slider:SetValue("parent", parent)
	
	slider:SetWidth(200)
	slider:SetHeight(14)
	
	sliderLabel:SetWidth(100)
	sliderLabel:SetPoint("CENTERLEFT", slider, "CENTERLEFT")
	sliderLabel:SetFontSize(13)
	sliderLabel:SetFontColor (labelColor[1], labelColor[2], labelColor[3], labelColor[4])
	
	--sliderLane:SetPoint("TOPLEFT", slider, "TOPLEFT", 0, 2)
	--sliderLane:SetPoint("BOTTOMRIGHT", slider, "BOTTOMRIGHT", 0, -2)
	sliderLane:SetPoint("CENTERLEFT", sliderLabel, "CENTERRIGHT")
	sliderLane:SetWidth(100)
	sliderLane:SetBackgroundColor(elementColor[1], elementColor[2], elementColor[3], elementColor[4])
	sliderLane:SetHeight(10)
	
	sliderLaneInner:SetPoint("TOPLEFT", sliderLane, "TOPLEFT", 1, 1)
	sliderLaneInner:SetPoint("BOTTOMRIGHT", sliderLane, "BOTTOMRIGHT", -1, -1)
	sliderLaneInner:SetBackgroundColor(0, 0, 0, 1)
	
	sliderPos:SetPoint("CENTER", sliderLane, "CENTER")
	sliderPos:SetBackgroundColor(elementColor[1], elementColor[2], elementColor[3], elementColor[4])
	sliderPos:SetWidth(14)
	sliderPos:SetHeight(14)
	
	local mouseDown = false
	
	sliderPos:EventAttach(Event.UI.Input.Mouse.Left.Down, function ()
		if isActive == false then return end
		mouseDown = true
	end, name .. "pos_Left_Down")
	
	sliderPos:EventAttach(Event.UI.Input.Mouse.Left.Up, function ()
		mouseDown = false
	end, name .. "pos_Left_Up")
	
	sliderPos:EventAttach(Event.UI.Input.Mouse.Left.Upoutside , function ()
		mouseDown = false
	end, name .. "pos_Left_Upoutside")
	
	sliderPos:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function ()
		if mouseDown then slider:ProcessMove() end
	end, name .. "pos_Left_Up")
	
	function slider:ProcessMove()
		
		if Inspect.Mouse().y < (sliderLane:GetTop() - 14) or Inspect.Mouse().y > (sliderLane:GetTop() + sliderLane:GetHeight() + 14) then mouseDown = false end
		if Inspect.Mouse().x < (sliderLane:GetLeft() - 40) or Inspect.Mouse().x > (sliderLane:GetLeft() + sliderLane:GetWidth() + 40) then mouseDown = false end
		
		local range = self:GetValue("range")
		
		if range == nil then mouseDown = false end
		
		if mouseDown == false then return end

		local x = Inspect.Mouse().x
		if x < sliderLane:GetLeft() then x = sliderLane:GetLeft() end
		if x > sliderLane:GetLeft() + sliderLane:GetWidth()  then x = sliderLane:GetLeft() + sliderLane:GetWidth() end
		
		local curdivX = x - (sliderLane:GetLeft() + (sliderLane:GetWidth() / 2))
		
		local valuePerPixel = (range[2] - range[1] + precision) / sliderLane:GetWidth()		
		
		local newValue = curdivX * valuePerPixel + ((range[2] - range[1]) / 2)
		
		if newValue < range[1] then newValue = range[1] end
		if newValue > range[2] then newValue = range[2] end
		
		self:SetValue("value", newValue)
		
		if labelText ~= nil then slider:SetText(labelText) end

		sliderPos:SetPoint ("CENTER", sliderLane, "CENTER", curdivX, 0)
		
		EnKai.eventHandlers[name]["SliderChanged"](newValue)
	end
	
	function slider:SetRange(from, to)
		self:SetValue("range", { from, to })
	end
	
	function slider:SetMidValue (newMidValue)
		midValue = newMidValue		
	end
	
	function slider:AdjustValue(newValue)
		local range = self:GetValue("range")
		if range == nil then return end
		
		if midValue == nil then midValue = newValue end
				
		self:SetValue("value", newValue)
		
		local pixelPerValue = sliderLane:GetWidth() / (range[2] - range[1] + precision)
		local newX = (newValue - (range[2] - range[1]) / 2) * pixelPerValue
		--local newX = math.floor((sliderLane:GetWidth() / (range[2] - range[1] + precision) * newValue)
		sliderPos:SetPoint ("CENTER", sliderLane, "CENTER", newX, 0)
		
		if labelText ~= nil then slider:SetText(labelText) end
		
		EnKai.eventHandlers[name]["SliderChanged"](newValue)
		
	end
	
	function slider:SetColor (r, g, b, a)
		elementColor = { r, g, b, a }
	
		sliderLane:SetBackgroundColor(r, g, b, a)
		sliderPos:SetBackgroundColor(r, g, b, a)
	end
	
	function slider:SetLabelColor(r, g, b, a) 
		labelColor = {r, g, b, a}
		sliderLabel:SetFontColor (r, g, b, a) 
	end
	
	function slider:SetActive(flag)
		if flag == true then
			slider:SetAlpha(1)
		else
			slider:SetAlpha(.5)
		end
		isActive = flag
	end
	
	function slider:SetText(text) 
		labelText = text
		if self:GetValue("value") ~= nil then
			sliderLabel:SetText(string.format(text, self:GetValue("value"))) 
		end
	end	
	
	function slider:SetLabelWidth(newLabelWidth)		
		sliderLabel:SetWidth(newLabelWidth)
		sliderLane:SetWidth(slider:GetWidth() - newLabelWidth)
	end
	
	local oSetWidth, oSetHeight = slider.SetWidth, slider.SetHeight
	
	function slider:SetWidth(newWidth)		
		oSetWidth(self, newWidth)
		sliderLane:SetWidth(newWidth - sliderLabel:GetWidth())		
	end
	
	function slider:SetPrecision(newPrecision)
		precision = newPrecision
	end
			
	EnKai.eventHandlers[name] = {}
	EnKai.events[name] = {}
	EnKai.eventHandlers[name]["SliderChanged"], EnKai.events[name]["SliderChanged"] = Utility.Event.Create(addonInfo.identifier, name .. "SliderChanged")
	
	return slider
	
end