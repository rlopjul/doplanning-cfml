<cfif (SESSION.client_abb EQ "software7" AND SESSION.user_id IS 2)>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Migrar Cliente</title>
</head>

<body>

<cfif isDefined("FORM.abb")>


	<cfset client_abb = FORM.abb>
	
	<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>
	
	<cfquery datasource="#APPLICATION.dsn#" name="getClient">
		SELECT *
		FROM app_clients
		WHERE abbreviation = <cfqueryparam value="#client_abb#" cfsqltype="cf_sql_varchar">;
	</cfquery>

	<cfif getClient.recordCount IS 0>
		<cfthrow message="Error al obtener el cliente: #client_abb#">
	</cfif>
	
	<cfoutput>
	CLIENTE: #getClient.name#<br/>
	</cfoutput>
	
	<!---Modificaciones de la base de datos--->
	<cftransaction>
	
		<cfquery datasource="#client_dsn#">	
			ALTER TABLE `#client_abb#_users`
			 ADD COLUMN `dni` VARCHAR(45) AFTER `mobile_phone_ccode`,
			 ADD COLUMN `language` VARCHAR(10) default 'es' NOT NULL AFTER `dni`,
			 ADD COLUMN `notify_new_message` BOOLEAN default 1 NOT NULL AFTER `language`,
			 ADD COLUMN `notify_new_file` BOOLEAN default 1  NOT NULL AFTER `notify_new_message`,
			 ADD COLUMN `notify_replace_file` BOOLEAN default 1  NOT NULL AFTER `notify_new_file`,
			 ADD COLUMN `notify_new_area` BOOLEAN default 1  NOT NULL AFTER `notify_replace_file`,
			 ADD COLUMN `notify_new_event` BOOLEAN NOT NULL DEFAULT 1 AFTER `notify_new_area`,
			 ADD COLUMN `notify_new_task` BOOLEAN NOT NULL DEFAULT 1 AFTER `notify_new_event`,
			 ADD COLUMN `notify_new_entry` BOOLEAN NOT NULL DEFAULT 1 AFTER `notify_new_task`,
			 ADD COLUMN `notify_new_news` BOOLEAN NOT NULL DEFAULT 1 AFTER `notify_new_entry`,
			 ADD COLUMN `notify_new_consultation` BOOLEAN NOT NULL DEFAULT 1 AFTER `notify_new_news`,
			 <!---ADD COLUMN `notify_new_link` BOOLEAN NOT NULL DEFAULT 1 AFTER `notify_new_news`,--->
			 ADD COLUMN `image_file` VARCHAR(255) AFTER `notify_new_consultation`,
			 ADD COLUMN `image_type` VARCHAR(45) AFTER `image_file`;
		</cfquery>
		
		<!---Añadir nuevo campo a la tabla de áreas: type--->
		<cfquery datasource="#client_dsn#">	
			ALTER TABLE `#client_abb#_areas` ADD COLUMN `type` VARCHAR(10) AFTER `space_used`;
		</cfquery>
		
		<!---Añadir nuevo campo a la tabla de mensajes: link--->
		<cfquery datasource="#client_dsn#">	
			ALTER TABLE `#client_abb#_messages` ADD COLUMN `link` VARCHAR(1000) NOT NULL AFTER `area_id`;
		</cfquery>
		
		<!---El tipo de dato de la space_used y space_downloaded de usuarios hay que ponerlo como BIG INT (hay que crear un script para esto)--->
		<cfquery datasource="#client_dsn#">
			ALTER TABLE`#client_abb#_users`
				MODIFY COLUMN `space_used` BIGINT UNSIGNED DEFAULT 0,
				MODIFY COLUMN `space_downloaded` BIGINT UNSIGNED DEFAULT 0;
		</cfquery>
		
		
		<!---Nuevas tablas--->
		<cfquery datasource="#client_dsn#">
			CREATE TABLE `#client_abb#_display_types` (
			  `display_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
			  `enabled` tinyint(1) NOT NULL DEFAULT '1',
			  `display_type_title_es` varchar(100) NOT NULL,
			  `display_type_title_en` varchar(100) NOT NULL,
			  PRIMARY KEY (`display_type_id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		</cfquery>
		
		<cfquery datasource="#client_dsn#">
			INSERT INTO `#client_abb#_display_types` (`display_type_id`,`enabled`,`display_type_title_es`,`display_type_title_en`) VALUES
			 (1,1,'Por defecto','By default'),
			 (2,1,'Listado de elementos','Elements list'),
			 (3,1,'Imagen a la derecha','Image to right'),
			 (4,1,'Imagen a la izquierda','Image to left');
		</cfquery>
		<!---, (5,1,'Figura con pie','Image with footnote')--->
		
		
		<cfquery datasource="#client_dsn#">
			CREATE TABLE `#client_abb#_iframes_display_types` (
			  `iframe_display_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
			  `width` int(10) unsigned NOT NULL,
			  `width_unit` varchar(10) NOT NULL,
			  `height` int(10) unsigned NOT NULL,
			  `height_unit` varchar(10) NOT NULL,
			  `enabled` tinyint(1) NOT NULL DEFAULT '1',
			  `iframe_display_type_title_es` varchar(100) NOT NULL,
			  `iframe_display_type_title_en` varchar(100) NOT NULL,
			  PRIMARY KEY (`iframe_display_type_id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;		
		</cfquery>
		
		<cfquery datasource="#client_dsn#">
			INSERT INTO `#client_abb#_iframes_display_types` (`iframe_display_type_id`,`width`,`width_unit`,`height`,`height_unit`,`enabled`,`iframe_display_type_title_es`,`iframe_display_type_title_en`) VALUES
 (1,100,'%',400,'px',1,'Ancho de página x 400','100% x 400px'),
 (2,560,'px',315,'px',1,'560 x 315','560 x 315');
		</cfquery>
		
		
		<cfquery datasource="#client_dsn#">	
			CREATE TABLE `#client_abb#_tasks` (
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
			  `start_date` date NOT NULL,
			  `end_date` date NOT NULL,
			  `recipient_user` int(11) NOT NULL,
			  `done` tinyint(1) NOT NULL,
			  `estimated_value` decimal(12,2) NOT NULL,
			  `real_value` decimal(12,2) NOT NULL,
			  `last_update_date` datetime NOT NULL,
			  PRIMARY KEY (`id`),
			  KEY `user_in_charge` (`user_in_charge`),
			  KEY `attached_file_id` (`attached_file_id`),
			  KEY `area_id` (`area_id`),
			  KEY `FK_#client_abb#_tasks_4` (`attached_image_id`),
			  KEY `FK_#client_abb#_tasks_5` (`recipient_user`),
			  CONSTRAINT `FK_#client_abb#_tasks_4` FOREIGN KEY (`attached_image_id`) REFERENCES `#client_abb#_files` (`id`),
			  CONSTRAINT `FK_#client_abb#_tasks_5` FOREIGN KEY (`recipient_user`) REFERENCES `#client_abb#_users` (`id`),
			  CONSTRAINT `#client_abb#_tasks_ibfk_1` FOREIGN KEY (`user_in_charge`) REFERENCES `#client_abb#_users` (`id`),
			  CONSTRAINT `#client_abb#_tasks_ibfk_2` FOREIGN KEY (`attached_file_id`) REFERENCES `#client_abb#_files` (`id`),
			  CONSTRAINT `#client_abb#_tasks_ibfk_3` FOREIGN KEY (`area_id`) REFERENCES `#client_abb#_areas` (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		</cfquery>
		
		
		<cfquery datasource="#client_dsn#">	
			CREATE TABLE  `#client_abb#_events` (
			  `id` int(11) NOT NULL auto_increment,
			  `title` text collate utf8_unicode_ci,
			  `description` text collate utf8_unicode_ci,
			  `parent_id` int(11) NOT NULL,
			  `parent_kind` varchar(10) collate utf8_unicode_ci default NULL,
			  `user_in_charge` int(11) NOT NULL,
			  `attached_file_name` varchar(255) collate utf8_unicode_ci default NULL,
			  `attached_file_id` int(11) default NULL,
			  `creation_date` datetime NOT NULL,
			  `status` varchar(255) collate utf8_unicode_ci NOT NULL,
			  `area_id` int(11) NOT NULL,
			  `attached_image_name` varchar(255) collate utf8_unicode_ci default NULL,
			  `attached_image_id` int(11) default NULL,
			  `link` varchar(1000) collate utf8_unicode_ci NOT NULL,
			  `start_date` date NOT NULL,
			  `end_date` date NOT NULL,
			  `place` varchar(255) collate utf8_unicode_ci NOT NULL,
			  `last_update_date` datetime default NULL,
			  `start_time` time NOT NULL,
			  `end_time` time NOT NULL,
			  `iframe_url` varchar(1000) collate utf8_unicode_ci NOT NULL,
			  `iframe_display_type_id` int(10) unsigned NOT NULL default '1',
			  PRIMARY KEY  (`id`),
			  KEY `user_in_charge` (`user_in_charge`),
			  KEY `attached_file_id` (`attached_file_id`),
			  KEY `area_id` (`area_id`),
			  KEY `FK_#client_abb#_events_4` (`attached_image_id`),
			  KEY `FK_#client_abb#_events_5` (`iframe_display_type_id`),
			  CONSTRAINT `FK_#client_abb#_events_5` FOREIGN KEY (`iframe_display_type_id`) REFERENCES `#client_abb#_iframes_display_types` (`iframe_display_type_id`),
			  CONSTRAINT `#client_abb#_events_ibfk_1` FOREIGN KEY (`user_in_charge`) REFERENCES `#client_abb#_users` (`id`),
			  CONSTRAINT `#client_abb#_events_ibfk_2` FOREIGN KEY (`attached_file_id`) REFERENCES `#client_abb#_files` (`id`),
			  CONSTRAINT `#client_abb#_events_ibfk_3` FOREIGN KEY (`area_id`) REFERENCES `#client_abb#_areas` (`id`),
			  CONSTRAINT `FK_#client_abb#_events_4` FOREIGN KEY (`attached_image_id`) REFERENCES `#client_abb#_files` (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		</cfquery>
		
		
		<cfquery datasource="#client_dsn#">
			CREATE TABLE  `#client_abb#_news` (
			  `id` int(11) NOT NULL auto_increment,
			  `title` text collate utf8_unicode_ci,
			  `description` text collate utf8_unicode_ci,
			  `parent_id` int(11) NOT NULL,
			  `parent_kind` varchar(10) collate utf8_unicode_ci default NULL,
			  `user_in_charge` int(11) NOT NULL,
			  `attached_file_name` varchar(255) collate utf8_unicode_ci default NULL,
			  `attached_file_id` int(11) default NULL,
			  `creation_date` datetime NOT NULL,
			  `status` varchar(255) collate utf8_unicode_ci NOT NULL,
			  `area_id` int(11) NOT NULL,
			  `attached_image_name` varchar(255) collate utf8_unicode_ci default NULL,
			  `attached_image_id` int(11) default NULL,
			  `link` varchar(1000) collate utf8_unicode_ci NOT NULL,
			  `last_update_date` datetime default NULL,
			  `iframe_url` varchar(1000) collate utf8_unicode_ci NOT NULL,
			  `iframe_display_type_id` int(10) unsigned NOT NULL default '1',
			  `position` int(10) unsigned NOT NULL,
			  PRIMARY KEY  (`id`),
			  KEY `user_in_charge` (`user_in_charge`),
			  KEY `attached_file_id` (`attached_file_id`),
			  KEY `area_id` (`area_id`),
			  KEY `FK_#client_abb#_news_4` (`attached_image_id`),
			  KEY `FK_#client_abb#_news_5` (`iframe_display_type_id`),
			  CONSTRAINT `FK_#client_abb#_news_5` FOREIGN KEY (`iframe_display_type_id`) REFERENCES `#client_abb#_iframes_display_types` (`iframe_display_type_id`),
			  CONSTRAINT `#client_abb#_news_ibfk_1` FOREIGN KEY (`user_in_charge`) REFERENCES `#client_abb#_users` (`id`),
			  CONSTRAINT `#client_abb#_news_ibfk_2` FOREIGN KEY (`attached_file_id`) REFERENCES `#client_abb#_files` (`id`),
			  CONSTRAINT `#client_abb#_news_ibfk_3` FOREIGN KEY (`area_id`) REFERENCES `#client_abb#_areas` (`id`),
			  CONSTRAINT `FK_#client_abb#_news_4` FOREIGN KEY (`attached_image_id`) REFERENCES `#client_abb#_files` (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		</cfquery>	
		
		
		<cfquery datasource="#client_dsn#">
			CREATE TABLE `#client_abb#_consultations` (
			  `id` int(10) unsigned NOT NULL auto_increment,
			  `title` text collate utf8_unicode_ci,
			  `description` text collate utf8_unicode_ci,
			  `parent_id` int(11) NOT NULL,
			  `parent_kind` varchar(15) collate utf8_unicode_ci default NULL,
			  `user_in_charge` int(11) NOT NULL,
			  `attached_file_name` varchar(255) collate utf8_unicode_ci default NULL,
			  `attached_file_id` int(11) default NULL,
			  `creation_date` datetime NOT NULL,
			  `status` varchar(45) collate utf8_unicode_ci NOT NULL,
			  `area_id` int(11) NOT NULL,
			  `attached_image_name` varchar(255) collate utf8_unicode_ci default NULL,
			  `attached_image_id` int(11) default NULL,
			  `link` varchar(255) collate utf8_unicode_ci NOT NULL,
			  `last_update_date` datetime NOT NULL,
			  `read_date` datetime default NULL,
			  `answer_date` datetime default NULL,
			  `close_date` datetime default NULL,
			  `state` varchar(10) collate utf8_unicode_ci NOT NULL,
			  `identifier` varchar(100) collate utf8_unicode_ci NOT NULL,
			  PRIMARY KEY  (`id`),
			  KEY `user_in_charge` (`user_in_charge`),
			  KEY `attached_file_id` (`attached_file_id`),
			  KEY `area_id` (`area_id`),
			  KEY `FK_#client_abb#_consultations_4` (`attached_image_id`),
			  CONSTRAINT `FK_#client_abb#_consultations_4` FOREIGN KEY (`attached_image_id`) REFERENCES `#client_abb#_files` (`id`),
			  CONSTRAINT `#client_abb#_consultations_ibfk_1` FOREIGN KEY (`user_in_charge`) REFERENCES `#client_abb#_users` (`id`),
			  CONSTRAINT `#client_abb#_consultations_ibfk_2` FOREIGN KEY (`attached_file_id`) REFERENCES `#client_abb#_files` (`id`),
			  CONSTRAINT `#client_abb#_consultations_ibfk_3` FOREIGN KEY (`area_id`) REFERENCES `#client_abb#_areas` (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		</cfquery>

		<cfquery datasource="#client_dsn#">
			CREATE TABLE  `#client_abb#_consultations_readings` (
			  `consultation_id` int(10) unsigned NOT NULL,
			  `user_id` int(11) NOT NULL,
			  `date` datetime NOT NULL,
			  KEY `FK_#client_abb#_consultations_readings_consultations` (`consultation_id`),
			  KEY `FK_#client_abb#_consultations_readings_users` (`user_id`),
			  CONSTRAINT `FK_#client_abb#_consultations_readings_consultations` FOREIGN KEY (`consultation_id`) REFERENCES `#client_abb#_consultations` (`id`) ON DELETE CASCADE,
			  CONSTRAINT `FK_#client_abb#_consultations_readings_users` FOREIGN KEY (`user_id`) REFERENCES `#client_abb#_users` (`id`) ON DELETE CASCADE
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		</cfquery>
		
		<!---ENTRADAS--->
		
		
		<cfquery datasource="#client_dsn#">
			CREATE TABLE  `#client_abb#_entries` (
			  `id` int(11) NOT NULL auto_increment,
			  `title` text collate utf8_unicode_ci,
			  `description` text collate utf8_unicode_ci,
			  `parent_id` int(11) NOT NULL,
			  `parent_kind` varchar(10) collate utf8_unicode_ci default NULL,
			  `user_in_charge` int(11) NOT NULL,
			  `attached_file_name` varchar(255) collate utf8_unicode_ci default NULL,
			  `attached_file_id` int(11) default NULL,
			  `creation_date` datetime NOT NULL,
			  `status` varchar(255) collate utf8_unicode_ci NOT NULL,
			  `area_id` int(11) NOT NULL,
			  `attached_image_name` varchar(255) collate utf8_unicode_ci default NULL,
			  `attached_image_id` int(11) default NULL,
			  `link` varchar(1000) collate utf8_unicode_ci NOT NULL,
			  `last_update_date` datetime default NULL,
			  `position` int(10) unsigned NOT NULL,
			  `display_type_id` int(10) unsigned NOT NULL default '1',
			  `iframe_url` varchar(1000) collate utf8_unicode_ci NOT NULL,
			  `iframe_display_type_id` int(10) unsigned NOT NULL default '1',
			  PRIMARY KEY  (`id`),
			  KEY `user_in_charge` (`user_in_charge`),
			  KEY `attached_file_id` (`attached_file_id`),
			  KEY `area_id` (`area_id`),
			  KEY `FK_#client_abb#_entries_4` (`attached_image_id`),
			  KEY `FK_#client_abb#_entries_5` (`iframe_display_type_id`),
			  KEY `FK_#client_abb#_entries_6` (`display_type_id`),
			  CONSTRAINT `FK_#client_abb#_entries_6` FOREIGN KEY (`display_type_id`) REFERENCES `#client_abb#_display_types` (`display_type_id`),
			  CONSTRAINT `#client_abb#_entries_ibfk_1` FOREIGN KEY (`user_in_charge`) REFERENCES `#client_abb#_users` (`id`),
			  CONSTRAINT `#client_abb#_entries_ibfk_2` FOREIGN KEY (`attached_file_id`) REFERENCES `#client_abb#_files` (`id`),
			  CONSTRAINT `#client_abb#_entries_ibfk_3` FOREIGN KEY (`area_id`) REFERENCES `#client_abb#_areas` (`id`),
			  CONSTRAINT `FK_#client_abb#_entries_4` FOREIGN KEY (`attached_image_id`) REFERENCES `#client_abb#_files` (`id`),
			  CONSTRAINT `FK_#client_abb#_entries_5` FOREIGN KEY (`iframe_display_type_id`) REFERENCES `#client_abb#_iframes_display_types` (`iframe_display_type_id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		</cfquery>
		
		
	</cftransaction>
	
	-Realizadas modificaciones GENERALES de la base de datos.<br/>
	
	
	<!---Añadir un área raiz (que no será visible) que será la padre del área raiz actual.--->
	<cfquery datasource="#client_dsn#" name="getRootArea">
		SELECT *
		FROM #client_abb#_areas
		WHERE id = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
		AND parent_id IS NULL;
	</cfquery>
	
	<cfif getRootArea.recordCount IS 0>
		<cfthrow message="Error al obtener el área raiz">
	</cfif>
	
	<cftransaction>
	
		<cfquery datasource="#client_dsn#" name="insertNewRootArea">
			INSERT INTO #client_abb#_areas (name, parent_id, user_in_charge, creation_date, description) 
			VALUES (
				<cfqueryparam value="#getRootArea.name#" cfsqltype="cf_sql_varchar">,			
				NULL,				
				<cfqueryparam value="#getRootArea.user_in_charge#" cfsqltype="cf_sql_integer">,			
				NOW(),
				<cfqueryparam value="" cfsqltype="cf_sql_varchar">
				);	 
		</cfquery>
	
		<cfquery name="getLastInsertId" datasource="#client_dsn#">
			SELECT LAST_INSERT_ID() AS last_insert_id FROM #client_abb#_areas;
		</cfquery>
		
	</cftransaction>
	
	<cfset new_root_area_id = getLastInsertId.last_insert_id>
	
	<cfquery name="parentIdQuery" datasource="#client_dsn#">
		UPDATE #client_abb#_areas SET parent_id = <cfqueryparam value="#new_root_area_id#" cfsqltype="cf_sql_integer">
		WHERE id = <cfqueryparam value="#getRootArea.id#" cfsqltype="cf_sql_integer">;
	</cfquery>
	
	-Añadida nueva área raiz.<br/>
	
	
	<!---Copiar las preferencias--->
	
	<cfquery datasource="#client_dsn#" name="getUsersPreferences">
		SELECT *
		FROM #client_abb#_user_preferences;
	</cfquery>
	
	<cfloop query="getUsersPreferences">
		
		<cfquery datasource="#client_dsn#">
			UPDATE #client_abb#_users
			SET language = <cfqueryparam value="#getUsersPreferences.language#" cfsqltype="cf_sql_varchar">,
			notify_new_message = <cfqueryparam value="#getUsersPreferences.notify_new_message#" cfsqltype="cf_sql_bit">,
			notify_new_file = <cfqueryparam value="#getUsersPreferences.notify_new_file#" cfsqltype="cf_sql_bit">,
			notify_replace_file = <cfqueryparam value="#getUsersPreferences.notify_replace_file#" cfsqltype="cf_sql_bit">,
			notify_new_area = <cfqueryparam value="#getUsersPreferences.notify_new_area#" cfsqltype="cf_sql_bit">
			WHERE id = <cfqueryparam value="#getUsersPreferences.user_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
					
	</cfloop>
	
	-Copiadas preferencias a tabla de preferencias.<br/>
	
	
	<cftransaction>
	
		<cfquery datasource="#client_dsn#">
			ALTER TABLE `#client_abb#_user_preferences` RENAME TO `#client_abb#_user_preferences_NO_USADA`;
		</cfquery>
		
		-Modificada tabla user_preferences a NO USADA.<br/>
		
		<cfquery datasource="#client_dsn#">
			ALTER TABLE `#client_abb#_user_images` RENAME TO `#client_abb#_user_images_NO_USADA`;
		</cfquery>
	
		-Modificada tabla user_images a NO USADA.<br/>
		
	</cftransaction>


	Modificaciones terminadas.<br/>
</cfif>
<br/>
<cfform method="post" action="#CGI.SCRIPT_NAME#">
	<label>Client Abb</label>
	<cfinput type="text" name="abb" value="" required="yes" message="Client ID requerido">
	<cfinput type="submit" name="migrate" value="MIGRAR">
</cfform>

</body>
</html>

</cfif>
