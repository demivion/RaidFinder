local addonInfo, privateVars = ...

function EnKai.ui.nkScrollbox(name, parent) 

	local elementColor = {1, 1, 1, 1}

	local scrollBox = UI.CreateFrame ('Frame', name, parent)
	local scrollLane = UI.CreateFrame ('Frame', name .. 'lane', scrollBox)
	local scrollLaneInner = UI.CreateFrame ('Frame', name .. 'inner', scrollLane)
	local scrollPos = UI.CreateFrame ('Frame', name .. 'pos', scrollLaneInner)

	local properties = {}

	function scrollBox:SetValue(property, value)
		properties[property] = value
	end
	
	function scrollBox:GetValue(property)
		return properties[property]
	end
	
	scrollBox:SetValue("name", name)
	scrollBox:SetValue("parent", parent)
	
	local precision = 1
	
	scrollBox:SetWidth(14)
	scrollBox:SetHeight(100)
	
	scrollLane:SetPoint("TOPLEFT", scrollBox, "TOPLEFT", 2, 0)
	scrollLane:SetPoint("BOTTOMRIGHT", scrollBox, "BOTTOMRIGHT", -2, 0)
	scrollLane:SetBackgroundColor(1, 1, 1, 1)
	scrollLane:SetWidth(10)
	--scrollLane:SetHeight(100)
	
	scrollLaneInner:SetPoint("TOPLEFT", scrollLane, "TOPLEFT", 1, 1)
	scrollLaneInner:SetPoint("BOTTOMRIGHT", scrollLane, "BOTTOMRIGHT", -1, -1)
	scrollLaneInner:SetBackgroundColor(0, 0, 0, 1)
	
	scrollPos:SetPoint("TOPCENTER", scrollLane, "TOPCENTER")
	scrollPos:SetBackgroundColor(1, 1, 1, 1)
	scrollPos:SetWidth(14)
	scrollPos:SetHeight(14)
	
	local mouseDown = false
	
	scrollPos:EventAttach(Event.UI.Input.Mouse.Left.Down, function ()
		mouseDown = true
	end, name .. "pos_Left_Down")
	
	scrollPos:EventAttach(Event.UI.Input.Mouse.Left.Up, function ()
		mouseDown = false
	end, name .. "pos_Left_Up")
	
	scrollPos:EventAttach(Event.UI.Input.Mouse.Left.Upoutside , function ()
		mouseDown = false
	end, name .. "pos_Left_Upoutside")
	
	scrollPos:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function ()
		if mouseDown == true  then scrollBox:ProcessMove() end
	end, name .. "pos_Left_Up")
	
	function scrollBox:ProcessMove()
		
		if Inspect.Mouse().y < (scrollLane:GetTop() - 14) or Inspect.Mouse().y > (scrollLane:GetTop() + scrollLane:GetHeight() + 14) then mouseDown = false end
		if Inspect.Mouse().x < (scrollLane:GetLeft() - 40) or Inspect.Mouse().x > (scrollLane:GetLeft() + scrollLane:GetWidth() + 40) then mouseDown = false end
		
		local range = self:GetValue("range")
		
		if range == nil then mouseDown = false end
		
		if mouseDown == false then return end

		local y = Inspect.Mouse().y
		if y < scrollLane:GetTop() then y = scrollLane:GetTop() end
		if y > scrollLane:GetTop() + scrollLane:GetHeight() - 14 then y = scrollLane:GetTop() + scrollLane:GetHeight() - 14 end
		
		local curdivY = y - scrollLane:GetTop()
				
		local valuePerPixel = (range[2] - range[1] + precision) / (scrollLane:GetHeight()-14)
		local newValue = curdivY * valuePerPixel + range[1]
		
		if newValue < range[1] then newValue = range[1] end
		if newValue > range[2] then newValue = range[2] end

		self:SetValue("value", newValue)

		scrollPos:SetPoint ("CENTERTOP", scrollLane, "CENTERTOP", 0, curdivY)
		
		EnKai.eventHandlers[name]["ScrollboxChanged"](newValue)
	end
	
	function scrollBox:SetRange(from, to)
		self:SetValue("range", { from, to })
	end
	
	function scrollBox:AdjustValue(newValue)
		local range = self:GetValue("range")
		if range == nil then return end
		
		self:SetValue("value", newValue)
		
		if (newValue == range[2]) then
			scrollPos:SetPoint ("CENTERTOP", scrollLane, "CENTERTOP", 0, scrollLane:GetHeight()-14)
		else
			local pixelPerValue = (scrollLane:GetHeight()-14) / (range[2] - range[1] + precision)
			local newY = pixelPerValue * (newValue - precision)
			--local newY = math.floor((scrollLane:GetHeight() -14) / (range[2] - range[1] + precision) * (newValue-1))
			scrollPos:SetPoint ("CENTERTOP", scrollLane, "CENTERTOP", 0, newY)
		end
		
		EnKai.eventHandlers[name]["ScrollboxChanged"](newValue)
		
	end
	
	local oSetWidth, oSetHeight = scrollBox.SetWidth, scrollBox.SetHeight
		
	function scrollBox:SetHeight(newHeight)
		height = newHeight
		oSetHeight(self, height)
		if range ~= nil then		
			local newY = math.floor((scrollLane:GetHeight() -14) / (range[2] - range[1] + 1) * (newValue-1))
			scrollPos:SetPoint ("CENTERTOP", scrollLane, "CENTERTOP", 0, newY)
		end
	end
	
	function scrollBox:SetColor (r, g, b, a)
		elementColor = { r, g, b, a }
	
		scrollLane:SetBackgroundColor(r, g, b, a)
		scrollPos:SetBackgroundColor(r, g, b, a)
	end
			
	EnKai.eventHandlers[name] = {}
	EnKai.events[name] = {}
	EnKai.eventHandlers[name]["ScrollboxChanged"], EnKai.events[name]["ScrollboxChanged"] = Utility.Event.Create(addonInfo.identifier, name .. "ScrollboxChanged")
	
	return scrollBox
	
end