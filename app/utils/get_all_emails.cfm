<cfset no_include_clients="">

<cfquery datasource="#APPLICATION.dsn#" name="getClients">
	SELECT *
	FROM app_clients;
</cfquery>

EMAILS:<br/>
<cfloop query="getClients">
	
	<cfset client_dsn = APPLICATION.identifier&"_"&getClients.abbreviation>
	<cfset client_abb = getClients.abbreviation>
	<cfset client_name = getClients.name>
	
	<cfif listFind(no_include_clients, client_abb, ",") IS 0>
	
		<cfquery datasource="#client_dsn#" name="getUsers">
			SELECT *
			FROM #client_abb#_users;
		</cfquery>
			
		<cfoutput>
			<cfloop query="getUsers"><cfif find("juntadeandalucia.es",getUsers.email) GT 0>#getUsers.email#;</cfif></cfloop>
		</cfoutput>
		
	</cfif>
	
</cfloop>