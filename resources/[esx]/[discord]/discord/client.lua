Citizen.CreateThread(function()
	while true do
        --This is the Application ID (Replace this with you own)
		SetDiscordAppId(686269411606528040)

        --Here you will have to put the image name for the "large" icon.
		SetDiscordRichPresenceAsset('revenge')
        
        --(11-11-2018) New Natives:

        --Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('Revenge Roleplay')
       
        --Here you will have to put the image name for the "small" icon.
        SetDiscordRichPresenceAssetSmall('revenge')

        --Here you can add hover text for the "small" icon.
        SetDiscordRichPresenceAssetSmallText('Revenge')

        --It updates every one minute just in case.
		Citizen.Wait(60000)
	end
end)