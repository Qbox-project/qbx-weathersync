local currentWeather = Config.StartWeather
local baseTime = Config.BaseTime
local timeOffset = Config.TimeOffset
local freezeTime = Config.FreezeTime
local blackout = Config.Blackout
local newWeatherTimer = Config.NewWeatherTimer

--- Does source have permissions to run admin commands
--- @param src number - Source to check
--- @return boolean - has permission
local function isAllowedToChange(src)
    return exports.qbx_core:HasPermission(src, "admin") or IsPlayerAceAllowed(tostring(src), 'command')
end

--- Sets time offset based on minutes provided
--- @param minute number - Minutes to offset by
local function shiftToMinute(minute)
    timeOffset -= (((baseTime + timeOffset) % 60) - minute)
end

--- Sets time offset based on hour provided
--- @param hour number - Hour to offset by
local function shiftToHour(hour)
    timeOffset -= ((((baseTime + timeOffset) / 60) % 24) - hour) * 60
end

--- Triggers event to switch weather to next stage
local function nextWeatherStage()
    if currentWeather == "CLEAR" or currentWeather == "CLOUDS" or currentWeather == "EXTRASUNNY" then
        currentWeather = (math.random(1, 5) > 2) and "CLEARING" or "OVERCAST" -- 60/40 chance
    elseif currentWeather == "CLEARING" or currentWeather == "OVERCAST" then
        local new = math.random(1, 6)
        if new == 1 then currentWeather = (currentWeather == "CLEARING") and "FOGGY" or "RAIN"
        elseif new == 2 then currentWeather = "CLOUDS"
        elseif new == 3 then currentWeather = "CLEAR"
        elseif new == 4 then currentWeather = "EXTRASUNNY"
        elseif new == 5 then currentWeather = "SMOG"
        else currentWeather = "FOGGY"
        end
    elseif currentWeather == "THUNDER" or currentWeather == "RAIN" then currentWeather = "CLEARING"
    elseif currentWeather == "SMOG" or currentWeather == "FOGGY" then currentWeather = "CLEAR"
    else currentWeather = "CLEAR"
    end
    TriggerEvent("qb-weathersync:server:RequestStateSync")
end

--- Switch to a specified weather type
--- @param weather string - Weather type from Config.AvailableWeatherTypes
--- @return boolean - success
local function setWeather(weather)
    local validWeatherType = false
    for _, weatherType in pairs(Config.AvailableWeatherTypes) do
        if weatherType == string.upper(weather) then
            validWeatherType = true
        end
    end
    if not validWeatherType then return false end
    currentWeather = string.upper(weather)
    newWeatherTimer = Config.NewWeatherTimer
    TriggerEvent('qb-weathersync:server:RequestStateSync')
    return true
end

--- Sets sun position based on time to specified
--- @param hour number|string - Hour to set (0-24)
--- @param minute? number|string `optional` - Minute to set (0-60)
--- @return boolean - success
local function setTime(hour, minute)
    local argh = tonumber(hour)
    local argm = tonumber(minute) or 0
    if argh == nil or argh > 24 then
        print(Lang:t('time.invalid'))
        return false
    end
    shiftToHour((argh < 24) and argh or 0)
    shiftToMinute((argm < 60) and argm or 0)
    print(Lang:t('time.change', {value = argh, value2 = argm}))
    TriggerEvent('qb-weathersync:server:RequestStateSync')
    return true
end

--- Sets or toggles blackout state and returns the state
--- @param state? boolean `optional` - enable blackout?
--- @return boolean - blackout state
local function setBlackout(state)
    if state == nil then state = not blackout end
    blackout = state
    TriggerEvent('qb-weathersync:server:RequestStateSync')
    return blackout
end

--- Sets or toggles time freeze state and returns the state
--- @param state? boolean `optional` - Enable time freeze?
--- @return boolean - Time freeze state
local function setTimeFreeze(state)
    if state == nil then state = not freezeTime end
    freezeTime = state
    TriggerEvent('qb-weathersync:server:RequestStateSync')
    return freezeTime
end

--- Sets or toggles dynamic weather state and returns the state
--- @param state? boolean `optional` - Enable dynamic weather?
--- @return boolean - Dynamic Weather state
local function setDynamicWeather(state)
    if state == nil then state = not Config.DynamicWeather end
    Config.DynamicWeather = state
    TriggerEvent('qb-weathersync:server:RequestStateSync')
    return Config.DynamicWeather
end

-- EVENTS
RegisterNetEvent('qb-weathersync:server:RequestStateSync', function()
    TriggerClientEvent('qb-weathersync:client:SyncWeather', -1, currentWeather, blackout)
    TriggerClientEvent('qb-weathersync:client:SyncTime', -1, baseTime, timeOffset, freezeTime)
end)

RegisterNetEvent('qb-weathersync:server:setWeather', function(weather)
    if GetInvokingResource() then return end
    local src = source
    if not isAllowedToChange(src) then return end
    local success = setWeather(weather)
    if success then exports.qbx_core:Notify(src, Lang:t('weather.updated'))
    else exports.qbx_core:Notify(src, Lang:t('weather.invalid'))
    end
end)

RegisterNetEvent('qb-weathersync:server:setTime', function(hour, minute)
    if GetInvokingResource() then return end
    local src = source
    if not isAllowedToChange(src) then return end
    local success = setTime(hour, minute)
    if success then exports.qbx_core:Notify(src, Lang:t('time.change', {value = hour, value2 = minute or "00"}))
    else exports.qbx_core:Notify(src, Lang:t('time.invalid'))
    end
end)

RegisterNetEvent('qb-weathersync:server:toggleBlackout', function(state)
    if GetInvokingResource() then return end
    local src = source
    if not isAllowedToChange(src) then return end
    local newstate = setBlackout(state)
    if newstate then exports.qbx_core:Notify(src, Lang:t('blackout.enabled'))
    else exports.qbx_core:Notify(src, Lang:t('blackout.disabled'))
    end
end)

RegisterNetEvent('qb-weathersync:server:toggleFreezeTime', function(state)
    if GetInvokingResource() then return end
    local src = source
    if not isAllowedToChange(src) then return end
    local newstate = setTimeFreeze(state)
    if newstate then exports.qbx_core:Notify(src, Lang:t('time.now_frozen'))
    else exports.qbx_core:Notify(src, Lang:t('time.now_unfrozen'))
    end
end)

RegisterNetEvent('qb-weathersync:server:toggleDynamicWeather', function(state)
    if GetInvokingResource() then return end
    local src = source
    if not isAllowedToChange(src) then return end
    local newstate = setDynamicWeather(state)
    if newstate then exports.qbx_core:Notify(src, Lang:t('weather.now_unfrozen'))
    else exports.qbx_core:Notify(src, Lang:t('weather.now_frozen'))
    end
end)

-- COMMANDS
lib.addCommand('freezetime', {help = Lang:t('help.freezecommand'), restricted = 'admin'}, function(source)
    local newstate = setTimeFreeze()
    if newstate then exports.qbx_core:Notify(source, Lang:t('time.frozenc'))
    else exports.qbx_core:Notify(source, Lang:t('time.unfrozenc')) end
end)

lib.addCommand('freezeweather', {help = Lang:t('help.freezeweathercommand'), restricted = 'admin'}, function(source)
    local newstate = setDynamicWeather()
    if newstate then exports.qbx_core:Notify(source, Lang:t('dynamic_weather.enabled'))
    else exports.qbx_core:Notify(source, Lang:t('dynamic_weather.disabled')) end
end)

lib.addCommand('weather', {help = Lang:t('help.weathercommand'), restricted = 'admin', params = {{name = 'weathertype', type = 'string', help = Lang:t('help.availableweather')}}
}, function(source, args)
    local success = setWeather(args.weathertype)
    if success then exports.qbx_core:Notify(source, Lang:t('weather.willchangeto', {value = string.lower(args.weathertype)}))
    else exports.qbx_core:Notify(source, Lang:t('weather.invalidc'), 'error') end
end)

lib.addCommand('blackout', {help = Lang:t('help.blackoutcommand'), restricted = 'admin'}, function(source)
    local newstate = setBlackout()
    if newstate then exports.qbx_core:Notify(source, Lang:t('blackout.enabledc'))
    else exports.qbx_core:Notify(source, Lang:t('blackout.disabledc')) end
end)

lib.addCommand('morning', {help = Lang:t('help.morningcommand'), restricted = 'admin'}, function(source)
    setTime(9, 0)
    exports.qbx_core:Notify(source, Lang:t('time.morning'))
end)

lib.addCommand('noon', {help = Lang:t('help.nooncommand'), restricted = 'admin'}, function(source)
    setTime(12, 0)
    exports.qbx_core:Notify(source, Lang:t('time.noon'))
end)

lib.addCommand('evening', {help = Lang:t('help.eveningcommand'), restricted = 'admin'}, function(source)
    setTime(18, 0)
    exports.qbx_core:Notify(source, Lang:t('time.evening'))
end)

lib.addCommand('night', {help = Lang:t('help.nightcommand'), restricted = 'admin'}, function(source)
    setTime(23, 0)
    exports.qbx_core:Notify(source, Lang:t('time.night'))
end)

lib.addCommand('time', {help = Lang:t('help.timecommand'), restricted = 'admin', params = {{name = 'hours', type = 'number', help = Lang:t('help.timeh')}, {name = 'minutes', type = 'number', help = Lang:t('help.timem')}}
}, function(source, args)
    local success = setTime(args.hours, args.minutes)
    if success then exports.qbx_core:Notify(source, Lang:t('time.changec', {value = args.hours..':'..(args.minutes or "00")}))
    else exports.qbx_core:Notify(source, Lang:t('time.invalidc'), 'error') end
end)

-- THREAD LOOPS
CreateThread(function()
    local previous = 0
    while true do
        Wait(0)
        local newBaseTime = os.time(os.date("!*t")) / 2 + 360 --Set the server time depending of OS time
        if (newBaseTime % 60) ~= previous then --Check if a new minute is passed
            previous = newBaseTime % 60 --Only update time with plain minutes, seconds are handled in the client
            if freezeTime then
                timeOffset = timeOffset + baseTime - newBaseTime
            end
            baseTime = newBaseTime
        end
    end
end)

CreateThread(function()
    while true do
        Wait(2000)--Change to send every minute in game sync
        TriggerClientEvent('qb-weathersync:client:SyncTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

CreateThread(function()
    while true do
        Wait(300000)
        TriggerClientEvent('qb-weathersync:client:SyncWeather', -1, currentWeather, blackout)
    end
end)

CreateThread(function()
    while true do
        newWeatherTimer = newWeatherTimer - 1
        Wait((1000 * 60) * Config.NewWeatherTimer)
        if newWeatherTimer == 0 then
            if Config.DynamicWeather then
                nextWeatherStage()
            end
            newWeatherTimer = Config.NewWeatherTimer
        end
    end
end)

-- EXPORTS
exports('nextWeatherStage', nextWeatherStage)
exports('setWeather', setWeather)
exports('setTime', setTime)
exports('setBlackout', setBlackout)
exports('setTimeFreeze', setTimeFreeze)
exports('setDynamicWeather', setDynamicWeather)
exports('getBlackoutState', function() return blackout end)
exports('getTimeFreezeState', function() return freezeTime end)
exports('getWeatherState', function() return currentWeather end)
exports('getDynamicWeather', function() return Config.DynamicWeather end)