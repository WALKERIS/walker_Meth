
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

local started, displayed = false, false
local progress, quality = 0, 0
local CurrentVehicle, LastCar
local ESX = exports.es_extended:getSharedObject()


local function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


RegisterNetEvent('esx_methcar:stop', function()
    started = false
    lib.notify({ title = 'Gamyba', description = 'Sustabdyta gamyba', position = 'top-center', type = 'error' })
    FreezeEntityPosition(LastCar, false)
    lib.hideTextUI()
end)
RegisterNetEvent('esx_methcar:stopfreeze', function(id)
    FreezeEntityPosition(id, false)
end)
RegisterNetEvent('esx_methcar:notify', function(message)
    lib.notify({ description = message, type = 'info' })
end)
RegisterNetEvent('esx_methcar:startprod', function()
    lib.notify({ title = 'Gamyba', description = 'Pradedama gamyba', position = 'top-center', type = 'success' })
    started = true; displayed = false; progress = 0; quality = 0
    FreezeEntityPosition(CurrentVehicle, true)
    SetPedIntoVehicle(PlayerPedId(), CurrentVehicle, 3)
    SetVehicleDoorOpen(CurrentVehicle, 2)
	lib.hideTextUI()
end)
RegisterNetEvent('walker_methcar:pradeti', function(x,y,z)
    AddExplosion(x,y,z+2,23,20.0,true,false,1.0,true)
    if not HasNamedPtfxAssetLoaded('core') then
        RequestNamedPtfxAsset('core'); while not HasNamedPtfxAssetLoaded('core') do Citizen.Wait(1) end
    end
    SetPtfxAssetNextCall('core')
    local fire = StartParticleFxLoopedAtCoord('ent_ray_heli_aprtmnt_l_fire', x,y,z-0.8,0,0,0,0.8)
    Citizen.Wait(6000); StopParticleFxLooped(fire,0)
end)
RegisterNetEvent('esx_methcar:drugged', function()
    SetTimecycleModifier('drug_drive_blend01'); SetPedMotionBlur(PlayerPedId(), true)
    SetPedMovementClipset(PlayerPedId(), 'MOVE_M@DRUNK@SLIGHTLYDRUNK', true)
    SetPedIsDrunk(PlayerPedId(), true)
    Citizen.Wait(300000); ClearTimecycleModifier()
end)


local function askEvent(prompt, options)
    lib.hideTextUI()
    local dialog = lib.inputDialog(prompt, {{ type='select', label='', options=options, required=true }}, { allowCancel=false })
    return dialog and dialog[1] or nil
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(6000)
        if started then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            TriggerServerEvent('esx_methcar:make', pos.x, pos.y, pos.z)
        end
    end
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)


        if IsPedInAnyVehicle(ped) then
            CurrentVehicle = GetVehiclePedIsUsing(ped)
            LastCar = CurrentVehicle
            local model = GetDisplayNameFromVehicleModel(GetEntityModel(CurrentVehicle))
            if model=='JOURNEY' and GetPedInVehicleSeat(CurrentVehicle, -1)==ped then
                if not started then
                    if not displayed then lib.showTextUI('[G] - Pradėti gaminti narkotikus'); displayed = true end
                    if IsControlJustReleased(0, Keys['G']) then
                        if pos.y>=3500 and IsVehicleSeatFree(CurrentVehicle,3) then
                            TriggerServerEvent('esx_methcar:start')
                        else
                            lib.notify({ title='Nepavyko', description = 'Reikalavimai neatitinka', type='error', position='top-center'})
                            lib.hideTextUI()
                        end
                    end
                end
            end
        else
            if started then TriggerEvent('esx_methcar:stop') end
			if displayed then lib.hideTextUI(); displayed = false end
        end

        -- Production progress
        if started then
            if progress < 96 then
                Citizen.Wait(6000); 
				progress = progress+1 
                lib.showTextUI(('Progresas %d%%  \n Kokybe %d%%'):format(progress,quality),{position='bottom-center',icon='fa-solid fa-flask',iconAnimation='bounce',style={backgroundColor='#E04131',color='white'}})
                Citizen.Wait(6000)

                -- Event blocks
                local ev
                if progress>22 and progress<24 then
                    ev = { prompt='Propano vamzdis nutekėjo, ką daryti?', options={
                        {value='repair',label='Pataisykite juostele'},
                        {value='ignore',label='Palikite tai būti'},
                        {value='replace',label='Pakeiskite'}
                    }, handler=function(choice)
                        if choice=='repair' then
                            ESX.ShowNotification('Juosta tarsi sustabdė nuotėkį')
                            local ok = lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'})
                            quality = quality + (ok and -1 or -3)
                        elseif choice=='ignore' then
                            ESX.ShowNotification('Susprogo propano bakas...')
                            TriggerServerEvent('walker_methcar:pradeti',pos.x,pos.y,pos.z)
                            started=false; quality=0
                        elseif choice=='replace' then
                            ESX.ShowNotification('Geras darbas, vamzdis pakeistas')
                            local ok = lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'})
                            quality = quality + (ok and 5 or 3)
                        end
                    end }
                elseif progress>30 and progress<32 then
                    ev = { prompt='Išpylėte butelį acetono ant žemės, ką daryti?', options={
                        {value='vent',label='Atidarykite langus'},
                        {value='leave',label='Palikti kaip yra'},
                        {value='mask',label='Uždėkite dujokaukę'}
                    }, handler=function(choice)
                        if choice=='vent' then
                            ESX.ShowNotification('Atidarėte langus')
                            local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality+(ok and 0 or -1)
                        elseif choice=='leave' then
                            ESX.ShowNotification('Per daug įkvėpėte acetono'); TriggerEvent('esx_methcar:drugged')
                        elseif choice=='mask' then
                            ESX.ShowNotification('Uždėjote dujokaukę'); SetPedPropIndex(ped,1,26,7,true)
                        end
                    end }
                elseif progress>38 and progress<40 then
                    ev = { prompt='Amfa per greitai tampa kieta, ką daryti?', options={
                        {value='pressure',label='Padidinkite slėgį'},
                        {value='heat',label='Pakelkite temperatūrą'},
                        {value='reduce',label='Sumažinkite slėgį'}
                    }, handler=function(choice)
                        if choice=='pressure' then ESX.ShowNotification('Slėgį pakėlėte')
                        elseif choice=='heat' then local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality+(ok and 5 or 3)
                        elseif choice=='reduce' then local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality-(ok and 2 or 4)
                        end
                    end }
                elseif progress>41 and progress<43 then
                    ev = { prompt='Netyčia įpylėte per daug acetono, ką daryti?', options={
                        {value='nothing',label='Nieko nedaryk'},
                        {value='suck',label='Išsiurbti švirkštu'},
                        {value='lithium',label='Įpilkite daugiau ličio'}
                    }, handler=function(choice)
                        if choice=='nothing' then local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality-(ok and 2 or 3)
                        elseif choice=='suck' then local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality-(ok and 0 or 1)
                        elseif choice=='lithium' then local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality+(ok and 3 or 2)
                        end
                    end }
                elseif progress>46 and progress<49 then
                    ev = { prompt='Radote vandens dažų, ką darote?', options={
                        {value='add',label='Pridėkite'},
                        {value='put',label='Padėkite'},
                        {value='drink',label='Gerkite'}
                    }, handler=function(choice)
                        if choice=='add' then local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality+(ok and 4 or 2)
                        else ESX.ShowNotification('...')
                        end
                    end }
                elseif progress>55 and progress<58 then
                    ev = { prompt='Filtras užsikimšęs, ką daryti?', options={
                        {value='blast',label='Suslėgtu oru'},
                        {value='replace',label='Pakeiskite filtrą'},
                        {value='brush',label='Valykite šepetėliu'}
                    }, handler=function(choice)
                        if choice=='blast' then local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality-(ok and 2 or 3)
                        elseif choice=='replace' then local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality+(ok and 3 or 2)
                        else local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality-(ok and 1 or 2)
                        end
                    end }
                elseif progress>58 and progress<60 then
					ev = { prompt='Išpylėte butelį acetono ant žemės, ką daryti?', options={
                        {value='vent',label='Atidarykite langus'},
                        {value='leave',label='Palikti kaip yra'},
                        {value='mask',label='Uždėkite dujokaukę'}
                    }, handler=function(choice)
                        if choice=='vent' then
                            ESX.ShowNotification('Atidarėte langus')
                            local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality+(ok and 0 or -1)
                        elseif choice=='leave' then
                            ESX.ShowNotification('Per daug įkvėpėte acetono'); TriggerEvent('esx_methcar:drugged')
                        elseif choice=='mask' then
                            ESX.ShowNotification('Uždėjote dujokaukę'); SetPedPropIndex(ped,1,26,7,true)
                        end
                    end }
                elseif progress>63 and progress<65 then
					ev = { prompt='Propano vamzdis nutekėjo, ką daryti?', options={
                        {value='repair',label='Pataisykite juostele'},
                        {value='ignore',label='Palikite tai būti'},
                        {value='replace',label='Pakeiskite'}
                    }, handler=function(choice)
                        if choice=='repair' then
                            ESX.ShowNotification('Juosta tarsi sustabdė nuotėkį')
                            local ok = lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'})
                            quality = quality + (ok and -1 or -3)
                        elseif choice=='ignore' then
                            ESX.ShowNotification('Susprogo propano bakas...')
                            TriggerServerEvent('walker_methcar:pradeti',pos.x,pos.y,pos.z)
                            started=false; quality=0
                        elseif choice=='replace' then
                            ESX.ShowNotification('Geras darbas, vamzdis pakeistas')
                            local ok = lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'})
                            quality = quality + (ok and 5 or 3)
                        end
                    end }
                elseif progress>71 and progress<73 then
					ev = { prompt='Filtras užsikimšęs, ką daryti?', options={
                        {value='blast',label='Suslėgtu oru'},
                        {value='replace',label='Pakeiskite filtrą'},
                        {value='brush',label='Valykite šepetėliu'}
                    }, handler=function(choice)
                        if choice=='blast' then local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality-(ok and 2 or 3)
                        elseif choice=='replace' then local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality+(ok and 3 or 2)
                        else local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality-(ok and 1 or 2)
                        end
                    end }
                elseif progress>76 and progress<78 then
                    ev = { prompt='Išpylėte butelį acetono ant žemės, ką daryti?', options={
                        {value='vent',label='Atidarykite langus'},
                        {value='leave',label='Palikti kaip yra'},
                        {value='mask',label='Uždėkite dujokaukę'}
                    }, handler=function(choice)
                        if choice=='vent' then
                            ESX.ShowNotification('Atidarėte langus')
                            local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality+(ok and 0 or -1)
                        elseif choice=='leave' then
                            ESX.ShowNotification('Per daug įkvėpėte acetono'); TriggerEvent('esx_methcar:drugged')
                        elseif choice=='mask' then
                            ESX.ShowNotification('Uždėjote dujokaukę'); SetPedPropIndex(ped,1,26,7,true)
                        end
                    end }
                elseif progress>82 and progress<84 then
                    ev = { prompt='Tau reikia nusišikti, ką darai?', options={
                        {value='hold',label='Laikykite'},
                        {value='outside',label='Eikite į lauką'},
                        {value='inside',label='Viduje'}
                    }, handler=function(choice)
                        if choice=='hold' then local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality+(ok and 1 or 0)
                        elseif choice=='outside' then local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality-(ok and 2 or 3)
                        else local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality-(ok and 1 or 2)
                        end
                    end }
                elseif progress>88 and progress<90 then
                    ev = { prompt='Pridedate stiklo gabalėlių, kad turėtumėte daugiau?', options={
                        {value='yes',label='Taip'},
                        {value='no',label='Ne'},
                        {value='swap',label='Keisti stiklas/amfa'}
                    }, handler=function(choice)
                        if choice=='yes' then local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality+(ok and 1 or 0)
                        elseif choice=='no' then local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality+(ok and 1 or 0)
                        else local ok=lib.skillCheck({'easy','easy','easy'},{'w','a','s','d'}); quality=quality-(ok and 1 or 2)
                        end
                    end }
                end
                if ev then
                    local choice = askEvent(ev.prompt, ev.options)
                    if choice then ev.handler(choice) end
                else

                    quality = quality + 1
                    progress = progress + math.random(1,2)
                end
            else

                TriggerEvent('esx_methcar:stop')
                ESX.ShowNotification('Išvirete Amfetamina')
                TriggerServerEvent('esx_methcar:finish', quality)
                lib.alertDialog({header='Tau pavyko isvirti amfa', centered=true, cancel=true})
            end
        end
    end
end)
