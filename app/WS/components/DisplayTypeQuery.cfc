<!---Copyright Era7 Information Technologies 2007-2013

	Date of file creation: 09-04-2013
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 09-04-2013
	
--->
<cfcomponent output="false">

	<cfset component = "DisplayTypeQuery">	
	

	<!---getDisplayTypes--->
	
	<cffunction name="getDisplayTypes" output="false" returntype="query" access="public">		
		<cfargument name="client_abb" type="string" required="yes">
		<cfargument name="client_dsn" type="string" required="yes">		
		
		<cfset var method = "getDisplayTypes">
								
			<cfquery name="displayTypesQuery" datasource="#client_dsn#">
				SELECT display_type_id, display_type_title_es, display_type_title_en
				FROM #client_abb#_display_types
				WHERE enabled = 1
				ORDER BY display_type_id ASC;
			</cfquery>	
		
		<cfreturn displayTypesQuery>
		
	</cffunction>
	
</cfcomponent>