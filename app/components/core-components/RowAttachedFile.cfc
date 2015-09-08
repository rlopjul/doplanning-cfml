<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "RowAttachedFile">

	<!---uploadRowAttachedFile--->

	<cffunction name="uploadRowAttachedFile" access="public" returntype="void">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="true">
		<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="field_name" type="string" required="true">
		<cfargument name="user_id" type="numeric" required="false">
		<cfargument name="tableTypeNameP" type="string" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "uploadRowAttachedFile">

		<cfset var destination = "#APPLICATION.filesPath#/#arguments.client_abb#/#arguments.tableTypeNameP#/">
		<cfset var destinationTemp = "#destination#temp/">

			<cfif directoryExists(destinationTemp) IS false>

				<cfdirectory action="create" directory="#destinationTemp#">

			</cfif>

			<cffile action="upload" filefield="#arguments.field_name#" destination="#destinationTemp#" nameconflict="overwrite" result="uploadedFile">

			<cfset tempFile = "#uploadedFile.serverDirectory#/#uploadedFile.serverFile#">

			<!--- MODULE ANTI VIRUS --->
			<cfif APPLICATION.moduleAntiVirus IS true>

				<cfinvoke component="AntiVirusManager" method="checkForVirus" returnvariable="checkForVirusResponse">
					<cfinvokeargument name="path" value="#uploadedFile.serverDirectory#/">
					<cfinvokeargument name="filename" value="#uploadedFile.serverFile#">
				</cfinvoke>

				<cfif checkForVirusResponse.result IS false><!--- Delete infected file --->

					<!--- delete image --->
					<cffile action="delete" file="#tempFile#">

					<!---saveVirusLog--->
					<cfinvoke component="AntiVirusManager" method="saveVirusLog">
						<cfif isDefined("arguments.user_id")>
							<cfinvokeargument name="user_id" value="#arguments.user_id#">
						</cfif>
						<cfinvokeargument name="file_name" value="#uploadedFile.serverFile#"/>
						<cfinvokeargument name="anti_virus_result" value="#checkForVirusResponse.message#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

					<cfset anti_virus_check_message = trim(listlast(checkForVirusResponse.message, ":"))>

					<cfthrow message="Archivo #uploadedFile.serverFile# no válido por ser identificado como virus: #anti_virus_check_message#">

				</cfif>

			</cfif>

			<cfset finalDestination = "#destination##arguments.table_id#_#arguments.row_id#_#arguments.field_id#">

			<cffile action="move" source="#tempFile#" destination="#finalDestination#">

	</cffunction>



	<!---deleteRowAttachedFile--->

	<cffunction name="deleteRowAttachedFile" access="public" returntype="void">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="true">
		<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="tableTypeNameP" type="string" required="true">
		<cfargument name="tableTypeTable" type="string" required="true">
		<cfargument name="user_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "deleteRowAttachedFile">

		<cfset var destination = "#APPLICATION.filesPath#/#arguments.client_abb#/#arguments.tableTypeNameP#/">

		<cfset var finalDestination = "#destination##arguments.table_id#_#arguments.row_id#_#arguments.field_id#">

		<cfquery datasource="#client_dsn#" name="deleteRowAttachedFile">
			UPDATE `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#`
			SET
			field_#arguments.field_id# = <cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
			last_update_user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">,
			last_update_date = NOW()
			WHERE row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">;
		</cfquery>

		<cffile action="delete" file="#finalDestination#">

	</cffunction>


	<!---getRowAttachedFilePath--->

	<cffunction name="getRowAttachedFilePath" access="public" returntype="string">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="true">
		<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="tableTypeNameP" type="string" required="true">
		<cfargument name="tableTypeTable" type="string" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

			<cfreturn = "#destination##arguments.table_id#_#arguments.row_id#_#arguments.field_id#">

	</cffunction>



</cfcomponent>
