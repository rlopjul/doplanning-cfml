<!---Copyright Era7 Information Technologies 2007-2016--->

<cfcomponent output="false">

	<cfset component = "FileType">


	<!----getFileTypesConversion--->

	<cffunction name="getFileTypesConversion" access="public" returntype="struct">
		<cfargument name="file_type" type="string" required="yes">

		<cfset var method = "getFileTypesConversion">

			<cftry>

				<cfinvoke component="#APPLICATION.componentsPath#/FileTypeManager" method="getFileTypesConversion" returnvariable="fileTypeQuery">
					<cfinvokeargument name="file_type" value="#arguments.file_type#"/>
					<cfinvokeargument name="return_type" value="query"/>
				</cfinvoke>

				<cfset response = {result=true, query=fileTypeQuery}>

				<cfcatch>
					<cfinclude template="includes/errorHandler.cfm">
				</cfcatch>

			</cftry>

			<cfreturn response>

	</cffunction>

</cfcomponent>
