local addonInfo, privateVars = ...

if not EnKai then EnKai = {} end
if not EnKai.events then EnKai.events = {} end

EnKai.eventHandlers = {}
--EnKai.events = {}

function EnKai.events.updateHandler()

	EnKai.coroutines.process ()
	EnKai.fx.process()
	--EnKai.uiGarbageCollector () -- missing SetName() on frames to fully build this

end

Command.Event.Attach(Event.System.Update.Begin, EnKai.events.updateHandler, "EnKai.uiUpdateHandler")