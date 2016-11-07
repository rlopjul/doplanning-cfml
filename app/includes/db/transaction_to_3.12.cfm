<cfset version_id = "3.12">

<cfif checkVersion IS true>

	<cfquery datasource="#client_datasource#" name="isDbDp312">
		SELECT *
		FROM information_schema.COLUMNS
		WHERE TABLE_SCHEMA = 'dp_#new_client_abb#'
		AND TABLE_NAME = '#new_client_abb#_files_converted';
	</cfquery>

</cfif>

<cfif checkVersion IS true AND isDbDp312.recordCount GT 0>

	<cfoutput>
		Cliente #new_client_abb# ya migrado anteriormente a versión #version_id#<br/><br/>
	</cfoutput>

<cfelse>

	<cfoutput>
		Migrar #new_client_abb# a versión #version_id#<br/>
	</cfoutput>

	<cftry>

		<cfquery datasource="#client_datasource#">

			CREATE TABLE `dp_#new_client_abb#`.`#new_client_abb#_files_converted` (
			  `file_id` int(11) NOT NULL,
			  `file_type` varchar(10) NOT NULL,
			  `uploading_date` datetime NOT NULL,
			  `conversion_date` datetime NOT NULL,
			  PRIMARY KEY (`file_id`,`file_type`),
				CONSTRAINT `FK_files_files_converted` FOREIGN KEY (`file_id`) REFERENCES `#new_client_abb#_files` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
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
