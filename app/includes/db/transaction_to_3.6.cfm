<cfset version_id = "3.6">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp36">
		SELECT *
		FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#'
		AND TABLE_NAME = '#new_client_abb#_files'
		AND COLUMN_NAME = 'url_id';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp36.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>

<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<!--- basic_email_notification column --->

		<cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_users_typologies`
      ADD COLUMN `basic_email_notification` TINYINT(1) NOT NULL DEFAULT 0 AFTER `form_display_type`;
		</cfquery>

    <!--- url_id column --->

    <cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_areas`
      ADD COLUMN `url_id` VARCHAR(75) NULL AFTER `read_only`;
    </cfquery>

    <!--- url_id unique column --->

    <cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_areas`
      ADD UNIQUE INDEX `url_id_UNIQUE` (`url_id` ASC);
    </cfquery>

    <!--- url_id colum in web elements --->

    <cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_entries`
      ADD COLUMN `url_id` VARCHAR(75) NULL AFTER `publication_restricted`,
      ADD UNIQUE INDEX `url_id_UNIQUE` (`url_id` ASC);
    </cfquery>

    <cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_news`
      ADD COLUMN `url_id` VARCHAR(75) NULL AFTER `publication_restricted`,
      ADD UNIQUE INDEX `url_id_UNIQUE` (`url_id` ASC);
    </cfquery>

    <cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_events`
      ADD COLUMN `url_id` VARCHAR(75) NULL AFTER `publication_restricted`,
      ADD UNIQUE INDEX `url_id_UNIQUE` (`url_id` ASC);
    </cfquery>

    <cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_pubmeds`
      ADD COLUMN `url_id` VARCHAR(75) NULL AFTER `publication_restricted`,
      ADD UNIQUE INDEX `url_id_UNIQUE` (`url_id` ASC);
    </cfquery>

    <cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_images`
      ADD COLUMN `url_id` VARCHAR(75) NULL AFTER `publication_restricted`,
      ADD UNIQUE INDEX `url_id_UNIQUE` (`url_id` ASC);
    </cfquery>

    <cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_lists`
      ADD COLUMN `url_id` VARCHAR(75) NULL AFTER `publication_restricted`,
      ADD UNIQUE INDEX `url_id_UNIQUE` (`url_id` ASC);
    </cfquery>

    <cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_forms`
      ADD COLUMN `url_id` VARCHAR(75) NULL AFTER `publication_restricted`,
      ADD UNIQUE INDEX `url_id_UNIQUE` (`url_id` ASC);
    </cfquery>

    <cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_lists_views`
      ADD COLUMN `url_id` VARCHAR(75) NULL AFTER `publication_restricted`,
      ADD UNIQUE INDEX `url_id_UNIQUE` (`url_id` ASC);
    </cfquery>

    <cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_forms_views`
      ADD COLUMN `url_id` VARCHAR(75) NULL AFTER `publication_restricted`,
      ADD UNIQUE INDEX `url_id_UNIQUE` (`url_id` ASC);
    </cfquery>

    <cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_mailings`
      ADD COLUMN `url_id` VARCHAR(75) NULL AFTER `publication_restricted`,
      ADD UNIQUE INDEX `url_id_UNIQUE` (`url_id` ASC);
    </cfquery>

    <cfquery datasource="#client_datasource#">
      ALTER TABLE `#new_client_abb#_files`
      ADD COLUMN `url_id` VARCHAR(75) NULL AFTER `thumbnail_format`,
      ADD UNIQUE INDEX `url_id_UNIQUE` (`url_id` ASC);
    </cfquery>


		<cfcatch>
			<cfoutput>
				<b>#new_client_abb# NO migrado a versión #version_id#</b><br/>
				<cfdump var="#cfcatch#">
			</cfoutput>
		</cfcatch>

	</cftry>


</cfif>
