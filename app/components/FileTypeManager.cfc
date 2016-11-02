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

		<cfargument name="return_type" type="string" required="no" default="xml">

		<cfset var method = "getFileTypesConversion">

		<cfset var xmlResult = "">

			<!---<cfset file_types = structNew()>
			<cfset file_types[".ppt"] = '<file_type id=".ppt"><name_es><![CDATA[PowerPoint]></name_es></file_type>'>
			<cfset file_types[".swf"] = '<file_type id=".swf"><name_es><![CDATA[Flash]></name_es></file_type>'>--->


			<cfquery datasource="#APPLICATION.dsn#" name="getFileTypesConversion">
				SELECT app_file_types.file_type, app_file_types.name_es, app_file_types.name_en
				FROM app_file_types
				INNER JOIN app_file_types_conversion ON app_file_types.file_type = app_file_types_conversion.file_type_to
				WHERE app_file_types_conversion.file_type_from = <cfqueryparam value="#arguments.file_type#" cfsqltype="cf_sql_varchar">
				AND app_file_types_conversion.enabled = <cfqueryparam value="1" cfsqltype="cf_sql_tinyint">
				ORDER BY app_file_types_conversion.order ASC;
			</cfquery>

			<cfif arguments.return_type EQ "query">

				<cfset xmlResponse = getFileTypesConversion>

			<cfelseif arguments.return_type EQ "object">

				<cfset xmlResponse = getFileTypesConversion>

			<cfelse>

				<cfset xmlResult = "<file_types_conversion>">

				<cfloop query="getFileTypesConversion">
					<cfset xmlResult = xmlResult&'<file_type id="#getFileTypesConversion.file_type#"><name_es><![CDATA[#getFileTypesConversion.name_es#]]></name_es><name_en><![CDATA[#getFileTypesConversion.name_en#]]></name_en></file_type>'>
				</cfloop>

				<cfset xmlResult = xmlResult&"<file_types_conversion>">

				<cfset xmlResponse = xmlResult>

			</cfif>


		<cfreturn xmlResponse>

	</cffunction>

</cfcomponent>
