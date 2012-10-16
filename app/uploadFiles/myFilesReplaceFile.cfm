<cfprocessingdirective suppresswhitespace="true">
<cfsilent>
<!---Copyright Era7 Information Technologies 2007-2009

    File created by: ppareja
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 13-01-2009
	
	Esta página se utiliza para la subida de archivos en la versión HTML
	
--->
<cftry>	
	<cfset component = "replaceFile">
	<cfset method = "replaceFile">
	
	<cfif isDefined("URL.user_id") AND isDefined("URL.client_abb") AND isDefined("URL.language") AND isDefined("URL.session_id")>
	
		<cfset user_id = URL.user_id>
		<cfset client_abb = URL.client_abb>
		<cfset user_language = URL.language>
		<cfset client_dsn = APPLICATION.identifier&"_"&client_abb>
	
	<cfelse><!---No value given for one or more required parameters--->
		<cfset error_code = 610>
			
		<cfthrow errorcode="#error_code#">
	</cfif>
	
	
	<cfquery name="getSessionidQuery" datasource="#client_dsn#">
		SELECT session_id 
		FROM #client_abb#_users
		WHERE id=<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;		 
	</cfquery>
		
	<cfif #getSessionidQuery.recordCount# GT 0 AND #getSessionidQuery.session_id# EQ #URL.session_id#>
		
		<cfset destination = '#APPLICATION.filesPath#/#client_abb#/files/'>
		
		<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="objectFile" returnvariable="objectFile">
			
			<cfinvokeargument name="return_type" value="object">
		</cfinvoke>
		
		<cfif isDefined("URL.file")>
		
			<cfset xml="#URL.file#">
			
			<cfxml variable="fileXml">
				<cfoutput>
					#xml#
				</cfoutput>
			</cfxml>
			
			<cfset objectFile.id = fileXml.file.xmlAttributes.id>
		
		<cfelseif isDefined("FORM.file_id") AND isValid("integer",FORM.file_id)>
			
			<!---<cfxml variable="fileXml">
				<cfoutput>
				<file id="#FORM.file_id#">
				</file>
				</cfoutput>
			</cfxml>--->
			
			<cfset objectFile.id = FORM.file_id>
			
		<cfelse><!---No value given for one or more required parameters--->

			<cfset error_code = 610>
			
			<cfthrow errorcode="#error_code#">
			
		</cfif>
		
		
		<!---<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="objectFile" returnvariable="objectFile">
			<cfinvokeargument name="xml" value="#fileXml.file#">
			<cfinvokeargument name="return_type" value="object">
		</cfinvoke>--->
		
		<!---<cfset file_id = fileXml.file.xmlAttributes.id>
		<cfset file_size = fileXml.file.xmlAttributes.file_size>
		<cfset file_type = fileXml.file.xmlAttributes.file_type>
		<cfset file_file_name = fileXml.file.file_name.xmlText>
		<cfset file_physical_name = file_id&file_type>--->
		
		<cfquery name="getFile" datasource="#client_dsn#">
			SELECT *
			FROM #client_abb#_files
			WHERE id=<cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">
			AND user_in_charge = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
	
		<cfif getFile.recordCount GT 0>
			
			<cfquery name="beginQuery" datasource="#client_dsn#">
				BEGIN;
			</cfquery>
			
			<cfinvoke component="#APPLICATION.componentsPath#/DateManager" method="getCurrentDateTime" returnvariable="current_date">
			</cfinvoke>
			
			<cfinvoke component="#APPLICATION.componentsPath#/DateManager" method="timestampToString" returnvariable="stringCurrentDate">
				<cfinvokeargument name="timestamp_date" value="#current_date#">
			</cfinvoke>
			
			<cfinvoke component="#APPLICATION.componentsPath#/DateManager" method="timestampToString" returnvariable="stringDateUpload">
				<cfinvokeargument name="timestamp_date" value="#getFile.uploading_date#">
			</cfinvoke>
			
			<cfset objectFile.name = getFile.name>
			<cfset objectFile.physical_name = getFile.physical_name>
			<cfset objectFile.uploading_date = stringDateUpload>
			
			<cfset objectFile.replacement_date = stringCurrentDate>
			<cfset objectFile.user_in_charge = user_id>
			
			<!---
			physical_name = <cfqueryparam value="#objectFile.physical_name#" cfsqltype="cf_sql_varchar">,
			--->
			<cffile action="delete" file="#destination##getFile.physical_name#">	
			
			<cffile action="upload" filefield="Filedata" destination="#destination#" nameconflict="overwrite" result="uploadedFile">
			
			<cfset objectFile.file_name = "#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#">
			<cfset objectFile.file_type = lCase(".#uploadedFile.clientFileExt#")>
			<cfset objectFile.file_size_full = "#uploadedFile.fileSize#">
			
			<cfset temp_file="#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#">
			
			<cfquery name="updateUploadingFile" datasource="#client_dsn#">
				UPDATE #client_abb#_files
				SET replacement_date = <cfqueryparam value="#current_date#" cfsqltype="cf_sql_timestamp">, 
				file_size = <cfqueryparam value="#objectFile.file_size_full#" cfsqltype="cf_sql_integer">,
				file_type = <cfqueryparam value="#objectFile.file_type#" cfsqltype="cf_sql_varchar">,
				file_name = <cfqueryparam value="#objectFile.file_name#" cfsqltype="cf_sql_varchar">,
				status = 'ok',
				status_replacement = 'uploaded'
				WHERE id=<cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<!--- ------------------ Update User Space Used --------------------- --->
			<cfquery name="updateSpaceUsed" datasource="#client_dsn#">
				UPDATE #client_abb#_users
				SET space_used = space_used-#getFile.file_size#+<cfqueryparam value="#objectFile.file_size_full#" cfsqltype="cf_sql_integer">
				WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfquery name="endQuery" datasource="#client_dsn#">
				COMMIT;
			</cfquery>

			<cftry>
				
				<cffile action="rename" source="#destination##temp_file#" destination="#destination##objectFile.physical_name#">
			
				<cfcatch><!---The upload fail--->
				
					<cfquery datasource="#client_dsn#" name="changeFileStatus">
						UPDATE #client_abb#_files
						SET status = 'failed'
						WHERE id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">
					</cfquery>
					
					<cfset error_code = 604>
			
					<cfthrow errorcode="#error_code#">
				
				</cfcatch>
			</cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="xmlFile" returnvariable="xmlResult">
				<cfinvokeargument name="objectFile" value="#objectFile#">
			</cfinvoke>
			
			<!---<cfquery name="selectFileQuery" datasource="#client_dsn#">		
				SELECT *
				FROM #client_abb#_files
				WHERE id=<cfqueryPARAM value = "#file_id#" CFSQLType = "CF_SQL_integer">;
			</cfquery>
			<cfif #selectFileQuery.recordCount# GT 0>
				<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="objectFile" returnvariable="xmlResult">
						<cfinvokeargument name="id" value="#selectFileQuery.id#">
						<cfinvokeargument name="physical_name" value="#selectFileQuery.physical_name#">		
						<cfinvokeargument name="user_in_charge" value="#selectFileQuery.user_in_charge#">		
						<cfinvokeargument name="file_size" value="#selectFileQuery.file_size#">
						<cfinvokeargument name="file_type" value="#selectFileQuery.file_type#">
						<cfinvokeargument name="uploading_date" value="#selectFileQuery.uploading_date#">
						<cfinvokeargument name="replacement_date" value="#selectFileQuery.replacement_date#">
						<cfinvokeargument name="name" value="#selectFileQuery.name#">
						<cfinvokeargument name="file_name" value="#selectFileQuery.file_name#">
						<cfinvokeargument name="description" value="#selectFileQuery.description#">
						<cfinvokeargument name="return_type" value="xml">
				</cfinvoke>
			<cfelse><!---File does not exist--->
				<cfset error_code = 601>
				<cfthrow errorcode="#error_code#">
			</cfif>--->
			
			<cfset xmlResponseContent = xmlResult>
			
			<cfinclude template="#APPLICATION.componentsPath#/includes/functionEndNoLog.cfm">
			
		<cfelse><!---File does not exist--->
		
			<cfset error_code = 601>
			
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