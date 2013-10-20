function nkGenie.ExtItemTooltip:new (name, parent, settings)
	
	local this = {}
	this.name = name
	
	local fontsize = settings.fontsize
	if fontsize == nil then fontsize = 13 end
	
	local tooltip = UI.CreateFrame('nkExtFrame', name, parent, { color = { border = '333333', body = '000000'}, visible = false } ) 
	
	tooltip:getElement(false):SetLayer(3)
	tooltip.title = UI.CreateFrame('nkExtText', name .. 'Title', tooltip:getElement(true), {fontsize = fontsize, anchors = {{from = "TOPLEFT", object = tooltip:getElement(true), to = "TOPLEFT", x = 5, y = 5 }} })
	tooltip.bop = UI.CreateFrame('nkExtText', name .. 'bop', tooltip:getElement(true), {fontsize = fontsize, anchors = {{from = "TOPLEFT", object = tooltip:getElement(true), to = "TOPLEFT", x = 5, y = 22 }} })

	tooltip.subTitle = UI.CreateFrame('nkExtText', name .. 'SubTitle', tooltip.title:getElement(true), {fontsize = fontsize, anchors = {{from = "TOPLEFT", object = tooltip:getElement(true), to = "TOPLEFT", x = 5, y = 39 }} })
	tooltip.subValue = UI.CreateFrame('nkExtText', name .. 'SubTitle', tooltip.title:getElement(true), {fontsize = fontsize, anchors = {{from = "TOPRIGHT", object = tooltip:getElement(true), to = "TOPRIGHT", x = -5, y = 39 }} })

	tooltip.separator = UI.CreateFrame('nkExtFrame', name .. 'Sep', tooltip.title:getElement(true), { height = 1, color = { body = '999999'}, anchors = {{ from = "TOPLEFT", object = tooltip.subTitle:getElement(), to = "BOTTOMLEFT", x = 2, y = 0}, { from = "TOPRIGHT", object = tooltip.subValue:getElement(), to = "BOTTOMRIGHT", x = -2, y = 0}} })
	
	tooltip.lines = {}
	
	local anchor = {{from = "TOPLEFT", object = tooltip.subTitle:getElement(true), to = "BOTTOMLEFT", x = 0, y = 2}}
	
	for idx = 1, 6, 1 do
		local line = UI.CreateFrame('nkExtText', name .. 'Line' .. idx, tooltip:getElement(true), { text = '', fontsize = fontsize, color = 'FFFFFF', anchors = anchor, visible = false })
		anchor = {{from = "TOPLEFT", object = line:getElement(true), to = "BOTTOMLEFT"}}
		table.insert (tooltip.lines, line)
	end
		
	this.element = tooltip
	for k, v in pairs (settings) do this[k] = v end
	
	setmetatable(this, self)
	self.__index = self
	return this

end

function nkGenie.ExtItemTooltip:update (settings)

	if settings == nil then return end
	
	local qualityColor = {"267F00", "4777B7", "985DC9","FF6A00"}
	
	if settings.template ~= nil then
		for k, v in pairs (settings.template) do if settings[k] == nil then settings[k] = v end end
		settings.template = nil
	end	
	
	for k, v in pairs (settings) do self[k] = v end
	if settings.onUseText == nil then self.onUseText = nil end
	if settings.onEquipText == nil then self.onEquipText = nil end
	if settings.descText == nil then self.descText = nil end
	if settings.flavText == nil then self.flavText = nil end
	if settings.lines == nil then self.lines = nil end
	if settings.addLine == nil then self.addLine = nil end
	if settings.bop == nil then self.bop = nil end
	if settings.account == nil then self.account = nil end
	if settings.bound == nil then self.bound = nil end
	if settings.quality == nil then self.quality = 0 end
	if settings.subTitle == nil then self.subTitle = nil end

	--if self.lines == nil then return end
	
	local tooltip = self.element
	
	if self.titleColor == nil then
		local color = qualityColor[self.quality]
		if color == nil then color = 'FFFFFF' end
	
		tooltip.title:update ({text = self.title, color = color})
	else
		tooltip.title:update ({text = self.title, color = self.titleColor})
	end
	
	local width = tooltip.title:GetWidth() + 10
	local height = 70
		
	if self.bop == nil and self.account == nil and self.bound == nil then
		height = height - 16
		tooltip.bop:SetVisible(false)
		tooltip.subTitle:update({ anchors = {{from = "TOPLEFT", object = tooltip:getElement(true), to = "TOPLEFT", x = 5, y = 22}} })
		tooltip.subValue:update({ anchors = {{from = "TOPRIGHT", object = tooltip:getElement(true), to = "TOPRIGHT", x = -5, y = 22 }} })
	else
		tooltip.bop:SetVisible(true)
		if self.account == true then
			tooltip.bop:update({ text = nkGenie.langTexts.account})
		elseif self.bound == true then
			tooltip.bop:update({ text = nkGenie.langTexts.bound})
		else
			tooltip.bop:update({ text = nkGenie.langTexts.bop})
		end
		
		local tempwidth = tooltip.bop:GetWidth()
		if tempwidth > width then width = tempwidth end
		
		tooltip.subTitle:update({ anchors = {{from = "TOPLEFT", object = tooltip:getElement(true), to = "TOPLEFT", x = 5, y = 39}} })
		tooltip.subValue:update({ anchors = {{from = "TOPRIGHT", object = tooltip:getElement(true), to = "TOPRIGHT", x = -5, y = 39 }} })
	end
	
	if (self.subTitle == '' or self.subTitle == nil) and (self.subValue  == '' or self.subValue == nil) then
		height = height - 16
		tooltip.subTitle:SetVisible(false)
		tooltip.subValue:SetVisible(false)
		tooltip.lines[1]:update({ anchors = {{from = "TOPLEFT", object = tooltip.title:getElement(true), to = "BOTTOMLEFT", x = 0, y = 2}} })
	else	
		tooltip.subTitle:SetVisible(true)
		tooltip.subValue:SetVisible(true)
		tooltip.lines[1]:update({ anchors = {{from = "TOPLEFT", object = tooltip.subTitle:getElement(true), to = "BOTTOMLEFT", x = 0, y = 2}} })
		
		if self.subTitle == '' or self.subTitle == nil then self.subTitle = ' ' end
		tooltip.subTitle:update ({text = self.subTitle })
	
		tooltip.subValue:update ({text = self.subValue })
		local tempwidth = tooltip.subTitle:GetWidth() + tooltip.subValue:GetWidth() + 25
		if tempwidth > width then width = tempwidth end
	end
	
	local line = 1
	local addLine = false
	local lineText = ''
	local lineHeight
	local seperatorPos = nil
	
	if self.lines ~= nil then
		for k, v in pairs (self.lines) do
			local color = 'FFFFFF'
			if v.color ~= nil then color = v.color end				
			line, height, width = self:AddLine (line, v.text, v.width, v.height, self.fontsize, color, height, width)
		end
	end
	
	if self.onUseText ~= nil then
		line, height, width = self:AddLine (line, self.onUseText, 250, nil, self.fontsize, '34A637', height, width)
	end
	
	if self.onEquipText ~= nil then		
		line, height, width = self:AddLine (line, self.onEquipText, 250, nil, self.fontsize, 'FFFFFF', height, width)
	end
	
	if self.descText ~= nil then		
		line, height, width = self:AddLine (line, self.descText, 250, nil, self.fontsize, 'CCBF92', height, width)
	end
	
	if self.flavText ~= nil then		
		line, height, width = self:AddLine (line, '', 250, 8, self.fontsize, 'CCBF92', height, width)
		line, height, width = self:AddLine (line, self.flavText, 250, nil, self.fontsize, 'CCBF92', height, width)
	end
	
	if self.addInfoLines ~= nil then		
		if #self.addInfoLines > 0 then
			if line > 1 then seperatorPos = line-1 end
			for k, v in pairs (self.addInfoLines) do
				local color = 'FFFFFF'
				if v.color ~= nil then color = v.color end				
				line, height, width = self:AddLine (line, v.text, v.width, v.height, self.fontsize, color, height, width)
			end
		end
	end
	
	if (line-1) < #tooltip.lines then
		for idx = line, #tooltip.lines, 1 do
			tooltip.lines[idx]:SetVisible(false)
		end
	end
	
	local anchors = nil
	
	if self.anchors ~= nil then
		anchors = self.anchors
	elseif self.alignTo == nil then
		local mouseData = Inspect.Mouse()		
		anchors = {{ from = "TOPLEFT", object = UIParent, to = "TOPLEFT", x = mouseData.x, y = mouseData.y + 10 }}
	else
		anchors = {{ from = "TOPLEFT", object = self.alignTo, to = "TOPRIGHT", x = self.x, y = self.y }}
	end

	tooltip:getElement(false):ClearAll()
	tooltip:update ({ visible = true, width = width+10, height = height, anchors = anchors })	
	
	if self.parent ~= nil then tooltip:SetParent (self.parent) end
	
	if seperatorPos ~= nil then
		if tooltip.separator2 == nil then			
			tooltip.separator2 = UI.CreateFrame('nkExtFrame', self.name .. 'Seperator2', tooltip:getElement(true), { width = tooltip:GetWidth()-15, height = 1, color = { body = 'CCCCCC'}, anchors = {{from = "TOPLEFT", object = tooltip.lines[seperatorPos]:getElement(), to = "BOTTOMLEFT", x = 0, y = 4}} })
		else
			tooltip.separator2:update ({width = tooltip:GetWidth()-10, anchors = {{from = "TOPLEFT", object = tooltip.lines[seperatorPos]:getElement(), to = "BOTTOMLEFT", x = 0, y = 4}} })
			tooltip.separator2:SetVisible(true)
		end	
	else
		if tooltip.separator2 ~= nil then tooltip.separator2:SetVisible(false) end
	end
	
	if line == 1 then tooltip.separator:SetVisible (false) else tooltip.separator:SetVisible (true) end
	
end

function nkGenie.ExtItemTooltip:AddLine (lineNo, text, width, height, fontsize, color, tooltipHeight, toolTipWidth)

	local tooltip = self.element
	local tempHeight = height
	--if height == nil then tempHeight = 5 end
	
	if tooltip.lines[lineNo] == nil then
		local previousLine = tooltip.lines[lineNo-1]
		local line = UI.CreateFrame('nkExtText', self.name .. 'Line' .. lineNo, tooltip:getElement(true), { text = text, wordwrap = true, width = width, height = tempHeight, fontsize = fontsize, color = color, anchors = {{from = "TOPLEFT", object = previousLine:getElement(), to = "BOTTOMLEFT"}} })
		table.insert (tooltip.lines, line)
	else
		tooltip.lines[lineNo].height = nil
		tooltip.lines[lineNo].width = nil
		tooltip.lines[lineNo]:update({ text = text, wordwrap = true, color = color, width = width, height = height, visible = true })
	end

	if height == nil then 	
		height = tooltip.lines[lineNo].element:GetHeight() 
		tooltip.lines[lineNo]:update({ height = height })
	end
	
	if tooltip.lines[lineNo]:GetWidth() > toolTipWidth then toolTipWidth = tooltip.lines[lineNo]:GetWidth() end
	tooltipHeight = tooltipHeight + height
	lineNo = lineNo + 1
	
	return lineNo, tooltipHeight, toolTipWidth

end

function nkGenie.ExtItemTooltip:SetVisible(flag) self.element:SetVisible(flag) end
function nkGenie.ExtItemTooltip:getElement(flag) return self.element:getElement(falg) end