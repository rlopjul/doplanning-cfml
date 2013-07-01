<!---Copyright Era7 Information Technologies 2007-2009

	Date of file creation: 04-11-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 15-07-2009
	
--->
<cfcomponent output="false">
	
	<cfset component = "FolderManager">
	
	<!--- ----------------------- XML FOLDER -------------------------------- --->
	
	<cffunction name="xmlFolder" returntype="string" output="false" access="public">		
		<cfargument name="objectFolder" type="struct" required="yes">
		
		<cfset var method = "xmlFolder">
		
		<cftry>
			 
			<cfsavecontent variable="xmlResult">
				<cfoutput>
					<folder id="#objectFolder.id#"
						 parent_id="#objectFolder.parent_id#"
						 user_in_charge="#objectFolder.user_in_charge#"
						 creation_date="#objectFolder.creation_date#">
						<name><![CDATA[#objectFolder.name#]]></name>	
						<description><![CDATA[#objectFolder.description#]]></description>	
					</folder>
				</cfoutput>
			</cfsavecontent>
			
			<cfreturn xmlResult>
		
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
				<cfreturn null>
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	
	<!--- ----------------------- FOLDER OBJECT -------------------------------- --->
	
	<cffunction name="objectFolder" returntype="any" output="false" access="public">	
		
		<cfargument name="xml" type="string" required="no">
		
		<cfargument name="id" type="string" required="no" default="">
		<cfargument name="parent_id" type="string" required="no" default="">		
		<cfargument name="user_in_charge" type="string" required="no" default="">		
		<cfargument name="creation_date" type="string" required="no" default="">
		<cfargument name="name" type="string" required="no" default="">
		<cfargument name="description" type="string" required="no" default="">
		
		<cfargument name="return_type" type="string" required="no">
		
		<cfset var method = "objectFolder">
		
		<cftry>
			
			<cfif isDefined("arguments.xml")>
			
				<cfxml variable="xmlFolder">
				<cfoutput>
				#arguments.xml#
				</cfoutput>
				</cfxml>
				
				<cfif isDefined("xmlFolder.folder.XmlAttributes.id")>
					<cfset id = xmlFolder.folder.XmlAttributes.id>
				</cfif>
				<cfif isDefined("xmlFolder.folder.XmlAttributes.parent_id")>
					<cfset parent_id = xmlFolder.folder.XmlAttributes.parent_id>
				</cfif>
				<cfif isDefined("xmlFolder.folder.XmlAttributes.user_in_charge")>
					<cfset user_in_charge = xmlFolder.folder.XmlAttributes.user_in_charge>
				</cfif>
				<cfif isDefined("xmlFolder.folder.XmlAttributes.creation_date")>
					<cfset creation_date = xmlFolder.folder.XmlAttributes.creation_date>
				</cfif>
				<cfif isDefined("xmlFolder.folder.name")>
					<cfset name = xmlFolder.folder.name.xmlText>
				</cfif>
				<cfif isDefined("xmlFolder.folder.description")>
					<cfset description = xmlFolder.folder.description.xmlText>
				</cfif>
			
			</cfif>
					
			<cfset object = {
				id="#id#",
				parent_id="#parent_id#",
				user_in_charge="#user_in_charge#",
				creation_date="#creation_date#",
				name="#name#",
				description="#description#"
				}>
			
			<cfif isDefined("arguments.return_type")>
			
				<cfif arguments.return_type EQ "object">
				
					<cfreturn object>
					
				<cfelseif arguments.return_type EQ "xml">
				
					<cfinvoke component="FolderManager" method="xmlFolder" returnvariable="xmlResult">
						<cfinvokeargument name="objectFolder" value="#object#">
					</cfinvoke>
					<cfreturn xmlResult>
					
				<cfelse>
					
					<cfreturn object>
					
				</cfif>
				
			<cfelse>
			
				<cfreturn object>
				
			</cfif>
			
		
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
				<cfreturn null>
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	
	<!--- ---------------------------- getUserRootFolderId ---------------------------------- --->
	
	<cffunction name="getUserRootFolderId" returntype="numeric" access="public">
		
		<cfset var method = "getUserRootFolderId">
		
		<cfset var root_folder_id = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfquery name="getRootFolderId" datasource="#client_dsn#">
				SELECT root_folder_id 
				FROM #client_abb#_users
				WHERE id = <cfqueryPARAM value = "#user_id#" CFSQLType = "CF_SQL_varchar">;
			</cfquery>
			
			<cfif #getRootFolderId.recordCount# GT 0 AND isValid("integer",getRootFolderId.root_folder_id)>
			
				<cfset root_folder_id = getRootFolderId.root_folder_id>
				
			<cfelse><!---The root folder id is not found or incorrect--->
				
				<cfset error_code = 702>
				
				<cfthrow errorcode="#error_code#">
			
			</cfif>
		
		<cfreturn root_folder_id>
		
	</cffunction>
	
	
	<!--- -------------------------------- getFolderContent ------------------------------ --->
	
	<cffunction name="getFolderContent" output="false" returntype="string" access="public">
		<cfargument name="folder_id" type="String" required="true">
		<cfargument name="withSubFolders" type="boolean" required="false" default="true">
		<cfargument name="withSubSubFolders" type="boolean" required="false" default="true">
		<cfargument name="withSubFoldersFiles" type="boolean" required="false" default="true">
		
		<cfset var method = "getFolderContent">
		
		<cfset var xmlPart = "">
		<cfset var xmlFoldersResult = "">
		<cfset var xmlFilesResult = "">
		<cfset var nameXml = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
		
			
			<cfinclude template="includes/functionStart.cfm">
										
			<cfinvoke component="FolderManager" method="getFolder" returnvariable="objectFolder">
				<cfinvokeargument name="get_folder_id" value="#arguments.folder_id#">
				<cfinvokeargument name="return_type" value="object">
			</cfinvoke>
			
			<!---checkUserAccess--->
			<cfif objectFolder.user_in_charge NEQ user_id>
				<cfset error_code = 103>
				
				<cfthrow errorcode="#error_code#">	
			</cfif>	
					
			<cfset nameXml = xmlFormat(objectFolder.name)>
			<cfset xmlPart='<folder id="#objectFolder.id#" parent_id="#objectFolder.parent_id#" name="#nameXml#">'>
				
			<cfif withSubFolders EQ true>
			
				<!--- Sub folders --->							
				<cfinvoke component="FolderManager" method="getFolderFolders" returnvariable="xmlFoldersResult">
					<cfinvokeargument name="folder_id" value="#arguments.folder_id#">
					<cfinvokeargument name="withSubSubFolders" value="#arguments.withSubSubFolders#">
					<cfinvokeargument name="withFiles" value="#arguments.withSubFoldersFiles#">								
				</cfinvoke>
			
				<cfset xmlPart = xmlPart&xmlFoldersResult>		
				
			</cfif>							
			
			
			<!--- Folder Files --->							
			<cfinvoke component="FolderManager" method="getFolderFiles" returnvariable="xmlFilesResult">
				<cfinvokeargument name="folder_id" value="#arguments.folder_id#">							
			</cfinvoke>
			
			<cfset xmlPart = xmlPart&xmlFilesResult>			
		
			
			<cfset xmlPart=xmlPart&'</folder>'>				
			
			<cfset xmlResponse = xmlPart>
		
		
		<cfreturn xmlResponse>	
		
	</cffunction>
	
	<!--- -------------------------------- getFolderFolders ------------------------------ --->
	
	<cffunction name="getFolderFolders" output="false" returntype="string" access="public">
		<cfargument name="folder_id" type="String" required="true">
		<cfargument name="withSubSubFolders" type="boolean" required="true">
		<cfargument name="withFiles" type="boolean" required="true">
		
		<cfset var method = "getFolderFolders">
		
		<cfset var xmlPart = "">
		<cfset var xmlFoldersResult = "">
		<cfset var xmlFilesResult = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
		
			<cfinclude template="includes/functionStart.cfm">
			
			<cfquery name="subFoldersQuery" datasource="#client_dsn#">
				SELECT id, parent_id, name
				FROM #client_abb#_folders
				WHERE parent_id = <cfqueryparam value="#arguments.folder_id#" cfsqltype="cf_sql_integer">
				AND user_in_charge = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
				ORDER BY name ASC;
			</cfquery>
			
			<!--- Appending sub folders content in the case where there are sub folders --->
			<cfif subFoldersQuery.recordCount GT 0>	
					
				<cfloop query="subFoldersQuery">	
					
					<cfset nameXml = xmlFormat(subFoldersQuery.name)>
				
					<cfset xmlPart=xmlPart&'<folder id="#subFoldersQuery.id#" parent_id="#subFoldersQuery.parent_id#" name="#nameXml#">'>			
					
					<cfif arguments.withSubSubFolders IS true>
					
						<!--- Sub folders --->					
						<cfinvoke component="FolderManager" method="getFolderFolders" returnvariable="xmlFoldersResult">
							<cfinvokeargument name="folder_id" value="#subFoldersQuery.id#">
							<cfinvokeargument name="withSubSubFolders" value="true">
							<cfinvokeargument name="withFiles" value="#arguments.withFiles#">								
						</cfinvoke>
					
						<cfset xmlPart = xmlPart&xmlFoldersResult>
					
					</cfif>	
					
					<cfif arguments.withFiles IS true>
					
						<!--- Folder Files --->							
						<cfinvoke component="FolderManager" method="getFolderFiles" returnvariable="xmlFilesResult">
							<cfinvokeargument name="folder_id" value="#subFoldersQuery.id#">							
						</cfinvoke>
					
						<cfset xmlPart = xmlPart&xmlFilesResult>
					
					</cfif>
					
					<cfset xmlPart = xmlPart&'</folder>'>	
									
				</cfloop>			
			</cfif>						
			
			<cfset xmlResponse = xmlPart>
		
		
		<cfreturn xmlResponse>	
		
	</cffunction>
	
	
	<!--- -------------------------------- getFolderFiles ------------------------------ --->
	
	<cffunction name="getFolderFiles" output="false" returntype="string" access="public">
		<cfargument name="folder_id" type="String" required="true">		
		
		<cfset var method = "getFolderFiles">
		
		<cfset var xmlPart = "">
		<cfset var xmlFilePart = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
		
			<cfinclude template="includes/functionStart.cfm">
			
			<!--- Folder files --->
			<cfquery name="getFolderFiles" datasource="#client_dsn#">
				SELECT f.id, f.name, f.file_size, f.uploading_date, f.replacement_date, f.file_type
				FROM #client_abb#_folders_files AS ff, #client_abb#_files AS f
				WHERE ff.folder_id = <cfqueryparam value="#arguments.folder_id#" cfsqltype="cf_sql_integer">
				AND ff.file_id = f.id AND f.status='ok'
				ORDER BY f.name ASC;
			</cfquery>
			
			<cfloop query="getFolderFiles">
				
				<cfinvoke component="FileManager" method="objectFile" returnvariable="xmlFilePart">
						<cfinvokeargument name="id" value="#getFolderFiles.id#">	
						<cfinvokeargument name="file_size" value="#getFolderFiles.file_size#">
						<cfinvokeargument name="file_type" value="#getFolderFiles.file_type#">
						<cfinvokeargument name="uploading_date" value="#getFolderFiles.uploading_date#">
						<cfinvokeargument name="replacement_date" value="#getFolderFiles.replacement_date#">
						<cfinvokeargument name="name" value="#getFolderFiles.name#">
						
						<cfinvokeargument name="tree_mode" value="true">
						
						<cfinvokeargument name="return_type" value="xml">
				</cfinvoke>
				
				<cfset xmlPart = xmlPart&xmlFilePart>
				
			</cfloop>
				
		<cfset xmlResponse = xmlPart>
		
		<cfreturn xmlResponse>	
		
	</cffunction>
	
	
		
	<!--- --------------------------------------------------------------------------- --->
	<!--- ------------------------------FOLDERS-------------------------------------- --->
	<!--- --------------------------------------------------------------------------- --->

	<!--- ----------------------- CREATE FOLDER -------------------------------- --->
	
	<cffunction name="createFolder" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
		<!---<cfargument name="folder" type="string" required="yes">--->			
		
		<cfset var method = "createFolder">
		
		<cfset var folder = "">
		
		<cfset var folderSequence = "">
		<cfset var folderXml = "">
	
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset folder = xmlRequest.request.parameters.folder>
						
			<cfxml variable="folderXml">
				<cfoutput>
				#folder#
				</cfoutput>
			</cfxml>
			
			<cfif isDefined("folderXml.folder.name") AND	
				isDefined("folderXml.folder.XmlAttributes.parent_id")>
				
				<cfinvoke component="FolderManager" method="objectFolder" returnvariable="objectFolder">
					<cfinvokeargument name="xml" value="#folderXml#">
				</cfinvoke>
		
				<cfquery name="beginQuery" datasource="#client_dsn#">
					BEGIN;
				</cfquery>
				
				<cfinvoke component="DateManager" method="getCurrentDateTime" returnvariable="current_date">
				</cfinvoke>
				
				<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringCurrentDate">
					<cfinvokeargument name="timestamp_date" value="#current_date#">
				</cfinvoke>
				
				<cfset objectFolder.user_in_charge = user_id>
				<cfset objectFolder.creation_date = stringCurrentDate>
				
				<cfquery name="createQuery" datasource="#client_dsn#" result="createQueryResult">
					INSERT 
					INTO #client_abb#_folders (name,user_in_charge,parent_id,description,creation_date) 
					VALUES(<cfqueryPARAM value = "#objectFolder.name#" CFSQLType="CF_SQL_varchar">,
						<cfqueryPARAM value = "#objectFolder.user_in_charge#" CFSQLType="cf_sql_integer">,
						<cfqueryPARAM value = "#objectFolder.parent_id#" CFSQLType="CF_SQL_integer">,
						<cfqueryPARAM value = "#objectFolder.description#" CFSQLType="CF_SQL_varchar">,
						<cfqueryparam value="#current_date#" cfsqltype="cf_sql_timestamp">
						);
				</cfquery>
				<!---<cfset objectFolder.id = createQueryResult.GENERATED_KEY>--->
				<cfquery name="getLastInsertId" datasource="#client_dsn#">
					SELECT LAST_INSERT_ID() AS last_insert_id FROM #client_abb#_folders;
				</cfquery>
				<cfset objectFolder.id = getLastInsertId.last_insert_id>
				
				<cfquery name="endQuery" datasource="#client_dsn#">
					COMMIT;
				</cfquery>	
				

				<cfinvoke component="FolderManager" method="xmlFolder" returnvariable="xmlResponseContent">
					<cfinvokeargument name="objectFolder" value="#objectFolder#">
				</cfinvoke>
				
			<cfelse><!---Falta alguno de los parámetros requeridos--->
				<cfset error_code = 705>
			
				<cfthrow errorcode="#error_code#">
			</cfif>
		
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>		
		
	</cffunction>

	
	<!--- ----------------------- getFolder -------------------------------- --->
	
	<cffunction name="getFolder" returntype="any" output="false" access="public">		
		<cfargument name="get_folder_id" type="string" required="yes">
		<cfargument name="return_type" type="string" required="no" default="xml">
		
		<cfset var folder_id = arguments.get_folder_id>
		
		<cfset var method = "getFolder">
	
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfquery name="selectFolderQuery" datasource="#client_dsn#">		
				SELECT *
				FROM #client_abb#_folders
				WHERE id=<cfqueryparam value="#folder_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif selectFolderQuery.recordCount GT 0>
			
				<cfinvoke component="FolderManager" method="objectFolder" returnvariable="resultFolder">
					<cfinvokeargument name="id" value="#selectFolderQuery.id#">
					<cfinvokeargument name="parent_id" value="#selectFolderQuery.parent_id#">
					<cfinvokeargument name="user_in_charge" value="#selectFolderQuery.user_in_charge#">
					<cfinvokeargument name="creation_date" value="#selectFolderQuery.creation_date#">
					<cfinvokeargument name="name" value="#selectFolderQuery.name#">
					<cfinvokeargument name="description" value="#selectFolderQuery.description#">
					
					<cfinvokeargument name="return_type" value="#arguments.return_type#">
				</cfinvoke>	
				
				<cfset xmlResponse = resultFolder>
				
			<cfelse><!---Folder does not exist--->
			
				<cfset error_code = 701>
			
				<cfthrow errorcode="#error_code#">
				
			</cfif>			
			
			
		<cfreturn xmlResponse>		
		
	</cffunction>
	
	
	<!--- ----------------------- SELECT FOLDER -------------------------------- --->
	
	<cffunction name="selectFolder" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "selectFolder">
		
		<cfset var folder_id = "">
	
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset folder_id = xmlRequest.request.parameters.folder.xmlAttributes.id>
		
			<cfinvoke component="FolderManager" method="getFolder" returnvariable="xmlResponseContent">
				<cfinvokeargument name="get_folder_id" value="#folder_id#">
				
				<cfinvokeargument name="return_type" value="xml">
			</cfinvoke>		
			
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>		
		
	</cffunction>
	
	
	<!--- _______________________UPDATE FOLDER_________________________________________  --->
	
	<cffunction name="updateFolder" returntype="string" output="false" access="public">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "updateFolder">
		
		<cfset var folder = "">
		<cfset var folderXml = "">
	
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">		
			
			<cfset folder = xmlRequest.request.parameters.folder>
			<cfxml variable="folderXml">
				<cfoutput>
					#folder#
				</cfoutput>
			</cfxml>			
			
			<cfquery name="beginQuery" datasource="#client_dsn#">
				BEGIN;
			</cfquery>
					
			<cfif isDefined("folderXml.folder.name.xmlText")>
				<cfquery name="nameQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_folders SET name = <cfqueryPARAM value = "#folderXml.folder.name.xmlText#" CFSQLType = "CF_SQL_varchar">
					WHERE id = <cfqueryPARAM value = "#folderXml.folder.XmlAttributes.id#" CFSQLType = "CF_SQL_integer">;
				</cfquery>
			</cfif>
			<cfif isDefined("folderXml.folder.XmlAttributes.parent_id")>
				<cfquery name="parentIdQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_folders SET parent_id = <cfqueryPARAM value = "#folderXml.folder.XmlAttributes.parent_id#" CFSQLType = "CF_SQL_integer">
					WHERE id = <cfqueryPARAM value = "#folderXml.folder.XmlAttributes.id#" CFSQLType = "CF_SQL_integer">;
				</cfquery>
			</cfif>
			
			<cfif isDefined("folderXml.folder.description.xmlText")>
				<cfset desc = "#folderXml.folder.description.xmlText#">
				<cfset desc = '#replace(desc,"<![CDATA[","","all")#'>
				<cfset desc = '#replace(desc,"]]>","","all")#'>
				<cfquery name="descriptionQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_folders SET description = <cfqueryPARAM value = "#desc#" CFSQLType = "CF_SQL_varchar">
					WHERE id = <cfqueryPARAM value = "#folderXml.folder.XmlAttributes.id#" CFSQLType = "CF_SQL_integer">;
				</cfquery>
			</cfif>	
			
			<cfquery name="commitQuery" datasource="#client_dsn#">
				COMMIT;
			</cfquery>			
			
			<!---Tiene que obtenerlo de base de datos porque el que viene en el xml
			no está completo y solo trae lo que se modifica--->
			<cfinvoke component="FolderManager" method="getFolder" returnvariable="xmlResponseContent">
				<cfinvokeargument name="get_folder_id" value="#folderXml.folder.XmlAttributes.id#">
				
				<cfinvokeargument name="return_type" value="xml">
			</cfinvoke>	
			
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	<!--- _____________________________________________________________________________  --->
	
	
	<!--- ----------------------- DELETE FOLDER -------------------------------- --->
	
	<cffunction name="deleteFolder" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
		<!---<cfargument name="folder_id" type="string" required="yes">--->
		
		<cfset var method = "deleteFolder">
		
		<cfset var folder_id = "">
	
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset folder_id = xmlRequest.request.parameters.folder.xmlAttributes.id>
					
			<cfquery name="beginQuery" datasource="#client_dsn#">
				BEGIN;
			</cfquery>
			
			<!--- ----------------------------DELETE FOLDER FILES----------------------------------- --->
			<cfquery name="filesQuery" datasource="#client_dsn#">
				SELECT file_id 
				FROM #client_abb#_folders_files 
				WHERE folder_id = <cfqueryPARAM value = "#folder_id#" CFSQLType = "CF_SQL_integer">;
			</cfquery>
			<cfif filesQuery.recordCount GT 0>
				<cfloop query="filesQuery">
					<cfinvoke component="FileManager" method="deleteFile">
						<cfinvokeargument name="request" value='<request><parameters><file id="#filesQuery.file_id#"/></parameters></request>'>
					</cfinvoke>
				</cfloop>
			</cfif>
			<!--- --------------------------------------------------------------------------------- --->
			
			<!--- ------------------------------DELETE SUB FOLDERS--------------------------------- --->
			<cfquery name="subFoldersQuery" datasource="#client_dsn#">
				SELECT id
				FROM #client_abb#_folders 
				WHERE parent_id = <cfqueryPARAM value = "#folder_id#" CFSQLType = "CF_SQL_integer">;
			</cfquery>
			<cfif subFoldersQuery.recordCount GT 0>
				<cfloop query="subFoldersQuery">
					<cfinvoke component="FolderManager" method="deleteFolder">
						<cfinvokeargument name="request" value='<request><parameters><folder id="#subFoldersQuery.id#"/></parameters></request>'>
					</cfinvoke>
				</cfloop>
			</cfif>
			<!--- ---------------------------------------------------------------------------------- --->
			
			<!--- ------------------------------DELETE FOLDER--------------------------------------- --->
			<cfquery name="deleteFolderQuery" datasource="#client_dsn#">
				DELETE 
				FROM #client_abb#_folders
				WHERE id = <cfqueryPARAM value = "#folder_id#" CFSQLType = "CF_SQL_integer">;
			</cfquery>			
			<!--- ---------------------------------------------------------------------------------- --->
			
			<cfquery name="beginQuery" datasource="#client_dsn#">
				COMMIT;
			</cfquery>
			
			<cfsavecontent variable="xmlResult">
				<cfoutput>
				<folder id="#folder_id#" />
				</cfoutput>
			</cfsavecontent>
			
			<cfset xmlResponseContent = xmlResult>
		
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
	
	<cfreturn xmlResponse>		
		
	</cffunction>
	
	<!--- --------------------------------------------------------------------------- --->
	<!--- --------------------------------------------------------------------------- --->
	
	
</cfcomponent>