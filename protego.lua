local log = hs.logger.new('Protego', 'debug')

local PASSWORD = "enht"

local str_arr = {}
local trigger_words = {"porn", "hentai", "gay", "homoseksuel", "nude", "loli", "vagina", "penis", "dick", "pik"}

local keycodes = hs.keycodes.map
local BACKSLASH_KEY = 51
local KeyDown_event = 10

local breach_detected = false
local allow_settings = false
local attemps_to_open_settings = 0
local breach_word = ""


local keyEventtap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local bundleId = string.lower(hs.application.frontmostApplication():bundleID())
    local keyCode = event:getKeyCode()
    local letter = keycodes[keyCode]

    
    if #str_arr > 25 then
        table.remove(str_arr, 1)
    end
    
    if (letter == "delete") then
        table.remove(str_arr, #str_arr)
    elseif (letter == "space") then
        str_arr[#str_arr + 1] = " "
    else
        str_arr[#str_arr + 1] = letter
    end
    

    local actual_string = ""
    
    for i = 1, #str_arr, 1 do
        actual_string = actual_string .. str_arr[i]
    end
    
    for i = 1, #trigger_words, 1 do
        if (string.match(actual_string:lower(), trigger_words[i])) then
            breach_word = trigger_words[i]
            
            -- slet ordet
            deleteWord(trigger_words[i])
            
            lock()
        end
        
        if (allow_settings == false and string.match(actual_string:lower(), hs.base64.decode(PASSWORD))) then
        	--deleteWord(hs.base64.decode(PASSWORD))
            
        	local oops = hs.eventtap.event.newKeyEvent({"cmd"}, 6, true)
	        oops:post()

            allow_settings = true
            str_arr = {}
            hs.application.launchOrFocus("/System/Applications/System Preferences.app")
            attemps_to_open_settings = 0
        end
    end
end):start()




local appWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
    if (appName ~= "System­indstillinger") then
        return
    end
    
    if (eventType == hs.application.watcher.activated) then
        if (allow_settings == false) then
            -- Bring all Finder windows forward when one gets activated
            appObject:kill()
            attemps_to_open_settings = attemps_to_open_settings + 1
            
            if (attemps_to_open_settings > 1) then
                breach_word = "forsøgte at åbne indstillingerne"
                lock()
            end
        end
    elseif (eventType == hs.application.watcher.terminated) then
        allow_settings = false
    end
end):start()


local unlockWatcher = hs.caffeinate.watcher.new(function(event)
    if (event == hs.caffeinate.watcher.screensDidUnlock) then 
        -- gør mig selv opmærksom på krænkelse
        if (breach_detected) then
            breach_detected = false
            if breachShowMethod then
            	local answer = hs.dialog.blockAlert("Jeg er blevet krænket :(", "Handling: " .. breach_word, "Ok")
            else
            	hs.notify.new({title = "Jeg er blevet krænket :(", informativeText = "Handling: " .. breach_word}):send()
        	end
        end
    end
end):start()



function deleteWord(word)
    for x = 1, #word, 1 do
        local delete_event = hs.eventtap.event.newEvent()
        delete_event:setType(KeyDown_event)
        delete_event:setKeyCode(BACKSLASH_KEY)
        delete_event:post()
    end
end


function lock()
    attemps_to_open_settings = 0
    breach_detected = true
    -- hs.brightness.set(10)
    
    -- tag et billede

    -- lås computeren
    if (hs.caffeinate.lockScreen()) then
        
    else
        log.i("Der skete en fejl")
    end

    -- gør mig opmærksom næste gang jeg logger ind
    str_arr = {}
end
