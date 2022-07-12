tac                     = nil

Citizen.CreateThread(function()
  while tac == nil do
    TriggerEvent('tac:getSharedObject', function(obj) tac = obj end)
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('smerfikubrania:koszulka')
AddEventHandler('smerfikubrania:koszulka', function()
	TriggerEvent('skinchanger:getSkin', function(skin)
	

		local clothesSkin = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 15, ['torso_2'] = 0,
		['arms'] = 15, ['arms_2'] = 0
		}
		TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	end)
end)
RegisterNetEvent('smerfikubrania:spodnie')
AddEventHandler('smerfikubrania:spodnie', function()
	TriggerEvent('skinchanger:getSkin', function(skin)
	

		local clothesSkin = {
		['pants_1'] = 21, ['pants_2'] = 0
		}
		TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	end)
end)

RegisterNetEvent('smerfikubrania:buty')
AddEventHandler('smerfikubrania:buty', function()
	TriggerEvent('skinchanger:getSkin', function(skin)
	

		local clothesSkin = {
		['shoes_1'] = 34, ['shoes_2'] = 0
		}
		TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	end)
end)

function OpenActionMenuInteraction(target)

	local elements = {}

	table.insert(elements, {label = ('Ponerse la ropa'), value = 'ubie'})
	table.insert(elements, {label = ('Sacarse la remera'), value = 'tul'})
	table.insert(elements, {label = ('Sacarse los pantalones'), value = 'spo'})
	table.insert(elements, {label = ('Sacarse las zapatillas'), value = 'but'})
  		tac.UI.Menu.CloseAll()	


	tac.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'action_menu',
		{
			title    = ('Ropa'),
			align    = 'top-left',
			elements = elements
		},
    function(data, menu)



		
		if data.current.value == 'ubie' then			
		tac.TriggerServerCallback('tac_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
		end)
		tac.UI.Menu.CloseAll()	
		elseif data.current.value == 'tul' then
		TriggerEvent('smerfikubrania:koszulka')
		tac.UI.Menu.CloseAll()	
		elseif data.current.value == 'spo' then
		TriggerEvent('smerfikubrania:spodnie')
		tac.UI.Menu.CloseAll()	
		elseif data.current.value == 'but' then
		TriggerEvent('smerfikubrania:buty')
		tac.UI.Menu.CloseAll()	
	  end
	end)


end
			
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsControlJustReleased(0, 344) and not tac.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'action_menu') then
		OpenActionMenuInteraction()
    end
  end
end)