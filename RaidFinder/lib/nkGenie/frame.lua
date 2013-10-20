function nkGenie.ExtFrame:new(name, parent, settings)

	local this = {}
	this.name = name
	this.parent = parent
	
	local element = UI.CreateFrame("Frame", name, parent)
	
	if settings ~= nil and settings.color ~= nil and settings.color.border ~= nil then
		element.inner = UI.CreateFrame("nkExtFrame", name .. 'inner', element, { anchors = {{ from = "TOPLEFT", object = element, to = "TOPLEFT", x = 1, y = 1}, { from = "BOTTOMRIGHT", object = element, to = "BOTTOMRIGHT", x = -1, y = -1}}} )
	end
	
	this.element = element
	setmetatable(this, self)
	self.__index = self
	return this
	
end

function nkGenie.ExtFrame:update (settings)

	if settings == nil then return end
	if settings.template ~= nil then
		for k, v in pairs (settings.template) do if settings[k] == nil then settings[k] = v end end
		settings.template = nil
	end	
	
	if settings.width ~= nil then self.element:SetWidth(settings.width) end
	if settings.height ~= nil then self.element:SetHeight(settings.height) end
	
	if settings.anchors ~= nil then
		for k, anchor in pairs(settings.anchors) do
			if anchor.x ~= nil and anchor.y ~= nil then
				self.element:SetPoint (anchor.from, anchor.object, anchor.to, anchor.x, anchor.y)
			else
				self.element:SetPoint (anchor.from, anchor.object, anchor.to)
			end
		end
	end
	
	if settings.callBack ~= nil then
		function self.element.Event:LeftClick()
			settings.callBack(self)
		end
	end
	
	if settings.color ~= nil then	
		if settings.color.body ~= nil then
			if settings.color.border ~= nil then
				local alpha = settings.color.alphaborder or 1
				local color = nkGenie.Tools:HexToRGB(settings.color.border)
				self.element:SetBackgroundColor(color[1], color[2], color[3], alpha)
				self.element.inner:update({ color = { body = settings.color.body, alphabody = settings.color.alphabody } })
			else
				local color = nkGenie.Tools:HexToRGB(settings.color.body)
				local alpha = settings.color.alphabody or 1
				self.element:SetBackgroundColor(color[1], color[2], color[3], alpha)
			end
		elseif settings.color.alpha ~= nil then
			self.element:SetAlpha (settings.color.alpha)
		end
	end		
		
	if settings.layer ~= nil then self.element:SetLayer(settings.layer) end
	if settings.strata ~= nil then self.element:SetStrata(settings.strata) end
	if settings.visible ~= nil then self.element:SetVisible(settings.visible) end
	
	for k, v in pairs (settings) do self[k] = v end
	
end

function nkGenie.ExtFrame:getElement (innerFlag)

	if (innerFlag == nil or innerFlag == true) and self.element.inner ~= nil then
		return self.element.inner:getElement(false)
	else
		return self.element
	end
		
end

function nkGenie.ExtFrame:SetEvent(event, func)

	local element = self:getElement(false)

	if event == "LeftClick" then
		function element.Event:LeftClick() func(element)  end
	elseif event == "LeftDown" then
		function element.Event:LeftDown() func(element)  end
	elseif event == "MouseMove" then
		function element.Event:MouseMove() func(element)  end
	elseif event == "LeftUp" then
		function element.Event:LeftUp() func(element)  end
	elseif event == "MouseIn" then
		function element.Event:MouseIn() func(element)  end
	elseif event == "MouseOut" then
		function element.Event:MouseOut() func(element)  end
	elseif event == "WheelForward" then
		function element.Event:WheelForward() func(element)  end
	elseif event == "WheelBack" then
		function element.Event:WheelBack() func(element)  end	
	elseif event == "RightClick" then
		function element.Event:RightClick() func(element)  end
	elseif event == "RightDown" then
		function element.Event:RightDown() func(element)  end
	elseif event == "RightUp" then
		function element.Event:RightUp() func(element)  end
	elseif event == "MiddleClick" then
		function element.Event:MiddleClick() func(element)  end
	end
	
end

function nkGenie.ExtFrame:ClearEvent(event)

	local element = self:getElement(false)

	if event == "LeftClick" then
		function element.Event:LeftClick() end
	elseif event == "LeftDown" then
		function element.Event:LeftDown()  end
	elseif event == "MouseMove" then
		function element.Event:MouseMove()  end
	elseif event == "LeftUp" then
		function element.Event:LeftUp() end
	elseif event == "MouseIn" then
		function element.Event:MouseIn() end
	elseif event == "MouseOut" then
		function element.Event:MouseOut() end
	elseif event == "WheelForward" then
		function element.Event:WheelForward() end
	elseif event == "WheelBack" then
		function element.Event:WheelBack() end	
	elseif event == "RightClick" then
		function element.Event:RightClick() end
	elseif event == "RightDown" then
		function element.Event:RightDown() end
	elseif event == "RightUp" then
		function element.Event:RightUp() end
	elseif event == "MiddleClick" then
		function element.Event:MiddleClick() end
	end
	
end

function nkGenie.ExtFrame:SetMacro(event, macro)

	local element = self:getElement(false)

	if event == "LeftClick" then
		element.Event.LeftDown = macro
	end

end

function nkGenie.ExtFrame:GetVisible() return self:getElement(false):GetVisible() end
function nkGenie.ExtFrame:SetVisible(flag) self:getElement(false):SetVisible(flag) end
function nkGenie.ExtFrame:SetParent(parent) self:getElement(false):SetParent(parent) end
function nkGenie.ExtFrame:GetWidth() return self:getElement(false):GetWidth() end
function nkGenie.ExtFrame:GetHeight() return self:getElement(false):GetHeight() end
function nkGenie.ExtFrame:SetSecureMode(mode) self:getElement(false):SetSecureMode(mode) end
function nkGenie.ExtFrame:SetStrata(strata) self:getElement(false):SetStrata(strata) end
function nkGenie.ExtFrame:SetLayer(layer) self:getElement(false):SetLayer(layer) end