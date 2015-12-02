<cfset version_id = "3.3">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp33">
		SELECT *
		FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#'
		AND TABLE_NAME = '#new_client_abb#_lists_searchs_fields'
		AND COLUMN_NAME = 'search_value';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp33.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>

<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>


		<!--- table special categories --->

		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_tables_special_categories` (
			`category_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
			`table_id` int(11) unsigned NOT NULL,
			`table_type_id` int(11) unsigned NOT NULL,
			`title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
			`value` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
			`field_id` int(10) unsigned DEFAULT NULL,
			PRIMARY KEY (`category_id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_users_notifications_tables_special_categories_disabled` (
			`user_id` int(11) NOT NULL,
			`table_id` int(10) unsigned NOT NULL,
			`table_type_id` int(10) unsigned NOT NULL,
			`category_id` int(11) unsigned NOT NULL,
			PRIMARY KEY (`user_id`,`table_id`,`table_type_id`,`category_id`),
			KEY `FK_#new_client_abb#_users_notifications_special_categories_disabled_idx` (`category_id`),
			CONSTRAINT `FK_#new_client_abb#_users_notifications_special_categories_disabled_2` FOREIGN KEY (`category_id`) REFERENCES `#new_client_abb#_tables_special_categories` (`category_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
			CONSTRAINT `FK_#new_client_abb#_users_notifications_special_categories_disabled_1` FOREIGN KEY (`user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		</cfquery>


		<!--- list searchs --->

		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_lists_searchs` (
			`id` int(11) unsigned NOT NULL AUTO_INCREMENT,
			`title` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
			`description` text COLLATE utf8_unicode_ci,
			`table_id` int(10) unsigned NOT NULL,
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
			`last_update_user_id` int(11) DEFAULT NULL,
			`last_update_type` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
			`list_rows_by_default` tinyint(1) NOT NULL DEFAULT '1',
			PRIMARY KEY (`id`) USING BTREE,
			KEY `FK_#new_client_abb#_lists_searchs_1` (`user_in_charge`),
			KEY `FK_#new_client_abb#_lists_searchs_2` (`area_id`),
			KEY `FK_#new_client_abb#_lists_searchs_3` (`attached_file_id`),
			KEY `FK_#new_client_abb#_lists_searchs_4` (`attached_image_id`),
			KEY `FK_#new_client_abb#_lists_searchs_7_idx` (`last_update_user_id`),
			KEY `FK_#new_client_abb#_lists_searchs_7_idx1` (`table_id`),
			CONSTRAINT `FK_#new_client_abb#_lists_searchs_1` FOREIGN KEY (`user_in_charge`) REFERENCES `#new_client_abb#_users` (`id`),
			CONSTRAINT `FK_#new_client_abb#_lists_searchs_2` FOREIGN KEY (`area_id`) REFERENCES `#new_client_abb#_areas` (`id`),
			CONSTRAINT `FK_#new_client_abb#_lists_searchs_3` FOREIGN KEY (`attached_file_id`) REFERENCES `#new_client_abb#_files` (`id`),
			CONSTRAINT `FK_#new_client_abb#_lists_searchs_4` FOREIGN KEY (`attached_image_id`) REFERENCES `#new_client_abb#_files` (`id`),
			CONSTRAINT `FK_#new_client_abb#_lists_searchs_6` FOREIGN KEY (`last_update_user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
			CONSTRAINT `FK_#new_client_abb#_lists_searchs_7` FOREIGN KEY (`table_id`) REFERENCES `#new_client_abb#_lists` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_lists_searchs_fields` (
			`search_field_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
			`search_id` int(11) unsigned NOT NULL,
			`table_id` int(10) unsigned NOT NULL,
			`field_id` int(10) unsigned NOT NULL,
			`search_value` varchar(255) NOT NULL,
			PRIMARY KEY (`search_field_id`),
			KEY `FK_#new_client_abb#_lists_searchs_fields_1` (`search_id`),
			KEY `FK_#new_client_abb#_lists_searchs_fields_2` (`table_id`),
			KEY `FK_#new_client_abb#_lists_searchs_fields_3_idx` (`field_id`),
			KEY `UNIQUE` (`field_id`,`table_id`,`search_id`),
			CONSTRAINT `FK_#new_client_abb#_lists_searchs_fields_1` FOREIGN KEY (`search_id`) REFERENCES `#new_client_abb#_lists_searchs` (`id`),
			CONSTRAINT `FK_#new_client_abb#_lists_searchs_fields_2` FOREIGN KEY (`table_id`) REFERENCES `#new_client_abb#_lists` (`id`),
			CONSTRAINT `FK_#new_client_abb#_lists_searchs_fields_3` FOREIGN KEY (`field_id`) REFERENCES `#new_client_abb#_lists_fields` (`field_id`) ON DELETE CASCADE ON UPDATE NO ACTION
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		</cfquery>


		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput>
		</cfcatch>

	</cftry>


</cfif>
