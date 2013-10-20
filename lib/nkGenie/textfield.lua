function nkGenie.ExtTextField:new(name, parent, settings)

	if settings == nil then return nil end
	
	local this = {}
	this.name = name
	this.parent = parent
	
	if settings.template ~= nil then
		for k, v in pairs (settings.template) do
			if settings[k] == nil then settings[k] = v end
		end
		settings.template = nil
	end
	
	local element = UI.CreateFrame ('nkExtFrame', name .. 'border', parent, { width = settings.width, height = settings.height, color = settings.color })
	
	if settings.label ~= nil then
		element.label = UI.CreateFrame ('nkExtText', name .. 'label', parent, { fontsize = settings.fontsize, color = settings.color.label, width = settings.labelwidth, text = settings.label, anchors = settings.anchors })
		element:update ({ anchors = {{ from = "CENTERLEFT", object = element.label:getElement(), to = "CENTERRIGHT", x = 5, y = 0 }} })
	else
		element:update ({ anchors = settings.anchors })
	end
	
	element.textfield = UI.CreateFrame ('RiftTextfield', name, element:getElement(true) )
	element.textfield:SetPoint ("CENTERLEFT", element:getElement(true), "CENTERLEFT", 2, 0)
	
	if settings.width ~= nil then element.textfield:SetWidth (settings.width) end
	if settings.height ~= nil then element.textfield:SetHeight (settings.height) end

	if settings.value ~= nil then element.textfield:SetText (tostring(settings.value)) end
	
	if settings.func ~= nil then
		function element.textfield.Event:KeyDown(key) 
			local code = string.byte(key)
			if tonumber(code) == 13 then
				if settings.valuetype == 'number' then
					local tmpValue = self:GetText()
					if tmpValue == '' then settings.func(0) else 
						if tonumber(tmpValue) == nil then
							settings.func(0) 
						else
							settings.func(tonumber(tmpValue)) 
						end
					end					
				else
					settings.func(self:GetText());
				end				
				self.restoreValue = false;
				self:SetKeyFocus(false);
			end
		end
	end
	
	function element.textfield.Event:LeftClick()
		self.backupValue = self:GetText()
		if settings.color.focus ~= nil then
			local color = { body = settings.color.body, border = settings.color.focus }
			element:update ({ color = color } )
		end
	end
	
	function element.textfield.Event:KeyFocusLoss()
		if self.restoreValue ~= false and self.backupValue ~= nil then	
			element.textfield:SetText(self.backupValue)
		end
		self.restoreValue = nil
		self.backupValue = nil
		element:update({ color = settings.color })
	end
	
	for k, v in pairs (settings) do this[k] = v end
	this.element = element
	
	setmetatable(this, self)
	self.__index = self
	return this
	
end

function nkGenie.ExtTextField:getValue(getAsTextFlag) 
	local value = self.element.textfield:GetText() 
	if self.valuetype == 'number' and getAsTextFlag ~= true then
		return tonumber(value)
	else
		return value
	end
end

function nkGenie.ExtTextField:update (settings) 

	if settings.visible ~= nil then self.element:SetVisible(settings.visible) end
	
	for k, v in pairs (settings) do self[k] = v end
	
end


function nkGenie.ExtTextField:getElement() return self.element:getElement(true) end
function nkGenie.ExtTextField:setValue(value) self.element.textfield:SetText(tostring(value)) end
function nkGenie.ExtTextField:leave() self.restoreValue = false; self.element.textfield:SetKeyFocus(false) end
function nkGenie.ExtTextField:select() self.element.textfield:SetKeyFocus(true); self.element.textfield:SetSelection(0, string.len(self:getValue(true))) end
function nkGenie.ExtTextField:SetVisible(flag) self.element:SetVisible(flag) end
function nkGenie.ExtTextField:GetVisible() return self.element:GetVisible() end
