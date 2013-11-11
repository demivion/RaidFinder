local addonInfo, privateVars = ...

function EnKai.ui.nkGrid(name, parent) 

	-- pre-define ui elements --
	
	local grid = UI.CreateFrame ('Frame', name, parent)
	local progressText = UI.CreateFrame('Text', name .. 'ProgressText', parent)
	
	local LayoutHeaders = {}
	local LayoutRows = {}
	
	local properties = {}

	function grid:SetValue(property, value)
		properties[property] = value
	end
	
	function grid:GetValue(property)
		return properties[property]
	end
	
	-- default values --
	
	local fontSize = 13
	local headerFontSize = 13
	local headerHeight = headerFontSize + 7
	local cellHeight = fontSize + 7
		
	local borderColor = { 1, 1, 1, 1 }
	local bodyColor = { 0, 0, 0, 1 }
	local labelColor = { 1, 1, 1, 1 }
	local headerLabelColor = { 1, 1, 1, 1}
	local labelHighlightColor = { 0, 0, 0, 1 }
	local bodyHighlightColor = { 1, 1, 1, 1 }
	local labelSelectedColor = { 0, 0, 0, 1 }
	local bodySelectedColor = { 0.6, 0.6, 0.6, 1 }
	local transparentHeader = false
	
	local rowPos = 1
	local cellValues = {}
		
	local highlightedRow = nil
	local selectedRow = nil
	local selectable = false
	local rows = 0	
	local cols
	local sortable = false
	local sortAscending = false
	local backupFilter
	
	-- fill ui elements with live

	progressText:SetLayer(9999)
	progressText:SetFontSize(30)
	progressText:SetFontColor(1, 1, 1 ,1)
	progressText:SetPoint("CENTER", grid, "CENTER")
	progressText:SetVisible(false)
	
	function grid:SetHeaderHeight(newHeight)
		headerHeight = newHeight
		for idx = 1, #LayoutHeaders, 1 do
			LayoutHeaders[idx]:SetHeight(newHeight)
		end
		
		local height = headerHeight + (rows * cellHeight) + 1
		grid:SetHeight(height)		
	end
	
	function grid:SetHeaderLabeLColor(r,g,b,a) -- typo in old versions. Will be removed at some point
		grid:SetHeaderLabelColor(r, g, b, a)
	end
	
	function grid:SetHeaderLabelColor (r, g, b, a)
		headerLabelColor = {r, g, b, a}
		for idx = 1, #LayoutHeaders, 1 do
			LayoutHeaders[idx]:SetLabeLColor(r, g, b, a)
		end
	end
	
	function grid:SetBorderColor(r, g, b, a)
		borderColor = {r, g, b, a}
		for idx = 1, #LayoutHeaders, 1 do
			LayoutHeaders[idx]:SetBorderColor(r, g, b, a)
		end
		
		for idx = 1, #LayoutRows, 1 do
			for idx2 = 1, #LayoutRows[idx], 1 do
				LayoutRows[idx][idx2]:SetBorderColor(r, g, b, a)
			end
		end
	end
	
	function grid:SetBodyColor(r, g, b, a)
		bodyColor = {r, g, b, a}
		for idx = 1, #LayoutRows, 1 do
			for idx2 = 1, #LayoutRows[idx], 1 do
				LayoutRows[idx][idx2]:SetBodyColor(r, g, b, a)
			end
		end
	end
	
	function grid:SetBodyHighlightColor (r, g, b, a)
		bodyHighlightColor = { r, g, b, a}
	end
	
	function grid:SetLabelHighlightColor (r, g, b, a)
		labelHighlightColor = { r, g, b, a}
	end
	
	function grid:SetBodySelectedColor (r, g, b, a)
		bodySelectedColor = { r, g, b, a}
	end
		
	function grid:SetLabelSelectedColor (r, g, b, a)
		labelSelectedColor = { r, g, b, a}
	end
	
	-- layout function --
	
	function grid:Layout (newCols, newRows)

		if newCols == nil or newRows == nil then return end
		
		if newCols ~= nil then cols = newCols end
		if newRows ~= nil then rows = newRows end
		
		local width = 0
		local height = (headerHeight-1) + (rows * (cellHeight-1)) + 1
		
		for k, v in pairs (cols) do
			width = width + v.width -1
		end
		
		grid:SetHeight(height)
		grid:SetWidth(width)
		
		LayoutHeaders = {} -- would prefer to delete existing frames but not yet implemented in API
		LayoutRows = {}   -- would prefer to delete existing frames but not yet implemented in API
			
		local from, object, to, x = "TOPLEFT", grid, "TOPLEFT", 0

		for idx = 1, #cols, 1 do
			local thisHeader = EnKai.uiCreateFrame('nkGridHeaderCell', name .. 'HeaderCell' .. idx, grid)
						
			thisHeader:SetWidth(cols[idx].width)
			thisHeader:SetBorderColor (borderColor[1], borderColor[2], borderColor[3], borderColor[4])
			thisHeader:SetBodyColor (bodyColor[1], bodyColor[2], bodyColor[3], bodyColor[4])
			thisHeader:SetLabelColor (headerLabelColor[1], headerLabelColor[2], headerLabelColor[3], headerLabelColor[4])
			thisHeader:SetAlign(cols[idx].align)
			thisHeader:SetFontSize(headerFontSize)
			
			--thisHeader:SetHeight(headerHeight) -- not necessary on initial build
			if cols[idx].header ~= nil then thisHeader:SetText(cols[idx].header) end
			thisHeader:SetPoint(from, object, to, x, 0)
			thisHeader:SetHeight(headerHeight)
			
			object, to, x = thisHeader, "TOPRIGHT", -1
			
			table.insert (LayoutHeaders, thisHeader)
		end
		
		if transparentHeader == true then
			grid:SetTransparentHeader()
		end
		
		--self:SetEvents()
		
		local gridCoRoutine = coroutine.create(
		   function ()
		   
				for idx = 1, rows, 1 do
					progressText:SetText(string.format ('%03d%%', math.floor(100 / rows * idx)))
				
					local object, to, x, y
					local count = #LayoutRows
					
					if count == 0 then
						object, to, x, y = LayoutHeaders[1], "BOTTOMLEFT", 0, -1						
					else
						object, to, x, y = LayoutRows[count][1], "BOTTOMLEFT", 0, -1
					end
					
					local thisRow = {}
					
					for idx2 = 1, #cols, 1 do
						local thisCell = EnKai.uiCreateFrame('nkGridCell', name .. 'cell' .. idx .. '.' .. idx2, grid)
						thisCell:SetBorderColor (borderColor[1], borderColor[2], borderColor[3], borderColor[4])
						thisCell:SetBodyColor (bodyColor[1], bodyColor[2], bodyColor[3], bodyColor[4])
						thisCell:SetWidth(cols[idx2].width)
						thisCell:SetAlign(cols[idx2].align)
						thisCell:SetFontSize(fontSize)
						
						if cols[idx2].texture == true then
							thisCell:SetTexture(cols[idx2].textureType, cols[idx2].texturePath)
							
							if cols[idx2].textureWidth ~= nil then thisCell:SetTextureWidth(cols[idx2].textureWidth) end
							if cols[idx2].textureHeight ~= nil then thisCell:SetTextureHeight(cols[idx2].textureHeight) end
						end
						
						thisCell:SetPoint("TOPLEFT", object, to, x, y)
						object, to, x, y = thisCell, "TOPRIGHT", -1, 0
						table.insert (thisRow, thisCell)
					end
					
					table.insert (LayoutRows, thisRow)
					
					if idx == rows then
						progressText:SetVisible(false)
						EnKai.eventHandlers[name]["GridFinished"]()
					end
					
					coroutine.yield(idx)
				end
		end)

		table.insert(privateVars.coRoutines, { func = gridCoRoutine, counter = rows, active = true })
		progressText:SetVisible(true)

	end
	
	function grid:ReLayout()
			
		local height = headerHeight + (rows * cellHeight) + 1
		grid:SetHeight(height)
		
		for idx = 1, #cols, 1 do
			local thisHeader = LayoutHeaders[idx]
						
			thisHeader:SetBorderColor (borderColor[1], borderColor[2], borderColor[3], borderColor[4])
			thisHeader:SetBodyColor (bodyColor[1], bodyColor[2], bodyColor[3], bodyColor[4])
			thisHeader:SetLabelColor (headerLabelColor[1], headerLabelColor[2], headerLabelColor[3], headerLabelColor[4])
			thisHeader:SetAlign(cols[idx].align)
			thisHeader:SetFontSize(headerFontSize)
		end
			
		local gridCoRoutine = coroutine.create(
		   function ()
		   
				for idx = 1, rows, 1 do
					progressText:SetText(string.format ('%03d%%', math.floor(100 / rows * idx)))
				
					local count = #LayoutRows

					local thisRow = {}
					
					for idx2 = 1, #cols, 1 do
						local thisCell = LayoutRows[idx][idx2]
						thisCell:SetBorderColor (borderColor[1], borderColor[2], borderColor[3], borderColor[4])
						thisCell:SetBodyColor (bodyColor[1], bodyColor[2], bodyColor[3], bodyColor[4])						
						thisCell:SetFontSize(fontSize)
					end
					
					if idx == rows then
						progressText:SetVisible(false)
						EnKai.eventHandlers[name]["GridFinished"]()
					end
					
					coroutine.yield(idx)
				end
		end)

		table.insert(privateVars.coRoutines, { func = gridCoRoutine, counter = rows, active = true })
		progressText:SetVisible(true)
	
	end
	
	function grid:UpdateLayout(newCols)
	
		if newCols == nil then return end
		
		for idx = 1, #newCols, 1 do
			local thisHeader = LayoutHeaders[idx]
			
			if thisHeader ~= nil then
			
				--thisHeader:SetWidth(newCols[idx].width)				
				thisHeader:SetBorderColor (borderColor[1], borderColor[2], borderColor[3], borderColor[4])
				thisHeader:SetBodyColor (bodyColor[1], bodyColor[2], bodyColor[3], bodyColor[4])
				thisHeader:SetLabelColor (headerLabelColor[1], headerLabelColor[2], headerLabelColor[3], headerLabelColor[4])
				thisHeader:SetAlign(newCols[idx].align)
				thisHeader:SetFontSize(headerFontSize)
				thisHeader:SetWidth(newCols[idx].width)
				thisHeader:SetVisible(true)
				
				if newCols[idx].header ~= nil then thisHeader:SetText(newCols[idx].header) end
			else
				print("ENKAI ERROR: Grid cannot increase number of cols after creation!")
				return
			end
		end
		
		if #newCols < #LayoutHeaders then
			for idx = #newCols+1, #LayoutHeaders, 1 do
				LayoutHeaders[idx]:SetVisible(false)
			end
		end
		
		if transparentHeader == true then
			grid:SetTransparentHeader()
		end
		
		local gridCoRoutine = coroutine.create(
		   function ()
		   
				for idx = 1, rows, 1 do
					progressText:SetText(string.format ('%03d%%', math.floor(100 / rows * idx)))
				
					local count = #LayoutRows

					local thisRow = {}
					
					for idx2 = 1, #newCols, 1 do
						local thisCell = LayoutRows[idx][idx2]
						thisCell:SetWidth(newCols[idx2].width)
						thisCell:SetHide(true)
					end
					
					if #newCols < #LayoutHeaders then
						for idx2 = #newCols+1, #LayoutHeaders, 1 do
							local thisCell = LayoutRows[idx][idx2]
							thisCell:SetHide(false)
						end
					end
					
					if idx == rows then
						progressText:SetVisible(false)
					end
					
					coroutine.yield(idx)
				end
		end)

		cols = newCols

		table.insert(privateVars.coRoutines, { func = gridCoRoutine, counter = rows, active = true })
		progressText:SetVisible(true)
		
	end
	
	-- transparent header
	
	function grid:SetTransparentHeader()
		
		transparentHeader = true
		
		for idx = 1, #LayoutHeaders, 1 do
			LayoutHeaders[idx]:SetBorderColor(0, 0, 0, 0)
			LayoutHeaders[idx]:SetBodyColor(0, 0, 0, 0)
		end
		
	end
	
	function grid:SetHeaderFontSize(newFontSize)
		if headerHeight == headerFontSize + 7 then headerHeight = newFontSize + 7 end
		headerFontSize = newFontSize
		 
		if #LayoutRows > 0 then grid:ReLayout() end
	end
	
	function grid:SetFontSize(newFontSize)
		fontSize = newFontSize
		cellHeight = fontSize + 7
		if #LayoutRows > 0 then grid:ReLayout() end
	end
	
	-- fill values ---

	function grid:SetCellValue(row, coll, newValue)
		if cellValues == nil then return end
		if cellValues[row] == nil then return end
		
		if type (cellValues[row][coll]) ~= 'table' then
			cellValues[row][coll] = newValue
		else
			cellValues[row][coll].value = newValue
		end
		
		if row >= rowPos and row <= rowPos + ( rows -1) then
			grid:UpdateGrid()
		end
	end
	
	function grid:SetCellValues(values) 
				
		if values ~= nil then cellValues = values end
		grid:UpdateGrid()
		
	end
	
	function grid:GetCellValue(row, col)
		
		if cellValues == nil then return nil end
		if cellValues[row] == nil then return nil end
		
		if type (cellValues[row][col]) ~= 'table' then
			return cellValues[row][col]
		else
			return cellValues[row][col].value
		end
		
	end
	
	function grid:GetCellValues()
		return cellValues
	end
	
	function grid:UpdateGrid()
		
		if LayoutRows == nil then return end
		
		for idx = rowPos, rowPos + ( rows -1 ), 1 do
			local v = cellValues[idx]
			
			if v == nil then
				if LayoutRows[idx - rowPos + 1] ~= nil then			
					for idx2 = 1, #LayoutRows[idx - rowPos + 1], 1 do
						local cell = LayoutRows[idx - rowPos + 1][idx2]
						cell:SetBodyColor (bodyColor[1], bodyColor[2], bodyColor[3], bodyColor[4])
						if cell:IsTexture() == true then
							cell:SetVisible(false)
						else
							cell:SetText('')
						end
					end
				end
			else
				for idx2 = 1, #v, 1 do				
					local cell = LayoutRows[idx - rowPos + 1][idx2]
					
					cell:SetBorderColor (borderColor[1], borderColor[2], borderColor[3], borderColor[4])
					cell:SetBodyColor (bodyColor[1], bodyColor[2], bodyColor[3], bodyColor[4])
					
					local autowidth, width = nil, cell:GetWidth() 

					if cell:GetOrientation() ~= 'CENTERLEFT' then
						width = nil
						autowidth = true
					end
							
					if cell:IsTexture() == true then
						cell:SetVisible(true)
						if type(v[idx2]) ~= 'table' then							
							cell:SetTexture (cols[idx2].textureType, tostring(v[idx2]))
						else
							cell:SetTexture (cols[idx2].textureType, tostring(v[idx2].value))
						end
					else
						if type(v[idx2]) ~= 'table' then
							cell:SetText(tostring(v[idx2]))
						elseif v[idx2].color ~= nil then
							cell:SetText(tostring(v[idx2].value))
							cell:SetLabelColor(v[idx2].color[1], v[idx2].color[2], v[idx2].color[3], v[idx2].color[4])
						else
							cell:SetLabelColor(labelColor[1], labelColor[2],labelColor[3], labelColor[4])
							cell:SetText(tostring(v[idx2].value))
						end
						
					end
				end
				
				if #v < #LayoutRows[idx - rowPos+1] then
					for idx2 = #v+1, #LayoutRows[idx - rowPos + 1], 1 do
						local cell = LayoutRows[idx - rowPos + 1][idx2]						
						if cell:IsTexture() then
							cell:SetVisible(false)
						else
							cell:SetText('')
						end
					end
				end
			end
		end
		
		if highlightedRow ~= nil then grid:RowHighlight(highlightedRow, true) end		
		if selectedRow ~= nil and selectedRow >= rowPos and selectedRow <= rowPos + (rows -1) then 		
			grid:RowSelect(selectedRow, true) 
		end
		
	end
	
	-- row highlighting --
	
	function grid:RowHighlight (row, active)
		if LayoutRows == nil or LayoutRows[row] == nil then return end 
	
		for idx = 1, #LayoutRows[row], 1 do
		
			local cell = LayoutRows[row][idx]		
			local specColor = nil
			
			if rowPos ~= nil then
				if cellValues[rowPos + row - 1] == nil then return end
				local cellValue = cellValues[rowPos + row - 1][idx] 
				if cellValue ~= nil then
					if type(cellValue) == 'table' and cellValue.color ~= nil and cellValue.color ~= bodyHighlightColor then specColor = cellValue.color end
				end
			end
			
			if active == true then
				cell:SetBodyColor(bodyHighlightColor[1], bodyHighlightColor[2], bodyHighlightColor[3], bodyHighlightColor[4])

				if specColor == nil then
					cell:SetLabelColor (labelHighlightColor[1], labelHighlightColor[2], labelHighlightColor[3], labelHighlightColor[4])
				else
					if specColor[1] == bodyHighlightColor[1] and specColor[2] == bodyHighlightColor[2] and specColor[3] == bodyHighlightColor[3] and specColor[4] == bodyHighlightColor[4] then
						cell:SetLabelColor (labelHighlightColor[1], labelHighlightColor[2], labelHighlightColor[3], labelHighlightColor[4])
					else
						cell:SetLabelColor (specColor[1], specColor[2], specColor[3], specColor[4])
					end
				end
			else
				cell:SetBodyColor(bodyColor[1], bodyColor[2], bodyColor[3], bodyColor[4])

				if specColor == nil then
					cell:SetLabelColor (labelColor[1], labelColor[2], labelColor[3], labelColor[4])
				else
					cell:SetLabelColor (specColor[1], specColor[2], specColor[3], specColor[4])
				end
			end
		end
		
	end
	
	-- row selection --
	
	function grid:RowSelect (row, active)

		if active == true and selectedRow ~= nil and selectedRow >= rowPos and selectedRow <= rowPos + (rows -1) then grid:RowSelect(selectedRow, false) end
		
		if active == true then 
			selectedRow = row 
		else
			selectedRow = nil
		end		
	
		local gridRow = row - rowPos + 1
		
		if LayoutRows[gridRow] == nil then return end
		
		for idx = 1, #LayoutRows[gridRow], 1 do
		
			local cell = LayoutRows[gridRow][idx]		
			local specColor = nil
			
			if rowPos ~= nil then
				if cellValues[gridRow] == nil then return end
				local cellValue = cellValues[gridRow][idx] 
				if cellValue ~= nil then
					if type(cellValue) == 'table' and cellValue.color ~= nil and cellValue.color ~= bodySelectedColor then specColor = cellValue.color end
				end
			end
			
			if active == true then
				cell:SetBodyColor(bodySelectedColor[1], bodySelectedColor[2], bodySelectedColor[3], bodySelectedColor[4])

				if specColor == nil then
					cell:SetLabelColor (labelSelectedColor[1], labelSelectedColor[2], labelSelectedColor[3], labelSelectedColor[4])
				else
					cell:SetLabelColor (specColor[1], specColor[2], specColor[3], specColor[4])
				end
			else
				cell:SetBodyColor(bodyColor[1], bodyColor[2], bodyColor[3], bodyColor[4])

				if specColor == nil then
					cell:SetLabelColor (labelColor[1], labelColor[2], labelColor[3], labelColor[4])
				else
					cell:SetLabelColor (specColor[1], specColor[2], specColor[3], specColor[4])
				end
			end
		end
		
	end
	
	function grid:SetSelectable (flag) 
		selectable = flag 
		if selectable == false and selectedRow ~= nil then grid:RowSelect(selectedRow, false) end
	end

	function grid:GetSelectedRow() return selectedRow end
	
	-- rowPos functions
	
	function grid:GetRowPos()
		return rowPos
	end
	
	function grid:SetRowPos(setToPos, updateGrid)

		if setToPos == nil or setToPos < 1 then return end
		if cellValues == nil then return end
		
		if setToPos > (#cellValues - rows + 1) then return end
		
		rowPos = setToPos
		
		if updateGrid == true then self:UpdateGrid() end

	end
		
	function grid:GetKey(rowPos) 

		if cellValues == nil then return nil end
		if cellValues[rowPos] == nil then return nil end

		for k, v in pairs (cellValues[rowPos]) do
			if v.key ~= nil then return v.key end
		end

		return nil

	end
	
	function grid:GetCell(row, cell)
		return LayoutRows[row][cell]
	end
	
	function grid:SetSortable(flag)
		sortable = flag
	end
	
	function grid:Sort(col)
		if sortAscending == true then sortAscending = false else sortAscending = true end
		if #cellValues == 0 then return end
		
		local testValue = cellValues[1][col] 
		if type(testValue) == 'table' then
			if sortAscending == true then	 
				table.sort (cellValues, function (v1, v2) return v1[col].value < v2[col].value end )
			else
				table.sort (cellValues, function (v1, v2) return v1[col].value > v2[col].value end )
			end
		else
			if sortAscending == true then	
				table.sort (cellValues, function (v1, v2) return v1[col] < v2[col] end )
			else
				table.sort (cellValues, function (v1, v2) return v1[col] > v2[col] end )
			end
		end
		
		grid:SetRowPos(1, false)
		grid:SetCellValues()		
		
	end
	
	function grid:filter (searchValue, col, reset)

		if searchValue == nil or (reset ~= true and searchValue == '') or cellValues == nil then return end
		if col == nil or col == 0 or col > #LayoutRows[1] then return end	
		if reset == true and backupFilter == nil then return end
		
		if reset ~= true then 
			if backupFilter == nil then backupFilter = EnKai.tools.table.copy(cellValues) end
		end
			
		local values = {}
		
		for k, v in pairs(backupFilter) do
		
			if reset == true then
				table.insert (values, v)
			else
				local compareValue = nil
				if type(v[col]) == 'table' then		
					compareValue = string.upper(v[col].value)
				else
					compareValue = string.upper(v[col])
				end
				
				if string.find(compareValue, string.upper(searchValue)) ~= nil then table.insert (values, v) end
			end
		end
		
		if reset == true then backupFilter = nil end
		
		grid:SetCellValues(values)
	end
	
	-- set grid events --
	
	grid:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function ()
		
		local mouse = Inspect.Mouse()
		if mouse.y < grid:GetTop() + headerHeight then return end
		
		local rowNo = math.floor((mouse.y - (grid:GetTop() + headerHeight)) / (cellHeight-1)) + 1
		if rowNo > rows then rowNo = rows end
		
		if rowNo == highlightedRow then return end
		if highlightedRow ~= nil then 		
			if (highlightedRow + rowPos - 1)== selectedRow then
				grid:RowSelect(selectedRow, true) 
			else
				grid:RowHighlight(highlightedRow, false) 
			end
		end
		
		grid:RowHighlight(rowNo, true)
		highlightedRow = rowNo
		
		EnKai.eventHandlers[name]["MouseOver"](rowNo)
				
	end, name .. "_MouseCursorMove")
	
	grid:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function ()
		if highlightedRow ~= nil then 
			if highlightedRow == selectedRow then
				grid:RowSelect(selectedRow, true) 
			else
				grid:RowHighlight(highlightedRow, false) 
			end
		end
		EnKai.eventHandlers[name]["MouseOut"]()
	end, name .. "_MouseCursorOut")
	
	grid:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		local mouse = Inspect.Mouse()
		if mouse.y < grid:GetTop() + headerHeight then
			if sortable == false then return end
			local pos = mouse.x - grid:GetLeft()
			local start = 0
			for idx = 1, #cols, 1 do
				if pos >= start and pos <= start + cols[idx].width then
					grid:Sort(idx)
					return
				end
				start = start + cols[idx].width
			end
		else
			local rowNo = math.floor((mouse.y - (grid:GetTop() + headerHeight)) / (cellHeight -1)) + rowPos
			
			if selectable == true then
				if rowNo == selectedRow then
					grid:RowSelect(rowNo, false)
				else
					grid:RowSelect(rowNo, true)
				end
			end
			
			EnKai.eventHandlers[name]["LeftClick"](rowNo)
		end
	end, name .. "LeftClick")
	
	grid:EventAttach(Event.UI.Input.Mouse.Right.Click, function ()
		local mouse = Inspect.Mouse()
		if mouse.y < grid:GetTop() + headerHeight then return end
		local rowNo = math.floor((mouse.y - (grid:GetTop() + headerHeight)) / (cellHeight -1)) + rowPos
		EnKai.eventHandlers[name]["RightClick"](rowNo)
	end, name .. "RightClick")
	
	grid:EventAttach(Event.UI.Input.Mouse.Wheel.Forward, function ()
		if rowPos == nil then return nil end
		rowPos = rowPos -1
		if rowPos <= 0 then rowPos = 1 end
		
		if highlightedRow ~= nil then grid:RowHighlight(highlightedRow, false) end
		
		grid:UpdateGrid()
		EnKai.eventHandlers[name]["WheelForward"](rowPos)
	end, name .. "_MouseWheelForward")
	
	grid:EventAttach(Event.UI.Input.Mouse.Wheel.Back, function ()
		if rowPos == nil then return nil end
		rowPos = rowPos + 1
		local max = #cellValues - (rows - 1)
		if max < 1 then max = 1 end
		if rowPos > max then rowPos = max end
		
		if highlightedRow ~= nil then  grid:RowHighlight(highlightedRow, false) end
		grid:UpdateGrid()
		EnKai.eventHandlers[name]["WheelBack"](rowPos)
	end, name .. "_MouseWheelBack")
	
	EnKai.eventHandlers[name] = {}
	EnKai.events[name] = {}
	EnKai.eventHandlers[name]["GridFinished"], EnKai.events[name]["GridFinished"] = Utility.Event.Create(addonInfo.identifier, name .. "GridFinished")
	EnKai.eventHandlers[name]["LeftClick"], EnKai.events[name]["LeftClick"] = Utility.Event.Create(addonInfo.identifier, name .. "LeftClick")
	EnKai.eventHandlers[name]["RightClick"], EnKai.events[name]["RightClick"] = Utility.Event.Create(addonInfo.identifier, name .. "RightClick")
	EnKai.eventHandlers[name]["MouseOver"], EnKai.events[name]["MouseOver"] = Utility.Event.Create(addonInfo.identifier, name .. "MouseOver")
	EnKai.eventHandlers[name]["MouseOut"], EnKai.events[name]["MouseOut"] = Utility.Event.Create(addonInfo.identifier, name .. "MouseOut")
	EnKai.eventHandlers[name]["WheelForward"], EnKai.events[name]["WheelForward"] = Utility.Event.Create(addonInfo.identifier, name .. "WheelForward")
	EnKai.eventHandlers[name]["WheelBack"], EnKai.events[name]["WheelBack"] = Utility.Event.Create(addonInfo.identifier, name .. "WheelBack")
	
	return grid
	
end