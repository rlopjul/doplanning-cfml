<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="true">

	<cfset component = "Table">
	<cfset request_component = "TableManager">


	<!--- ----------------------------------- getAreaTables ------------------------------------- --->
	
	<cffunction name="getAreaTables" returntype="struct" access="public">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfset var method = "getAreaTables">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getAreaTables" returnvariable="response">
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>


	<!--- ----------------------------------- getFieldTypes ------------------------------------- --->
	
	<cffunction name="getFieldTypes" returntype="struct" access="public">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfset var method = "getFieldTypes">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getFieldTypes" returnvariable="response">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>


	<!--- ----------------------------------- getTableFields ------------------------------------- --->
	
	<cffunction name="getTableFields" returntype="struct" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="with_types" type="boolean" required="false" default="false">

		<cfset var method = "getTableFields">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getTableFields" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
				<cfinvokeargument name="with_types" value="#arguments.with_types#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>


	<!--- ----------------------------------- getTableData ------------------------------------- --->
	
	<cffunction name="getTableData" returntype="struct" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		
		<cfset var method = "getTableData">

		<cfset var response = structNew()>
					
		<cftry>
	
			<cfinvoke component="#APPLICATION.componentsPath#/TableManager" method="getTableData" returnvariable="response">
				<cfinvokeargument name="table_id" value="#arguments.table_id#"/>
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#"/>
			</cfinvoke>
			
			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>



</cfcomponent>