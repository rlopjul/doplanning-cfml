<!---Copyright Era7 Information Technologies 2007-2014--->
<cfcomponent output="false">

	<cfset component = "ItemSubTypeQuery">	
	

	<!---getSubTypes--->
	
	<cffunction name="getSubTypes" output="false" returntype="query" access="public">
		<cfargument name="itemTypeId" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
		
		<cfset var method = "getSubTypes">
								
			<cfquery name="subTypesQuery" datasource="#client_dsn#">
				SELECT sub_type_id, sub_type_title_es, sub_type_title_en
				FROM #client_abb#_items_sub_types
				WHERE item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer">
				AND enabled = 1
				ORDER BY position ASC;
			</cfquery>	
		
		<cfreturn subTypesQuery>
		
	</cffunction>


	<!---getSubType--->
	
	<cffunction name="getSubType" output="false" returntype="query" access="public">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="sub_type_id" type="numeric" required="false">
		<cfargument name="sub_type_name" type="numeric" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">		
		
		<cfset var method = "getSubType">
								
			<cfquery name="subTypeQuery" datasource="#client_dsn#">
				SELECT sub_type_id, sub_type_title_es, sub_type_title_en
				FROM #client_abb#_items_sub_types
				WHERE item_type_id = <cfqueryparam value="#arguments.itemTypeId#" cfsqltype="cf_sql_integer"> AND 
				<cfif isDefined("arguments.sub_type_name")>
					sub_type_name = <cfqueryparam value="#arguments.sub_type_name#" cfsqltype="cf_sql_integer">
				<cfelse>
					sub_type_id = <cfqueryparam value="#arguments.sub_type_id#" cfsqltype="cf_sql_integer">
				</cfif>;
			</cfquery>	
		
		<cfreturn subTypeQuery>
		
	</cffunction>
	
</cfcomponent>