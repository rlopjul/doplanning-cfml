<!--- NUEVAS TABLAS --->

<!--- TABLA PARA ORDENAR ITEMS --->
CREATE TABLE  `dp_software7`.`software7_items_position` (
  `item_id` int(11) NOT NULL,
  `item_type_id` int(10) unsigned NOT NULL,
  `area_id` int(11) NOT NULL,
  `position` int(10) unsigned NOT NULL,
  PRIMARY KEY (`item_id`,`item_type_id`,`area_id`) USING BTREE,
  KEY `FK_software7_items_position_1` (`area_id`),
  CONSTRAINT `FK_software7_items_position_1` FOREIGN KEY (`area_id`) REFERENCES `software7_areas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

<!--- TABLA DE TIPOS DE CAMPOS --->
CREATE TABLE  `dp_software7`.`software7_tables_fields_types` (
  `field_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `input_type` varchar(45) NOT NULL,
  `name` varchar(50) NOT NULL,
  `max_length` int(10) unsigned DEFAULT NULL,
  `mysql_type` varchar(45) DEFAULT NULL,
  `cf_sql_type` varchar(45) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`field_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


<!--- TABLAS DE LISTAS --->
CREATE TABLE  `dp_software7`.`software7_lists` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `user_in_charge` int(11) NOT NULL,
  `area_id` int(11) NOT NULL,
  `creation_date` datetime NOT NULL,
  `parent_id` int(11) NOT NULL,
  `parent_kind` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attached_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attached_file_id` int(11) DEFAULT NULL,
  `attached_image_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attached_image_id` int(11) DEFAULT NULL,
  `status` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `link` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `link_target` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `last_update_date` datetime DEFAULT NULL,
  `enabled` tinyint(1) DEFAULT '0',
  `structure_available` tinyint(1) NOT NULL DEFAULT '0',
  `general` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `FK_software7_lists_1` (`user_in_charge`),
  KEY `FK_software7_lists_2` (`area_id`),
  KEY `FK_software7_lists_3` (`attached_file_id`),
  KEY `FK_software7_lists_4` (`attached_image_id`),
  CONSTRAINT `FK_software7_lists_1` FOREIGN KEY (`user_in_charge`) REFERENCES `software7_users` (`id`),
  CONSTRAINT `FK_software7_lists_2` FOREIGN KEY (`area_id`) REFERENCES `software7_areas` (`id`),
  CONSTRAINT `FK_software7_lists_3` FOREIGN KEY (`attached_file_id`) REFERENCES `software7_files` (`id`),
  CONSTRAINT `FK_software7_lists_4` FOREIGN KEY (`attached_image_id`) REFERENCES `software7_files` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE  `dp_software7`.`software7_lists_fields` (
  `field_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `field_type_id` int(10) unsigned NOT NULL,
  `table_id` int(10) unsigned NOT NULL,
  `label` varchar(100) NOT NULL,
  `description` varchar(1000) NOT NULL,
  `required` tinyint(1) NOT NULL DEFAULT '0',
  `position` int(10) unsigned NOT NULL,
  `default_value` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`field_id`),
  KEY `FK_software7_lists_fields_1` (`field_type_id`),
  KEY `FK_software7_lists_fields_2` (`table_id`),
  CONSTRAINT `FK_software7_lists_fields_2` FOREIGN KEY (`table_id`) REFERENCES `software7_lists` (`id`),
  CONSTRAINT `FK_software7_lists_fields_1` FOREIGN KEY (`field_type_id`) REFERENCES `software7_tables_fields_types` (`field_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


<!--- TABLAS DE FORMULARIOS --->
<!--- Igual que las de las listas pero con forms en lugar de lists--->


<!--- TABLAS DE TIPOLOGÍAS --->
<!--- Igual que las de las listas pero con typologies en lugar de lists --->


<!--- TABLA DE IMÁGENES --->
CREATE TABLE  `dp_software7`.`software7_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text COLLATE utf8_unicode_ci,
  `description` text COLLATE utf8_unicode_ci,
  `parent_id` int(11) NOT NULL,
  `parent_kind` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_in_charge` int(11) NOT NULL,
  `attached_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attached_file_id` int(11) DEFAULT NULL,
  `creation_date` datetime NOT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `area_id` int(11) NOT NULL,
  `attached_image_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attached_image_id` int(11) DEFAULT NULL,
  `link` varchar(1000) COLLATE utf8_unicode_ci NOT NULL,
  `link_target` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `last_update_date` datetime DEFAULT NULL,
  `display_type_id` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `user_in_charge` (`user_in_charge`),
  KEY `attached_file_id` (`attached_file_id`),
  KEY `area_id` (`area_id`),
  KEY `FK_software7_images_4` (`attached_image_id`),
  KEY `FK_software7_images_5` (`display_type_id`),
  CONSTRAINT `FK_software7_images_1` FOREIGN KEY (`user_in_charge`) REFERENCES `software7_users` (`id`),
  CONSTRAINT `FK_software7_images_2` FOREIGN KEY (`attached_file_id`) REFERENCES `software7_files` (`id`),
  CONSTRAINT `FK_software7_images_3` FOREIGN KEY (`area_id`) REFERENCES `software7_areas` (`id`),
  CONSTRAINT `FK_software7_images_4` FOREIGN KEY (`attached_image_id`) REFERENCES `software7_files` (`id`),
  CONSTRAINT `FK_software7_images_5` FOREIGN KEY (`display_type_id`) REFERENCES `software7_display_types` (`display_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


<!---TABLAS DE COMENTARIOS DE PUBMED--->
CREATE TABLE  `dp_software7`.`software7_pubmeds` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` text COLLATE utf8_unicode_ci,
  `description` text COLLATE utf8_unicode_ci,
  `parent_id` int(11) NOT NULL,
  `parent_kind` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_in_charge` int(11) NOT NULL,
  `attached_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attached_file_id` int(11) DEFAULT NULL,
  `creation_date` datetime NOT NULL,
  `status` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `area_id` int(11) NOT NULL,
  `attached_image_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attached_image_id` int(11) DEFAULT NULL,
  `link` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `link_target` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `last_update_date` datetime NOT NULL,
  `identifier` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `display_type_id` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `user_in_charge` (`user_in_charge`),
  KEY `attached_file_id` (`attached_file_id`),
  KEY `area_id` (`area_id`),
  KEY `FK_software7_pubmeds_4` (`attached_image_id`),
  KEY `FK_software7_pubmeds_5` (`display_type_id`),
  CONSTRAINT `FK_software7_pubmeds_5` FOREIGN KEY (`display_type_id`) REFERENCES `software7_display_types` (`display_type_id`),
  CONSTRAINT `FK_software7_pubmeds_1` FOREIGN KEY (`user_in_charge`) REFERENCES `software7_users` (`id`),
  CONSTRAINT `FK_software7_pubmeds_2` FOREIGN KEY (`attached_file_id`) REFERENCES `software7_files` (`id`),
  CONSTRAINT `FK_software7_pubmeds_3` FOREIGN KEY (`area_id`) REFERENCES `software7_areas` (`id`),
  CONSTRAINT `FK_software7_pubmeds_4` FOREIGN KEY (`attached_image_id`) REFERENCES `software7_files` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


<!--- Añadir columna link target a las tablas: entries, events y news --->
ALTER TABLE `dp_software7`.`software7_entries` ADD COLUMN `link_target` VARCHAR(45) NOT NULL AFTER `link`;
ALTER TABLE `dp_software7`.`software7_events` ADD COLUMN `link_target` VARCHAR(45) NOT NULL AFTER `link`;
ALTER TABLE `dp_software7`.`software7_news` ADD COLUMN `link_target` VARCHAR(45) NOT NULL AFTER `link`;

<!--- Añadir columna typology_id y typology_row_id a los archivos --->
ALTER TABLE `dp_software7`.`software7_files` ADD COLUMN `typology_id` INTEGER UNSIGNED AFTER `status_replacement`,
 ADD COLUMN `typology_row_id` INTEGER UNSIGNED AFTER `typology_id`;
ALTER TABLE `dp_software7`.`software7_files` ADD CONSTRAINT `FK_software7_files_2` FOREIGN KEY `FK_software7_files_2` (`typology_id`)
    REFERENCES `software7_typologies` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;


ALTER TABLE `dp_software7`.`software7_areas` ADD COLUMN `menu_type_id` INTEGER UNSIGNED AFTER `type`;

ALTER TABLE `dp_software7`.`software7_areas` ADD CONSTRAINT `FK_software7_areas_4` FOREIGN KEY `FK_software7_areas_4` (`menu_type_id`)
    REFERENCES `software7_menu_types` (`menu_type_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;

CREATE TABLE  `dp_software7`.`software7_menu_types` (
  `menu_type_id` int(10) unsigned NOT NULL,
  `menu_type_title_es` varchar(255) NOT NULL,
  PRIMARY KEY (`menu_type_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


<!---Permitir valores nulos en campo position antiguo--->

ALTER TABLE `dp_software7`.`software7_entries` MODIFY COLUMN `position` INTEGER UNSIGNED DEFAULT NULL;
ALTER TABLE `dp_software7`.`software7_news` MODIFY COLUMN `position` INTEGER UNSIGNED DEFAULT NULL;



ALTER TABLE `dp_software7`.`software7_areas` ADD COLUMN `default_typology_id` INTEGER UNSIGNED AFTER `menu_type_id`,
 ADD CONSTRAINT `FK_software7_areas_5` FOREIGN KEY `FK_software7_areas_5` (`default_typology_id`)
    REFERENCES `software7_typologies` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT;



INSERT INTO `software7_tables_fields_types` (`field_type_id`,`field_type_group`,`input_type`,`name`,`max_length`,`mysql_type`,`cf_sql_type`,`enabled`,`position`) VALUES 
 (1,'short_text','text','Texto plano 1 línea (máx. 255 caracteres)',255,'VARCHAR(255)','cf_sql_varchar',1,1),
 (2,'long_text','textarea','Texto plano varias líneas (máx. 21000 caracteres)',21000,'TEXT','cf_sql_longvarchar',1,2),
 (3,'long_text','textarea','Texto varias líneas con formato (máx. 21000 caracteres)',21000,'TEXT','cf_sql_longvarchar',1,3),
 (4,'integer','number','Número entero',20,'BIGINT(20)','cf_sql_bigint',1,5),
 (5,'decimal','text','Número decimal',30,'DECIMAL(30,5)','cf_sql_decimal',1,6),
 (6,'date','date','Fecha (formato DD-MM-AAAA)',10,'DATE','cf_sql_date',1,7),
 (7,'boolean','select','Booleano (Sí/No)',1,'TINYINT(1)','cf_sql_bit',1,8),
 (8,'url','url','URL',2000,'VARCHAR(2000)','cf_sql_varchar',1,9),
 (9,'list','select','Lista desplegable con selección simple',11,'INT(11)','cf_sql_integer',1,10),
 (10,'list','select','Lista con selección múltiple',11,'INT(11)','cf_sql_integer',1,11),
 (11,'very_long_text','textarea','Texto muy grande con formato',1000000,'MEDIUMTEXT','cf_sql_longvarchar',1,4),
 (12,'doplanning_file','number','Archivo de DoPlanning',11,'INT(11)','cf_sql_integer',0,12);


CREATE TABLE  `dp_software7`.`software7_lists_users` (
  `list_id` int(10) unsigned NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`list_id`,`user_id`),
  KEY `FK_software7_lists_users_2` (`user_id`),
  CONSTRAINT `FK_software7_lists_users_1` FOREIGN KEY (`list_id`) REFERENCES `software7_lists` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_software7_lists_users_2` FOREIGN KEY (`user_id`) REFERENCES `software7_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `dp_software7`.`software7_lists_fields` ADD COLUMN `list_area_id` INTEGER AFTER `default_value`,
 ADD CONSTRAINT `FK_software7_lists_fields_3` FOREIGN KEY `FK_software7_lists_fields_3` (`list_area_id`)
    REFERENCES `software7_areas` (`id`)
    ON DELETE SET NULL
    ON UPDATE RESTRICT;

CREATE TABLE  `dp_software7`.`software7_lists_rows_areas` (
  `list_id` int(10) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `field_id` int(10) unsigned NOT NULL,
  `area_id` int(11) NOT NULL,
  PRIMARY KEY (`list_id`,`row_id`,`area_id`,`field_id`) USING BTREE,
  KEY `FK_software7_lists_rows_areas_2` (`field_id`),
  KEY `FK_software7_lists_rows_areas_3` (`area_id`),
  CONSTRAINT `FK_software7_lists_rows_areas_1` FOREIGN KEY (`list_id`) REFERENCES `software7_lists` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_software7_lists_rows_areas_2` FOREIGN KEY (`field_id`) REFERENCES `software7_lists_fields` (`field_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_software7_lists_rows_areas_3` FOREIGN KEY (`area_id`) REFERENCES `software7_areas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `dp_software7`.`software7_typologies_fields` ADD COLUMN `list_area_id` INTEGER AFTER `default_value`,
 ADD CONSTRAINT `FK_software7_typologies_fields_3` FOREIGN KEY `FK_software7_typologies_fields_3` (`list_area_id`)
    REFERENCES `software7_areas` (`id`)
    ON DELETE SET NULL
    ON UPDATE RESTRICT;

CREATE TABLE  `dp_software7`.`software7_typologies_rows_areas` (
  `typology_id` int(10) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `field_id` int(10) unsigned NOT NULL,
  `area_id` int(11) NOT NULL,
  PRIMARY KEY (`typology_id`,`row_id`,`area_id`,`field_id`) USING BTREE,
  KEY `FK_software7_typologies_rows_areas_2` (`field_id`),
  KEY `FK_software7_typologies_rows_areas_3` (`area_id`),
  CONSTRAINT `FK_software7_typologies_rows_areas_1` FOREIGN KEY (`typology_id`) REFERENCES `software7_typologies` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_software7_typologies_rows_areas_2` FOREIGN KEY (`field_id`) REFERENCES `software7_typologies_fields` (`field_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_software7_typologies_rows_areas_3` FOREIGN KEY (`area_id`) REFERENCES `software7_areas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `dp_software7`.`software7_forms_fields` ADD COLUMN `list_area_id` INTEGER AFTER `default_value`,
 ADD CONSTRAINT `FK_software7_forms_fields_3` FOREIGN KEY `FK_software7_forms_fields_3` (`list_area_id`)
    REFERENCES `software7_areas` (`id`)
    ON DELETE SET NULL
    ON UPDATE RESTRICT;

CREATE TABLE  `dp_software7`.`software7_forms_rows_areas` (
  `form_id` int(10) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `field_id` int(10) unsigned NOT NULL,
  `area_id` int(11) NOT NULL,
  PRIMARY KEY (`form_id`,`row_id`,`area_id`,`field_id`) USING BTREE,
  KEY `FK_software7_forms_rows_areas_2` (`field_id`),
  KEY `FK_software7_forms_rows_areas_3` (`area_id`),
  CONSTRAINT `FK_software7_forms_rows_areas_1` FOREIGN KEY (`form_id`) REFERENCES `software7_forms` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_software7_forms_rows_areas_2` FOREIGN KEY (`field_id`) REFERENCES `software7_forms_fields` (`field_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_software7_forms_rows_areas_3` FOREIGN KEY (`area_id`) REFERENCES `software7_areas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



<!---
Esto por ahora no hay que hacerlo, pero puede que haya que hacerlo después:
Script que copie todos los position de las tablas de items (áreas web: entradas, eventos, noticias, ...) en items_position
Las entradas habría que migrarlas con un orden inverso, es decir la última se pone la primera, porque a las entradas se les aplicaba en la versión anterior un orden inverso que a las noticias
Antes sólo se ordenaban: las noticias y las entradas, pero con órdenes distintos.
--->




ALTER TABLE `dp_software7`.`software7_files` ADD COLUMN `file_type_id` INTEGER UNSIGNED NOT NULL DEFAULT 1 AFTER `typology_row_id`;

ALTER TABLE `dp_software7`.`software7_files` ADD COLUMN `area_id` INTEGER UNSIGNED AFTER `file_type_id`;

ALTER TABLE `dp_software7`.`software7_files` ADD COLUMN `locked` BOOLEAN NOT NULL DEFAULT 0 AFTER `area_id`;

CREATE TABLE  `dp_software7`.`software7_files_locks` (
  `file_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `lock_date` datetime NOT NULL,
  `lock` tinyint(1) NOT NULL,
  PRIMARY KEY (`file_id`,`user_id`,`lock_date`),
  KEY `FK_software7_files_locks_2` (`user_id`),
  CONSTRAINT `FK_software7_files_locks_1` FOREIGN KEY (`file_id`) REFERENCES `software7_files` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_software7_files_locks_2` FOREIGN KEY (`user_id`) REFERENCES `software7_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `dp_software7`.`software7_users` 
 ADD COLUMN `notify_delete_file` BOOLEAN NOT NULL DEFAULT 1 AFTER `notify_new_typology`,
 ADD COLUMN `notify_lock_file` BOOLEAN NOT NULL DEFAULT 1 AFTER `notify_delete_file`;



