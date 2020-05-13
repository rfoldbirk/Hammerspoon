local log = hs.logger.new('Init', 'debug')

-- lydstyrken bliver automatisk sænket til 0, hvis man åbner computeren mens man er på et andet netværk
-- beskyttelse mod sjofle pranks
-- beskyttelse mod Mikkel :)
-- automatisk fjernelse af Hammerspoon menuen, når man forlader hjemme netværket


-- wifi indstillinger
homeSSID = "foldberg"
alwaysHideMenu = false
showNotificationsOnWifiChange = false

-- protego indstillinger
breachShowMethod = true -- true = dialog box | false = notification




dofile("./protego.lua")
dofile("./wifi.lua")


-- bedre reload!
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
    hs.reload()
end)