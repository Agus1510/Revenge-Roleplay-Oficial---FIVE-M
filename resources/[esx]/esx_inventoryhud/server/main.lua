tac = nil

TriggerEvent(
	"tac:getSharedObject",
	function(obj)
		tac = obj
	end
)

tac.RegisterServerCallback(
	"tac_inventoryhud:getPlayerInventory",
	function(source, cb, target)
		local targetXPlayer = tac.GetPlayerFromId(target)

		if targetXPlayer ~= nil then
			cb({inventory = targetXPlayer.inventory, money = targetXPlayer.getMoney(), accounts = targetXPlayer.accounts, weapons = targetXPlayer.loadout})
		else
			cb(nil)
		end
	end
)
