INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_mafia3','mafia3',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_mafia3','mafia3',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_mafia3', 'mafia3', 1)
;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('mafia3', 'La mara 18', 1);


INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(60, 'mafia3', 0, 'soldato', 'Soldado', 20000, '{}', '{}'),
(61, 'mafia3', 2, 'mafioso', 'Mafioso', 22500, '{}', '{}'),
(62, 'mafia3', 3, 'capo', 'Capo', 25000, '{}', '{}'),
(63, 'mafia3', 4, 'assassin', 'Sicario', 27500, '{}', '{}'),
(64, 'mafia3', 5, 'consigliere', 'Consigliere', 30000, '{}', '{}'),
(65, 'mafia3', 6, 'boss', 'Jefe', 35000, '{}', '{}');