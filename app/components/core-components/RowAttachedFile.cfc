<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "RowAttachedFile">

	<!---uploadRowAttachedFile--->

	<cffunction name="uploadRowAttachedFile" access="public" returntype="numeric">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="true">
		<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="field_name" type="string" required="true">
		<cfargument name="user_id" type="numeric" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "uploadRowAttachedFile">
		<cfset var file_id = "">
		<cfset var antiVirusCheckMessage = "">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfset var fileTypeId = attachedFileTypeId>
			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfset var destination = "#APPLICATION.filesPath#/#arguments.client_abb#/">
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

				<cfset antiVirusCheckMessage = trim(listlast(checkForVirusResponse.message, ":"))>

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

					<cfthrow message="Archivo #uploadedFile.serverFile# no válido por ser identificado como virus: #antiVirusCheckMessage#">

				</cfif>

			</cfif>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="createFileInDatabase" argumentcollection="#arguments#" returnvariable="file_id">
				<cfinvokeargument name="fileTypeId" value="#attachedFileTypeId#">
				<cfinvokeargument name="file_name" value="#uploadedFile.clientFile#">
				<cfinvokeargument name="file_type" value=".#uploadedFile.clientFileExt#">
				<cfinvokeargument name="file_size" value="#uploadedFile.fileSize#">
				<cfif isDefined("arguments.user_id")>
					<cfinvokeargument name="user_id" value="#arguments.user_id#">
				</cfif>
				<cfinvokeargument name="status" value="pending">
				<cfif APPLICATION.moduleAntiVirus IS true>
					<cfinvokeargument name="anti_virus_check" value="true">
					<cfinvokeargument name="anti_virus_check_result" value="#antiVirusCheckMessage#">
				</cfif>
				<cfinvokeargument name="item_id" value="#arguments.table_id#">
				<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
				<cfinvokeargument name="row_id" value="#arguments.row_id#">
				<cfinvokeargument name="field_id" value="#arguments.field_id#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset finalDestination = "#destination##fileTypeDirectory#/#file_id#">
			<cffile action="move" source="#tempFile#" destination="#finalDestination#">

			<cfquery datasource="#client_dsn#" name="updateFileStatus">
				UPDATE #client_abb#_#fileTypeTable#
				SET status = 'ok',
				physical_name = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_varchar">
				WHERE id = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfreturn file_id>

	</cffunction>



	<!---deleteRowAttachedFile--->

	<cffunction name="deleteRowAttachedFile" access="public" returntype="void">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="true">
		<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="user_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "deleteRowAttachedFile">

			<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

			<cfset var fileTypeId = attachedFileTypeId>
			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfset var destination = "#APPLICATION.filesPath#/#arguments.client_abb#/">
			<cfset var destinationTemp = "#destination#temp/">

			<cftransaction>

				<cfquery datasource="#client_dsn#" name="deleteRowAttachedFile">
					UPDATE `#client_abb#_#tableTypeTable#_rows_#arguments.table_id#`
					SET
					field_#arguments.field_id# = <cfqueryparam cfsqltype="cf_sql_varchar" null="yes">,
					last_update_user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">,
					last_update_date = NOW()
					WHERE row_id = <cfqueryparam value="#arguments.row_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="deleteFile">
					<cfinvokeargument name="file_id" value="#arguments.file_id#">
					<cfinvokeargument name="user_id" value="#arguments.user_id#">
					<cfinvokeargument name="moveToBin" value="false">
					<cfinvokeargument name="with_transaction" value="false">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cftransaction>


	</cffunction>


	<!---deleteRowAttachedFileIfExist--->

	<cffunction name="deleteRowAttachedFileIfExist" access="public" returntype="void">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="row_id" type="numeric" required="true">
		<cfargument name="field_id" type="numeric" required="true">
		<cfargument name="user_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "deleteRowAttachedFileIfExist">

		<cfset var rowQuery = "">
		<cfset var field_name = "">
		<cfset var file_id = "">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="getTableRows" returnvariable="rowQuery">
				<cfinvokeargument name="table_id" value="#arguments.table_id#">
				<cfinvokeargument name="tableTypeId" value="#arguments.tableTypeId#">
				<cfinvokeargument name="row_id" value="#arguments.row_id#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset field_name = 'field_#arguments.field_id#'>
			<cfset file_id = rowQuery[field_name]>

			<cfif rowQuery.recordCount GT 0 AND isNumeric(file_id)>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/RowAttachedFile" method="deleteRowAttachedFile">
					<cfinvokeargument name="file_id" value="#file_id#">
					<cfinvokeargument name="table_id" value="#arguments.table_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
					<cfinvokeargument name="row_id" value="#arguments.row_id#">
					<cfinvokeargument name="field_id" value="#arguments.field_id#">
					<cfinvokeargument name="user_id" value="#arguments.user_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cfif>

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

			<cfreturn "#destination##arguments.table_id#_#arguments.row_id#_#arguments.field_id#">

	</cffunction>



</cfcomponent>
