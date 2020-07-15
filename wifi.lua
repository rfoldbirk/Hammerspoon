local log = hs.logger.new('Wifi', 'debug')


function isHome()
    SSID = hs.wifi.currentNetwork()
    local homeWifiDetected = false

    for i=1, #homeSSIDs do
        if homeSSIDs[i] == SSID then
            homeWifiDetected = true
        end
    end

    return homeWifiDetected
end


if alwaysHideMenu == false then
    hs.menuIcon(true)
end

local wifiWatcher = nil
local lastSSID = hs.wifi.currentNetwork()

local lastVolume = 25

SSID = hs.wifi.currentNetwork()


hs.menuIcon(isHome() and not alwaysHideMenu)
stop_fishing = (isHome() and not alwaysHideMenu)





function ssidChangedCallback()
    SSID = hs.wifi.currentNetwork()
    
    if not isHome() then
        -- vi har lige været på en hjemmenetværket og nu er vi på et andet
        stop_fishing = false -- fiskeri efter lidt for friske ord begynder automatisk igen
        max_attempts = 1

        hs.menuIcon(false)
        if showNotificationsOnWifiChange then
            hs.notify.new({title = "Du er på ukendt territorie :/"}):send()
        end

        lastVolume = hs.audiodevice.defaultOutputDevice():outputVolume()
        hs.audiodevice.defaultOutputDevice():setVolume(0)
    else
        stop_fishing = true

        if alwaysHideMenu == false then
            hs.menuIcon(true)
        end
        
        if showNotificationsOnWifiChange then
            hs.notify.new({title = "Du er tilbage i sikkerhed"}):send()
        end

        hs.audiodevice.defaultOutputDevice():setVolume(lastVolume)
    end
    
    lastSSID = SSID
end

local wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback):start()


local unlockWatcher = hs.caffeinate.watcher.new(function(event)
    if (event == hs.caffeinate.watcher.screensDidUnlock) then
        -- set volume to zero
        if not isHome() then
            hs.audiodevice.defaultOutputDevice():setVolume(0)
        end
    end
end):start()