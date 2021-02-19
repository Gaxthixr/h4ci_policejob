INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
('society_lspd', 'Police', 1);

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
('society_lspd', 'Police', 1);

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('lspd', 'Police', 1);

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('lspd', 0, 'cadet', 'Cadet', 100, '', ''),
('lspd', 1, 'officier', 'Officier', 100, '', ''),
('lspd', 2, 'sergent', 'Sergent', 100, '', ''),
('lspd', 3, 'lieutenant', 'Lieutenant', 100, '', '')
('lspd', 4, 'boss', 'Commandant', 100, '', '');