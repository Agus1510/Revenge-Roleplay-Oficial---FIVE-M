INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_gaviria','gaviria',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_gaviria','gaviria',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_gaviria', 'gaviria', 1)
;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('gaviria', 'Los gaviria', 1);


INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(66, 'gaviria', 0, 'soldato', 'Soldado', 15000, '{}', '{}'),
(67, 'gaviria', 2, 'mafioso', 'Mafioso', 10000, '{}', '{}'),
(68, 'gaviria', 3, 'capo', 'Capo', 10000, '{}', '{}'),
(69, 'gaviria', 4, 'assassin', 'Sicario', 10000, '{}', '{}'),
(70, 'gaviria', 5, 'consigliere', 'Consigliere', 5000, '{}', '{}'),
(71, 'gaviria', 6, 'boss', 'Jefe', 5000, '{}', '{}');