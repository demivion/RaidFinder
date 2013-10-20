local addonInfo, privateVars = ...

if not EnKai then EnKai = {} end
if not EnKai.manager then EnKai.manager = {} end
				
privateVars.manager = {}										
			
privateVars.manager.context = UI.CreateContext("nkButton")
privateVars.manager.context:SetSecureMode('restricted')

function EnKai.manager.init(addonName, subMenuItems, mainFunc)

	if EnKai.manager.button == nil then 
		EnKai.manager.button = privateVars.manager.addonButton() 
		Command.Event.Attach(Event.System.Secure.Enter, EnKai.manager.secureEnter, "nkManager.Ssytem.Secure.Enter")
	end	
	
	if addonName ~= nil then EnKai.manager.button:AddAddon (addonName, subMenuItems, mainFunc) end

end

function EnKai.manager.secureEnter()
	EnKai.manager.button:CloseAllMenus ()
end

function privateVars.manager.addonButton()

	local button = UI.CreateFrame ('Texture', 'nkButton', privateVars.manager.context)
		
	button:SetTextureAsync('EnKai', 'manager/nkButton.png')
	button:SetWidth(35)
	button:SetHeight(34)
	button:SetPoint ("TOPRIGHT", UIParent, "TOPRIGHT", EnKaiSetup.mmButtonX, EnKaiSetup.mmButtonY)
	button:SetSecureMode('restricted')
	
	local menu = EnKai.uiCreateFrame("nkMenu", 'EnKai.managerMenu', button)
		
	menu:SetFontSize(13)
	menu:SetWidth(120)
	menu:SetBackgroundColor(0.208, 0.208, 0.208, 1)
	menu:SetLabelColor(1, 1, 1, 1)
	menu:SetBorderColor(0, 0, 0, 1)
	menu:SetPoint("TOPRIGHT", button, "CENTER", -10, 0)
	menu:SetVisible(false)
	
	local items = {}
	local subMenus
	
	button:EventAttach(Event.UI.Input.Mouse.Left.Click, function (self)
		if Inspect.System.Secure() == false then
			if menu:GetVisible() == true then 
				menu:SetVisible(false) 
				button:CloseAllMenus()
			elseif menu:GetEntryCount() > 0 then
				menu:SetVisible(true) 
			end
		end
	end, "EnKai.manager.Left.Click")	
		
	function button:AddAddon(addonName, subMenuItems, mainFunc)

		if subMenuItems == nil then
			menu:AddEntry ({ closeOnClick = true, label = addonName, callBack = function () button:CloseAllMenus(); mainFunc() end })
		else
			
			local newSubMenu = EnKai.uiCreateFrame("nkMenu", 'EnKai.managerMenu' .. addonName, button)
			newSubMenu:SetFontSize(13)
			newSubMenu:SetWidth(100)
			newSubMenu:SetBackgroundColor(0.208, 0.208, 0.208, 1)
			newSubMenu:SetLabelColor(1, 1, 1, 1)
			newSubMenu:SetBorderColor(0, 0, 0, 1)
			newSubMenu:SetVisible(false)
			
			local showSubMenu = function ()
				for k, v in pairs (subMenus) do v:SetVisible(false) end
				
				if newSubMenu:GetVisible() == true then 
					newSubMenu:SetVisible(false) 
				elseif newSubMenu:GetEntryCount() > 0 then
					newSubMenu:SetVisible(true) 
				end 
			end
			
			for k, v in pairs(subMenuItems) do				
				if v.seperator == true then
					newSubMenu:AddSeparator()					
				elseif v.callBack ~= nil then
					newSubMenu:AddEntry({ closeOnClick = true, label = v.label, macro = v.macro, callBack = function() button:CloseAllMenus(); v.callBack() end })
				else
					newSubMenu:AddEntry({ closeOnClick = true, label = v.label, macro = v.macro, callBack = function() button:CloseAllMenus() end })
				end
			end
						
			local mainMenuItems = menu:GetEntries()
			
			if #mainMenuItems > 0 then
				newSubMenu:SetPoint("TOPRIGHT", mainMenuItems[#mainMenuItems], "TOPLEFT", 0, 18)
			else
				newSubMenu:SetPoint("TOPRIGHT", menu, "TOPLEFT")
			end
			
			if subMenus == nil then subMenus = {} end
			table.insert(subMenus, newSubMenu)
			
			menu:AddEntry ( { subMenu = true, label = addonName, callBack = function () showSubMenu() end } )
		end	
		
	end	
	
	function button:CloseAllMenus ()
		if subMenus ~= nil then
			for k, v in pairs (subMenus) do
				v:SetVisible(false)
			end
		end
		menu:SetVisible(false)
	end
	
	function button:ToggleMenu()
		if menu:GetVisible() == true then 
			menu:SetVisible(false) 
		elseif menu:GetEntryCount() > 0 then
			menu:SetVisible(true) 
		end 
	end
	
	button:EventAttach(Event.UI.Input.Mouse.Right.Down, function (self)
		if Inspect.System.Secure() == true then return end
		privateVars.manager.rightDown = true
		local mouseData = Inspect.Mouse()
		privateVars.manager.startX, privateVars.manager.startY = mouseData.x, mouseData.y
		
	end, "EnKai.manager.Right.Down")	
	
	button:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function(self, _, x, y)
		if privateVars.manager.rightDown ~= true then return end
		
		local curdivX = x - privateVars.manager.startX
		local curdivY = y - privateVars.manager.startY
		
		button:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", EnKaiSetup.mmButtonX + curdivX, EnKaiSetup.mmButtonY + curdivY )
	end, "EnKai.manager.Mouse.Cursor.Move")	
	
	button:EventAttach(Event.UI.Input.Mouse.Right.Up, function(self, _)	
		if privateVars.manager.rightDown ~= true then return end
		
		privateVars.manager.rightDown = false
		
		if privateVars.manager.startX == nil or privateVars.manager.startY == nil then return end
				
		local mouseData = Inspect.Mouse()
		local curdivX = mouseData.x - privateVars.manager.startX
		local curdivY = mouseData.y - privateVars.manager.startY	
			
		EnKaiSetup.mmButtonX = EnKaiSetup.mmButtonX + curdivX
		EnKaiSetup.mmButtonY = EnKaiSetup.mmButtonY + curdivY
		

	end, "EnKai.manager.Right.Up")	
	
	button:EventAttach(Event.UI.Input.Mouse.Right.Upoutside, function(self)
		if privateVars.manager.rightDown ~= true then return end
		
		privateVars.manager.rightDown = false
		
		local mouseData = Inspect.Mouse()
		local curdivX = mouseData.x - privateVars.manager.startX
		local curdivY = mouseData.y - privateVars.manager.startY	
			
		EnKaiSetup.mmButtonX = EnKaiSetup.mmButtonX + curdivX
		EnKaiSetup.mmButtonY = EnKaiSetup.mmButtonY + curdivY
	end, "EnKai.manager.Right.Upoutside")	
	
	return button
	
end