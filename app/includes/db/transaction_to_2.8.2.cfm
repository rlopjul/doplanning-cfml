<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp282">
		SHOW TABLES LIKE '#new_client_abb#_virus_logs';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp282.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión 2.8.2<br/><br/>
	</cfoutput>
	
<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión 2.8.2<br/>
	</cfoutput>

	<!---Modificaciones de la base de datos--->
	<cftransaction>
		
		<cfquery datasource="#client_datasource#">	
			ALTER TABLE `#new_client_abb#_files` 
				ADD COLUMN `anti_virus_check` TINYINT UNSIGNED NULL AFTER `publication_scope_id`,
				ADD COLUMN `anti_virus_check_result` VARCHAR(255) NULL AFTER `anti_virus_check`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			CREATE TABLE `#new_client_abb#_virus_logs` (
			  `virus_log_id` bigint(20) NOT NULL AUTO_INCREMENT,
			  `user_id` int(11) NOT NULL,
			  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
			  `file_id` int(11) NULL,
			  `file_type_id` int(10) unsigned NULL,
			  `file_name` varchar(255) COLLATE utf8_unicode_ci NULL,
			  `anti_virus_result` VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
			  PRIMARY KEY (`virus_log_id`),
			  KEY `user_id` (`user_id`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
 		</cfquery>
			
	</cftransaction>

	<cfoutput>
		#new_client_abb# migrado a versión 2.8.2<br/><br/>
	</cfoutput>

</cfif>