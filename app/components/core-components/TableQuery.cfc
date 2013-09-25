<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfcomponent output="false">

	<cfset component = "TableQuery">	
	
	<cfset dateFormat = "%d-%m-%Y"><!---Formato de fecha en la que se debe recibir los parámetros--->
	<cfset dateTimeFormat = "%d-%m-%Y %H:%i:%s">


	<!---getTable--->
		
	<cffunction name="getTable" output="false" returntype="query" access="public">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
				
		<cfset var method = "getTable">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">		
			
			<!---<cfquery name="getTableQuery" datasource="#client_dsn#">
				SELECT *
				FROM #client_abb#_#tableTypeTable#
				WHERE table_id = <cfqueryparam value="#arguments.table_id#" cfsqltype="cf_sql_integer">;
			</cfquery>--->

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="getItemQuery">
				<cfinvokeargument name="item_id" value="#arguments.table_id#">
				<cfinvokeargument name="itemTypeId" value="#itemTypeId#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
		<cfreturn getItemQuery>
		
	</cffunction>
	

</cfcomponent>	
