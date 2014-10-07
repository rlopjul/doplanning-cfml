<!--- Copyright Era7 Information Technologies 2007-2013 --->
<cfcomponent output="false">

	<cfset component = "AreaItemManager">	
	
	<cfset dateFormat = "%d-%m-%Y"><!---%H:%i:%s---><!---Formato de fecha en la que se debe recibir los parámetros--->
	<cfset dateTimeFormat = "%d-%m-%Y %H:%i:%s">
	<!---<cfset timeZoneTo = "+1:00">--->
	<cfset timeZoneTo = "Europe/Madrid">


	<!--- getAreaItemTypesStruct --->

	<cffunction name="getAreaItemTypesStruct" returntype="struct" access="public">
		<cfargument name="client_abb" type="string" required="true">

		<cfset var itemTypesStruct = structNew()>

		<cfinclude template="includes/areaItemTypeStruct.cfm">

		<cfreturn itemTypesStruct>

	</cffunction>


	<!--- getAreaItemTypesArray --->

	<!---<cffunction name="getAreaItemTypesArray" returntype="array" access="public">
		<cfargument name="client_abb" type="string" required="true">

		<cfset var itemTypesStruct = structNew()>

		<cfinvoke component="AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
		</cfinvoke>

		<cfset var itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>

		<cfreturn itemTypesArray>

	</cffunction>--->


	<!--- ----------------------- DELETE ITEM ATTACHED FILE -------------------------------- --->
	
	<cffunction name="deleteItemAttachedFile" returntype="void" access="public">
		<cfargument name="item_id" type="string" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="itemQuery" type="query" required="true">
		<cfargument name="forceDeleteVirus" type="string" required="true">
		<cfargument name="anti_virus_check_result" type="string" required="false">

		<cfargument name="file_type" type="string" required="true"><!--- file / image --->

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">
		
		<cfset var method = "deleteItemAttachedFile">
		
		<cfset var area_id = "">
									
			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">
		
			<!--- DELETE IN DB  --->
			<cfquery name="deleteAttachedFile" datasource="#client_dsn#">
				UPDATE #client_abb#_#itemTypeTable#
				SET	attached_#arguments.file_type#_name = <cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
				attached_#arguments.file_type#_id = <cfqueryparam cfsqltype="cf_sql_integer" null="yes">
				WHERE id = <cfqueryparam value="#itemQuery.id#" cfsqltype="cf_sql_integer">;
			</cfquery>
				
			<!---DELETE ATTACHED_IMAGE FILE--->
			<cfif itemQuery["attached_#arguments.file_type#_id"] NEQ "NULL" AND itemQuery["attached_#arguments.file_type#_id"] NEQ "" AND itemQuery["attached_#arguments.file_type#_id"] NEQ "-1">
			
				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="deleteFile" returnvariable="deleteFileResult">
					<cfinvokeargument name="file_id" value="#itemQuery['attached_#arguments.file_type#_id']#">
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfinvokeargument name="forceDeleteVirus" value="#arguments.forceDeleteVirus#">
					<cfinvokeargument name="user_id" value="#user_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>
				
				<cfif deleteFileResult.result IS false><!---File delete failed--->

					<cfthrow message="#resultDeleteFile.message#">

				<cfelseif arguments.forceDeleteVirus IS true>

					<!--- Alert --->
					<cfinvoke component="#APPLICATION.componentsPath#/AlertManager" method="newAreaItem">
						<cfinvokeargument name="objectItem" value="#itemQuery#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="action" value="attached_#arguments.file_type#_deleted_virus">
						<cfinvokeargument name="anti_virus_check_result" value="#arguments.anti_virus_check_result#">
					</cfinvoke>
				
				</cfif>
				
			<cfelse>
			
				<cfset error_code = 601>

				<cfthrow errorcode="#error_code#">
				
			</cfif>

			<cfinclude template="includes/logRecord.cfm">
				
	</cffunction>
	<!--- ---------------------------------------------------------------------------------- --->
	
	


</cfcomponent>
	