function nkGenie.ExtCheckbox:new (name, parent, settings)

	if settings == nil then return nil end
	local this = {}
	this.name = name
	this.parent = parent
	
	if settings.template ~= nil then
		for k, value in pairs (settings.template) do
			if settings[k] == nil then settings[k] = value end
		end
		settings.template = nil
	end	
	
	if settings.checked == nil then settings.checked = false end
	
	local element = UI.CreateFrame ('nkExtFrame', name, parent, { anchors = settings.anchors, width = settings.labelwidth + settings.fontsize + 7 } )
	
	local labelColor = settings.color.border
	if settings.color.label ~= nil then labelColor = settings.color.label end
	
	if settings.labelinfront == true then
		element.text = UI.CreateFrame('nkExtText', name .. 'label', element:getElement(), { wordwrap = true, width = settings.labelwidth, text = settings.text, fontsize = settings.fontsize, color = labelColor, anchors = {{from = "TOPLEFT", object = element:getElement(), to = "TOPLEFT" }} })
		element.box = UI.CreateFrame('nkExtFrame', name .. 'box', element:getElement(), { width = settings.fontsize + 2, height = settings.fontsize + 2, color = { border = settings.color.border, body = settings.color.body}, anchors = {{from = "CENTERLEFT", object = element.text:getElement(), to = "CENTERRIGHT", x =5, y = 0  }}})
	else
		element.box = UI.CreateFrame('nkExtFrame', name .. 'box', element:getElement(), { width = settings.fontsize + 2, height = settings.fontsize + 2, color = { border = settings.color.border, body = settings.color.body}, anchors = {{from = "TOPLEFT", object = element:getElement(), to = "TOPLEFT" }} })
		element.text = UI.CreateFrame('nkExtText', name .. 'label', element:getElement(), { wordwrap = false, width = settings.labelwidth, text = settings.text, fontsize = settings.fontsize, color = labelColor, anchors = {{from = "CENTERLEFT", object = element.box:getElement(), to = "CENTERRIGHT", x = 5, y = 0 }} })
	end
	
	element.box.mark = UI.CreateFrame('nkExtFrame', name .. 'mark', element.box:getElement(), {width = element.box:getElement(true):GetWidth()-4, height = element.box:getElement(true):GetHeight()-4, color = { body = settings.color.border}, anchors = {{from = "CENTER", object = element.box:getElement(), to = "CENTER" }}, visible = settings.checked})
	element:update ({ width = element.text:GetWidth() + element.box:getElement(false):GetWidth()+5, height = element.box:getElement(false):GetHeight() })
	
	element.box:SetEvent ("LeftClick", function () 
		if this.checked == false then this.checked = true else this.checked = false end 			
		this:toggle(this.checked)
		if this.func ~= nil then this.func (this) end
	end)
			
	this.element = element	
	for k, v in pairs (settings) do this[k] = v end
	
	setmetatable(this, self)
	self.__index = self
	return this

end

function nkGenie.ExtCheckbox:update ( settings ) 

	if settings == nil then return end
	
	if settings.template ~= nil then
		for k, value in pairs (settings.template) do if settings[k] == nil then settings[k] = value end end
		settings.template = nil
	end	
	
	if settings.text ~= nil then self.element.text:update ({width = settings.labelwidth, text = settings.text}) end
	
	for k, v in pairs (settings) do self[k] = v end

end

function nkGenie.ExtCheckbox:toggle (flag)

	self.checked = flag
	self.element.box.mark:update({ visible = flag })

end

function nkGenie.ExtCheckbox:getChecked () return self.checked end
function nkGenie.ExtCheckbox:getElement() return self.element:getElement() end
function nkGenie.ExtCheckbox:getLabel() return self.element.text:getText() end
function nkGenie.ExtCheckbox:SetVisible(flag) return self.element:SetVisible(flag) end