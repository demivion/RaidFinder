local addonInfo, privateVars = ...

function EnKai.ui.nkTooltip(name, parent) 

	local defaultTitleColor = {1, 1, 1, 1}
	local defaultSubTitleColor = {1, 1, 1, 1}	
	local defaultLinesColor = {1, 1, 1, 1}	
	local defaultBorderColor = { 0.557, 0.553, 0.431, 1 }
	
	local defaultWidth = 100

	local tooltip = UI.CreateFrame ('Frame', name, parent)
	local tooltipInner = UI.CreateFrame ('Frame', name .. 'Innner', tooltip)
	local title = UI.CreateFrame ('Text', name .. 'Title', tooltipInner)
	local subTitle = UI.CreateFrame ('Text', name .. 'subTitle', tooltipInner)
	local separator = UI.CreateFrame("Frame", name .. 'separator', tooltipInner)
	
	local lines = {}

	local properties = {}

	function tooltip:SetValue(property, value)
		properties[property] = value
	end
	
	function tooltip:GetValue(property)
		return properties[property]
	end
	
	tooltip:SetValue("name", name)
	tooltip:SetValue("parent", parent)
	
	tooltip:SetWidth(defaultWidth)
	tooltip:SetBackgroundColor (defaultBorderColor[1], defaultBorderColor[2], defaultBorderColor[3], defaultBorderColor[4])
	
	tooltipInner:SetPoint ("TOPLEFT", tooltip, "TOPLEFT", 1, 1)
	tooltipInner:SetPoint ("BOTTOMRIGHT", tooltip, "BOTTOMRIGHT", -1, -1)
	tooltipInner:SetBackgroundColor (0, 0, 0, 1)
	
	title:SetPoint ("TOPLEFT", tooltip, "TOPLEFT")
	title:SetFontSize(13)
	title:SetFontColor(defaultTitleColor[1], defaultTitleColor[2], defaultTitleColor[3], defaultTitleColor[4])
		
	subTitle:SetPoint ("TOPLEFT", title, "BOTTOMLEFT")
	subTitle:SetFontSize(11)
	subTitle:SetFontColor(defaultSubTitleColor[1], defaultSubTitleColor[2], defaultSubTitleColor[3], defaultSubTitleColor[4])
	subTitle:SetVisible(false)
	subTitle:SetHeight(1)
	
	separator:SetPoint("TOPLEFT", subTitle, "BOTTOMLEFT")
	separator:SetWidth(tooltipInner:GetWidth())
	separator:SetHeight(1)
	
	separator:SetBackgroundColor(defaultBorderColor[1], defaultBorderColor[2], defaultBorderColor[3], defaultBorderColor[4])
		
	function tooltip:SetTitle(newTitle)
		title:SetText(newTitle)
	end
	
	function tooltip:SetSubTitle(newTitle)
	
		tooltip:SetValue('subTitle', newTitle)
		
		if newTitle == nil then
			subTitle:SetPoint("TOPLEFT", tooltipInner, "BOTTOMLEFT")
			subTitle:SetVisible(false)
			subTitle:SetHeight(1)
		else				
			subTitle:SetText(newTitle)
			subTitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT")
			subTitle:SetVisible(true)
			subTitle:SetHeight(11)
		end
	end
	
	function tooltip:SetLines(newLines)
		
		local newHeight = title:GetHeight() + 7
		local newWidth = tooltip:GetWidth()
		
		if subTitle:GetVisible() == true then newHeight = newHeight + subTitle:GetHeight() end
			
		for idx = 1, #newLines, 1 do
			local line = nil
			if idx > #lines then
				line = UI.CreateFrame('Text', name .. 'line' .. idx, tooltipInner)
				line:SetFontColor(defaultLinesColor[1], defaultLinesColor[2], defaultLinesColor[3], defaultLinesColor[4])
				line:SetFontSize(11)
								
				if idx == 1 then
					line:SetPoint("TOPLEFT", separator, "BOTTOMLEFT")
				else
					line:SetPoint("TOPLEFT", lines[idx-1], "BOTTOMLEFT")
				end
				
				table.insert(lines, line)
			else
				line = lines[idx]
				line:SetVisible(true)
			end
			
			if newLines[idx].height == nil then
				line:SetHeight(16)
			else
				line:SetHeight(newLines[idx].height)
			end

			line:SetText(newLines[idx].text, true)	
			
			newHeight = newHeight + line:GetHeight()
			if line:GetWidth() > newWidth then newWidth = line:GetWidth() end
			
		end
		
		if #newLines < #lines then
			for idx = #newLines + 1, #lines, 1 do
				lines[idx]:SetVisible(false)
			end
		end
		
		tooltip:SetWidth(newWidth)
		separator:SetWidth(newWidth-2)
		tooltip:SetHeight(newHeight)
	end
	
	return tooltip
	
end