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
breachShowMethod = false -- true = dialog box | false = notification
removeLockHotkey = "zxm"
settingsHotkey = "zxm"
naughtyWords = {"fuck", "porn"}


dofile("./windows.lua")
dofile("./protego.lua")
dofile("./wifi.lua")


-- bedre reload!
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")