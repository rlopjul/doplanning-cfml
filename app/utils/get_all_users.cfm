<cfif (SESSION.client_abb EQ "era7" AND (SESSION.user_id EQ "3" OR SESSION.user_id EQ "111" 
OR SESSION.user_id EQ "93" OR SESSION.user_id EQ "152" OR SESSION.user_id EQ "1")) OR (SESSION.client_abb EQ "web4bio7" AND SESSION.user_id EQ "4") OR (SESSION.client_abb EQ "software7" AND SESSION.user_id EQ "2") OR (SESSION.client_abb EQ "bioinformatics7" AND SESSION.user_id EQ "10")>

<cfset no_include_clients="software7,web4bio7,organizacion,empresa,democlientes,demo,era7,pruebas,hospitalgranada,aliente">
<cfquery datasource="#APPLICATION.dsn#" name="getClients">
	SELECT *
	FROM app_clients;
</cfquery>

<cfheader name="Content-Disposition" value="attachment;filename=usuarios_doplanning.csv;" charset="iso-8859-1">
<cfcontent type="text/csv; charset=iso-8859-1">
<cfloop query="getClients">
	
	<cfset client_dsn = APPLICATION.identifier&"_"&getClients.abbreviation>
	<cfset client_abb = getClients.abbreviation>
	<cfset client_name = getClients.name>
	
	<cfif listFind(no_include_clients, client_abb, ",") IS 0>
	
		<cfquery datasource="#client_dsn#" name="getUsers">
			SELECT *
			FROM #client_abb#_users
			WHERE enabled = true;
		</cfquery>
			
		<cfoutput>
		<cfloop query="getUsers">	
			#getUsers.email#;#client_name#;
		</cfloop>
		</cfoutput>
		
	</cfif>
	
</cfloop>
</cfcontent>

</cfif>