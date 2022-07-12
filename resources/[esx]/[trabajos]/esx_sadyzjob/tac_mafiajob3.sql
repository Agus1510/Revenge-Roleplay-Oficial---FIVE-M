INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_sadzy','sadzy',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_sadzy','sadzy',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_sadzy', 'sadzy', 1)
;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('sadzy', 'Sadzy Corp', 1);


INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(60, 'sadzy', 0, 'soldato', 'Soldado', 15000, '{}', '{}'),
(61, 'sadzy', 2, 'mafioso', 'Mafioso', 10000, '{}', '{}'),
(62, 'sadzy', 3, 'capo', 'Capo', 10000, '{}', '{}'),
(63, 'sadzy', 4, 'assassin', 'Sicario', 10000, '{}', '{}'),
(64, 'sadzy', 5, 'consigliere', 'Consigliere', 5000, '{}', '{}'),
(65, 'sadzy', 6, 'boss', 'Jefe', 5000, '{}', '{}');