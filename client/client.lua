local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local started = false
local displayed = false
local progress = 0
local CurrentVehicle 
local pause = false
local selection = 0
local quality = 0
local hidetextui = lib.hideTextUI()

local LastCar

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

ESX = exports.es_extended:getSharedObject()

RegisterNetEvent('esx_methcar:stop')
AddEventHandler('esx_methcar:stop', function()
	started = false
	lib.notify({
		title = 'Gamyba',
		description = 'Sustabdyta gamyba',
		position = 'top-center',
		type = 'error'
	})
	FreezeEntityPosition(LastCar, false)
	lib.hideTextUI()
end)
RegisterNetEvent('esx_methcar:stopfreeze')
AddEventHandler('esx_methcar:stopfreeze', function(id)
	FreezeEntityPosition(id, false)
end)
RegisterNetEvent('esx_methcar:notify')
AddEventHandler('esx_methcar:notify', function(message)
	lib.notify({
		title = nil,
		description = message,
		type = 'info'
	})
end)

RegisterNetEvent('esx_methcar:startprod')
AddEventHandler('esx_methcar:startprod', function()
	lib.notify({
		title = 'Gamyba',
		description = 'Pradedama gamyba',
		position = 'top-center',
		type = 'success'
	})
	started = true
	FreezeEntityPosition(CurrentVehicle,true)
	displayed = false
	print('AMFOS VYRIMAS PRADETAS')
	lib.notify({
		title = 'Prasidėjo amfos gamyba',
		description = 'Prasidėjo amfos gamyba',
		type = 'success',
		position = 'top-center'
	})
	SetPedIntoVehicle(GetPlayerPed(-1), CurrentVehicle, 3)
	SetVehicleDoorOpen(CurrentVehicle, 2)
end)

RegisterNetEvent('walker_methcar:pradeti')
AddEventHandler('walker_methcar:pradeti', function(posx, posy, posz)
	AddExplosion(posx, posy, posz + 2,23, 20.0, true, false, 1.0, true)
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Citizen.Wait(1)
		end
	end
	SetPtfxAssetNextCall("core")
	local fire = StartParticleFxLoopedAtCoord("ent_ray_heli_aprtmnt_l_fire", posx, posy, posz-0.8 , 0.0, 0.0, 0.0, 0.8, false, false, false, false)
	Citizen.Wait(6000)
	StopParticleFxLooped(fire, 0)
	
end)


RegisterNetEvent('esx_methcar:smoke')
AddEventHandler('esx_methcar:smoke', function(posx, posy, posz, bool)

	if bool == 'a' then

		if not HasNamedPtfxAssetLoaded("core") then
			RequestNamedPtfxAsset("core")
			while not HasNamedPtfxAssetLoaded("core") do
				Citizen.Wait(1)
			end
		end
		SetPtfxAssetNextCall("core")
		local smoke = StartParticleFxLoopedAtCoord("exp_grd_flare", posx, posy, posz + 1.7, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
		SetParticleFxLoopedAlpha(smoke, 0.8)
		SetParticleFxLoopedColour(smoke, 0.0, 0.0, 0.0, 0)
		Citizen.Wait(22000)
		StopParticleFxLooped(smoke, 0)
	else
		StopParticleFxLooped(smoke, 0)
	end

end)
RegisterNetEvent('esx_methcar:drugged')
AddEventHandler('esx_methcar:drugged', function()
	SetTimecycleModifier("drug_drive_blend01")
	SetPedMotionBlur(GetPlayerPed(-1), true)
	SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(GetPlayerPed(-1), true)

	Citizen.Wait(300000)
	ClearTimecycleModifier()
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		
		playerPed = GetPlayerPed(-1)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		if IsPedInAnyVehicle(playerPed) then
			
			
			CurrentVehicle = GetVehiclePedIsUsing(PlayerPedId())

			car = GetVehiclePedIsIn(playerPed, false)
			LastCar = GetVehiclePedIsUsing(playerPed)
	
			local model = GetEntityModel(CurrentVehicle)
			local modelName = GetDisplayNameFromVehicleModel(model)
			
			if modelName == 'JOURNEY' and car then
				
					if GetPedInVehicleSeat(car, -1) == playerPed then
						if started == false then
							if displayed == false then
								lib.showTextUI('[G] - Pradėti gaminti narkotikus')
								displayed = true
							end
						end
						if IsControlJustReleased(0, Keys['G']) then
							if pos.y >= 3500 then
								if IsVehicleSeatFree(CurrentVehicle, 3) then
									TriggerServerEvent('esx_methcar:start')	
									progress = 0
									pause = false
									selection = 0
									quality = 0

									lib.hideTextUI()
				
								else
									lib.notify({
										title = 'Automobilis jau užimtas',
										description = 'Automobilis jau užimtas',
										position = 'top-center',
										type = 'error'
									})
									lib.hideTextUI()
								end
							else
								lib.notify({
									title = 'Nepavyko',
									description = 'Esate per arti miesto, eikite toliau į šiaurę, kad pradėtumėte metalo gamybą',
									position = 'top-center',
									type = 'error'
								})
								lib.hideTextUI()
							end
						end
					end
			end
			
		else

				
				if started then
					started = false
					displayed = false
					TriggerEvent('esx_methcar:stop')
					print('PIMPAM PASIBAIGE NIGERIO GYVENIMAS| MADE BY WALKER')
					FreezeEntityPosition(LastCar,false)
				end
		end
		
		if started == true then
			
			if progress < 96 then
				Citizen.Wait(6000)
				if not pause and IsPedInAnyVehicle(playerPed) then
					progress = progress +  1
					--ESX.ShowNotification('~r~Meth production: ~g~~h~' .. progress .. '%')
					lib.showTextUI('Progresas '.. progress .. '%  \n Kokybe ' .. quality..'%', {
						position = "bottom-center",
						icon = 'fa-solid fa-flask',
						iconAnimation = 'bounce',
						style = {
							backgroundColor = '#E04131',
							color = 'white'
						}
					})
					Citizen.Wait(6000) 
				end

				--
				--   EVENT 1
				--
				if progress > 22 and progress < 24 then
					pause = true
					if selection == 0 then
						lib.hideTextUI()
							lib.showTextUI('Propano vamzdis nutekėjo, ką daryti?  \n Z. Pataisykite juostele  \n X. Palikite tai būti  \n C. Pakeiskite  \n Paspauskite pasirinkimo, kurį norite atlikti, numerį',{
								icon = 'fa-solid fa-flask',
								iconAnimation = 'bounce'
							})
					end
					if selection == 1 then
						
						print("Slected 1")
						ESX.ShowNotification('Juosta tarsi sustabdė nuotėkį')
						local pavyko = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if pavyko then
						quality = quality - 1
						pause = false
					else
						quality = quality - 3
						pause = false
					end
				end
					if selection == 2 then
						
						print("Slected 2")
						ESX.ShowNotification('Susprogo propano bakas, jūs sujaukėte...')
						TriggerServerEvent('walker_methcar:pradeti', pos.x, pos.y, pos.z)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						AddExplosion(posx, posy, posz + 2,23, 20.0, true, false, 1.0, true)
						xPlayer.removeInventoryItem('methlab', 1)
						quality = 0
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('PIMPAM BAIGESI NIGERIO GYVENIMAS')
					end
					if selection == 3 then
						
						print("Slected 3")
						ESX.ShowNotification('Geras darbas, vamzdis nebuvo geros būklės')
						local success = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if success then
						pause = false
						quality = quality + 5
						else
							pause = false
						quality = quality + 3
					end
				end
			end
				--
				--   EVENT 5
				--
				if progress > 30 and progress < 32 then
					pause = true
					if selection == 0 then
						lib.hideTextUI()
							lib.showTextUI('Išpylėte butelį acetono ant žemės, ką daryti?  \n Z. Atidarykite langus, kad pašalintumėte kvapą  \n X. Palikti kaip yra  \n C. Uzsideti dujokauke  \n Paspauskite pasirinkimo, kurį norite atlikti, numerį',{
								icon = 'fa-solid fa-flask fa-bounce',
								iconAnimation = 'bounce'
							})
					end
					if selection == 1 then
						
						print("Slected 1")
						ESX.ShowNotification('Jūs atidarėte langus, kad pašalintumėte kvapą')
						local test = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if test then
						quality = quality - 0
						pause = false
						else
							quality = quality - 1
							pause = false	
						end
					end
					if selection == 2 then
						
						print("Slected 2")
						ESX.ShowNotification('Per daug įkvėpėte acetono')
						pause = false
						TriggerEvent('esx_methcar:drugged')
					end
					if selection == 3 then
						
						print("Slected 3")
						ESX.ShowNotification('Tai paprastas būdas išspręsti problemą... Manau')
						SetPedPropIndex(playerPed, 1, 26, 7, true)
						pause = false
					end
				end
				--
				--   EVENT 2
				--
				if progress > 38 and progress < 40 then
					pause = true
					if selection == 0 then
						lib.hideTextUI()
							lib.showTextUI('Amfa per greitai tampa kieta, ką daryti?  \n Z. Padidinkite slėgį \n X. Pakelkite temperatūrą  \n C. Sumažinkite slėgį  \n Paspauskite pasirinkimo, kurį norite atlikti, numerį',{
								icon = 'fa-solid fa-flask fa-bounce',
								iconAnimation = 'bounce'
							})
					end
					if selection == 1 then
						
						print("Slected 1")
						ESX.ShowNotification('Jūs padidinote slėgį ir propanas pradėjo bėgti, jūs jį sumažinote ir kol kas viskas gerai')
						pause = false
					end
					if selection == 2 then
						
						print("Slected 2")
						ESX.ShowNotification('Temperatūros pakėlimas padėjo...')
						local test1 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if test1 then
						quality = quality + 5
						pause = false
						else
						quality = quality + 3
						pause = false 
						end
					end
					if selection == 3 then
						
						print("Slected 3")
						ESX.ShowNotification('Sumažinus slėgį viskas tik pablogėjo...')
						local test2 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if test2 then
						pause = false
						quality = quality - 2
						else 
							pause = false
							quality = quality - 4
					end
				end
			end
				--
				--   EVENT 8 - 3
				--
				if progress > 41 and progress < 43 then
					pause = true
					if selection == 0 then
						lib.hideTextUI()
							lib.showTextUI('Netyčia įpylėte per daug acetono, ką daryti?  \n Z. Nieko nedaryk   \n X. Pabandykite jį išsiurbti naudodami švirkštą   \n C. Įpilkite daugiau ličio, kad subalansuotumėte   \n Paspauskite pasirinkimo, kurį norite atlikti, numerį',{
								icon = 'fa-solid fa-flask fa-bounce',
								iconAnimation = 'bounce'
							})
					end
					if selection == 1 then
						print("Slected 1")
						
						ESX.ShowNotification('Amfa nelabai kvepia acetonu')
						local test3 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if test3 then
						quality = quality - 2
						pause = false
						else
							quality = quality - 3
							pause = false
						end
					end
					if selection == 2 then
						print("Slected 2")
						
						ESX.ShowNotification('Tai veikė, bet vis tiek per daug')
						local test4 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if test4 then
						pause = false
						quality = quality - 0
						else
							pause = false
							quality = quality - 1
						end
					end
					if selection == 3 then
						print("Slected 3")
						
						ESX.ShowNotification('Sėkmingai subalansavote abi chemines medžiagas ir vėl gerai')
						local test5 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if test5 then
						pause = false
						quality = quality + 3
						else
							pause = false
							quality = quality + 2
					end
				end
			end
				--
				--   EVENT 3
				--
				if progress > 46 and progress < 49 then
					pause = true
					if selection == 0 then
						lib.hideTextUI()
							lib.showTextUI('Radai vandens dažų, ką darai?  \n Z. Pridėkite jį  \n X. Padėkite jį  \n C. Gerk tai  \n Paspauskite pasirinkimo, kurį norite atlikti, numerį',{
								icon = 'fa-solid fa-flask fa-bounce',
								iconAnimation = 'bounce'
							})
					end
					if selection == 1 then
						print("Slected 1")
						
						ESX.ShowNotification('Gera mintis, žmonėms patinka spalvos')
						local test6 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if test6 then
						quality = quality + 4
						pause = false
						else
							quality = quality + 2
							pause = false
						end
					end
					if selection == 2 then
						print("Slected 2")
						
						ESX.ShowNotification('Taip, tai gali sugadinti amfos skonį')
						pause = false
					end
					if selection == 3 then
						print("Slected 3")
						
						ESX.ShowNotification('Jūs esate šiek tiek keistas ir svaigstate, bet viskas gerai')
						pause = false
					end
				end
				--
				--   EVENT 4
				--
				if progress > 55 and progress < 58 then
					pause = true
					if selection == 0 then
						lib.hideTextUI()
						lib.showTextUI('Filtras užsikimšęs, ką daryti?  \n Z. Išvalykite jį suslėgtu oru  \n X. Pakeiskite filtrą  \n C. Nuvalykite jį naudodami dantų šepetėlį  \n Paspauskite pasirinkimo, kurį norite atlikti, numerį',{
                            icon = 'fa-solid fa-flask fa-bounce',
							iconAnimation = 'bounce'
                        })
					end
					if selection == 1 then
						print("Slected 1")
						
						ESX.ShowNotification('Suslėgtas oras apipurškė skystą amfa ant taves')
						local test7 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if test7 then
						quality = quality - 2
						pause = false
						else
							quality = quality - 3
							pause = false
						end
					end
					if selection == 2 then
						print("Slected 2")
						
						ESX.ShowNotification('Tikriausiai geriausias pasirinkimas buvo jį pakeisti')
						local test8 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if test8 then
						pause = false
						quality = quality + 3
						else 
							quality = quality + 2
							pause = false
						end
					end
					if selection == 3 then
						print("Slected 3")
						
						ESX.ShowNotification('Tai veikė gana gerai, bet vis tiek buvo purvinas')
						local test9 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if test9 then
						pause = false
						quality = quality - 1
						else
							quality = quality - 2
							pause = false
						end
					end
				end
				--
				--   EVENT 5
				--
				if progress > 58 and progress < 60 then
					pause = true
					if selection == 0 then
						lib.hideTextUI()
						lib.showTextUI('Išpylėte butelį acetono ant žemės, ką daryti?  \n Z. Atidarykite langus, kad pašalintumėte kvapą  \n X. Palikite tai  \n C. Uždėkite kaukę su oro filtru  \n Paspauskite pasirinkimo, kurį norite atlikti, numerį',{
                            icon = 'fa-solid fa-flask fa-bounce',
							iconAnimation = 'bounce'
                        })
					end
					if selection == 1 then
						print("Slected 1")
						
						ESX.ShowNotification('Jūs atidarėte langus, kad pašalintumėte kvapą')
						local test10 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if test10 then
						quality = quality - 1
						pause = false
						else
							quality = quality - 2
							pause = false
						end
					end
					if selection == 2 then
						print("Slected 2")
						
						ESX.ShowNotification('Per daug įkvėpėte acetono')
						pause = false
						TriggerEvent('esx_methcar:drugged')
					end
					if selection == 3 then
						print("Slected 3")
						
						ESX.ShowNotification('Tai paprastas būdas išspręsti problemą... Manau')
						SetPedPropIndex(playerPed, 1, 26, 7, true)
						pause = false
					end
				end
				--
				--   EVENT 1 - 6
				--
				if progress > 63 and progress < 65 then
					pause = true
					if selection == 0 then
						lib.hideTextUI()
						lib.showTextUI('Propano vamzdis nutekėjo, ką daryti?  \n Z. Pataisykite juostele  \n X. Palikite tai būti  \n C. Pakeiskite  \n Paspauskite pasirinkimo, kurį norite atlikti, numerį',{
                            icon = 'fa-solid fa-flask fa-bounce',
							iconAnimation = 'bounce'
                        })
					end
					if selection == 1 then
						
						print("Slected 1")
						ESX.ShowNotification('Juosta tarsi sustabdė nuotėkį')
						local test11 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if test11 then
						quality = quality - 3
						pause = false
						else
							quality = quality - 4
							pause = false
						end	
					end
					if selection == 2 then
						
						print("Slected 2")
						ESX.ShowNotification('Susprogo propano bakas, jūs sujaukėte...')
						TriggerServerEvent('walker_methcar:pradeti', pos.x, pos.y, pos.z)
						AddExplosion(posx, posy, posz + 2,23, 20.0, true, false, 1.0, true)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						xPlayer.removeInventoryItem('methlab', 1)
						quality = 0
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('PIMPAM BAIGESI NIGERIO GYVENIMAS')
					end
					if selection == 3 then
						
						print("Slected 3")
						ESX.ShowNotification('Geras darbas, vamzdis nebuvo geros būklės')
						local test12 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if test12 then
						pause = false
						quality = quality + 5
						else 
							quality = quality + 3
							pause = false
						end
				end
			end
				--
				--   EVENT 4 - 7
				--
				if progress > 71 and progress < 73 then
					pause = true
					if selection == 0 then
						lib.hideTextUI()
						lib.showTextUI('Filtras užsikimšęs, ką daryti?  \n Z.Išvalykite jį suslėgtu oru  \n X. Pakeiskite filtrą  \n C. Nuvalykite jį naudodami dantų šepetėlį  \n Paspauskite pasirinkimo, kurį norite atlikti, numerį',{
                            icon = 'fa-solid fa-flask fa-bounce',
							iconAnimation = 'bounce'
                        })
					end
					if selection == 1 then
						print("Slected 1")
						
						ESX.ShowNotification('Suslėgtas oras apipurškė skystą metą')
						local paejo = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if paejo then 
						quality = quality - 2
						pause = false
						else
							quality = quality - 3
							pause = false
						end
					end
					if selection == 2 then
						print("Slected 2")
						
						ESX.ShowNotification('Tikriausiai geriausias pasirinkimas buvo jį pakeisti')
						local paejo2 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if paejo2 then
						pause = false
						quality = quality + 3
						else
							quality = quality + 2
							pause = false
						end
					end
					if selection == 3 then
						print("Slected 3")
						
						ESX.ShowNotification('Tai veikė gana gerai, bet vis tiek buvo purvinas')
						local paejo3 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if paejo3 then 
						pause = false
						quality = quality - 1
						else
							quality = quality - 2
							pause = false
						end
					end
				end
				--
				--   EVENT 8
				--
				if progress > 76 and progress < 78 then
					pause = true
					if selection == 0 then
						lib.hideTextUI()
						lib.showTextUI('Netyčia įpylėte per daug acetono, ką daryti?  \n Z. Nieko nedaryk  \n X. Pabandykite jį išsiurbti naudodami švirkštą  \n C. Įpilkite daugiau ličio, kad subalansuotumėte  \n Paspauskite pasirinkimo, kurį norite atlikti, numerį',{
                            icon = 'fa-solid fa-flask fa-bounce',
							iconAnimation = 'bounce'
                        })
					end
					if selection == 1 then
						print("Slected 1")
						
						ESX.ShowNotification('Amfa nelabai kvepia acetonu')
						local flipflop = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if flipflop then
						quality = quality - 3
						pause = false
						else
							quality = quality - 4
							pause = false
						end
					end
					if selection == 2 then
						print("Slected 2")
						
						ESX.ShowNotification('Tai veikė, bet vis tiek per daug')
						local flipflop2 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if flipflop2 then
						pause = false
						quality = quality - 1
						else
							quality = quality - 2
							pause = false
						end
					end
					if selection == 3 then
						print("Slected 3")
						
						ESX.ShowNotification('Sėkmingai subalansavote abi chemines medžiagas ir vėl gerai')
						local flipflop3 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if flipflop3 then
						pause = false
						quality = quality + 3
						else
							quality = quality + 2
							pause = false
						end
					end
				end
				--
				--   EVENT 9
				--
				if progress > 82 and progress < 84 then
					pause = true
					if selection == 0 then
						lib.hideTextUI()
						lib.showTextUI('Tau reikia nusišikti, ką darai?  \n Z. Pabandykite jį laikyti  \n X. Išeik į lauką ir nusišikti  \n C. nusišikti viduje  \n Paspauskite pasirinkimo, kurį norite atlikti, numerį',{
                            icon = 'fa-solid fa-flask fa-bounce',
							iconAnimation = 'bounce'
                        })
					end
					if selection == 1 then
						print("Slected 1")
						
						ESX.ShowNotification('Geras darbas, pirmiausia reikia dirbti, o vėliau')
						local flipasirflopas = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if flipasirflopas then
						quality = quality + 1
						pause = false
						else
							quality = quality + 0
							pause = false
						end
					end
					if selection == 2 then
						print("Slected 2")
						
						ESX.ShowNotification('Kai buvote lauke, stiklas nukrito nuo stalo ir išsiliejo ant grindų...')
						local flipasirflopas2 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if flipasirflopas2 then
						pause = false
						quality = quality - 2
						else
							quality = quality - 3
							pause = false
						end
					end
					if selection == 3 then
						print("Slected 3")
						
						ESX.ShowNotification('Dabar oras kvepia šūdu, o amfa – šūdu')
						local flipasirflopas3 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if flipasirflopas3 then
						pause = false
						quality = quality - 1
						else quality = quality - 2
							pause = false
						end
					end
				end
				--
				--   EVENT 10
				--
				if progress > 88 and progress < 90 then
					pause = true
					if selection == 0 then
						lib.hideTextUI()
						lib.showTextUI('Ar pridedate stiklo gabalėlių į amfa, kad atrodytų, kad turite daugiau?  \n Z. Taip!  \n X. Ne  \n C. Ką daryti, jei vietoj to į stiklą pridėsiu amfos?  \n Paspauskite pasirinkimo, kurį norite atlikti, numerį',{
                            icon = 'fa-solid fa-flask fa-bounce',
							iconAnimation = 'bounce'
                        })
					end
					if selection == 1 then
						print("Slected 1")
						
						ESX.ShowNotification('Dabar jūs turite dar keletą maišelių')
						local nusibodo = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if nusibodo then 
						quality = quality + 1
						pause = false
						else
							quality = quality + 0
							pause = false
						end
					end
					if selection == 2 then
						print("Slected 2")
						
						ESX.ShowNotification('Esate geras narkotiku gamintojas, jūsų produktas yra aukštos kokybės')
						local nusibodo2 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if nusibodo2 then
						pause = false
						quality = quality + 1
						else
							quality = quality + 0
							pause = false
						end
					end
					if selection == 3 then
						print("Slected 3")
						ESX.ShowNotification('Tai šiek tiek per daug, tai daugiau stiklo nei meta, bet gerai')
						local nusibodo3 = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
						if nusibodo3 then
						pause = false
						quality = quality - 1
						else
							quality = quality - 2
							pause = false
						end
					end
				end
				
				
				
				
				
				
				
				if IsPedInAnyVehicle(playerPed) then
					TriggerServerEvent('esx_methcar:make', pos.x,pos.y,pos.z)
					if pause == false then
						selection = 0
						quality = quality + 1
						progress = progress +  math.random(1, 2)
						--ESX.ShowNotification('~r~Meth production: ~g~~h~' .. progress .. '%')
					end
				else
					TriggerEvent('esx_methcar:stop')
				end

			else
				TriggerEvent('esx_methcar:stop')
				progress = 100
				--ESX.ShowNotification('~r~Meth production: ~g~~h~' .. progress .. '%')
				ESX.ShowNotification('Isvirete Amfetamina')
				TriggerServerEvent('esx_methcar:finish', quality)
				FreezeEntityPosition(LastCar, false)
				local alert = lib.alertDialog({
					header = 'Tau pavyko isvirti amfa',
					content = 'Jus isvirete:  ' .. qualtiy * 1.5 .. 'vienetu',
					centered = true,
					cancel = true
				})
			end	
			
		end
		
	end
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
			else
				if started then
					started = false
					displayed = false
					TriggerEvent('esx_methcar:stop')
					print('PIMPAM PASIBAIGE NIGERIO GYVENIMAS')
					FreezeEntityPosition(LastCar,false)
				end		
			end
	end

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)		
		if pause == true then
			if IsControlJustReleased(0, Keys['Z']) then
				selection = 1
				lib.notify({
					title = nil,
					position = 'top',
					description = 'Pasirinktote Z varijanta',
					type = 'success'
				})
				lib.hideTextUI()
			end
			if IsControlJustReleased(0, Keys['X']) then
				selection = 2
				lib.notify({
					title = nil,
					position = 'top',
					description = 'Pasirinktote X varijanta',
					type = 'success'
				})
				lib.hideTextUI()
			end
			if IsControlJustReleased(0, Keys['C']) then
				selection = 3
				lib.notify({
					title = nil,
					position = 'top',
					description = 'Pasirinktote C varijanta',
					type = 'success'
				})
				lib.hideTextUI()
			end
		end

	end
end)




