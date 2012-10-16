<cfprocessingdirective suppresswhitespace="true">
<cfsilent>
<!---Copyright Era7 Information Technologies 2007-2009

    Date of file creation: 30-01-2009
    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 27-04-2010
	
	Esta página se utiliza para la subida de archivos en la versión Flex.
	
	En la última modificación se ha cambiado el procedimiento para que se pueda reemplazar un archivo
	que al ser subido anteriormente para reemplazarse no se ha completado la subida correctamente y ha quedado erróneo.
	
--->
<cftry>	
	<cfset component = "myFilesReplaceFileTicket">
	<cfset method = "myFilesReplaceFileTicket">
	
	<cfif isDefined("FORM.user_id") AND isDefined("FORM.client_abb") AND isDefined("FORM.language") AND isDefined("FORM.session_id")>
	
		<cfset user_id = FORM.user_id>
		<cfset client_abb = FORM.client_abb>
		<cfset user_language = FORM.language>
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
		
	<cfif #getSessionidQuery.recordCount# GT 0 AND #getSessionidQuery.session_id# EQ #FORM.session_id#>
		
		<cfset destination = '#APPLICATION.filesPath#/#client_abb#/'>
		
		<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="objectFile" returnvariable="objectFile">
			
			<cfinvokeargument name="return_type" value="object">
		</cfinvoke>
		
		<cfif isDefined("FORM.file")>
		
			<cfset xml="#FORM.file#">
			
			<cfxml variable="fileXml">
				<cfoutput>
					#xml#
				</cfoutput>
			</cfxml>
			
			<cfset objectFile.id = fileXml.file.xmlAttributes.id>
		
		<cfelseif isDefined("FORM.file_id") AND isValid("integer",FORM.file_id)>
			
			<cfset objectFile.id = FORM.file_id>
			
		<cfelse><!---No value given for one or more required parameters--->

			<cfset error_code = 610>
			
			<cfthrow errorcode="#error_code#">
			
		</cfif>
		
		
		<!---<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="objectFile" returnvariable="objectFile">
			<cfinvokeargument name="xml" value="#fileXml.file#">
			<cfinvokeargument name="return_type" value="object">
		</cfinvoke>--->
		
		<!---Se obtienen los valores directamente de base de datos--->
		<cfquery name="getFile" datasource="#client_dsn#">
			SELECT *
			FROM #client_abb#_files
			WHERE id=<cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">
			AND user_in_charge = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
		</cfquery>
	
		<cfif getFile.recordCount GT 0>
			
			<cfif getFile.status NEQ "canceled">
				
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
				
				<!---<cfquery name="updateStateUploadingFile" datasource="#client_dsn#">
					UPDATE #client_abb#_files
					SET status = 'uploading',
					status_replacement = 'uploading'
					WHERE id=<cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">;
				</cfquery>--->
									
				<cffile action="upload" filefield="Filedata" destination="#destination#" nameconflict="overwrite" result="uploadedFile">
				
				<cfset objectFile.file_name = "#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#">
				<cfset objectFile.file_type = lCase(".#uploadedFile.clientFileExt#")>
				<cfset objectFile.file_size_full = "#uploadedFile.fileSize#">
				
				<cfset temp_file="#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#">
				
				
				<cftry>
					
					<!---<cfif fileExists("#destination#files/#getFile.physical_name#")>
						<cffile action="delete" file="#destination#files/#getFile.physical_name#">
					</cfif>--->
					
					<!---IMPORTANTE: No se puede utilizar move o rename en lugar de copy porque en esta versión de Railo tienen un bug que impiden realizar la acción en ciertos casos. Parece ser que el bug es debido a que internamente se llama a fileExists para comprobar si existe el archivo de destino y por esa acción este queda bloqueado y no permite sobreescribirlo.--->
					
					<cffile action="copy" source="#destination##temp_file#" destination="#destination#files/#getFile.physical_name#" nameconflict="overwrite">
					
					<cffile action="delete" file="#destination##temp_file#">
					
				
					<cfcatch><!---The upload fail--->
						
						<!---No se marca como erróneo para que el usuario tenga acceso al archivo y pueda reemplazarlo--->
						<!---<cfquery datasource="#client_dsn#" name="changeFileStatus">
							UPDATE #client_abb#_files
							SET status = 'error'
							WHERE id = <cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">
						</cfquery>--->
						
						<cfset error_code = 604>
				
						<cfthrow errorcode="#error_code#">
					
					</cfcatch>
				</cftry>
				
				
				<!---<cfquery name="beginQuery" datasource="#client_dsn#">
					BEGIN;
				</cfquery>--->
				<cftransaction>
				
					<cfquery name="updateUploadingFile" datasource="#client_dsn#">
						UPDATE #client_abb#_files
						SET replacement_date = <cfqueryparam value="#current_date#" cfsqltype="cf_sql_timestamp">, 
						file_size = <cfqueryparam value="#objectFile.file_size_full#" cfsqltype="cf_sql_integer">,
						file_type = <cfqueryparam value="#objectFile.file_type#" cfsqltype="cf_sql_varchar">,
						file_name = <cfqueryparam value="#objectFile.file_name#" cfsqltype="cf_sql_varchar">,
						status = <cfqueryparam value="ok" cfsqltype="cf_sql_varchar">,
						status_replacement = <cfqueryparam value="uploaded" cfsqltype="cf_sql_varchar">
						WHERE id=<cfqueryparam value="#objectFile.id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
					<!--- ------------------ Update User Space Used --------------------- --->
					<cfquery name="updateSpaceUsed" datasource="#client_dsn#">
						UPDATE #client_abb#_users
						SET space_used = space_used-#getFile.file_size#+<cfqueryparam value="#objectFile.file_size_full#" cfsqltype="cf_sql_integer">
						WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
				
				</cftransaction>
				<!---<cfquery name="endQuery" datasource="#client_dsn#">
					COMMIT;
				</cfquery>--->
	
				
				<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="xmlFile" returnvariable="xmlResult">
					<cfinvokeargument name="objectFile" value="#objectFile#">
				</cfinvoke>
				
				<cfset xmlResponseContent = xmlResult>
				
			<cfelse><!---Status=canceled--->
			
				<cfset xmlResponseContent = '<file status="canceled"/>'>
			
			</cfif>					
		
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