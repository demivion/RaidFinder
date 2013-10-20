function nkGenie.ExtText:new (name, parent)

	local this = {}
	this.name = name
	this.parent = parent	
	
	this.element = UI.CreateFrame("Text", name, parent)

	setmetatable(this, self)
	self.__index = self
	return this
	
end

function nkGenie.ExtText:update(settings)
	
	if settings == nil then return end
	if settings.template ~= nil then
		for k, v in pairs (settings.template) do if settings[k] == nil then settings[k] = v end end
		settings.template = nil
	end

	if settings.fontsize ~= nil then self.element:SetFontSize(settings.fontsize) end
	if settings.wordwrap ~= nil then self.element:SetWordwrap(settings.wordwrap) end
	
	if settings.text ~= nil then self.element:SetText(settings.text) end
	
	if settings.height == nil and self.height == nil then 
		self.element:ClearHeight()		
	--	self.element:SetHeight(self.element:GetFullHeight())		
	elseif settings.height ~= nil then
		self.element:SetHeight(math.floor(settings.height))
	else
		self.element:SetHeight(math.floor(self.height))
	end		
	
	if settings.autowidth == true then 
		-- Für die Kompatibilität, wird gelöscht sobald ich autowidth überall entfernt habe
		settings.width = nil
		self.width = nil
	end
	
	if settings.width == nil and self.width == nil then
	--	self.element:SetWidth(self.element:GetFullWidth())
	elseif settings.width ~= nil then
		self.element:SetWidth(settings.width)
	else
		self.element:SetWidth(self.width)
	end
	
	if settings.color ~= nil then
		local alpha = settings.alpha or 1
		local color = nkGenie.Tools:HexToRGB (settings.color)

		self.element:SetFontColor(color[1], color[2], color[3], alpha)
	end
	
	if settings.anchors ~= nil then
		for k, anchor in pairs(settings.anchors) do
			if anchor.x ~= nil and anchor.y ~= nil then
				self.element:SetPoint (anchor.from, anchor.object, anchor.to, anchor.x, anchor.y)
			else
				self.element:SetPoint (anchor.from, anchor.object, anchor.to)
			end
		end	
	end	
	
	if settings.visible ~= nil then self.element:SetVisible(settings.visible) end
	if settings.layer ~= nil then self.element:SetLayer(settings.layer) end
	
	for k, v in pairs (settings) do self[k] = v end

end

function nkGenie.ExtText:SetEvent(event, func)

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
	end

end
	
function nkGenie.ExtText:getElement() return self.element end
function nkGenie.ExtText:GetWidth() return self:getElement():GetWidth() end
function nkGenie.ExtText:GetHeight() return self:getElement():GetHeight() end
function nkGenie.ExtText:getText() return self:getElement():GetText() end
function nkGenie.ExtText:SetVisible(flag) self:getElement():SetVisible(flag) end
function nkGenie.ExtText:SetLayer(layer) self:getElement():SetLayer(layer) end