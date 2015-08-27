<!---Copyright Era7 Information Technologies 2007-2015--->
<cfcomponent output="true">

	<cfset component = "AreaItemType">
	<cfset request_component = "AreaItemTypeManager">


	<!--- ----------------------- getAreaItemTypesOptions -------------------------------- --->
	
	<cffunction name="getAreaItemTypesOptions" returntype="struct" access="public">
		<cfargument name="itemTypeId" type="numeric" required="false">
				
		<cfset var method = "getAreaItemTypesOptions">

		<cfset var response = structNew()>
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/AreaItemTypeManager" method="getAreaItemTypesOptions" returnvariable="response">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#"/>
			</cfinvoke>		

			<cfinclude template="includes/responseHandlerStruct.cfm">
            
			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>

		<cfreturn response>
		
	</cffunction>
	

	<!--- updateAreaItemTypesOptions --->
	
	<cffunction name="updateAreaItemTypesOptions" output="false" returntype="struct" returnformat="json" access="remote">
		
		<cfset var method = "updateAreaItemTypesOptions">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/AreaItemTypeManager" method="updateAreaItemTypesOptions" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Modificaciones guardadas">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
			
	</cffunction>
	
</cfcomponent>