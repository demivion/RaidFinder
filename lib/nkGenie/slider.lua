function nkGenie.ExtSlider:new(name, parent, settings)

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
	
	local slider = UI.CreateFrame ('nkExtFrame', name, parent, { width = this.width, height = 14, anchors = this.anchors })

	if this.labelinfront == true then
		slider.text = UI.CreateFrame ('nkExtText', name .. 'label', slider:getElement(), { width = this.labelwidth, text = this.text, fontsize = this.fontsize, color = this.color.border, anchors = {{from = "TOPLEFT", object = slider:getElement(), to = "TOPLEFT" }}  })
		slider.bar = UI.CreateFrame ('nkExtFrame', name .. 'bar', slider.text:getElement(), { width = this.width, height = 10, color = this.color, anchors = {{ from = "CENTERLEFT", object = slider.text:getElement(), to = "CENTERRIGHT",x=5,y=0 }}})
	else
		slider.bar = UI.CreateFrame ('nkExtFrame', name .. 'bar', slider:getElement(), { width = this.width, height = 10, color = this.color, anchors = {{ from = "TOPLEFT", object = slider:getElement(), to = "TOPLEFT" }}})
		slider.text = UI.CreateFrame ('nkExtText', name .. 'label', slider.bar:getElement(), { width = this.labelwidth, text = this.text ,fontsize = this.fontsize, color = this.color.border, anchors = {{from = "CENTERLEFT", object = slider.bar:getElement(), to = "CENTERRIGHT" }}  })		
	end	

	local x = this.width / (this.range[2] - this.range[1]) * (this.value - this.range[1]) - 7
	slider.box = UI.CreateFrame ('nkExtFrame', name .. 'box', slider.bar:getElement(), { width = 14, height = 14, color = {body = this.color.border}, anchors = {{from = "CENTERLEFT", object = slider.bar:getElement(), to = "CENTERLEFT", x = x, y = 0}}})

	slider.bar:SetEvent('LeftDown', function() slider.bar.MouseDown = true end)		
	slider.bar:SetEvent('MouseMove', function() self:ProcessMove (this) end)	
	slider.bar:SetEvent('LeftUp', function() slider.bar.MouseDown = false end)
	
	this.element = slider
	
	setmetatable(this, self)
	self.__index = self
	return this

end

function nkGenie.ExtSlider:ProcessMove (this)

	if this.element.bar.MouseDown then
	
		if Inspect.Mouse().y < (this.element.bar:getElement():GetTop()-10) or Inspect.Mouse().y > (this.element.bar:getElement():GetTop() + 20) then this.element.bar.MouseDown = false end
		if Inspect.Mouse().x < (this.element.bar:getElement():GetLeft()-20) or Inspect.Mouse().x > (this.element.bar:getElement():GetLeft() + this.width + 20) then this.element.bar.MouseDown = false end
		local curdivX = Inspect.Mouse().x - this.element.bar:getElement():GetLeft()-7
		local valuePerPixel = (this.range[2] - this.range[1]) / this.width
		local newValue = curdivX * valuePerPixel + this.range[1]
		if newValue < this.range[1] then newValue = this.range[1] end
		if newValue > this.range[2] then newValue = this.range[2] end
		
		if this.precision == nil then this.precision = 0 end		
		this.value = nkTools.round(newValue, this.precision)
		
		local x = this.width / (this.range[2] - this.range[1]) * ( newValue - this.range[1]) - 7
		this.element.box:getElement():SetPoint ("CENTERLEFT", this.element.bar:getElement(),"CENTERLEFT", x, 0)
		
		if this.func ~= nil then this.func (this) end
	end
end

function nkGenie.ExtSlider:update( settings ) 

	if settings == nil then return end
		
	if settings.template ~= nil then
		for k, v in pairs (settings.template) do if settings[k] == nil then settings[k] = v end end
		settings.template = nil
	end
	
	if settings.text ~= nil then self.element.text:update({width = self.labelwidth, text = settings.text}) end

	for k, v in pairs (settings) do self[k] = v end
	
end

function nkGenie.ExtSlider:SetValue (value)

	self.value = value
	local x = self.width / (self.range[2] - self.range[1]) * ( value - self.range[1]) - 7
	self.element.box:getElement():SetPoint ("CENTERLEFT", self.element.bar:getElement(),"CENTERLEFT", x, 0)

end

function nkGenie.ExtSlider:getElement() return self.element:getElement() end