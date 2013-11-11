local addonInfo, privateVars = ...

if not EnKai then EnKai = {} end
if not EnKai.ui then EnKai.ui = {} end

privateVars.ui = {}
privateVars.ui.context = UI.CreateContext("EnKai.ui")

privateVars.gc = {}
privateVars.free = {}

function EnKai.uiCreateFrame (frameType, name, parent)

	if frameType == nil or name == nil or parent == nil then
		EnKai.tools.error.display (addonInfo.identifier, string.format("EnKai.uiCreateFrame - invalid number of parameters\nexpecting: type of frame (string), name of frame (string), parent of frame (string)\nreceived: %s, %s, %s", frameType, name, parent))
		return
	end

	local uiObject = nil

	local checkFrameType = string.upper(frameType) 

-- the below is a prototype to frame resuing
-- missing SetName() on frames to fully build this
	
--	if privateVars.free[checkFrameType] ~= nil and #privateVars.free[checkFrameType] > 0 then
--		uiObject = privateVars.free[checkFrameType][1]
--		uiObject:SetParent(parent)
--		--uiObject:SetName(name)
--		
--		table.remove(privateVars.free[checkFrameType], 1)
--	else

--		if checkFrameType == 'NKFRAME' then
--			uiObject = EnKai.ui.nkFrame(name, parent)
		if checkFrameType == 'NKACTIONBUTTON' then
			uiObject = EnKai.ui.nkActionButton(name, parent)
		elseif checkFrameType == 'NKBUTTON' then
			uiObject = EnKai.ui.nkButton(name, parent)
		elseif checkFrameType == 'NKCHECKBOX' then
			uiObject = EnKai.ui.nkCheckbox(name, parent)
		elseif checkFrameType == 'NKCOMBOBOX' then
			uiObject = EnKai.ui.nkCombobox(name, parent)
		elseif checkFrameType == 'NKDIALOG' then
			uiObject = EnKai.ui.nkDialog(name, parent)
		elseif checkFrameType == 'NKGRID' then
			uiObject = EnKai.ui.nkGrid(name, parent)
		elseif checkFrameType == 'NKGRIDCELL' then
			uiObject = EnKai.ui.nkGridCell(name, parent)
		elseif checkFrameType == 'NKGRIDHEADERCELL' then
			uiObject = EnKai.ui.nkGridHeaderCell(name, parent)
		elseif checkFrameType == 'NKIMAGEGALLERY' then	
			uiObject = EnKai.ui.nkImageGallery(name, parent)
		elseif checkFrameType == 'NKINFOTEXT' then	
			uiObject = EnKai.ui.nkInfoText(name, parent)
		elseif checkFrameType == 'NKITEMTOOLTIP' then	
			uiObject = EnKai.ui.nkItemTooltip(name, parent)
		elseif checkFrameType == 'NKMENU' then
			uiObject = EnKai.ui.nkMenu(name, parent)
		elseif checkFrameType == 'NKMENUENTRY' then
			uiObject = EnKai.ui.nkMenuEntry(name, parent)
		elseif checkFrameType == 'NKRADIOBUTTON' then
			uiObject = EnKai.ui.nkRadioButton(name, parent)
		elseif checkFrameType == 'NKSCROLLBOX' then
			uiObject = EnKai.ui.nkScrollbox(name, parent)
		elseif checkFrameType == 'NKSCROLLPANE' then
			uiObject = EnKai.ui.nkScrollpane(name, parent)
		elseif checkFrameType == 'NKSLIDER' then
			uiObject = EnKai.ui.nkSlider(name, parent)
		elseif checkFrameType == 'NKTABPANE' then
			uiObject = EnKai.ui.nkTabpane(name, parent)
		elseif checkFrameType == 'NKTEXTFIELD' then
			uiObject = EnKai.ui.nkTextfield(name, parent)
		elseif checkFrameType == 'NKTOOLTIP' then
			uiObject = EnKai.ui.nkTooltip(name, parent)
		elseif checkFrameType == 'NKWINDOW' then
			uiObject = EnKai.ui.nkWindow(name, parent)
		elseif checkFrameType == 'NKWINDOWMODERN' then
			uiObject = EnKai.ui.nkWindowModern(name, parent)
		else
			EnKai.tools.error.display (addonInfo.identifier, string.format("EnKai.uiCreateFrame - unknown frame type [%s]", frameType))
		end
--	end

	return uiObject

end

-- the below is a prototype to frame resuing
-- missing SetName() on frames to fully build this

function EnKai.uiAddToGarbageCollector (frameType, element)

	local checkFrameType = string.upper(frameType) 

	if privateVars.gc[checkFrameType] == nil then privateVars.gc[checkFrameType] = {} end
	if privateVars.gc[checkFrameType].normal == nil then privateVars.gc[checkFrameType].normal = {} end
	if privateVars.gc[checkFrameType].secure == nil then privateVars.gc[checkFrameType].secure = {} end
	
	table.insert(privateVars.gc[checkFrameType][element:GetSecureMode()], element)	
	if Inspect.System.Secure() == false or element:GetSecureMode() == 'normal' then element:SetVisible(false) end
	
end  

local function _recycleElement (element)
	
	element:SetVisible(false)
	element:ClearAll()
	element:SetBackgroundColor(0,0,0,0)
	element:SetStrata('main')
	element:SetLayer(0)
	element:SetMouseMasking('full')
	
	if element:GetMouseoverUnit() ~= nil then element:SetMouseoverUnit(nil) end
	
	element:SetSecureMode('normal')
	
	for k, v in pairs (element:GetEvents()) do
		element:EventDetach(v.handle, v.callback, v.label, v.priority, v.owner)
	end
	
	element:_recycle()
	
end

function EnKai.uiGarbageCollector ()

	local secure = Inspect.System.Secure()

	for elementType, secureModes in pairs(privateVars.gc) do
	
		if secure == false and #privateVars.gc[elementType].secure > 0 then
			for idx = 1, #privateVars.gc.secure, 1 do
			
				local element = privateVars.gc[elementType].secure[idx]
				_recycleElement(element)
			
				if privateVars.free[elementType] == nil then privateVars.free[elementType] = {} end
				table.insert(privateVars.free[elementType], element)
				
			end
			
			privateVars.gc[elementType].secure = {}
		end
		
		for idx = 1, #privateVars.gc[elementType].normal, 1 do
		
			local element = privateVars.gc[elementType].normal[idx]
			_recycleElement(element)
			
			if privateVars.free[elementType] == nil then privateVars.free[elementType] = {} end
			table.insert(privateVars.free[elementType], element)
		end
		
		privateVars.gc[elementType].normal = {}
	end

end
