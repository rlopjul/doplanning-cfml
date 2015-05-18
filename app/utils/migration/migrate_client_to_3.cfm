ALTER TABLE `doplanning_app`.`app_clients` 
ADD COLUMN `app_title` VARCHAR(100) NOT NULL DEFAULT 'DoPlanning' AFTER `name`;
