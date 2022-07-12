Config = {}

Config.Animations = {

	{
		name  = 'Festivos',
		label = 'Festivos',
		items = {
			{label = "Fumar un cigarrillo", type = "scenario", data = {anim = "WORLD_HUMAN_SMOKING"}},
			{label = "Tocar musica", type = "scenario", data = {anim = "WORLD_HUMAN_MUSICIAN"}},
			{label = "Dj", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@dj", anim = "dj"}},
			{label = "Tomar una cerveza", type = "scenario", data = {anim = "WORLD_HUMAN_DRINKING"}},
			{label = "Tomar cerveza en bar", type = "scenario", data = {anim = "WORLD_HUMAN_PARTYING"}},
			{label = "Guitarra en el aire", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@air_guitar", anim = "air_guitar"}},
			{label = "Meneo", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@air_shagging", anim = "air_shagging"}},
			{label = "Rock'n'roll", type = "anim", data = {lib = "mp_player_int_upperrock", anim = "mp_player_int_rock"}},
			-- {label = "Fumer un joint", type = "scenario", data = {anim = "WORLD_HUMAN_SMOKING_POT"}},
			{label = "Borracho en el acto", type = "anim", data = {lib = "amb@world_human_bum_standing@drunk@idle_a", anim = "idle_a"}},
			{label = "Vomito en el coche", type = "anim", data = {lib = "oddjobs@taxi@tie", anim = "vomit_outside"}},
		}
	},

	{
		name  = 'Saludos',
		label = 'Saludos',
		items = {
			{label = "Saludar", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_hello"}},
			{label = "Dar la mano", type = "anim", data = {lib = "mp_common", anim = "givetake1_a"}},
			{label = "Tchek", type = "anim", data = {lib = "mp_ped_interaction", anim = "handshake_guy_a"}},
			{label = "Saludo bandido", type = "anim", data = {lib = "mp_ped_interaction", anim = "hugs_guy_a"}},
			{label = "Saludo militar", type = "anim", data = {lib = "mp_player_int_uppersalute", anim = "mp_player_int_salute"}},
		}
	},

	{
		name  = 'Trabajo',
		label = 'Trabajo',
		items = {
			{label = "Sospechoso", type = "anim", data = {lib = "random@arrests@busted", anim = "idle_c"}},
			{label = "Pescador", type = "scenario", data = {anim = "world_human_stand_fishing"}},
			{label = "Policia : Investigar", type = "anim", data = {lib = "amb@code_human_police_investigate@idle_b", anim = "idle_f"}},
			{label = "Policia : Hablar en la radio", type = "anim", data = {lib = "random@arrests", anim = "generic_radio_chatter"}},
			{label = "Policia : circular", type = "scenario", data = {anim = "WORLD_HUMAN_CAR_PARK_ATTENDANT"}},
			{label = "Policia : Binoculares", type = "scenario", data = {anim = "WORLD_HUMAN_BINOCULARS"}},
			{label = "Agricultura : recolectar", type = "scenario", data = {anim = "world_human_gardener_plant"}},
			{label = "Mecanico : Reparar el motor", type = "anim", data = {lib = "mini@repair", anim = "fixing_a_ped"}},
			{label = "Medico : observar", type = "scenario", data = {anim = "CODE_HUMAN_MEDIC_KNEEL"}},
			{label = "Taxi : Hablar con el cliente", type = "anim", data = {lib = "oddjobs@taxi@driver", anim = "leanover_idle"}},
			{label = "Taxi : Dar la factura", type = "anim", data = {lib = "oddjobs@taxi@cyi", anim = "std_hand_off_ps_passenger"}},
			{label = "Almacenero : Dar las cosas", type = "anim", data = {lib = "mp_am_hold_up", anim = "purchase_beerbox_shopkeeper"}},
			{label = "Barman : Servir un shot", type = "anim", data = {lib = "mini@drinking", anim = "shots_barman_b"}},
			{label = "Periodista : Tomar una foto", type = "scenario", data = {anim = "WORLD_HUMAN_PAPARAZZI"}},
			{label = "Periodista : Tomar notas", type = "scenario", data = {anim = "WORLD_HUMAN_CLIPBOARD"}},
			{label = "Albañil : Golpe de martillo", type = "scenario", data = {anim = "WORLD_HUMAN_HAMMERING"}},
			{label = "Vagabundo : Pedir dinero", type = "scenario", data = {anim = "WORLD_HUMAN_BUM_FREEWAY"}},
			{label = "Vagabundo : Estatua", type = "scenario", data = {anim = "WORLD_HUMAN_HUMAN_STATUE"}},
		}
	},

	{
		name  = 'Humor',
		label = 'Humor',
		items = {
			{label = "Felicitar", type = "scenario", data = {anim = "WORLD_HUMAN_CHEERING"}},
			{label = "Super", type = "anim", data = {lib = "mp_action", anim = "thanks_male_06"}},
			{label = "Usted", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_point"}},
			{label = "Ven", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_come_here_soft"}}, 
			{label = "Keskya ?", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_bring_it_on"}},
			{label = "Mio", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_me"}},
			{label = "Lo sabía, puta", type = "anim", data = {lib = "anim@am_hold_up@male", anim = "shoplift_high"}},
			{label = "Agotado", type = "scenario", data = {lib = "amb@world_human_jog_standing@male@idle_b", anim = "idle_d"}},
			{label = "Estoy en la mierda", type = "scenario", data = {lib = "amb@world_human_bum_standing@depressed@idle_a", anim = "idle_a"}},
			{label = "Mano a cara", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@face_palm", anim = "face_palm"}},
			{label = "Calmate ", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_easy_now"}},
			{label = "qué he hecho ?", type = "anim", data = {lib = "oddjobs@assassinate@multi@", anim = "react_big_variations_a"}},
			{label = "Tener miedo", type = "anim", data = {lib = "amb@code_human_cower_stand@male@react_cowering", anim = "base_right"}},
			{label = "Peleamos ?", type = "anim", data = {lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_e"}},
			{label = "No es posible !", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_damn"}},
			{label = "abrazo", type = "anim", data = {lib = "mp_ped_interaction", anim = "kisses_guy_a"}},
			{label = "Dedo de honor", type = "anim", data = {lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter"}},
			{label = "gilipollas", type = "anim", data = {lib = "mp_player_int_upperwank", anim = "mp_player_int_wank_01"}},
			{label = "Tiro en la cabeza", type = "anim", data = {lib = "mp_suicide", anim = "pistol"}},
		}
	},

	{
		name  = 'Deportes',
		label = 'Deportes',
		items = {
			{label = "Mostrar musculos", type = "anim", data = {lib = "amb@world_human_muscle_flex@arms_at_side@base", anim = "base"}},
			{label = "Barra de culturismo", type = "anim", data = {lib = "amb@world_human_muscle_free_weights@male@barbell@base", anim = "base"}},
			{label = "Hacer flexiones", type = "anim", data = {lib = "amb@world_human_push_ups@male@base", anim = "base"}},
			{label = "Hacer abdominales", type = "anim", data = {lib = "amb@world_human_sit_ups@male@base", anim = "base"}},
			{label = "Haciendo yoga", type = "anim", data = {lib = "amb@world_human_yoga@male@base", anim = "base_a"}},
		}
	},

	{
		name  = 'Diverso',
		label = 'Diverso',
		items = {
			{label = "Beber un cafe", type = "anim", data = {lib = "amb@world_human_aa_coffee@idle_a", anim = "idle_a"}},
			{label = "Sentarse", type = "anim", data = {lib = "anim@heists@prison_heistunfinished_biztarget_idle", anim = "target_idle"}},
			{label = "Apoyarse en una pared", type = "scenario", data = {anim = "world_human_leaning"}},
			{label = "Acostado boca arriba", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE_BACK"}},
			{label = "Acostado boca abajo", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE"}},
			{label = "Limpiar algo", type = "scenario", data = {anim = "world_human_maid_clean"}},
			{label = "Preparar la comida", type = "scenario", data = {anim = "PROP_HUMAN_BBQ"}},
			{label = "Buscar algo", type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_bj_to_prop_female"}},
			{label = "Tomar una selfie", type = "scenario", data = {anim = "world_human_tourist_mobile"}},
			{label = "Escuchar atras de la puerta", type = "anim", data = {lib = "mini@safe_cracking", anim = "idle_base"}}, 
		}
	},

	{
		name  = 'Actitudes',
		label = 'Actitudes',
		items = {
			{label = "Normal M", type = "attitude", data = {lib = "move_m@confident", anim = "move_m@confident"}},
			{label = "Normal F", type = "attitude", data = {lib = "move_f@heels@c", anim = "move_f@heels@c"}},
			{label = "Depresivo", type = "attitude", data = {lib = "move_m@depressed@a", anim = "move_m@depressed@a"}},
			{label = "Depresivo F", type = "attitude", data = {lib = "move_f@depressed@a", anim = "move_f@depressed@a"}},
			{label = "Negocios", type = "attitude", data = {lib = "move_m@business@a", anim = "move_m@business@a"}},
			{label = "Determinado", type = "attitude", data = {lib = "move_m@brave@a", anim = "move_m@brave@a"}},
			{label = "Casual", type = "attitude", data = {lib = "move_m@casual@a", anim = "move_m@casual@a"}},
			{label = "Gordp", type = "attitude", data = {lib = "move_m@fat@a", anim = "move_m@fat@a"}},
			{label = "Hipster", type = "attitude", data = {lib = "move_m@hipster@a", anim = "move_m@hipster@a"}},
			{label = "Herido", type = "attitude", data = {lib = "move_m@injured", anim = "move_m@injured"}},
			{label = "Intimidado", type = "attitude", data = {lib = "move_m@hurry@a", anim = "move_m@hurry@a"}},
			{label = "Hobo", type = "attitude", data = {lib = "move_m@hobo@a", anim = "move_m@hobo@a"}},
			{label = "Infeliz", type = "attitude", data = {lib = "move_m@sad@a", anim = "move_m@sad@a"}},
			{label = "Musculoso", type = "attitude", data = {lib = "move_m@muscle@a", anim = "move_m@muscle@a"}},
			{label = "En shock", type = "attitude", data = {lib = "move_m@shocked@a", anim = "move_m@shocked@a"}},
			{label = "Oscuro", type = "attitude", data = {lib = "move_m@shadyped@a", anim = "move_m@shadyped@a"}},
			{label = "Fatigado", type = "attitude", data = {lib = "move_m@buzzed", anim = "move_m@buzzed"}},
			{label = "Presionado", type = "attitude", data = {lib = "move_m@hurry_butch@a", anim = "move_m@hurry_butch@a"}},
			{label = "Orgulloso", type = "attitude", data = {lib = "move_m@money", anim = "move_m@money"}},
			{label = "Caminado rapido", type = "attitude", data = {lib = "move_m@quick", anim = "move_m@quick"}},
			{label = "Hombre comedor", type = "attitude", data = {lib = "move_f@maneater", anim = "move_f@maneater"}},
			{label = "Descarado", type = "attitude", data = {lib = "move_f@sassy", anim = "move_f@sassy"}},	
			{label = "Arrogante", type = "attitude", data = {lib = "move_f@arrogant@a", anim = "move_f@arrogant@a"}},
		}
	},
	{
		name  = 'Porno',
		label = 'Porno',
		items = {
			{label = "Cogiendo en el auto", type = "anim", data = {lib = "oddjobs@towing", anim = "m_blow_job_loop"}},
			{label = "Pete en el auto", type = "anim", data = {lib = "oddjobs@towing", anim = "f_blow_job_loop"}},
			{label = "Cogiendo en el auto 2", type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_player"}},
			{label = "Cogiendo en el auto 3", type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_female"}},
			{label = "Rascarse las bolas", type = "anim", data = {lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch"}},
			{label = "Hacer el encanto", type = "anim", data = {lib = "mini@strip_club@idles@stripper", anim = "stripper_idle_02"}},
			{label = "Pose michto", type = "scenario", data = {anim = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"}},
			{label = "Montrer sa poitrine", type = "anim", data = {lib = "mini@strip_club@backroom@", anim = "stripper_b_backroom_idle_b"}},
			{label = "Strip Tease 1", type = "anim", data = {lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", anim = "ld_girl_a_song_a_p1_f"}},
			{label = "Strip Tease 2", type = "anim", data = {lib = "mini@strip_club@private_dance@part2", anim = "priv_dance_p2"}},
			{label = "Stip Tease au sol", type = "anim", data = {lib = "mini@strip_club@private_dance@part3", anim = "priv_dance_p3"}},
		}
	}
}