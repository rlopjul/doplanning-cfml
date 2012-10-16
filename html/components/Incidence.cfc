<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 07-07-2009
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 07-07-2009
	
--->
<cfcomponent output="true">

	<cfset component = "Incidence">
	<cfset request_component = "IncidenceManager">
	
	
	<!---<cfscript>
	
		function insertBR(str) 
		{
		
			str = replace(str,chr(13),"<br />","ALL");
			return str;	
		}
	
	</cfscript>	--->
	
    
    <cffunction name="createIncidence" returntype="void" access="remote">
		<cfargument name="type_id" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">
        <cfargument name="description" type="string" required="true">
		<cfargument name="related_to" type="string" required="true">
		
		<cfset var method = "createIncidence">
		
		<cfset var request_parameters = "">
				
		<cftry>
			
			<cfset client_abb = SESSION.client_abb>
			<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>
			<cfset user_id = SESSION.user_id>
			
			<cfset response_page = "incidence_new_success.cfm">
			
			<cfset title = trim(arguments.title)>
			
			<cftransaction>
						
				<cfquery datasource="#client_dsn#" name="insert_incidence">
					INSERT INTO #client_abb#_incidences 
					(type_id, title, description, user_in_charge, creation_date, related_to, status)
					VALUES (
					<cfqueryparam value="#arguments.type_id#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#title#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#description#" cfsqltype="cf_sql_longvarchar">,
					<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
					now(),
					<cfqueryparam value="#related_to#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="pending" cfsqltype="cf_sql_varchar">
					);
				</cfquery>
				
				<cfquery datasource="#client_dsn#" name="getLastInsertId">
					SELECT LAST_INSERT_ID() AS last_insert_id FROM #client_abb#_incidences;
				</cfquery>
			
			</cftransaction>	
			
			<cfset incidence_id = getLastInsertId.last_insert_id>
			
			<cfquery datasource="#client_dsn#" name="incidence">
				SELECT *, DATE_FORMAT(incidences.creation_date,'%d-%m-%y %T') AS creation_date_formatted
				FROM #client_abb#_incidences AS incidences
				WHERE incidences.id = <cfqueryparam value="#incidence_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			<cfquery datasource="#APPLICATION.dsn#" name="types">
				SELECT *
				FROM APP_incidences_types AS incidences_types; 
			</cfquery>
			<cfquery dbtype="query" name="get_incidence">
				SELECT *
				FROM incidence, types
				WHERE incidence.type_id = types.id;
			</cfquery>
			<cfinvoke component="#APPLICATION.componentsPath#/AlertManager" method="newIncidence" returnvariable="response">
				<cfinvokeargument name="objectIncidence" value="#get_incidence#">
			</cfinvoke>
			
			<cfset response_page = response_page&"?iid=#client_abb#"&incidence_id>
			
			<cfset message = "">
			
			<cfset message = URLEncodedFormat(message)>
			
            <cflocation url="#APPLICATION.htmlPath#/#response_page#&message=#message#" addtoken="no">
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
	<!---<cffunction name="deleteIncidence" returntype="void" access="remote">
		<cfargument name="message_id" type="string" required="true">
		<cfargument name="area_id" type="string" required="true">
		
		<cfset var method = "deleteIncidence">
		
		<cfset var request_parameters = "">
		
		<cftry>
			
			<cfset response_page = "messages.cfm?area=#arguments.area_id#">
			
			<cfif len(arguments.message_id) IS 0 OR NOT isValid("integer",arguments.message_id)>
			
				<cfset message = "Mensage incorrecto.">
				<cfset message = URLEncodedFormat(message)>
				<cflocation url="#APPLICATION.htmlPath#/#response_page#&message=#message#" addtoken="no">
			
			</cfif>
			
			<cfset request_parameters = '<message id="#arguments.message_id#"/>'>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>	
			
			<cfset message = "Mensaje eliminado.">
			<cfset message = URLEncodedFormat(message)>
            
            <cflocation url="#APPLICATION.htmlPath#/#response_page#&message=#message#" addtoken="no">	
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>--->
	
	
</cfcomponent>