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






ALTER TABLE `dp_hcs`.`hcs_areas_tree_cache` 
ADD COLUMN `areas_with_access` TEXT NULL AFTER `cache_content`;

ALTER TABLE `dp_hcs`.`hcs_areas_tree_cache` 
CHANGE COLUMN `cache_content` `cache_content` LONGTEXT CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NULL;
