local addonInfo, privateVars = ...

function EnKai.ui.nkItemTooltip(name, parent) 

	local defaultTitleColor = {1, 1, 1, 1}
	local defaultSubTitleColor = {1, 1, 1, 1}	
	local defaultLinesColor = {1, 1, 1, 1}	
	local defaultBorderColor = { 0.557, 0.553, 0.431, 1 }
	
	local defaultWidth = 225

	local tooltip = UI.CreateFrame ('Frame', name, parent)
	local tooltipInner = UI.CreateFrame ('Frame', name .. '.inner', tooltip)
	local title = UI.CreateFrame ('Text', name .. '.title', tooltipInner)
	local bound = UI.CreateFrame ('Text', name .. '.bop', tooltipInner)
	local itemCat = UI.CreateFrame ('Text', name .. '.cat', tooltipInner)
	local itemType = UI.CreateFrame ('Text', name .. '.type', tooltipInner)
	local dps = UI.CreateFrame ('Text', name .. '.dps', tooltipInner)
	local equip = UI.CreateFrame ('Text', name .. '.equip', tooltipInner)
	local use = UI.CreateFrame ('Text', name .. '.use', tooltipInner)
	local level = UI.CreateFrame ('Text', name .. '.level', tooltipInner)
	local faction = UI.CreateFrame ('Text', name .. '.faction', tooltipInner)
	local calling = UI.CreateFrame ('Text', name .. '.calling', tooltipInner)
	local set = UI.CreateFrame ('Text', name .. '.set', tooltipInner)
	local costLabel = UI.CreateFrame ('Text', name .. '.costLabel', tooltipInner)
	local costCurrencyIcon = UI.CreateFrame ('Texture', name .. '.costCurrencyIcon', tooltipInner)
	local costCurrencyText = UI.CreateFrame ('Text', name .. '.costCurrency', tooltipInner)
	local costShopIcon = UI.CreateFrame ('Texture', name .. '.costShopIcon', tooltipInner)
	local costShopText = UI.CreateFrame ('Text', name .. '.costShop', tooltipInner)
	local upgradeText =  UI.CreateFrame ('Text', name .. '.upgradeText', tooltipInner)
	local upgradeItem1 = UI.CreateFrame ('Texture', name .. '.upgradeItem1', tooltipInner)
	local upgradeCount1 = UI.CreateFrame ('Text', name .. '.upgradeCount1', tooltipInner)
	local upgradeItem2 = UI.CreateFrame ('Texture', name .. '.upgradeItem2', tooltipInner)
	local upgradeCount2 = UI.CreateFrame ('Text', name .. '.upgradeCount2', tooltipInner)
	local upgradeItem3 = UI.CreateFrame ('Texture', name .. '.upgradeItem3', tooltipInner)
	local upgradeCount3 = UI.CreateFrame ('Text', name .. '.upgradeCount3', tooltipInner)
	
	local stats = {}
	
	local riftDetails = nil
	local nkDetails = nil

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
	
	title:SetWordwrap(true)
	title:SetFontSize(15)
	title:SetFontColor(defaultTitleColor[1], defaultTitleColor[2], defaultTitleColor[3], defaultTitleColor[4])
		
	bound:SetPoint ("TOPLEFT", title, "BOTTOMLEFT", 0, -3)
	bound:SetFontSize(12)
	bound:SetFontColor(1, 1, 1, 1)
	bound:SetWidth(defaultWidth- 4)
	
	itemCat:SetPoint("TOPLEFT", bound, "BOTTOMLEFT", 0, -3)
	itemCat:SetFontSize(12)
	itemCat:SetFontColor(1, 1, 1, 1)
	itemCat:SetWidth(defaultWidth- 4)
	
	itemType:SetPoint("CENTERRIGHT", itemCat, "CENTERRIGHT")
	itemType:SetFontSize(12)
	itemType:SetFontColor(1, 1, 1, 1)
	
	dps:SetPoint("TOPLEFT", itemCat, "BOTTOMLEFT", 0, 10)
	dps:SetFontSize(12)
	dps:SetWordwrap(true)
	dps:SetWidth(defaultWidth-4)
	dps:SetFontColor(1, 1, 1, 1)
	
	equip:SetFontSize(12)
	equip:SetFontColor (1,1,1,1)
	equip:SetWidth(defaultWidth-4)
	equip:SetWordwrap(true)
	
	use:SetFontSize(12)
	use:SetFontColor (1,1,1,1)
	use:SetWidth(defaultWidth-4)
	use:SetWordwrap(true)
	
	set:SetFontSize(12)
	set:SetFontColor(0.455, 0.929, 0.882, 1)
	set:SetWidth(defaultWidth-4)
	set:SetWordwrap(true)
	
	costLabel:SetFontSize(12)
	costLabel:SetFontColor(1, 1, 1, 1)
	costLabel:SetWordwrap(false)
	costLabel:SetText(nkItemBase.texts.cost)
	
	costCurrencyIcon:SetWidth(14)
	costCurrencyIcon:SetHeight(14)
	
	costCurrencyText:SetFontSize(12)
	costCurrencyText:SetFontColor(1, 1, 1, 1)
	--costCurrencyText:SetWidth(defaultWidth-20)
	costCurrencyText:SetWordwrap(false)
	costCurrencyText:SetPoint("CENTERLEFT", costCurrencyIcon, "CENTERRIGHT", 2, 0)
	
	costShopIcon:SetTextureAsync("EnKai", "gfx/shopCurrency.png")
	costShopIcon:SetWidth(14)
	costShopIcon:SetHeight(14)
	
	costShopText:SetFontSize(12)
	costShopText:SetFontColor(1, 1, 1, 1)
	--costShopText:SetWidth(defaultWidth-20)
	costShopText:SetWordwrap(false)
	costShopText:SetPoint("CENTERLEFT", costShopIcon, "CENTERRIGHT", 2, 0)
	
	upgradeText:SetFontSize(12)
	upgradeText:SetFontColor(1, 1, 1, 1)
	upgradeText:SetWordwrap(false)
	upgradeText:SetText(nkItemBase.texts.upgrade)
	
	upgradeItem1:SetPoint("CENTERLEFT", upgradeText, "CENTERRIGHT", 2, 0)
	upgradeItem1:SetWidth(16)
	upgradeItem1:SetHeight(16)
	
	upgradeCount1:SetPoint("CENTERLEFT", upgradeItem1, "CENTERRIGHT", 2, 0)
	upgradeCount1:SetFontColor(1, 1, 1, 1)
	upgradeCount1:SetWordwrap(false)
	
	upgradeItem2:SetPoint("CENTERLEFT", upgradeCount1, "CENTERRIGHT", 2, 0)
	upgradeItem2:SetWidth(16)
	upgradeItem2:SetHeight(16)
	
	upgradeCount2:SetPoint("CENTERLEFT", upgradeItem2, "CENTERRIGHT", 2, 0)
	upgradeCount2:SetFontColor(1, 1, 1, 1)
	upgradeCount2:SetWordwrap(false)
	
	upgradeItem3:SetPoint("CENTERLEFT", upgradeCount2, "CENTERRIGHT", 2, 0)
	upgradeItem3:SetWidth(16)
	upgradeItem3:SetHeight(16)
	
	upgradeCount3:SetPoint("CENTERLEFT", upgradeItem3, "CENTERRIGHT", 2, 0)
	upgradeCount3:SetFontColor(1, 1, 1, 1)
	upgradeCount3:SetWordwrap(false)
	
	--level:SetPoint("TOPLEFT", dps, "BOTTOMLEFT")
	level:SetFontSize(12)
	level:SetFontColor (1,1,1,1)
	
	faction:SetFontSize(12)
	faction:SetFontColor (1,1,1,1)
	faction:SetWordwrap(true)
	
	calling:SetPoint("TOPLEFT", level, "BOTTOMLEFT")
	calling:SetFontSize(12)
	calling:SetFontColor (1,1,1,1)
	
	function tooltip:SetItem(itemID, itemLibDetails)
	
		local err, details = pcall (Inspect.Item.Detail, itemID)
		if err == true then
			tooltip:SetItemDetails(details, itemLibDetails)
		end
	
		local tooltipCoRoutine = coroutine.create(
		   function ()
				for idx = 1, 10, 1 do
					local err, details = pcall (Inspect.Item.Detail, itemID)
					if err == true then 
						tooltip:SetItemDetails(details, itemLibDetails)
						coroutine.yield(nil)
					end		
					coroutine.yield(idx)
				end
		end)

		table.insert(privateVars.coRoutines, { func = tooltipCoRoutine, counter = 10, active = true })	
	end
	
	function tooltip:SetItemDetails(details, itemLibDetails)
	
		local visible = tooltip:GetVisible()
		tooltip:SetVisible(false)
	
		riftDetails = details
		nkDetails = itemLibDetails
		
		local object = title
		local height = 6
		
		title:ClearAll()
		title:SetPoint ("TOPLEFT", tooltip, "TOPLEFT")
		title:SetWidth(defaultWidth - 4)
	
		if itemLibDetails ~= nil and itemLibDetails.augmented == true then	
			title:SetText(itemLibDetails.name)
		else
			title:SetText(details.name)
		end
		
		height = height + title:GetHeight()
		
		local color = {trash = {0.502, 0.502, 0.502, 1}, sellable = {1, 1, 1, 1}, uncommon = {0.149, 0.498, 0, 1}, rare = { 0.278, 0.467, 0.718, 1 }, epic = { 0.596, 0.365, 0.788, 1 }, relic = { 1, 0.416, 0, 1 }, transcendant = {1, 1, 1, 1}, quest = {1, 0.847, 0, 1}}
		
		if details.rarity == nil then
			title:SetFontColor (color.trash[1], color.trash[2], color.trash[3], color.trash[4])
		else
			title:SetFontColor (color[details.rarity][1], color[details.rarity][2], color[details.rarity][3], color[details.rarity][4])
		end
		
		if details.bind ~= nil then		
			bound:SetText(privateVars.langTexts.boundText[details.bind])
			height = height + bound:GetHeight() -4
			itemCat:SetPoint("TOPLEFT", bound, "BOTTOMLEFT", 0, -3)
			bound:SetVisible(true)
			object = bound
		else
			bound:SetVisible(false)
			itemCat:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -3)
		end

		local riftSlot, itemTypeText = nil
		
		--if EnKai.items.getRessource ('riftCategoryToType', details.category) ~= nil then riftSlot = EnKai.items.getRessource ('riftCategoryToType', details.category) end
		if EnKai.items.translateRiftCategory (details.category) ~= nil then riftSlot = EnKai.items.translateRiftCategory (details.category) end
		
		if riftSlot ~= nil then
		
			itemTypeText = EnKai.items.getRessource ('itemTypeTranslation', riftSlot)
			
			if itemTypeText == nil then
				EnKai.tools.error.display (addonInfo.toc.Identifier, string.format("itemTooltip could not get item type for rift slot %s", riftSlot), 2)
				itemCat:SetVisible(false)
				itemType:SetVisible(false)
			else
			
				if string.find(itemTypeText, " ") == nil then
					itemCat:SetText(itemTypeText)
					itemType:SetText("")
				else
					itemCat:SetText(EnKai.strings.leftBack (itemTypeText, " "))
					itemType:SetText(EnKai.strings.rightBack(itemTypeText, " "))
				end			
			
				itemCat:SetVisible(true)
				itemType:SetVisible(true)
			
				height = height + itemCat:GetHeight() -4
				object = itemCat
			end
		else
			itemCat:SetVisible(false)
			itemType:SetVisible(false)
		end
		
		if details.damageMin ~= nil then		
			local dpsValue = (details.damageMax + details.damageMin) / 2 / details.damageDelay
			dps:SetText (string.format (privateVars.langTexts.dps, dpsValue, details.damageMax, details.damageMin, details.damageDelay))
			dps:SetVisible(true)
			object = dps
			height = height + dps:GetHeight() + 10
		else
			dps:SetVisible(false)
		end
		
		local counter = 1
		local y = 10
		
		if (itemLibDetails == nil or itemLibDetails.augmented ~= true) and details.stats ~= nil then
		
			local statList = {	'armor', 'dexterity', 'strength', 'endurance', 'parry', 'intelligence', 'wisdom', 'powerSpell', 'critSpell', 'focus', 'block',
								'toughness', 'powerAttack', 'critAttack', 'critPower', 'hit', 'dodge', 'resistWater', 'resistFire', 'resistEarth',
								'resistLife', 'resistDeath', 'resistAir', 'resistAll', 'valor', 'deflect', 'vengeance' }
				
			for _, v in pairs (statList) do
				
				if details.stats[v] ~= nil then
				
					local statLine = stats[counter]
					if statLine == nil then
						statLine = UI.CreateFrame ('Text', name .. '.stats.' .. counter, tooltipInner)
						statLine:SetFontSize(12)
						statLine:SetFontColor(1,1,1,1)
						
						table.insert(stats, statLine)				
					end  
					
					statLine:SetPoint("TOPLEFT", object, "BOTTOMLEFT", 0, y)
					statLine:SetText(string.format("%s: +%d", privateVars.langTexts.stats[v], details.stats[v]))
					statLine:SetVisible(true)
					height = height + statLine:GetHeight() + y
					
					object = statLine
					y = -3
					counter = counter + 1
				end
			end	
		
			if counter <= #stats then
				for idx = counter, #stats, 1 do
					stats[idx]:SetVisible(false)
				end
			end
		elseif itemLibDetails ~= nil then
			local statList = {'armor', 'dex', 'str', 'endu', 'parry', 'int', 'wis', 'sp', 'scrit', 'focus', 'block', 'tough', 'atp', 'crit', 'cp', 'hit', 'dodge', 'resiW', 'resiF', 'resiE', 'resiL', 'resiD', 'resiA', 'resiAll', 'hm', 'defl', 'veng' }
			local labelist = {	armor = 'armor', dex = 'dexterity', str = 'strength', endu = 'endurance', parry = 'parry', int = 'intelligence', wis = 'wisdom', sp = 'powerSpell', scrit = 'critSpell', focus = 'focus', block = 'block',
								tough = 'toughness', atp = 'powerAttack', crit = 'critAttack', cp = 'critPower', hit = 'hit', dodge = 'dodge', resiW = 'resistWater', resiF = 'resistFire', resiE = 'resistEarth',
								resiL = 'resistLife', resiD = 'resistDeath', resiA = 'resistAir', resiAll = 'resistAll', hm = 'valor' , defl = 'deflect', veng = 'vengeance' }
			
			for k, v in pairs (statList) do
				if itemLibDetails[v] ~= nil then
					local statLine = stats[counter]
					if statLine == nil then
						statLine = UI.CreateFrame ('Text', name .. '.stats.' .. counter, tooltipInner)
						statLine:SetFontSize(12)
						statLine:SetFontColor(1,1,1,1)
						
						table.insert(stats, statLine)				
					end  
					
					statLine:SetPoint("TOPLEFT", object, "BOTTOMLEFT", 0, y)
					statLine:SetText(string.format("%s: +%d", privateVars.langTexts.stats[labelist[v]], itemLibDetails[v]))
					statLine:SetVisible(true)
					height = height + statLine:GetHeight() + y
					
					object = statLine
					y = -3
					counter = counter + 1
				end
			end
			
			if counter <= #stats then
				for idx = counter, #stats, 1 do
					stats[idx]:SetVisible(false)
				end
			end
		else
			for idx = 1, #stats, 1 do
				stats[idx]:SetVisible(false)
			end			
		end
		
		y = 10
		
		if itemLibDetails ~= nil then
		
			local useText = itemLibDetails['use' .. EnKai.tools.lang.getLanguageShort () ]
		
			if useText ~= nil then
				use:SetText (string.format(privateVars.langTexts.use, useText))
				use:SetPoint("TOPLEFT", object, "BOTTOMLEFT", 0, y)
				use:SetVisible(true)
				height = height + use:GetHeight() + y
				object = use
				y = 10
			else
				use:SetVisible(false)
			end
			
			local equipText = itemLibDetails['equip' .. EnKai.tools.lang.getLanguageShort () ]
			
			if equipText ~= nil then
				equip:SetText (string.format(privateVars.langTexts.equip, equipText))
				equip:SetPoint("TOPLEFT", object, "BOTTOMLEFT", 0, y)
				equip:SetVisible(true)
				height = height + equip:GetHeight() + y
				object = equip
				y = 10
			else
				equip:SetVisible(false)
			end
		else
			use:SetVisible(false)
			equip:SetVisible(false) 			
		end
		
		if itemLibDetails ~= nil then
		
			local setText = itemLibDetails['itemSet' .. EnKai.tools.lang.getLanguageShort () ]
		
			if setText ~= nil then
				local text = setText
			
				local setBoni = itemLibDetails['itemSetBonus']
				if setBoni ~= nil then
					for idx = 1, #setBoni, 1 do
						text = text .. "\n" .. setBoni[idx][1] .. ": "
						if EnKai.tools.lang.getLanguageShort () == "DE" then
							text = text .. setBoni[idx][2]
						elseif EnKai.tools.lang.getLanguageShort () == "FR" then
							text = text .. setBoni[idx][4]
						else
							text = text .. setBoni[idx][3]
						end
					end
				end
				
				set:SetText (text)
				set:SetPoint("TOPLEFT", object, "BOTTOMLEFT", 0, y)
				set:SetVisible(true)
				height = height + set:GetHeight() + y
				object = set
				y = 10
				
				
				
			else
				set:SetVisible(false)
			end
		else
			set:SetVisible(false)
		end
		
		if details.requiredLevel ~= nil then
			level:SetText (string.format(privateVars.langTexts.requiredLevel, details.requiredLevel))
			level:SetPoint("TOPLEFT", object, "BOTTOMLEFT", 0, y)
			level:SetVisible(true)
			height = height + level:GetHeight() + y
			object = level
			y = -3
		else
			level:SetVisible(false)
		end
			
		if details.requiredCalling ~= nil then
			local callingText = nil
			local tempCallings = EnKai.strings.split(details.requiredCalling, " ")
			for k, v in pairs (tempCallings) do
				if callingText ~= nil then
					callingText = callingText .. ', ' .. privateVars.langTexts.callings[v]
				else
					callingText = privateVars.langTexts.callings[v]
				end
			end
		
			calling:SetText (string.format(privateVars.langTexts.requiredCalling, callingText))
			calling:SetPoint("TOPLEFT", object, "BOTTOMLEFT", 0, y)
			calling:SetVisible(true)
			object = calling
			height = height + calling:GetHeight() + y
			y = -3
		else
			calling:SetVisible(false)
		end
		
		if itemLibDetails ~= nil and itemLibDetails.rfl ~= nil then
			local levelText = privateVars.langTexts.factionList[itemLibDetails.rfl]
			local factionText = itemLibDetails.rf
			if privateVars.langTexts.factionNames ~= nil and privateVars.langTexts.factionNames[factionText] ~= nil then factionText = privateVars.langTexts.factionNames[factionText] end
			local text = string.format(privateVars.langTexts.requiredFaction, factionText, levelText)
			faction:SetText (text)
			faction:SetPoint("TOPLEFT", object, "BOTTOMLEFT", 0, y)
			faction:SetVisible(true)
			height = height + faction:GetHeight() + y
			object = faction
			y = -3
		else
			faction:SetVisible(false)
		end
		
		costLabel:SetVisible(false)
		costCurrencyIcon:SetVisible(false)
		costCurrencyText:SetVisible(false)
		costShopIcon:SetVisible(false)
		costShopText:SetVisible(false)
		
		upgradeText:SetVisible(false)
		upgradeItem1:SetVisible(false)
		upgradeCount1:SetVisible(false)
		upgradeItem2:SetVisible(false)
		upgradeCount2:SetVisible(false)
		upgradeItem3:SetVisible(false)
		upgradeCount3:SetVisible(false)

		if itemLibDetails ~= nil then
		
			if itemLibDetails.isupgrade == 1 then
			
				if itemLibDetails.cost ~= nil then
					y = 10
				
					upgradeText:SetPoint("TOPLEFT", object, "BOTTOMLEFT", 0, y)
					upgradeText:SetVisible(true)
				
					local counter = 1
				
					for k, v in pairs (itemLibDetails.cost) do
						local upgradeItemDetails = nkItemBase.Query.byKey(k, false, "consumable", false)
						if upgradeItemDetails == nil then upgradeItemDetails = nkItemBase.Query.byKey(k, false, nil, false) end
					
						if upgradeItemDetails ~= nil then
							if counter == 1 then
								upgradeItem1:SetTextureAsync("Rift", string.format('Data/\\UI\\item_icons\\%s.dds', upgradeItemDetails.icon))											
								upgradeCount1:SetText(tostring(v))
								upgradeItem1:SetVisible(true)
								upgradeCount1:SetVisible(true)
							elseif counter == 2 then
								upgradeItem2:SetTextureAsync("Rift", string.format('Data/\\UI\\item_icons\\%s.dds', upgradeItemDetails.icon))
								upgradeCount2:SetText(tostring(v))											
								upgradeItem2:SetVisible(true)
								upgradeCount2:SetVisible(true)
							else
								upgradeItem3:SetTextureAsync("Rift", string.format('Data/\\UI\\item_icons\\%s.dds', upgradeItemDetails.icon))
								upgradeCount3:SetText(tostring(v))											
								upgradeItem3:SetVisible(true)
								upgradeCount3:SetVisible(true)
							end
							
							counter = counter + 1
						end						
					end			
				
					object = upgradeText
					height = height + upgradeText:GetHeight() + y
					y = 5
				end 
				
			elseif itemLibDetails.cost ~= nil and type(itemLibDetails.cost) ~= 'string' then
				y = 10
				costLabel:SetVisible(true)
				costLabel:SetPoint("TOPLEFT", object, "BOTTOMLEFT", 0, y)
	
				local costObject = costLabel
				
				for k, v in pairs (itemLibDetails.cost) do
					if k == "shop" then
						costShopIcon:SetPoint("CENTERLEFT", costObject, "CENTERRIGHT", 5, 0)
						costShopText:SetText(tostring(v))
						costShopText:SetVisible(true)
						costShopIcon:SetVisible(true)
						costObject = costShopText
					else
						local currencyItem = nkItemBase.Query.byKey(k, false, "currency", false)
						
						if currencyItem ~= nil then
							costCurrencyIcon:SetPoint("CENTERLEFT", costObject, "CENTERRIGHT", 5, 0)
							costCurrencyIcon:SetTextureAsync("Rift", string.format('Data/\\UI\\item_icons\\%s.dds', currencyItem.icon))
							costCurrencyText:SetText(tostring(v))
							costCurrencyText:SetVisible(true)
							costCurrencyIcon:SetVisible(true)
							costObject = costCurrencyText
						end
					end
					counter = counter + 1
				end
				
				object = costLabel
				height = height + costLabel:GetHeight() + y
				y = 5
			end
		end
		
		
		tooltip:SetHeight(height)
		tooltip:SetWidth(defaultWidth)
		tooltip:SetVisible(visible)
		
	end
	
	function tooltip:GetDetails()
		return riftDetails, nkDetails
	end
	
	return tooltip
	
end