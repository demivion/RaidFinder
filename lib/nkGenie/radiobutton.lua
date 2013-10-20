function nkGenie.ExtRadioButton:new (name, parent, settings)

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
	
	local frame = UI.CreateFrame ('nkExtFrame', name, parent, { height = 16, anchors = this.anchors })	
	frame.label = UI.CreateFrame ('nkExtText', name .. 'label', frame:getElement(), {anchors = {{from = "TOPLEFT", object = frame:getElement(), to = "TOPLEFT"}}, color = this.color.border, text = this.label, fontsize = this.fontsize, width = this.labelwidth})
	
	frame.cbOptions = {}
	
	local cbData = this
	
	local callBackFunc = function (thisCheckbox)
		for k, checkbox in pairs (frame.cbOptions) do
			if checkbox.name ~= thisCheckbox.name then checkbox:toggle (false) end
		end
		
		if thisCheckbox:getChecked() == false then thisCheckbox:toggle(true) end
		if this.func ~= nil then
			local value = nil
			for k, details in pairs (this.options) do
				if details.label == thisCheckbox:getLabel() then value = details.value; break end
			end
			this.func(value)
		end
	end
	
	local cbOptionTemplate = { fontsize = this.fontsize, color = this.color, labelinfront=false, labelwidth = this.optionwidth }
	local anchors = {{from = "CENTERLEFT", object = frame.label:getElement(), to = "CENTERRIGHT"}}
	local checked = false
	
	for k, details in pairs (this.options) do
		if k~=1 then anchors[1].object = frame.cbOptions[k-1]:getElement(false) end		
		if k == 1 and this.value == nil then 
			checked = true
		elseif details.value == this.value then
			checked = true
		else
			checked = false
		end
		
		local cbOption = UI.CreateFrame ('nkExtCheckbox', name .. 'cb' .. k, frame:getElement(), { anchors = anchors, text = details.label, template = cbOptionTemplate, func = callBackFunc, checked = checked})
		table.insert(frame.cbOptions, cbOption)

	end
	
	this.element = frame
	
	setmetatable(this, self)
	self.__index = self
	return this
	
end

function nkGenie.ExtRadioButton:update () end
function nkGenie.ExtRadioButton:getElement () return self.element:getElement() end