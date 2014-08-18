<!---Copyright Era7 Information Technologies 2007-2014--->
<cfcomponent output="false">
	
	<cfset component = "ItemSubTypeManager">
	
	
	<!---  ---------------------- GET SUB TYPES -------------------------------- --->
	
	<cffunction name="getSubTypes" returntype="query" access="public">
		<cfargument name="itemTypeId" type="numeric" required="true">
		
		<cfset var method = "getSubTypes">
		
		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">
						
			<cfinvoke component="#APPLICATION.coreComponentsPath#/ItemSubTypeQuery" method="getSubTypes" returnvariable="getItemSubTypesResult">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfreturn getItemSubTypesResult>
							
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
				
	</cffunction>
	
	<!---  ------------------------------------------------------------------------ --->


	<!---  ---------------------- GET SUB TYPE -------------------------------- --->
	
	<cffunction name="getSubType" returntype="query" access="public">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="sub_type_id" type="numeric" required="false">
		<cfargument name="sub_type_name" type="numeric" required="false">
		
		<cfset var method = "getSubType">
		
		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">
						
			<cfinvoke component="#APPLICATION.coreComponentsPath#/ItemSubTypeQuery" method="getSubType" returnvariable="getSubTypeResult">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">

				<cfinvokeargument name="sub_type_id" value="#arguments.sub_type_id#">
				<cfinvokeargument name="sub_type_name" value="#arguments.sub_type_name#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfreturn getSubTypeResult>
							
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
				
	</cffunction>
	
	<!---  ------------------------------------------------------------------------ --->
	
	
</cfcomponent>