
local dragStatus = {}
local IsHandcuffed = false
dragStatus.isDragged = false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
    RefreshLSPDMoney()
end)


local societylspdmoney = nil
local priselspdservice = false

Citizen.CreateThread(function()
	
    while true do
        Citizen.Wait(0)
        local coords, letSleep = GetEntityCoords(PlayerPedId()), true

        for k,v in pairs(ConfigPolice.pos) do
        	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' then 
            if (ConfigPolice.Type ~= -1 and GetDistanceBetweenCoords(coords, v.position.x, v.position.y, v.position.z, true) < ConfigPolice.DrawDistance) then
                DrawMarker(ConfigPolice.Type, v.position.x, v.position.y, v.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ConfigPolice.Size.x, ConfigPolice.Size.y, ConfigPolice.Size.z, ConfigPolice.Color.r, ConfigPolice.Color.g, ConfigPolice.Color.b, 100, false, true, 2, false, false, false, false)
                letSleep = false
            end
        end
        for k,v in pairs(ConfigPolice.posprison) do
            if (ConfigPolice.Type ~= -1 and GetDistanceBetweenCoords(coords, v.position.x, v.position.y, v.position.z, true) < ConfigPolice.DrawDistance) then
                DrawMarker(ConfigPolice.Type, v.position.x, v.position.y, v.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ConfigPolice.Size.x, ConfigPolice.Size.y, ConfigPolice.Size.z, ConfigPolice.Color.r, ConfigPolice.Color.g, ConfigPolice.Color.b, 100, false, true, 2, false, false, false, false)
                letSleep = false
        end
        end

        if letSleep then
            Citizen.Wait(500)
        end
    
end
end
end)

function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
		RemoveAnimDict(dictname)
	end
end

Citizen.CreateThread(function()

        local comicomap = AddBlipForCoord(ConfigPolice.blip.position.x, ConfigPolice.blip.position.y, ConfigPolice.blip.position.z)
        SetBlipSprite(comicomap, 60)
        SetBlipColour(comicomap, 29)
        SetBlipAsShortRange(comicomap, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("LSPD")
        EndTextCommandSetBlipName(comicomap)

end)

------changement tenu prisonnier
local tenuprison = false
RMenu.Add('tenuprisonlspd', 'main', RageUI.CreateMenu("Vestiaire prison", "Pour prendre votre tenue de prisonnier ou reprendre votre tenue civil."))
RMenu:Get('tenuprisonlspd', 'main').Closed = function()
    tenuprison = false
end

function tenuprilspd()
    if not tenuprison then
        tenuprison = true
        RageUI.Visible(RMenu:Get('tenuprisonlspd', 'main'), true)
    while tenuprison do
        RageUI.IsVisible(RMenu:Get('tenuprisonlspd', 'main'), true, true, true, function()
            RageUI.Button("Tenue civil", "Pour prendre votre tenue civil.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
            ESX.ShowNotification('Vous avez repris votre ~b~tenue civil')
            end)
            end
            end)
           
            RageUI.Button("Tenue prisonnier", "Pour prendre votre tenue prisonnier.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            SetPedComponentVariation(GetPlayerPed(-1) , 8, 15, 0) --tshirt 
            SetPedComponentVariation(GetPlayerPed(-1) , 11, 146, 0)  --torse
            SetPedComponentVariation(GetPlayerPed(-1) , 10, 0, 0)  --decals
            SetPedComponentVariation(GetPlayerPed(-1) , 3, 41, 0)  -- bras
            SetPedComponentVariation(GetPlayerPed(-1) , 4, 3, 7)   --pants
            SetPedComponentVariation(GetPlayerPed(-1) , 6, 12, 12)   --shoes
            SetPedComponentVariation(GetPlayerPed(-1) , 7, 50, 0)   --Chaine
            SetPedPropIndex(GetPlayerPed(-1) , 0, -1, 0)   --helmet
            SetPedPropIndex(GetPlayerPed(-1) , 2, 0, 0)   --ears
            ESX.ShowNotification('Vous avez équipé votre ~b~tenue de de prisonnier')
            end
            end)   
        end, function()
        end)
            Citizen.Wait(0)
        end
    else
        tenuprison = false
    end
end

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
    
    
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, 465.32, -999.74, 24.91)
            if dist <= 1.0 then
              
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au vestiaire de la prison")
                    if IsControlJustPressed(1,51) then
                        tenuprilspd()
                    end   
                
                
            end
        end
end)
----fin changement tenu prisonnier
-------Vestiaire
local vestilspd = false
RMenu.Add('vestiairelspd', 'main', RageUI.CreateMenu("Vestiaire", "Pour prendre votre tenue de service ou reprendre votre tenue civil."))
RMenu:Get('vestiairelspd', 'main').Closed = function()
    vestilspd = false
end

function vestiairelspd()
    if not vestilspd then
        vestilspd = true
        RageUI.Visible(RMenu:Get('vestiairelspd', 'main'), true)
    while vestilspd do
        RageUI.IsVisible(RMenu:Get('vestiairelspd', 'main'), true, true, true, function()
            RageUI.Button("Tenue civil", "Pour prendre votre tenue civil.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
			ESX.ShowNotification('Vous avez repris votre ~b~tenue civil')
			priselspdservice = false
			end)
            end
            end)
            if ESX.PlayerData.job.grade_name == 'cadet' then
            
            RageUI.Button("Tenue cadet", "Pour prendre votre tenue cadet.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
			SetPedComponentVariation(GetPlayerPed(-1) , 8, 59, 1) --tshirt 
			SetPedComponentVariation(GetPlayerPed(-1) , 11, 55, 0)  --torse
			SetPedComponentVariation(GetPlayerPed(-1) , 10, 0, 0)  --decals
			SetPedComponentVariation(GetPlayerPed(-1) , 3, 41, 0)  -- bras
			SetPedComponentVariation(GetPlayerPed(-1) , 4, 25, 0)   --pants
			SetPedComponentVariation(GetPlayerPed(-1) , 6, 25, 0)   --shoes
			SetPedComponentVariation(GetPlayerPed(-1) , 7, 0, 0)   --Chaine
			SetPedPropIndex(GetPlayerPed(-1) , 0, 46, 0)   --helmet
			SetPedPropIndex(GetPlayerPed(-1) , 2, 2, 0)   --ears
            ESX.ShowNotification('Vous avez pris votre service et vous avez équipé votre ~b~tenue de cadet')
            priselspdservice = true
            end
            end)
        	end
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' and ESX.PlayerData.job.grade_name == 'officier' or ESX.PlayerData.job.grade_name == 'sergent' or ESX.PlayerData.job.grade_name == 'lieutenant' or ESX.PlayerData.job.grade_name == 'boss' then            
            RageUI.Button("Tenue police basique", "Pour prendre votre tenue police basique.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
			SetPedComponentVariation(GetPlayerPed(-1) , 8, 58, 0) --tshirt 
			SetPedComponentVariation(GetPlayerPed(-1) , 11, 55, 0)  --torse
			SetPedComponentVariation(GetPlayerPed(-1) , 10, 0, 0)  --decals
			SetPedComponentVariation(GetPlayerPed(-1) , 3, 41, 0)  -- bras
			SetPedComponentVariation(GetPlayerPed(-1) , 4, 25, 0)   --pants
			SetPedComponentVariation(GetPlayerPed(-1) , 6, 25, 0)   --shoes
			SetPedComponentVariation(GetPlayerPed(-1) , 7, 0, 0)   --Chaine
			SetPedPropIndex(GetPlayerPed(-1) , 2, 2, 0)   --ears
            ESX.ShowNotification('Vous avez pris votre service et vous avez équipé votre ~b~tenue police basique')
            priselspdservice = true
            end
            end)

            RageUI.Button("Gilet par balle", "Pour prendre votre gilet par balle.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            SetPedComponentVariation(GetPlayerPed(-1) , 9, 11, 1)   --bulletwear
            SetPedArmour(GetPlayerPed(-1), 100)
            ESX.ShowNotification('Vous avez pris votre service et vous avez équipé votre ~b~gilet par balle')
            priselspdservice = true
            end
            end)
            
        end

            
        end, function()
        end)
            Citizen.Wait(0)
        end
    else
        vestilspd = false
    end
end

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
    
    
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, ConfigPolice.pos.vestiaire.position.x, ConfigPolice.pos.vestiaire.position.y, ConfigPolice.pos.vestiaire.position.z)
		    if dist <= 1.0 then
		    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' then 	
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au vestiaire")
                    if IsControlJustPressed(1,51) then
                        vestiairelspd()
                    end   
                
               end 
            end
        end
end)

--------Fin vestiaire

-------armurerie
local armupdwllh = false
RMenu.Add('armurerielspd', 'main', RageUI.CreateMenu("Armurerie", "Pour prendre vos armes de fonction."))
RMenu.Add('armurerielspd', 'coffre', RageUI.CreateSubMenu(RMenu:Get('armurerielspd', 'main'), "Stockage", "Pour stocker vos objets ou autre."))
RMenu:Get('armurerielspd', 'main').Closed = function()
    armupdwllh = false
end

function ouvrirarmulspd()
    if not armupdwllh then
        armupdwllh = true
        RageUI.Visible(RMenu:Get('armurerielspd', 'main'), true)
    while armupdwllh do
        RageUI.IsVisible(RMenu:Get('armurerielspd', 'main'), true, true, true, function()
        	 if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' and ESX.PlayerData.job.grade_name == 'officier' or ESX.PlayerData.job.grade_name == 'sergent' or ESX.PlayerData.job.grade_name == 'lieutenant' or ESX.PlayerData.job.grade_name == 'boss' then
        	RageUI.Button("Stockage", "Pour déposer/récupérer des armes ou objets.", {RightLabel = "→→→"},true, function()
            end, RMenu:Get('armurerielspd', 'coffre'))     
            end     
            RageUI.Button("Equipement de base", "Pour prendre votre équipement de base. (Taser, matraque, lampe torche)", {RightLabel = "~r~500$"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            TriggerServerEvent('h4ci_lspd:equipementbase')
            end
            end)

            for k,v in pairs(ConfigPolice.armurerie) do
            RageUI.Button(v.nom, "Pour obtenir un "..v.nom, {RightLabel = "~r~$"..v.prix},true, function(Hovered, Active, Selected)
            if (Selected) then   
            TriggerServerEvent('h4ci_lspd:armurerie', v.arme, v.prix)
            end
            end)
        end



        end, function()
        end)
        RageUI.IsVisible(RMenu:Get('armurerielspd', 'coffre'), true, true, true, function()
        	RageUI.Button("Prendre objet", "Pour prendre un objet.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            RageUI.CloseAll()
            armupdwllh = false
            OpenGetStocksLSPDMenu()
            end
            end)
            RageUI.Button("Déposer objet", "Pour déposer un objet.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            RageUI.CloseAll()
            armupdwllh = false
            OpenPutStocksLSPDMenu()
            end
            end)
    		end, function()
			end)
            Citizen.Wait(0)
        end
    else
        armupdwllh = false
    end
end

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
    

    
                local plyCoords2 = GetEntityCoords(GetPlayerPed(-1), false)
                local dist2 = Vdist(plyCoords2.x, plyCoords2.y, plyCoords2.z, ConfigPolice.pos.armurerie.position.x, ConfigPolice.pos.armurerie.position.y, ConfigPolice.pos.armurerie.position.z)
		    if dist2 <= 1.0 then
		    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' then 	
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder à l'armurerie")
                    if IsControlJustPressed(1,51) then
                        ouvrirarmulspd()
                    end   
                end
               end 
        end
end)


--coffre
function OpenGetStocksLSPDMenu()
	ESX.TriggerServerCallback('h4ci_lspd:prendreitem', function(items)
		local elements = {}

		for i=1, #items, 1 do
            table.insert(elements, {
                label = 'x' .. items[i].count .. ' ' .. items[i].label,
                value = items[i].name
            })
        end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css      = 'police',
			title    = 'police stockage',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
                css      = 'police',
				title = 'quantité'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					ESX.ShowNotification('quantité invalide')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('h4ci_lspd:prendreitems', itemName, count)

					Citizen.Wait(300)
					OpenGetStocksLSPDMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksLSPDMenu()
	ESX.TriggerServerCallback('h4ci_lspd:inventairejoueur', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css      = 'police',
			title    = 'inventaire',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
                css      = 'police',
				title = 'quantité'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					ESX.ShowNotification('quantité invalide')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('h4ci_lspd:stockitem', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksLSPDMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end
--fin coffre
--------Fin armurerie

------ bureau boss
Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
                local plyCoords6 = GetEntityCoords(GetPlayerPed(-1), false)
                local dist6 = Vdist(plyCoords6.x, plyCoords6.y, plyCoords6.z, ConfigPolice.pos.boss.position.x, ConfigPolice.pos.boss.position.y, ConfigPolice.pos.boss.position.z)
		    if dist6 <= 1.0 then
		    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' and ESX.PlayerData.job.grade_name == 'boss' then	
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder à la gestion d'entreprise")
                    if IsControlJustPressed(1,51) then
                        OpenBossActionsLSPDMenu()
                    end   
                end
               end 
        end
end)

function OpenBossActionsLSPDMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lspd',{
        css      = 'lspd',
        title    = 'Action commandant',
        align    = 'top-left',
        elements = {
            {label = 'Action chef', value = 'boss_lspdactions'},
    }}, function (data, menu)
        if data.current.value == 'boss_lspdactions' then
            TriggerEvent('esx_society:openBossMenu', 'lspd', function(data2, menu2)
                menu2.close()
            end)
        end

    end, function (data, menu)
        menu.close()

    end)
end

-------fin bureau boss

-------garage
local pdgarage = false
RMenu.Add('garagelspd', 'main', RageUI.CreateMenu("Garage", "Pour sortir des véhicules de police."))
RMenu:Get('garagelspd', 'main').Closed = function()
    pdgarage = false
end

function ouvrirgarpd()
    if not pdgarage then
        pdgarage = true
        RageUI.Visible(RMenu:Get('garagelspd', 'main'), true)
    while pdgarage do
        RageUI.IsVisible(RMenu:Get('garagelspd', 'main'), true, true, true, function() 
        	RageUI.Button("Ranger voiture", "Pour ranger une voiture.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
			if dist4 < 4 then
				ESX.ShowAdvancedNotification("Garagiste karim", "La voiture est de retour merci!", "", "CHAR_BIKESITE", 1)
				DeleteEntity(veh)
			end	
            end
            end)         
            for k,v in pairs(ConfigPolice.garagevoiture) do
            RageUI.Button(v.nom, "Pour sortir une "..v.nom, {RightLabel = "Dispo ["..v.stock.."]"},true, function(Hovered, Active, Selected)
            if (Selected) then
            if v.stock > 0 then
            ESX.ShowAdvancedNotification("Garagiste karim", "La voiture arrive dans quelques instant..", "", "CHAR_BIKESITE", 1) 
            Citizen.Wait(2000)   
            spawnCar(v.modele)
            ESX.ShowAdvancedNotification("Garagiste karim", "Abime pas la voiture grosse folle !", "", "CHAR_BIKESITE", 1) 
            v.stock = v.stock - 1
        	else
        	ESX.ShowNotification("Plus de voiture en stock!")
        	end
            end
            end)
            end
            
        end, function()
        end)
            Citizen.Wait(0)
        end
    else
        pdgarage = false
    end
end

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
    

    
                local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
                local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, ConfigPolice.pos.garagevoiture.position.x, ConfigPolice.pos.garagevoiture.position.y, ConfigPolice.pos.garagevoiture.position.z)
		    if dist3 <= 3.0 then
		    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' then 	
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au garage")
                    if IsControlJustPressed(1,51) then
                    	if priselspdservice == true then            
                        ouvrirgarpd()
                        else
                			ESX.ShowNotification("Vous n'avez pas pris votre service au vestiaire...")
                		end
                    end   
                end
               end 
        end
end)

function spawnCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, ConfigPolice.pos.spawnvoiture.position.x, ConfigPolice.pos.spawnvoiture.position.y, ConfigPolice.pos.spawnvoiture.position.z, ConfigPolice.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "LSPDH"..math.random(1,9).."C"..math.random(1,9)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1) 
end

--------Fin garage

-------helico garage
local garahelipd = false
RMenu.Add('garagehelicolspd', 'main', RageUI.CreateMenu("Garage", "Pour sortir des hélico de police."))
RMenu:Get('garagehelicolspd', 'main').Closed = function()
    garahelipd = false
end

function ouvrirgarhelipd()
    if not garahelipd then
        garahelipd = true
        RageUI.Visible(RMenu:Get('garagehelicolspd', 'main'), true)
    while garahelipd do
        RageUI.IsVisible(RMenu:Get('garagehelicolspd', 'main'), true, true, true, function() 
        	RageUI.Button("Ranger hélico", "Pour ranger un hélico.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
			if dist4 < 9 then
				ESX.ShowAdvancedNotification("Garagiste karim", "L'hélico a bien été retourner, merci!", "", "CHAR_BIKESITE", 1)
				DeleteEntity(veh)
			end	
            end
            end)         
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' and ESX.PlayerData.job.grade_name == 'lieutenant' or ESX.PlayerData.job.grade_name == 'boss' then
            RageUI.Button("Hélico", "Pour sortir un hélico.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then
            ESX.ShowAdvancedNotification("Garagiste karim", "L'hélico arrive dans quelques instant..", "", "CHAR_BIKESITE", 1) 
            Citizen.Wait(2000)   
            spawnHeli("polmav")
            ESX.ShowAdvancedNotification("Garagiste karim", "Abime pas l'hélico grosse folle !", "", "CHAR_BIKESITE", 1) 
            end
            end)
        	end
            

            
        end, function()
        end)
            Citizen.Wait(0)
        end
    else
        garahelipd = false
    end
end

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
    

    
                local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
                local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, ConfigPolice.pos.garagehelico.position.x, ConfigPolice.pos.garagehelico.position.y, ConfigPolice.pos.garagehelico.position.z)
		    if dist3 <= 3.0 then
		    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' then 	
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au garage hélico")
                    if IsControlJustPressed(1,51) then
                    	if priselspdservice == true then
                        ouvrirgarhelipd()
                         else
                			ESX.ShowNotification("Vous n'avez pas pris votre service au vestiaire...")
                		end
                    end   
                end
               end 
        end
end)

function spawnHeli(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, ConfigPolice.pos.spawnhelico.position.x,ConfigPolice.pos.spawnhelico.position.y, ConfigPolice.pos.spawnhelico.position.z, ConfigPolice.pos.spawnhelico.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "LSPDH"..math.random(1,9).."C"..math.random(1,9)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
end

--------Fin helico garage




-------menu f6


local f6lspd = false

RMenu.Add('lspdf6', 'main', RageUI.CreateMenu("Menu LSPD", "Pour effectuer différentes tâches"))
RMenu.Add('lspdf6', 'amende', RageUI.CreateSubMenu(RMenu:Get('lspdf6', 'main'), "Amendes", "Pour mettre une amende à un citoyen"))
RMenu.Add('lspdf6', 'commandant', RageUI.CreateSubMenu(RMenu:Get('lspdf6', 'main'), "Option commandant", "Option disponible pour le commandant"))
RMenu.Add('lspdf6', 'int_citoyen', RageUI.CreateSubMenu(RMenu:Get('lspdf6', 'main'), "Interaction citoyen", "Pour agir avec les citoyens"))
RMenu:Get('lspdf6', 'main').Closed = function()
    f6lspd = false
end

function ouvrirf6lspd()
    if not f6lspd then
        f6lspd = true
        RageUI.Visible(RMenu:Get('lspdf6', 'main'), true)
    while f6lspd do
        

        RageUI.IsVisible(RMenu:Get('lspdf6', 'main'), true, true, true, function() 
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' and ESX.PlayerData.job.grade_name == 'boss' then	
        RageUI.Button("Option commandant", "Option disponible pour le commandant", {RightLabel = "→→→"},true, function()
        end, RMenu:Get('lspdf6', 'commandant'))
        end
        RageUI.Button("Interaction citoyen", "Pour agir avec les citoyens", {RightLabel = "→→→"},true, function()
        end, RMenu:Get('lspdf6', 'int_citoyen'))
        RageUI.Button("Amendes", "Pour mettre une amende à un citoyen", {RightLabel = "→→→"},true, function()
        end, RMenu:Get('lspdf6', 'amende'))
        RageUI.Button("Voiture en fourrière", "Pour mettre une voiture en fourrière", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
                local playerPed = PlayerPedId()

            if IsPedSittingInAnyVehicle(playerPed) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)

                if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                    ESX.ShowNotification('la voiture a été mis en fourrière bg')
                    ESX.Game.DeleteVehicle(vehicle)
                   
                else
                    ESX.ShowNotification('met toi côté conducteur bg pour la mettre en fourrière ou sort de la voiture')
                end
            else
                local vehicle = ESX.Game.GetVehicleInDirection()

                if DoesEntityExist(vehicle) then
                    ESX.ShowNotification('la voiture a été mis en fourrière bg')
                    ESX.Game.DeleteVehicle(vehicle)

                else
                    ESX.ShowNotification('ya pas de voiture autour bg ouvre les yeux')
                end
            end
            end
            end)
        RageUI.Button("Droit miranda", "Pour voir les droits miranda", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
                ESX.ShowNotification("Monsieur / Madame (Prénom et nom de la personne), je vous arrête pour (motif de l'arrestation).")
            	ESX.ShowNotification("Vous avez le droit de garder le silence.")
            	ESX.ShowNotification("Si vous renoncez à ce droit, tout ce que vous direz pourra être et sera utilisé contre vous.")
            	ESX.ShowNotification("Vous avez le droit à un avocat, si vous n’en avez pas les moyens, un avocat vous sera fourni.")
            	ESX.ShowNotification("Vous avez le droit à une assistance médicale ainsi qu'à de la nourriture et de l'eau.")
            	ESX.ShowNotification("Avez-vous bien compris vos droits ?")
            end
            end)
    

        end, function()
        end)
        RageUI.IsVisible(RMenu:Get('lspdf6', 'commandant'), true, true, true, function()
            if societylspdmoney ~= nil then
            RageUI.Button("Montant disponible dans la société :", nil, {RightLabel = "$" .. societylspdmoney}, true, function()
            end)
        end
            RageUI.Button("Message à la LSPD", "Pour écrire un message à toute la LSPD", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
                local info = 'commandant'
                local message = KeyboardInput('Veuillez mettre le messsage à envoyer', '', 40)
				TriggerServerEvent('h4ci_lspd:commandantmess', info, message)
            end
            end)
            RageUI.Button("Annonce recrutement", "Pour annoncer des recrutements au comico", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
				TriggerServerEvent('h4c1_lspd:annoncerecrutement')
            end
            end)
            RageUI.Button("Donner le PPA", "Pour donner le permis port d'arme à quelqu'un", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'weapon')
                 else
                    ESX.ShowNotification('Aucun joueurs à proximité')
                end 
            end
            end)
        end, function()
        end)
        RageUI.IsVisible(RMenu:Get('lspdf6', 'int_citoyen'), true, true, true, function()
        	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
            RageUI.Button("Menotter/démenotter", "Pour menotter/démenotter la personne", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
                local target, distance = ESX.Game.GetClosestPlayer()
				playerheading = GetEntityHeading(GetPlayerPed(-1))
				playerlocation = GetEntityForwardVector(PlayerPedId())
				playerCoords = GetEntityCoords(GetPlayerPed(-1))
				local target_id = GetPlayerServerId(target)
				if distance <= 2.0 then
					TriggerServerEvent('h4c1_lspd:lanceranimationmenotte', target_id, playerheading, playerCoords, playerlocation)
					Wait(5000)
					TriggerServerEvent('h4ci_lspd:menotterserv', GetPlayerServerId(closestPlayer))
				else
					ESX.ShowNotification('Peronne autour')
				end
            end
            end)
            RageUI.Button("Escorter", "Pour escorter la personne menotter", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
                TriggerServerEvent('h4ci_lspd:escorterserv', GetPlayerServerId(closestPlayer))
            end
            end)
            RageUI.Button("Carte d'identité", "Pour voir la carte d'identité de la personne proche", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
                RageUI.CloseALL()
                f6lspd = false
                OpenIdentityCardMenu(closestPlayer)
            end
            end)
            RageUI.Button("Fouiller", "Pour fouiller la personne proche", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
                RageUI.CloseALL()
                f6lspd = false
                OpenBodySearchMenu(closestPlayer)
            end
            end)
        	else
        	RageUI.Button("Aucun citoyen proche de vous", "Pas de citoyen avec qui agir", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
            end
            end)	
        	end	

        end, function()
        end)
        RageUI.IsVisible(RMenu:Get('lspdf6', 'amende'), true, true, true, function()
        	 RageUI.Button("Amende personnalisé", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('Personne autour')
                    else
                    	local prixamende = KeyboardInput('Veuillez mettre le montant à facturer', '', 12)
                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_lspd', "LSPD", prixamende)
                    end
            end
            end)
            for k, v in pairs(ConfigPolice.amende) do
            RageUI.Button(v.nom, nil, {RightLabel = "~r~$"..v.prix}, true, function(Hovered, Active, Selected)
                if (Selected) then   
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('Personne autour')
                    else
                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_lspd', v.nom, v.prix)
                    end
            end
            end)
            end
        end, function()
        end)

            Citizen.Wait(0)
        end
    else
        f6lspd = false
    end
end

	RegisterNetEvent('h4ci_lspd:infoservice')
AddEventHandler('h4ci_lspd:infoservice', function(service, nom, message)
	if service == 'commandant' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('INFO COMMANDANT', '~b~A lire', 'Commandant: ~g~'..nom..'\n~w~Message: ~g~'..message..'', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)	
	end
end)

function RefreshLSPDMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietyLSPDMoney(money)
        end, ESX.PlayerData.job.name)
    end
end

function UpdateSocietyLSPDMoney(money)
    societylspdmoney = ESX.Math.GroupDigits(money)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)


    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

RegisterNetEvent('h4c1_lspd:animationmenotte')
AddEventHandler('h4c1_lspd:animationmenotte', function(playerheading, playercoords, playerlocation)
	playerPed = GetPlayerPed(-1)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	cuffed = true
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
end)

RegisterNetEvent('h4c1_lspd:animationdemenotte')
AddEventHandler('h4c1_lspd:animationdemenotte', function()
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Citizen.Wait(3000)

end) 

RegisterNetEvent('h4c1_lspd:menotterclient')
AddEventHandler('h4c1_lspd:menotterclient', function()
	IsHandcuffed    = not IsHandcuffed
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		if IsHandcuffed then

			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(100)
			end

			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            DisableControlAction(2, 37, true)
			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 1, true) -- Disable pan
			DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 31, true) -- S
			DisableControlAction(0, 30, true) -- D

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			--FreezeEntityPosition(playerPed, true)
			DisplayRadar(false)

		else

			ClearPedSecondaryTask(playerPed)
            DisableControlAction(2, 37, false)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
            DisableControlAction(0, 106, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			--FreezeEntityPosition(playerPed, false)
			DisplayRadar(true)
		end
	end)

end)

RegisterNetEvent('h4ci_lspd:escorterclient')
AddEventHandler('h4ci_lspd:escorterclient', function(copId)
	if not IsHandcuffed then
		return
	end

	dragStatus.isDragged = not dragStatus.isDragged
	dragStatus.CopId = copId
end)

function OpenBodySearchMenu(player)
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		local elements = {}

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
				table.insert(elements, {
					label    = 'argent sale ', ESX.Math.Round(data.accounts[i].money),
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})

				break
			end
		end

		table.insert(elements, {label = 'armes '})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    = 'armes ', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo,
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end

		table.insert(elements, {label = 'items '})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label    = 'items ', data.inventory[i].count, data.inventory[i].label,
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			title    = 'fouille',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value then
				TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
				OpenBodySearchMenu(player)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenIdentityCardMenu(player)
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		local elements = {
			{label = 'name', data.name}
		}

		if Config.EnableESXIdentity then
			table.insert(elements, {label = 'sex', data.sex})
			table.insert(elements, {label = 'dob', data.dob})
			table.insert(elements, {label = 'height', data.height})
		end

		if data.drunk then
			table.insert(elements, {label = 'bac', data.drunk})
		end

		if data.licenses then
			table.insert(elements, {label = 'license_label'})

			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
			title    = 'citizen_interaction',
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		Citizen.Wait(1)

		if IsHandcuffed then
			playerPed = PlayerPedId()

			if dragStatus.isDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

				-- undrag if target is in an vehicle
				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end

				if IsPedDeadOrDying(targetPed, true) then
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end

			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'lspd' then
            	
                    if IsControlJustPressed(1,167) then
                    	if priselspdservice == true then
                        ouvrirf6lspd()
                        RefreshLSPDMoney()
                        else
                			ESX.ShowNotification("Vous n'avez pas pris votre service au vestiaire...")
                		end
                    end
                
       		 end
       		end
    end)

