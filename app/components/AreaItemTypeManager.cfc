<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">
	
	<cfset component = "AreaItemManager">


	<!--- ------------------------------------- updateAreaItemTypesOptions -------------------------------------  --->
	
	<cffunction name="updateAreaItemTypesOptions" output="false" access="public" returntype="struct">

		<cfset var method = "updateAreaItemTypesOptions">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<!--- checkAdminAccess --->
			<cfinclude template="includes/checkAdminAccess.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="getAreaItemTypesStruct" returnvariable="itemTypesStruct">
			</cfinvoke>

			<!---<cfset itemTypesArray = structSort(itemTypesStruct, "numeric", "ASC", "position")>--->

			<cftransaction>
				
				<cfloop collection="#itemTypesStruct#" item="itemType">

					<cfset itemTypeId = itemTypesStruct[itemType].id>

					<cfif isDefined("arguments.item_type_#itemTypeId#_category_area_id") AND isNumeric(arguments['item_type_#itemTypeId#_category_area_id'])>
						
						<cfquery name="updateAreaItemType" datasource="#client_dsn#">
							REPLACE INTO #client_abb#_items_types
							SET item_type_id = <cfqueryparam value="#itemTypeId#" cfsqltype="cf_sql_integer">,
							category_area_id = <cfqueryparam value="#arguments['item_type_#itemTypeId#_category_area_id']#" cfsqltype="cf_sql_integer">;
						</cfquery>

					</cfif>
					
					
				</cfloop>

			</cftransaction>
		
			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true}>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>


	<!--- ----------------- GET AREA ITEM TYPES OPTIONS --------------------------------------------   --->
	
	<cffunction name="getAreaItemTypesOptions" output="false" returntype="struct" access="public">
		<cfargument name="itemTypeId" type="numeric" required="false">
		
		<cfset var method = "getAreaItemTypesOptions">

		<cfset var response = structNew()>

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemTypeQuery" method="getAreaItemTypesOptions" returnvariable="itemTypesQuery">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#"/>
				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#"/>
				<cfinvokeargument name="client_dsn" value="#client_dsn#"/>
			</cfinvoke>

			<cfset response = {result=true, query=#itemTypesQuery#}>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>
	<!--- ------------------------------------------------------------------------------  --->


</cfcomponent>