ESX = nil 

CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

function HelpNotif(msg)
	BeginTextCommandDisplayHelp('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandDisplayHelp(0, false, true, -1)
end

function Notification(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg)
	DrawNotification(false, true)
end

function EntrerText(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ":")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do Wait(0) end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Wait(500)
		return result
	else
		Wait(500)
		return nil
	end
end

function LoadModel(model)
	while not HasModelLoaded(GetHashKey(model)) do
		RequestModel(GetHashKey(model))
		Wait(0)
	end
end

function infoToSubMenu(v)
	ESX.PlayerData = ESX.GetPlayerData()
	label = v.label
	name = v.name
	price = v.price
	quantityToBuy = 1
end

CreateThread(function()
	while true do
		local interval = 500
		local pCoords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(rxConfig.Position) do
			if #(pCoords - v.pos) <= 6.0 then
				interval = 0
				DrawMarker(21, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 0, 255, 0, 1, 2, 0, nil, nil, 0)
				if #(pCoords - v.pos) <= 1.5 then
					HelpNotif("Appuyez sur ~INPUT_CONTEXT~ pour parler avec le vendeur.")
					if IsControlJustPressed(1, 51) then
						rxShop()
					end
				end
			end
		end
		Wait(interval)
	end
end)

CreateThread(function()
	for k,v in pairs(rxConfig.Position) do
		local blip = AddBlipForCoord(v.pos)

		SetBlipSprite (blip, 52)
		SetBlipScale  (blip, 0.5)
		SetBlipDisplay(blip, 4)
		SetBlipColour (blip, 2)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Supérette")
		EndTextCommandSetBlipName(blip)
	end

	for k, v in pairs(rxConfig.Ped) do
		LoadModel("mp_m_shopkeep_01")
		local ped = CreatePed(2, GetHashKey("mp_m_shopkeep_01"), v.x, v.y, v.z, v.h, 0, 0)
		FreezeEntityPosition(ped, 1)
		SetEntityInvincible(ped, true)
		SetEntityAsMissionEntity(ped, 1, 1)
		SetBlockingOfNonTemporaryEvents(ped, 1)
	end
end)