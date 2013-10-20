function nkGenie.ExtDialog:new(name, parent, settings) 

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

	local dialog = nil
	
	if this.rdesign == true then
		dialog = UI.CreateFrame ('nkExtRiftWindow', name, parent, {layer = this.layer, fontsize = this.fontsize, width = this.width, height = this.height, title = this.title, anchors = this.anchors,
																	closeable = false, dragable = true, visible = true})
	else
		dialog = UI.CreateFrame ('nkExtWindow', name, parent, {layer = this.layer, fontsize = this.fontsize, width = this.width, height = this.height, color = this.color, title = this.title, anchors = this.anchors,
																	closeable = false, collapsible = false, dragable = true, visible = true})
	end
	
	dialog:SetStrata('main')
	
	if this.message ~= nil then
		dialog.message = UI.CreateFrame('nkExtText', name .. 'message', dialog:getBody(true), { text = this.message, fontsize = this.fontsize, color = this.color.message, anchors = {{ from = "CENTER", object = dialog:getBody(true), to = "CENTER", x = 0, y = -25 }} })
		if dialog.message:GetWidth() > dialog:getBody(true):GetWidth() then 
			dialog.message:update ({ width = dialog:getBody(true):GetWidth() }) 
		end
	end
	
	local buttonType, width = 'nkExtButton', 100
	local height, fwidth = 25, 210
	
	if this.rdesign == true then buttonType, width = 'nkExtRiftButton', nil end
	if this.rdesign == true then height, fwidth = 15, 275 end
	
	dialog.buttonFrame = UI.CreateFrame('nkExtFrame', name .. 'buttonFrame', dialog:getBody(true), { width = fwidth, height = height, anchors = {{ from = "CENTERBOTTOM", object = dialog:getBody(true), to = "CENTERBOTTOM", x = 0, y = -10 }} })
	
	if this.okButton == true then		
		dialog.okButton = UI.CreateFrame (buttonType, name .. 'okButton', dialog.buttonFrame:getElement(), { anchors = {{ from = "CENTER", object = dialog.buttonFrame:getElement(), to = "CENTER" }},
																									 label = nkGenie.langTexts.ok, width = width, color = {body = this.color.header, border=this.color.border, label = this.color.title},
																									 func = function () dialog:SetVisible(false); if this.func ~= nil then this.func() end end })
	elseif this.confirmButton == true then
		
		dialog.yesButton = UI.CreateFrame (buttonType, name .. 'yesButton', dialog.buttonFrame:getElement(), { anchors = {{ from = "CENTERLEFT", object = dialog.buttonFrame:getElement(), to = "CENTERLEFT" }},
																									 label = nkGenie.langTexts.yes, width = width, color = {body = this.color.header, border=this.color.border, label = this.color.title},
																									 func = function () dialog:SetVisible(false); if this.funcYes ~= nil then this.funcYes() end end })
																									 
		dialog.noButton = UI.CreateFrame (buttonType, name .. 'noButton', dialog.buttonFrame:getElement(), { anchors = {{ from = "CENTERRIGHT", object = dialog.buttonFrame:getElement(), to = "CENTERRIGHT" }},
																									 label = nkGenie.langTexts.no, width = width, color = {body = this.color.header, border=this.color.border, label = this.color.title},
																									 func = function () dialog:SetVisible(false); if this.funcNo ~= nil then this.funcNo() end end })
		
	end		
	
	this.dialog = dialog
	setmetatable(this, self)
	self.__index = self
	return this

end

function nkGenie.ExtDialog:update(settings)

	if settings.message ~= nil then
		if self.dialog.message ~= nil then self.dialog.message:update ({ text = settings.message }) end
	end
	
	if settings.anchors ~= nil then
		for k, anchor in pairs(settings.anchors) do
			if anchor.x ~= nil and anchor.y ~= nil then
				self.dialog:getElement():SetPoint (anchor.from, anchor.object, anchor.to, anchor.x, anchor.y)
			else
				self.dialog:getElement():SetPoint (anchor.from, anchor.object, anchor.to)
			end
		end
	end
	
	for k, v in pairs (settings) do self[k] = v end

end
 
function nkGenie.ExtDialog:getElement () return self.dialog:getElement() end

function nkGenie.ExtDialog:getInternal(element)
	
	if element == 'body' then
		return self.dialog.body
	elseif element == 'header' then
		return self.dialog.header
	end
	
end

function nkGenie.ExtDialog:getBody(innerFlag) return self.dialog:getBody(innerFlag) end
function nkGenie.ExtDialog:getHeader(innerFlag) return self.dialog:getHeader(innerFlag) end
function nkGenie.ExtDialog:getHeaderTitle() return self.dialog:getHeaderTitle() end
function nkGenie.ExtDialog:isVisible () return self.dialog:getElement():GetVisible() end
function nkGenie.ExtDialog:SetVisible (flag) self.dialog:SetVisible(flag) end