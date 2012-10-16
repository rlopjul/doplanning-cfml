<cfprocessingdirective suppresswhitespace="true">
<cfsilent>
<!---Copyright Era7 Information Technologies 2007-2009

    Date of file creation: 29-01-2009
    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 09-07-2009
	
--->
<cftry>			
	<cfset component = "myFilesUploadFileTicket">
	<cfset method = "myFilesUploadFileTicket">
	
	<cfif isDefined("FORM.user_id") AND isDefined("FORM.client_abb") AND isDefined("FORM.language") AND isDefined("FORM.session_id")>
	
		<cfset user_id = FORM.user_id>
		<cfset client_abb = FORM.client_abb>
		<cfset user_language = FORM.language>
		<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>
	
	<cfelse><!---No value given for one or more required parameters--->
		<cfset error_code = 610>
			
		<cfthrow errorcode="#error_code#" message="URL:#CGI.QUERY_STRING#">
	</cfif>
	
	<cfquery name="getSessionidQuery" datasource="#client_dsn#">
		SELECT session_id 
		FROM #client_abb#_users
		WHERE id=<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;		 
	</cfquery>
		
	<cfif getSessionidQuery.recordCount GT 0 AND getSessionidQuery.session_id EQ FORM.session_id>
		
		<cfset destination = '#APPLICATION.filesPath#/#client_abb#/files/'>
		
		<cfif isDefined("FORM.file")>
		
			<cfset xml="#FORM.file#">
			
			<cfxml variable="fileXml">
				<cfoutput>
					#xml#
				</cfoutput>
			</cfxml>
		</cfif>

		<cfif isDefined("fileXml.file.xmlAttributes.id") AND isValid("integer", fileXml.file.xmlAttributes.id)>		
			
			<cfset upload_file_id = fileXml.file.xmlAttributes.id>		
			
			<cfquery datasource="#client_dsn#" name="getFileStatus">				
				SELECT *
				FROM #client_abb#_files
				WHERE id = <cfqueryparam value="#upload_file_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif getFileStatus.recordCount IS 0><!---The file does not exist in database (is not found)--->
				
				<cfset xmlResponseContent = arguments.request>
				<cfset error_code = 601>
				
				<cfthrow errorcode="#error_code#">
				
			</cfif>
			
			<cfif getFileStatus.status NEQ "canceled">
		
				<cftry>	
					
					<cfquery name="updateStateUploadingFile" datasource="#client_dsn#">
						UPDATE #client_abb#_files
						SET status = 'uploading'
						WHERE id=<cfqueryparam value="#upload_file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
				
					<cffile action="upload" filefield="Filedata" destination="#destination##upload_file_id#" nameconflict="overwrite" result="uploadedFile">
					
					<cfif NOT isDefined("uploadedFile.clientFileExt")><!---Si no está definido es porque el archivo no tiene nombre, y solo tiene extensión, por ejemplo: .project--->
						<cfif isDefined("uploadedFile.clientFile") AND len(uploadedFile.clientFile) GT 0>
							<cfset dot = findOneOf(".", uploadedFile.clientFile)>
							<cfif dot GT 0>
								<cfset uploadedFile.clientFileExt = right(uploadedFile.clientFile,len(uploadedFile.clientFile)-dot)>
							<cfelse>
								<cfset uploadedFile.clientFileExt = "">
							</cfif>
						<cfelse>
							<cfset uploadedFile.clientFileExt = "">
						</cfif>
					</cfif>
			
					<!---<cfset temp_file="#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#">--->
					<cfset temp_file = uploadedFile.clientFile>
					
					<cfset file_type = lCase(".#uploadedFile.clientFileExt#")>
					
					<!---<cffile action="rename" source="#destination##temp_file#" destination="#destination##upload_file_id#">--->
							
					<cfinvoke component="#APPLICATION.componentsPath#/DateManager" method="getCurrentDateTime" returnvariable="current_date">
					</cfinvoke>
					
					<cfinvoke component="#APPLICATION.componentsPath#/DateManager" method="timestampToString" returnvariable="stringCurrentDate">
						<cfinvokeargument name="timestamp_date" value="#current_date#">
					</cfinvoke>
					
					
					<cfquery name="updateUploadingFile" datasource="#client_dsn#">
						UPDATE #client_abb#_files
						SET uploading_date = <cfqueryparam value="#current_date#" cfsqltype="cf_sql_timestamp">, 
						file_size = <cfqueryparam value="#uploadedFile.fileSize#" cfsqltype="cf_sql_integer">,
						file_type = <cfqueryparam value="#file_type#" cfsqltype="cf_sql_varchar">,
						file_name = <cfqueryparam value="#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#" cfsqltype="cf_sql_varchar">,
						physical_name = <cfqueryparam value="#upload_file_id#" cfsqltype="cf_sql_varchar">,
						status = <cfqueryparam value="ok" cfsqltype="cf_sql_varchar">
						WHERE id=<cfqueryparam value="#upload_file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
							
					<!--- ------------------ Update User Space Used --------------------- --->
					<cfquery name="updateSpaceUsed" datasource="#client_dsn#">
						UPDATE #client_abb#_users
						SET space_used = space_used+<cfqueryparam value="#uploadedFile.fileSize#" cfsqltype="cf_sql_integer">
						WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
					
					<cfcatch><!---The upload fail--->
						<cfif isDefined("upload_file_id")>
							<cfquery datasource="#client_dsn#" name="changeFileStatus">
								UPDATE #client_abb#_files
								SET status = 'error'
								WHERE id = <cfqueryparam value="#upload_file_id#" cfsqltype="cf_sql_integer">;
							</cfquery>
						</cfif>
						
						<!---<cfset error_code = 604>--->
				
						<cfthrow object="#cfcatch#">
					
					</cfcatch>
				</cftry>
				
				
				<!---<cfset xmlResultFile.response.xmlAttributes.component = component>
				<cfset xmlResultFile.response.xmlAttributes.method = method>
					
				<cfset xmlResponse = xmlResultFile>--->
				
				<cfquery name="selectFileQuery" datasource="#client_dsn#">		
					SELECT *
					FROM #client_abb#_files AS files
					WHERE files.id=<cfqueryPARAM value="#upload_file_id#" CFSQLType="cf_sql_integer">;
				</cfquery>
				
				<cfif selectFileQuery.recordCount GT 0>
				
					<!---<file file_size="#selectFileQuery.file_size#" file_type="#selectFileQuery.file_type#">
						<name><![CDATA[#selectFileQuery.name#]]></name>
						<file_name><![CDATA[#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#]]></file_name>
						<description><![CDATA[#fileXml.file.description.xmlText#]]></description>
					</file>--->
				
				<cfelse><!---File does not exist--->
			
					<cfset error_code = 601>
				
					<cfthrow errorcode="#error_code#">
	
				</cfif>	
				
				<cfset xmlResponseContent = fileXml>				
				
			<cfelse><!---Status=canceled--->
			
				<!---deleteFile--->
				<cfquery datasource="#client_dsn#" name="changeFileStatus">
					DELETE
					FROM #client_abb#_files
					WHERE id = <cfqueryparam value="#upload_file_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
			
				<cfset xmlResponseContent = '<file status="canceled"/>'>
			
			</cfif>			
		
			<cfinclude template="#APPLICATION.componentsPath#/includes/functionEndNoLog.cfm">
			
				
			<!---<cfelse><!---File insert fail--->
			
				<cffile action="delete" file="#destination##temp_file#">
			
				<cfset xmlResponseContent = xml>
				<cfset error_code = 602>
				
				<cfthrow errorcode="#error_code#">
			
			</cfif>--->
			

		<cfelse><!---XML receibed is incorrect or incomplete--->
			
			<cfset xmlResponseContent = xml>
			<cfset error_code = 1002>
			
			<cfthrow errorcode="#error_code#">		
				
		</cfif>
			
		
	<cfelse><!---Session finished or incorrect--->
			
		<cfset error_code = 102>
		
		<cfthrow errorcode="#error_code#">
		
	</cfif>	
	
	<cfcatch>
		<cfset xmlResponseContent = "">
		<cfinclude template="#APPLICATION.componentsPath#/includes/errorHandler.cfm">
		<!---<cfreturn xmlResponse>--->
	</cfcatch>
</cftry>
</cfsilent><cfoutput>#xmlResponse#</cfoutput></cfprocessingdirective>