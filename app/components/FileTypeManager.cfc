<!---Copyright Era7 Information Technologies 2007-2009

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 12-11-2009

--->
<cfcomponent output="false">

	<cfset component = "FileTypeManager">


	<!----getFileTypesConversion--->
	<!---Aquí se obtienen los tipos a los que se puede convertir un archivo--->

	<cffunction name="getFileTypesConversion" access="public" returntype="any">
		<cfargument name="file_type" type="string" required="yes">

		<cfset var method = "getFileTypesConversion">

		<cfset var response = "">

			<cfquery datasource="#APPLICATION.dsn#" name="response">
				SELECT app_file_types.file_type, app_file_types.name_es, app_file_types.name_en
				FROM app_file_types
				INNER JOIN app_file_types_conversion ON app_file_types.file_type = app_file_types_conversion.file_type_to
				WHERE app_file_types_conversion.file_type_from = <cfqueryparam value="#arguments.file_type#" cfsqltype="cf_sql_varchar">
				AND app_file_types_conversion.enabled = <cfqueryparam value="1" cfsqltype="cf_sql_tinyint">
				ORDER BY app_file_types_conversion.order ASC;
			</cfquery>


		<cfreturn response>

	</cffunction>

</cfcomponent>
