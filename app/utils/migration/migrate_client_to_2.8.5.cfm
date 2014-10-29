ALTER TABLE `dp_hcs`.`hcs_areas` 
ADD COLUMN `version_tree` BIGINT NULL DEFAULT 0 AFTER `default_typology_id`;

CREATE TABLE `hcs_areas_tree_cache` (
  `user_id` int(11) NOT NULL,
  `area_id` int(11) NOT NULL,
  `tree_type` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `version` bigint(20) NOT NULL,
  `cache_content` longtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`user_id`,`area_id`,`tree_type`),
  KEY `FK_hcs_areas_tree_cache_areas_idx` (`area_id`),
  CONSTRAINT `FK_hcs_areas_tree_cache_areas` FOREIGN KEY (`area_id`) REFERENCES `hcs_areas` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_hcs_areas_tree_cache_users` FOREIGN KEY (`user_id`) REFERENCES `hcs_users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


