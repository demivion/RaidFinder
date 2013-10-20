local addonInfo, privateVars = ...

function EnKai.ui.nkWindow(name, parent) 

	local window = UI.CreateFrame('RiftWindow', name, parent)
	local dragFrame = UI.CreateFrame ('Frame', name .. 'dragFrame', window:GetBorder())	
	local btClose = UI.CreateFrame("RiftButton", name .. ".btClose", window)
	
	local properties = {}

	function window:SetValue(property, value)
		properties[property] = value
	end
	
	function window:GetValue(property)
		return properties[property]
	end
	
	local allowSecureClose = true

	window:SetValue("name", name)
	window:SetValue("parent", parent)
	
	dragFrame:SetPoint ("TOPLEFT", window, "TOPLEFT", 0, 0)
	dragFrame:SetHeight(60)
	dragFrame:SetWidth(100)	
	dragFrame:SetVisible(false)
	
	dragFrame:EventAttach(Event.UI.Input.Mouse.Left.Down, function (self)		
		
		self.leftDown = true
		local mouse = Inspect.Mouse()
		
		self.originalXDiff = mouse.x - self:GetLeft()
		self.originalYDiff = mouse.y - self:GetTop()
		
		local left, top, right, bottom = window:GetBounds()
		
		window:ClearAll()
		window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", left, top)
		window:SetWidth(right-left)
		window:SetHeight(bottom-top)
	
	end, name .. "dragFrame.Left.Down")
	
	dragFrame:EventAttach( Event.UI.Input.Mouse.Cursor.Move, function (self, _, x, y)	
		if self.leftDown ~= true then return end
		window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x - self.originalXDiff, y - self.originalYDiff)
	end, name .. "dragFrame.Cursor.Move")
	
	dragFrame:EventAttach( Event.UI.Input.Mouse.Left.Up, function (self)	
	    self.leftDown = false
	end, name .. "dragFrame.Left.Up")
	
	btClose:SetSkin("close")
	btClose:SetPoint("TOPRIGHT", window, "TOPRIGHT", -8, 15)
	
	btClose:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		if Inspect.System.Secure() == false or allowSecureClose == true then window:SetVisible(false) end
	end, name .. "btClose.Left.Click")

	function window:SetDragable (flag)
		dragFrame:SetVisible(flag)
	end
	
	function window:SetCloseable (flag)
		btClose:SetVisible(flag)
	end
	
	function window:PreventSecureClose(flag)
		if flag == true then allowSecureClose = false else allowSecureClose = true end
	end
		
	local oSetWidth, oSetHeight = window.SetWidth, window.SetHeight
	
	function window:SetWidth(width)
		oSetWidth(self, width)
		dragFrame:SetWidth(width)
	end
	
	
	return window
	
end