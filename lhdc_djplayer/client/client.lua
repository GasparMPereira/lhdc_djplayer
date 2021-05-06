ESX = nil
local HasAlreadyEnteredMarker, LastZone = false, nil
local isInClub = false
local display = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
	ESX.PlayerData = ESX.GetPlayerData()
	startThreads()
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
AddEventHandler('lhdc_djplayer:hasEnteredMarker', function(zone)
    if zone == 'djbooth' then
        CurrentAction     = 'djbooth'
		CurrentActionMsg  = 'Press ~INPUT_CONTEXT~ to DJ'
        CurrentActionData = {}
    end
end)
AddEventHandler('lhdc_djplayer:hasExitedMarker', function(zone)
    if zone == 'djbooth' then
        ESX.UI.Menu.CloseAll()
    end
  	CurrentAction = nil
end)
function OpenDjPult()
	SetDisplay(not display)
end
function startThreads()
	ESX.TriggerServerCallback('lhdc_djplayer:getPlayerData', function(playerData)
		if playerData['songIndex'] then
			SendNUIMessage({musiccommand = 'playsong', songname = playerData['songIndex']})
		end
		if playerData['state'] then
			SendNUIMessage({musiccommand = playerData['state'], songname = ''})
		end
	end)
	Citizen.CreateThread(function()
		while true do
		Citizen.Wait(5)
			if ESX.PlayerData.job.name == Config.Job and ESX.PlayerData.job.grade == Config.Grade then
				local coords = GetEntityCoords(PlayerPedId())
				local currentPos = Config.nightclubs.bahama_mamas.djbooth
				if GetDistanceBetweenCoords(coords, currentPos.Pos.x, currentPos.Pos.y, currentPos.Pos.z, true) < 50 then
						DrawMarker(1, currentPos.Pos.x, currentPos.Pos.y, currentPos.Pos.z -1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.5, 153, 50, 204, 100, false, true, 2, false, nil, nil, false)
					end
				local isInMarker  = false
				local currentZone = nil
				if(GetDistanceBetweenCoords(coords, currentPos.Pos.x, currentPos.Pos.y, currentPos.Pos.z, true) < 1.5) then
					isInMarker  = true
					currentZone = 'djbooth'
				end
				if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
					HasAlreadyEnteredMarker = true
					LastZone                = currentZone
					TriggerEvent('lhdc_djplayer:hasEnteredMarker', currentZone)
				end
				if not isInMarker and HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = false
					TriggerEvent('lhdc_djplayer:hasExitedMarker', LastZone)
				end
			end
		end
	end)
  	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if CurrentAction then
				ESX.ShowHelpNotification(CurrentActionMsg)
				if IsControlJustPressed(1, 38) and GetLastInputMethod(2) then
				if CurrentAction == 'djbooth' then
					OpenDjPult('galaxyclub')
				end
				CurrentAction = nil
				end
			end
		end
  	end)
	Citizen.CreateThread(function()		
	  	while true do
			Citizen.Wait(500)
			local coords = GetEntityCoords(GetPlayerPed(-1))
			local currentPos = Config.nightclubs.bahama_mamas.dancefloor
			local distance = GetDistanceBetweenCoords(coords, currentPos.Pos.x, currentPos.Pos.y, currentPos.Pos.z, true)
			if distance < Config.Range and coords.z < 100.0 then
				isInClub = true
				local number = distance/Config.Range
				local volume = round(((1-number)/10), 2)
				SendNUIMessage({setvolume = volume})	
			elseif isInClub then
				isInClub = false
				SendNUIMessage({setvolume = 0.0})
			end
	  	end
	end)
end
RegisterNetEvent('lhdc_djplayer:setmusicforeveryone')
AddEventHandler('lhdc_djplayer:setmusicforeveryone', function(command, songname)
	SendNUIMessage({musiccommand = command, songname = songname})
end)
function round(num, dec)
	local mult = 10^(dec or 0)
	return math.floor(num * mult + 0.5) / mult
end
RegisterNUICallback("error", function(data)
    ESX.ShowNotification(data.error)
    SetDisplay(false)
end)
RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)
function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end
RegisterNUICallback("newsong", function(data)
	TriggerServerEvent('lhdc_djplayer:setcommand', "playsong", data.song)
    --ESX.ShowNotification(data.song)
end)
RegisterNUICallback("play", function(data)
	TriggerServerEvent('lhdc_djplayer:setcommand', "play", '')
end)
RegisterNUICallback("pause", function(data)
	TriggerServerEvent('lhdc_djplayer:setcommand', "pause", '')
end)
RegisterNUICallback("seek", function(data)
	TriggerServerEvent('lhdc_djplayer:setcommand', "seek", data.pos)
end)
Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display)
        DisableControlAction(0, 2, display)
        DisableControlAction(0, 142, display)
        DisableControlAction(0, 18, display)
        DisableControlAction(0, 322, display)
        DisableControlAction(0, 106, display)
    end
end)