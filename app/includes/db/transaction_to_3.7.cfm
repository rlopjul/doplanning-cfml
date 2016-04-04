<cfset version_id = "3.7">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp37">
		SELECT *
		FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#'
		AND TABLE_NAME = '#new_client_abb#_users'
		AND COLUMN_NAME = 'area_admin_administrator';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp37.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>

<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

    <!--- Fix bug deleting typology related to area --->

		<cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_areas`
        DROP FOREIGN KEY `FK_#new_client_abb#_areas_5`;
		</cfquery>

    <cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_areas`
        ADD CONSTRAINT `FK_#new_client_abb#_areas_5`
        FOREIGN KEY (`default_typology_id`)
        REFERENCES `#new_client_abb#_typologies` (`id`)
        ON DELETE SET NULL;
		</cfquery>

    <!--- Fix bug with locks at the same time --->

    <cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_files_locks`
        ADD COLUMN `lock_id` VARCHAR(45) NOT NULL FIRST,
        DROP PRIMARY KEY,
        ADD PRIMARY KEY (`file_id`, `user_id`, `lock_date`, `lock`, `lock_id`);
    </cfquery>

    <!--- Changed tree XML --->

    <cfquery datasource="#client_datasource#">
      DELETE FROM #new_client_abb#_areas_tree_cache;
    </cfquery>

    <!--- Add new column to users table for area administrators ---->

    <cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_users`
        ADD COLUMN `area_admin_administrator` TINYINT(1) NOT NULL DEFAULT 0 AFTER `user_administrator`;
    </cfquery>

		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput>
		</cfcatch>

	</cftry>


</cfif>
