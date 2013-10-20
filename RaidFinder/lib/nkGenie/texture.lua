function nkGenie.ExtTexture:new (name, parent, settings)

	if settings == nil then return nil end
	local this = settings
	this.name = name
	this.parent = parent
	
	local texture = UI.CreateFrame("Texture", name, parent)
	
	if this.width ~= nil then texture:SetWidth(this.width)  end
	if this.height ~= nil then texture:SetHeight(this.height) end
	
	if this.anchors ~= nil then
		for k, anchor in pairs(this.anchors) do
			if anchor.x ~= nil and anchor.y ~= nil then
				texture:SetPoint (anchor.from, anchor.object, anchor.to, anchor.x, anchor.y)
			else
				texture:SetPoint (anchor.from, anchor.object, anchor.to)
			end
		end
	end
	
	if this.callBack ~= nil then
		function texture.Event:LeftClick() this.callBack(self) end
	end
		
	if this.visible == false then texture:SetVisible(false) end
	this.element = texture	
	
	setmetatable(this, self)
	self.__index = self
	return this

end

function nkGenie.ExtTexture:SetTexture(settings)
	if settings == nil then return end
	
	local textureType = self.type
	if settings.type ~= nil then textureType = settings.type end
	
	self.element:SetTexture(textureType, settings.path)
end

function nkGenie.ExtTexture:update (settings) 
	
	if settings == nil then return end
	
	if settings.anchors ~= nil then
		for k, anchor in pairs(settings.anchors) do
			if anchor.x ~= nil and anchor.y ~= nil then
				self.element:SetPoint (anchor.from, anchor.object, anchor.to, anchor.x, anchor.y)
			else
				self.element:SetPoint (anchor.from, anchor.object, anchor.to)
			end
		end
	end
	
	if settings.width ~= nil then self.element:SetWidth(settings.width)  end
	if settings.height ~= nil then self.element:SetHeight(settings.height) end
	
	if settings.alpha ~= nil then self.element:SetAlpha(settings.alpha) end
	if settings.type ~= nil and settings.path ~= nil then self.element:SetTexture(settings.type, settings.path) end	
	if settings.layer ~= nil then self.element:SetLayer (settings.layer) end
	if settings.visible ~= nil then self.element:SetVisible (settings.visible) end
	
	for k, v in pairs (settings) do self[k] = v end
	
end

function nkGenie.ExtTexture:SetEvent(event, func)

	local element = self:getElement(false)

	if event == "LeftClick" then
		function element.Event:LeftClick() func(element)  end
	elseif event == "LeftDown" then
		function element.Event:LeftDown() func(element)  end
	elseif event == "MouseMove" then
		function element.Event:MouseMove() func(element)  end
	elseif event == "LeftUp" then
		function element.Event:LeftUp() func(element)  end
	elseif event == "RightClick" then
		function element.Event:RightClick() func(element)  end
	elseif event == "RightDown" then
		function element.Event:RightDown() func(element)  end
	elseif event == "RightUp" then
		function element.Event:RightUp() func(element)  end
	elseif event == "MiddleClick" then
		function element.Event:MiddleClick() func(element)  end
	elseif event == "MouseIn" then
		function element.Event:MouseIn() func(element)  end
	elseif event == "MouseOut" then
		function element.Event:MouseOut() func(element)  end
	end

end

function nkGenie.ExtTexture:SetMacro(event, macro)

	local element = self:getElement(false)

	if event == "LeftClick" then
		element.Event.LeftDown = macro
	elseif event == 'RightClick' then
		element.Event.RightDown = macro
	end

end

function nkGenie.ExtTexture:getElement() return self.element end
function nkGenie.ExtTexture:SetSecureMode(mode) self.element:SetSecureMode(mode) end
function nkGenie.ExtTexture:SetVisible(flag) self.element:SetVisible(flag) end
function nkGenie.ExtTexture:GetLeft() return self.element:GetLeft() end
function nkGenie.ExtTexture:GetTop() return self.element:GetTop() end
function nkGenie.ExtTexture:GetHeight() return self.element:GetHeight() end
function nkGenie.ExtTexture:GetWidth() return self.element:GetWidth() end
function nkGenie.ExtTexture:SetLayer(layer) return self.element:SetLayer(layer) end
