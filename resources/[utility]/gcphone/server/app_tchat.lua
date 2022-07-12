function TchatGetMessageChannel (channel, cb)
    MySQL.Async.fetchAll("SELECT * FROM phone_app_chat WHERE channel = @channel ORDER BY time DESC LIMIT 100", {
        ['@channel'] = channel
    }, cb)
end

function TchatAddMessage (channel, message)
    local Query = "INSERT INTO phone_app_chat (`channel`, `message`) VALUES(@channel, @message)"
    local Query2 = 'SELECT * from phone_app_chat WHERE `id` = @id'
    local Parameters = {
        ['@channel'] = channel,
        ['@message'] = message
    }

	local lastInsertId = MySQL.Sync.insert(Query, Parameters)
	TriggerClientEvent('rvphone:tchat_receive', -1, MySQL.Sync.fetchAll(Query2, {['id'] = lastInsertId})[1])
end

RegisterServerEvent('rvphone:tchat_channel')
AddEventHandler('rvphone:tchat_channel', function(channel)
    local sourcePlayer = tonumber(source)
    TchatGetMessageChannel(channel, function (messages)
        TriggerClientEvent('rvphone:tchat_channel', sourcePlayer, channel, messages)
    end)
end)

RegisterServerEvent('rvphone:tchat_addMessage')
AddEventHandler('rvphone:tchat_addMessage', function(channel, message)
    TchatAddMessage(channel, message)
end)
