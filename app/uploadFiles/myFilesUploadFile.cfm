<cfprocessingdirective suppresswhitespace="true">
<cfsilent>
<!---Copyright Era7 Information Technologies 2007-2008

    File created by: ppareja
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 13-01-2009
	
	Esta página se utiliza para la subida de archivos en la versión HTML
	
--->
<cftry>			
	<cfset component = "myFilesUploadFile">
	<cfset method = "myFilesUploadFile">
	<!---<cfinclude template="#APPLICATION.componentsPath#/includes/sessionVars.cfm">--->	
	<!---<cfinvoke component="#APPLICATION.componentsPath#/LoginManager" method="getUserLoggedIn" returnvariable="xmlUser">
	</cfinvoke>--->
	<!---<cfxml variable="xmlUser">
		#user.response.result.user#
	</cfxml>--->
	
	<!---<cfset user_id = xmlUser.response.result.user.xmlAttributes.id>
	<cfset client_abb = xmlUser.response.result.user.xmlAttributes.client_abb>
	<cfset user_language = xmlUser.response.result.user.xmlAttributes.language>--->
	
	<cfif isDefined("URL.user_id") AND isDefined("URL.client_abb") AND isDefined("URL.language") AND isDefined("URL.session_id")><!---AND isDefined("URL.folder_id") Si URL.folder_id no viene definido es porque se asocia directamente desde área--->
	
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
		
	<cfif getSessionidQuery.recordCount GT 0 AND getSessionidQuery.session_id EQ URL.session_id>
		
		<cfset destination = '#APPLICATION.filesPath#/#client_abb#/files/'>
		
		<cfif isDefined("URL.file")>
		
			<cfset xml="#URL.file#">
			
			<cfxml variable="fileXml">
				<cfoutput>
					#xml#
				</cfoutput>
			</cfxml>
		
		<cfelseif isDefined("FORM.name") AND isDefined("FORM.description")>
			
			<cfxml variable="fileXml">
				<cfoutput>
				<file>
					<name><![CDATA[#FORM.name#]]></name>
					<description><![CDATA[#FORM.description#]]></description>
				</file>
				</cfoutput>
			</cfxml>
			
		<cfelse><!---No value given for one or more required parameters--->

			<cfset error_code = 610>
			
			<cfthrow errorcode="#error_code#">
			
		</cfif>
		
		<cfif isDefined("fileXml.file.name.xmlText") AND 
			  isDefined("fileXml.file.description.xmlText")>
				
			<!---
			isDefined("fileXml.file.file_name.xmlText") AND isDefined("fileXml.file.XmlAttributes.file_size") AND isDefined("fileXml.file.XmlAttributes.file_type") AND--->
			
			<cfif NOT isDefined("URL.folder_id")>
				<!---Esto para la asociación de archivos directamente desde las áreas--->
				<cfinvoke component="#APPLICATION.componentsPath#/FolderManager" method="getUserRootFolderId" returnvariable="root_folder_id">
				</cfinvoke>		
				
				<cfset folder_id = root_folder_id>
				
			<cfelse>
				<cfset folder_id = URL.folder_id>
			</cfif>
			
				
			<cffile action="upload" filefield="Filedata" destination="#destination#" nameconflict="overwrite" result="uploadedFile">
			
			<cfset temp_file="#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#">	
			
			<cfsavecontent variable="xmlRequest">
				<cfoutput>
				<request>
					<parameters>
					<file file_size="#uploadedFile.fileSize#" file_type=".#uploadedFile.clientFileExt#">
						<name><![CDATA[#fileXml.file.name.xmlText#]]></name>
						<file_name><![CDATA[#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#]]></file_name>
						<description><![CDATA[#fileXml.file.description.xmlText#]]></description>
					</file>
					<folder id="#folder_id#"/>
					</parameters>
				</request>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="createFile" returnvariable="result">
				<cfinvokeargument name="request" value="#xmlRequest#">
				<cfinvokeargument name="status" value="ok">
				<cfinvokeargument name="user_id" value="#user_id#">
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="user_language" value="#user_language#">
				<!---Este metodo necesita recibir las variables como argumentos porque cuando se suben archivos desde Firefox no se puede acceder a las variables de sesion--->	
			</cfinvoke>	
			
			<cfxml variable="xmlResultFile">
				<cfoutput>
					#result#
				</cfoutput>
			</cfxml>
			
			<cfif xmlResultFile.response.xmlAttributes.status EQ "ok">
				
				<cftry>
					
					<cfset upload_file_id = xmlResultFile.response.result.file.XmlAttributes.id>		
					
					<cffile action="rename" source="#destination##temp_file#" 
							destination="#destination##upload_file_id#">
							
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
								SET status = 'failed'
								WHERE id = <cfqueryparam value="#upload_file_id#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>
						
						<!---<cfset error_code = 604>--->
				
						<cfthrow object="#cfcatch#">
					
					</cfcatch>
				</cftry>
							
				
				<cfset xmlResultFile.response.xmlAttributes.component = component>
				<cfset xmlResultFile.response.xmlAttributes.method = method>
					
				<cfset xmlResponse = xmlResultFile>
			
				
			<cfelse><!---File insert fail--->
			
				<cffile action="delete" file="#destination##temp_file#">
			
				<cfset xmlResponseContent = xml>
				<cfset error_code = 602>
				
				<cfthrow errorcode="#error_code#">
			
			</cfif>
			

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