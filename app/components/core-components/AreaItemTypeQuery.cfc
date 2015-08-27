<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "AreaItemTypeQuery">	


	<!--- getAreaItemTypesOptions --->

	<cffunction name="getAreaItemTypesOptions" output="false" returntype="query" access="public">
		<cfargument name="itemTypeId" type="numeric" required="false">
		
		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "getAreaItemTypesOptions">

			<cfquery name="getAreaItemTypesOptions" datasource="#client_dsn#">
				SELECT items_types.*, areas.name AS category_area_name
				FROM #client_abb#_items_types AS items_types
				INNER JOIN #client_abb#_areas AS areas
				ON items_types.category_area_id = areas.id
				<cfif isDefined("arguments.itemTypeId")>
					WHERE items_types.item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">
				</cfif>;
			</cfquery>
				
		<cfreturn getAreaItemTypesOptions>
		
	</cffunction>

</cfcomponent>