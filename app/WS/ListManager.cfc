<!---Copyright Era7 Information Technologies 2007-2009

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 25-11-2009
	
--->
<cfcomponent output="false">	

	<cfset component = "ListManager">
	
	
	<!---- getList --->
	<!---Obtiene una lista--->
	
	<!----------------------------------------- getList -------------------------------------------------->
	
	<cffunction name="getList" returntype="string" access="remote">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "getList">
		
		<cfset var user_id = "">
		<cfset var client_abb = "">
		<cfset var user_language = "">
			
		<cfset var xmlRequest = "">
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset list_name = xmlRequest.request.parameters.list.xmlAttributes.name>
			<cfset list_target = xmlRequest.request.parameters.list.xmlAttributes.target>
			
			<!--- ORDER --->
			<cfif isDefined("xmlRequest.request.parameters.order")>
		
				<cfset order_by = xmlRequest.request.parameters.order.xmlAttributes.parameter>
				
				<cfif order_by EQ "id">
					<cfset order_by = "item_id">
				</cfif>
				
				<cfset order_type = xmlRequest.request.parameters.order.xmlAttributes.order_type>
			
			<cfelse>
			
				<cfset order_by = "item_id">
				<cfset order_type = "asc">
			
			</cfif>
			
			<cfquery datasource="#client_dsn#" name="getListItems">
				SELECT item_id, name_es
				FROM #client_abb#_list_#list_name# AS list 
				ORDER BY #order_by# #order_type#;
			</cfquery>			
			
			<cfset xmlResult = '<list name="#list_name#" target="#list_target#">'>
		
			<cfif getListItems.RecordCount GT 0>
				<cfloop query="getListItems">
					
					<cfset xmlItem = '<item id="#getListItems.item_id#"><name_es><![CDATA[#getListItems.name_es#]]></name_es></item>'>
					<cfset xmlResult = xmlResult&xmlItem>
				</cfloop>
			</cfif>
			
			<cfset xmlResponseContent = xmlResult&"</list>">
	
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>

</cfcomponent>