INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_mafia2','mafia2',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_mafia2','mafia2',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_mafia2', 'mafia2', 1)
;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('mafia2', 'VMA', 1);


INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('mafia2', 0, 'soldato', 'Soldado', 20000, '{}', '{}'),
('mafia2', 2, 'mafioso', 'Mafioso', 25000, '{}', '{}'),
('mafia2', 3, 'capo', 'Capo', 30000, '{}', '{}'),
('mafia2', 4, 'assassin', 'Sicario', 35000, '{}', '{}'),
('mafia2', 5, 'consigliere', 'Consigliere', 40000, '{}', '{}'),
('mafia2', 6, 'boss', 'Jefe', 45000, '{}', '{}');