<cfset version_id = "3.0.1">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp301">
		SELECT * 
		FROM information_schema.COLUMNS 
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#' 
		AND TABLE_NAME = '#new_client_abb#_files' 
		AND COLUMN_NAME = 'public';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp301.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>
	
<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `dp_#new_client_abb#`.`#new_client_abb#_files` 
			ADD COLUMN `public` TINYINT(1) NOT NULL DEFAULT 0 AFTER `anti_virus_check_result`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `dp_#new_client_abb#`.`#new_client_abb#_files` 
			ADD COLUMN `file_public_id` VARCHAR(100) NULL AFTER `public`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `dp_#new_client_abb#`.`#new_client_abb#_files` 
			ADD UNIQUE INDEX `file_public_id_UNIQUE` (`file_public_id` ASC);
		</cfquery>

		<!--- Falta cambiar esto en el resto de DPs de Era7 Bioinfo--->
		<cfquery datasource="#client_datasource#">
			ALTER TABLE `dp_#new_client_abb#`.`#new_client_abb#_dp_documents` 
			CHANGE COLUMN `description` `description` LONGTEXT CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci' NOT NULL ;
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

	IMPORTANTE: la versión anterior a esta (3.0) requiere este cambio en doplanning_app

	ALTER TABLE `doplanning_app`.`app_clients` 
	ADD COLUMN `app_title` VARCHAR(100) NOT NULL DEFAULT 'DoPlanning' AFTER `name`;

--->