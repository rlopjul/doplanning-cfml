
	
<!---Modificaciones de la base de datos--->
<cftransaction>

	<!--- TABLA PARA ORDENAR ITEMS --->
	<cfquery datasource="#client_dsn#">	
		CREATE TABLE `#client_abb#_items_position` (
		  `item_id` int(11) NOT NULL,
		  `item_type_id` int(10) unsigned NOT NULL,
		  `area_id` int(11) NOT NULL,
		  `position` int(10) unsigned NOT NULL,
		  PRIMARY KEY (`item_id`,`item_type_id`,`area_id`) USING BTREE,
		  KEY `FK_#client_abb#_items_position_1` (`area_id`),
		  CONSTRAINT `FK_#client_abb#_items_position_1` FOREIGN KEY (`area_id`) REFERENCES `#client_abb#_areas` (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>
	
	<!--- TABLA DE TIPOS DE CAMPOS --->
	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_tables_fields_types` (
		  `field_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
		  `field_type_group` varchar(45) NOT NULL,
		  `input_type` varchar(45) NOT NULL,
		  `name` varchar(100) NOT NULL,
		  `max_length` int(10) unsigned DEFAULT NULL,
		  `mysql_type` varchar(45) DEFAULT NULL,
		  `cf_sql_type` varchar(45) DEFAULT NULL,
		  `enabled` tinyint(1) NOT NULL,
		  `position` int(10) unsigned NOT NULL,
		  PRIMARY KEY (`field_type_id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>		

	<!--- TABLAS DE LISTAS --->
	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_lists` (
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
		  KEY `FK_#client_abb#_lists_1` (`user_in_charge`),
		  KEY `FK_#client_abb#_lists_2` (`area_id`),
		  KEY `FK_#client_abb#_lists_3` (`attached_file_id`),
		  KEY `FK_#client_abb#_lists_4` (`attached_image_id`),
		  CONSTRAINT `FK_#client_abb#_lists_1` FOREIGN KEY (`user_in_charge`) REFERENCES `#client_abb#_users` (`id`),
		  CONSTRAINT `FK_#client_abb#_lists_2` FOREIGN KEY (`area_id`) REFERENCES `#client_abb#_areas` (`id`),
		  CONSTRAINT `FK_#client_abb#_lists_3` FOREIGN KEY (`attached_file_id`) REFERENCES `#client_abb#_files` (`id`),
		  CONSTRAINT `FK_#client_abb#_lists_4` FOREIGN KEY (`attached_image_id`) REFERENCES `#client_abb#_files` (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>		


	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_lists_fields` (
		  `field_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
		  `field_type_id` int(10) unsigned NOT NULL,
		  `table_id` int(10) unsigned NOT NULL,
		  `label` varchar(100) NOT NULL,
		  `description` varchar(1000) NOT NULL,
		  `required` tinyint(1) NOT NULL DEFAULT '0',
		  `position` int(10) unsigned NOT NULL,
		  `default_value` varchar(1000) DEFAULT NULL,
		  PRIMARY KEY (`field_id`),
		  KEY `FK_#client_abb#_lists_fields_1` (`field_type_id`),
		  KEY `FK_#client_abb#_lists_fields_2` (`table_id`),
		  CONSTRAINT `FK_#client_abb#_lists_fields_2` FOREIGN KEY (`table_id`) REFERENCES `#client_abb#_lists` (`id`),
		  CONSTRAINT `FK_#client_abb#_lists_fields_1` FOREIGN KEY (`field_type_id`) REFERENCES `#client_abb#_tables_fields_types` (`field_type_id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>		
	
		

	<!--- TABLAS DE FORMULARIOS --->
	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_forms` (
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
		  KEY `FK_#client_abb#_forms_1` (`user_in_charge`),
		  KEY `FK_#client_abb#_forms_2` (`area_id`),
		  KEY `FK_#client_abb#_forms_3` (`attached_file_id`),
		  KEY `FK_#client_abb#_forms_4` (`attached_image_id`),
		  CONSTRAINT `FK_#client_abb#_forms_1` FOREIGN KEY (`user_in_charge`) REFERENCES `#client_abb#_users` (`id`),
		  CONSTRAINT `FK_#client_abb#_forms_2` FOREIGN KEY (`area_id`) REFERENCES `#client_abb#_areas` (`id`),
		  CONSTRAINT `FK_#client_abb#_forms_3` FOREIGN KEY (`attached_file_id`) REFERENCES `#client_abb#_files` (`id`),
		  CONSTRAINT `FK_#client_abb#_forms_4` FOREIGN KEY (`attached_image_id`) REFERENCES `#client_abb#_files` (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>		


	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_forms_fields` (
		  `field_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
		  `field_type_id` int(10) unsigned NOT NULL,
		  `table_id` int(10) unsigned NOT NULL,
		  `label` varchar(100) NOT NULL,
		  `description` varchar(1000) NOT NULL,
		  `required` tinyint(1) NOT NULL DEFAULT '0',
		  `position` int(10) unsigned NOT NULL,
		  `default_value` varchar(1000) DEFAULT NULL,
		  PRIMARY KEY (`field_id`),
		  KEY `FK_#client_abb#_forms_fields_1` (`field_type_id`),
		  KEY `FK_#client_abb#_forms_fields_2` (`table_id`),
		  CONSTRAINT `FK_#client_abb#_forms_fields_2` FOREIGN KEY (`table_id`) REFERENCES `#client_abb#_forms` (`id`),
		  CONSTRAINT `FK_#client_abb#_forms_fields_1` FOREIGN KEY (`field_type_id`) REFERENCES `#client_abb#_tables_fields_types` (`field_type_id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>	
	
	<!--- TABLAS DE TIPOLOGÍAS --->	
	
	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_typologies` (
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
		  KEY `FK_#client_abb#_typologies_1` (`user_in_charge`),
		  KEY `FK_#client_abb#_typologies_2` (`area_id`),
		  KEY `FK_#client_abb#_typologies_3` (`attached_file_id`),
		  KEY `FK_#client_abb#_typologies_4` (`attached_image_id`),
		  CONSTRAINT `FK_#client_abb#_typologies_1` FOREIGN KEY (`user_in_charge`) REFERENCES `#client_abb#_users` (`id`),
		  CONSTRAINT `FK_#client_abb#_typologies_2` FOREIGN KEY (`area_id`) REFERENCES `#client_abb#_areas` (`id`),
		  CONSTRAINT `FK_#client_abb#_typologies_3` FOREIGN KEY (`attached_file_id`) REFERENCES `#client_abb#_files` (`id`),
		  CONSTRAINT `FK_#client_abb#_typologies_4` FOREIGN KEY (`attached_image_id`) REFERENCES `#client_abb#_files` (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>		


	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_typologies_fields` (
		  `field_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
		  `field_type_id` int(10) unsigned NOT NULL,
		  `table_id` int(10) unsigned NOT NULL,
		  `label` varchar(100) NOT NULL,
		  `description` varchar(1000) NOT NULL,
		  `required` tinyint(1) NOT NULL DEFAULT '0',
		  `position` int(10) unsigned NOT NULL,
		  `default_value` varchar(1000) DEFAULT NULL,
		  PRIMARY KEY (`field_id`),
		  KEY `FK_#client_abb#_typologies_fields_1` (`field_type_id`),
		  KEY `FK_#client_abb#_typologies_fields_2` (`table_id`),
		  CONSTRAINT `FK_#client_abb#_typologies_fields_2` FOREIGN KEY (`table_id`) REFERENCES `#client_abb#_typologies` (`id`),
		  CONSTRAINT `FK_#client_abb#_typologies_fields_1` FOREIGN KEY (`field_type_id`) REFERENCES `#client_abb#_tables_fields_types` (`field_type_id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>		
	
	
	<!--- TABLA DE IMÁGENES --->

	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_images` (
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
		  KEY `FK_#client_abb#_images_4` (`attached_image_id`),
		  KEY `FK_#client_abb#_images_5` (`display_type_id`),
		  CONSTRAINT `FK_#client_abb#_images_1` FOREIGN KEY (`user_in_charge`) REFERENCES `#client_abb#_users` (`id`),
		  CONSTRAINT `FK_#client_abb#_images_2` FOREIGN KEY (`attached_file_id`) REFERENCES `#client_abb#_files` (`id`),
		  CONSTRAINT `FK_#client_abb#_images_3` FOREIGN KEY (`area_id`) REFERENCES `#client_abb#_areas` (`id`),
		  CONSTRAINT `FK_#client_abb#_images_4` FOREIGN KEY (`attached_image_id`) REFERENCES `#client_abb#_files` (`id`),
		  CONSTRAINT `FK_#client_abb#_images_5` FOREIGN KEY (`display_type_id`) REFERENCES `#client_abb#_display_types` (`display_type_id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>	
	
	<!---TABLAS DE COMENTARIOS DE PUBMED--->		

	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_pubmeds` (
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
		  KEY `FK_#client_abb#_pubmeds_4` (`attached_image_id`),
		  KEY `FK_#client_abb#_pubmeds_5` (`display_type_id`),
		  CONSTRAINT `FK_#client_abb#_pubmeds_5` FOREIGN KEY (`display_type_id`) REFERENCES `#client_abb#_display_types` (`display_type_id`),
		  CONSTRAINT `FK_#client_abb#_pubmeds_1` FOREIGN KEY (`user_in_charge`) REFERENCES `#client_abb#_users` (`id`),
		  CONSTRAINT `FK_#client_abb#_pubmeds_2` FOREIGN KEY (`attached_file_id`) REFERENCES `#client_abb#_files` (`id`),
		  CONSTRAINT `FK_#client_abb#_pubmeds_3` FOREIGN KEY (`area_id`) REFERENCES `#client_abb#_areas` (`id`),
		  CONSTRAINT `FK_#client_abb#_pubmeds_4` FOREIGN KEY (`attached_image_id`) REFERENCES `#client_abb#_files` (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>		
	
	
	
	<!--- Añadir columna link target a las tablas: entries, events y news --->
	
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_entries` ADD COLUMN `link_target` VARCHAR(45) NOT NULL AFTER `link`;
	</cfquery>			
	
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_events` ADD COLUMN `link_target` VARCHAR(45) NOT NULL AFTER `link`;
	</cfquery>	
	
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_news` ADD COLUMN `link_target` VARCHAR(45) NOT NULL AFTER `link`;
	</cfquery>					
	
	
	<!--- Añadir columna typology_id y row_id a los archivos --->
	
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_files` 
		ADD COLUMN `typology_id` INTEGER UNSIGNED AFTER `status_replacement`,
		ADD COLUMN `typology_row_id` INTEGER UNSIGNED AFTER `typology_id`;
	</cfquery>			
	
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_files` 
		ADD CONSTRAINT `FK_#client_abb#_files_2` FOREIGN KEY `FK_#client_abb#_files_2` (`typology_id`)
		REFERENCES `#client_abb#_typologies` (`id`)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT;
	</cfquery>			
	
	
	
	<!--- INSERT --->
	
	<cfquery datasource="#client_dsn#">				 
		INSERT INTO `#client_abb#_tables_fields_types` (`field_type_id`,`field_type_group`,`input_type`,`name`,`max_length`,`mysql_type`,`cf_sql_type`,`enabled`,`position`) VALUES 
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
	</cfquery>			
	
	
	<!--- New column position --->
	
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_entries` MODIFY COLUMN `position` INTEGER UNSIGNED DEFAULT NULL;
	</cfquery>			
	
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_news` MODIFY COLUMN `position` INTEGER UNSIGNED DEFAULT NULL;
	</cfquery>
		
	
	<!--- New column users --->
	
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_users`
		  ADD COLUMN `notify_new_pubmed` BOOLEAN default 1 NOT NULL AFTER `notify_new_consultation`,
		  ADD COLUMN `notify_new_image` BOOLEAN default 1 NOT NULL AFTER `notify_new_pubmed`,
		  ADD COLUMN `notify_new_list` BOOLEAN default 1  NOT NULL AFTER `notify_new_image`,
		  ADD COLUMN `notify_new_list_row` BOOLEAN default 1  NOT NULL AFTER `notify_new_list`,
		  ADD COLUMN `notify_new_form` BOOLEAN NOT NULL DEFAULT 1 AFTER `notify_new_list_row`,
		  ADD COLUMN `notify_new_form_row` BOOLEAN default 1  NOT NULL AFTER `notify_new_form`,
		  ADD COLUMN `notify_new_typology` BOOLEAN default 1  NOT NULL AFTER `notify_new_form_row`;
	</cfquery>			
	
				
	<!--- Menu type --->
	
	
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_areas` ADD COLUMN `menu_type_id` INTEGER UNSIGNED AFTER `type`;
	</cfquery>

	
	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_menu_types` (
		  `menu_type_id` int(10) unsigned NOT NULL,
		  `menu_type_title_es` varchar(255) NOT NULL,
		  PRIMARY KEY (`menu_type_id`) USING BTREE
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>
	
	<cfquery datasource="#client_dsn#">	
		INSERT INTO `#client_abb#_menu_types` VALUES 
		 (1,'Menú principal'),
		 (2,'Pie'),
		 (3,'Otros'),
		 (4,'Centros'),
		 (5,'Imágenes');
	</cfquery>	
	
	
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_areas` ADD CONSTRAINT `FK_#client_abb#_areas_4` FOREIGN KEY `FK_#client_abb#_areas_4` (`menu_type_id`)
			REFERENCES `#client_abb#_menu_types` (`menu_type_id`)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT;
	</cfquery>		
	
	
	
	<!--- Tipologías --->
	<cfquery datasource="#client_dsn#">	
	ALTER TABLE `#client_abb#_areas` ADD COLUMN `default_typology_id` INTEGER UNSIGNED AFTER `menu_type_id`,
		 ADD CONSTRAINT `FK_#client_abb#_areas_5` FOREIGN KEY `FK_#client_abb#_areas_5` (`default_typology_id`)
			REFERENCES `#client_abb#_typologies` (`id`)
			ON DELETE RESTRICT
			ON UPDATE RESTRICT;
	</cfquery>				
	
	
	<!--- Tipologías --->
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_areas` ADD COLUMN `hide_in_menu` BOOLEAN NOT NULL DEFAULT 0 AFTER `menu_type_id`;
	</cfquery>	
	
	
	<!--- List --->
	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_lists_users` (
		  `list_id` int(10) unsigned NOT NULL,
		  `user_id` int(11) NOT NULL,
		  PRIMARY KEY (`list_id`,`user_id`),
		  KEY `FK_#client_abb#_lists_users_2` (`user_id`),
		  CONSTRAINT `FK_#client_abb#_lists_users_1` FOREIGN KEY (`list_id`) REFERENCES `#client_abb#_lists` (`id`) ON DELETE CASCADE,
		  CONSTRAINT `FK_#client_abb#_lists_users_2` FOREIGN KEY (`user_id`) REFERENCES `#client_abb#_users` (`id`) ON DELETE CASCADE
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>	


	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_lists_fields` ADD COLUMN `list_area_id` INTEGER AFTER `default_value`,
			ADD CONSTRAINT `FK_#client_abb#_lists_fields_3` FOREIGN KEY `FK_#client_abb#_lists_fields_3` (`list_area_id`)
			REFERENCES `#client_abb#_areas` (`id`)
			ON DELETE SET NULL
			ON UPDATE RESTRICT;
	</cfquery>	
			
	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_lists_rows_areas` (
		  `list_id` int(10) unsigned NOT NULL,
		  `row_id` int(10) unsigned NOT NULL,
		  `field_id` int(10) unsigned NOT NULL,
		  `area_id` int(11) NOT NULL,
		  PRIMARY KEY (`list_id`,`row_id`,`area_id`,`field_id`) USING BTREE,
		  KEY `FK_#client_abb#_lists_rows_areas_2` (`field_id`),
		  KEY `FK_#client_abb#_lists_rows_areas_3` (`area_id`),
		  CONSTRAINT `FK_#client_abb#_lists_rows_areas_1` FOREIGN KEY (`list_id`) REFERENCES `#client_abb#_lists` (`id`) ON DELETE CASCADE,
		  CONSTRAINT `FK_#client_abb#_lists_rows_areas_2` FOREIGN KEY (`field_id`) REFERENCES `#client_abb#_lists_fields` (`field_id`) ON DELETE CASCADE,
		  CONSTRAINT `FK_#client_abb#_lists_rows_areas_3` FOREIGN KEY (`area_id`) REFERENCES `#client_abb#_areas` (`id`) ON DELETE CASCADE
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>					
			
			
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_typologies_fields` ADD COLUMN `list_area_id` INTEGER AFTER `default_value`,
			ADD CONSTRAINT `FK_#client_abb#_typologies_fields_3` FOREIGN KEY `FK_#client_abb#_typologies_fields_3` (`list_area_id`)
			REFERENCES `#client_abb#_areas` (`id`)
			ON DELETE SET NULL
			ON UPDATE RESTRICT;
	</cfquery>					
			
	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_typologies_rows_areas` (
		  `typology_id` int(10) unsigned NOT NULL,
		  `row_id` int(10) unsigned NOT NULL,
		  `field_id` int(10) unsigned NOT NULL,
		  `area_id` int(11) NOT NULL,
		  PRIMARY KEY (`typology_id`,`row_id`,`area_id`,`field_id`) USING BTREE,
		  KEY `FK_#client_abb#_typologies_rows_areas_2` (`field_id`),
		  KEY `FK_#client_abb#_typologies_rows_areas_3` (`area_id`),
		  CONSTRAINT `FK_#client_abb#_typologies_rows_areas_1` FOREIGN KEY (`typology_id`) REFERENCES `#client_abb#_typologies` (`id`) ON DELETE CASCADE,
		  CONSTRAINT `FK_#client_abb#_typologies_rows_areas_2` FOREIGN KEY (`field_id`) REFERENCES `#client_abb#_typologies_fields` (`field_id`) ON DELETE CASCADE,
		  CONSTRAINT `FK_#client_abb#_typologies_rows_areas_3` FOREIGN KEY (`area_id`) REFERENCES `#client_abb#_areas` (`id`) ON DELETE CASCADE
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>						
			
	<!--- Form fields --->
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_forms_fields` ADD COLUMN `list_area_id` INTEGER AFTER `default_value`,
			ADD CONSTRAINT `FK_#client_abb#_forms_fields_3` FOREIGN KEY `FK_#client_abb#_forms_fields_3` (`list_area_id`)		
			REFERENCES `#client_abb#_areas` (`id`)
			ON DELETE SET NULL
			ON UPDATE RESTRICT;
	</cfquery>							
			
	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_forms_rows_areas` (
		  `form_id` int(10) unsigned NOT NULL,			
		  `row_id` int(10) unsigned NOT NULL,
		  `field_id` int(10) unsigned NOT NULL,
		  `area_id` int(11) NOT NULL,
		  PRIMARY KEY (`form_id`,`row_id`,`area_id`,`field_id`) USING BTREE,
		  KEY `FK_#client_abb#_forms_rows_areas_2` (`field_id`),
		  KEY `FK_#client_abb#_forms_rows_areas_3` (`area_id`),
		  CONSTRAINT `FK_#client_abb#_forms_rows_areas_1` FOREIGN KEY (`form_id`) REFERENCES `#client_abb#_forms` (`id`) ON DELETE CASCADE,
		  CONSTRAINT `FK_#client_abb#_forms_rows_areas_2` FOREIGN KEY (`field_id`) REFERENCES `#client_abb#_forms_fields` (`field_id`) ON DELETE CASCADE,
		  CONSTRAINT `FK_#client_abb#_forms_rows_areas_3` FOREIGN KEY (`area_id`) REFERENCES `#client_abb#_areas` (`id`) ON DELETE CASCADE
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>	
	
	<!--- 28/11/2013 --->	
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_files` ADD COLUMN `file_type_id` INTEGER UNSIGNED NOT NULL DEFAULT 1 AFTER `typology_row_id`;
	</cfquery>	
	
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_files`  ADD COLUMN `area_id` INTEGER UNSIGNED AFTER `file_type_id`;
	</cfquery>
	
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_files`  ADD COLUMN `locked` BOOLEAN NOT NULL DEFAULT 0 AFTER `area_id`;
	</cfquery>
	
	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_files_locks` (
		  `file_id` int(11) NOT NULL,
		  `user_id` int(11) NOT NULL,
		  `lock_date` datetime NOT NULL,
		  `lock` tinyint(1) NOT NULL,
		  PRIMARY KEY (`file_id`,`user_id`,`lock_date`),
		  KEY `FK_#client_abb#_files_locks_2` (`user_id`),
		  CONSTRAINT `FK_#client_abb#_files_locks_1` FOREIGN KEY (`file_id`) REFERENCES `#client_abb#_files` (`id`) ON DELETE CASCADE,
		  CONSTRAINT `FK_#client_abb#_files_locks_2` FOREIGN KEY (`user_id`) REFERENCES `#client_abb#_users` (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>
	
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_users` 
			 ADD COLUMN `notify_delete_file` BOOLEAN NOT NULL DEFAULT 1 AFTER `notify_new_typology`,
			 ADD COLUMN `notify_lock_file` BOOLEAN NOT NULL DEFAULT 1 AFTER `notify_delete_file`;	
	</cfquery>
	
	
	
	<!--- 16/12/2013 --->	
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_files` ADD COLUMN `reviser_user` INTEGER AFTER `locked`,
			 ADD COLUMN `approver_user` INTEGER AFTER `reviser_user`,
			 ADD CONSTRAINT `FK_#client_abb#_files_3` FOREIGN KEY `FK_#client_abb#_files_3` (`reviser_user`)
				REFERENCES `#client_abb#_users` (`id`)
				ON DELETE RESTRICT
				ON UPDATE RESTRICT,
			 ADD CONSTRAINT `FK_#client_abb#_files_4` FOREIGN KEY `FK_#client_abb#_files_4` (`approver_user`)
				REFERENCES `#client_abb#_users` (`id`)
				ON DELETE RESTRICT
				ON UPDATE RESTRICT;
	</cfquery>	
	
	
	
	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_files_versions` (
		  `version_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
		
		  `file_id` int(11) NOT NULL,
		  `physical_name` text COLLATE utf8_unicode_ci,
		  `user_in_charge` int(11) NOT NULL,
		  `file_size` int(11) DEFAULT NULL,
		  `file_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
		  `uploading_date` datetime NOT NULL,
		  `description` text COLLATE utf8_unicode_ci,
		  `file_name` text COLLATE utf8_unicode_ci,
		  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
		  `revision_user` int(11) DEFAULT NULL,
		  `revision_request_user` int(11) DEFAULT NULL,
		  `revision_request_date` datetime DEFAULT NULL,
		  `revised` tinyint(1) DEFAULT NULL,
		  `revision_date` datetime DEFAULT NULL,
		  `revision_result` tinyint(1) DEFAULT NULL,
		  `approval_user` int(11) DEFAULT NULL,
		  `approval_request_date` datetime DEFAULT NULL,
		  `approved` tinyint(1) DEFAULT NULL,
		  `approval_date` datetime DEFAULT NULL,
		  `publication_user` int(11) DEFAULT NULL,
		  `publication_date` datetime DEFAULT NULL,
		  `publication_file_id` int(11) DEFAULT NULL,
		  `publication_area_id` int(11) DEFAULT NULL,
		
		  PRIMARY KEY (`version_id`) USING BTREE,
		  KEY `user_in_charge` (`user_in_charge`),
		  KEY `FK_#client_abb#_files_versions_2` (`file_id`),
		  KEY `FK_#client_abb#_files_versions_3` (`revision_request_user`),
		  KEY `FK_#client_abb#_files_versions_4` (`revision_user`),
		  KEY `FK_#client_abb#_files_versions_5` (`approval_user`),
		  KEY `FK_#client_abb#_files_versions_6` (`publication_user`),
		  KEY `FK_#client_abb#_files_versions_7` (`publication_file_id`),
		  KEY `FK_#client_abb#_files_versions_9` (`publication_area_id`),
		  CONSTRAINT `FK_#client_abb#_files_versions_9` FOREIGN KEY (`publication_area_id`) REFERENCES `#client_abb#_areas` (`id`) ON DELETE SET NULL,
		
		  CONSTRAINT `FK_#client_abb#_files_versions_1` FOREIGN KEY (`user_in_charge`) REFERENCES `#client_abb#_users` (`id`),
		  CONSTRAINT `FK_#client_abb#_files_versions_2` FOREIGN KEY (`file_id`) REFERENCES `#client_abb#_files` (`id`),
		  CONSTRAINT `FK_#client_abb#_files_versions_3` FOREIGN KEY (`revision_request_user`) REFERENCES `#client_abb#_users` (`id`) ON DELETE SET NULL,
		  CONSTRAINT `FK_#client_abb#_files_versions_4` FOREIGN KEY (`revision_user`) REFERENCES `#client_abb#_users` (`id`),
		  CONSTRAINT `FK_#client_abb#_files_versions_5` FOREIGN KEY (`approval_user`) REFERENCES `#client_abb#_users` (`id`),
		  CONSTRAINT `FK_#client_abb#_files_versions_6` FOREIGN KEY (`publication_user`) REFERENCES `#client_abb#_users` (`id`) ON DELETE SET NULL,
		  CONSTRAINT `FK_#client_abb#_files_versions_7` FOREIGN KEY (`publication_file_id`) REFERENCES `#client_abb#_files` (`id`) ON DELETE SET NULL,
		  CONSTRAINT `FK_#client_abb#_files_versions_8` FOREIGN KEY (`publication_area_id`) REFERENCES `#client_abb#_areas` (`id`) ON DELETE SET NULL
		
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>			
	
	

	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_files` ADD COLUMN `in_approval` BOOLEAN NOT NULL DEFAULT 0 AFTER `approver_user`;
	</cfquery>
	
	<!--- 04/02/2014 --->	

	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_lists_views` (
		  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
		  `table_id` int(10) unsigned NOT NULL,
		  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
		  `description` varchar(1000) COLLATE utf8_unicode_ci NOT NULL,
		  `user_in_charge` int(11) NOT NULL,
		  `area_id` int(11) NOT NULL,
		  `creation_date` datetime NOT NULL,
		  `last_update_date` datetime DEFAULT NULL,
		  `include_creation_date` tinyint(1) NOT NULL,
		  `include_last_update_date` tinyint(1) NOT NULL,
		  `include_insert_user` tinyint(1) NOT NULL,
		  `include_update_user` tinyint(1) NOT NULL,
		  `creation_date_position` int(10) unsigned NOT NULL,
		  `last_update_date_position` int(10) unsigned NOT NULL,
		  `insert_user_position` int(10) unsigned NOT NULL,
		  `update_user_position` int(10) unsigned NOT NULL,
		  PRIMARY KEY (`id`) USING BTREE,
		  KEY `FK_#client_abb#_lists_views_1` (`table_id`),
		  KEY `FK_#client_abb#_lists_views_2` (`user_in_charge`),
		  KEY `FK_#client_abb#_lists_views_3` (`area_id`),
		  CONSTRAINT `FK_#client_abb#_lists_views_1` FOREIGN KEY (`table_id`) REFERENCES `#client_abb#_lists` (`id`),
		  CONSTRAINT `FK_#client_abb#_lists_views_2` FOREIGN KEY (`user_in_charge`) REFERENCES `#client_abb#_users` (`id`),
		  CONSTRAINT `FK_#client_abb#_lists_views_3` FOREIGN KEY (`area_id`) REFERENCES `#client_abb#_areas` (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	</cfquery>	


	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_lists_views_fields` (
		  `view_id` int(10) unsigned NOT NULL,
		  `field_id` int(10) unsigned NOT NULL,
		  `position` int(10) unsigned NOT NULL,
		  UNIQUE KEY `UNIQUE` (`view_id`,`field_id`) USING BTREE,
		  KEY `FK_#client_abb#_lists_views_fields_2` (`field_id`) USING BTREE,
		  CONSTRAINT `FK_#client_abb#_lists_views_fields_1` FOREIGN KEY (`view_id`) REFERENCES `#client_abb#_lists_views` (`id`) ON DELETE CASCADE,
		  CONSTRAINT `FK_#client_abb#_lists_views_fields_2` FOREIGN KEY (`field_id`) REFERENCES `#client_abb#_lists_fields` (`field_id`) ON DELETE CASCADE
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;			
	</cfquery>		
	

	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_forms_views` (
		  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
		  `table_id` int(10) unsigned NOT NULL,
		  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
		  `description` varchar(1000) COLLATE utf8_unicode_ci NOT NULL,
		  `user_in_charge` int(11) NOT NULL,
		  `area_id` int(11) NOT NULL,
		  `creation_date` datetime NOT NULL,
		  `last_update_date` datetime DEFAULT NULL,
		  `include_creation_date` tinyint(1) NOT NULL,
		  `include_last_update_date` tinyint(1) NOT NULL,
		  `include_insert_user` tinyint(1) NOT NULL,
		  `include_update_user` tinyint(1) NOT NULL,
		  `creation_date_position` int(10) unsigned NOT NULL,
		  `last_update_date_position` int(10) unsigned NOT NULL,
		  `insert_user_position` int(10) unsigned NOT NULL,
		  `update_user_position` int(10) unsigned NOT NULL,
		  PRIMARY KEY (`id`) USING BTREE,
		  KEY `FK_#client_abb#_forms_views_1` (`table_id`),
		  KEY `FK_#client_abb#_forms_views_2` (`user_in_charge`),
		  KEY `FK_#client_abb#_forms_views_3` (`area_id`),
		  CONSTRAINT `FK_#client_abb#_forms_views_1` FOREIGN KEY (`table_id`) REFERENCES `#client_abb#_forms` (`id`),
		  CONSTRAINT `FK_#client_abb#_forms_views_2` FOREIGN KEY (`user_in_charge`) REFERENCES `#client_abb#_users` (`id`),
		  CONSTRAINT `FK_#client_abb#_forms_views_3` FOREIGN KEY (`area_id`) REFERENCES `#client_abb#_areas` (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;			
	</cfquery>	
	
	<cfquery datasource="#client_dsn#">	
		CREATE TABLE  `#client_abb#_forms_views_fields` (
		  `view_id` int(10) unsigned NOT NULL,
		  `field_id` int(10) unsigned NOT NULL,
		  `position` int(10) unsigned NOT NULL,
		  UNIQUE KEY `UNIQUE` (`view_id`,`field_id`) USING BTREE,
		  KEY `FK_#client_abb#_forms_views_fields_2` (`field_id`) USING BTREE,
		  CONSTRAINT `FK_#client_abb#_forms_views_fields_1` FOREIGN KEY (`view_id`) REFERENCES `#client_abb#_forms_views` (`id`) ON DELETE CASCADE,
		  CONSTRAINT `FK_#client_abb#_forms_views_fields_2` FOREIGN KEY (`field_id`) REFERENCES `#client_abb#_forms_fields` (`field_id`) ON DELETE CASCADE
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;			
	</cfquery>	
	
			
	<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_users` ADD COLUMN `notify_new_list_view` BOOLEAN NOT NULL DEFAULT '1' AFTER `notify_new_list_row`,
		 ADD COLUMN `notify_new_form_view` BOOLEAN NOT NULL DEFAULT '1' AFTER `notify_new_form_row`;			
	</cfquery>			
	
			
</cftransaction>

	

