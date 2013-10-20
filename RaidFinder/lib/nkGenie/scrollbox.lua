function nkGenie.ExtScrollBox:new(name, parent, settings)

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
	
	local slider = UI.CreateFrame ('nkExtFrame', name, parent, { width = 14, height = this.height, anchors = this.anchors })
	
	if settings.visible ~= nil then slider:SetVisible(settings.visible) end
	
	slider.bar = UI.CreateFrame ('nkExtFrame', name .. 'bar', slider:getElement(), { width = 10, height = this.height, color = this.color, anchors = {{ from = "CENTERTOP", object = slider:getElement(), to = "CENTERTOP", x = 0, y = 0 }}})
	
	local y = math.floor((this.height-28) / (this.range[2] - this.range[1]) * (this.value - this.range[1]))
	if this.range[2] - this.range[1] == 0 or y < 0 then y = 0 end	
	
	slider.box = UI.CreateFrame ('nkExtFrame', name .. 'box', slider.bar:getElement(), { width = 14, height = 28, color = {body = this.color.border}, anchors = {{from = "CENTERTOP", object = slider.bar:getElement(), to = "CENTERTOP", x = 0, y = y}}})

	slider.bar:SetEvent('LeftDown', function() slider.bar.MouseDown = true end)		
	slider.bar:SetEvent('MouseMove', function() self:ProcessMove (this) end)	
	slider.bar:SetEvent('LeftUp', function() slider.bar.MouseDown = false end)
	
	this.element = slider
	
	setmetatable(this, self)
	self.__index = self
	return this

end

function nkGenie.ExtScrollBox:ProcessMove (this)

	if this.element.bar.MouseDown then
	
		if Inspect.Mouse().y < (this.element.bar:getElement():GetTop()-40) or Inspect.Mouse().y > (this.element.bar:getElement():GetTop() + this.height + 40) then this.element.bar.MouseDown = false end
		if Inspect.Mouse().x < (this.element.bar:getElement():GetLeft()-40) or Inspect.Mouse().x > (this.element.bar:getElement():GetLeft() + 40) then this.element.bar.MouseDown = false end

		local curdivY = Inspect.Mouse(). y - this.element.bar:getElement():GetTop()
		
		local valuePerPixel = (this.range[2] - this.range[1]) / (this.height-28)
		local newValue = curdivY * valuePerPixel + this.range[1]
		if newValue < this.range[1] then newValue = this.range[1] end
		if newValue > this.range[2] then newValue = this.range[2] end
		
		this.value = newValue
		
		local y = (this.height-28) / (this.range[2] - this.range[1]) * ( newValue - this.range[1])
		
		if y < 0 then y = 0 end
		if y + 28 > this.height then y = this.height - 28 end
		
		this.element.box:getElement():SetPoint ("CENTERTOP", this.element.bar:getElement(),"CENTERTOP", 0, y)
		
		if this.func ~= nil then this.func (this) end
	end
end

function nkGenie.ExtScrollBox:SetValue (value)

	if self.range[1] == self.range[2] then return end

	self.value = value
	local y = (self.height-28) / (self.range[2] - self.range[1]) * ( value - self.range[1]) - 7
	
	if y < 0 then y = 0 end
	--self.element.box:getElement():ClearAll()
	self.element.box:getElement():SetPoint ("CENTERTOP", self.element.bar:getElement(),"CENTERTOP", 0, y)

end

function nkGenie.ExtScrollBox:updateRange (range)

	self.range = range
	self:SetValue(1)

end

function nkGenie.ExtScrollBox:SetVisible (flag) self.element:SetVisible(flag) end
function nkGenie.ExtScrollBox:update( settings ) end
function nkGenie.ExtScrollBox:getElement() return self.element:getElement() end