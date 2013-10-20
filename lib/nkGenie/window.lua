function nkGenie.ExtWindow:new(name, parent, settings) 

	if settings == nil then return nil end
	
	if parent == nil then parent = nkGenie.context end
	
	local this = settings
	this.name = name
	this.parent = parent
	
	if this.template ~= nil then
		for k, value in pairs (this.template) do
			if this[k] == nil then this[k] = value end
		end
		this.template = nil
	end	

	if this.fontsize == nil then this.fontsize = 14 end
	if this.collapsed == nil then this.collapsed = false end
		
	local window = UI.CreateFrame('nkExtFrame', name .. 'main', parent, { layer = layer, visible = this.visible, width = this.width, height = this.height, anchors = this.anchors, color = { settings.color.alpha } })
		
	window.header = UI.CreateFrame('nkExtFrame', name .. 'header', window:getElement(), { layer = 1, height = this.fontsize*2+2, color = {border = this.color.border, body = this.color.header}, anchors = {{from = "TOPLEFT", object = window:getElement(), to = "TOPLEFT"}, {from = "TOPRIGHT", object = window:getElement(), to ="TOPRIGHT"}} })
	window.headerTitle = UI.CreateFrame('nkExtText', name .. 'hederTitle', window.header:getElement(), {text = this.title, fontsize = this.fontsize, color = this.color.title, anchors = {{ from = "CENTERLEFT", object = window.header:getElement(), to = "CENTERLEFT", x = 10, y = 0}}})
	
	if this.footer ~= nil then
		window.footer = UI.CreateFrame('nkExtFrame', name .. 'footer', window:getElement(), { layer = 1, width = this.width, height = this.fontsize*2+2, color = {border = this.color.border, body = this.color.footer}, anchors = {{from = "BOTTOMLEFT", object = window:getElement(), to = "BOTTOMLEFT"}} })
		window.footerTitle = UI.CreateFrame('nkExtText', name .. 'footerTitle', window.footer:getElement(), { text = this.footer, fontsize = this.fontsize, color = this.color.title, anchors = {{ from = "CENTERLEFT", object = window.footer:getElement(), to = "CENTERLEFT", x = 10, y = 0}}})
		window.body = UI.CreateFrame('nkExtFrame', name .. 'body', window:getElement(false), { layer = 2, color = {border = this.color.border, body = this.color.body}, anchors={{from = "TOPLEFT", object = window.header:getElement(false), to = "BOTTOMLEFT", x = 0, y = -1}, {from = "BOTTOMRIGHT", object = window.footer:getElement(false), to = "TOPRIGHT", x=0, y=1}}})
		
		window.footer:SetEvent ('LeftClick', function () end )
	else
		window.body = UI.CreateFrame('nkExtFrame', name .. 'body', window:getElement(false), { layer = 2, color = {border = this.color.border, body = this.color.body}, anchors={{from = "TOPLEFT", object = window.header:getElement(false), to = "BOTTOMLEFT", x = 0, y = -1}, {from = "BOTTOMRIGHT", object = window:getElement(), to = "BOTTOMRIGHT"}}})
	end
	
	window.body:SetEvent ('LeftClick', function () end )
	
	if this.closeable == true then		
		window.closeBox = UI.CreateFrame("nkExtFrame", name .. 'close', window.header:getElement(), { width = window.header:getElement(true):GetHeight()-8, height = window.header:getElement(true):GetHeight()-8, color = { border = this.color.border, body = this.color.header}, anchors = {{from = "TOPRIGHT", object = window.header:getElement(true), to = "TOPRIGHT", x=-4,y=4}}})
		window.closeBoxX = UI.CreateFrame("nkExtText", name .. 'closeX', window.closeBox:getElement(true), { text = "X", fontsize = this.fontsize, color = this.color.border, anchors = {{ from = "CENTER", object = window.closeBox:getElement(true), to = "CENTER"}}})
		
		if this.closeFunc ~= nil then
			window.closeBox:SetEvent('LeftClick', function() window:update( { visible = false} ); this.closeFunc() end )
		else
			window.closeBox:SetEvent('LeftClick', function() window:update({ visible = false} ) end )
		end
	end
	
	if this.collapsible == true then
		if this.closeable == true then
			window.collapseBox = UI.CreateFrame('nkExtFrame', name .. 'collapse', window.header:getElement(), { width = window.header:getElement(true):GetHeight()-8, height = window.header:getElement(true):GetHeight()-8, color = { border = this.color.border, body = this.color.header}, anchors = {{from = "TOPRIGHT", object = window.closeBox:getElement(false), to = "TOPLEFT", x=-4,y=0}}})
		else
			window.collapseBox = UI.CreateFrame('nkExtFrame', name .. 'collapse', window.header:getElement(), { width = window.header:getElement(true):GetHeight()-8, height = window.header:getElement(true):GetHeight()-8, color = { border = this.color.border, body = this.color.header}, anchors = {{from = "TOPRIGHT", object = window.header:getElement(), to = "TOPRIGHT", x=-4,y=4}}})		
		end

		local collapseChar = '\94'
		if this.collapsed == true then collapseChar = 'v' end
				
		window.collapseBoxSign = UI.CreateFrame('nkExtText', name .. 'collpaseSign', window.collapseBox:getElement(), { text = collapseChar, fontsize = this.fontsize, color = this.color.border, anchors = {{ from = "CENTER", object = window.collapseBox:getElement(), to = "CENTER"}}, callBack = function () end})		
		
		window.collapseBox:SetEvent("LeftClick", function ()
			if this.collapsed == true then 
				if window.footer ~= nil then window.footer:SetVisible(true) end
				window.body:SetVisible(true)
				this.collapsed = false
				window.collapseBoxSign:update ({ text = '\94' })
				local thisElement = window:getElement(false)
			else
				if window.footer ~= nil then window.footer:SetVisible(false) end
				window.body:SetVisible(false)				
				this.collapsed = true
				window.collapseBoxSign:update ({ text = 'v' })
			end
		end )
	end
	
	if this.dragable == true then
		window.header:SetEvent('LeftDown', function(frame)
				frame.MouseDown = true
				mouseData = Inspect.Mouse()
				if this.anchors[1].x == nil then this.anchors[1].x = 0 end
				if this.anchors[1].y == nil then this.anchors[1].y = 0 end
				
				frame.startX = mouseData.x - this.anchors[1].x
				frame.startY = mouseData.y - this.anchors[1].y
			end)
			
		window.header:SetEvent('MouseMove', function(frame)
				if frame.MouseDown then
					mouseData = Inspect.Mouse()
					curdivX = mouseData.x - frame.startX
					curdivY = mouseData.y - frame.startY
					this.anchors[1].x = curdivX
					this.anchors[1].y = curdivY
					window:update({ anchors = {{ from = this.anchors[1].from, object = this.anchors[1].object, to = this.anchors[1].to, x = curdivX, y = curdivY }} })
					if this.dragfunc ~= nil then this.dragfunc (frame:GetLeft(), frame:GetTop()) end
				end
			end)
		
		window.header:SetEvent('LeftUp', function(frame)  if frame.MouseDown then frame.MouseDown = false end end)
	end
	
	this.window = window
	setmetatable(this, self)
	self.__index = self
	return this

end

function nkGenie.ExtWindow:update(settings)

	if settings == nil then return end
	if settings.template ~= nil then
		for k, v in pairs (settings.template) do if settings[k] == nil then settings[k] = v end end
		settings.template = nil
	end	
	
	if settings.visible ~= nil then self.window:getElement():SetVisible(settings.visible) end
	if settings.layer ~= nil then self.window:getElement():SetLayer(settings.layer) end
	
	if settings.height ~= nil then self.window:update({ height = settings.height }) end
	if settings.width ~= nil then self.window:update({ width = settings.width }) end
	
	for k, v in pairs (settings) do self[k] = v end

end

function nkGenie.ExtWindow:getFooter (innerFlag)

	if self.window.footer == nil then return nil end
	return self.window.footer:getElement(innerFlag)

end

function nkGenie.ExtWindow:collapse(flag)

	local visibility = true
	if flag == true then visibility = false end

	if self:getFooter() ~= nil then self:getFooter(false):SetVisible(visibility) end
	self:getBody(false):SetVisible(visibility)
	self.collapsed = flag
	
	if flag == false then	
		self.window.collapseBoxSign:update ({ text = '\94' })
	else
		self.window.collapseBoxSign:update ({ text = 'v' })
	end
	
end

function nkGenie.ExtWindow:getInternal(element)
	
	if element == 'body' then
		return self.window.body
	elseif element == 'header' then
		return self.window.header
	elseif element == 'footer' then
		return self.window.footer
	end
end

function nkGenie.ExtWindow:getElement() return self.window:getElement() end
function nkGenie.ExtWindow:getBody(innerFlag) return self.window.body:getElement(innerFlag) end
function nkGenie.ExtWindow:getHeader(innerFlag) return self.window.header:getElement(innerFlag) end
function nkGenie.ExtWindow:getHeaderTitle() return self.window.headerTitle:getElement() end
function nkGenie.ExtWindow:isVisible () return self.window:getElement():GetVisible() end
function nkGenie.ExtWindow:SetVisible (flag) self.window:SetVisible(flag) end
function nkGenie.ExtWindow:SetStrata(strata) self:getElement():SetStrata(strata) end

function nkGenie.ExtRiftWindow:new (name, parent, settings)

	if settings == nil then return nil end
	
	if parent == nil then parent = nkGenie.context end
	
	local this = settings
	this.name = name
	this.parent = parent
	
	if this.template ~= nil then
		for k, value in pairs (this.template) do
			if this[k] == nil then this[k] = value end
		end
		this.template = nil
	end	

	local window = UI.CreateFrame('RiftWindow', name, parent)
	window:SetTitle (this.title)
	
	window.dragFrame = UI.CreateFrame ('nkExtFrame', name .. 'dragFrame', window)	
		
	this.window = window
	setmetatable(this, self)
	self.__index = self
	return this

end

function nkGenie.ExtRiftWindow:update (settings)

	if settings.width ~= nil then self.window:SetWidth(settings.width) end
	if settings.height ~= nil then self.window:SetHeight(settings.height) end

	if settings.dragable == true then		
		self.window.dragFrame:update ({ width = self.window:GetWidth() - 200, height = 30, anchors = {{ from = "TOPCENTER", object = self.window, to = "TOPCENTER", x = 0, y = 15 }}})
	
		self.window.dragFrame:SetEvent('LeftDown', function(frame)
				frame.MouseDown = true
				mouseData = Inspect.Mouse()
				if self.anchors[1].x == nil then self.anchors[1].x = 0 end
				if self.anchors[1].y == nil then self.anchors[1].y = 0 end
				
				frame.startX = mouseData.x - self.anchors[1].x
				frame.startY = mouseData.y - self.anchors[1].y
			end)
			
		self.window.dragFrame:SetEvent('MouseMove', function(frame)
				if frame.MouseDown then
					mouseData = Inspect.Mouse()
					curdivX = mouseData.x - frame.startX
					curdivY = mouseData.y - frame.startY
					self.anchors[1].x = curdivX
					self.anchors[1].y = curdivY
					self:update({ anchors = {{ from = self.anchors[1].from, object = self.anchors[1].object, to = self.anchors[1].to, x = curdivX, y = curdivY }} })
					if self.dragfunc ~= nil then self.dragfunc (frame:GetLeft(), frame:GetTop()) end
				end
			end)
		
		self.window.dragFrame:SetEvent('LeftUp', function(frame)  if frame.MouseDown then frame.MouseDown = false end end)	
	end

	if settings.dragable ~= true and self.dragable ~= true then
		self.window.dragFrame:SetVisible(false)
	else
		self.window.dragFrame:SetVisible(true)
	end	
	
	if settings.closeable == true then		
		if self.window.closeButton == nil then
			self.window.closeButton = UI.CreateFrame('nkExtTexture', self.name .. 'close', self.window, {type = 'nkGenie', path = 'gfx/btnClose.png', width = 28, height = 28, anchors = {{ from = "TOPRIGHT", object = self.window, to = "TOPRIGHT", x = -12, y = 18 }} })
		end
		
		if settings.closeFunc ~= nil then
			self.window.closeButton:SetEvent('LeftClick', function() self:update( { visible = false} ); settings.closeFunc() end )
		else
			self.window.closeButton:SetEvent('LeftClick', function() self:update({ visible = false} ) end )
		end
	end
	
	if settings.anchors ~= nil then
		for k, anchor in pairs(settings.anchors) do
			if anchor.x ~= nil and anchor.y ~= nil then
				self.window:SetPoint (anchor.from, anchor.object, anchor.to, anchor.x, anchor.y)
			else
				self.window:SetPoint (anchor.from, anchor.object, anchor.to)
			end
		end
	end
	
	if settings.layer ~= nil then self.window:SetLayer(settings.layer) end
	if settings.strata ~= nil then self.window:SetStrata(settings.strata) end
	if settings.visible ~= nil then self.window:SetVisible(settings.visible) end
	
	for k, v in pairs (settings) do self[k] = v end

end

function nkGenie.ExtRiftWindow:getElement() return self.window end
function nkGenie.ExtRiftWindow:SetVisible(flag) self.window:SetVisible(flag) end
function nkGenie.ExtRiftWindow:getBody() return self.window:GetContent() end
function nkGenie.ExtRiftWindow:isVisible () return self.window:GetVisible() end
function nkGenie.ExtRiftWindow:SetStrata(strata) self:getElement():SetStrata(strata) end