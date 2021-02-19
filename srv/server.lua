ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'lspd', 'alerte LSPD', true, true)

TriggerEvent('esx_society:registerSociety', 'lspd', 'Police', 'society_lspd', 'society_lspd', 'society_lspd', {type = 'public'})

----- armurerie
RegisterNetEvent('h4ci_lspd:equipementbase')
AddEventHandler('h4ci_lspd:equipementbase', function()
local _source = source
local xPlayer = ESX.GetPlayerFromId(source)
local price = 500
local xMoney = xPlayer.getMoney()
local identifier
	local steam
	local playerId = source
	local PcName = GetPlayerName(playerId)
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'license:') then
			identifier = string.sub(v, 9)
			break
		end
	end
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'steam:') then
			steam = string.sub(v, 7)
			break
		end
	end

if xMoney >= price then
xPlayer.removeMoney(price)
xPlayer.addWeapon('WEAPON_NIGHTSTICK', 42)
xPlayer.addWeapon('WEAPON_STUNGUN', 42)
xPlayer.addWeapon('WEAPON_FLASHLIGHT', 42)
TriggerClientEvent('esx:showNotification', source, "Vous avez reçu votre ~b~équipement de base ! ~r~-"..price.."$")
TriggerEvent('Ise_Logs', 3447003, "LSPD Armurerie", "Nom : "..PcName..".\nLicense : license:"..identifier.."\nSteam : steam:"..steam.."\nA acheté l'équipement de base.")
else
TriggerClientEvent('esx:showNotification', source, "C'est la hess, il vous manque ~r~"..price.."$, ~w~aller gratter à vos supérieurs.")
end
end)

RegisterNetEvent('h4ci_lspd:armurerie')
AddEventHandler('h4ci_lspd:armurerie', function(arme, prix)
local _source = source
local xPlayer = ESX.GetPlayerFromId(source)
local price = prix
local xMoney = xPlayer.getMoney()

if xMoney >= price then
xPlayer.removeMoney(price)
xPlayer.addWeapon(arme, 42)
TriggerClientEvent('esx:showNotification', source, "Vous avez reçu votre ~b~"..arme.." ! ~r~-"..price.."$")
else
TriggerClientEvent('esx:showNotification', source, "C'est la hess, il vous manque ~r~"..price.."$, ~w~aller gratter à vos supérieurs.")
end
end)


----------fin armurerie


------ coffre


RegisterServerEvent('h4ci_lspd:prendreitems')
AddEventHandler('h4ci_lspd:prendreitems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lspd', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, 'objet retiré', count, inventoryItem.label)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
		end
	end)
end)


RegisterNetEvent('h4ci_lspd:stockitem')
AddEventHandler('h4ci_lspd:stockitem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lspd', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', _source, "objet déposé "..count..""..inventoryItem.label.."")
		else
			TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
		end
	end)
end)


ESX.RegisterServerCallback('h4ci_lspd:inventairejoueur', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

ESX.RegisterServerCallback('h4ci_lspd:prendreitem', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_lspd', function(inventory)
		cb(inventory.items)
	end)
end)

------ fin coffre

------ menu f6

RegisterServerEvent('h4ci_lspd:statutservice')
AddEventHandler('h4ci_lspd:statutservice', function(PriseOuFin)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'lspd' then
			TriggerClientEvent('h4ci_lspd:infoservice', xPlayers[i], _raison, name)
		end
	end
end)

RegisterServerEvent('h4ci_lspd:commandantmess')
AddEventHandler('h4ci_lspd:commandantmess', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)


	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'lspd' then
			TriggerClientEvent('h4ci_lspd:infoservice', xPlayers[i], _raison, name, message)
		end
	end
end)

RegisterServerEvent('h4c1_lspd:annoncerecrutement')
AddEventHandler('h4c1_lspd:annoncerecrutement', function (target)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
    TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'LSPD', '~b~Annonce LSPD', '~y~Recrutement en cours, rendez-vous au commissariat !', 'CHAR_CALL911', 8)

    end
end)

RegisterServerEvent('h4c1_lspd:lanceranimationmenotte')
AddEventHandler('h4c1_lspd:lanceranimationmenotte', function(targetid, playerheading, playerCoords,  playerlocation)
	_source = source
	TriggerClientEvent('h4c1_lspd:animationmenotte', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('h4c1_lspd:animationdemenotte', _source)
end)

RegisterServerEvent('h4ci_lspd:menotterserv')
AddEventHandler('h4ci_lspd:menotterserv', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'lspd' then
		TriggerClientEvent('h4c1_lspd:menotterclient', target)
	else
		TriggerClientEvent('h4c1_lspd:menotterclient', target)
	end
end)

RegisterServerEvent('h4ci_lspd:escorterserv')
AddEventHandler('h4ci_lspd:escorterserv', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'lspd' then
		TriggerClientEvent('h4ci_lspd:escorterclient', target, source)
	else
		print(('%s attempted to drag (not cop)!'):format(xPlayer.identifier))
	end
end)

RegisterNetEvent('esx_policejob:confiscatePlayerItem')
AddEventHandler('esx_policejob:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.name ~= 'police' then
		print(('esx_policejob: %s attempted to confiscate!'):format(sourceXPlayer.identifier))
		return
	end

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		-- does the target player have enough in their inventory?
		if targetItem.count > 0 and targetItem.count <= amount then

			-- can the player carry the said amount of x item?
			if sourceXPlayer.canCarryItem(itemName, sourceItem.count) then
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				sourceXPlayer.showNotification('you_confiscated', amount, sourceItem.label, targetXPlayer.name)
				targetXPlayer.showNotification('got_confiscated', amount, sourceItem.label, sourceXPlayer.name)
			else
				sourceXPlayer.showNotification('quantity_invalid')
			end
		else
			sourceXPlayer.showNotification('quantity_invalid')
		end

	elseif itemType == 'item_account' then
		local targetAccount = targetXPlayer.getAccount(itemName)

		-- does the target player have enough money?
		if targetAccount.money >= amount then
			targetXPlayer.removeAccountMoney(itemName, amount)
			sourceXPlayer.addAccountMoney   (itemName, amount)

			sourceXPlayer.showNotification('you_confiscated_account', amount, itemName, targetXPlayer.name)
			targetXPlayer.showNotification('got_confiscated_account', amount, itemName, sourceXPlayer.name)
		else
			sourceXPlayer.showNotification('quantity_invalid')
		end

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end

		-- does the target player have weapon?
		if targetXPlayer.hasWeapon(itemName) then
			targetXPlayer.removeWeapon(itemName, amount)
			sourceXPlayer.addWeapon   (itemName, amount)

			sourceXPlayer.showNotification('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount)
			targetXPlayer.showNotification('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name)
		else
			sourceXPlayer.showNotification('quantity_invalid')
		end
	end
end)

ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData', function(source, cb, target, notify)
	local xPlayer = ESX.GetPlayerFromId(target)

	if notify then
		xPlayer.showNotification('being_searched')
	end

	if xPlayer then
		local data = {
			name = xPlayer.getName(),
			job = xPlayer.job.label,
			grade = xPlayer.job.grade_label,
			inventory = xPlayer.getInventory(),
			accounts = xPlayer.getAccounts(),
			weapons = xPlayer.getLoadout()
		}

		if Config.EnableESXIdentity then
			data.dob = xPlayer.get('dateofbirth')
			data.height = xPlayer.get('height')

			if xPlayer.get('sex') == 'm' then data.sex = 'male' else data.sex = 'female' end
		end

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status then
				data.drunk = ESX.Math.Round(status.percent)
			end
		end)

		if Config.EnableLicenses then
			TriggerEvent('esx_license:getLicenses', target, function(licenses)
				data.licenses = licenses
				cb(data)
			end)
		else
			cb(data)
		end
	end
end)