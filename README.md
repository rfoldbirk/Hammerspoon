# Hammerspoon Automatisering

### Installation

Efter at have gemt filerne i mappen `~/.hammerspoon` skal du:
1. Installere [ffmpeg](https://ffmpeg.org) eventuelt via [brew](https://brew.sh)
2. Åbne en terminal og skrive: `mkdir ~/.hammerspoon/mugshots`
3. Oprette en fil ved navn `settings.lua` se eventuelt afsnittet omkring config

--------------------

### Config // settings.lua

Indtil videre kan du rykke rundt på disse indstillinger:

```lua
-- generelt
showMessageOnConfigReload = false


-- wifi indstillinger
homeSSIDs = { 'netværk 1', 'netværk 2' }
alwaysHideMenu = false
showNotificationsOnWifiChange = false

-- protego indstillinger
breachShowMethod = false -- true = dialog box | false = notification

removeProtegoHotkey = 'rmp'
removeLockHotkey = 'rml' -- koden du skal bruge for at låse computeren op igen.

settingsHotkey = 'rms'
settingsKill_DisableWhenHome = true

naughtyWords = { 'trompet', 'guitar' } -- du kan selvfølgelig tilføje så mange ord som overhovedet muligt
```



### Hotkeys

Indtil videre kan du holde `CMD + ALT` inde mens du trykker på en af piletasterne, så bliver vinduerne kastet rundt på skærmen :)
