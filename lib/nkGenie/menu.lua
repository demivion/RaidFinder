nkGenie.ExtMenu.MenuItem = {}

function nkGenie.ExtMenu:new (name, parent, settings)

	if settings == nil then return nil end
	local this = settings
	this.name = name
	this.parent = parent
	
	if this.template ~= nil then
		for k, v in pairs (this.template) do
			if this[k] == nil then this[k] = v end
		end
		this.template = nil
	end

	local menuItemTemplate = { width = this.width - 2, height = this.fontsize, color = this.color }
	
	local frame = UI.CreateFrame ('nkExtFrame', name, parent, { color = { body = this.color.body, border = this.color.border }, width = this.width, anchors = this.anchors, visible = false })
	frame:SetSecureMode('restricted')
	frame:getElement(true):SetSecureMode('restricted');
	
	this.element = frame
	setmetatable(this, self)
	self.__index = self
	return this

end

function nkGenie.ExtMenu:GetVisible() return self.element:getElement(false):GetVisible() end
function nkGenie.ExtMenu:SetVisible(flag) return self.element:getElement(false):SetVisible(flag) end
function nkGenie.ExtMenu:getElement() return self.element:getElement(false) end
function nkGenie.ExtMenu:getEntryCount() return #self.element.menuItems end
function nkGenie.ExtMenu:getItems() return self.element.menuItems end

function nkGenie.ExtMenu:update(settings) 

	if settings == nil then return end
	
	local frame = self.element	
	
	if frame.menuItems == nil then frame.menuItems = {} end
	if frame.sepItems == nil then frame.sepItems = {} end
	
	local menuItemTemplate = { width = self.width - 2, height = self.fontsize, color = self.color }
	local anchors = {{ from = "TOPLEFT", object = frame:getElement(true), to = "TOPLEFT"}}
	local height = 4
	local menuCount = 1
	local sepCount = 1
		
	for k, v in pairs (settings.items) do
		if v.seperator == true then
			local sep = frame.sepItems[sepCount]
			
			if sep == nil then
				anchors[1].x = 0
				anchors[1].y = 5
				sep = UI.CreateFrame ('nkExtFrame', self.name .. 'sep' .. sepCount, frame:getElement(true), { color = { body = self.color.border }, width = self.width-2, height = 1, anchors = anchors })
				table.insert (frame.sepItems, sep)
			else
				sep:update({ anchors = anchors })
			end
			
			height = height + 11
			anchors = {{ from = "TOPLEFT", object = sep:getElement(), to = "BOTTOMLEFT", x = 0, y = 5 }}
			sepCount = sepCount + 1
		else
			local menuItem = frame.menuItems[menuCount]
					
			local clickFunc = function()
				if v.closeOnClick == true then self:SetVisible(false) end
				v.func()
			end
			
			if menuItem == nil then
				menuItem = nkGenie.ExtMenu.MenuItem:new (self.name .. 'item' .. menuCount, frame:getElement(true), { fontsize = self.fontsize, width = self.width -2 , label = v.label, macro = v.macro, func = clickFunc, anchors = anchors, template = menuItemTemplate })
				table.insert (frame.menuItems, menuItem)
			else
				menuItem:update({label = v.label, macro = v.macro, func = clickFunc})
			end
				
			height = height + menuItem:getHeight()
			anchors = {{ from = "TOPLEFT", object = menuItem:getElement(), to = "BOTTOMLEFT" }}
			menuCount = menuCount + 1
		end
		
	end
	
	frame:update ({ height = height })
	
	for k, v in pairs (settings) do self[k] = v end

end

function nkGenie.ExtMenu.MenuItem:new (name, parent, settings)

	if settings == nil then return nil end
	local this = settings
	this.name = name
	this.parent = parent
	
	if this.template ~= nil then
		for k, v in pairs (this.template) do
			if this[k] == nil then this[k] = v end
		end
		this.template = nil
	end

	local frame = UI.CreateFrame ('nkExtFrame', name, parent, { width = this.width, color = { body = this.color.body }, anchors = this.anchors })
	frame:SetSecureMode('restricted')
	frame.label = UI.CreateFrame ('nkExtText', name .. 'label', frame:getElement(), { text = this.label, fontsize = this.fontsize, width = this.width, color = this.color.labelinactive, anchors = {{ from = "TOPLEFT", object = frame:getElement(), to = "TOPLEFT" }} })
	
	frame:update ({ height = frame.label:getElement():GetHeight() })
		
	if this.macro ~= nil then
		frame:SetMacro('LeftClick', this.macro)
	end
	
	if this.func ~= nil then	
		frame:SetEvent('LeftClick', function (element) this.func() end)
	end
	
	frame:SetEvent('MouseIn', function (element) 
		frame:update ({ color = { body = this.color.bodyactive}  })
		frame.label:update ({ color = this.color.labelactive })
	end)
	
	frame:SetEvent('MouseOut', function (element) 
		frame:update ({ color = { body = this.color.body}  })
		frame.label:update ({ color = this.color.labelinactive })
	end)
	
	this.element = frame
	setmetatable(this, self)
	self.__index = self
	return this
	
end

function nkGenie.ExtMenu.MenuItem:update (settings)

	if settings == nil then return end
	
	if settings.label ~= nil then self.element.label:update ({ text = settings.label }) end

	for k, v in pairs (settings) do self[k] = v end

end

function nkGenie.ExtMenu.MenuItem:getElement() return self.element:getElement() end
function nkGenie.ExtMenu.MenuItem:getHeight() return self.element.label:getElement():GetHeight() end