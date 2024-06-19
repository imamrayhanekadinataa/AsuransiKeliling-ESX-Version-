ESX = nil

Citizen.CreateThread(function() 
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function _L(str)
    if not Locale then return "Locale error" end
    if not Locale[Config.locale] then return "Invalid locale" end
    if not Locale[Config.locale][str] then return "Invalid string" end
    return Locale[Config.locale][str]
end

RegisterNetEvent("marskuy-askel:delete")
AddEventHandler("marskuy-askel:delete", function()
	local minuteCalculation = 60000
	local minutesPassed = 0
	local minutesLeft = Config.DeleteVehicleTimer

	--ESX.ShowNotification(_L("first_message"):format(math.floor(minutesLeft)))
	lib.defaultNotify({
		title = 'Asuransi Keliling',
		description = _L("first_message"):format(math.floor(minutesLeft)),
		status = 'info'
	})

	while minutesPassed < Config.DeleteVehicleTimer do
		Citizen.Wait(1*minuteCalculation)
		minutesPassed = minutesPassed + 1
		minutesLeft = minutesLeft - 1
		if minutesLeft == 0 then
			--ESX.ShowNotification(_L("deleted_vehicles"))
			lib.defaultNotify({
				title = 'Asuransi Keliling',
				description = _L("deleted_vehicles"),
				status = 'info'
			})
		elseif minutesLeft == 1 then
			--ESX.ShowNotification(_L("deleted_in_min"):format(math.floor(minutesLeft)))
			lib.defaultNotify({
				title = 'Asuransi Keliling',
				description = _L("deleted_in_min"):format(math.floor(minutesLeft)),
				status = 'info'
			})
		else
			--ESX.ShowNotification(_L("deleted_in_mins"):format(math.floor(minutesLeft)))
			lib.defaultNotify({
				title = 'Asuransi Keliling',
				description = _L("deleted_in_mins"):format(math.floor(minutesLeft)),
				status = 'info'
			})
		end
	end
	for vehicle in EnumerateVehicles() do
		local canDelete = true
		local carCoords = GetEntityCoords(vehicle)

		if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then
			if canDelete then
				SetVehicleHasBeenOwnedByPlayer(vehicle, false) 
				SetEntityAsMissionEntity(vehicle, false, false) 
				DeleteVehicle(vehicle)
				if (DoesEntityExist(vehicle)) then 
					DeleteVehicle(vehicle) 
				end
			end
		end
	end
end)

local entityEnumerator = {
	__gc = function(enum)
	if enum.destructor and enum.handle then
		enum.destructor(enum.handle)
	end
	enum.destructor = nil
	enum.handle = nil
end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end