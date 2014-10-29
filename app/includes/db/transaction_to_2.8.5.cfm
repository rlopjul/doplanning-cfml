<cfset version_id = "2.8.5">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp285">
		SHOW TABLES LIKE '#new_client_abb#_areas_tree_cache';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp285.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>
	
<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>
		
		<!---Modificaciones de la base de datos--->
		<cftransaction>
			
			<cfquery datasource="#client_datasource#">
				ALTER TABLE `#new_client_abb#_areas` 
				ADD COLUMN `version_tree` BIGINT NULL DEFAULT 0 AFTER `default_typology_id`;
			</cfquery>

			<cfquery datasource="#client_datasource#">
				CREATE TABLE `#new_client_abb#_areas_tree_cache` (
				  `user_id` int(11) NOT NULL,
				  `area_id` int(11) NOT NULL,
				  `tree_type` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
				  `version` bigint(20) NOT NULL,
				  `cache_content` longtext COLLATE utf8_unicode_ci NOT NULL,
				  PRIMARY KEY (`user_id`,`area_id`,`tree_type`),
				  KEY `FK_#new_client_abb#_areas_tree_cache_areas_idx` (`area_id`),
				  CONSTRAINT `FK_#new_client_abb#_areas_tree_cache_areas` FOREIGN KEY (`area_id`) REFERENCES `#new_client_abb#_areas` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
				  CONSTRAINT `FK_#new_client_abb#_areas_tree_cache_users` FOREIGN KEY (`user_id`) REFERENCES `#new_client_abb#_users` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
				) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			</cfquery>

		</cftransaction>

		<cfoutput>
			#new_client_abb# migrado a versión #version_id#<br/><br/>
		</cfoutput>

		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput> 
		</cfcatch>

	</cftry>


</cfif>