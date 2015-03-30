<cfif (SESSION.client_abb EQ "era7" AND (SESSION.user_id EQ "3" OR SESSION.user_id EQ "111" 
OR SESSION.user_id EQ "93" OR SESSION.user_id EQ "152" OR SESSION.user_id EQ "1")) OR (SESSION.client_abb EQ "web4bio7" AND (SESSION.user_id EQ "4" OR SESSION.user_id EQ "9")) OR (SESSION.client_abb EQ "software7" AND SESSION.user_id EQ "2") OR (SESSION.client_abb EQ "era7it" AND SESSION.user_id EQ "3") OR (APPLICATION.identifier EQ "vpnet" AND SESSION.user_id IS 1) OR (SESSION.client_abb EQ "bioinformatics7" AND SESSION.user_id IS 10)>
	
<cfquery datasource="#APPLICATION.dsn#" name="getClients">
	SELECT *
	FROM app_clients;
</cfquery>

<cfset newLine = (Chr( 13 ) & Chr( 10 )) />
<cfset fileContent = "">

	<cfloop query="getClients">

		<cfset cur_client_abb = getClients.abbreviation>
		<cfset cur_sms_used = getClients.number_of_sms_used>
		<cfset client_dsn = APPLICATION.identifier&"_"&getClients.abbreviation>

			<!---Esta consulta anterior no se puede ejecutar (da error) en versiones antiguas de MySQL--->
			<cfquery datasource="#client_dsn#" name="getClient">
				SELECT sum(space_used) AS users_space_used, sum(space_downloaded) AS users_space_downloaded, sum(number_of_connections) AS users_connections, creation_date
				FROM #cur_client_abb#_users;
			</cfquery>
			
			<cfquery datasource="#client_dsn#" name="getClientAdministrator">
				SELECT *
				FROM #cur_client_abb#_users AS users
				WHERE users.id = #getClients.administrator_id#;
			</cfquery>
	
		<cfset fileContent = fileContent&"#getClients.name#;#getClientAdministrator.family_name# #getClientAdministrator.name#;#getClientAdministrator.email##newLine#">
			
	</cfloop>



	<cfset contentDisposition = "attachment; filename=all_dp_administrators.csv;">
	<cfset contentType = "text/csv; charset=Windows-1252">

	<cfheader name="Content-Disposition" value="#contentDisposition#" charset="Windows-1252"><!---iso-8859-1--->
	<cfcontent type="#contentType#"><cfoutput>#fileContent#</cfoutput></cfcontent>

</cfif>