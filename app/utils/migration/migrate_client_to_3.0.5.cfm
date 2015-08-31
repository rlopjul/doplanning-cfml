ALTER TABLE `dp_hcs`.`hcs_areas_users`
ADD COLUMN `association_date` DATETIME NULL DEFAULT NULL AFTER `user_id`;

ALTER TABLE `dp_hcs`.`hcs_users`
ADD COLUMN `no_notifications` TINYINT(1) NOT NULL DEFAULT 0 AFTER `notify_app_features`;

ALTER TABLE `dp_hcs`.`hcs_users`
ADD COLUMN `notifications_digest_type_id` INT(11) NULL AFTER `no_notifications`,
ADD COLUMN `notifications_last_digest_date` DATETIME NULL AFTER `notifications_digest_type_id`;

/*CREATE TABLE `hcs_categories` (
  `item_type_id` int(10) NOT NULL,
  `category_area_id` int(11) NOT NULL,
  PRIMARY KEY (`item_type_id`),
  KEY `FK_hcs_categories_1_idx` (`category_area_id`),
  CONSTRAINT `FK_hcs_categories_1` FOREIGN KEY (`category_area_id`) REFERENCES `hcs_areas` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;*/

CREATE TABLE `hcs_items_categories` (
  `item_id` int(11) NOT NULL,
  `item_type_id` int(10) unsigned NOT NULL,
  `area_id` int(11) NOT NULL,
  PRIMARY KEY (`item_id`,`item_type_id`,`area_id`) USING BTREE,
  KEY `FK_hcs_items_categories_1` (`area_id`),
  CONSTRAINT `FK_hcs_items_categories_1` FOREIGN KEY (`area_id`) REFERENCES `hcs_areas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `hcs_items_types` (
  `item_type_id` int(10) unsigned NOT NULL,
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `category_area_id` int(11) NOT NULL,
  PRIMARY KEY (`item_type_id`),
  KEY `FK_hcs_items_types_1_idx` (`category_area_id`),
  CONSTRAINT `FK_hcs_items_types_1` FOREIGN KEY (`category_area_id`) REFERENCES `hcs_areas` (`id`) ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `hcs_users_notifications_categories_disabled` (
  `user_id` int(11) NOT NULL,
  `item_type_id` int(10) unsigned NOT NULL,
  `area_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`item_type_id`,`area_id`),
  CONSTRAINT `FK_hcs_users_notifications_categories_disabled_1` FOREIGN KEY (`user_id`) REFERENCES `hcs_users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*CREATE TABLE `hcs_users_notifications_webs` (
  `user_id` int(11) NOT NULL,
  `web_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`web_id`),
  KEY `FK_hcs_users_notifications_webs_2_idx` (`web_id`),
  CONSTRAINT `FK_hcs_users_notifications_webs_1` FOREIGN KEY (`user_id`) REFERENCES `hcs_users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_hcs_users_notifications_webs_2` FOREIGN KEY (`web_id`) REFERENCES `hcs_webs` (`web_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;*/

ALTER TABLE `dp_hcs`.`hcs_users`
ADD COLUMN `notifications_web_digest_type_id` INT(11) NULL DEFAULT NULL AFTER `notifications_last_digest_date`,
ADD COLUMN `notifications_web_last_digest_date` DATETIME NULL DEFAULT NULL AFTER `notifications_web_digest_type_id`;
