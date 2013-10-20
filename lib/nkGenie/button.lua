function nkGenie.ExtButton:new (name, parent, settings)
	
	if settings == nil then return nil end
	local this = settings
	this.name = name
	this.parent = parent
	
	if this.template ~= nil then
		for k, value in pairs (this.template) do
			if this[k] == nil then this[k] = value end
		end
		this.template = nil
	end	
	
	local width = 5
	if this.width ~= nil then width = this.width end
	
	local button = UI.CreateFrame('nkExtFrame', name, parent, { layer = layer, width = width, height = 25, color= {border = this.color.border, body = this.color.body}, anchors = this.anchors })
	local tempColor = nkGenie.Tools:ColorAdjust(this.color.body, 1.2)	
	
	button.upper = UI.CreateFrame('nkExtFrame', name .. 'upper', button:getElement(true), { height = 12, color= {body = tempColor}, anchors = {{from = "TOPLEFT", object = button:getElement(true), to = "TOPLEFT"},{ from = "TOPRIGHT", object = button:getElement(true), to = "TOPRIGHT"} }})	
	button.label = UI.CreateFrame('nkExtText', name .. 'label', button.upper:getElement(), { text = this.label, fontsize = 14, color = this.color.label , anchors = {{ from = "CENTER", object = button:getElement(), to = "CENTER"}}})
	
	if this.width == nil or this.autoWidth == true then 
		local width = button.label:GetWidth(true)
		button:update ({ width = width+10 })
	end

	if this.func ~= nil then
		local frame = button:getElement(false)
		function frame.Event:LeftClick() this.func() end
	end
	
	if this.macro ~= nil then
		local element = button:getElement(false)
		element:SetSecureMode('restricted')
		element.Event.LeftDown = this.macro
	end
		
	this.button = button
	setmetatable(this, self)
	self.__index = self
	return this
	
end

function nkGenie.ExtButton:getElement()

	return self.button:getElement(false)

end

function nkGenie.ExtButton:update()

	if settings == nil then return end
	if settings.template ~= nil then
		for k, v in pairs (settings.template) do if settings[k] == nil then settings[k] = v end end
		settings.template = nil
	end	
	
	if settings.width ~= nil then self:getElement():SetWidth(settings.width) end
	for k, v in pairs (settings) do self[k] = v end

end

function nkGenie.ExtRiftButton:new (name, parent, settings)

	if settings == nil then return nil end
	local this = settings
	this.name = name
	this.parent = parent
	
	if this.template ~= nil then
		for k, value in pairs (this.template) do
			if this[k] == nil then this[k] = value end
		end
		this.template = nil
	end	
		
	local button = UI.CreateFrame('RiftButton', name, parent)	
			
	this.button = button
	setmetatable(this, self)
	self.__index = self
	return this

end

function nkGenie.ExtRiftButton:update(settings)

	if settings == nil then return end
	if settings.template ~= nil then
		for k, v in pairs (settings.template) do if settings[k] == nil then settings[k] = v end end
		settings.template = nil
	end	
	
	if settings.anchors ~= nil then
		for k, anchor in pairs(settings.anchors) do
			if anchor.x ~= nil and anchor.y ~= nil then
				--self.button:CearAll()
				self.button:SetPoint (anchor.from, anchor.object, anchor.to, anchor.x, anchor.y)
			else
				self.button:SetPoint (anchor.from, anchor.object, anchor.to)
			end
		end
	end
		
	if settings.label ~= nil then self.button:SetText(settings.label) end
	if settings.layer ~= nil then self.button:SetLayer(settings.layer) end
	if settings.width ~= nil then self.button:SetWidth(settings.width) end
	
	if settings.func ~= nil then
		function self.button.Event:LeftPress() settings.func() end
	end
		
	for k, v in pairs (settings) do self[k] = v end

end

function nkGenie.ExtRiftButton:getElement() return self.button end