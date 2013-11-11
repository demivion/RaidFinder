local addonInfo, privateVars = ...

function EnKai.ui.nkFrame(name, parent) 

	local frame = UI.CreateFrame ('Frame', name, parent)	

	local events = {}

	function frame:_recycle()
	end

	function frame:recycle()
		EnKai.uiAddToGarbageCollector ('nkFrame', frame)  
	end	
	
	local oEventAttach, oEventDetach = frame.EventAttach, frame.EventDetach
		
	function frame:EventAttach(handle, callback, label, priority)
		oEventAttach(handle, callback, label, priority)
		events[handle] = {callback = callback, label = label, priority = priority}		
	end	
	
	function frame:EventDetach(handle, callback, label, priority, owner)
		oEventDetach(handle, callback, label, priority, owner)
		events[handle] = nil		
	end
	
	function frame:GetEvents()
		return events
	end

	return frame
	
end