function nkGenie.ExtTabPane:new (name, parent, settings)

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
	
	if this.activePane == nil then this.activePane = 1 end
	if this.fontsize == nil then this.fontsize = 14 end
	
	local width, height = 0, 0
	local headerWidth, headerHeight = 0, this.headerHeight
	local anchors = nil
	
	if this.orientation == 'vertical' then
		if this.headerTextureWidth ~= nil then		
			width = this.width - this.headerTextureWidth
		else
			width = this.width - this.headerWidth + 1
		end
		
		height = this.height		
		headerWidth = this.headerWidth
	else
		width = this.width
		height = (this.height-(this.fontsize * 2 + 1))
		if this.headerWidth == nil then headerWidth = 150 else headerWidth = this.headerWidth end
	end

	if this.headerHeight == nil then
		headerHeight = this.fontsize * 2 + 2
	end
	
	if this.bodyOffsetX ~= nil then width = width - this.bodyOffsetX end

	local element = UI.CreateFrame ('nkExtFrame', name, parent, { width = this.width, height = this.height, anchors = this.anchors })
	
	if this.bodyTexture ~= nil then
		element.body = UI.CreateFrame('nkExtTexture', name .. 'bodyTexture', element:getElement(), {type = this.paneTextureAddon, path = this.bodyTexture, width = width, height = height, anchors = {{from = "BOTTOMRIGHT", object = element:getElement(), to ="BOTTOMRIGHT"}}})
	else
		element.body = UI.CreateFrame ('nkExtFrame', name .. 'body', element:getElement(), { color = {border = this.color.border, body = this.color.body}, width = width, height = height, anchors = {{from = "BOTTOMRIGHT", object = element:getElement(), to ="BOTTOMRIGHT"}}})
	end

	local lastObject = element:getElement()
	local headerParent = element.body:getElement(true)
	local lastObjectTo = "TOPLEFT"
	local lastObjectX, lastObjectY = 0, 0
	
	if this.headerOffsetX ~= nil then lastObjectX = this.headerOffsetX end
	if this.headerOffsetY ~= nil then lastObjectY = this.headerOffsetY end	
	
	local index = 1
	
	if this.headerTexture ~= nil then		
		element.headerBG = UI.CreateFrame('nkExtTexture', name .. 'bodyTexture', element.body:getElement(), {type = this.paneTextureAddon, path = this.headerTexture, width = this.headerTextureWidth, height = this.headerTextureHeight, anchors = {{from = lastObjectTo, object = lastObject, to =lastObjectTo}}})	
		headerParent = element.headerBG:getElement()
	end
	
	this.header = {}
	
	for k, pane in pairs(this.panes) do	
	
		local layer = 1
		if settings.contentLayer ~= nil then layer = settings.contentLayer end
		
		pane.content:update ({ visible = false, layer = layer })
		local thisName = name .. 'header' .. k		
				
		local header = nil
		
		if this.paneTextureAddon ~= nil then
			header = UI.CreateFrame('nkExtTexture', thisName, headerParent, {layer = 1, type = this.paneTextureAddon, path = this.paneTextureInactive, width = headerWidth, height = headerHeight, anchors = {{from = "TOPLEFT", object = lastObject, to = lastObjectTo, x = lastObjectX, y = lastObjectY }}})					
		else
			header = UI.CreateFrame ('nkExtFrame', thisName, headerParent, { layer = 1, color = {border = this.color.border, body = this.color.inactive}, width = headerWidth, height = headerHeight, anchors = {{from = "TOPLEFT", object = lastObject, to = lastObjectTo, x = lastObjectX, y = lastObjectY }}})
		end
		
		header.label = UI.CreateFrame ('nkExtText', thisName .. 'label', headerParent, { layer = 2, fontsize = this.fontsize, text = pane.label, color = this.color.label, anchors = {{from = "CENTER", object = header:getElement(true), to = "CENTER" , x = -1, y = 0}} })
		
		local lineAnchor = {{from = "BOTTOMLEFT", object = header:getElement(false), to = "BOTTOMLEFT", x=1, y=0 }}
		local lineWidth, lineHeight = headerWidth -2, 1
		
		if this.orientation == 'vertical' then
			lineAnchor = {{from = "TOPRIGHT", object = header:getElement(false), to = "TOPRIGHT", x = 0, y = 1 }}
			lineWidth, lineHeight = 1, headerHeight-2
		end
		
		if this.paneTextureAddon == nil then
			header.line = UI.CreateFrame ('nkExtFrame', thisName .. 'line', header:getElement(true), { color = {body = this.color.body}, width = lineWidth, height = lineHeight, visible = false, anchors = lineAnchor})
		end
		
		pane.content:update( {anchors = {{ from = "TOPLEFT", object = element.body:getElement(), to = "TOPLEFT" }, { from = "BOTTOMRIGHT", object = element.body:getElement(), to = "BOTTOMRIGHT"}} })
		
		local body = header:getElement()
		body.paneNo = index
		
		if this.paneTextureActive ~= nil then
			function body.Event:MouseIn()
				header:SetTexture ({ type = this.paneTextureAddon, path = this.paneTextureActive })
				--header.label:update ({ text = pane.label })				
			end
			
			function body.Event:MouseOut()
				if this.activePane ~= self.paneNo then
					header:SetTexture ({ type = this.paneTextureAddon, path = this.paneTextureInactive })
					--header.label:update ({ text = pane.label })
				end
			end
		end

		
		function body.Event:LeftClick()
			this.header[this.activePane]:update({ color = {body = this.color.inactive, border = this.color.border} })
			if this.header[this.activePane].line ~= nil then this.header[this.activePane].line:update({ visible = false }) end
			this.panes[this.activePane].content:update ({visible = false })
			
			this.activePane=self.paneNo
			
			this.header[this.activePane]:update({ color = {body = this.color.body, border = this.color.border} })
			if this.header[this.activePane].line ~= nil then this.header[this.activePane].line:update({ visible = true }) end
			
			if this.panes[this.activePane].initFunc ~= nil then
				if this.panes[this.activePane].initialized ~= true then
					this.panes[this.activePane].initFunc()
					this.panes[this.activePane].initialized = true
				end
			end
			
			if this.panes[this.activePane].switchFunc ~= nil then this.panes[this.activePane].switchFunc() end
			
			this.panes[this.activePane].content:update ({visible = true })			
			
			if this.paneTextureActive ~= nil then
				for k, v in pairs (this.header) do
					v:SetTexture ({ type = this.paneTextureAddon, path = this.paneTextureInactive })
				end
			
				header:SetTexture ({ type = this.paneTextureAddon, path = this.paneTextureActive })
				header.label:update ({ text = pane.label })
			end
		end
		
		lastObjectTo = "TOPRIGHT"
		lastObjectX, lastObjectY = -1, 0
		lastObject = header:getElement(false)
		
		if this.headerOffsetX ~= nil then lastObjectX = this.headerOffsetX end
		
		if this.orientation == 'vertical' then
			lastObjectTo = "BOTTOMLEFT"
			lastObjectX, lastObjectY = 0, -1
			if this.paneTextureAddon ~= nil then lastObjectY = 4 end
		end		
	
		table.insert(this.header, header)
		index = index + 1
	end
	
	if this.panes[1].initFunc ~= nil then 
		this.panes[1].initFunc() 
		this.panes[1].initialized = true
	end
	
	this.header[1]:update({ color = {body = this.color.body, border = this.color.border} })
	if this.header[1].line ~= nil then this.header[1].line:update({ visible = true }) end
	if this.paneTextureActive ~= nil then this.header[1]:SetTexture ({ type = this.paneTextureAddon, path = this.paneTextureActive }) end
	this.panes[1].content:update ({visible = true })

	this.element = element
	
	setmetatable(this, self)
	self.__index = self
	return this

end

function nkGenie.ExtTabPane:update () end
function nkGenie.ExtTabPane:getBody (innerFlag) return self.element.body:getElement(innerFlag) end
function nkGenie.ExtTabPane:getActivePane() return self.activePane end