RegisterNetEvent("rvphone:tchat_receive")
AddEventHandler("rvphone:tchat_receive", function(message)
  SendNUIMessage({event = 'tchat_receive', message = message})
end)

RegisterNetEvent("rvphone:tchat_channel")
AddEventHandler("rvphone:tchat_channel", function(channel, messages)
  SendNUIMessage({event = 'tchat_channel', messages = messages})
end)

RegisterNUICallback('tchat_addMessage', function(data, cb)
  TriggerServerEvent('rvphone:tchat_addMessage', data.channel, data.message)
end)

RegisterNUICallback('tchat_getChannel', function(data, cb)
  TriggerServerEvent('rvphone:tchat_channel', data.channel)
end)
