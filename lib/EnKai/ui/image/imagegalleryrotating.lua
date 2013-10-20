local addonInfo, privateVars = ...

function EnKai.ui.nkImageGallery(name, parent) 

	local imageGallery = UI.CreateFrame ('Frame', name, parent)
	
	local imageLeftSmallBorder = UI.CreateFrame ('Frame', name .. 'imageLeftSmallBorder', imageGallery)
	local imageLeftBorder = UI.CreateFrame ('Frame', name .. 'imageLeftBorder', imageGallery)
	local imageMainBorder = UI.CreateFrame ('Frame', name .. 'imageMainBorder', imageGallery)
	local imageRightBorder = UI.CreateFrame ('Frame', name .. 'imageRightBorder', imageGallery)
	local imageRightSmallBorder = UI.CreateFrame ('Frame', name .. 'imageRightSmallBorder', imageGallery)
	
	local imageLeftSmall = UI.CreateFrame ('Texture', name .. 'imageLeftSmall', imageLeftSmallBorder)
	local imageLeft = UI.CreateFrame ('Texture', name .. 'imageLeft', imageLeftBorder)
	local imageMain = UI.CreateFrame ('Texture', name .. 'imageMain', imageMainBorder)
	local imageRight = UI.CreateFrame ('Texture', name .. 'imageRight', imageRightBorder)
	local imageRightSmall = UI.CreateFrame ('Texture', name .. 'imageRightSmall', imageRightSmallBorder)
	
	local imageRotateLeft = UI.CreateFrame ('Texture', name .. 'imageRotateLeft', imageGallery)
	local imageRotateRight = UI.CreateFrame ('Texture', name .. 'imageRotateRight', imageGallery)
	
	local properties = {}

	function imageGallery:SetValue(property, value)
		properties[property] = value
	end
	
	function imageGallery:GetValue(property)
		return properties[property]
	end
	
	local currentPos = 1
	local imageList = {}
	
	imageGallery:SetWidth(192)
	imageGallery:SetHeight(50)
	
	imageMainBorder:SetBackgroundColor(0, 0, 0, 1)
	imageMainBorder:SetPoint("CENTER", imageGallery, "CENTER")
	imageMainBorder:SetWidth(50)
	imageMainBorder:SetHeight(50)
	imageMainBorder:SetLayer(3)
	
	imageLeftBorder:SetBackgroundColor(0, 0, 0, 1)
	imageLeftBorder:SetPoint("CENTERRIGHT", imageMainBorder, "CENTERLEFT", 10, 0)
	imageLeftBorder:SetWidth(40)
	imageLeftBorder:SetHeight(40)
	imageLeftBorder:SetLayer(2)
	
	imageLeftSmallBorder:SetBackgroundColor(0, 0, 0, 1)
	imageLeftSmallBorder:SetPoint("CENTERRIGHT", imageLeftBorder, "CENTERLEFT", 10, 0)
	imageLeftSmallBorder:SetWidth(30)
	imageLeftSmallBorder:SetHeight(30)
	imageLeftSmallBorder:SetLayer(1)
	
	imageRightBorder:SetBackgroundColor(0, 0, 0, 1)
	imageRightBorder:SetPoint("CENTERLEFT", imageMainBorder, "CENTERRIGHT", -10, 0)
	imageRightBorder:SetWidth(40)
	imageRightBorder:SetHeight(40)
	imageRightBorder:SetLayer(2)
	
	imageRightSmallBorder:SetBackgroundColor(0, 0, 0, 1)
	imageRightSmallBorder:SetPoint("CENTERLEFT", imageRightBorder, "CENTERRIGHT", -10, 0)
	imageRightSmallBorder:SetWidth(30)
	imageRightSmallBorder:SetHeight(30)
	imageRightSmallBorder:SetLayer(1)
	
	imageMain:SetPoint("TOPLEFT", imageMainBorder, "TOPLEFT", 2, 2)
	imageMain:SetPoint("BOTTOMRIGHT", imageMainBorder, "BOTTOMRIGHT", -2, -2)
	
	imageLeft:SetPoint("TOPLEFT", imageLeftBorder, "TOPLEFT", 2, 2)
	imageLeft:SetPoint("BOTTOMRIGHT", imageLeftBorder, "BOTTOMRIGHT", -2, -2)
	
	imageLeftSmall:SetPoint("TOPLEFT", imageLeftSmallBorder, "TOPLEFT", 2, 2)
	imageLeftSmall:SetPoint("BOTTOMRIGHT", imageLeftSmallBorder, "BOTTOMRIGHT", -2, -2)
	
	imageRight:SetPoint("TOPLEFT", imageRightBorder, "TOPLEFT", 2, 2)
	imageRight:SetPoint("BOTTOMRIGHT", imageRightBorder, "BOTTOMRIGHT", -2, -2)
	
	imageRightSmall:SetPoint("TOPLEFT", imageRightSmallBorder, "TOPLEFT", 2, 2)
	imageRightSmall:SetPoint("BOTTOMRIGHT", imageRightSmallBorder, "BOTTOMRIGHT", -2, -2)
	
	imageRotateLeft:SetPoint("CENTERRIGHT", imageLeftSmallBorder, "CENTERLEFT", -5 ,0 )
	imageRotateLeft:SetHeight(16)
	imageRotateLeft:SetWidth(16)
	imageRotateLeft:SetTextureAsync("EnKai", "gfx/arrowLeft.png")
	
	imageRotateRight:SetPoint("CENTERLEFT", imageRightSmallBorder, "CENTERRIGHT", 5 ,0 )
	imageRotateRight:SetHeight(16)
	imageRotateRight:SetWidth(16)
	imageRotateLeft:SetTextureAsync("EnKai", "gfx/arrowRight.png")
	
	imageRotateLeft:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		imageGallery:Rotate(false)
	end, name .. "imageRotateLeft.Left_Click")
	
	imageRotateRight:EventAttach(Event.UI.Input.Mouse.Left.Click, function ()
		imageGallery:Rotate(right)
	end, name .. "imageRotateRight.Left_Click")
	
	function imageGallery:Rotate(rotateRight)
	
		if rotateRight == true then 
			currentPos = curentPos + 1
			if currentPos > #imageList then currentPos = 1 end
		else
			currentPos = currentPos - 1
			if currentPos < 1 then currentPos = #imageList end
		end
		
		imageGallery:ShowImage()
		
	end
	
	function imageGallery:SetImages( newImageList )
		if #newImageList < 5 then return end
	
		imageList = newImageList
		currentPos = math.floor(#imageList/2) + 1
		imageGallery:ShowImages()
	end
	
	function imageGallery:SetDefaultImages()
	
		local newImageList = {}
	
		local slot = Utility.Item.Slot.All()
		local items = Inspect.Item.Detail (slot)
		
		for k, v in pairs (items) do
			table.insert (newImageList, { texturePath = v.icon, textureType = 'Rift' })
		end
		
		local abilityList = Inspect.Ability.New.List()
		local abilities = Inspect.Ability.New.Detail(abilityList)
		
		for k, v in pairs (abilities) do
			table.insert (newImageList, { texturePath = v.icon, textureType = 'Rift' })
		end		
		
		imageGallery:SetImages(newImageList)
	
	end
	
	function imageGallery:ShowImages ()
	
		imageMain:SetTexture( imageList[currentPos].textureType, imageList[currentPos].texturePath)			
	
		if currentPos > 1 then	
			imageLeft:SetTexture( imageList[currentPos-1].textureType, imageList[currentPos-1].texturePath)							
		else			
			imageLeft:SetTexture( imageList[#imageList+currentPos-1].textureType, imageList[currentPos+currentPos-1].texturePath)			
		end
		
		if currentPos > 2 then	
			imageLeftSmall:SetTexture( imageList[currentPos-2].textureType, imageList[currentPos-2].texturePath)							
		else			
			imageLeftSmall:SetTexture( imageList[#imageList+currentPos-2].textureType, imageList[currentPos+currentPos-2].texturePath)			
		end
		
		if currentPos <= #imageList -1 then
			imageRight:SetTexture( imageList[currentPos+1].textureType, imageList[currentPos+1].texturePath)			
		else
			imageRight:SetTexture( imageList[1].textureType, imageList[1].texturePath)			
		end
		
		if currentPos <= #imageList - 2 then
			imageRightSmall:SetTexture( imageList[currentPos+2].textureType, imageList[currentPos+2].texturePath)			
		else
			imageRightSmall:SetTexture( imageList[2 - (#imageList - currentPos)].textureType, imageList[2 - (#imageList - currentPos)].texturePath)			
		end

	end
	
	return imageGallery
	
end