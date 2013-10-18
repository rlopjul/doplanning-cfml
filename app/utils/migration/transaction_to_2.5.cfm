
	
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
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		</cfquery>
		
		<!--- TABLA DE TIPOS DE CAMPOS --->
		<cfquery datasource="#client_dsn#">	
			CREATE TABLE `#client_abb#_tables_fields_types` (
			  `field_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
			  `input_type` varchar(45) NOT NULL,
			  `name` varchar(50) NOT NULL,
			  `max_length` int(10) unsigned DEFAULT NULL,
			  `mysql_type` varchar(45) DEFAULT NULL,
			  `cf_sql_type` varchar(45) DEFAULT NULL,
			  `enabled` tinyint(1) NOT NULL,
			  PRIMARY KEY (`field_type_id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
			 INSERT INTO `#client_abb#_tables_fields_types` (`field_type_id`,`input_type`,`name`,`max_length`,`mysql_type`,`cf_sql_type`,`enabled`) VALUES
				 (1,'text','Texto plano 1 línea (máx. 255 caracteres)',255,'VARCHAR(255)','cf_sql_varchar',1),
				 (2,'textarea','Texto plano varias líneas (máx. 21000 caracteres)',21000,'TEXT','cf_sql_longvarchar',1),
				 (3,'textarea','Texto de varias líneas grande',1000000,'MEDIUMTEXT','cf_sql_longvarchar',1),
				 (4,'number','Número entero',20,'BIGINT(20)','cf_sql_bigint',1),
				 (5,'text','Número decimal',30,'DECIMAL(30,5)','cf_sql_decimal',1),
				 (6,'date','Fecha (formato DD-MM-AAAA)',10,'DATE','cf_sql_date',1),
				 (7,'select','Booleano (Sí/No)',1,'TINYINT(1)','cf_sql_bit',1),
				 (8,'url','URL',2000,'VARCHAR(2000)','cf_sql_varchar',1),
				 (9,'select','Lista desplegable con selección simple',11,'INT(11)','cf_sql_integer',0),
				 (10,'select','Lista desplegable con selección múltiple',11,'INT(11)','cf_sql_integer',0);
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
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		</cfquery>
		
		<cfquery datasource="#client_dsn#">	
			INSERT INTO `#client_abb#_menu_types` VALUES 
			 (1,'Menú principal'),
			 (2,'Pie'),
			 (3,'Otros'),
			 (4,'Centros');
		</cfquery>	
		
		
		<cfquery datasource="#client_dsn#">	
			ALTER TABLE `#client_abb#_areas` ADD CONSTRAINT `FK_#client_abb#_areas_4` FOREIGN KEY `FK_#client_abb#_areas_4` (`menu_type_id`)
				REFERENCES `#client_abb#_menu_types` (`menu_type_id`)
				ON DELETE RESTRICT
				ON UPDATE RESTRICT;
		</cfquery>		
		
		
		<cfquery datasource="#client_dsn#">	
		ALTER TABLE `#client_abb#_areas` ADD COLUMN `default_typology_id` INTEGER UNSIGNED AFTER `menu_type_id`,
			 ADD CONSTRAINT `FK_#client_abb#_areas_5` FOREIGN KEY `FK_#client_abb#_areas_5` (`default_typology_id`)
				REFERENCES `#client_abb#_typologies` (`id`)
				ON DELETE RESTRICT
				ON UPDATE RESTRICT;
		</cfquery>				
		
		


				
	</cftransaction>

	

