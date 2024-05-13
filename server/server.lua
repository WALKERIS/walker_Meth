ESX = exports.es_extended:getSharedObject()
local ox_inventory = exports.ox_inventory


RegisterServerEvent('esx_methcar:start')
AddEventHandler('esx_methcar:start', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.getInventoryItem('acetone').count >= 5 and xPlayer.getInventoryItem('lithium').count >= 2 and xPlayer.getInventoryItem('methlab').count >= 1 then 
		if xPlayer.getInventoryItem('meth').count >= 60 then
				TriggerClientEvent('esx_methcar:notify', _source, "Jūs negalite turėti daugiau amfos")
		else
			TriggerClientEvent('esx_methcar:startprod', _source)
			local methlab = ox_inventory:Search(_source, 1, 'methlab')
			xPlayer.removeInventoryItem('acetone', 5)
			xPlayer.removeInventoryItem('lithium', 2)
			local patvarumas ox_inventory:SetDurability(_source, methlab.slot, 0.10)
			if patvarumas then
				print("test pavyko")
			else
				print("Test nepavyko")
			end
		end		
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
	xPlayer.addInventoryItem('meth', math.floor(qualtiy / 4) + rnd)
	xPlayer.addInventoryItem('prastas_meth', math.floor(qualtiy / 2) + rnd)
	
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

