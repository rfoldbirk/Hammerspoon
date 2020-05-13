local log = hs.logger.new('Wifi', 'debug')


local wifiWatcher = nil
local lastSSID = hs.wifi.currentNetwork()

local lastVolume = 25

function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()
    
    if newSSID ~= homeSSID and lastSSID == homeSSID then
        -- vi har lige været på en hjemmenetværket og nu er vi på et andet
        hs.menuIcon(false)
        if showNotificationsOnWifiChange then
            hs.notify.new({title = "Forlod netværket"}):send()
        end

        lastVolume = hs.audiodevice.defaultOutputDevice():outputVolume()
        hs.audiodevice.defaultOutputDevice():setVolume(0)
    else
        if not alwaysHideMenu then
            hs.menuIcon(true)
        end
        
        if showNotificationsOnWifiChange then
            hs.notify.new({title = "Joinede netværket"}):send()
        end

        hs.audiodevice.defaultOutputDevice():setVolume(lastVolume)
    end
    
    lastSSID = newSSID
end

local wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback):start()

ssidChangedCallback()



local unlockWatcher = hs.caffeinate.watcher.new(function(event)
    if (event == hs.caffeinate.watcher.screensDidUnlock) then
        -- set volume to zero
        newSSID = hs.wifi.currentNetwork()
        
        if newSSID ~= homeSSID then
            hs.audiodevice.defaultOutputDevice():setVolume(0)
        end
    end
end):start()