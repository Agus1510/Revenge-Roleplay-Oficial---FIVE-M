Locales['en'] = {
    -- Name
    ['name'] = 'RevengeAntiCheat',

    -- General
    ['unknown'] = 'unknown',
    ['fatal_error'] = 'FATAL ERROR',

    -- Resource strings
    ['callback_not_found'] = '[%s] has not been found',
    ['trigger_not_found'] = '[%s] has not been found',

    -- Ban strings
    ['checking'] = '👮 Revenge𝗔𝗻𝘁𝗶𝗖𝗵𝗲𝗮𝘁 | Estas siendo revisado...',
    ['user_ban_reason'] = '👮 Revenge𝗔𝗻𝘁𝗶𝗖𝗵𝗲𝗮𝘁 | Fuiste baneado de este servidor ( 𝗨𝘀𝗲𝗿𝗻𝗮𝗺𝗲: %s )',
    ['user_kick_reason'] = '👮 Revenge𝗔𝗻𝘁𝗶𝗖𝗵𝗲𝗮𝘁 | Fuiste kickeado por ( 𝗥azón: %s )',
    ['banlist_ban_reason'] = 'El jugador intento activar \'%s\' evento',
    ['banlist_not_loaded_kick_player'] = '👮 Revenge𝗔𝗻𝘁𝗶𝗖𝗵𝗲𝗮𝘁 | Nuestros bans no fueron cargados tendras que esperar unos segundos. Intenta mas tarde!',
    ['ip_not_found'] = '👮 Revenge𝗔𝗻𝘁𝗶𝗖𝗵𝗲𝗮𝘁 |No pudimos encontrar tu IP',
    ['ip_blocked'] = '👮 Revenge𝗔𝗻𝘁𝗶𝗖𝗵𝗲𝗮𝘁 | Tienes un VPN activo, desactivalo para entrar al servidor | Hay algun error? Contacta con los administradores',
    ['new_identifiers_found'] = '%s, new identifier(s) found - original ban %s',
    ['failed_to_load_banlist'] = '[RevengeAntiCheat] Fallo al cargar banlist!',
    ['failed_to_load_tokenlist'] = '[RevengeAntiCheat] Fallo al cargar tokenlist!',
    ['failed_to_load_ips'] = '[RevengeAntiCheat] Fallo al cargar IPs!',
    ['failed_to_load_check'] = '[RevengeAntiCheat] Porfavor revisa este error pronto, Los bans no van a funcionar!',
    ['ban_type_godmode'] = 'Godmode detectado en un jugador',
    ['lua_executor_found'] = 'Lua executor detectado en jugador',
    ['ban_type_injection'] = 'El jugador inyecto algunos comandos (Injection)',
    ['ban_type_blacklisted_weapon'] = 'El jugador tiene un arma de la blacklist: %s',
    ['ban_type_blacklisted_key'] = 'El jugador presiono una tecla de la blacklist para %s',
    ['ban_type_hash'] = 'El jugador tiene un hash modificado',
    ['ban_type_esx_shared'] = 'El jugador trato de activar \'esx:getSharedObject\'',
    ['ban_type_superjump'] = 'El jugador tiene super salto',
    ['ban_type_client_files_blocked'] = 'El jugador no respondio despues de 5 minutos (Client Files Blocked)',
    ['kick_type_security_token'] = 'Porque no vamos a crear otro token secreto',
    ['kick_type_security_mismatch'] = 'Porque tu token secreto no coincide',

    -- Commands
    ['command'] = 'Comando',
    ['available_commands'] = 'Comandos disponibles',
    ['command_reload'] = 'Recargar la lista de bans',
    ['ips_command_reload'] = 'Recargar la lista blanca de IPs',
    ['ips_command_add'] = 'Agregar ip a la whitelist',
    ['command_help'] = 'Devuelve todos los comandos del anticheat',
    ['command_total'] = 'Returns the number of bans in list',
    ['total_bans'] = 'We currently have %s ban(s) in our list',
    ['command_not_found'] = 'does not exist',
    ['banlist_reloaded'] = 'All bans in anticheat has been reloaded from banlist.json',
    ['ips_reloaded'] = 'All IPs has been reloaded from ignore-ips.json',
    ['ip_added'] = 'IP: %s, has been added to the whitelist',
    ['ip_invalid'] = 'IP: %s, is not a valid IP, it should look like this, for example: 0.0.0.0',
    ['not_allowed'] = 'You don\'t have permission to execute %s',

    -- Discord
    ['discord_title'] = '[RevengeAntiCheat] Baneo a un jugador',
    ['discord_description'] = '**Nombre:** %s\n **Razon:** %s\n **Identificadores:**\n %s',
}
