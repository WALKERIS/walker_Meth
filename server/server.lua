ESX = exports.es_extended:getSharedObject()
local ox_inventory = exports.ox_inventory


RegisterServerEvent('esx_methcar:start')
AddEventHandler('esx_methcar:start', function()
    local _source = source
    local playerInv = ox_inventory:GetInventory(_source)
    
    local acetone = ox_inventory:Search(_source, 'count', 'acetone') or 0
    local lithium = ox_inventory:Search(_source, 'count', 'lithium') or 0
    local methlab = ox_inventory:Search(_source, 'slots', 'methlab')[1]

    if acetone >= 5 and lithium >= 2 and methlab then

        local currentDurability = methlab.metadata.durability or 100
        local newDurability = currentDurability - 10


        if newDurability > 0 then
            exports.ox_inventory:SetDurability(playerInv.id, methlab.slot, newDurability)
        else
            ox_inventory:RemoveItem(_source, 'methlab', 1, nil, methlab.slot)
        end


        ox_inventory:RemoveItem(_source, 'acetone', 5)
        ox_inventory:RemoveItem(_source, 'lithium', 2)
        
        TriggerClientEvent('esx_methcar:startprod', _source)
    else
        TriggerClientEvent('esx_methcar:notify', _source, "Nepakanka atsargų pradėti gaminti amfa")
    end
end)

RegisterServerEvent('esx_methcar:stopf')
AddEventHandler('esx_methcar:stopf', function(id)
local _source = source
	local xPlayers = ESX.GetPlayers()
	local xPlayer = ESX.GetPlayerFromId(_source)
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('esx_methcar:stopfreeze', xPlayers[i], id)
	end
	
end)
RegisterServerEvent('esx_methcar:make')
AddEventHandler('esx_methcar:make', function(posx,posy,posz)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.getInventoryItem('methlab').count >= 1 then
	
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			TriggerClientEvent('esx_methcar:smoke',xPlayers[i],posx,posy,posz, 'a') 
		end
		
	else
		TriggerClientEvent('esx_methcar:stop', _source)
	end
	
end)
RegisterServerEvent('esx_methcar:finish')
AddEventHandler('esx_methcar:finish', function(qualtiy)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	print(qualtiy)
	local rnd = math.random(-5, 5)
	TriggerEvent('KLevels:addXP', _source, 20)
	xPlayer.addInventoryItem('meth', math.floor(qualtiy * 1.5) + rnd)
	
end)

RegisterServerEvent('esx_methcar:blow')
AddEventHandler('esx_methcar:blow', function(posx, posy, posz)
	local _source = source
	local xPlayers = ESX.GetPlayers()
	local xPlayer = ESX.GetPlayerFromId(_source)
	for i=1, #xPlayers, 1 do
		TriggerClientEvent('walker_methcar:pradeti', xPlayers[i],posx, posy, posz)
	end
	xPlayer.removeInventoryItem('methlab', 1)
end)
