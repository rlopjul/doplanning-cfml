<cfset version_id = "3.9">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp39">
		SELECT *
		FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#'
		AND TABLE_NAME = '#new_client_abb#_typologies'
		AND COLUMN_NAME = 'url_id'
    AND COLUMN_TYPE = 'varchar(255)';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp39.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>

<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<!--- Typologies WEB fields --->

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `dp_#new_client_abb#`.`#new_client_abb#_typologies` ADD COLUMN `publication_scope_id` INTEGER UNSIGNED DEFAULT NULL AFTER `general`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `dp_#new_client_abb#`.`#new_client_abb#_typologies` ADD CONSTRAINT `FK_#new_client_abb#_typologies_6` FOREIGN KEY `FK_#new_client_abb#_typologies_6` (`publication_scope_id`)
			    REFERENCES `#new_client_abb#_scopes` (`scope_id`)
			    ON DELETE RESTRICT
			    ON UPDATE RESTRICT;
		</cfquery>


		<cfquery datasource="#client_datasource#">
			 ALTER TABLE `dp_#new_client_abb#`.`#new_client_abb#_typologies` ADD COLUMN `publication_date` DATE AFTER `publication_scope_id`,
			 ADD COLUMN `publication_validated` BOOLEAN AFTER `publication_date`,
			 ADD COLUMN `publication_validated_user` INTEGER AFTER `publication_validated`,
			 ADD COLUMN `publication_validated_date` DATETIME AFTER `publication_validated_user`;
		</cfquery>

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_typologies`
			ADD COLUMN `publication_restricted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '' AFTER `publication_validated_date`;
		</cfquery>

		<!--- url_id colum --->

		<cfquery datasource="#client_datasource#">
			ALTER TABLE `#new_client_abb#_typologies`
			ADD COLUMN `url_id` VARCHAR(255) NULL AFTER `publication_restricted`,
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
