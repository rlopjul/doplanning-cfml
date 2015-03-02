<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 12-08-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 08-07-2009
	
--->
<cfcomponent displayname="LogManager" output="false">

	<cfset component = "LogManager">	
	
	<cfset date_format = "%d-%m-%Y"><!---%H:%i:%s---><!---Formato de fecha en la que se debe recibir los parámetros--->
	<cfset datetime_format = "%d-%m-%Y %H:%i:%s">
	
	<!----------------------------------------- saveLog -------------------------------------------------->
	
	<cffunction name="saveLog" access="public" returntype="void">
		<cfargument name="log_component" type="string" required="yes">
		<cfargument name="log_method" type="string" required="yes">
		<cfargument name="log_content" type="string" required="yes">
		<cfargument name="client_abb" type="string" required="no">
		
		<cfset var method = "saveLog">
		
		<cftry>
			
			<cfif NOT isDefined("arguments.client_abb")>
				<cfinclude template="includes/sessionVarsNoAppCheck.cfm">
			<cfelse>
				<cfset client_dsn = APPLICATION.identifier&"_"&arguments.client_abb>
			</cfif>
		
			<cfquery name="recordLog" datasource="#client_dsn#">
				INSERT INTO #client_abb#_logs (user_id, request_content, component, method)
				VALUES 
				(<cfif isDefined("user_id")>
					<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
				 <cfelse>
					<cfqueryparam null="yes" cfsqltype="cf_sql_integer">
				 </cfif>, '#log_content#', '#log_component#', '#log_method#')
			</cfquery>
		
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	
	<!----------------------------------------- getLogs -------------------------------------------------->
	
	<cffunction name="getLogs" returntype="string" access="remote">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "getLogs">
		
		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">
			
		<cfset var xmlRequest = "">
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinclude template="includes/checkAdminAccess.cfm">
			
			<cfif isDefined("xmlRequest.request.parameters.logs.xmlAttributes.items_page")>
				<cfset logs_per_page = xmlRequest.request.parameters.logs.xmlAttributes.items_page>
			<cfelse>
				<cfset logs_per_page = 20>
			</cfif>
			
			<cfif isDefined("xmlRequest.request.parameters.logs.xmlAttributes.page")>
			
				<cfset current_page = xmlRequest.request.parameters.logs.xmlAttributes.page>
			
			<cfelse>
				<cfset current_page = 1>
			</cfif>
			
			<cfif isDefined("xmlRequest.request.parameters.logs.xmlAttributes.date_from")>
				<cfset date_from = xmlRequest.request.parameters.logs.xmlAttributes.date_from>
			</cfif>
			<cfif isDefined("xmlRequest.request.parameters.logs.xmlAttributes.date_to")>
				<cfset date_to = xmlRequest.request.parameters.logs.xmlAttributes.date_to>
			</cfif>
			
			<cfif isDefined("xmlRequest.request.parameters.logs.xmlAttributes.user_id")>
				<cfset user_log = xmlRequest.request.parameters.logs.xmlAttributes.user_id>
			</cfif>
			
			<cfif isDefined("xmlRequest.request.parameters.logs.xmlAttributes.action_id")>
				<cfset action_id = xmlRequest.request.parameters.logs.xmlAttributes.action_id>
			</cfif>
			
			<!--- ORDER --->
			<cfif isDefined("xmlRequest.request.parameters.order")>
		
				<cfset order_by = xmlRequest.request.parameters.order.xmlAttributes.parameter>
				
				<cfif order_by EQ "id">
					<cfset order_by = "log_id">
				</cfif>
				
				<cfset order_type = xmlRequest.request.parameters.order.xmlAttributes.order_type>
			
			<cfelse>
			
				<cfset order_by = "time">
				<cfset order_type = "desc">
			
			</cfif>
			
			<!---<cfif current_page IS 1>
			
				<cfquery datasource="#client_dsn#" name="getAllLogs">
					SELECT * , count(*) AS num_logs
					FROM #client_abb#_logs AS logs 
					LEFT JOIN #client_abb#_users AS users ON logs.user_id = users.id
					<cfif isDefined("user_log")>
					AND logs.user_id = <cfqueryparam value="#user_log#" cfsqltype="cf_sql_integer">
					</cfif>
					<cfif isDefined("date_from")>
					AND logs.time > <cfqueryparam value="#date_from#" cfsqltype="cf_sql_timestamp">
					</cfif>
					<cfif isDefined("date_to")>
					AND logs.time < <cfqueryparam value="#date_to#" cfsqltype="cf_sql_timestamp">
					</cfif>
					LEFT JOIN app_methods AS methods ON logs.method = methods.name
					<cfif isDefined("action_id")>
					AND methods.id = <cfqueryparam value="#action_id#" cfsqltype="cf_sql_integer">
					</cfif>
					LEFT JOIN app_components AS components ON logs.component = components.name
					
					GROUP BY logs.id
					ORDER BY #order_by# #order_type#;
				</cfquery>
				
				<cfset num_logs = getAllLogs.num_logs>
			
				<cfset num_pages = ceiling(num_logs/logs_per_page)>
				
			</cfif>--->
			
			<cfset init_log = (current_page-1)*logs_per_page>
			
			<cfquery datasource="#client_dsn#" name="logs">
				SELECT SQL_CALC_FOUND_ROWS *, logs.id AS log_id 
				FROM #client_abb#_logs AS logs 
				LEFT JOIN #client_abb#_users AS users ON logs.user_id = users.id
				<!---LEFT JOIN app_methods AS methods ON logs.method = methods.name
				LEFT JOIN app_components AS components ON logs.component = components.name
				WHERE methods.action_es != ''--->
				WHERE logs.id != 0
				<cfif isDefined("user_log")>
				AND logs.user_id = <cfqueryparam value="#user_log#" cfsqltype="cf_sql_integer">
				</cfif>
				<cfif isDefined("date_from")>
				AND logs.time >= STR_TO_DATE(<cfqueryparam value="#date_from#" cfsqltype="cf_sql_varchar">,'#date_format#')
				</cfif>
				<cfif isDefined("date_to")>
				AND logs.time <= STR_TO_DATE(<cfqueryparam value="#date_to# 23:59:59" cfsqltype="cf_sql_varchar">,'#datetime_format#')
				</cfif>
				ORDER BY #order_by# #order_type#
				LIMIT #init_log#, #logs_per_page#;
			</cfquery>			
			
			<cfquery datasource="#client_dsn#" name="getLogCount">
				SELECT FOUND_ROWS() AS num_logs;
			</cfquery>
			
			<cfquery datasource="#APPLICATION.dsn#" name="methods">
				SELECT *
				FROM app_methods AS methods; <!---ON logs.method = methods.name--->
			</cfquery>
			
			<cfquery datasource="#APPLICATION.dsn#" name="components">
				SELECT *
				FROM app_components AS components; <!---ON logs.component = components.name--->
			</cfquery>
			
			<cfquery dbtype="query" name="getLog">
				SELECT *
				FROM logs, methods, components
				WHERE logs.method = methods.name
				AND logs.component = components.name
				<cfif isDefined("action_id")>
				AND methods.id = <cfqueryparam value="#action_id#" cfsqltype="cf_sql_integer">
				</cfif>;
			</cfquery>
			
			<!---<cfquery name="getLog" dbtype="query">
				SELECT TOP 10 *, logs.id AS log_id 
				FROM getAllLogs
				ORDER BY #order_by# #order_type#;
			</cfquery>--->
			
			<cfset num_logs = getLogCount.num_logs>
			
			<cfset num_pages = ceiling(num_logs/logs_per_page)>
			
			<cfset xmlResult = '<logs total="#num_logs#" pages="#num_pages#" page="#current_page#">'>
			
			<cfif getLog.RecordCount GT 0>
				<cfloop query="getLog">
					
					<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringLogTime">
						<cfinvokeargument name="timestamp_date" value="#getLog.time#">
					</cfinvoke>
					
					<cfset xmlLog = '<log id="#getLog.log_id#" user_id="#getLog.user_id#" time="#stringLogTime#"><user_full_name><![CDATA[#getLog.family_name# #getLog.name#]]></user_full_name><action><![CDATA[#getLog.action_es#]]></action><description><![CDATA[#getLog.description_es#]]></description></log>'>
					<cfset xmlResult = xmlResult&xmlLog>
				</cfloop>
			</cfif>
			
			<cfset xmlResponseContent = xmlResult&"</logs>">
	
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!----------------------------------------- getLogActions -------------------------------------------------->
	
	<!---Devuelve una lista de las acciones de log disponibles--->
	
	<cffunction name="getLogActions" returntype="string" access="remote">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "getLogActions">
		
		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">
			
		<cfset var xmlRequest = "">
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfinclude template="includes/checkAdminAccess.cfm">
			
			<cfquery datasource="#APPLICATION.dsn#" name="getLogActions">
				SELECT *
				FROM app_methods AS methods
				WHERE action_es != ''
				ORDER BY action_es ASC;
			</cfquery>
			
			<cfset xmlResult = '<log_actions>'>
			
			<cfif getLogActions.RecordCount GT 0>
				<cfloop query="getLogActions">
					
					<cfset xmlLog = '<log_action id="#getLogActions.id#"><action><![CDATA[#getLogActions.action_es#]]></action><description><![CDATA[#getLogActions.description_es#]]></description></log_action>'>
					<cfset xmlResult = xmlResult&xmlLog>
				</cfloop>
			</cfif>
			
			<cfset xmlResponseContent = xmlResult&"</log_actions>">
	
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
</cfcomponent>