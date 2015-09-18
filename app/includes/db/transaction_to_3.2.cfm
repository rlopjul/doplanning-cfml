<cfset version_id = "3.2">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp32">
		SELECT *
		FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#'
		AND TABLE_NAME = '#new_client_abb#_mailings';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp32.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>

<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>


		<cfquery datasource="#client_datasource#">
			INSERT INTO `#new_client_abb#_tables_fields_types` (`field_type_id`, `field_type_group`, `input_type`, `name`, `max_length`, `mysql_type`, `cf_sql_type`, `enabled`, `position`) VALUES ('18', 'file', 'file', 'Archivo adjunto', '11', 'INT(11)', 'cf_sql_integer', '1', '18');
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_virus_logs`
			CHANGE COLUMN `user_id` `user_id` INT(11) NULL ;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_files`
			ADD COLUMN `row_id` INT(20) NULL AFTER `item_type_id`,
			ADD COLUMN `field_id` INT(10) NULL AFTER `row_id`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_files`
			DROP FOREIGN KEY `#new_client_abb#_files_ibfk_1`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_files`
			CHANGE COLUMN `user_in_charge` `user_in_charge` INT(11) NULL ;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_files`
			ADD CONSTRAINT `#new_client_abb#_files_ibfk_1`
		  	FOREIGN KEY (`user_in_charge`)
		  	REFERENCES `#new_client_abb#_users` (`id`);
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_lists`
			ADD COLUMN `last_update_type` VARCHAR(45) NULL AFTER `last_update_user_id`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_forms`
			ADD COLUMN `last_update_type` VARCHAR(45) NULL AFTER `last_update_user_id`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_typologies`
			ADD COLUMN `last_update_type` VARCHAR(45) NULL AFTER `last_update_user_id`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users_typologies`
			ADD COLUMN `last_update_type` VARCHAR(45) NULL AFTER `last_update_user_id`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users`
			ADD COLUMN `last_update_date` DATETIME NULL AFTER `typology_row_id`,
			ADD COLUMN `last_update_user_id` INT(11) NULL AFTER `last_update_date`,
			ADD COLUMN `last_update_type` VARCHAR(45) NULL AFTER `last_update_user_id`,
			ADD INDEX `#new_client_abb#_users_ibfk_3_idx` (`last_update_user_id` ASC);
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users`
			ADD CONSTRAINT `#new_client_abb#_users_ibfk_3`
			  FOREIGN KEY (`last_update_user_id`)
			  REFERENCES `#new_client_abb#_users` (`id`)
			  ON DELETE NO ACTION
			  ON UPDATE NO ACTION;
		</cfquery>


		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users`
			ADD COLUMN `start_page` VARCHAR(45) NULL AFTER `information`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users`
			ADD COLUMN `start_page_locked` TINYINT(1) NOT NULL DEFAULT 0 AFTER `start_page`;
		</cfquery>


		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users`
			CHANGE COLUMN `space_used` `space_used` BIGINT(20) NULL DEFAULT '0' ;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_areas`
			ADD COLUMN `item_type_17_enabled` TINYINT(1) NOT NULL DEFAULT 0 AFTER `item_type_16_enabled`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users`
			ADD COLUMN `notify_new_dp_document` TINYINT(1) NOT NULL DEFAULT 1 AFTER `notify_new_typology`,
			ADD COLUMN `notify_new_mailing` TINYINT(1) NOT NULL DEFAULT '1' AFTER `notify_new_dp_document`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_files`
			ADD COLUMN `thumbnail` TINYINT(1) NOT NULL DEFAULT 0 AFTER `field_id`,
			ADD COLUMN `thumbnail_format` VARCHAR(45) NULL AFTER `thumbnail`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_mailings_templates` (
			  `template_id` int(11) NOT NULL,
			  `title` varchar(255) CHARACTER SET latin1 NOT NULL,
			  `head_content` text CHARACTER SET latin1 NOT NULL,
			  `foot_content` text CHARACTER SET latin1 NOT NULL,
			  `content_styles` varchar(1000) COLLATE utf8_unicode_ci NOT NULL,
			  `creation_user_id` int(11) DEFAULT NULL,
			  `last_update_user_id` int(11) DEFAULT NULL,
			  `creation_date` datetime NOT NULL,
			  `last_update_date` datetime DEFAULT NULL,
			  `position` int(11) NOT NULL,
			  PRIMARY KEY (`template_id`),
			  KEY `FK_#new_client_abb#_mailings_1_idx` (`creation_user_id`),
			  KEY `FK_#new_client_abb#_mailings_2_idx` (`last_update_user_id`),
			  CONSTRAINT `FK_#new_client_abb#_mailings_templates_1` FOREIGN KEY (`creation_user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE SET NULL ON UPDATE SET NULL,
			  CONSTRAINT `FK_#new_client_abb#_mailings_templates_2` FOREIGN KEY (`last_update_user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE SET NULL ON UPDATE SET NULL
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_mailings` (
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
			  `link` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
			  `link_target` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
			  `last_update_date` datetime DEFAULT NULL,
			  `enabled` tinyint(1) DEFAULT '0',
			  `structure_available` tinyint(1) NOT NULL DEFAULT '0',
			  `general` tinyint(1) NOT NULL DEFAULT '0',
			  `publication_scope_id` int(10) unsigned DEFAULT NULL,
			  `publication_date` datetime DEFAULT NULL,
			  `publication_validated` tinyint(1) DEFAULT NULL,
			  `publication_validated_user` int(11) DEFAULT NULL,
			  `publication_validated_date` datetime DEFAULT NULL,
			  `last_update_user_id` int(11) DEFAULT NULL,
			  `last_update_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
			  `state` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
			  `email_addresses` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
			  `template_id` int(11) DEFAULT NULL,
			  `head_content` text COLLATE utf8_unicode_ci NOT NULL,
			  `foot_content` text COLLATE utf8_unicode_ci NOT NULL,
			  `content_styles` varchar(1000) COLLATE utf8_unicode_ci NOT NULL,
			  PRIMARY KEY (`id`) USING BTREE,
			  KEY `FK_#new_client_abb#_mailings_1` (`user_in_charge`),
			  KEY `FK_#new_client_abb#_mailings_2` (`area_id`),
			  KEY `FK_#new_client_abb#_mailings_3` (`attached_file_id`),
			  KEY `FK_#new_client_abb#_mailings_4` (`attached_image_id`),
			  KEY `FK_#new_client_abb#_mailings_5` (`publication_scope_id`),
			  KEY `FK_#new_client_abb#_mailings_7_idx` (`last_update_user_id`),
			  KEY `FK_#new_client_abb#_mailings_7_idx1` (`template_id`),
			  CONSTRAINT `FK_#new_client_abb#_mailings_1` FOREIGN KEY (`user_in_charge`) REFERENCES `#new_client_abb#_users` (`id`),
			  CONSTRAINT `FK_#new_client_abb#_mailings_2` FOREIGN KEY (`area_id`) REFERENCES `#new_client_abb#_areas` (`id`),
			  CONSTRAINT `FK_#new_client_abb#_mailings_3` FOREIGN KEY (`attached_file_id`) REFERENCES `#new_client_abb#_files` (`id`),
			  CONSTRAINT `FK_#new_client_abb#_mailings_4` FOREIGN KEY (`attached_image_id`) REFERENCES `#new_client_abb#_files` (`id`),
			  CONSTRAINT `FK_#new_client_abb#_mailings_5` FOREIGN KEY (`publication_scope_id`) REFERENCES `#new_client_abb#_scopes` (`scope_id`),
			  CONSTRAINT `FK_#new_client_abb#_mailings_6` FOREIGN KEY (`last_update_user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
			  CONSTRAINT `FK_#new_client_abb#_mailings_7` FOREIGN KEY (`template_id`) REFERENCES `#new_client_abb#_mailings_templates` (`template_id`) ON DELETE SET NULL ON UPDATE SET NULL
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		</cfquery>



		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput>
		</cfcatch>

	</cftry>


</cfif>
