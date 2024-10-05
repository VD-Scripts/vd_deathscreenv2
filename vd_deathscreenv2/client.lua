vRP = Proxy.getInterface("vRP")


local CallCommand = "calladmin"


local coma_threshold = 120 -- schimbati de la cat HP vreti ca player-ul sa intre in coma state
local health
local killername = ""
local testCommand = true
local cantReset = false

Citizen.CreateThread(function()
  local once = false
  while true do
    Citizen.Wait(1000)
    health = GetEntityHealth(PlayerPedId())
    if health <= coma_threshold then
      if not cantReset then
        if not in_coma then
          in_coma = true
          Die()
        end
      end
    end
  end
end)
RegisterNUICallback("calladmin", function()
  vRP.executeCommand({CallCommand})
end)
RegisterNUICallback("respawn", function()
  Citizen.CreateThread(function()
    cantReset = true
    in_coma = false

    SetEntityInvincible(PlayerPedId(),false)

    vRP.varyHealth({100})
    vRP.notify({"Te respawnezi..."})
    once = false
    

    SendNUIMessage({type="hide"})
    SetNuiFocus(false,false)
    vRP.stopScreenEffect({"DeathFailMPIn"})
    Citizen.Wait(5000)
    cantReset = false

    SetTimeout(500,function()
      exports['vrp']:spawnPlayer()
      vRP.setRagdoll({false})
      CancelEvent();
    end)
  end)
end)
Citizen.CreateThread(function() -- coma decrease thread
    while true do 
      Citizen.Wait(1000)
      SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
    end
end)
AddEventHandler('gameEventTriggered', function (name, args)
  if name == 'CEventNetworkEntityDamage' then
    local victim, attacker, weaponHash, isMelee = table.unpack(args)
    local plyPed = PlayerPedId()

    data = {
      serverId = GetPlayerServerId( NetworkGetPlayerIndexFromPed(attacker))
    }
    TriggerServerEvent("serverEvent", data)
  end
end)
RegisterNetEvent("vd_deathscreen:mafiot", function(name)
  killername = name
end)
function Die()
  Citizen.CreateThread(function()
    if IsEntityDead(PlayerPedId()) then
      local x,y,z = vRP.getPosition()
      NetworkResurrectLocalPlayer(x, y, z, true, true, false)
      Citizen.Wait(0)
    end
    SendNUIMessage({
      type = "open",
      killer = killername
    })
    TriggerServerEvent("vd_deathscreen:updateHealth")
    in_coma = true
    SetEntityHealth(PlayerPedId(), coma_threshold)
    SetNuiFocus(true,true)
    SetEntityInvincible(PlayerPedId(),true)
    vRP.ejectVehicle()
    vRP.setRagdoll({true})
    vRP.playScreenEffect({"DeathFailMPIn", -1})
  end)
end
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)

    while in_coma do
      Citizen.Wait(500)
      health = GetEntityHealth(PlayerPedId())

      if not cantReset then
        if health <= coma_threshold then 
          SetEntityHealth(PlayerPedId(), coma_threshold)
        else
          in_coma = false
      
          SetEntityInvincible(PlayerPedId(),false)
          vRP.setRagdoll({false})
          once = false
         
          
          SendNUIMessage({type="hide"})
          SetNuiFocus(false,false)
          if IsEntityDead(PlayerPedId()) then
            local x,y,z = vRP.getPosition()
            NetworkResurrectLocalPlayer(x, y, z, true, true, false)
            Citizen.Wait(0)
          end
          break
        end
      end

    end
  
  end
end)

-- Test Command
if testCommand then
  RegisterCommand("die", function()
    SetEntityHealth(PlayerPedId(),120)
  end)
end