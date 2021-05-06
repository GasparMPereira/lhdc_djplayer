ESX = nil
local currentPlayerData = {
	['state'] = nil,
	['songIndex'] = nil
}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
ESX.RegisterServerCallback('lhdc_djplayer:getPlayerData', function(source, cb)
	cb(currentPlayerData)
end)
RegisterServerEvent('lhdc_djplayer:setcommand')
AddEventHandler('lhdc_djplayer:setcommand', function(command, songname)
	if command == 'playsong' then
		currentPlayerData['songIndex'] = songname
		currentPlayerData['state'] = 'play'
	elseif command == 'play' then
		currentPlayerData['state'] = 'play'
	elseif command == 'pause' then
		currentPlayerData['state'] = 'pause'
	end
	TriggerClientEvent('lhdc_djplayer:setmusicforeveryone', -1, command, songname)
end)