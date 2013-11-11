local addonInfo, privateVars = ...

function EnKai.ui.nkWindowModern(name, parent)

	local window = UI.CreateFrame("Frame", name, parent)
	local body = UI.CreateFrame("Frame", name .. '.body', window)
	local header = UI.CreateFrame("Frame", name .. ".header", window)
	local title = UI.CreateFrame("Text", name .. ".title", header)
	local closeIcon = UI.CreateFrame("Texture", name .. ".closeIcon", header)
	local arrow = UI.CreateFrame("Texture", name .. ".arrow", header)
	local moveCheckbox = EnKai.uiCreateFrame("nkCheckbox", name .. ".moveCheckbox", header)
		
	local autoHide = false
	local dragable = true
	local titleAlign = "center"
	local titleOffSet = 0
	local internalSetPoint = false
		
	window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 200, 0)
	window:SetWidth(100)
	window:SetHeight(100)
	
	header:SetPoint("TOPLEFT", window, "TOPLEFT")
	header:SetPoint("TOPRIGHT", window, "TOPRIGHT")
	header:SetHeight(20)
	header:SetBackgroundColor(0, 0, 0, 1)
	header:SetLayer(2)
	
	header:EventAttach(Event.UI.Input.Mouse.Left.Down, function (self)		
		if dragable == false then return end
		
		self.leftDown = true
		local mouse = Inspect.Mouse()
		
		self.originalXDiff = mouse.x - self:GetLeft()
		self.originalYDiff = mouse.y - self:GetTop()
		
		local left, top, right, bottom = window:GetBounds()
		
		--window:ClearAll()
		window:ClearPoint("TOPLEFT")
		window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", left, top)
		--window:SetWidth(right-left)
		--window:SetHeight(bottom-top)
	
	end, name .. ".header.Left.Down")
	
	header:EventAttach( Event.UI.Input.Mouse.Cursor.Move, function (self, _, x, y)	
		if self.leftDown ~= true then return end
		window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x - self.originalXDiff, y - self.originalYDiff)
	end, name .. ".header.Cursor.Move")
	
	header:EventAttach( Event.UI.Input.Mouse.Left.Up, function (self)	
		if self.leftDown ~= true then return end
	    self.leftDown = false
		window:ProcessMove()			   
	    EnKai.eventHandlers[name]["Moved"](window:GetLeft(), window:GetTop())
	end, name .. ".header.Left.Up")
	
	header:EventAttach( Event.UI.Input.Mouse.Left.Upoutside, function (self)
		if self.leftDown ~= true then return end
		self.leftDown = false
		window:ProcessMove()
		EnKai.eventHandlers[name]["Moved"](window:GetLeft(), window:GetTop())
	end	, name .. ".header.Left.Upoutside")
	
	header:EventAttach(Event.UI.Input.Mouse.Cursor.In, function (self)
		if autoHide == true then EnKai.fx.pauseEffect (name .. '.autohide' ) end					
		window:ShowContent(true)	
	end, name .. ".header.Mouse.Cursor.In")

	header:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function (self)
		if autoHide == true then EnKai.fx.updateTime (name .. '.autohide' ) end		
	end, name .. ".body.Mouse.Cursor.Out")

	title:SetPoint("CENTER", header, "CENTER")
	title:SetFontColor(0.925, 0.894, 0.741, 1)
	title:SetFontSize(16)
	
	closeIcon:SetPoint("CENTERRIGHT", header, "CENTERRIGHT", -10, 0)
	closeIcon:SetTextureAsync ("EnKai", "gfx/iconCancel.png")
	closeIcon:SetHeight(12)
	closeIcon:SetWidth(12)
	
	closeIcon:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		window:SetVisible(false)
		EnKai.eventHandlers[name]["Closed"]()
	end, name .. "-.closeIcon.Left.Click")

	arrow:SetVisible(false)	
	arrow:SetWidth(14)
	arrow:SetHeight(14)
	arrow:SetPoint("CENTERLEFT", header, "CENTERLEFT", 5, 0)
	arrow:SetTextureAsync("EnKai", "gfx/windowModernArrowRight.png")
	
	arrow:EventAttach( Event.UI.Input.Mouse.Left.Down, function (self, _, x, y)	
		if autoHide == true then
			window:SetAutoHide(false, 5)
			arrow:SetTextureAsync("EnKai", "gfx/windowModernArrowDown.png")
		else
			window:SetAutoHide(true, 5)
			arrow:SetTextureAsync("EnKai", "gfx/windowModernArrowRight.png")
		end
		
	end, name .. ".arrow.Mouse.Left.Down")
	
	moveCheckbox:SetVisible(false)
	moveCheckbox:SetBoxWidth(10)
	moveCheckbox:SetBoxHeight(10)
	moveCheckbox:SetWidth(10)	
	moveCheckbox:SetPoint("CENTERLEFT", arrow, "CENTERRIGHT", 5, 0)
	moveCheckbox:SetChecked(false)
	moveCheckbox:SetColor(0.925, 0.894, 0.741, 1)
	
	Command.Event.Attach(EnKai.events[name .. '.moveCheckbox'].CheckboxChanged, function (_, newValue)
		 dragable = newValue
		 EnKai.eventHandlers[name]["Dragable"](newValue)
	end, name .. '.moveCheckbox.CheckboxChanged')
			
	body:SetBackgroundColor(0, 0, 0, .5)
	body:SetPoint("TOPLEFT", window, "TOPLEFT", 0, 20)
	body:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT")
	body:SetLayer(1)

	function window:ProcessMove()
		if window:GetTop() + window:GetHeight() >= UIParent:GetHeight() then
	    	body:SetPoint("TOPLEFT", window, "TOPLEFT")
			body:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", 0, -20)
			header:ClearPoint("TOPLEFT")
			header:ClearPoint("TOPRIGHT")
			header:SetPoint("BOTTOMLEFT", window, "BOTTOMLEFT")
			header:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT")
			internalSetPoint = true
			window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", window:GetLeft(), UIParent:GetHeight()-window:GetHeight())
			internalSetPoint = false
			
	    else
	    	body:SetPoint("TOPLEFT", window, "TOPLEFT", 0, 20)
			body:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT")
			header:ClearPoint("BOTTOMLEFT")
			header:ClearPoint("BOTTOMRIGHT")
			header:SetPoint("TOPLEFT", window, "TOPLEFT")
			header:SetPoint("TOPRIGHT", window, "TOPRIGHT")
			if window:GetTop() < 0 then
				internalSetPoint = true 
				window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", window:GetLeft(), 0)
				internalSetPoint = false 
			end
	    end
	end
	
	function window:ShowMoveToggle(flag)
		moveCheckbox:SetVisible(flag)
	end
	
	function window:ShowAutoHideToggle(flag)
		arrow:SetVisible(flag)
	end

	function window:SetAutoHide(flag, duration)
		
		if flag == true then
			if autoHide == false then EnKai.fx.register (name .. '.autohide', body, { id = 'timedhide', duration = duration, callback = function() body:SetVisible(false) end  } ) end
		else
			if autoHide == true then EnKai.fx.cancel (name .. '.autohide' ) end
		end
		
		autoHide = flag
	end
	
	function window:SetDragable(flag)
		dragable = flag
		moveCheckbox:SetChecked(flag)
	end
	
	function window:GetContent() return body end
	function window:GetHeader() return header end
	
	function window:SetTitle(newTitle)
		title:ClearAll()
		title:SetText(newTitle)
		if title:GetWidth() > header:GetWidth() then title:SetWidth(header:GetWidth()) end
		
		if titleAlign == "center" then
			title:SetPoint("CENTER", header, "CENTER", titleOffSet, 0)
		elseif titleAlign == "left" then
			title:SetPoint("CENTERLEFT", header, "CENTERLEFT", titleOffSet, 0)
		else
			title:SetPoint("CENTERRIGHT", header, "CENTERRIGHT", titleOffSet, 0)
		end
	end
	
	function window:SetTitleAlign(newAlign, newOffSet)
		if newAlign == "center" or newAlign == "left" or newAlign == "right" then titleAlign = newAlign end
		if newOffSet ~= nil then titleOffSet = tonumber(newOffSet) end
		window:SetTitle(title:GetText())
	end

	function window:SetFontSize(newFontSize)
		title:SetFontSize(newFontSize)
		window:SetTitle(title:GetText())		
	end
	
	function window:ShowContent(flag)
		if flag == true and autoHide == true then
			EnKai.fx.updateTime (name .. '.autohide' )			
		end
		body:SetVisible(flag)
	end
	
	
	local oSetBackgroundColor = window.SetBackgroundColor
	
	function window:SetBackgroundColor(r,g,b,a)
		body:SetBackgroundColor(r,g,b,a)
	end
	
	local oSetWidth, oSetHeight, oSetPoint = window.SetWidth, window.SetHeight, window.SetPoint
		
	function window:SetWidth(newWidth)
		oSetWidth(self, newWidth)
		window:SetTitle(title:GetText())	
	end	
	
	function window:SetHeight(newHeight)
		oSetHeight(self, newHeight)
		if window:GetTop() + newHeight >= UIParent:GetHeight() then window:ProcessMove() end
	end
	
	function window:SetPoint(from, object, to, x, y)
	
		if x ~= nil then
			if x < 0 then x = 0 end
			if x + window:GetWidth() > UIParent:GetWidth() then x = UIParent:GetWidth() - window:GetWidth() end
		end
		
		if y ~= nil then
			if y < 0 then y = 0 end
		end

		if x ~= nil and y ~= nil then			
			oSetPoint(self, from, object, to, x, y)
		else
			oSetPoint(self, from, object, to)
		end
		
		if internalSetPoint == true then return end
		if window:GetTop() + window:GetHeight() >= UIParent:GetHeight() then window:ProcessMove() end
	end 
	
	EnKai.eventHandlers[name] = {}
	EnKai.events[name] = {}
	EnKai.eventHandlers[name]["Moved"], EnKai.events[name]["Moved"] = Utility.Event.Create(addonInfo.identifier, name .. "Moved")	
	EnKai.eventHandlers[name]["Closed"], EnKai.events[name]["Closed"] = Utility.Event.Create(addonInfo.identifier, name .. "Closed")
	EnKai.eventHandlers[name]["Dragable"], EnKai.events[name]["Dragable"] = Utility.Event.Create(addonInfo.identifier, name .. "Dragable")
	
	return window
end