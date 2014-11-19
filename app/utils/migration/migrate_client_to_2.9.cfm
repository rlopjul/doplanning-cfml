ALTER TABLE `dp_hcs`.`hcs_webs` 
ADD COLUMN `news_area_id` INT(11) NULL AFTER `language`,
ADD COLUMN `events_area_id` INT(11) NULL AFTER `news_area_id`,
ADD COLUMN `publications_area_id` INT(11) NULL AFTER `events_area_id`,
ADD INDEX `FK_hcs_webs_areas_news_idx` (`news_area_id` ASC),
ADD INDEX `FK_hcs_webs_areas_events_idx` (`events_area_id` ASC),
ADD INDEX `FK_hcs_webs_areas_publications_idx` (`publications_area_id` ASC);
ALTER TABLE `dp_hcs`.`hcs_webs` 
ADD CONSTRAINT `FK_hcs_webs_areas`
  FOREIGN KEY (`area_id`)
  REFERENCES `dp_hcs`.`hcs_areas` (`id`)
  ON DELETE RESTRICT
  ON UPDATE NO ACTION,
ADD CONSTRAINT `FK_hcs_webs_areas_news`
  FOREIGN KEY (`news_area_id`)
  REFERENCES `dp_hcs`.`hcs_areas` (`id`)
  ON DELETE RESTRICT
  ON UPDATE NO ACTION,
ADD CONSTRAINT `FK_hcs_webs_areas_events`
  FOREIGN KEY (`events_area_id`)
  REFERENCES `dp_hcs`.`hcs_areas` (`id`)
  ON DELETE RESTRICT
  ON UPDATE NO ACTION,
ADD CONSTRAINT `FK_hcs_webs_areas_publications`
  FOREIGN KEY (`publications_area_id`)
  REFERENCES `dp_hcs`.`hcs_areas` (`id`)
  ON DELETE RESTRICT
  ON UPDATE NO ACTION;



ALTER TABLE `dp_hcs`.`hcs_entries` 
ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
ADD INDEX `FK_hcs_entries_7_idx` (`last_update_user_id` ASC);
ALTER TABLE `dp_hcs`.`hcs_entries` 
ADD CONSTRAINT `FK_hcs_entries_7`
  FOREIGN KEY (`last_update_user_id`)
  REFERENCES `dp_hcs`.`hcs_users` (`id`)
  ON DELETE SET NULL
  ON UPDATE NO ACTION;



ALTER TABLE `dp_hcs`.`hcs_events` 
ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
ADD INDEX `FK_hcs_events_6_idx` (`last_update_user_id` ASC);
ALTER TABLE `dp_hcs`.`hcs_events` 
ADD CONSTRAINT `FK_hcs_events_6`
  FOREIGN KEY (`last_update_user_id`)
  REFERENCES `dp_hcs`.`hcs_users` (`id`)
  ON DELETE SET NULL
  ON UPDATE NO ACTION;


ALTER TABLE `dp_hcs`.`hcs_news` 
ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
ADD INDEX `FK_hcs_news_6_idx` (`last_update_user_id` ASC);
ALTER TABLE `dp_hcs`.`hcs_news` 
ADD CONSTRAINT `FK_hcs_news_6`
  FOREIGN KEY (`last_update_user_id`)
  REFERENCES `dp_hcs`.`hcs_users` (`id`)
  ON DELETE SET NULL
  ON UPDATE NO ACTION;


ALTER TABLE `dp_hcs`.`hcs_images` 
ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
ADD INDEX `FK_hcs_images_6_idx` (`last_update_user_id` ASC);
ALTER TABLE `dp_hcs`.`hcs_images` 
ADD CONSTRAINT `FK_hcs_images_6`
  FOREIGN KEY (`last_update_user_id`)
  REFERENCES `dp_hcs`.`hcs_users` (`id`)
  ON DELETE SET NULL
  ON UPDATE NO ACTION;


ALTER TABLE `dp_hcs`.`hcs_lists` 
ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
ADD INDEX `FK_hcs_lists_6_idx` (`last_update_user_id` ASC);
ALTER TABLE `dp_hcs`.`hcs_lists` 
ADD CONSTRAINT `FK_hcs_lists_6`
  FOREIGN KEY (`last_update_user_id`)
  REFERENCES `dp_hcs`.`hcs_users` (`id`)
  ON DELETE SET NULL
  ON UPDATE NO ACTION;


ALTER TABLE `dp_hcs`.`hcs_forms` 
ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
ADD INDEX `FK_hcs_forms_6_idx` (`last_update_user_id` ASC);
ALTER TABLE `dp_hcs`.`hcs_forms` 
ADD CONSTRAINT `FK_hcs_forms_6`
  FOREIGN KEY (`last_update_user_id`)
  REFERENCES `dp_hcs`.`hcs_users` (`id`)
  ON DELETE SET NULL
  ON UPDATE NO ACTION;


ALTER TABLE `dp_hcs`.`hcs_tasks` 
ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `last_update_date`,
ADD INDEX `FK_hcs_tasks_6_idx` (`last_update_user_id` ASC);
ALTER TABLE `dp_hcs`.`hcs_tasks` 
ADD CONSTRAINT `FK_hcs_tasks_6`
  FOREIGN KEY (`last_update_user_id`)
  REFERENCES `dp_hcs`.`hcs_users` (`id`)
  ON DELETE SET NULL
  ON UPDATE NO ACTION;


ALTER TABLE `dp_hcs`.`hcs_pubmeds` 
ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
ADD INDEX `FK_hcs_pubmeds_7_idx` (`last_update_user_id` ASC);
ALTER TABLE `dp_hcs`.`hcs_pubmeds` 
ADD CONSTRAINT `FK_hcs_pubmeds_7`
  FOREIGN KEY (`last_update_user_id`)
  REFERENCES `dp_hcs`.`hcs_users` (`id`)
  ON DELETE SET NULL
  ON UPDATE NO ACTION;


<!--- Comprobar si existe esta tabla --->
ALTER TABLE `dp_hcs`.`hcs_links` 
ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
ADD INDEX `FK_hcs_links_6_idx` (`last_update_user_id` ASC);
ALTER TABLE `dp_hcs`.`hcs_links` 
ADD CONSTRAINT `FK_hcs_links_6`
  FOREIGN KEY (`last_update_user_id`)
  REFERENCES `dp_hcs`.`hcs_users` (`id`)
  ON DELETE SET NULL
  ON UPDATE NO ACTION;

ALTER TABLE `dp_hcs`.`hcs_lists_views` 
ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
ADD INDEX `FK_hcs_lists_views_4_idx` (`last_update_user_id` ASC);
ALTER TABLE `dp_hcs`.`hcs_lists_views` 
ADD CONSTRAINT `FK_hcs_lists_views_4`
  FOREIGN KEY (`last_update_user_id`)
  REFERENCES `dp_hcs`.`hcs_users` (`id`)
  ON DELETE SET NULL
  ON UPDATE NO ACTION;


ALTER TABLE `dp_hcs`.`hcs_forms_views` 
ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `publication_validated_date`,
ADD INDEX `FK_hcs_forms_views_4_idx` (`last_update_user_id` ASC);
ALTER TABLE `dp_hcs`.`hcs_forms_views` 
ADD CONSTRAINT `FK_hcs_forms_views_4`
  FOREIGN KEY (`last_update_user_id`)
  REFERENCES `dp_hcs`.`hcs_users` (`id`)
  ON DELETE SET NULL
  ON UPDATE NO ACTION;


ALTER TABLE `dp_hcs`.`hcs_typologies` 
ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `general`,
ADD INDEX `FK_hcs_typologies_5_idx` (`last_update_user_id` ASC);
ALTER TABLE `dp_hcs`.`hcs_typologies` 
ADD CONSTRAINT `FK_hcs_typologies_5`
  FOREIGN KEY (`last_update_user_id`)
  REFERENCES `dp_hcs`.`hcs_users` (`id`)
  ON DELETE SET NULL
  ON UPDATE NO ACTION;


ALTER TABLE `dp_hcs`.`hcs_areas_tree_cache` 
ADD COLUMN `areas_with_access` TEXT NULL AFTER `cache_content`;

ALTER TABLE `dp_hcs`.`hcs_areas_tree_cache` 
CHANGE COLUMN `cache_content` `cache_content` LONGTEXT CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL;


CREATE TABLE `hcs_dp_documents_locks` (
  `item_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `lock_date` datetime NOT NULL,
  `lock` tinyint(1) NOT NULL,
  PRIMARY KEY (`item_id`,`user_id`,`lock_date`),
  KEY `FK_hcs_dp_documents_locks_2` (`user_id`),
  CONSTRAINT `FK_hcs_dp_documents_locks_1` FOREIGN KEY (`item_id`) REFERENCES `hcs_dp_documents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_hcs_dp_documents_locks_2` FOREIGN KEY (`user_id`) REFERENCES `hcs_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

