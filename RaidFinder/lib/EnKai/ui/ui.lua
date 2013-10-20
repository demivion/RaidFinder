local addonInfo, privateVars = ...

if not EnKai then EnKai = {} end
if not EnKai.ui then EnKai.ui = {} end

privateVars.ui = {}
privateVars.ui.context = UI.CreateContext("EnKai.ui")

function EnKai.uiCreateFrame (frameType, name, parent)

	if frameType == nil or name == nil or parent == nil then
		EnKai.tools.error.display (addonInfo.identifier, string.format("EnKai.uiCreateFrame - invalid number of parameters\nexpecting: type of frame (string), name of frame (string), parent of frame (string)\nreceived: %s, %s, %s", frameType, name, parent))
		return
	end

	local uiObject = nil

	local checkFrameType = string.upper(frameType) 

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

	return uiObject

end
