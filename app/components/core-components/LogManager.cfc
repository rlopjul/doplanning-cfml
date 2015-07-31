<!--- Copyright Era7 Information Technologies 2007-20014 --->

<cfcomponent displayname="LogManager" output="false">

	<cfset component = "LogManager">	
	
	<cfset date_format = "%d-%m-%Y"><!---%H:%i:%s---><!---Formato de fecha en la que se debe recibir los parámetros--->
	<cfset datetime_format = "%d-%m-%Y %H:%i:%s">
	
	<!----------------------------------------- saveLog -------------------------------------------------->
	
	<cffunction name="saveLog" access="public" returntype="void">
		<cfargument name="log_component" type="string" required="true">
		<cfargument name="log_method" type="string" required="true">
		<cfargument name="log_content" type="string" required="true">
		<cfargument name="user_id" type="numeric" required="false">

		<cfargument name="client_abb" type="string" required="true">
		
		<cfset var method = "saveLog">
		
			<cfset client_dsn = APPLICATION.identifier&"_"&arguments.client_abb>
		
			<cfquery name="recordLog" datasource="#client_dsn#">
				INSERT INTO #client_abb#_logs 
				SET user_id = <cfif isDefined("arguments.user_id")>
					<cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">
				 <cfelse>
					<cfqueryparam null="true" cfsqltype="cf_sql_integer">
				 </cfif>,
				request_content = <cfqueryparam value="#arguments.log_content#" cfsqltype="cf_sql_longvarchar">,
				component = <cfqueryparam value="#arguments.log_component#" cfsqltype="cf_sql_varchar">,
				method = <cfqueryparam value="#arguments.log_method#" cfsqltype="cf_sql_varchar">;
			</cfquery>
		
	</cffunction>

</cfcomponent>