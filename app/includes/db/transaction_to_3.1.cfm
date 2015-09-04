<cfset version_id = "3.1">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp31">
		SELECT *
		FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#'
		AND TABLE_NAME = '#new_client_abb#_users_notifications_categories_disabled';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp31.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>

<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_areas_users`
			ADD COLUMN `association_date` DATETIME NULL DEFAULT NULL AFTER `user_id`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users`
			ADD COLUMN `no_notifications` TINYINT(1) NOT NULL DEFAULT 0 AFTER `notify_app_features`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users`
			ADD COLUMN `notifications_digest_type_id` INT(11) NULL AFTER `no_notifications`,
			ADD COLUMN `notifications_last_digest_date` DATETIME NULL AFTER `notifications_digest_type_id`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_users`
			ADD COLUMN `notifications_web_digest_type_id` INT(11) NULL DEFAULT NULL AFTER `notifications_last_digest_date`,
			ADD COLUMN `notifications_web_last_digest_date` DATETIME NULL DEFAULT NULL AFTER `notifications_web_digest_type_id`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_items_categories` (
		  `item_id` int(11) NOT NULL,
		  `item_type_id` int(10) unsigned NOT NULL,
		  `area_id` int(11) NOT NULL,
		  PRIMARY KEY (`item_id`,`item_type_id`,`area_id`) USING BTREE,
		  KEY `FK_#new_client_abb#_items_categories_1` (`area_id`),
		  CONSTRAINT `FK_#new_client_abb#_items_categories_1` FOREIGN KEY (`area_id`) REFERENCES `#new_client_abb#_areas` (`id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_items_types` (
			`item_type_id` int(10) unsigned NOT NULL,
			`enabled` tinyint(1) unsigned NOT NULL DEFAULT '1',
			`category_area_id` int(11) NOT NULL,
			PRIMARY KEY (`item_type_id`),
			KEY `FK_#new_client_abb#_items_types_1_idx` (`category_area_id`),
			CONSTRAINT `FK_#new_client_abb#_items_types_1` FOREIGN KEY (`category_area_id`) REFERENCES `#new_client_abb#_areas` (`id`) ON UPDATE NO ACTION
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_users_notifications_categories_disabled` (
			  `user_id` int(11) NOT NULL,
			  `item_type_id` int(10) unsigned NOT NULL,
			  `area_id` int(11) NOT NULL,
			  PRIMARY KEY (`user_id`,`item_type_id`,`area_id`),
			  CONSTRAINT `FK_#new_client_abb#_users_notifications_categories_disabled_1` FOREIGN KEY (`user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
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
