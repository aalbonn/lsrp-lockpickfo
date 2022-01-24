
local success = false
local action = nil
local trigger = nil
local npins = nil

QBCore = nil
Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

RegisterNetEvent('lsrp-lockpick:StartLockpickfo')
AddEventHandler('lsrp-lockpick:StartLockpickfo', function(cb)
    QBCore.Functions.Notify("Press A or D to Rotate ", "primary", 10000)
    action = nil
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "enableui",
        pins = math.random(4,6),
        enable = true,
    })
    Citizen.CreateThread(function()
        while true do
            if action == 'success' then
                cb(true)
                break
            elseif action == 'failed' then
                cb(false)
                break
            end
            Citizen.Wait(0)
        end
    end)
end)

RegisterNUICallback('escape', function(data, cb)
    SetNuiFocus(false, false)
    action = 'failed'
end)

RegisterNUICallback('removepin', function(data, cb)
    TriggerServerEvent('lsrp-lockpickfo:removePin')
end)

RegisterNUICallback('process', function(data, cb)
    SetNuiFocus(false)
    if data.state then
        action = 'success'
    else
        action = 'failed'
    end
end)