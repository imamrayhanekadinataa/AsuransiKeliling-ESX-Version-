ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand(Config.Cmd, function(source, args, rawCommand) 
  local player = ESX.GetPlayerFromId(source)
  local playerGroup = player.getGroup()

  if playerGroup ~= nil and playerGroup == "superadmin" or playerGroup == "admin" or playerGroup == "mod" then 
      TriggerClientEvent('marskuy-askel:delete', -1)
  end
end)

function DeleteVehTaskCoroutine()
  TriggerClientEvent('marskuy-askel:delete', -1)
end

for i = 1, #Config.DeleteVehiclesAt, 1 do
    TriggerEvent('cron:runAt', Config.DeleteVehiclesAt[i].h, Config.DeleteVehiclesAt[i].m, DeleteVehTaskCoroutine)
end


   

   