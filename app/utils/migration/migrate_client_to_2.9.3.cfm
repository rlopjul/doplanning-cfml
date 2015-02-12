ALTER TABLE `dp_hcs`.`hcs_areas` 
ADD COLUMN `users_visible` TINYINT(1) NOT NULL DEFAULT 1 AFTER `item_type_20_enabled`;

ALTER TABLE `dp_hcs`.`hcs_areas` 
ADD COLUMN `read_only` TINYINT(1) NOT NULL DEFAULT 0 AFTER `users_visible`;


ALTER TABLE `dp_hcs`.`hcs_users` 
ADD COLUMN `notify_been_associated_to_area` TINYINT(1) NOT NULL DEFAULT 1 AFTER `notify_lock_file`,
ADD COLUMN `notify_new_user_in_area` TINYINT(1) NOT NULL DEFAULT 1 AFTER `notify_been_associated_to_area`;


ALTER TABLE `dp_hcs`.`hcs_users` 
ADD COLUMN `notify_app_news` TINYINT(1) NOT NULL DEFAULT 1 AFTER `notify_new_user_in_area`;

ALTER TABLE `dp_hcs`.`hcs_users` 
ADD COLUMN `notify_app_features` TINYINT(1) NOT NULL DEFAULT 1 AFTER `notify_app_news`;


