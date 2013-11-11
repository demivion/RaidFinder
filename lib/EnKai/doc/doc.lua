local addonInfo, privateVars = ...

if not EnKai then EnKai = {} end
--if not EnKai.doc then EnKai.doc = {} end

function EnKai.doc (name, parent)

	local doc = EnKai.uiCreateFrame("nkWindowModern", name, parent)
	
	local docEmbedded = EnKai.docEmbedded(name .. '.doc', doc)
	docEmbedded:SetPoint("TOPLEFT", doc:GetContent(), "TOPLEFT")
	docEmbedded:Layout(20)
	
	doc:SetHeight(docEmbedded:GetHeight() + 20)	
	
	local oSetWidth, oSetHeight = doc.SetWidth, doc.SetHeight
		
	function doc:SetWidth(newWidth)
		oSetWidth(self, newWidth)
		docEmbedded:SetWidth(doc:GetContent():GetWidth())
	end
	
	function doc:SetHeight(newHeight)
		oSetHeight(self, newHeight)
		docEmbedded:SetHeight(doc:GetContent():GetHeight())
	end
	
	function doc:AddChapter(parentChapter, newTitle, newContent, updateFlag)
		docEmbedded:AddChapter(parentChapter, newTitle, newContent, updateFlag)
	end
	
	return doc

end 