<cfset version_id = "2.10">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp210">
		SELECT * 
		FROM information_schema.COLUMNS 
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#' 
		AND TABLE_NAME = '#new_client_abb#_items_deleted' 
		AND COLUMN_NAME = 'item_id';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp210.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>
	
<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_items_deleted` (
			  `item_id` int(11) NOT NULL,
			  `item_type_id` int(10) unsigned NOT NULL,
			  `delete_area_id` int(11) NOT NULL,
			  `delete_user_id` int(11) NOT NULL,
			  `delete_date` datetime NOT NULL,
			  `in_bin` tinyint(1) unsigned NOT NULL DEFAULT '1',
			  `final_delete_date` datetime DEFAULT NULL,
			  `final_delete_status` varchar(45) DEFAULT NULL,
			  `final_delete_error_message` text,
			  `final_delete_error_detail` text,
			  PRIMARY KEY (`item_id`,`item_type_id`),
			  KEY `FK_#new_client_abb#_items_deleted_1` (`delete_area_id`),
			  KEY `FK_#new_client_abb#_items_deleted_2_idx` (`delete_user_id`),
			  CONSTRAINT `FK_#new_client_abb#_items_deleted_1` FOREIGN KEY (`delete_area_id`) REFERENCES `#new_client_abb#_areas` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
			  CONSTRAINT `FK_#new_client_abb#_items_deleted_2` FOREIGN KEY (`delete_user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			UPDATE `#new_client_abb#_tables_fields_types` SET `mysql_type`='TEXT', `cf_sql_type`='cf_sql_longvarchar' WHERE `field_type_id`='15';
		</cfquery>

		<cfquery datasource="#client_datasource#">
			UPDATE `#new_client_abb#_tables_fields_types` SET `mysql_type`='TEXT', `cf_sql_type`='cf_sql_longvarchar' WHERE `field_type_id`='16';
		</cfquery>

		
		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput> 
		</cfcatch>

	</cftry>


</cfif>

<!---

	IMPORTANTE: esta versión requiere los siguientes campos en la base de datos y DAR PERMISO DE ACCESO A LOS USUARIOS MySQL a la base de datos doplanning_app

	ALTER TABLE `doplanning_app`.`app_clients` 
	ADD COLUMN `bin_enabled` TINYINT(1) NULL DEFAULT 0 AFTER `tasks_reminder_days`,
	ADD COLUMN `bin_days` INT(10) NULL DEFAULT '30' AFTER `bin_enabled`;

--->