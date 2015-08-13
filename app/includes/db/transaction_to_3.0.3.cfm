<cfset version_id = "3.0.3">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp303">
		SELECT * 
		FROM information_schema.COLUMNS 
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#' 
		AND TABLE_NAME = '#new_client_abb#_files_downloads';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp303.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>
	
<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_items_deleted` 
			DROP PRIMARY KEY,
			ADD PRIMARY KEY (`item_id`, `item_type_id`, `delete_date`);
		</cfquery>

		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_files_downloads` (
			  `file_id` int(11) NOT NULL,
			  `user_id` int(11) DEFAULT NULL,
			  `download_date` datetime NOT NULL,
			  `area_id` int(11) DEFAULT NULL,
			  `file_size` int(11) NOT NULL,
			  PRIMARY KEY (`file_id`,`download_date`),
			  KEY `FK_#new_client_abb#_files_downloads_2_idx` (`user_id`),
			  KEY `FK_#new_client_abb#_files_downloads_3_idx` (`area_id`),
			  CONSTRAINT `FK_#new_client_abb#_files_downloads_1` FOREIGN KEY (`file_id`) REFERENCES `#new_client_abb#_files` (`id`) ON DELETE CASCADE,
			  CONSTRAINT `FK_#new_client_abb#_files_downloads_2` FOREIGN KEY (`user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
			  CONSTRAINT `FK_#new_client_abb#_files_downloads_3` FOREIGN KEY (`area_id`) REFERENCES `#new_client_abb#_areas` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_files` 
			ADD COLUMN `item_id` INT(11) NULL DEFAULT NULL AFTER `file_public_id`,
			ADD COLUMN `item_type_id` INT(11) NULL DEFAULT NULL AFTER `item_id`;
		</cfquery>

		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput> 
		</cfcatch>

	</cftry>


</cfif>