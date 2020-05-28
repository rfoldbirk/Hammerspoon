local log = hs.logger.new('Windows', 'debug')

height = 808

local lastPick = ""
local divider = 2


directionKeyEventtap = hs.eventtap.new( 
{
	hs.eventtap.event.types.keyDown,
	hs.eventtap.event.types.flagsChanged,
}, 
function(event)
	key = hs.keycodes.map[event:getKeyCode()]

	if not (key == 'up' or key == 'down' or key == 'right' or key == 'left') then
		return
	end

	f = event:getFlags()

	flagged = f:contain({"alt", "cmd"})

	-- log.i(flagged, key)

	if not flagged then
		if key == "left" then
			insertPoint = insertPoint + 1
			if f:contain({"cmd"}) then
				insertPoint = #keypress_history
			end
		elseif key == "right" then
			insertPoint = insertPoint - 1
			if f:contain({"cmd"}) then
				insertPoint = 0
			end
			if insertPoint < 0 then
				insertPoint = 0
			end
		end
		return
	end

	local win = hs.window.focusedWindow()
	local app = win:frame()
	local window = win:screen():frame()


	-- default
	app.x = window.x
	app.y = window.y
	app.w = window.w
	app.h = height

	if key == lastPick then
		divider = divider + 1
	else
		divider = 2
		lastPick = key
	end

	if key == "left" then
		app.w = window.w / divider
		app.x = window.x
	elseif key == "right" then
		app.w = window.w / divider
		app.x = window.w - app.w
	elseif key == "down" then
		app.h = height / 2
		app.y = height - height / 2 + 92/4
	end
	win:setFrame(app)

	event:setType(0)

end)



directionKeyEventtap:start()