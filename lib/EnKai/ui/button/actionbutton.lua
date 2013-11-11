local addonInfo, privateVars = ...

function EnKai.ui.nkActionButton(name, parent) 

	local button = UI.CreateFrame ('Frame', name, parent)	
	local border = UI.CreateFrame ('Texture', name .. 'border', button)
	local texture = UI.CreateFrame ('Texture', name .. 'texture', button)
	local tint = UI.CreateFrame ('Frame', name .. 'tint', button)
	
	local properties = {}

	function button:SetValue(property, value)
		properties[property] = value
	end
	
	function button:GetValue(property)
		return properties[property]
	end
	
	local scale = 1
	local dragable = false
	local tintColor = { 1, 0, 0, .2 }	
	
	button:SetWidth(48)
	button:SetHeight(48)
	
	border:SetTextureAsync ("EnKai", "gfx/actionButton.png")
	border:SetPoint("TOPLEFT", button, "TOPLEFT")
	border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT")
	border:SetLayer(1)
	
	texture:SetPoint("CENTER", button, "CENTER")
	texture:SetWidth(34)
	texture:SetHeight(34)
	texture:SetLayer(2)
	
	tint:SetPoint("TOPLEFT", texture, "TOPLEFT")
	tint:SetPoint("BOTTOMRIGHT", texture, "BOTTOMRIGHT")
	tint:SetLayer(3)
	tint:SetBackgroundColor(tintColor[1], tintColor[2], tintColor[3], tintColor[4])
	tint:SetVisible(false)
	
	function button:SetScale(newScale)
		scale = newScale
		
		button:SetWidth(48 * newScale)
		button:SetHeight(48 * newScale)
		
		texture:SetWidth(34 * newScale)
		texture:SetHeight(34 * newScale)
	end
	
	function button:SetTexture(addonName, path)
		texture:SetTextureAsync (addonName, path)
	end
	
	function button:SetDragable(flag)
		dragable = flag
	end
	
	function button:SetMacro(newMacro)
		button:SetSecureMode('restricted')
		button:EventMacroSet(Event.UI.Input.Mouse.Left.Click, newMacro)
	end
	
	function button:SetActiveState(flag)
		if flag == true then tint:SetVisible(false) else tint:SetVisible(true) end
	end
	
	local oSetPoint = button.SetPoint
	
	function button:SetPoint(from, object, to, x, y)
	
		if x ~= nil and y ~= nil then			
			oSetPoint(self, from, object, to, x, y)
		else
			oSetPoint(self, from, object, to)
		end
	end	
	
	button:EventAttach(Event.UI.Input.Mouse.Right.Down, function (self)		
		
		if dragable == false then return end
		if Inspect.System.Secure() == true then return end
		
		self.rightDown = true
		local mouse = Inspect.Mouse()
		
		self.originalXDiff = mouse.x - self:GetLeft()
		self.originalYDiff = mouse.y - self:GetTop()
		
		local left, top, right, bottom = button:GetBounds()
		
		button:ClearAll()
		button:SetPoint("TOPLEFT", UIParent, "TOPLEFT", left, top)
		button:SetWidth(right-left)
		button:SetHeight(bottom-top)
	
	end, name .. "button.Left.Down")
	
	button:EventAttach( Event.UI.Input.Mouse.Cursor.Move, function (self, _, x, y)	
		if self.rightDown ~= true then return end
		button:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x - self.originalXDiff, y - self.originalYDiff)
	end, name .. "button.Cursor.Move")
	
	button:EventAttach( Event.UI.Input.Mouse.Right.Up, function (self)	
	    self.rightDown = false
		EnKai.eventHandlers[name]["Moved"](button:GetLeft(), button:GetTop())
	end, name .. "button.Left.Up")
	
	button:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		if dragable == true then return end
		EnKai.eventHandlers[name]["Clicked"]()
	end, name .. "_Left_Click")

	EnKai.eventHandlers[name] = {}
	EnKai.events[name] = {}
	EnKai.eventHandlers[name]["Clicked"], EnKai.events[name]["Clicked"] = Utility.Event.Create(addonInfo.identifier, name .. "Clicked")
	EnKai.eventHandlers[name]["Moved"], EnKai.events[name]["Moved"] = Utility.Event.Create(addonInfo.identifier, name .. "Moved")
		
	return button
	
end