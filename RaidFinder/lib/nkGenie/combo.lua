nkGenie.ExtCombo.activeCombo = nil

function nkGenie.ExtCombo:new(name, parent, settings)

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
	
	if settings.value == nil then settings.value = '' end
	settings.counter = 1
	settings.collapsed = true
	
	local comboHeight = settings.fontsize + 8
	local selFrameHeight = (5 * (settings.fontsize + 7)+8)
	if #settings.selection < 5 then selFrameHeight = (#settings.selection * (settings.fontsize + 7) + 8) end
	
	local masterHeight = comboHeight
	local iconBoxSize = settings.fontsize + 8

	local frame = UI.CreateFrame ('nkExtFrame', name, parent, {layer = settings.layer, width = settings.width, height = masterHeight, anchors = settings.anchors })
	frame.label = UI.CreateFrame ('nkExtFrame', name .. 'label', frame:getElement(), {color = settings.color, width = (settings.width - iconBoxSize + 1), height = comboHeight, anchors = {{ from = "TOPLEFT", object = frame:getElement(), to = "TOPLEFT"}} })

	local comboText = ''
	
	if settings.value ~= nil then
		for k, v in pairs (settings.selection) do
			if v.value == settings.value then comboText = v.label; break end
		end
	end
	
	frame.labelValue = UI.CreateFrame('nkExtText', name .. 'labelValue', frame.label:getElement(true), {color = settings.color.label, width = (settings.width - iconBoxSize - 7), text = comboText, fontsize = settings.fontsize, anchors = {{ from = "CENTERLEFT", object = frame.label:getElement(true), to = "CENTERLEFT", x = 4, y = 0 }} })
	frame.IconBox = UI.CreateFrame('nkExtFrame', name .. 'IconBox', frame.label:getElement(true), {color = settings.color, width = iconBoxSize, height = comboHeight, anchors = {{ from = "TOPRIGHT", object = frame:getElement(), to = "TOPRIGHT"}} })
	frame.IconBoxText = UI.CreateFrame('nkExtText', name .. 'IconBoxText', frame.IconBox:getElement(true), {color = settings.color.label, text = 'v', fontsize = settings.fontsize, anchors = {{ from = "CENTER", object = frame.IconBox:getElement(true), to = "CENTER"}} })
		
	frame.selFrame = UI.CreateFrame('nkExtFrame', name .. 'selFrame', frame:getElement(), {visible = false, width = settings.width, height = selFrameHeight, color = settings.color, anchors = {{ from = "TOPLEFT", object = frame.label:getElement(false), to = "BOTTOMLEFT", x = 0, y = -1 }} })
	frame.selFrame.selValues = {}

	local selValueItemAnchor = {{ from = "TOPLEFT", object = frame.selFrame:getElement(false), to = "TOPLEFT", x = 4, y = 4 }}
	
	table.sort (settings.selection, function (a, b) return (a.label < b.label) end )
	
	for idx = 1, 5, 1 do
		local visible = true
		if idx > #settings.selection then visible = false end

		local selValueItem = UI.CreateFrame('nkExtFrame', name .. 'selValueFrame' .. idx, frame.selFrame:getElement(true), {width = (settings.width- 8), height = settings.fontsize + 7, anchors = selValueItemAnchor })
		selValueItem.label = UI.CreateFrame('nkExtText', name .. 'selValueLabel' .. idx, selValueItem:getElement(), {visible = visible, color = settings.color.label, text = '', width = (settings.width - 8), fontsize = settings.fontsize, anchors = selValueItemAnchor })		
		
		selValueItem:SetEvent('MouseIn', function () 
			this:rowHighlight(idx, true) 
		end)
	
		selValueItem:SetEvent('MouseOut', function () 
			this:rowHighlight(idx, false) 
		end)			
		
		selValueItem:SetEvent('LeftClick', function ()
			local selValue = this.selection[idx + this.counter - 1]			
			this:setValue ( selValue.label )
			if settings.func ~= nil then settings.func (selValue.value) end
		end)
		
		table.insert (frame.selFrame.selValues, selValueItem)
		selValueItemAnchor = {{ from = "TOPLEFT", object = selValueItem:getElement(), to = "BOTTOMLEFT"}}
	end

	frame:SetEvent ('LeftClick', function()
		--if nkGenie.ExtCombo.activeCombo == nil or nkGenie.ExtCombo.activeCombo == this.name then			
			if this.collapsed == true then
				if nkGenie.ExtCombo.activeCombo ~= nil then
					nkGenie.ExtCombo.activeCombo:close()
				end
				
				nkGenie.ExtCombo.activeCombo = this
				this.collapsed = false
				frame.selFrame:SetVisible(true)
				this:showValues()
			else
				nkGenie.ExtCombo.activeCombo = nil
				frame.selFrame:SetVisible(false)
				this.collapsed = true
			end
		--end
	end)
		
	local maxRange = #settings.selection - 4
	frame.selFrame.slider = UI.CreateFrame('nkExtScrollBox', name .. 'selFrameSlider', frame.selFrame:getElement(), { visible = false, value = 1, color = settings.color, height = frame.selFrame:getElement():GetHeight(), anchors = {{ from = "TOPRIGHT", object = frame.selFrame:getElement(), to = "TOPRIGHT",x =-3,y =0}}, range = {1, maxRange},
																							func = function (slider) this.counter = math.floor(slider.value); this:showValues() end })
	if #settings.selection > 5 then
		frame.selFrame.slider:SetVisible(true)
		for idx = 1, 5, 1 do
			frame.selFrame.selValues[idx]:update( {width = (settings.width- 22) })
			frame.selFrame.selValues[idx].label:update( {width = (settings.width- 28) })
		end
	end
		
	frame.selFrame:SetEvent('WheelForward', function ()
		if #this.selection < 5 then return end
		this.counter = this.counter - 1
		if this.counter == 0 then this.counter = 1 end		
		this:showValues()
		frame.selFrame.slider:SetValue(this.counter)
	end)
	
	frame.selFrame:SetEvent ('WheelBack', function ()
		if #this.selection < 5 then return end
		this.counter = this.counter + 1
		if this.counter > (#this.selection - 4) then this.counter = (#this.selection-4) end
		this:showValues()
		frame.selFrame.slider:SetValue(this.counter)
	end)
	
	for k, v in pairs (settings) do this[k] = v end
	this.element = frame
	
	setmetatable(this, self)
	self.__index = self
	return this
	
end

function nkGenie.ExtCombo:showValues ()

	local selValue = 1
	local width = self.width - 8
	
	if #self.selection > 5 then
		local maxRange = #self.selection - 4
		self.element.selFrame.slider:updateRange({1, maxRange})
		self.element.selFrame.slider:SetVisible(true)
		self.element.selFrame:update({ height = (5 * (self.fontsize + 7)+8) })
		
		width = self.width -22
	else
		self.element.selFrame.slider:SetVisible(false)
		self.element.selFrame:update({ height = (#self.selection * (self.fontsize + 7)+8) })		
	end
	
	for idx = self.counter, self.counter+4, 1 do
		if idx > #self.selection then 
			self.element.selFrame.selValues[selValue]:SetVisible(false)
			self.element.selFrame.selValues[selValue].label:SetVisible(false)
		else
			self.element.selFrame.selValues[selValue]:SetVisible(true)
			self.element.selFrame.selValues[selValue].label:SetVisible(true)
			self.element.selFrame.selValues[selValue]:update({ width = width })
			self.element.selFrame.selValues[selValue].label:update ({ text = self.selection[idx].label, width = width })
		end
		
		selValue = selValue +1
	end
	
end

function nkGenie.ExtCombo:setValue (value)

	self.element.selFrame:SetVisible(false)
	self.collapsed = true
	self.element.labelValue:update ({ text = value })
	
	for k, v in pairs (self.selection) do
		if v.label == value then
			self.value = v.value			
			break
		end
	end

end

function nkGenie.ExtCombo:setByValue (value)

	for k, v in pairs (self.selection) do
		if v.value == value then
			self:setValue(v.label)
			break
		end
	end

end

function nkGenie.ExtCombo:rowHighlight (row, active)
	
	local element = self.element.selFrame.selValues[row]	

	if active == true then
		element:update ({ color = {body = self.color.label} })
		element.label:update ({ color = self.color.border })
	else
		element:update ({ color = {body = self.color.body} })
		element.label:update ({ color = self.color.label })
	end
	
end

function nkGenie.ExtCombo:update() end

function nkGenie.ExtCombo:updateSelection (selection) 

	if selection == nil then return end

	self.counter = 1
	self.collapsed = true
	self.element.selFrame:SetVisible(false)
	
	if self.sortSel ~= false then table.sort (selection, function (a, b) return (a.label < b.label) end ) end
	
	self.selection = selection

	for k, v in pairs (selection) do
		if self.value == v.value then			
			self.element.labelValue:update ({ text = v.label })
			break
		end
	end
	
end

function nkGenie.ExtCombo:getElement() return self.element:getElement(false) end
function nkGenie.ExtCombo:getValue() return self.value end
function nkGenie.ExtCombo:SetVisible(flag) self:getElement():SetVisible(flag) end

function nkGenie.ExtCombo:close() 

	self.element.selFrame:SetVisible(false)
	self.collapsed = true

end