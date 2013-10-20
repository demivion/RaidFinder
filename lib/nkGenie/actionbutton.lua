function nkGenie.ExtActionButton:new (name, parent, settings)
	
	local this = settings or {}
	this.name = name
	this.parent = parent
	
	local button = UI.CreateFrame ('nkExtTexture', 'nkButton' .. name, parent, {alpha = settings.alpha, visible = settings.visible, type = 'nkGenie', path = 'ressource/button.png', width = settings.buttonSize, height = settings.buttonSize, anchors = settings.anchors })
	
	if settings.secure == true then button:SetSecureMode('restricted') end
		
	button.icon = UI.CreateFrame ('nkExtTexture', 'nkButton' .. name .. 'icon', button:getElement(), {type = settings.type, path = settings.texture, width = settings.iconSize, height = settings.iconSize, anchors = {{ from = "CENTER", object = button:getElement(), to = "CENTER" }} })
	
	if settings.secure == true then button.icon:SetSecureMode('restricted') end
	
	this.element = button
	
	setmetatable(this, self)
	self.__index = self
	return this

end
	
function nkGenie.ExtActionButton:SetEvent(event, func)

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

function nkGenie.ExtActionButton:SetMacro(event, macro)

	local element = self:getElement(false)

	if event == "LeftClick" then
		element.Event.LeftDown = macro
	end

end

function nkGenie.ExtActionButton:getElement() return self.element:getElement() end	
function nkGenie.ExtActionButton:update() end
function nkGenie.ExtActionButton:SetVisible(flag) self.element:SetVisible(flag) end
function nkGenie.ExtActionButton:SetAlpha(flag) self.element:SetAlpha(flag) end