function nkGenie.ExtGrid:new(name, parent, settings)

	if settings == nil then return nil end
	
	local this = {}
	this.name = name
	this.parent = parent
	
	if settings.template ~= nil then
		for k, v in pairs (settings.template) do
			if settings[k] == nil then settings[k] = v end
		end
		settings.template = nil
	end
	
	local frame = UI.CreateFrame('nkExtFrame', name .. 'main', parent, { anchors = settings.anchors })
	
	if settings.layer ~= nil then frame:getElement():SetLayer(settings.layer) end
		
	for k, v in pairs (settings) do this[k] = v end
	this.element = frame
	
	setmetatable(this, self)
	self.__index = self
	return this
	
end

function nkGenie.ExtGrid:layout (cols, rows, settings)

	if cols == nil or rows == nil or settings == nil then return end
	
	self.rows = rows
	
	local width = 0
	local height = (rows + 1) * (self.fontsize + 7)+1
	
	if settings.headerHeight ~= nil then height = settings.headerHeight + (rows * (self.fontsize + 7))+1 end
	
	for k, v in pairs (cols) do
		width = width + v.width -1
	end
	
	self.element:update({ width = width, height = height })
	
	self.element.layoutHeader = {}
	self.element.layoutRows = {}
		
	local headerAnchor = {{ from = "TOPLEFT", object = self.element:getElement(false), to = "TOPLEFT" }} 

	for idx = 1, #cols, 1 do
		local thisheader = self:buildHeaderCell (idx, cols[idx], headerAnchor, settings.headerHeight)		
		headerAnchor = {{ from = "TOPLEFT", object = thisheader:getElement(false), to = "TOPRIGHT", x = -1, y = 0 }}
		table.insert (self.element.layoutHeader, thisheader)
	end
	
	local cellAnchors = {{ from = "TOPLEFT", object = self.element.layoutHeader[1]:getElement(false), to = "BOTTOMLEFT", x = 0, y = -1 }}
	
	for idx = 1, rows, 1 do
		
		local thisRow = {}
		
		for idx2 = 1, #cols, 1 do
			local thisCell = self:buildContentCell (idx, idx2, cols[idx2], cellAnchors)			
			cellAnchors = {{ from = "TOPLEFT", object = thisCell:getElement(false), to = "TOPRIGHT", x = -1, y = 0 }}			
			table.insert (thisRow, thisCell)
		end
		
		cellAnchors = {{ from = "TOPLEFT", object = thisRow[1]:getElement(false), to = "BOTTOMLEFT", x = 0, y = -1 }}
		table.insert (self.element.layoutRows, thisRow)
	end
	
	self:SetEvents()

end

function nkGenie.ExtGrid:buildHeaderCell (counter, colDef, headerAnchor, height)
	
	local color = { body = self.color.body, border = self.color.border }
	local labelColor = self.color.label
	
	if self.color.headerBody == '' then 
		color = nil
	elseif self.color.headerBody ~= nil then 
		color.body = self.color.headerBody
	end
	if self.color.headerLabel ~= nil then labelColor = self.color.headerLabel end	

	if height == nil then height = self.fontsize + 8 end
	
	local thisheader = UI.CreateFrame('nkExtFrame', self.name .. 'col'..counter..'Header', self.element:getElement(true), { width = colDef.width, height = height, color = color, anchors = headerAnchor })
	thisheader.label = UI.CreateFrame('nkExtText', self.name .. 'col' .. counter .. 'HeaderLabel', thisheader:getElement(true), { text = colDef.header, fontsize = self.fontsize, color = labelColor, anchors = {{ from = "CENTER", object = thisheader:getElement(true), to = "CENTER" }} })

	if colDef.sortable ~= false then
		thisheader:SetEvent('LeftClick', function ()
			if self.sortedIndex ~= counter then 
				self:reSort(counter, true)
			elseif self.sortedDirection == true then
				self:reSort(counter, false)
			else
				self:reSort(counter, true)
			end
		end)
	end
		
	return thisheader
	
end

function nkGenie.ExtGrid:buildContentCell (rowCounter, cellCounter, colDef, cellAnchors)

	local anchorOrientation = "CENTER"
	if colDef.align ~= nil then
		if colDef.align == 'left' then
			anchorOrientation = "CENTERLEFT"
		elseif colDef.align == 'right' then
			anchorOrientation = "CENTERRIGHT"
		end				
	end
	local thisCell = UI.CreateFrame('nkExtFrame', self.name .. 'row' .. rowCounter .. 'col' .. cellCounter, self.element:getElement(true), { width = colDef.width, height = self.fontsize+8, color = self.color, anchors = cellAnchors })
	
	if colDef.texture then
		thisCell.content = UI.CreateFrame('nkExtTexture', self.name .. 'row' .. rowCounter .. 'col' .. cellCounter .. 'content', thisCell:getElement(true), { type = colDef.type, path = colDef.path, width = colDef.textureWidth, height = colDef.textureHeight, anchors = {{ from = anchorOrientation, object = thisCell:getElement(true), to = anchorOrientation }} })
		thisCell.isTexture = true
	else	
		thisCell.content = UI.CreateFrame('nkExtText', self.name .. 'row' .. rowCounter .. 'col' .. cellCounter .. 'content', thisCell:getElement(true), { text = '', fontsize = self.fontsize, color = self.color.label, anchors = {{ from = anchorOrientation, object = thisCell:getElement(true), to = anchorOrientation }} })
		thisCell.isTexture = false
	end
	
	thisCell.marker = UI.CreateFrame('nkExtFrame', self.name .. 'row' .. rowCounter .. 'col' .. cellCounter .. 'marker', thisCell.content:getElement(), { anchors = {{from = "TOPLEFT", object = thisCell:getElement(), to = "TOPLEFT" }, { from = "BOTTOMRIGHT", object = thisCell:getElement(), to = "BOTTOMRIGHT"}} })
	
	thisCell.marker:SetEvent('MouseIn', function () 
		self:rowHighlight(rowCounter, true) 
		if self.mouseOverFunc ~= nil then self.mouseOverFunc (rowCounter) end
	end)
	thisCell.marker:SetEvent('MouseOut', function () 
		self:rowHighlight(rowCounter, false) 
		if self.mouseOutFunc ~= nil then self.mouseOutFunc (rowCounter) end
	end)
	
	if self.clickCallBack ~= nil then thisCell.marker:SetEvent('LeftClick', function () self.clickCallBack(rowCounter) end) end
	if self.clickRightCallBack ~= nil then thisCell.marker:SetEvent('RightClick', function () self.clickRightCallBack(rowCounter) end) end

	thisCell.anchorOrientation = anchorOrientation
	
	return thisCell
	
end

function nkGenie.ExtGrid:rowHighlight (row, active)
	
	for idx = 1, #self.element.layoutRows[row], 1 do
		
		local cell = self.element.layoutRows[row][idx]		
		local specColor = nil
		
		if self.counter ~= nil then
			if self.values[self.counter + row - 1] == nil then return end
			local cellValue = self.values[self.counter + row - 1][idx] 
			if cellValue ~= nil then
				if type(cellValue) == 'table' and cellValue.color ~= nil and cellValue.color ~= self.color.bodyhighlight then specColor = cellValue.color end
			end
		end
		
		if active == true then
			cell:update ({ color = {body = self.color.bodyhighlight, border = self.color.border } })
			if specColor == nil then
				cell.content:update ({ color = self.color.labelhighlight })
			else
				cell.content:update ({ color = self.color.specColor })
			end
		else
			cell:update ({ color = self.color })
			if specColor == nil then
				cell.content:update ({ color = self.color.label })
			else
				cell.content:update ({ color = self.color.specColor })
			end
		end
		
	end

end

function nkGenie.ExtGrid:SetEvents()

	local this = self
	local frame = self.element:getElement(false)
	function frame.Event:WheelForward ()
		if this.counter == nil then return end
		this.counter = this.counter -1
		if this.counter <= 0 then this.counter = 1 end
		this:fill()
		if this.wheelFunc ~= nil then this.wheelFunc(this.counter) end
	end
	
	function frame.Event:WheelBack ()
		if this.counter == nil then return end
		this.counter = this.counter +1
		local max = #this.values - (this.rows - 1)
		if max < 1 then max = 1 end
		
		if this.counter > max then this.counter = max end
		this:fill()
		if this.wheelFunc ~= nil then this.wheelFunc(this.counter) end
	end
	
end

function nkGenie.ExtGrid:fill (values)

	local rows = self.element.layoutRows
	
	if values ~= nil then self.values = values end
	
	if self.counter == nil then self.counter = 1 end	
	
	for idx = self.counter, self.counter + (self.rows -1), 1 do
		local v = self.values[idx]
		if v == nil then
			for idx2 = 1, #rows[idx - self.counter + 1], 1 do
				local cell = rows[idx - self.counter + 1][idx2]
				if cell.isTexture then
					cell.content:SetVisible(false)
				else
					cell.content:update ({ text = '' })
				end
			end
		else
			for idx2 = 1, #v, 1 do				
				local cell = rows[idx - self.counter + 1][idx2]
				
				local autowidth, width = nil, cell:getElement():GetWidth() 

				if cell.anchorOrientation ~= 'CENTERLEFT' then
					width = nil
					autowidth = true
				end
						
				if cell.isTexture then
					cell.content:SetVisible(true)
					if type(v[idx2]) ~= 'table' then
						cell.content:SetTexture ({ path = tostring(v[idx2]) })
					else
						cell.content:SetTexture ({ path = tostring(v[idx2].value) })
					end
				else
					if type(v[idx2]) ~= 'table' then
						cell.content:update ({ text = tostring(v[idx2]), width = width, autowidth = autowidth })
					elseif v[idx2].color ~= nil then
						cell.content:update ({ text = tostring(v[idx2].value), color = v[idx2].color, width = width, autowidth = autowidth })
					else
						cell.content:update ({ text = tostring(v[idx2].value), width = width, autowidth = autowidth })
					end
				end
			end
			
			if #v < #rows[idx - self.counter+1] then
				for idx2 = #v+1, #rows[idx - self.counter + 1], 1 do
					local cell = rows[idx - self.counter + 1][idx2]
					
					if cell.isTexture then
						cell.content:SetVisible(false)
					else
						cell.content:update ({ text = '' })
					end
				end
			end
		end
	end

end

function nkGenie.ExtGrid:reSort(index, direction)

	if self.values == nil then return end
	if self.values[1] == nil then return end
	if self.values[1][index] == nil then return end
	
	self.counter = 1
	self.sortedIndex = index
	self.sortedDirection = direction
	
	if type(self.values[1][index]) == 'table' then
		if direction == true then
			if tonumber(self.values[1][index].value) ~= nil then
				table.sort (self.values, function (v1, v2) return tonumber(v1[index].value) > tonumber(v2[index].value) end )
			else
				table.sort (self.values, function (v1, v2) return v1[index].value > v2[index].value end )
			end
		else
			if tonumber(self.values[1][index].value) ~= nil then
				table.sort (self.values, function (v1, v2) return tonumber(v1[index].value) < tonumber(v2[index].value) end )
			else
				table.sort (self.values, function (v1, v2) return v1[index].value < v2[index].value end )
			end
		end
	else
		if direction == true then
			table.sort (self.values, function (v1, v2) return v1[index] > v2[index] end )
		else
			table.sort (self.values, function (v1, v2) return v1[index] < v2[index] end )
		end
	end

	self:fill()
	
end

function nkGenie.ExtGrid:update (cols, noOfRows, settings)

	if cols == nil or noOfRows == nil or settings == nil then return end

	self.rows = noOfRows
	local rows = self.element.layoutRows
	
	if #rows[1] < #cols then
		local noOfCols = #self.element.layoutHeader
		
		-- Header Zellen anfügen
	
		local headerAnchor = {{ from = "TOPLEFT", object = self.element.layoutHeader[noOfCols]:getElement(false), to = "TOPRIGHT", x = -1, y = 0 }}

		for idx = noOfCols+1, #cols, 1 do
			local thisheader = self:buildHeaderCell (idx, cols[idx], headerAnchor, settings.headerHeight)		
			headerAnchor = {{ from = "TOPLEFT", object = thisheader:getElement(false), to = "TOPRIGHT", x = -1, y = 0 }}
			table.insert (self.element.layoutHeader, thisheader)
		end
		
		-- Content Zellen anfügen
	
		local cellAnchors = {{ from = "TOPLEFT", object = self.element.layoutHeader[noOfCols+1]:getElement(false), to = "BOTTOMLEFT", x = 0, y = -1 }}
	
		for idx = 1, #rows, 1 do
			
			local thisRow = rows[idx]
			
			for idx2 = noOfCols+1, #cols, 1 do
				local thisCell = self:buildContentCell (idx, idx2, cols[idx2], cellAnchors)			
				cellAnchors = {{ from = "TOPLEFT", object = thisCell:getElement(false), to = "TOPRIGHT", x = -1, y = 0 }}			
				table.insert (thisRow, thisCell)
			end
			
			cellAnchors = {{ from = "TOPLEFT", object = thisRow[noOfCols+1]:getElement(false), to = "BOTTOMLEFT", x = 0, y = -1 }}
		end
	end
	
	local width = 0
	local height = (noOfRows + 1) * (self.fontsize + 7);
	for k, v in pairs (cols) do width = width + v.width -1 end
	
	self.element:update({ width = width, height = height })
	
	for idx = 1, #rows[1], 1 do
		local colDef = cols[idx]
		if colDef == nil then
			self.element.layoutHeader[idx]:update({ visible = false })
			self.element.layoutHeader[idx].label:update({ visible = false })
		else
			self.element.layoutHeader[idx]:update({ visible = true, width = colDef.width })
			self.element.layoutHeader[idx].label:update ({ visible = true, text = colDef.header })
		end		
	end
	
	for idx = 1, noOfRows, 1 do
		for idx2 = 1, #rows[idx], 1 do
			local cell = rows[idx][idx2]			
			local colDef = cols[idx2]
			if colDef == nil then
				cell:update ({ visible = false })
			else
				cell:update ({visible = true, width = colDef.width })
			end
		end
	end
	
	for k, v in pairs (settings) do self[k] = v end
			
end

function nkGenie.ExtGrid:setClickEvent (clickCallBack, rightClick)

	if rightClick == true then
		self.clickRightCallBack = clickCallBack
	else
		self.clickCallBack = clickCallBack
	end
	
	local rows = self.element.layoutRows

	for idx = 1, #rows, 1 do
		for idx2 = 1, #rows[idx], 1 do
			local cell = rows[idx][idx2]		
			
			if rightClick == true then 			
				cell.marker:SetEvent('RightClick', function () self.clickRightCallBack(idx) end)
			else
				cell.marker:SetEvent('LeftClick', function () self.clickCallBack(idx) end)
			end
		end
	end

end

function nkGenie.ExtGrid:getElement(flag) return self.element:getElement(flag) end
function nkGenie.ExtGrid:getCounter() if self.counter == nil then return 0 else return self.counter end end
function nkGenie.ExtGrid:getKey(counter) 

	if self.values == nil then return nil end
	if self.values[counter] == nil then return nil end

	for k, v in pairs (self.values[counter]) do
		if v.key ~= nil then return v.key end
	end

	return nil

end

function nkGenie.ExtGrid:search (searchValue, col) 

	if searchValue == nil or searchValue == '' or self.values == nil then return nil end
	if col == nil or col == 0 or col > #self.element.layoutRows[1] then return nil end
	
	for k, v in pairs(self.values) do
		local compareValue = nil
		if type(v[col]) == 'table' then		
			compareValue = string.upper(v[col].value)
		else
			compareValue = string.upper(v[col])
		end

		if string.find(compareValue, string.upper(searchValue)) ~= nil then return k end
	end
	
	return nil

end

function nkGenie.ExtGrid:setPos(setToPos)

	if setToPos == nil or setToPos < 1 then return end
	if self.values == nil then return end

	--if setToPos > (#self.values - self.rows) then return end
	
	self.counter = setToPos
	self:fill()

end

function nkGenie.ExtGrid:getLastElement()

	local lastRow = self.element.layoutRows[#self.element.layoutRows]
	local lastCell = lastRow[#lastRow]
	return lastCell.marker:getElement()

end

function nkGenie.ExtGrid:getHeight ()

	return self:getElement(false):GetHeight();

end