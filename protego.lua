local log = hs.logger.new('Protector', 'debug')


max_length = 20
keypress_history = {}

lockdown = false
breach_word = ""
deletableFields = 0
allow_settingsHotkey = false
attemps_to_open_settingsHotkey = 0




title = "Jeg er blevet krænket :("
content = "Handling: "


insertPoint = 0


mouseE = hs.eventtap.new(
{
    hs.eventtap.event.types.mouseMoved,
    hs.eventtap.event.types.leftMouseDown,
    hs.eventtap.event.types.rightMouseDown,
},
function(event)
    if lockdown then
        hs.mouse.setAbsolutePosition({0, 0})
        event:setType(0)
    end
end):start()


appWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
    if (appName ~= "System­indstillinger") then
        return
    end
    
    if (eventType == hs.application.watcher.activated) then
        if (allow_settingsHotkey == false) then
            -- Bring all Finder windows forward when one gets activated
            appObject:kill()
            attemps_to_open_settingsHotkey = attemps_to_open_settingsHotkey + 1
            
            if (attemps_to_open_settingsHotkey > 1) then
                caught("forsøgte at åbne indstillingerne")
            end
        end
    elseif (eventType == hs.application.watcher.terminated) then
        allow_settingsHotkey = false
    end
end)

keyEventtap = hs.eventtap.new( {hs.eventtap.event.types.keyDown}, function(event)
    key = hs.keycodes.map[event:getKeyCode()]

    -- add
    if key == "space" then
        key = " "
    end

    if #key == 1 then
        -- keypress_history[#keypress_history + 1] = key
        if insertPoint > #keypress_history then
            insertPoint = #keypress_history
        end
        table.insert(keypress_history, #keypress_history + 1 - insertPoint, key)
    elseif key == "delete" then
        if #keypress_history - insertPoint > 0 then
            local cmded = event:getFlags():contain({"cmd"})
            local alted = event:getFlags():contain({"alt"})
            if cmded then
                keypress_history = {}
                insertPoint = 0
            elseif alted then

                local removeWord = ""
                local canRemove = true
                local onlySpaces = false


                for i = #keypress_history, 1, -1 do
                    local k = keypress_history[i]

                    if k == " " then
                        canRemove = false
                        if #removeWord == 0 then
                            onlySpaces = true
                        end

                        if onlySpaces then
                            canRemove = true
                        end
                    else
                        onlySpaces = false
                    end

                    if canRemove then
                        removeWord = k .. removeWord
                    end
                end

                removeFromHistory(removeWord, keypress_history)
            else
                table.remove(keypress_history, #keypress_history - insertPoint)
            end
        end
    end

    -- overflow prevention
    controlHistory()
    str = tableToString(keypress_history) 

    log.i(str)

    -- lockdown check / settingsHotkey manager
    if lockdown then
        if string.match(str, removeLockHotkey) then
            disengage()
        end

        if deletableFields <= 0 then
            event:setType(0)
        else
            deletableFields = deletableFields - 1
        end
        return
    else
        -- settingsHotkey
        if string.match(str, settingsHotkey) and not allow_settingsHotkey then
            deleteWord(settingsHotkey)
            allow_settingsHotkey = true
            hs.application.launchOrFocus("/System/Applications/System Preferences.app")
        end
    end


    -- check for naughty words
    for i = 1, #naughtyWords, 1 do
        if string.match(str, naughtyWords[i]) then
            caught(naughtyWords[i])
        end
    end
end)


function disengage()
    lockdown = false
    removeFromHistory(removeLockHotkey, keypress_history)

    if breachShowMethod then
        hs.dialog.blockAlert(title, content .. breach_word, "Ok")
    else
        hs.notify.new({title = title, informativeText = content .. breach_word}):send()
    end
end


function removeFromHistory(word, arr)
    for i=1, #word, 1 do
        table.remove(arr, #arr - insertPoint)
    end
end

function caught(word)
    lockdown = true
    deletableFields = #word
    deleteWord(word)
    breach_word = word
end


function cmdZ()
    local cmdZ_event = hs.eventtap.event.newKeyEvent({"cmd"}, 6, true)
    cmdZ_event:post()
end

function deleteWord(word)
    for x = 1, #word, 1 do
        local delete_event = hs.eventtap.event.newEvent()
        delete_event:setType(10)
        delete_event:setKeyCode(51)
        delete_event:post()
    end
end


function tableToString(arr)
    local str = ""
    for i = 1, #arr, 1 do
        str = str .. arr[i]
    end
    return str
end


function controlHistory()
    if #keypress_history > max_length then
        table.remove(keypress_history, 1)
    end
end



appWatcher:start()
keyEventtap:start()