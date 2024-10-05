local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "VDScripts_DeathScreen")

local loaded = false
RegisterServerEvent("vd_deathscreen:updateHealth", function()
    vRPclient.updateHealth(source, {120})
end)
RegisterServerEvent("serverEvent", function(data)
    local tSource = data.serverId
    if tSource ~= 0 then
        local tName = GetPlayerName(tSource)
        TriggerClientEvent("vd_deathscreen:mafiot", source, tName)
    elseif tSource == 0 then
        TriggerClientEvent("vd_deathscreen:mafiot", source, "YOURSELF")
    end
end)