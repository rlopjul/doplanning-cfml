<!---Copyright Era7 Information Technologies 2007-2013

    File created by: ppareja
    ColdFusion version required: 8
    Last file change by: alucena
	
	15-04-2013 alucena: corregido error en deleteFile con archivos con status que no es ok
	13-06-2013 alucena: corregido error con variable files_table (se utilizaba file_table) en deleteImageFile
	
--->
<cfcomponent output="false">	

	<cfset component = "FileManager">
	
	<cfset messageTypeId = 1>
	<cfset fileItemTypeId = 10>
	<cfset typologyTableTypeId = 3>
	
	<!--- ----------------------- XML FILE -------------------------------- --->
	
	<cffunction name="xmlFile" returntype="string" output="false" access="public">		
		<cfargument name="objectFile" type="struct" required="yes">
		
		<cfset var method = "xmlFile">
		
		<cftry>
		
			<cfprocessingdirective suppresswhitespace="true">
			<cfsavecontent variable="xmlResult">
				<cfoutput><file
					<cfif len(objectFile.id) GT 0> 
						id="#objectFile.id#"
					</cfif>
					<cfif objectFile.tree_mode EQ "true">
						name="#xmlFormat(objectFile.name)#"
					</cfif> 
					<cfif len(objectFile.physical_name) GT 0>
						physical_name="#xmlFormat(objectFile.physical_name)#"
					</cfif>
					<cfif len(objectFile.user_in_charge) GT 0> 
						user_in_charge="#objectFile.user_in_charge#" 
					</cfif>
					<cfif len(objectFile.file_size_full) GT 0>
						file_size_full="#objectFile.file_size_full#"
					</cfif>
					<!---<cfif len(objectFile.file_size_kb) GT 0>
						file_size_kb="#objectFile.file_size_kb#"
					</cfif>--->
					<cfif len(objectFile.file_size) GT 0>
						file_size="#objectFile.file_size#"
					</cfif>
					<cfif len(objectFile.file_type) GT 0> 
						file_type="#objectFile.file_type#"
					</cfif>
					<cfif len(objectFile.uploading_date) GT 0>
						uploading_date="#objectFile.uploading_date#"
					</cfif>
					<cfif len(objectFile.replacement_date) GT 0>
						replacement_date="#objectFile.replacement_date#"
					</cfif>
					<cfif len(objectFile.association_date) GT 0>
						association_date="#objectFile.association_date#"
					</cfif>
					<cfif len(objectFile.status) GT 0>
						status="#objectFile.status#"
					</cfif>
					<cfif len(objectFile.area_id) GT 0>
						area_id="#objectFile.area_id#"
					</cfif>
					<cfif len(objectFile.user_image_type) GT 0>
						user_image_type="#objectFile.user_image_type#"
					</cfif>
					<cfif len(objectFile.typology_id) GT 0>
						typology_id="#objectFile.typology_id#"
					</cfif>
					<cfif len(objectFile.typology_row_id) GT 0>
						typology_row_id="#objectFile.typology_row_id#"
					</cfif>
					>
					<cfif objectFile.tree_mode NEQ "true">
						<cfif len(objectFile.name) GT 0>
						<name><![CDATA[#objectFile.name#]]></name>
						</cfif>
						<cfif len(objectFile.file_name) GT 0>
						<file_name><![CDATA[#objectFile.file_name#]]></file_name>
						</cfif>
						<cfif len(objectFile.description) GT 0>
						<description><![CDATA[#objectFile.description#]]></description>
						</cfif>
						<cfif len(objectFile.user_full_name) GT 0>
						<user_full_name><![CDATA[#objectFile.user_full_name#]]></user_full_name>
						</cfif>
						<cfif len(objectFile.area_name) GT 0>
						<area_name><![CDATA[#objectFile.area_name#]]></area_name>
						</cfif>
						<cfif isDefined("objectFile.file_types_conversion") AND objectFile.file_types_conversion.recordCount GT 0>
							<file_types_conversion>
								<cfloop query="objectFile.file_types_conversion">
									<file_type id="#objectFile.file_types_conversion.file_type#"><name_es><![CDATA[#objectFile.file_types_conversion.name_es#]]></name_es><name_en><![CDATA[#objectFile.file_types_conversion.name_en#]]></name_en></file_type>
								</cfloop>
							</file_types_conversion>
						</cfif> 
					</cfif>
					</file></cfoutput>
			</cfsavecontent>
			</cfprocessingdirective>
			
			<cfreturn xmlResult>
		
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
				<cfreturn null>
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	
	<!--- ----------------------- FILE OBJECT -------------------------------- --->
	
	<cffunction name="objectFile" returntype="any" output="false" access="public">	
		
		<cfargument name="xml" type="string" required="no">
		
		<cfargument name="id" type="string" required="no" default="">
		<cfargument name="physical_name" type="string" required="no" default="">		
		<cfargument name="user_in_charge" type="string" required="no" default="">		
		<cfargument name="file_size" type="string" required="no" default="">
		<cfargument name="file_type" type="string" required="no" default="">
		<cfargument name="uploading_date" type="string" required="no" default="">
		<cfargument name="replacement_date" type="string" required="no" default="">
		<cfargument name="association_date" type="string" required="no" default="">
		<cfargument name="name" type="string" required="no" default="">
		<cfargument name="file_name" type="string" required="no" default="">
		<cfargument name="description" type="string" required="no" default="">
		<cfargument name="user_full_name" type="string" required="no" default="">
		<cfargument name="status" type="string" required="no" default="">
		<cfargument name="area_id" type="string" required="no" default="">
		<cfargument name="area_name" type="string" required="no" default="">
		<cfargument name="user_image_type" type="string" required="no" default="">
		<cfargument name="typology_id" type="string" required="false" default="">
		<cfargument name="typology_row_id" type="string" required="false" default="">
		
		<cfargument name="file_types_conversion" type="query" required="no" default="#queryNew("")#">
		
		<cfargument name="tree_mode" type="boolean" required="no" default="false">
		
		<cfargument name="return_type" type="string" required="no">
		
		<cfset var method = "objectFile">
		
		<cfset var object = structNew()>
		
		<cftry>
			
			<cfif isDefined("arguments.xml")>
			
				<cfxml variable="xmlFile">
					<cfoutput>#arguments.xml#</cfoutput>
				</cfxml>
			
				<cfif isDefined("xmlFile.file.XmlAttributes.id")>
					<cfset id=xmlFile.file.XmlAttributes.id>
				</cfif>
				
				<cfif isDefined("xmlFile.file.XmlAttributes.physical_name")>
					<cfset physical_name=xmlFile.file.XmlAttributes.physical_name>
				</cfif>
				<cfif isDefined("xmlFile.file.XmlAttributes.user_in_charge")>
					<cfset user_in_charge=xmlFile.file.XmlAttributes.user_in_charge>
				</cfif>
				<cfif isDefined("xmlFile.file.XmlAttributes.file_size_full")>
					<cfset file_size_full=xmlFile.file.XmlAttributes.file_size_full>
				</cfif>
				<cfif isDefined("xmlFile.file.XmlAttributes.file_size")>
					<cfset file_size=xmlFile.file.XmlAttributes.file_size>
				</cfif>
				<cfif isDefined("xmlFile.file.XmlAttributes.file_type")>
					<cfset file_type=lCase(xmlFile.file.XmlAttributes.file_type)>
				</cfif>
				<cfif isDefined("xmlFile.file.XmlAttributes.uploading_date")>
					<cfset uploading_date=xmlFile.file.XmlAttributes.uploading_date>
				</cfif>
				<cfif isDefined("xmlFile.file.XmlAttributes.replacement_date")>
					<cfset replacement_date=xmlFile.file.XmlAttributes.replacement_date>
				</cfif>
				<cfif isDefined("xmlFile.file.XmlAttributes.association_date")>
					<cfset association_date=xmlFile.file.XmlAttributes.association_date>
				</cfif>
				<cfif tree_mode EQ true AND isDefined("xmlFile.file.XmlAttributes.name")>
					<cfset name=xmlFile.file.XmlAttributes.name>
				</cfif>
				<cfif tree_mode EQ true AND isDefined("xmlFile.file.XmlAttributes.typology_id")>
					<cfset typology_id=xmlFile.file.XmlAttributes.typology_id>
				</cfif>
				<cfif tree_mode EQ true AND isDefined("xmlFile.file.XmlAttributes.typology_row_id")>
					<cfset typology_row_id=xmlFile.file.XmlAttributes.typology_row_id>
				</cfif>
				<cfif isDefined("xmlFile.file.name")>
					<cfset name=xmlFile.file.name.xmlText>
				</cfif>
				<cfif isDefined("xmlFile.file.file_name")>
					<cfset file_name=xmlFile.file.file_name.xmlText>
				</cfif>
				<cfif isDefined("xmlFile.file.description")>
					<cfset description=xmlFile.file.description.xmlText>
				</cfif>
				<cfif isDefined("xmlFile.file.user_full_name")>
					<cfset user_full_name=xmlFile.file.user_full_name.xmlText>
				</cfif>
				<cfif isDefined("xmlFile.file.xmlAttributes.status")>
					<cfset status=xmlFile.file.xmlAttributes.status>
				</cfif>
				<cfif isDefined("xmlFile.file.xmlAttributes.area_id")>
					<cfset area_id=xmlFile.file.xmlAttributes.area_id>
				</cfif>
				<cfif isDefined("xmlFile.file.area_name")>
					<cfset area_name=xmlFile.file.area_name.xmlText>
				</cfif>
				<cfif isDefined("xmlFile.file.xmlAttributes.user_image_type")>
					<cfset user_image_type=xmlFile.file.xmlAttributes.user_image_type>
				</cfif>
				
			</cfif>
			
			<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringDateUpload">
				<cfinvokeargument name="timestamp_date" value="#uploading_date#">
			</cfinvoke>
			<cfset uploading_date = stringDateUpload>
			
			<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringDateReplace">
				<cfinvokeargument name="timestamp_date" value="#replacement_date#">
			</cfinvoke>
			<cfset replacement_date = stringDateReplace>
			
			<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringDateAssociation">
				<cfinvokeargument name="timestamp_date" value="#association_date#">
			</cfinvoke>
			<cfset association_date = stringDateAssociation>
			
			<!---file_size in kilobytes or megabytes--->
			<cfif NOT isDefined("file_size_full") AND len("#file_size#") GT 0>
				<cfset file_size_full = file_size><!---file_size_full is the file_size from database without parse to kilobytes--->
				
				<!---fileUrl--->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="trasnformFileSize" returnvariable="file_size">
					<cfinvokeargument name="file_size_full" value="#file_size_full#">
				</cfinvoke>

				<!---
				<!---Get the file size in KB--->
				<cfset file_size_kb = Fix(file_size/1024)>
				<cfif file_size_kb IS 0>
					<cfset file_size_kb = 1>
				</cfif>
				<cfset file_size_kb = file_size_kb&" KB">
				
				
				<cfif file_size_full LT (1024*1024)><!---File size is LT a mega byte--->
				
					<cfset file_size = file_size_kb>
					
				<cfelse>
				
					<cfset file_size = file_size/(1024*1024)>
					<cfset file_size = round(file_size*100)/100>
					
					<cfset file_size = file_size&" MB">
					
				</cfif>--->
			<cfelse>
				<cfset file_size_full = "">
				<!--- <cfset file_size_kb = ""> --->
			</cfif>
					
			<cfset object = {
				id="#id#",
				physical_name="#physical_name#",
				user_in_charge="#user_in_charge#",
				file_size_full="#file_size_full#",
				<!--- file_size_kb="#file_size_kb#", --->
				file_size="#file_size#",
				file_type="#file_type#",
				uploading_date="#uploading_date#",
				replacement_date="#replacement_date#",
				association_date="#association_date#",
				name="#name#",
				file_name="#file_name#",
				description="#description#",
				tree_mode="#tree_mode#",
				user_full_name="#user_full_name#",
				status="#status#",
				area_id="#area_id#",
				area_name="#area_name#",
				file_types_conversion="#file_types_conversion#",
				user_image_type="#user_image_type#",
				typology_id="#typology_id#",
				typology_row_id="#typology_row_id#"
				}>
			
			<cfif isDefined("arguments.return_type")>
			
				<cfif arguments.return_type EQ "object">
				
					<cfreturn object>
					
				<cfelseif arguments.return_type EQ "xml">
				
					<cfinvoke component="FileManager" method="xmlFile" returnvariable="xmlResult">
						<cfinvokeargument name="objectFile" value="#object#">
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
	
	

	<!--- ----------------- GET USER FILE TREE  -------------------------------- --->
	<cffunction name="getUserFileTree" returntype="string" access="public" >	
		
		<cfset var method = "getUserFileTree">
		
		<cftry>
		
			<cfinclude template="includes/functionStart.cfm">
		
			<cfinvoke component="FolderManager" method="getUserRootFolderId" returnvariable="root_folder_id">
			</cfinvoke>		
							
				<cfinvoke component="FolderManager" method="getFolderContent" returnvariable="result">
					<cfinvokeargument name="folder_id" value="#root_folder_id#">							
				</cfinvoke> 			
			
				<cfsavecontent variable="xmlResult">
					<cfoutput>
						#result#						
					</cfoutput>
				</cfsavecontent>							
			
			<cfset xmlResponseContent = xmlResult>
		
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>			
		
	</cffunction>


	<!--- ----------------------- DELETE AREA FILES -------------------------------- --->
	
	<cffunction name="deleteAreaFiles" returntype="struct" access="package">
		<cfargument name="area_id" type="numeric" required="true">

		<cfset var response = structNew()>

		<cfset var cur_file_id = "">

		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfinclude template="includes/checkAreaAdminAccess.cfm">

			<!--- Get files to delete --->			
			<cfquery name="filesQuery" datasource="#client_dsn#">
				SELECT file_id 
				FROM #client_abb#_areas_files 
				WHERE area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif filesQuery.recordCount GT 0>
			
				<cfloop query="filesQuery">

					<cfset cur_file_id = filesQuery.file_id>

					<cfquery name="fileAreasQuery" datasource="#client_dsn#">
						SELECT area_id 
						FROM #client_abb#_areas_files
						WHERE file_id = <cfqueryparam value="#cur_file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
					<cfif fileAreasQuery.recordCount IS 1><!--- The file is only in 1 area --->

						<cfinvoke component="FileManager" method="deleteFile" returnvariable="deleteFileResult">
							<cfinvokeargument name="file_id" value="#cur_file_id#">
							<cfinvokeargument name="area_id" value="#arguments.area_id#">
						</cfinvoke>

						<cfif deleteFileResult.result IS false>
							
							<cfreturn deleteFileResult>

						</cfif>

					<cfelse>

						<cfinvoke component="FileManager" method="dissociateFile" returnvariable="dissociateFileResult">
							<cfinvokeargument name="file_id" value="#cur_file_id#">
							<cfinvokeargument name="area_id" value="#arguments.area_id#">
						</cfinvoke>

						<cfif dissociateFileResult.result IS false>
							
							<cfreturn dissociateFileResult>

						</cfif>
						
					</cfif>

				</cfloop>
				
			</cfif>

			<cfset response = {result=true, area_id=#arguments.area_id#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>


	<!--- ----------------------- DELETE FILE -------------------------------- --->
	
	<cffunction name="deleteFile" returntype="struct" output="false" access="public">		
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="false">
		
		<cfset var method = "deleteFile">
		
		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var fileQuery = "">
		<cfset var fileTypeId = "">
		<cfset var path = "">
		<cfset var filePath ="">
					
		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
									
			<!--- getFile --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="with_lock" value="false">
				<cfinvokeargument name="parse_dates" value="true">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif fileQuery.recordCount IS 0><!---The file does not exist (is not found)--->
				
				<cfset error_code = 601>
				
				<cfthrow errorcode="#error_code#">
							
			</cfif>	

			<cfset fileTypeId = fileQuery.file_type_id>
			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">
	

			<!---checkAccess--->
			<cfif fileQuery.file_type_id IS 2><!---Area file (all area users can delete the file)--->
				
				<cfset area_id = fileQuery.area_id>

				<!---checkAreaAccess--->
				<cfinclude template="includes/checkAreaAccess.cfm">

			<cfelse><!--- User file --->
		
				<cfif fileQuery.user_in_charge NEQ user_id><!---El usuario del item no es el mismo que el que intenta eliminar--->

					<cfif isDefined("arguments.area_id")>
					
						<cfset area_id = arguments.area_id>

						<cfinclude template="includes/checkAreaAdminAccess.cfm">

					<cfelse>

						<cfinclude template="includes/checkAdminAccess.cfm">

					</cfif>

				</cfif>			

			</cfif>

			<cfif fileQuery.locked IS true>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="No se puede eliminar un archivo bloqueado, debe desbloquearlo."}>

			<cfelse>

				<!---getFileAreas--->
				<cfquery datasource="#client_dsn#" name="getFileAreasQuery">
					SELECT area_id
					FROM #client_abb#_areas_files
					WHERE file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cftransaction>
								
					<!---Delete typology--->
					<cfif isNumeric(fileQuery.typology_id) AND isNumeric(fileQuery.typology_row_id)>
						
						<cfinvoke component="RowManager" method="deleteRow" returnvariable="deleteRowResponse">
							<cfinvokeargument name="row_id" value="#fileQuery.typology_row_id#"/>
							<cfinvokeargument name="table_id" value="#fileQuery.typology_id#"/>
							<cfinvokeargument name="tableTypeId" value="#typologyTableTypeId#"/>
						</cfinvoke>

						<cfif deleteRowResponse.result IS false>
							<cfthrow message="#deleteRowResponse.message#">
						</cfif>

					</cfif>

					<!--- Delete file versions --->
					<cfif fileQuery.file_type_id IS 3><!--- Area file with versions --->
					
						<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersions" returnvariable="fileVersionsQuery">
							<cfinvokeargument name="file_id" value="#arguments.file_id#">
							<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
							
							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

						<cfloop query="fileVersionsQuery">
							
							<cfinvoke component="FileManager" method="deleteFileVersion" returnvariable="deleteFileVersionResponse">
								<cfinvokeargument name="version_id" value="#fileVersionsQuery.version_id#"/>
								<cfinvokeargument name="fileQuery" value="#fileQuery#"/>
							</cfinvoke>

							<cfif deleteFileVersionResponse.result IS false>
								<cfthrow message="#deleteFileVersionResponse.message#">
							</cfif>

						</cfloop>

					</cfif>


					<!--- Delete association areas --->
					<cfquery name="deleteAssociationAreaQuery" datasource="#client_dsn#">
						DELETE 
						FROM #client_abb#_areas_files
						WHERE file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>	

					<!--- Delete areas positions --->
					<cfinvoke component="AreaItemManager" method="deleteItemPosition">
						<cfinvokeargument name="item_id" value="#arguments.file_id#">
						<cfinvokeargument name="itemTypeId" value="#fileItemTypeId#">
					</cfinvoke>
					
					<!--- Delete association folder file --->
					<cfquery name="deleteAssociationFolderQuery" datasource="#client_dsn#">
						DELETE 
						FROM #client_abb#_folders_files
						WHERE file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>		
					
					<!--- Deletion of the row representing the file --->
					<cfquery name="deleteFileQuery" datasource="#client_dsn#">		
						DELETE
						FROM #client_abb#_files 
						WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
					<cfif fileQuery.file_type_id IS NOT 3><!--- IS NOT file with versions --->

						<cfset path = APPLICATION.filesPath&'/#client_abb#/#fileTypeDirectory#/'>	
						<cfset filePath = path & fileQuery.physical_name>			
						
						<!--- Now we delete physically the file on the server --->
						<cfif FileExists(filePath)><!---If the physical file exist--->
							<cffile action="delete" file="#filePath#">
						<cfelse><!---The physical file does not exist--->
							<!---<cfset error_code = 608>
							<cfthrow errorcode="#error_code#">--->
						</cfif>
						
						<!---Update User Space Used--->
						<cfif fileQuery.status EQ "ok">
							<cfquery name="updateUserSpaceUsed" datasource="#client_dsn#">
								UPDATE #client_abb#_users
								SET space_used = space_used-#fileQuery.file_size#
								WHERE id = <cfqueryparam value="#fileQuery.user_in_charge#" cfsqltype="cf_sql_integer">;
							</cfquery>
						</cfif>

					</cfif>
				
				</cftransaction>

				<cfinclude template="includes/logRecord.cfm">

				<cfif getFileAreasQuery.recordCount GT 0>
					
					<cfloop query="getFileAreasQuery">

						<!--- Alert --->
						<cfinvoke component="AlertManager" method="newFile">
							<cfinvokeargument name="objectFile" value="#fileQuery#">
							<cfinvokeargument name="fileTypeId" value="#fileTypeId#"/>
							<cfinvokeargument name="area_id" value="#getFileAreasQuery.area_id#">
							<cfinvokeargument name="action" value="delete">
						</cfinvoke>
						
					</cfloop>

				</cfif>

				<cfset response = {result=true, file_id=#arguments.file_id#}>

			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>	
		
	</cffunction>


	
	<!--- ----------------------- DELETE FILE VERSION -------------------------------- --->
	
	<cffunction name="deleteFileVersion" returntype="struct" output="false" access="private">		
		<cfargument name="version_id" type="numeric" required="true">
		<cfargument name="fileQuery" type="query" required="true">
		
		<cfset var method = "deleteFileVersion">
		
		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var fileTypeId = "">
		<cfset var path = "">
		<cfset var filePath ="">

		<!--- Las consultas de este método no se pueden meter dentro de otra transacción porque este método se llama desde deleteFile --->
								
			<cfinclude template="includes/functionStartOnlySession.cfm">
									
			<!---
			<!--- getFile --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="with_lock" value="false">
				<cfinvokeargument name="parse_dates" value="true">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif fileQuery.recordCount IS 0><!---The file does not exist (is not found)--->
				
				<cfset error_code = 601>
				
				<cfthrow errorcode="#error_code#">
							
			</cfif>	

			<cfset fileTypeId = fileQuery.file_type_id>
			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">
			
			<cfset area_id = fileQuery.area_id>

			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">
		--->

			<cfset fileTypeId = fileQuery.file_type_id>
			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfif fileQuery.locked IS true>

				<cfset response = {result=false, version_id=#arguments.version_id#, message="No se puede eliminar un archivo bloqueado, debe desbloquearlo."}>

			<cfelse>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersion" returnvariable="fileVersionQuery">
					<cfinvokeargument name="version_id" value="#arguments.version_id#">
					<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
					
					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif fileVersionQuery.recordCount IS 0>
					
					<cfset error_code = 601>
				
					<cfthrow errorcode="#error_code#">

				</cfif>

				<!--- <cftransaction> --->
				
					<!--- Deletion of the row representing the file version --->
					<cfquery name="deleteFileVersionQuery" datasource="#client_dsn#">		
						DELETE
						FROM #client_abb#_files_versions
						WHERE version_id = <cfqueryparam value="#arguments.version_id#" cfsqltype="cf_sql_integer">
						AND file_id = <cfqueryparam value="#fileQuery.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
					<cfset path = APPLICATION.filesPath&'/#client_abb#/#fileTypeDirectory#/'>	
					<cfset filePath = path & fileVersionQuery.physical_name>			
					
					<!--- Now we delete physically the file on the server --->
					<!---<cfif FileExists(filePath)>---><!---If the physical file exist--->
						<cffile action="delete" file="#filePath#">
					<!---</cfif>--->
					
					<!---Update User Space Used--->
					<cfif fileQuery.status EQ "ok">
						<cfquery name="updateUserSpaceUsed" datasource="#client_dsn#">
							UPDATE #client_abb#_users
							SET space_used = space_used-#fileVersionQuery.file_size#
							WHERE id = <cfqueryparam value="#fileVersionQuery.user_in_charge#" cfsqltype="cf_sql_integer">;
						</cfquery>
					</cfif>
				
				<!--- </cftransaction> --->

				<cfinclude template="includes/logRecord.cfm">

				<!---<cfif getFileAreasQuery.recordCount GT 0>
					
					<cfloop query="getFileAreasQuery">

						<!--- Alert --->
						<cfinvoke component="AlertManager" method="newFile">
							<cfinvokeargument name="objectFile" value="#fileVersionQuery#">
							<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
							<cfinvokeargument name="area_id" value="#getFileAreasQuery.area_id#">
							<cfinvokeargument name="action" value="delete">
						</cfinvoke>
						
					</cfloop>

				</cfif>--->

				<cfset response = {result=true, version_id=#arguments.version_id#}>

			</cfif>

		<cfreturn response>	
		
	</cffunction>



	
	<!--- ----------------------- MOVE FILE TO FOLDER -------------------------------- --->
	
	<cffunction name="moveFileToFolder" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">		
		
		<cfset var method = "moveFileToFolder">
		
		<cfset var fileXml = "">
		<cfset var file_id = "">
		<cfset var folder_id = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfxml variable="fileXml">
				<cfoutput>
				#xmlRequest.request.parameters.file#
				</cfoutput>
			</cfxml>
			<cfxml variable="folderXml">
				<cfoutput>
				#xmlRequest.request.parameters.folder#
				</cfoutput>
			</cfxml>
			
			
			<cfquery name="beginQuery" datasource="#client_dsn#">
				BEGIN;
			</cfquery>
			
			<cfset file_id = fileXml.file.xmlAttributes.id>
			<cfset folder_id = folderXml.folder.xmlAttributes.id>
			
			<!---<cfif isDefined("fileXml.file.xmlAttr.xmlText")>
				<cfset desc = "#fileXml.file.description.xmlText#">
				<cfset desc = '#replace(desc,"<![CDATA[","","all")#'>
				<cfset desc = '#replace(desc,"]]>","","all")#'>
				<cfquery name="descriptionQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_files SET description = <cfqueryPARAM value = "#desc#" CFSQLType = "CF_SQL_varchar">
					WHERE id = <cfqueryPARAM value = "#fileXml.file.XmlAttributes.id#" CFSQLType = "CF_SQL_integer">;
				</cfquery>
			</cfif>--->	
			
			<cfquery name="moveFileQuery" datasource="#client_dsn#">
				UPDATE #client_abb#_folders_files SET folder_id = <cfqueryparam value="#folder_id#" cfsqltype="cf_sql_integer">
				WHERE file_id = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">; 
			</cfquery>
			
			<cfquery name="commitQuery" datasource="#client_dsn#">
				COMMIT;
			</cfquery>						
						
			<cfinvoke method="selectFile" component="FileManager" returnvariable="result">
				<cfinvokeargument name="request" value='<request><parameters><file id="#fileXml.file.xmlAttributes.id#" /></parameters></request>'>
			</cfinvoke>
			
			<cfxml variable="xmlResponse">
				<cfoutput>
				#result#
				</cfoutput>
			</cfxml>
			
			<cfset xmlResponse.response.xmlAttributes.component = component>
			<cfset xmlResponse.response.xmlAttributes.method = method>			
		
			<!---<cfinclude template="includes/functionEnd.cfm">--->
			<cfinclude template="includes/logRecord.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>		
		
	</cffunction>
	
	
	<!--- ----------------------- ASSOCIATE FILES -------------------------------- --->
	
	<!---Falta por terminar de implementar y por probar--->
	
	<!---<cffunction name="associateFiles" returntype="string" access="public">
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "associateFiles">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
		
		<cfset var area_id = "">
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset area_id = xmlRequest.request.parameters.area.xmlAttributes.id>
			
			<cfinclude template="includes/checkAreaAccess.cfm">
			
			<cfset xmlResult = '<files>'>
			
			<cfloop index="indexNode" from="1" to="#ArrayLen(xmlRequest.request.parameters.files.file)#">
			
				<cfinvoke component="FileManager" method="associateFile" returnvariable="associateFileResult">
					<cfinvokeargument name="file_id" value="#xmlRequest.request.parameters.files.file[indexNode].xmlAttributes.id#">
					<cfinvokeargument name="area_id" value="#area_id#">
				</cfinvoke>
				
				<!---<cfxml variable="xmlAssociateFileResult">
					<cfoutput>
					#associateFileResult#
					</cfoutput>
				</cfxml>--->
				
				<cfset xmlResult = xmlResult & associateFileResult>	
			
			</cfloop>
			
			<cfset xmlResult = xmlResult & '</file>'>
			
			<cfset xmlResponseContent = xmlResult>
			
			<cfinclude template="includes/functionEnd.cfm">
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>--->
	
		
	<!--- ----------------------- ASSOCIATE FILE -------------------------------- --->
	
	<cffunction name="associateFileToAreas" returntype="struct" output="false" access="public">		
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="areas_ids" type="string" required="true">		
		
		<cfset var method = "associateFileToAreas">

		<cfset var response = structNew()>
		
		<cfset var allAreas = true>
		<cfset var successfulAreas = "">
					
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
						
			<cfinvoke component="FileManager" method="getFile" returnvariable="objectFile">				
				<cfinvokeargument name="get_file_id" value="#arguments.file_id#">
			
				<cfinvokeargument name="return_type" value="query">
			</cfinvoke>		
	
			<cfloop list="#arguments.areas_ids#" index="cur_area_id">
				
				<cftry>
				
					<cfinvoke component="FileManager" method="associateFileToArea">				
						<cfinvokeargument name="objectFile" value="#objectFile#">
						<cfinvokeargument name="area_id" value="#cur_area_id#">
					</cfinvoke>	
					
					<cfset successfulAreas = listAppend(successfulAreas, cur_area_id)>	
					
					<cfcatch>
						<cfif isDefined("cfcatch.errorcode") AND cfcatch.errorcode IS 607><!---The file exists in the area--->	
							<cfset allAreas = false>
						<cfelse>
							<cfthrow object="#cfcatch#">					
						</cfif>
					</cfcatch>
				</cftry>
			
			</cfloop>
							
			<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfset response = {result=true, file_id=#arguments.file_id#, areas_ids=#successfulAreas#, allAreas=#allAreas#}>		

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>			
		
	</cffunction>
	

	<!--- ----------------------- ASSOCIATE FILE -------------------------------- --->
	
	<cffunction name="associateFile" returntype="struct" output="false" access="public">		
		<!---<cfargument name="request" type="string" required="yes">--->
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">				
		
		<cfset var method = "associateFile">
		
		<cfset var response = structNew()>
					
		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
	
			<cfinvoke component="FileManager" method="getFile" returnvariable="objectFile">				
				<cfinvokeargument name="get_file_id" value="#arguments.file_id#">
			
				<cfinvokeargument name="return_type" value="query">
			</cfinvoke>		
			
			<cfinvoke component="FileManager" method="associateFileToArea">				
				<cfinvokeargument name="objectFile" value="#objectFile#">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>		
			
			<cfset response = {result=true, file_id=#arguments.file_id#, area_id=#arguments.area_id#}>		

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>
	
	
	<!--- ----------------------- ASSOCIATE FILE TO AREA -------------------------------- --->
	
	<cffunction name="associateFileToArea" returntype="void" output="false" access="package">		
		<cfargument name="objectFile" type="query" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">		
		
		<cfset var method = "associateFileToArea">

		<cfset var fileTypeId = objectFile.file_type_id>
					
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<!--- checkAreaAccess --->
			<cfinclude template="includes/checkAreaAccess.cfm">
			
			<cfif objectFile.file_type_id IS 2>
				<!--- checkAreaAccess --->
				<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="checkAreaAccess">
					<cfinvokeargument name="area_id" value="#objectFile.area_id#">
				</cfinvoke>
			<cfelseif objectFile.user_in_charge NEQ user_id>
				<cfthrow message="No puede asociar a un área un archivo que no es de su propiedad">
			</cfif>

			<!---Chequea si existe el archivo en el área--->
			<cfquery datasource="#client_dsn#" name="isFileInAreaQuery">
				SELECT file_id
				FROM #client_abb#_areas_files
				WHERE area_id = <cfqueryparam value = "#arguments.area_id#" cfsqltype="cf_sql_integer"> AND 
				file_id = <cfqueryparam value = "#objectFile.id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif isFileInAreaQuery.recordCount IS NOT 0><!---The file exists in the area--->
				<cfset error_code = 607>
			
				<cfthrow errorcode="#error_code#">		
			</cfif>

			<cftransaction>
				
				<cfquery name="associateFileQuery" datasource="#client_dsn#">		
					INSERT INTO #client_abb#_areas_files (area_id, file_id, association_date)
						VALUES(
						<cfqueryparam value = "#arguments.area_id#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value = "#objectFile.id#" cfsqltype="cf_sql_integer">,
						NOW()
					);			
				</cfquery>

				<!---Add items position--->
				<cfinvoke component="AreaItemManager" method="getAreaItemsLastPosition" returnvariable="itemLastPosition">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>
				
				<cfset file_position = itemLastPosition+1>

				<cfinvoke component="AreaItemManager" method="insertAreaItemPosition">
					<cfinvokeargument name="item_id" value="#objectFile.id#">
					<cfinvokeargument name="itemTypeId" value="#fileItemTypeId#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
					<cfinvokeargument name="position" value="#file_position#">
				</cfinvoke>

			</cftransaction>

			<cfinclude template="includes/functionEndOnlyLog.cfm">		
								
			<!--- Alert --->
			<cfinvoke component="AlertManager" method="newFile">
				<cfinvokeargument name="objectFile" value="#objectFile#">
				<cfinvokeargument name="fileTypeId" value="#fileTypeId#"/>
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfif objectFile.file_type_id IS 1 OR (objectFile.file_type_id IS 2 AND objectFile.area_id NEQ arguments.area_id)>
					<cfinvokeargument name="action" value="associate">
				<cfelse>
					<cfinvokeargument name="action" value="new">
				</cfif>
			</cfinvoke>
		
	</cffunction>
	
	
	<!--- ----------------------- DISSOCIATE FILE -------------------------------- --->
	
	<cffunction name="dissociateFile" returntype="struct" output="false" access="public">		
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">		
		
		<cfset var method = "dissociateFile">
		
		<cfset var response = structNew()>
					
		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<!---checkAreaAccess--->
			<!--- Area accces check in dissociateFileFromArea --->

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="with_lock" value="false">
				<cfinvokeargument name="parse_dates" value="true">		

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif fileQuery.recordCount GT 0>

				<!--- Comprueba si es archivo de área y se está intentando quitar de esa área --->
				<cfif fileQuery.file_type_id IS 2 AND fileQuery.area_id IS arguments.area_id>
					<cfset response_message = "Para quitar este archivo de esta área debe eliminarlo.">
					<cfset response = {result=false, message=#response_message#, file_id=#arguments.file_id#, area_id=#arguments.area_id#}>
					<cfreturn response>
				</cfif>

				<!--- dissociateFileFromArea --->
				<cfinvoke component="FileManager" method="dissociateFileFromArea">				
					<cfinvokeargument name="objectFile" value="#fileQuery#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>		


				<cfset response = {result=true, file_id=#arguments.file_id#, area_id=#arguments.area_id#}>	

			<cfelse><!---File does not exist--->
			
				<cfset error_code = 601>
			
				<cfthrow errorcode="#error_code#">
			
			</cfif>	

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>		
		
	</cffunction>


	<!--- ----------------------- DISSOCIATE FILE FROM AREA -------------------------------- --->
	
	<cffunction name="dissociateFileFromArea" returntype="void" output="false" access="package">		
		<cfargument name="objectFile" type="query" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">		
		
		<cfset var method = "dissociateFileFromArea">
		
		<cfset var file_id = objectFile.file_id>
		<cfset var fileTypeId = objectFile.file_type_id>

			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<!--- checkAreaAccess --->
			<cfinclude template="includes/checkAreaAccess.cfm">
			
			<!---Chequea si el archivo está en otra área--->
			<cfquery datasource="#client_dsn#" name="isFileInAreaQuery">
				SELECT file_id
				FROM #client_abb#_areas_files
				WHERE file_id = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif isFileInAreaQuery.recordCount LT 2><!---The file is only in this area--->
				<!---<cfset response_message = "El archivo solo está asociado en esta área. Para quitarlo debe eliminarlo.">
				<cfset response = {result=false, message=#response_message#, file_id=#arguments.file_id#, area_id=#arguments.area_id#}>
				<cfreturn response>--->
				<cfthrow message="El archivo sólo está asociado en esta área. Para quitarlo debe eliminarlo.">
			</cfif>
			
			<cftransaction>
				
				<cfquery name="dissociateFileQuery" datasource="#client_dsn#">		
					DELETE FROM #client_abb#_areas_files 
					WHERE area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					AND file_id = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<!---DELETE ITEM POSITION--->
				<cfinvoke component="AreaItemManager" method="deleteItemPosition">
					<cfinvokeargument name="item_id" value="#file_id#">
					<cfinvokeargument name="itemTypeId" value="#fileItemTypeId#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>

			</cftransaction>
				
			<cfinclude template="includes/functionEndOnlyLog.cfm">

			<!--- Alert --->
			<cfinvoke component="AlertManager" method="newFile">
				<cfinvokeargument name="objectFile" value="#arguments.objectFile#">
				<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="action" value="dissociate">
			</cfinvoke>
		
	</cffunction>


		
	
	<!--- ----------------------- CONVERT FILE -------------------------------- --->
	
	<cffunction name="convertFile" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">	
		
		<cfset var method = "convertFile">
		<cfset var file_id = "">
		<cfset var file_type = "">
		
		<cfset var files_directory = "">
		<cfset var files_converted_directory = "">
		<cfset var file_copy = "">
		<cfset var file_converted = "">
		
		<cfset var objectFile = "">
		
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset file_id = xmlRequest.request.parameters.file.xmlAttributes.id>
			<cfset file_type = xmlRequest.request.parameters.file.xmlAttributes.file_type>
			
			<cfinvoke component="FileManager" method="getFile" returnvariable="objectFile">				
				<cfinvokeargument name="get_file_id" value="#file_id#">
			
				<cfinvokeargument name="return_type" value="query">
			</cfinvoke>
			
			<!---checkFileTypeConversion--->			
			<cfinvoke component="FileManager" method="checkFileTypeConversion" returnvariable="file_type_result">
				<cfinvokeargument name="file_type_from" value="#objectFile.file_type#">
				<cfinvokeargument name="file_type_to" value="#file_type#">
			</cfinvoke>	
			
			<cfif file_type_result IS true>
			
				<cfset files_directory = "files">
				<cfset files_converted_directory = "files_converted">
				
				<cfset source = '#APPLICATION.filesPath#/#client_abb#/#files_directory#/#objectFile.physical_name#'>		
				
				<cfif FileExists(source)>
					
					<cfquery datasource="#client_dsn#" name="getFileConverted">
						SELECT file_id, file_type, uploading_date, conversion_date
						FROM #client_abb#_files_converted
						WHERE file_id = <cfqueryparam value="#objectFile.file_id#" cfsqltype="cf_sql_integer">
						AND file_type = <cfqueryparam value="#file_type#" cfsqltype="cf_sql_varchar">;
					</cfquery>
					
					<cfif getFileConverted.recordCount LT 1 OR getFileConverted.uploading_date LT objectFile.uploading_date OR getFileConverted.uploading_date LT objectFile.replacement_date>
	
						<cfsetting requesttimeout="#APPLICATION.filesTimeout#">
							
						<cfset file_copy = '#APPLICATION.filesPath#/#client_abb#/#files_converted_directory#/temp_#objectFile.physical_name#_#user_id##objectFile.file_type#'>
						<cffile action="copy" source="#source#" destination="#file_copy#" nameconflict="overwrite">
						
						<cfif file_type NEQ ".html">
						
							<cfset file_converted = '#APPLICATION.filesPath#/#client_abb#/#files_converted_directory#/#objectFile.physical_name##file_type#'>
						
						<cfelse>
							
							<cfset file_converted = ExpandPath('#APPLICATION.path#/#client_abb#/temp/files/#objectFile.physical_name#_html/#objectFile.physical_name##file_type#')>					
							
						</cfif>
						
						<cfinvoke component="FileConverter" method="convertFile">
							<cfinvokeargument name="inputFilePath" value="#file_copy#">
							<cfinvokeargument name="outputFilePath" value="#file_converted#">
						</cfinvoke>
						
						<cffile action="delete" file="#file_copy#">
				
						<cfquery datasource="#client_dsn#" name="insertConvertedFile">
							REPLACE INTO #client_abb#_files_converted
							(file_id, file_type, uploading_date, conversion_date)
							VALUES (
							<cfqueryparam value="#objectFile.file_id#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#file_type#" cfsqltype="cf_sql_varchar">,
							<cfif isDate(objectFile.replacement_date) AND objectFile.replacement_date GT objectFile.uploading_date>
								<cfqueryparam value="#objectFile.replacement_date#" cfsqltype="cf_sql_timestamp">,
							<cfelse>
								<cfqueryparam value="#objectFile.uploading_date#" cfsqltype="cf_sql_timestamp">,
							</cfif>
							NOW());
						</cfquery>
					
						<cfset file_convert_message = "Archivo generado correctamente.">
					
					<cfelse>
					
						<cfset file_convert_message = "Archivo ya disponible en este formato, puede descargarlo.">
					
					</cfif>
					
					<cfset xmlResponseContent = "<file_convert><message><![CDATA[#file_convert_message#]]></message></file_convert>">
					
					<cfinclude template="includes/functionEndNoLog.cfm">
					
				<cfelse><!---The physical file does not exist--->
							
					<cfset error_code = 608>
					
					<cfthrow errorcode="#error_code#" detail="#source#">
				
				</cfif>
			
			<cfelse><!---The file can't be converted to the selected file type--->
			
				<cfset error_code = 612>
					
				<cfthrow errorcode="#error_code#" detail="#file_type#">
			
			</cfif>
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
				
	</cffunction>
	
	
	<!--- ----------------------- CONVERT PRESENTATION FILE -------------------------------- --->
	
	<!---En este método se convierte el archivo si no ha sido convertido ya en HTML, y después se generan las miniaturas y se obtienen el listado de archivos que forman la presentacion--->
	
	<cffunction name="convertPresentationFile" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">	
		
		<cfset var method = "convertPresentationFile">
		
		<cfset var xmlResult = "">
		<cfset var xmlResponseContent = "">
		<cfset var xmlResponse = "">
		
		<cfset var file_id = "">
		<cfset var file_type = "">	
		
		<cfset var objectFile = "">	
		<cfset var convertFileResult = "">
		<cfset var xmlConvertFileResult = "">
		<cfset var fileConvertedDirectory = "">
		<cfset var fileThumbsDirectory = "">

		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset file_id = xmlRequest.request.parameters.file.xmlAttributes.id>
			<cfset file_type = xmlRequest.request.parameters.file.xmlAttributes.file_type>
			
			<cfinvoke component="FileManager" method="getFile" returnvariable="objectFile">				
				<cfinvokeargument name="get_file_id" value="#file_id#">
			
				<cfinvokeargument name="return_type" value="query">
			</cfinvoke>
			
			<cfif objectFile.file_type EQ ".ppt" AND file_type EQ ".html">
			
				<!---convertFile--->			
				<cfinvoke component="FileManager" method="convertFile" returnvariable="convertFileResult">
					<cfinvokeargument name="request" value="#arguments.request#">
				</cfinvoke>	
				
				<!---check convertFile result--->
				<cfxml variable="xmlConvertFileResult">
					<cfoutput>
						#convertFileResult#
					</cfoutput>
				</cfxml>
				
				<cfif xmlConvertFileResult.response.xmlAttributes.status EQ "error">
					
					<cfset error_code = xmlConvertFileResult.response.error.xmlAttributes.code>
				
					<cfthrow errorcode="#error_code#">
				
				</cfif>
				
				<cfset fileConvertedDirectory = "#APPLICATION.path#/#client_abb#/temp/files/#objectFile.physical_name#_html/">			
				
				<cfif directoryExists(ExpandPath(fileConvertedDirectory))>
					
					<!---getImageFiles--->
					<cfinvoke component="FileConverter" method="getConvertedImages" returnvariable="convertedImages">
						<cfinvokeargument name="directory_path" value="#fileConvertedDirectory#">
						<cfinvokeargument name="return_type" value="list">
					</cfinvoke>	
					
					<cfset fileThumbsDirectory = fileConvertedDirectory&"thumbs/">
					
					<cfif NOT directoryExists(expandPath(fileThumbsDirectory))>
						<cfdirectory action="create" directory="#expandPath(fileThumbsDirectory)#" mode="777">
					</cfif>
					
					<cfset xmlResult = '<file id="#file_id#"><slides>'>
			
					<cfset cont = 0>
					<cfloop list="#convertedImages#" index="imageFile">
						
						<cfset imageName = imageFile>
						<cfset imageThumbName = imageName>
						
						<cfset imagePath = expandPath(fileConvertedDirectory&imageName)>
						<cfset imageThumbPath = expandPath(fileThumbsDirectory&imageThumbName)>
						
						
						<cfif fileExists(imagePath)>
							
							<cfif NOT fileExists(imageThumbPath)>
								<cfimage action="resize" source="#imagePath#" destination="#imageThumbPath#" width="150">
							</cfif>
							
							<cfset xmlResult = xmlResult&'<slide path="#fileConvertedDirectory##imageFile#" thumb="#fileThumbsDirectory##imageThumbName#" index="#cont#" />'>
							
							<cfset cont = cont+1>
							
						</cfif>
						
						
					</cfloop>
				
					<cfset xmlResult = xmlResult&"</slides></file>">	
				
					<cfset xmlResponseContent = xmlResult>
					
					<cfinclude template="includes/functionEnd.cfm">
				
				
				<cfelse><!---The directory does not exist--->
				
					<cfset error_code = 701>
			
					<cfthrow errorcode="#error_code#" detail="#fileConvertedDirectory#">
				
				</cfif>
				
				
			<cfelse><!---The presentation file types are incorrect--->
			
				<cfset error_code = 613>
			
				<cfthrow errorcode="#error_code#" detail="#objectFile.file_type# #file_type#">
			
			</cfif>
			
			
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
				
	</cffunction>
	
	
	<!--- -------------------------- checkFileTypeConversion -------------------------------- --->
	<!---Comprueba si se puede convertir un tipo de archivo o otro seleccionado--->
	
	<cffunction name="checkFileTypeConversion" returntype="boolean" access="public">
		<cfargument name="file_type_from" type="string" required="yes">
		<cfargument name="file_type_to" type="string" required="yes">
		
		<cfset var method = "checkFileTypeConversion">
		
		<cfset var file_type_result = false>
			
		<cfinclude template="includes/functionStart.cfm">

		<!---getFileTypesConversion--->
		<cfinvoke component="FileTypeManager" method="getFileTypesConversion" returnvariable="queryFileTypes">
			<cfinvokeargument name="file_type" value="#arguments.file_type_from#">
			
			<cfinvokeargument name="return_type" value="query">
		</cfinvoke>
		
		<cfquery dbtype="query" name="checkFileType">
			SELECT file_type
			FROM queryFileTypes
			WHERE file_type = <cfqueryparam value="#arguments.file_type_to#" cfsqltype="cf_sql_varchar">;			
		</cfquery>		
		
		<cfif checkFileType.recordCount GT 0>
			<cfset file_type_result = true>
		<cfelse>
			<cfset file_type_result = false>
		</cfif>
		
		<cfreturn file_type_result>
		
	</cffunction>
	
	
	<!--- ----------------------- SELECT FILE -------------------------------- --->
	
	<cffunction name="selectFile" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
				
		<cfset var method = "selectFile">
		
		<cfset var file_id = "">
		<cfset var area_id = "">
		<cfset var area_passed = false>
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset file_id = xmlRequest.request.parameters.file.xmlAttributes.id>
			
			<cfif isDefined("xmlRequest.request.parameters.area.xmlAttributes.id")>
				<cfset area_id = xmlRequest.request.parameters.area.xmlAttributes.id>
				<cfset area_passed = true>			
			</cfif>
			
			<cfinvoke component="FileManager" method="getFile" returnvariable="xmlResponseContent">
				<cfinvokeargument name="get_file_id" value="#file_id#">
				<cfif area_passed IS true>
				<cfinvokeargument name="area_id" value="#area_id#">
				</cfif>
				<!---<cfinvokeargument name="format_content" value="all">--->
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
	
	
	<!--- ----------------------- GET FILE -------------------------------- --->
	
	<!---Devuelve los datos de un archivo si el usuario logeado tiene acceso a ellos--->
	<!---El usuario administrador tiene acceso a todos los archivos--->
	
	<cffunction name="getFile" output="false" returntype="any" access="public">		
		<cfargument name="get_file_id" type="numeric" required="yes">
		<cfargument name="fileTypeId" type="numeric" required="false" default="1">
		<cfargument name="area_id" type="numeric" required="no">
		<cfargument name="item_id" type="numeric" required="no">
		<cfargument name="itemTypeId" type="numeric" required="no">
		<!---<cfargument name="format_content" type="string" required="no" default="default">--->
        <cfargument name="return_type" type="string" required="no" default="xml"><!---xml/object/query--->
		
		<cfset var method = "getFile">
		
		<cfset var file_id = "">
		<cfset var area_passed = false>
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset file_id = arguments.get_file_id>
			
			<cfif isDefined("arguments.area_id")>
				<cfset area_passed = true>
				
				<!--- checkAreaAccess --->
				<cfinclude template="includes/checkAreaAccess.cfm">					
			</cfif>
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="selectFileQuery">
				<cfinvokeargument name="file_id" value="#file_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfif area_passed IS true>
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfif>
				<cfif APPLICATION.moduleAreaFilesLite IS true>
					<cfinvokeargument name="with_lock" value="true">
				</cfif>
				<cfinvokeargument name="parse_dates" value="true">		

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfif selectFileQuery.recordCount GT 0>
				
				<!---The area is not checked before and the file is not property of the user--->
				<cfif area_passed IS NOT true AND selectFileQuery.user_in_charge NEQ user_id>
				
					<cfquery name="getFileAreasQuery" datasource="#client_dsn#">
						SELECT area_id
						FROM #client_abb#_areas_files
						WHERE file_id = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<cfif selectFileQuery.file_type_id IS NOT 1 AND isNumeric(selectFileQuery.area_id)><!--- Area file --->
						<cfset queryCount = getFileAreasQuery.recordCount>

						<cfset queryAddRow(getFileAreasQuery)>
						<cfset querySetCell(getFileAreasQuery, "area_id", selectFileQuery.area_id, queryCount+1)>
					</cfif>					
					
					<cfif getFileAreasQuery.RecordCount IS 0 AND isDefined("arguments.itemTypeId")><!---The file is not in area--->
					
					
						<!---Aquí comprueba si el archivo está asociado a otro tipo de elemento (entradas, noticias, eventos, etc)--->
						<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">
						
						<cfquery name="getFileAreasQuery" datasource="#client_dsn#">
							SELECT area_id
							FROM #client_abb#_#itemTypeTable# AS items
							WHERE (attached_file_id = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer"> 
							<cfif itemTypeId IS NOT 1>OR attached_image_id = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer"></cfif>)
							<cfif isDefined("arguments.item_id")>
							AND items.id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">
							</cfif>;
						</cfquery>
						
					
					</cfif>
					
					<cfif getFileAreasQuery.RecordCount GT 0>
				
						<cfif getFileAreasQuery.RecordCount IS 1>
						
							<cfset area_id = getFileAreasQuery.area_id>	
					
							<cfinclude template="includes/checkAreaAccess.cfm">
					
						<cfelse>
							
							<cfset fileAreasList = valueList(getFileAreasQuery.area_id)>
							<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="checkAreasAccess">
								<cfinvokeargument name="areasList" value="#fileAreasList#">
							</cfinvoke>							
							
						</cfif>
					
					<cfelse>
					
						<cfset error_code = 103>
			
						<cfthrow errorcode="#error_code#">
					
					</cfif>
				
				</cfif>
				
				<cfif arguments.return_type EQ "query">
				
					<cfset xmlResponse = selectFileQuery>				
				
				<cfelse>
					
					<cfif APPLICATION.moduleConvertFiles EQ true>
					
						<!---getFileTypesConversion--->
						<cfinvoke component="FileTypeManager" method="getFileTypesConversion" returnvariable="objectFileTypes">
							<cfinvokeargument name="file_type" value="#selectFileQuery.file_type#">
							
							<cfinvokeargument name="return_type" value="object">
						</cfinvoke>
					
					</cfif>
					
					<cfinvoke component="FileManager" method="objectFile" returnvariable="objectFile">
						<cfinvokeargument name="id" value="#selectFileQuery.file_id#">
						<cfinvokeargument name="physical_name" value="#selectFileQuery.physical_name#">		
						<cfinvokeargument name="user_in_charge" value="#selectFileQuery.user_in_charge#">		
						<cfinvokeargument name="file_size" value="#selectFileQuery.file_size#">
						<cfinvokeargument name="file_type" value="#selectFileQuery.file_type#">
						<cfinvokeargument name="uploading_date" value="#selectFileQuery.uploading_date#">
						<cfif area_passed IS true>
						<cfinvokeargument name="association_date" value="#selectFileQuery.association_date#">
						</cfif>
						<cfinvokeargument name="replacement_date" value="#selectFileQuery.replacement_date#">
						<cfinvokeargument name="name" value="#selectFileQuery.name#">
						<cfinvokeargument name="file_name" value="#selectFileQuery.file_name#">
						<cfinvokeargument name="description" value="#selectFileQuery.description#">
						<cfinvokeargument name="user_full_name" value="#selectFileQuery.family_name# #selectFileQuery.user_name#">
						<cfinvokeargument name="user_image_type" value="#selectFileQuery.user_image_type#">
						<cfif APPLICATION.moduleConvertFiles EQ true>
							<cfinvokeargument name="file_types_conversion" value="#objectFileTypes#">
						</cfif>
						<cfinvokeargument name="status" value="#selectFileQuery.status#">
						<cfinvokeargument name="typology_id" value="#selectFileQuery.typology_id#">
						<cfinvokeargument name="typology_row_id" value="#selectFileQuery.typology_row_id#">
						
						<cfinvokeargument name="return_type" value="object">
					</cfinvoke>
					
					
					<cfif arguments.return_type EQ "object">
						
						<cfset xmlResponse = objectFile>
					 
					<cfelse>
					
						<cfinvoke component="FileManager" method="xmlFile" returnvariable="xmlResponseContent">
							<cfinvokeargument name="objectFile" value="#objectFile#">
						</cfinvoke>
						
						<cfset xmlResponse = xmlResponseContent>
					
					</cfif>
				
				</cfif>
				
				
			<cfelse><!---File does not exist--->
			
				<cfset error_code = 601>
			
				<cfthrow errorcode="#error_code#">

			</cfif>					
			
		
		<cfreturn xmlResponse>		
		
	</cffunction>
	
	
	<!--- ----------------------------------- getEmptyFile ----------------------------------  --->
	
	<cffunction name="getEmptyFile" output="false" access="public" returntype="struct">
		<cfset var method = "getEmptyFile">

		<cfset var response = structNew()>

		<cfset var file = structNew()>
		
		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfset file.name = "">
			<cfset file.description = "">
			<cfset file.typology_id = "">
			<cfset file.typology_row_id = "">
			
			<cfset response = {result=true, file=#file#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>
	<!---  -------------------------------------------------------------------------------- --->


	<!--- ------------------------------------- getFileVersion -------------------------------------  --->
	
	<cffunction name="getFileVersion" output="false" access="public" returntype="struct">
		<cfargument name="version_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">

		<cfset var method = "getFileVersion">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersion" returnvariable="getFileVersionQuery">
				<cfinvokeargument name="version_id" value="#arguments.version_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif getFileVersionQuery.recordCount IS 0><!---File does not exist--->
				
				<cfset error_code = 601>
				
				<cfthrow errorcode="#error_code#">

			<cfelse>
				
				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
					<cfinvokeargument name="file_id" value="#getFileVersionQuery.file_id#">
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
					<cfinvokeargument name="with_lock" value="false">
					<cfinvokeargument name="parse_dates" value="false">		

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif fileQuery.recordCount GT 0>
					
					<cfset area_id = fileQuery.area_id>
				
					<!---checkAreaAccess--->
					<cfinclude template="includes/checkAreaAccess.cfm">

				<cfelse><!---File does not exist--->
				
					<cfset error_code = 601>
				
					<cfthrow errorcode="#error_code#">
				
				</cfif>

			</cfif>
			
			<cfset response = {result=true, version=getFileVersionQuery}>
								
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>



	<!--- ------------------------------------- getFileLastVersion -------------------------------------  --->
	
	<cffunction name="getLastFileVersion" output="false" access="public" returntype="struct">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">

		<cfset var method = "getLastFileVersion">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfinvokeargument name="with_lock" value="false">
				<cfinvokeargument name="parse_dates" value="false">		

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif fileQuery.recordCount GT 0>
				
				<cfset area_id = fileQuery.area_id>
			
				<!---checkAreaAccess--->
				<cfinclude template="includes/checkAreaAccess.cfm">

			<cfelse><!---File does not exist--->
			
				<cfset error_code = 601>
			
				<cfthrow errorcode="#error_code#">
			
			</cfif>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersions" returnvariable="getFileVersionsQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
				<cfinvokeargument name="limit" value="1">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfset response = {result=true, version=getFileVersionsQuery}>
								
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>



	<!--- ------------------------------------- getFileVersions -------------------------------------  --->
	
	<cffunction name="getFileVersions" output="false" access="public" returntype="struct">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">

		<cfset var method = "getFileVersions">

		<cfset var response = structNew()>

		<cfset var area_id = "">

		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfinvokeargument name="with_lock" value="false">
				<cfinvokeargument name="parse_dates" value="false">		

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif fileQuery.recordCount GT 0>
				
				<cfset area_id = fileQuery.area_id>
			
				<!---checkAreaAccess--->
				<cfinclude template="includes/checkAreaAccess.cfm">

			<cfelse><!---File does not exist--->
			
				<cfset error_code = 601>
			
				<cfthrow errorcode="#error_code#">
			
			</cfif>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersions" returnvariable="getFileVersionsQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfset response = {result=true, fileVersions=getFileVersionsQuery}>
								
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>

	
	<!--- ----------------------- DUPLICATE FILE -------------------------------- --->
	
	<!---Duplica un archivo en la aplicación--->
	
	<cffunction name="duplicateFile" output="false" returntype="query" access="public">		
		<cfargument name="file_id" type="numeric" required="yes">
		<cfargument name="fileTypeId" type="numeric" required="false" default="1">
		
		<cfset var method = "duplicateFile">
		
		<cfset var new_file_id = "">
		<cfset var new_file_physical_name = "">
		<cfset var current_date = "">
		<cfset var fileQuery = "">
		<cfset var destination = "">
					
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">
			
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<!---<cfinvoke component="DateManager" method="getCurrentDateTime" returnvariable="current_date">
			</cfinvoke>
			<cftransaction>
				
				<cfquery name="createFileQuery" datasource="#client_dsn#" result="createFileResult">
					INSERT INTO #client_abb#_files
(name,file_name,user_in_charge,file_size,file_type,uploading_date,description,status)
					VALUES(	<cfqueryparam value="#fileQuery.name#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#fileQuery.file_name#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#fileQuery.file_size#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#fileQuery.file_type#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#current_date#" cfsqltype="cf_sql_timestamp">,			
							<cfqueryparam value="#fileQuery.description#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="pending" cfsqltype="cf_sql_varchar">
						);
				</cfquery>
	
				<cfquery name="getLastInsertId" datasource="#client_dsn#">
					SELECT LAST_INSERT_ID() AS insert_file_id FROM #client_abb#_files;
				</cfquery>
				<cfset new_file_id = getLastInsertId.insert_file_id>
				<cfset new_file_physical_name = new_file_id>
				
			</cftransaction>--->

			<cfinvoke component="FileManager" method="createFile" returnvariable="createFileResult">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfinvokeargument name="name" value="#fileQuery.name#"/>
				<cfinvokeargument name="file_name" value="#fileQuery.file_name#"/>
				<cfinvokeargument name="file_type" value="#fileQuery.file_type#"/>
				<cfinvokeargument name="file_size" value="#fileQuery.file_size#"/>
				<cfinvokeargument name="description" value="#fileQuery.description#"/>

				<cfinvokeargument name="status" value="pending">
			</cfinvoke>	

			<cfif createFileResult.result IS false><!---File insert fail--->
						
				<cfset error_code = 602>
				
				<cfthrow errorcode="#error_code#">
			
			</cfif>
			
			<cfset newObjectFile = createFileResult.objectFile>
			<cfset new_file_id = newObjectFile.id>
			<cfset new_file_physical_name = new_file_id>

			<cfset destination = "#APPLICATION.filesPath#/#client_abb#/">
			<cfset destination = destination&"#fileTypeDirectory#/">

			<!---<cfset files_directory = "files">--->
			<cfset original_source = "#destination##fileQuery.physical_name#">
			<cfset new_source = "#destination##new_file_physical_name#">
			
			<cffile action="copy" destination="#new_source#" source="#original_source#">			
			
			<cftransaction>
				
				<cfquery name="updateFileQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_files
					SET physical_name = <cfqueryparam value="#new_file_physical_name#" cfsqltype="cf_sql_varchar">,
					status = <cfqueryparam value="ok" cfsqltype="cf_sql_varchar">
					WHERE id = <cfqueryparam value="#new_file_id#" cfsqltype="cf_sql_integer">;
				</cfquery>
				
				<cfquery name="updateSpaceUsed" datasource="#client_dsn#">
					UPDATE #client_abb#_users
					SET space_used = space_used+<cfqueryparam value="#fileQuery.file_size#" cfsqltype="cf_sql_integer">
					WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

			</cftransaction>
			
			<!---<cfinvoke component="FileManager" method="objectFile" returnvariable="newObjectFile">
				<cfinvokeargument name="id" value="#new_file_id#">
				<cfinvokeargument name="physical_name" value="#new_file_physical_name#">		
				<cfinvokeargument name="user_in_charge" value="#user_id#">		
				<cfinvokeargument name="name" value="#fileQuery.name#">
				<cfinvokeargument name="file_name" value="#fileQuery.file_name#">

				<cfinvokeargument name="return_type" value="object">
			</cfinvoke>--->	
		
		<cfreturn newObjectFile>		
		
	</cffunction>
	
	
	
	
	
	<!--- ----------------------- GET FILE CONVERTED -------------------------------- --->
	
	<!---Devuelve los datos del archivo convertido--->
	<!---En este método no es necesario comprobar permisos porque esto solo se usa internamente en la aplicación para la conversión de archivos--->
	
	<!---<cffunction name="getFileConverted" output="false" returntype="any" access="public">		
		<cfargument name="get_file_id" type="numeric" required="yes">

        <cfargument name="return_type" type="string" required="no" default="xml">
		
		<cfset var method = "getFileConverted">
		
		<cfset var file_id = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset file_id = arguments.get_file_id>
			
			<cfquery name="selectFileQuery" datasource="#client_dsn#">		
				SELECT physical_name, user_in_charge, file_size, file_type, files.name, file_name, uploading_date, replacement_date, files.description, files.status, users.family_name, files.id AS file_id, users.name AS user_name
				<cfif area_passed IS true>
				, areas_files.association_date
				</cfif>
				FROM #client_abb#_files AS files
				INNER JOIN #client_abb#_users AS users 
				ON files.id=<cfqueryPARAM value="#file_id#" CFSQLType="cf_sql_integer"> AND files.user_in_charge = users.id
				<cfif area_passed IS true>
				INNER JOIN #client_abb#_areas_files AS areas_files 
				ON areas_files.area_id=<cfqueryparam value="#area_id#" cfsqltype="cf_sql_integer"> AND files.id = areas_files.file_id
				</cfif>
				AND status = 'ok';
			</cfquery>
			
			<cfif selectFileQuery.recordCount GT 0>
				
				<cfif arguments.return_type EQ "query">
				
					<cfset xmlResponse = selectFileQuery>				
				
				<cfelse>
					
					<cfinvoke component="FileManager" method="objectFile" returnvariable="objectFile">
							<cfinvokeargument name="id" value="#selectFileQuery.file_id#">
							<cfinvokeargument name="physical_name" value="#selectFileQuery.physical_name#">		
							<cfinvokeargument name="user_in_charge" value="#selectFileQuery.user_in_charge#">		
							<cfinvokeargument name="file_size" value="#selectFileQuery.file_size#">
							<cfinvokeargument name="file_type" value="#selectFileQuery.file_type#">
							<cfinvokeargument name="uploading_date" value="#selectFileQuery.uploading_date#">
							<cfif area_passed IS true>
							<cfinvokeargument name="association_date" value="#selectFileQuery.association_date#">
							</cfif>
							<cfinvokeargument name="replacement_date" value="#selectFileQuery.replacement_date#">
							<cfinvokeargument name="name" value="#selectFileQuery.name#">
							<cfinvokeargument name="file_name" value="#selectFileQuery.file_name#">
							<cfinvokeargument name="description" value="#selectFileQuery.description#">
							<cfinvokeargument name="user_full_name" value="#selectFileQuery.family_name# #selectFileQuery.user_name#">
							<cfinvokeargument name="file_types_conversion" value="#objectFileTypes#">
							<cfinvokeargument name="status" value="#selectFileQuery.status#">
							
							<cfinvokeargument name="return_type" value="object">
					</cfinvoke>	
					
					
					<cfif arguments.return_type EQ "object">
						
						<cfset xmlResponse = objectFile>
					 
					<cfelse>
					
						<cfinvoke component="FileManager" method="xmlFile" returnvariable="xmlResponseContent">
							<cfinvokeargument name="objectFile" value="#objectFile#">
						</cfinvoke>
						
						<cfset xmlResponse = xmlResponseContent>
					
					</cfif>
				
				</cfif>
				
				
			<cfelse><!---File does not exist--->
			
				<cfset error_code = 601>
			
				<cfthrow errorcode="#error_code#">

			</cfif>					
			
		
		<cfreturn xmlResponse>		
		
	</cffunction>--->

	
	<!--- ----------------------- getFileStatus -------------------------------- --->
	
	<!---Devuelve el campo status del archivo en la base de datos, que representa el estado de la subida del archivo al servidor. Si el archivo tiene el status ok, devuelve sus datos--->
	
	<!---
	request:
	<request>
		<parameters>
			<file id=""/>
		</parameters>
	</request>
	response:
	<response component="FileManager" method="getFileStatus" status="ok">
		<result>
			<file id="" status="pending/uploading/ok/error"/>	
		</result>
	</response>
	--->
	
	
	<cffunction name="getFileStatus" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "getFileStatus">
		
		<cfset var file_id = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset file_id = xmlRequest.request.parameters.file.xmlAttributes.id>
			
			<cfquery datasource="#client_dsn#" name="fileQuery">				
				SELECT status, id, physical_name, user_in_charge, file_size, file_type, uploading_date, replacement_date, name, file_name, description
				FROM #client_abb#_files
				WHERE id = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif fileQuery.recordCount GT 0>
				
				<!---En la base de datos si status_replacement está definido y no es "ok"
				significa que se ha solicitado reeplazar ese archivo--->
				<!---<cfif len(fileQuery.status_replacement) GT 0 AND fileQuery.status_replacement NEQ "ok">
					<cfset xmlResult = '<file id="#file_id#" status="#fileQuery.status_replacement#" />'>
				<cfelse>--->
				
					<cfif fileQuery.status EQ "ok">
					
						<cfinvoke component="FileManager" method="objectFile" returnvariable="xmlResult">
							<cfinvokeargument name="id" value="#fileQuery.id#">
							<cfinvokeargument name="physical_name" value="#fileQuery.physical_name#">		
							<cfinvokeargument name="user_in_charge" value="#fileQuery.user_in_charge#">		
							<cfinvokeargument name="file_size" value="#fileQuery.file_size#">
							<cfinvokeargument name="file_type" value="#fileQuery.file_type#">
							<cfinvokeargument name="uploading_date" value="#fileQuery.uploading_date#">
							<cfinvokeargument name="replacement_date" value="#fileQuery.replacement_date#">
							<cfinvokeargument name="name" value="#fileQuery.name#">
							<cfinvokeargument name="file_name" value="#fileQuery.file_name#">
							<cfinvokeargument name="description" value="#fileQuery.description#">
							<cfinvokeargument name="status" value="#fileQuery.status#">
							
							<cfinvokeargument name="return_type" value="xml">
						</cfinvoke>
					
					
					<cfelse>
						
						<cfset xmlResult = '<file id="#file_id#" status="#fileQuery.status#" />'>
						
					</cfif>
				
				<!---</cfif>--->
				
				<cfset xmlResponseContent = xmlResult>
				
				<cfinclude template="includes/functionEndNoLog.cfm">
			
			<cfelse><!---The file does not exist (is not found)--->
				
				<cfset xmlResponseContent = arguments.request>
				<cfset error_code = 601>
				
				<cfthrow errorcode="#error_code#">
							
			</cfif>		
		
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>		
		
	</cffunction>
	
	
	<!--- ----------------------- getAreaItemFileStatus -------------------------------- --->
	
	<!---Devuelve el campo status del archivo en la base de datos, que representa el estado de la subida del archivo al servidor. Si el archivo tiene el status ok, devuelve sus datos--->
	
	<!---
	request:
	<request>
		<parameters>
			<file id=""/>
		</parameters>
	</request>
	response:
	<response component="FileManager" method="getFileStatus" status="ok">
		<result>
			<file id="" status="pending/uploading/ok/error"/>	
		</result>
	</response>
	--->
	
	
	<cffunction name="getAreaItemFileStatus" returntype="string" output="false" access="public">		
		<cfargument name="file_id" type="numeric" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="file_type" type="string" required="no" default="file"><!---file/image--->
		<cfargument name="send_alert" type="boolean" required="no" default="true">
		<cfargument name="action" type="string" required="no" default="new">
		
		<cfset var method = "getAreaItemFileStatus">
		
		<cfset var item_id = "">
		<cfset var itemQuery = "">
			
			<cfinclude template="includes/functionStartOnlySession.cfm">
			
			<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">
			
						
			<cfquery datasource="#client_dsn#" name="fileQuery">				
				SELECT status_replacement, status, id, physical_name, user_in_charge, file_size, file_type, uploading_date, replacement_date, name, file_name, description
				FROM #client_abb#_files
				WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif fileQuery.recordCount GT 0>
				
				<!---En la base de datos si status_replacement está definido y no es "ok"
				significa que se ha solicitado reeplazar ese archivo--->
				<cfif len(fileQuery.status_replacement) GT 0 AND fileQuery.status_replacement NEQ "ok">
				
					<cfset xmlResult = '<file id="#file_id#" status="#fileQuery.status_replacement#" />'>
					
				<cfelse>
				
					<cfif fileQuery.status EQ "ok" OR fileQuery.status EQ "uploaded"><!---El estado uploaded indica que se ha subido el archivo pero que no se ha notificado--->
						
						<cfif fileQuery.status EQ "uploaded">
							<cfquery datasource="#client_dsn#" name="getAreaItem">
								SELECT id, status
								FROM #client_abb#_#itemTypeTable#
								<cfif arguments.file_type EQ "file">
								WHERE attached_file_id = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">;
								<cfelseif arguments.file_type EQ "image">
								WHERE  attached_image_id = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">;
								</cfif>
							</cfquery>
							<cfset item_id = getAreaItem.id>
							
							<cfif arguments.send_alert IS true>
							
								<cfinvoke component="AreaItemManager" method="getItem" returnvariable="getItemResponse">
									<cfinvokeargument name="item_id" value="#item_id#">
									<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
									<cfinvokeargument name="return_type" value="query">
								</cfinvoke>
								
								<cfset itemQuery = getItemResponse.item>

								<cfinvoke component="AlertManager" method="newAreaItem">
									<cfinvokeargument name="objectItem" value="#itemQuery#">
									<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
									<cfinvokeargument name="action" value="#arguments.action#">
								</cfinvoke>
								
							</cfif>
							
							<cfquery datasource="#client_dsn#" name="updateFileStatus">				
								UPDATE #client_abb#_files
								SET status = 'ok'
								WHERE id = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">;
							</cfquery>
							<cfif getAreaItem.status NEQ "ok">
								<cfquery datasource="#client_dsn#" name="updateItemStatus">				
									UPDATE #client_abb#_#itemTypeTable#
									SET status = 'ok'
									WHERE id = <cfqueryparam value="#item_id#" cfsqltype="cf_sql_integer">;
								</cfquery>
							</cfif>
						</cfif>	
						
						<cfinvoke component="FileManager" method="objectFile" returnvariable="xmlResult">
							<cfinvokeargument name="id" value="#fileQuery.id#">
							<cfinvokeargument name="physical_name" value="#fileQuery.physical_name#">		
							<cfinvokeargument name="user_in_charge" value="#fileQuery.user_in_charge#">		
							<cfinvokeargument name="file_size" value="#fileQuery.file_size#">
							<cfinvokeargument name="file_type" value="#fileQuery.file_type#">
							<cfinvokeargument name="uploading_date" value="#fileQuery.uploading_date#">
							<cfinvokeargument name="replacement_date" value="#fileQuery.replacement_date#">
							<cfinvokeargument name="name" value="#fileQuery.name#">
							<cfinvokeargument name="file_name" value="#fileQuery.file_name#">
							<cfinvokeargument name="description" value="#fileQuery.description#">
							<cfinvokeargument name="status" value="ok">
							
							<cfinvokeargument name="return_type" value="xml">
						</cfinvoke>
					
					
					<cfelse>
						
						<cfset xmlResult = '<file id="#file_id#" status="#fileQuery.status#" />'>
						
					</cfif>
				
				</cfif>
				
				<cfset xmlResponseContent = xmlResult>
				
				
			
			<cfelse><!---The file does not exist (is not found)--->
				
				<cfset xmlResponseContent = arguments.request>
				<cfset error_code = 601>
				
				<cfthrow errorcode="#error_code#">
							
			</cfif>		
		
		
		<cfreturn xmlResponseContent>		
		
	</cffunction>
	
	
	
	<!--- ----------------------- getMessageFileStatus -------------------------------- --->
	
	<!---Devuelve el campo status del archivo en la base de datos, que representa el estado de la subida del archivo al servidor. Si el archivo tiene el status ok, devuelve sus datos
	Este método se mantiene por COMPATIBILIDAD con la versión de cliente Flex, pero debe ser sustituido por getAreaItemFileStatus, que se llama desde MessageManager.cfc
	--->
	
	<!---
	request:
	<request>
		<parameters>
			<file id=""/>
		</parameters>
	</request>
	response:
	<response component="FileManager" method="getFileStatus" status="ok">
		<result>
			<file id="" status="pending/uploading/ok/error"/>	
		</result>
	</response>
	--->
	
	
	<!---
	<cffunction name="getMessageFileStatus" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "getMessageFileStatus">
		
		<cfset var file_id = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset file_id = xmlRequest.request.parameters.file.xmlAttributes.id>
			
			
			<cfinvoke component="FileManager" method="getAreaItemFileStatus" returnvariable="xmlResponseContent">
				<cfinvokeargument name="file_id" value="#file_id#">
				<cfinvokeargument name="itemTypeId" value="#messageTypeId#">
			</cfinvoke>
			
			<cfinclude template="includes/functionEndNoLog.cfm">
		
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>		
		
	</cffunction>---->
	
	
	<!--- ----------------------- getImageFileStatus -------------------------------- --->
	
	<!---Devuelve el campo status del archivo en la base de datos, que representa el estado de la subida del archivo al servidor. Si el archivo tiene el status ok, devuelve sus datos.
	Este método recibe el parámetro type, que puede ser area_image o user_image, y que define el tipo de archivo de imagen sobre el que se hace la petición.--->
	
	<!---
	request:
	<request>
		<parameters>
			<file id=""/>
			<image_type></image_type>
		</parameters>
	</request>
	response:
	<response component="FileManager" method="getImageFileStatus" status="ok">
		<result>
			<file id="" status="pending/uploading/ok/error"/>	
		</result>
	</response>
	--->
	
	
	<cffunction name="getImageFileStatus" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
		
		<cfset var method = "getImageFileStatus">
		
		<cfset var file_id = "">
		<cfset var type = "">
		
		<cfset var files_table = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset file_id = xmlRequest.request.parameters.file.xmlAttributes.id>
			<cfset type = xmlRequest.request.parameters.image_type.xmlText>
			
			<cfswitch expression="#type#">
			
				<cfcase value="area_image">
					<cfset files_table = "#client_abb#_areas_images">
					<!---<cfset files_directory = "areas_images">
					<cfset association_table = "areas">--->
					
				</cfcase>
				
				<cfcase value="user_image">
					<cfset files_table = "#client_abb#_users_images">
					<!---<cfset files_directory = "users_images">
					<cfset association_table = "users">--->
					
				</cfcase>
			
			</cfswitch>
			
				
			<cfquery datasource="#client_dsn#" name="fileQuery">				
				SELECT *
				FROM #files_table#
				WHERE id = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif fileQuery.recordCount GT 0>
				
				<!---En la base de datos si status_replacement está definido y no es "ok"
				significa que se ha solicitado reeplazar ese archivo--->
				<cfif len(fileQuery.status_replacement) GT 0 AND fileQuery.status_replacement NEQ "ok">
				
					<cfset xmlResult = '<file id="#file_id#" status="#fileQuery.status_replacement#" />'>
					
				<cfelse>
				
					<cfif fileQuery.status EQ "ok">
					
						<cfinvoke component="FileManager" method="objectFile" returnvariable="xmlResult">
							<cfinvokeargument name="id" value="#fileQuery.id#">
							<cfinvokeargument name="physical_name" value="#fileQuery.physical_name#">			
							<cfinvokeargument name="file_size" value="#fileQuery.file_size#">
							<cfinvokeargument name="file_type" value="#fileQuery.file_type#">
							<cfinvokeargument name="uploading_date" value="#fileQuery.uploading_date#">
							<cfinvokeargument name="replacement_date" value="#fileQuery.replacement_date#">
							<cfinvokeargument name="file_name" value="#fileQuery.file_name#">
							<cfinvokeargument name="status" value="#fileQuery.status#">
							
							<cfinvokeargument name="return_type" value="xml">
						</cfinvoke>
					
					<cfelse>
						
						<cfset xmlResult = '<file id="#file_id#" status="#fileQuery.status#" />'>
						
					</cfif>
				
				</cfif>
				
				<cfset xmlResponseContent = xmlResult>
				
				<cfinclude template="includes/functionEnd.cfm">
			
			<cfelse><!---The file does not exist (is not found)--->
				
				<cfset xmlResponseContent = arguments.request>
				<cfset error_code = 601>
				
				<cfthrow errorcode="#error_code#">
							
			</cfif>	
			
			
			<cfset xmlResponseContent = xmlResult>
					
			<cfinclude template="includes/functionEnd.cfm">							
		
			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>		
		
	</cffunction>
	

	<!--- ----------------------- CREATE FILE -------------------------------- --->
	
	<cffunction name="createFile" returntype="struct" output="false" access="public">
		<cfargument name="fileTypeId" type="numeric" required="true"/>		
		<cfargument name="name" type="string" required="true"/>
		<cfargument name="file_name" type="string" required="true"/>
		<cfargument name="file_size" type="numeric" required="true"/>
		<!---<cfargument name="file_size_full" type="numeric" required="true"/>--->
		<cfargument name="file_type" type="string" required="true"/>
		<cfargument name="description" type="string" required="true"/>
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="reviser_user" type="numeric" required="false">
		<cfargument name="approver_user" type="numeric" required="false">

		<!---<cfargument name="folder_id" type="numeric" required="false"/>--->
		
		<!---Este parametro se le pasa cuando se adjunta un archivo a un mensaje, que primero se crea el mensaje y luego se sube--->
		<cfargument name="status" type="string" required="no" default="">
		
		<!---Este metodo necesitaba recibir variables de sesión como argumentos porque en cuando se suben archivos en Flex desde Firefox no se puede acceder a las variables de sesion--->		

		<cfset var method = "createFile">

		<cfset var response = structNew()>
		
		<cfset var file_id = "">
				
		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">
				
			<cfif arguments.fileTypeId IS NOT 1><!--- area_id required in fileTypeId 2 OR fileTypeId 3 --->
				
				<!---checkAreaAccess--->
				<cfinclude template="includes/checkAreaAccess.cfm">

			</cfif>
			
			<cfinvoke component="DateManager" method="getCurrentDateTime" returnvariable="current_date">
			</cfinvoke>
			
			<!---<cfinvoke component="DateManager" method="timestampToString" returnvariable="stringCurrentDate">
				<cfinvokeargument name="timestamp_date" value="#current_date#">
			</cfinvoke>

			<cfset objectFile.user_in_charge = user_id>
			<cfset objectFile.uploading_date = stringCurrentDate>--->

			<cfquery name="selectUserFileQuery" datasource="#client_dsn#">
				SELECT family_name, name
				FROM #client_abb#_users
				WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif selectUserFileQuery.recordCount IS 0><!---the user does not exist--->
			
				<cfset error_code = 204>
				
				<cfthrow errorcode="#error_code#"> 
			
			</cfif>

			<!---<cfset objectFile.user_full_name = "#selectUserFileQuery.family_name# #selectUserFileQuery.name#">--->
			
			<cftransaction>
			
				<cfquery name="createFileQuery" datasource="#client_dsn#" result="createFileResult">
					INSERT INTO `#client_abb#_#fileTypeTable#`
					SET name = <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
					file_name = <cfqueryparam value="#arguments.file_name#" cfsqltype="cf_sql_varchar">,
					user_in_charge = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
					file_size = <cfqueryparam value="#arguments.file_size#" cfsqltype="cf_sql_integer">,
					file_type = <cfqueryparam value="#arguments.file_type#" cfsqltype="cf_sql_varchar">,
					uploading_date = <cfqueryparam value="#current_date#" cfsqltype="cf_sql_timestamp">,	
					description = <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">,
					status = <cfqueryparam value="pending" cfsqltype="cf_sql_varchar">,
					file_type_id = <cfqueryparam value="#arguments.fileTypeId#" cfsqltype="cf_sql_integer">
					<cfif arguments.fileTypeId IS NOT 1>
						, area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
					</cfif>
					<cfif arguments.fileTypeId IS 3>
						, reviser_user = <cfqueryparam value="#arguments.reviser_user#" cfsqltype="cf_sql_integer">
						, approver_user = <cfqueryparam value="#arguments.approver_user#" cfsqltype="cf_sql_integer">
					</cfif>;
				</cfquery>

				<cfquery name="getLastInsertId" datasource="#client_dsn#">
					SELECT LAST_INSERT_ID() AS insert_file_id FROM #client_abb#_#fileTypeTable#;
				</cfquery>
				<cfset file_id = getLastInsertId.insert_file_id>
				
				<cfquery name="updateFileQuery" datasource="#client_dsn#">
					UPDATE #client_abb#_#fileTypeTable#
					SET physical_name = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_varchar">,
					status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
					WHERE id = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfif arguments.fileTypeId IS 3><!--- File edited version --->
					
					<cfquery name="createFileVersionQuery" datasource="#client_dsn#">
						INSERT INTO `#client_abb#_#fileTypeTable#_versions`
						SET file_id = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">,
						physical_name = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_varchar">,
						file_name = <cfqueryparam value="#arguments.file_name#" cfsqltype="cf_sql_varchar">,
						user_in_charge = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
						file_size = <cfqueryparam value="#arguments.file_size#" cfsqltype="cf_sql_integer">,
						file_type = <cfqueryparam value="#arguments.file_type#" cfsqltype="cf_sql_varchar">,
						uploading_date = <cfqueryparam value="#current_date#" cfsqltype="cf_sql_timestamp">,	
						status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">;
					</cfquery>

				</cfif>
				
				<!--- ------------------ Update User Space Used --------------------- --->
				<!---Esto se hace donde se sube realmente el archivo--->			
			
			</cftransaction>			

			<cfinclude template="includes/logRecord.cfm">

			<!--- getFile --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#file_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
				<cfinvokeargument name="with_lock" value="false">
				<cfinvokeargument name="parse_dates" value="true">
				<cfinvokeargument name="status" value="#arguments.status#">		

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif fileQuery.recordCount IS 0><!---File does not exist--->
			
				<cfset error_code = 601>
			
				<cfthrow errorcode="#error_code#">

			</cfif>		

			<cfset response = {result=true, objectFile=#fileQuery#}>
			
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>		
		
	</cffunction>
	
		
	<!--- ----------------------- DELETE IMAGE FILE -------------------------------- --->
	
	<cffunction name="deleteImageFile" returntype="string" output="false" access="public">		
		<cfargument name="request" type="string" required="yes">
		<!---<cfargument name="file_id" type="string" required="yes">--->
		
		<cfset var method = "deleteImageFile">
		
		<cfset var file_id = "">
		
		<cfset var files_table = "">
		<cfset var files_directory = "">
		<cfset var association_table = "">
		
		<!---<cfinclude template="includes/initVars.cfm">--->	
			
		<cftry>
			
			<cfinclude template="includes/functionStart.cfm">
			
			<cfset file_id = xmlRequest.request.parameters.file.xmlAttributes.id>
			<cfset type = xmlRequest.request.parameters.image_type>
			
			<cfswitch expression="#type#">
			
				<cfcase value="area_image">
					<cfset files_table = "areas_images">
					<cfset files_directory = "areas_images">
					<cfset association_table = "areas">
					
				</cfcase>
				
				<cfcase value="user_image">
					<cfset files_table = "users_images">
					<cfset files_directory = "users_images">
					<cfset association_table = "users">
					
				</cfcase>
			
			</cfswitch>
			
			
			<!--- Query to get the physical name and file_size of the file --->
			<cfquery name="fileQuery" datasource="#client_dsn#">				
				SELECT physical_name, file_size, user_in_charge
				FROM #client_abb#_#files_table#
				WHERE id = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">;
			</cfquery>
			
			<cfif fileQuery.recordCount GT 0>

				<cfif fileQuery.user_in_charge NEQ user_id><!---El usuario del item no es el mismo que el que intenta eliminar--->
					<cfinclude template="includes/checkAdminAccess.cfm">
				</cfif>

				<cftransaction>
					
					<!--- Delete association --->
					<cfquery name="deleteAssociationAreaQuery" datasource="#client_dsn#">
						UPDATE #client_abb#_#association_table#
						SET image_id = <cfqueryparam null="yes" cfsqltype="cf_sql_numeric">
						WHERE image_id = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>			
					
					<!--- Deletion of the row representing the file --->
					<cfquery name="deleteFileQuery" datasource="#client_dsn#">		
						DELETE
						FROM #client_abb#_#files_table#
						WHERE id = <cfqueryparam value="#file_id#" CFSQLType="CF_SQL_integer">;
					</cfquery>
					
					<cfset path = APPLICATION.filesPath&'/#client_abb#/#files_directory#/'>	
					<cfset filePath = path & "#fileQuery.physical_name#">			
					
					<!--- Now we delete physically the file on the server --->
					<cfif FileExists(filePath)><!---If the physical file exist--->
						<cffile action="delete" file="#filePath#">
					<cfelse><!---The physical file does not exist--->
						<cfset error_code = 608>
					
						<cfthrow errorcode="#error_code#">
					</cfif>
					
					<!---Update User Space Used--->
					<cfquery name="updateUserSpaceUsed" datasource="#client_dsn#">
						UPDATE #client_abb#_users
						SET space_used = space_used-#fileQuery.file_size#
						WHERE id = #user_id#;
					</cfquery>	
				
				</cftransaction>
			
				<cfset xmlResponseContent = '<file id="#file_id#" />'>
				
				<cfinclude template="includes/functionEnd.cfm">
			
			
			<cfelse><!---The file does not exist (is not found)--->
			
				<cfset xmlResponseContent = arguments.request>
				<cfset error_code = 601>
				
				<cfthrow errorcode="#error_code#">
							
			</cfif>		
		

			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>		
		
	</cffunction>

	
	
	<!--- ----------------GET ALL AREAS FILES--------------------------------------------   --->
	
	<cffunction name="getAllAreasFiles" output="false" returntype="struct" access="public">
		<cfargument name="search_text" type="string" required="no">
		<cfargument name="user_in_charge" type="numeric" required="no">
		<cfargument name="format_content" type="string" required="no" default="default">
		<cfargument name="with_area" type="boolean" required="no" default="false">

		<cfargument name="name" type="string" required="false">
		<cfargument name="file_name" type="string" required="false">
		<cfargument name="description" type="string" required="false">
		<cfargument name="limit" type="numeric" required="no">
		<cfargument name="from_date" type="string" required="no">
		<cfargument name="end_date" type="string" required="no">
		<cfargument name="typology_id" type="string" required="false">
		
		<cfset var method = "getAllAreasFiles">

		<cfset var response = structNew()>

		<cfset var user_areas_ids = "">

		<cftry>
				
			<cfinclude template="includes/functionStartOnlySession.cfm">
						
			<cfinvoke component="AreaManager" method="getAllUserAreasList" returnvariable="user_areas_ids">
				<cfinvokeargument name="get_user_id" value="#user_id#">
			</cfinvoke>

			<cfif isDefined("arguments.typology_id") AND isNumeric(arguments.typology_id)>
					
				<!--- getTypologiesRowsSearch --->
				<cfinvoke component="#APPLICATION.componentsPath#/RowManager" method="getTypologiesRowsSearch" argumentcollection="#arguments#" returnvariable="getTableRowsResult">
					<cfinvokeargument name="table_id" value="#arguments.typology_id#"/>
					<cfinvokeargument name="tableTypeId" value="#typologyTableTypeId#"/>

					<cfinvokeargument name="areas_ids" value="#user_areas_ids#">
				</cfinvoke>

				<cfif getTableRowsResult.result IS true>
					<cfset response = {result=true, files=#getTableRowsResult.rows#}>
				<cfelse>
					<cfset response = getTableRowsResult>
				</cfif>
				
			<cfelse>
			
				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getAreaFiles" returnvariable="getAreaFilesResult">
					<cfinvokeargument name="areas_ids" value="#user_areas_ids#">
					<cfinvokeargument name="parse_dates" value="true">
					<cfif isDefined("arguments.search_text")>
						<cfinvokeargument name="search_text" value="#arguments.search_text#">
					</cfif>
					<cfif isDefined("arguments.user_in_charge") AND isNumeric(arguments.user_in_charge)>
						<cfinvokeargument name="user_in_charge" value="#arguments.user_in_charge#">
					</cfif>
					<cfinvokeargument name="with_user" value="true">
					<cfinvokeargument name="with_area" value="#arguments.with_area#">
					<cfinvokeargument name="with_typology" value="false">
					<cfif isDefined("arguments.limit")>
					<cfinvokeargument name="limit" value="#arguments.limit#">
					</cfif>
					
					<cfinvokeargument name="name" value="#arguments.name#">
					<cfinvokeargument name="file_name" value="#arguments.file_name#">
					<cfinvokeargument name="description" value="#arguments.description#">
					<cfif isDefined("arguments.from_date")>
					<cfinvokeargument name="from_date" value="#arguments.from_date#">
					</cfif>
					<cfif isDefined("arguments.end_date")>
					<cfinvokeargument name="end_date" value="#arguments.end_date#">
					</cfif>				
					
					<!---<cfif APPLICATION.moduleAreaFilesLite IS true>
						<cfinvokeargument name="with_area_files_lite" value="true">
					</cfif>--->

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfset response = {result=true, files=#getAreaFilesResult.query#}>

			</cfif>

			<!---<cfset areaFilesQuery = getAreaFilesResult.query>
			
			<cfset xmlItems=''>
			<cfif areaFilesQuery.recordCount GT 0>
					
				<cfset xmlItems = '<files>'>
					
				<cfloop query="areaFilesQuery">
					
					<cfinvoke component="FileManager" method="objectFile" returnvariable="xmlResultItem">
						<cfinvokeargument name="id" value="#areaFilesQuery.id#">
						<cfinvokeargument name="name" value="#areaFilesQuery.name#">
						<cfinvokeargument name="user_in_charge" value="#areaFilesQuery.user_in_charge#">
						<cfinvokeargument name="association_date" value="#areaFilesQuery.association_date#">
						<cfinvokeargument name="replacement_date" value="#areaFilesQuery.replacement_date#">
						<cfinvokeargument name="user_full_name" value="#areaFilesQuery.family_name# #areaFilesQuery.user_name#">
						<cfinvokeargument name="file_type" value="#areaFilesQuery.file_type#">
						
						<!---<cfinvokeargument name="description" value="#areaFilesQuery.description#">--->
						
						<cfif arguments.with_area IS true>
							<cfinvokeargument name="area_name" value="#areaFilesQuery.area_name#">
							<cfinvokeargument name="area_id" value="#areaFilesQuery.area_id#">	
						</cfif>

						<cfinvokeargument name="return_type" value="xml">
					</cfinvoke>
					
					<cfset xmlItems = xmlItems&xmlResultItem>
					
				</cfloop>

				<cfset xmlItems = xmlItems&'</files>'>

			<cfelse>	
				<cfset xmlItems='<files/>'>	
			</cfif>			
						
			<cfset xmlResponseContent = xmlItems>
					
			<cfset xmlResponse = xmlResponseContent>
		
		<cfreturn xmlResponse>--->

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>
	<!--- ------------------------------------------------------------------------------  --->	
	
	
	
	<!--- ----------------------------------- uploadNewFile -------------------------------------- --->

	<cffunction name="uploadNewFile" output="false" returntype="struct" access="public">
		<cfargument name="fileTypeId" type="numeric" required="true"/>
		<cfargument name="name" type="string" required="true"/>
		<cfargument name="description" type="string" required="true"/>
		<cfargument name="Filedata" type="string" required="true"/>
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="typology_id" type="string" required="false">
		<cfargument name="reviser_user" type="numeric" required="false">
		<cfargument name="approver_user" type="numeric" required="false">

		<cfset var method = "uploadNewFile">

		<cfset var response = structNew()>

		<cfset var destination = "">
		<cfset var upload_file_id = "">
					
		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">
		
			<!---Esto es para la asociación de archivos directamente desde las áreas--->
			<!---
			Los directorios de los usuarios ya no se usan
			<cfinvoke component="#APPLICATION.componentsPath#/FolderManager" method="getUserRootFolderId" returnvariable="root_folder_id">
			</cfinvoke>		
			<cfset folder_id = root_folder_id>--->

			<cfset destination = "#APPLICATION.filesPath#/#client_abb#/">
			<cfset destination = destination&"#fileTypeDirectory#/">
			
			<cfif directoryExists(destination) IS false>
				
				 <cfdirectory action="create" directory="#destination#">

			</cfif>

			<cffile action="upload" filefield="Filedata" destination="#destination#" nameconflict="overwrite" result="uploadedFile">
		
			<cfset temp_file="#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#">	
			
			<cfinvoke component="FileManager" method="createFile" returnvariable="createFileResult">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfinvokeargument name="name" value="#arguments.name#"/>
				<cfinvokeargument name="file_name" value="#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#"/>
				<cfinvokeargument name="file_type" value=".#uploadedFile.clientFileExt#"/>
				<cfinvokeargument name="file_size" value="#uploadedFile.fileSize#"/>
				<cfinvokeargument name="description" value="#arguments.description#"/>
				<cfinvokeargument name="reviser_user" value="#arguments.reviser_user#"/>
				<cfinvokeargument name="approver_user" value="#arguments.approver_user#"/>
				<cfinvokeargument name="status" value="ok">

				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
			</cfinvoke>	

			<cfif createFileResult.result IS false><!---File insert fail--->
			
				<cffile action="delete" file="#destination##temp_file#">
			
				<cfset error_code = 602>
				
				<cfthrow errorcode="#error_code#">
			
			</cfif>
				
			<cftry>
				
				<cfset objectFile = createFileResult.objectFile>

				<cfset upload_file_id = createFileResult.objectFile.id>

				<!--- setFileTypology --->
				<cfif isDefined("arguments.typology_id") AND isNumeric(arguments.typology_id)>

					<cfset arguments.file_id = upload_file_id>
					
					<cfinvoke component="FileManager" method="setFileTypology" argumentcollection="#arguments#" returnvariable="setFileTypologyResponse">
					</cfinvoke>

					<cfif setFileTypologyResponse.result IS false>

						<cfthrow message="#setFileTypologyResponse.message#">
	
					</cfif>

				</cfif>	

				
				<!--- ------------------ Update User Space Used --------------------- --->
				<cfquery name="updateSpaceUsed" datasource="#client_dsn#">
					UPDATE #client_abb#_users
					SET space_used = space_used+<cfqueryparam value="#uploadedFile.fileSize#" cfsqltype="cf_sql_integer">
					WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
				</cfquery>	

				<!--- associateFileToArea --->
				<cfinvoke component="FileManager" method="associateFileToArea">
					<cfinvokeargument name="objectFile" value="#objectFile#"/>
					<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				</cfinvoke>

				<!---
				<!--- newAreaFile --->
				<cfinvoke component="AlertManager" method="newFile">
					<cfinvokeargument name="objectFile" value="#objectFile#">
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
					<cfinvokeargument name="action" value="new">
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
				</cfinvoke>--->

				<cffile action="rename" source="#destination##temp_file#" destination="#destination##upload_file_id#">

				<cfcatch><!---The upload fail--->

					<cfif isDefined("upload_file_id")>
						<cfquery datasource="#client_dsn#" name="changeFileStatus">
							UPDATE #client_abb#_#fileTypeTable#
							SET status = <cfqueryparam value="failed" cfsqltype="cf_sql_varchar">
							WHERE id = <cfqueryparam value="#upload_file_id#" cfsqltype="cf_sql_integer">;
						</cfquery>
					</cfif>

					<cffile action="delete" file="#destination##temp_file#">
					
					<!---<cfset error_code = 604>--->
			
					<cfthrow object="#cfcatch#">
				
				</cfcatch>
			</cftry>

			<cfset response = {result=true, file_id=#upload_file_id#}>	


		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>



	<!--- ----------------------- UPDATE FILE -------------------------------- --->
	
	<cffunction name="updateFile" returntype="struct" output="false" access="public">		
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="typology_id" type="string" required="false">
		<cfargument name="reviser_user" type="numeric" required="false">
		<cfargument name="approver_user" type="numeric" required="false">
		
		<cfset var method = "updateFile">

		<cfset var response = structNew()>

		<cfset var fileQuery = "">
					
		<cftry>
			
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<!---<cfinvoke component="FileManager" method="getFile" returnvariable="fileQuery">				
				<cfinvokeargument name="get_file_id" value="#arguments.file_id#">
			
				<cfinvokeargument name="return_type" value="query">
			</cfinvoke>--->
			<!--- getFile --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
				<cfif arguments.fileTypeId IS NOT 1>
					<cfinvokeargument name="with_lock" value="true">
				</cfif>
				<cfinvokeargument name="parse_dates" value="false">		

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>			

			<!---canUserModifyFile--->
			<cfinvoke component="FileManager" method="canUserModifyFile" returnvariable="canUserModifyFileResponse">
				<cfinvokeargument name="fileQuery" value="#fileQuery#">
			</cfinvoke>
			<cfif canUserModifyFileResponse.result IS false>
				
				<cfreturn canUserModifyFileResponse>

			</cfif>

			<!---<cftransaction> No se puede usar aquí transacción porque dentro de setFileTypology hay transacciones--->

			<cfquery name="updateFileQuery" datasource="#client_dsn#">
				UPDATE `#client_abb#_#fileTypeTable#`
				SET name = <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
				description = <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar">
				<cfif arguments.fileTypeId IS 3>
					, reviser_user = <cfqueryparam value="#arguments.reviser_user#" cfsqltype="cf_sql_integer">
					, approver_user = <cfqueryparam value="#arguments.approver_user#" cfsqltype="cf_sql_integer">
				</cfif>
				WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
			</cfquery>	

			<!--- setFileTypology --->
			<cfif isDefined("arguments.typology_id") AND isNumeric(arguments.typology_id)>
				
				<cfinvoke component="FileManager" method="setFileTypology" argumentcollection="#arguments#" returnvariable="setFileTypologyResponse">
				</cfinvoke>

				<cfif setFileTypologyResponse.result IS false>

					<cfthrow message="#setFileTypologyResponse.message#">

				</cfif>

				<cfif fileQuery.typology_id NEQ arguments.typology_id AND isNumeric(fileQuery.typology_row_id)><!---File typology was changed--->
					
					<cfinvoke component="RowManager" method="deleteRow" returnvariable="deleteRowResponse">
						<cfinvokeargument name="row_id" value="#fileQuery.typology_row_id#"/>
						<cfinvokeargument name="table_id" value="#fileQuery.typology_id#"/>
						<cfinvokeargument name="tableTypeId" value="#typologyTableTypeId#"/>
					</cfinvoke>

					<cfif deleteRowResponse.result IS false>
						<cfthrow message="#deleteRowResponse.message#">
					</cfif>

				</cfif>

			</cfif>		

			<!---</cftransaction>--->				
			
			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, file_id=#arguments.file_id#}>
			
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>	
		
	</cffunction>


	<!--- --------------------------------- canUserModifyFile ---------------------------------  --->
	
	<cffunction name="canUserModifyFile" output="false" access="private" returntype="struct">
		<cfargument name="fileQuery" type="query" required="true">

		<cfset var method = "canUserModifyFile">

		<cfset var response = structNew()>
		<cfset var area_id = "">

		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfif fileQuery.recordCount IS 0><!---File does not exist--->
			
			<cfset error_code = 601>
		
			<cfthrow errorcode="#error_code#">

		</cfif>		

		<cfif fileQuery.file_type_id IS NOT 1><!--- Area file --->

			<cfset area_id = fileQuery.area_id>
			
			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">

		<cfelseif fileQuery.user_in_charge NEQ user_id><!--- User file --->

			<cfset error_code = 103><!---Access denied--->
				
			<cfthrow errorcode="#error_code#">

		</cfif>


		<cfif fileQuery.locked IS true AND fileQuery.lock_user_id NEQ user_id>

			<cfset response = {result=false, file_id=#fileQuery.file_id#, message="El archivo está bloqueado por otro usuario y no puede ser modificado."}>

		<cfelseif fileQuery.locked IS false AND fileQuery.file_type_id IS NOT 1>

			<cfset response = {result=false, file_id=#fileQuery.file_id#, message="Debe bloquear el archivo para poder modificarlo."}>

		<cfelseif fileQuery.in_approval IS true>

			<cfset response = {result=false, file_id=#fileQuery.file_id#, message="No se puede modificar un archivo en proceso de aprobación."}>

		<cfelse>

			<cfset response = {result=true}>

		</cfif>

		<cfreturn response>

	</cffunction>




	<!--- ----------------------------------- replaceFile -------------------------------------- --->

	<cffunction name="replaceFile" output="false" returntype="struct" access="public">
		<cfargument name="file_id" type="string" required="true"/>
		<cfargument name="fileTypeId" type="numeric" required="true" />
		<cfargument name="Filedata" type="string" required="true"/>
		<cfargument name="unlock" type="boolean" required="false" default="false">
		
		<cfset var method = "replaceFile">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var destination = "">
		<cfset var temp_file = "">
		<cfset var new_physical_name = "">
		<cfset var fileQuery = "">
					
		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfset destination = "#APPLICATION.filesPath#/#client_abb#/">
			<cfset destination = destination&"#fileTypeDirectory#/">
			
			<!--- getFile --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
				<cfif arguments.fileTypeId IS NOT 1>
					<cfinvokeargument name="with_lock" value="true">
				</cfif>
				<cfinvokeargument name="parse_dates" value="false">		

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
		
			<!---canUserModifyFile--->
			<cfinvoke component="FileManager" method="canUserModifyFile" returnvariable="canUserModifyFileResponse">
				<cfinvokeargument name="fileQuery" value="#fileQuery#">
			</cfinvoke>
			<cfif canUserModifyFileResponse.result IS false>
				
				<cfreturn canUserModifyFileResponse>

			</cfif>

			<!---<cffile action="delete" file="#destination##fileQuery.physical_name#">--->	
			
			<cffile action="upload" filefield="Filedata" destination="#destination#" nameconflict="overwrite" result="uploadedFile">
				
			<cfset temp_file="#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#">

			<cftry>

				<cfset file_name = "#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#">
				<cfset file_type = lCase(".#uploadedFile.clientFileExt#")>
				<cfset file_size_full = uploadedFile.fileSize>

				<cftransaction>

					<cfif arguments.fileTypeId IS 3><!--- Save new version --->

						<cfquery name="insertFileVersionQuery" datasource="#client_dsn#">
							INSERT INTO `#client_abb#_#fileTypeTable#_versions`
							SET file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">,
							file_name = <cfqueryparam value="#file_name#" cfsqltype="cf_sql_varchar">,
							user_in_charge = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
							file_size = <cfqueryparam value="#file_size_full#" cfsqltype="cf_sql_integer">,
							file_type = <cfqueryparam value="#file_type#" cfsqltype="cf_sql_varchar">,
							uploading_date = NOW(),	
							status = <cfqueryparam value="pending" cfsqltype="cf_sql_varchar">;
						</cfquery>

						<cfquery name="getLastInsertId" datasource="#client_dsn#">
							SELECT LAST_INSERT_ID() AS insert_version_id FROM `#client_abb#_#fileTypeTable#_versions`;
						</cfquery>
						<cfset version_id = getLastInsertId.insert_version_id>

						<cfset new_physical_name = "#file_id#_#version_id#">

						<cfquery name="updateFileVersionQuery" datasource="#client_dsn#">
							UPDATE `#client_abb#_#fileTypeTable#_versions`
							SET physical_name = <cfqueryparam value="#new_physical_name#" cfsqltype="cf_sql_varchar">,
							status = <cfqueryparam value="ok" cfsqltype="cf_sql_varchar">
							WHERE version_id = <cfqueryparam value="#version_id#" cfsqltype="cf_sql_integer">;
						</cfquery>

					<cfelse>

						<cfset new_physical_name = fileQuery.physical_name>
						
					</cfif>
					
					
					<cfquery name="updateUploadingFile" datasource="#client_dsn#">
						UPDATE #client_abb#_#fileTypeTable#
						SET replacement_date = NOW(), 
						file_size = <cfqueryparam value="#file_size_full#" cfsqltype="cf_sql_integer">,
						file_type = <cfqueryparam value="#file_type#" cfsqltype="cf_sql_varchar">,
						file_name = <cfqueryparam value="#file_name#" cfsqltype="cf_sql_varchar">,
						status = 'ok',
						status_replacement = 'uploaded'
						<cfif arguments.fileTypeId IS 3>
						, physical_name = <cfqueryparam value="#new_physical_name#" cfsqltype="cf_sql_varchar">
						</cfif>
						WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
					<!--- ------------------ Update User Space Used --------------------- --->
					<cfquery name="updateSpaceUsed" datasource="#client_dsn#">
						UPDATE #client_abb#_users
						SET space_used = space_used-#fileQuery.file_size#+<cfqueryparam value="#file_size_full#" cfsqltype="cf_sql_integer">
						WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
				
				</cftransaction>

				<cfcatch>
					
					<cffile action="delete" file="#destination##temp_file#">
					
					<cfrethrow>
				
				</cfcatch>
			</cftry>

			<cftry>
				
				<cffile action="rename" source="#destination##temp_file#" destination="#destination##new_physical_name#" nameconflict="overwrite">

				<!--- getFile --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileReplacedQuery">
					<cfinvokeargument name="file_id" value="#arguments.file_id#">
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
					<cfinvokeargument name="with_lock" value="false">
					<cfinvokeargument name="parse_dates" value="true">		

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif fileReplacedQuery.recordCount IS 0><!---File does not exist--->
	
					<cfset error_code = 601>
				
					<cfthrow errorcode="#error_code#">

				</cfif>
			
				<cfcatch><!---The upload fail--->
				
					<cfquery datasource="#client_dsn#" name="changeFileStatus">
						UPDATE #client_abb#_files
						SET status = 'failed'
						WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
					<!---<cfset error_code = 604>
					<cfthrow errorcode="#error_code#">--->

					<cfrethrow>
				
				</cfcatch>
			</cftry>

			<cfinclude template="includes/logRecord.cfm">

			<!--- Alert --->
			<cfif arguments.fileTypeId IS NOT 3><!--- User document --->
				
				<!--- Replace file --->
				<cfinvoke component="AlertManager" method="replaceFile">
					<cfinvokeargument name="objectFile" value="#fileReplacedQuery#">
				</cfinvoke>

			<cfelse><!--- Area document --->
			
				<cfset area_id = fileQuery.area_id>

				<!--- New version --->
				<cfinvoke component="AlertManager" method="newFile">
					<cfinvokeargument name="objectFile" value="#fileReplacedQuery#">
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfinvokeargument name="action" value="new_version">
				</cfinvoke>	

			</cfif>
			
			<!--- Unlock file --->
			<cfif arguments.fileTypeId IS NOT 1 AND arguments.unlock IS true>
				
				<cfinvoke component="FileManager" method="changeAreaFileLock" returnvariable="changeLockResponse">
					<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
					<cfinvokeargument name="lock" value="false"/>
				</cfinvoke>

				<cfif changeLockResponse.result IS false>
					
					<cfreturn changeLockResponse>

				</cfif>
	
			</cfif>

			<cfset response = {result=true, file_id=#arguments.file_id#}>

		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>
	

	<!--- ----------------------------------- setFileTypology -------------------------------------- --->

	<cffunction name="setFileTypology" output="false" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="table_id" type="numeric" required="true">
		<cfargument name="tableTypeId" type="numeric" required="true">
		<cfargument name="action" type="string" required="true">

		<cfset var method = "setFileTypology">

		<cfset var response = structNew()>
					
		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfinvoke component="RowManager" method="saveRow" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>

			<cfif response.result IS true AND arguments.action IS "create">

				<cfquery datasource="#client_dsn#" name="setFileTypology">
					UPDATE #client_abb#_#fileTypeTable#
					SET typology_id = <cfqueryparam value="#response.table_id#" cfsqltype="cf_sql_integer">,
					typology_row_id = <cfqueryparam value="#response.row_id#" cfsqltype="cf_sql_integer">
					WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>



	<!--- ----------------------------------- changeFileUser -------------------------------------- --->

	<cffunction name="changeFileUser" output="false" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="new_user_in_charge" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="false"><!--- area_id NOT required when changes item file or image --->

		<cfset var method = "changeFileUser">

		<cfset var response = structNew()>
					
		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfif isDefined("arguments.area_id")>
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfif>
				<cfinvokeargument name="with_lock" value="true">
				<cfinvokeargument name="parse_dates" value="true">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<!---canUserModifyFile--->
			<cfinvoke component="FileManager" method="canUserModifyFile" returnvariable="canUserModifyFileResponse">
				<cfinvokeargument name="fileQuery" value="#fileQuery#">
			</cfinvoke>
			<cfif canUserModifyFileResponse.result IS false>
				
				<cfreturn canUserModifyFileResponse>

			</cfif>					

			<cfif fileQuery.user_in_charge NEQ user_id>
				
				<cfif isDefined("arguments.area_id")>
					<!---checkAreaResponsibleAccess--->
					<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
						<cfinvokeargument name="area_id" value="#area_id#">
					</cfinvoke>
				<cfelse>
					<!---checkAdminAccess--->
					<cfinvoke component="AreaManager" method="checkAdminAccess">
					</cfinvoke>
				</cfif>
				
			</cfif>

			<cfif fileQuery.user_in_charge EQ arguments.new_user_in_charge>
				
				<cfset response = {result=false, file_id=#arguments.file_id#, message="El usuario seleccionado es el propietario del archivo"}>

			<cfelse>			

				<cftransaction>
					
					<cfquery datasource="#client_dsn#" name="changeFileUserInCharge">
						UPDATE #client_abb#_files
						SET user_in_charge = <cfqueryparam value="#arguments.new_user_in_charge#" cfsqltype="cf_sql_integer">
						WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<cfquery datasource="#client_dsn#" name="updateOldUserSpaceUsed">
						UPDATE #client_abb#_users
						SET space_used = space_used - #fileQuery.file_size#
						WHERE id = <cfqueryparam value="#fileQuery.user_in_charge#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<cfquery datasource="#client_dsn#" name="updateNewUserSpaceUsed">
						UPDATE #client_abb#_users
						SET space_used = space_used + #fileQuery.file_size#
						WHERE id = <cfqueryparam value="#arguments.new_user_in_charge#" cfsqltype="cf_sql_integer">;
					</cfquery>

				</cftransaction>

				<cfif isDefined("arguments.area_id")>
					
					<!---Send Alert--->
					<cfinvoke component="AlertManager" method="changeFileUser">
						<cfinvokeargument name="objectFile" value="#fileQuery#">
						<cfinvokeargument name="area_id" value="#arguments.area_id#">
						<cfinvokeargument name="old_user_id" value="#fileQuery.user_in_charge#">
						<cfinvokeargument name="new_user_id" value="#arguments.new_user_in_charge#">
					</cfinvoke>	

				</cfif>

				<cfinclude template="includes/logRecord.cfm">

				<cfset response = {result=true, file_id=#arguments.file_id#}>

			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>



	<!--- ----------------------------------- changeFileArea -------------------------------------- --->

	<cffunction name="changeFileArea" output="false" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="new_area_id" type="numeric" required="true">

		<cfset var method = "changeFileArea">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var fileQuery = "">
					
		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfif APPLICATION.changeElementsArea IS false>
				<cfthrow message="Función no disponible">
			</cfif>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="with_lock" value="true">
				<cfinvokeargument name="parse_dates" value="true">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<!---canUserModifyFile--->
			<cfinvoke component="FileManager" method="canUserModifyFile" returnvariable="canUserModifyFileResponse">
				<cfinvokeargument name="fileQuery" value="#fileQuery#">
			</cfinvoke>
			<cfif canUserModifyFileResponse.result IS false>
				
				<cfreturn canUserModifyFileResponse>

			</cfif>	

			<cfif fileQuery.user_in_charge NEQ user_id>
				
				<cfif isNumeric(fileQuery.area_id)>
					<cfset area_id = fileQuery.area_id>
					<!---checkAreaResponsibleAccess--->
					<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
						<cfinvokeargument name="area_id" value="#area_id#">
					</cfinvoke>
				<cfelse>
					<!---checkAdminAccess--->
					<cfinvoke component="AreaManager" method="checkAdminAccess">
					</cfinvoke>
				</cfif>
				
			</cfif>

			<cfif fileQuery.file_type_id IS 1>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="Para cambiar de área este tipo de archivo debe asociarlo a la nueva área y quitarlo de la actual"}>
			
			<cfelseif fileQuery.area_id EQ arguments.new_area_id>
				
				<cfset response = {result=false, file_id=#arguments.file_id#, message="El área seleccionada es la misma que la actual del archivo"}>

			<cfelse>		

				<!--- associateFileToArea --->
				<cfinvoke component="FileManager" method="associateFileToArea">				
					<cfinvokeargument name="objectFile" value="#fileQuery#">
					<cfinvokeargument name="area_id" value="#arguments.new_area_id#">
				</cfinvoke>	

				<!--- dissociateFile --->
				<cfinvoke component="FileManager" method="dissociateFileFromArea">
					<cfinvokeargument name="objectFile" value="#fileQuery#"/>
					<cfinvokeargument name="area_id" value="#fileQuery.area_id#"/>
				</cfinvoke>

				<cfif fileQuery.file_type_id IS NOT 1>
					
					<!--- Change file area --->
					<cfquery datasource="#client_dsn#" name="changeFileArea">
						UPDATE #client_abb#_files
						SET area_id = <cfqueryparam value="#arguments.new_area_id#" cfsqltype="cf_sql_integer">
						WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

				</cfif>

				<cfinclude template="includes/logRecord.cfm">

				<cfset response = {result=true, file_id=#arguments.file_id#, new_area_id=#arguments.new_area_id#, old_area_id=#fileQuery.area_id#}>

			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>



	<!---  ---------------------- changeAreaFileLock -------------------------------- --->
	
	<cffunction name="changeAreaFileLock" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="lock" type="boolean" required="true">
		
		<cfset var method = "changeAreaFileLock">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var fileQuery = "">

		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">
						
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfinvokeargument name="with_lock" value="true">
				<cfinvokeargument name="parse_dates" value="true">		

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif fileQuery.recordCount IS 0><!---File does not exist--->
			
				<cfset error_code = 601>
			
				<cfthrow errorcode="#error_code#">
			
			</cfif>
				
			<cfset area_id = fileQuery.area_id>
		
			<cfif fileQuery.locked EQ arguments.lock>

				<cfif arguments.lock IS true>
					
					<cfthrow message="Error, el archivo ya está bloqueado.">

				<cfelse>

					<cfthrow message="Error, el archivo ya está desbloqueado.">

				</cfif>
													
			<cfelseif arguments.lock IS false AND fileQuery.lock_user_id NEQ user_id>
				
				<!---checkAreaResponsibleAccess--->
				<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
					<cfinvokeargument name="area_id" value="#area_id#">
				</cfinvoke>

			<cfelse>

				<!---checkAreaAccess--->
				<cfinclude template="includes/checkAreaAccess.cfm">

			</cfif>

			<cfif fileQuery.in_approval IS true>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="No se puede bloquear un archivo en proceso de aprobación."}>
				<cfreturn response>

			</cfif>		

			<cftransaction>
				
				<cfquery name="addFileLock" datasource="#client_dsn#">		
					INSERT INTO `#client_abb#_#fileTypeTable#_locks`
					SET file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">,
					user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
					lock_date = NOW(),
					`lock` = <cfqueryparam value="#arguments.lock#" cfsqltype="cf_sql_bit">;			
				</cfquery>

				<cfquery name="changeAreaFileLock" datasource="#client_dsn#">		
					UPDATE `#client_abb#_#fileTypeTable#`
					SET	locked = <cfqueryparam value="#arguments.lock#" cfsqltype="cf_sql_bit">
					WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;	
				</cfquery>	

			</cftransaction>

			<cfinclude template="includes/logRecord.cfm">

			<!--- Alert --->
			<cfinvoke component="AlertManager" method="newFile">
				<cfinvokeargument name="objectFile" value="#fileQuery#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfinvokeargument name="area_id" value="#area_id#">
				<cfif arguments.lock IS true>
					<cfinvokeargument name="action" value="lock">
				<cfelse>
					<cfinvokeargument name="action" value="unlock">
				</cfif>
			</cfinvoke>

			<cfset response = {result=true, file_id=#arguments.file_id#, lock=arguments.lock}>
									
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>
	<!---  ------------------------------------------------------------------------ --->



	<!--- ----------------------------------- requestRevision -------------------------------------- --->

	<cffunction name="requestRevision" output="false" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">

		<cfset var method = "requestRevision">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var version_id = "">
		<cfset var fileQuery = "">
					
		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="with_lock" value="false">
				<cfinvokeargument name="parse_dates" value="true">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfif fileQuery.recordCount IS 0><!---File does not exist--->
			
				<cfset error_code = 601>
			
				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfset area_id = fileQuery.area_id>
				
			<!---checkAreaResponsibleAccess--->
			<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>

			<cfif fileQuery.file_type_id IS NOT 3>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="Este tipo de archivo no se puede enviar a aprobación."}>

			<cfelseif fileQuery.locked IS true>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="Debe desbloquear el archivo para solicitar su aprobación."}>

			<cfelseif fileQuery.in_approval IS true>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="Este archivo ya estaba en aprobación."}>

			<cfelse>	

				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersions" returnvariable="fileVersionQuery">
					<cfinvokeargument name="file_id" value="#arguments.file_id#">
					<cfinvokeargument name="fileTypeId" value="#fileQuery.file_type_id#">
					<cfinvokeargument name="limit" value="1">
					
					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif fileVersionQuery.recordCount IS 0>

					<cfthrow message="Error al obtener la versión del archivo.">
					
				<cfelseif len(fileVersionQuery.revision_request_date) GT 0>
					
					<cfset response = {result=false, file_id=#arguments.file_id#, message="No se puede volver a enviar a aprobación una versión enviada previamente."}>
					<cfreturn response>

				</cfif>

				<cfset version_id = fileVersionQuery.version_id>

				<cftransaction>

					<!--- Set file in approval --->
					<cfquery datasource="#client_dsn#" name="changeFileApprovalState">
						UPDATE `#client_abb#_files`
						SET in_approval = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
						WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>
					
					<!--- Save revision request --->
					<cfquery datasource="#client_dsn#" name="saveRequestApprovalQuery">
						UPDATE `#client_abb#_files_versions`
						SET revision_user = <cfqueryparam value="#fileQuery.reviser_user#" cfsqltype="cf_sql_integer">,
						approval_user = <cfqueryparam value="#fileQuery.approver_user#" cfsqltype="cf_sql_integer">,
						revised = 0,
						revision_request_user = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
						revision_request_date = NOW()
						WHERE version_id = <cfqueryparam value="#version_id#" cfsqltype="cf_sql_integer">
						AND file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

				</cftransaction>

				<cfinclude template="includes/logRecord.cfm">

				<!---Send Alert--->
				<cfinvoke component="AlertManager" method="requestFileApproval">
					<cfinvokeargument name="objectFile" value="#fileQuery#">
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfinvokeargument name="action" value="revision">
				</cfinvoke>	

				<cfset response = {result=true, file_id=#arguments.file_id#, area_id=#area_id#}>

			</cfif>	

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>



	<!--- ----------------------------------- requestApproval -------------------------------------- --->

	<cffunction name="requestApproval" output="false" returntype="struct" access="private">
		<cfargument name="file_id" type="numeric" required="true">

		<cfset var method = "requestApproval">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var version_id = "">
		<cfset var fileQuery = "">
					
		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="with_lock" value="false">
				<cfinvokeargument name="parse_dates" value="true">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>
			
			<cfif fileQuery.recordCount IS 0><!---File does not exist--->
			
				<cfset error_code = 601>
			
				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfset area_id = fileQuery.area_id>

			<cfif fileQuery.file_type_id IS NOT 3>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="Este tipo de archivo no se puede enviar a aprobación."}>

			<cfelseif fileQuery.locked IS true>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="Debe desbloquear el archivo para solicitar su aprobación."}>

			<cfelseif fileQuery.in_approval IS false>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="Error, este archivo no está en proceso de aprobación."}>

			<cfelse>	

				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersions" returnvariable="fileVersionQuery">
					<cfinvokeargument name="file_id" value="#arguments.file_id#">
					<cfinvokeargument name="fileTypeId" value="#fileQuery.file_type_id#">
					<cfinvokeargument name="limit" value="1">
					
					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif fileVersionQuery.recordCount IS 0>

					<cfthrow message="Error al obtener la versión del archivo.">
					
				<cfelseif fileVersionQuery.revised IS NOT true OR fileVersionQuery.revision_result IS false>
					
					<cfset response = {result=false, file_id=#arguments.file_id#, message="Error, esta versión no ha sido validada."}>
					<cfreturn response>

				</cfif>

				<cfset version_id = fileVersionQuery.version_id>

				<!--- Save approval request --->
				<cfquery datasource="#client_dsn#" name="saveRequestApprovalQuery">
					UPDATE `#client_abb#_files_versions`
					SET 
					approval_request_date = NOW()
					WHERE version_id = <cfqueryparam value="#version_id#" cfsqltype="cf_sql_integer">
					AND file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfinclude template="includes/logRecord.cfm">

				<!---Send Alert--->
				<cfinvoke component="AlertManager" method="requestFileApproval">
					<cfinvokeargument name="objectFile" value="#fileQuery#">
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfinvokeargument name="action" value="approval">
				</cfinvoke>	

				<cfset response = {result=true, file_id=#arguments.file_id#, area_id=#area_id#}>

			</cfif>	

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
			
	</cffunction>




	<!---  -------------------------- validateFileVersion -------------------------------- --->
	
	<cffunction name="validateFileVersion" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="valid" type="boolean" required="true">
		
		<cfset var method = "validateFileVersion">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var version_id = "">
		<cfset var fileQuery = "">

		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">
						
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfinvokeargument name="with_lock" value="false">
				<cfinvokeargument name="parse_dates" value="true">		

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif fileQuery.recordCount IS 0><!---File does not exist--->
			
				<cfset error_code = 601>
			
				<cfthrow errorcode="#error_code#">
			
			</cfif>
			
			<cfset area_id = fileQuery.area_id>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersions" returnvariable="fileVersionQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#fileQuery.file_type_id#">
				<cfinvokeargument name="limit" value="1">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif fileVersionQuery.recordCount IS 0>

				<cfthrow message="Error al obtener la versión del archivo.">
				
			<cfelseif fileQuery.in_approval IS false>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="Este archivo no está en proceso de aprobación."}>

			<cfelseif fileVersionQuery.revision_user NEQ user_id>
				
				<cfset response = {result=false, file_id=#arguments.file_id#, message="No tiene permiso para validar este archivo."}>

			<cfelseif fileVersionQuery.revised IS true>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="Este archivo ya ha sido revisado previamente."}>
			
			<cfelse>	

				<cfset version_id = fileVersionQuery.version_id>
				
				<cftransaction>
					
					<cfquery datasource="#client_dsn#" name="addFileRevision">		
						UPDATE `#client_abb#_#fileTypeTable#_versions`
						SET 
						revised = 1,
						revision_date = NOW(),
						revision_result = <cfqueryparam value="#arguments.valid#" cfsqltype="cf_sql_bit">
						WHERE version_id = <cfqueryparam value="#version_id#" cfsqltype="cf_sql_integer">
						AND file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<cfif arguments.valid IS false>
						<!--- Remove file in approval state --->
						<cfquery datasource="#client_dsn#" name="changeFileApprovalState">
							UPDATE `#client_abb#_files`
							SET in_approval = 0
							WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
						</cfquery>
					</cfif>

				</cftransaction>

				<!--- Alert --->
				<cfinvoke component="AlertManager" method="newFile">
					<cfinvokeargument name="objectFile" value="#fileQuery#">
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfif arguments.valid IS true>
						<cfinvokeargument name="action" value="validate_version">
					<cfelse>
						<cfinvokeargument name="action" value="reject_version">
					</cfif>
				</cfinvoke>

				<cfif arguments.valid IS true>
					
					<!--- Request approval --->
					<cfinvoke component="FileManager" method="requestApproval" returnvariable="requestApprovalResponse">
						<cfinvokeargument name="file_id" value="#arguments.file_id#">
						<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
					</cfinvoke>

					<cfif requestApprovalResponse.result IS false>
						<cfreturn requestApprovalResponse>
					</cfif>

				</cfif>

				<cfinclude template="includes/logRecord.cfm">	

				<cfset response = {result=true, file_id=#arguments.file_id#}>
										
			</cfif>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>
	<!---  ----------------------------------------------------------------------------- --->



	<!---  -------------------------- approveFileVersion -------------------------------- --->
	
	<cffunction name="approveFileVersion" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="approve" type="boolean" required="true">
		
		<cfset var method = "approveFileVersion">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var version_id = "">
		<cfset var fileQuery = "">

		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">
						
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfinvokeargument name="with_lock" value="false">
				<cfinvokeargument name="parse_dates" value="true">		

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif fileQuery.recordCount IS 0><!---File does not exist--->
			
				<cfset error_code = 601>
			
				<cfthrow errorcode="#error_code#">
			
			</cfif>
			
			<cfset area_id = fileQuery.area_id>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersions" returnvariable="fileVersionQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#fileQuery.file_type_id#">
				<cfinvokeargument name="limit" value="1">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif fileVersionQuery.recordCount IS 0>

				<cfthrow message="Error al obtener la versión del archivo.">
				
			<cfelseif fileQuery.in_approval IS false>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="Este archivo no está en proceso de aprobación."}>

			<cfelseif fileVersionQuery.approval_user NEQ user_id>
				
				<cfset response = {result=false, file_id=#arguments.file_id#, message="No tiene permiso para aprobar este archivo."}>

			<cfelseif fileVersionQuery.approved IS true>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="Este archivo ya ha sido aprobado previamente."}>
			
			<cfelse>	

				<cfset version_id = fileVersionQuery.version_id>
				
				<cftransaction>
					
					<cfquery datasource="#client_dsn#" name="addFileApprove">		
						UPDATE `#client_abb#_#fileTypeTable#_versions`
						SET 
						approval_date = NOW(),
						approved = <cfqueryparam value="#arguments.approve#" cfsqltype="cf_sql_bit">
						WHERE version_id = <cfqueryparam value="#version_id#" cfsqltype="cf_sql_integer">
						AND file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<!--- Remove file in approval state --->
					<cfquery datasource="#client_dsn#" name="changeFileApprovalState">
						UPDATE `#client_abb#_files`
						SET in_approval = 0
						WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

				</cftransaction>

				<!--- Alert --->
				<cfinvoke component="AlertManager" method="newFile">
					<cfinvokeargument name="objectFile" value="#fileQuery#">
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfif arguments.approve IS true>
						<cfinvokeargument name="action" value="approve_version">
					<cfelse>
						<cfinvokeargument name="action" value="reject_version">
					</cfif>
				</cfinvoke>

				<cfinclude template="includes/logRecord.cfm">	

				<cfset response = {result=true, file_id=#arguments.file_id#}>
										
			</cfif>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>
	<!---  ----------------------------------------------------------------------------- --->



	<!---  -------------------------- publishFileVersion -------------------------------- --->
	
	<cffunction name="publishFileVersion" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="version_id" type="numeric" required="true">
		<cfargument name="publication_area_id" type="numeric" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="typology_id" type="string" required="false">
		
		<cfset var method = "publishFileVersion">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var fileQuery = "">
		<cfset var new_file_id = "">
		<cfset var old_file_id = "">

		<cfset var publisedFileTypeId = 2>

		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">
						
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfinvokeargument name="with_lock" value="false">
				<cfinvokeargument name="parse_dates" value="true">		

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif fileQuery.recordCount IS 0><!---File does not exist--->
			
				<cfset error_code = 601>
			
				<cfthrow errorcode="#error_code#">
			
			</cfif>
			
			<cfset area_id = fileQuery.area_id>

			<!---checkAreaResponsibleAccess--->
			<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>

			<!--- checkAreaAccess publication area--->
			<cfinvoke component="AreaManager" method="checkAreaAccess">
				<cfinvokeargument name="area_id" value="#arguments.publication_area_id#">
			</cfinvoke>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersion" returnvariable="fileVersionQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#fileQuery.file_type_id#">
				<cfinvokeargument name="version_id" value="#arguments.version_id#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif fileVersionQuery.recordCount IS 0>

				<cfthrow message="Error al obtener la versión del archivo.">

			<cfelseif fileVersionQuery.approved IS false>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="Esta versión no está aprobada."}>

			<cfelseif isNumeric(fileVersionQuery.publication_area_id)>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="Esta versión ya está publicada."}>

			<cfelse>	

				<cfinvoke component="FileManager" method="createFile" returnvariable="createFileResult">
					<cfinvokeargument name="fileTypeId" value="#publisedFileTypeId#"/>
					<cfinvokeargument name="name" value="#arguments.name#"/>
					<cfinvokeargument name="file_name" value="#fileVersionQuery.file_name#"/>
					<cfinvokeargument name="file_type" value="#fileVersionQuery.file_type#"/>
					<cfinvokeargument name="file_size" value="#fileVersionQuery.file_size#"/>
					<cfinvokeargument name="description" value="#arguments.description#"/>
					<cfinvokeargument name="area_id" value="#fileQuery.area_id#"/>

					<cfinvokeargument name="status" value="ok">
				</cfinvoke>	

				<cfif createFileResult.result IS false><!---File insert fail--->
							
					<cfset error_code = 602>
					
					<cfthrow errorcode="#error_code#">
				
				</cfif>

				<cfset newObjectFile = createFileResult.objectFile>
				<cfset new_file_id = newObjectFile.id>

				<cftry>

					<cfset old_file_id = arguments.file_id>
					<cfset new_file_physical_name = new_file_id>

					<cfset filesDirectory = "#APPLICATION.filesPath#/#client_abb#/">
					<cfset filesDirectorySource = filesDirectory&"#fileTypeDirectory#/">
					<cfset filesDirectoryDestination = filesDirectory&"files/">

					<cfset original_source = "#filesDirectorySource##fileQuery.physical_name#">
					<cfset new_source = "#filesDirectoryDestination##new_file_physical_name#">
					
					<cffile action="copy" source="#original_source#" destination="#new_source#">			
					
					<cftransaction>
						
						<cfquery name="updateSpaceUsed" datasource="#client_dsn#">
							UPDATE #client_abb#_users
							SET space_used = space_used+<cfqueryparam value="#fileQuery.file_size#" cfsqltype="cf_sql_integer">
							WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
						</cfquery>
						
						<cfquery name="updateFileVersion" datasource="#client_dsn#">		
							UPDATE `#client_abb#_#fileTypeTable#_versions`
							SET
							publication_user = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
							publication_file_id = <cfqueryparam value="#new_file_id#" cfsqltype="cf_sql_integer">, 
							publication_area_id = <cfqueryparam value="#arguments.publication_area_id#" cfsqltype="cf_sql_integer">, 
							publication_date = NOW()
							WHERE version_id = <cfqueryparam value="#arguments.version_id#" cfsqltype="cf_sql_integer">
							AND file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
						</cfquery>

					</cftransaction>

					<!--- setFileTypology --->
					<cfif isDefined("arguments.typology_id") AND isNumeric(arguments.typology_id)>

						<!---<cfset sres StructDelete(arguments, row_id, true)> NO elimina la variable--->
						<cfset arguments.row_id = javaCast("null","")>
						<cfset arguments.file_id = new_file_id>
						<cfset arguments.fileTypeId = publisedFileTypeId>
						<cfset arguments.action = "create">
						
						<cfinvoke component="FileManager" method="setFileTypology" argumentcollection="#arguments#" returnvariable="setFileTypologyResponse">
						</cfinvoke>

						<cfif setFileTypologyResponse.result IS false>

							<cfthrow message="#setFileTypologyResponse.message#">
		
						</cfif>

					</cfif>

					<!--- associateFileToArea --->
					<cfinvoke component="FileManager" method="associateFileToArea">
						<cfinvokeargument name="objectFile" value="#newObjectFile#"/>
						<cfinvokeargument name="area_id" value="#arguments.publication_area_id#"/>
					</cfinvoke>

					<cfcatch>

						<cfquery datasource="#client_dsn#" name="changeFileStatus">
							UPDATE #client_abb#_files
							SET status = <cfqueryparam value="failed" cfsqltype="cf_sql_varchar">
							WHERE id = <cfqueryparam value="#new_file_id#" cfsqltype="cf_sql_integer">;
						</cfquery>
				
						<cfthrow object="#cfcatch#">
					
					</cfcatch>
				</cftry>

				<cfinclude template="includes/logRecord.cfm">	

				<cfset response = {result=true, file_id=#old_file_id#}>
										
			</cfif>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>
	<!---  ----------------------------------------------------------------------------- --->




	<!---  -------------------------- duplicateFileVersion -------------------------------- --->
	
	<cffunction name="duplicateFileVersion" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="version_id" type="numeric" required="true">
		
		<cfset var method = "duplicateFileVersion">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var fileQuery = "">
		<cfset var new_version_id = "">

		<cftry>
		
			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">
						
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfinvokeargument name="with_lock" value="true">
				<cfinvokeargument name="parse_dates" value="true">		

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<!---canUserModifyFile--->
			<cfinvoke component="FileManager" method="canUserModifyFile" returnvariable="canUserModifyFileResponse">
				<cfinvokeargument name="fileQuery" value="#fileQuery#">
			</cfinvoke>
			<cfif canUserModifyFileResponse.result IS false>
				
				<cfreturn canUserModifyFileResponse>

			</cfif>
			
			<cfset area_id = fileQuery.area_id>

			<!---checkAreaResponsibleAccess--->
			<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersion" returnvariable="fileVersionQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#fileQuery.file_type_id#">
				<cfinvokeargument name="version_id" value="#arguments.version_id#">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>


			<cfif fileVersionQuery.recordCount IS 0>

				<cfthrow message="Error al obtener la versión del archivo.">

			<cfelse>

				<cftransaction>

					<cfquery name="insertFileVersionQuery" datasource="#client_dsn#">
						INSERT INTO `#client_abb#_#fileTypeTable#_versions`
						SET file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">,
						file_name = <cfqueryparam value="#fileVersionQuery.file_name#" cfsqltype="cf_sql_varchar">,
						physical_name = <cfqueryparam value="#fileVersionQuery.physical_name#" cfsqltype="cf_sql_varchar">,
						user_in_charge = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
						file_size = <cfqueryparam value="#fileVersionQuery.file_size#" cfsqltype="cf_sql_integer">,
						file_type = <cfqueryparam value="#fileVersionQuery.file_type#" cfsqltype="cf_sql_varchar">,
						uploading_date = <cfqueryparam value="#fileVersionQuery.uploading_date#" cfsqltype="cf_sql_timestamp">,	
						status = <cfqueryparam value="ok" cfsqltype="cf_sql_varchar">;
					</cfquery>

					<cfquery name="getLastInsertId" datasource="#client_dsn#">
						SELECT LAST_INSERT_ID() AS insert_version_id FROM `#client_abb#_#fileTypeTable#_versions`;
					</cfquery>
					<cfset new_version_id = getLastInsertId.insert_version_id>

					<cfquery name="updateFile" datasource="#client_dsn#">
						UPDATE `#client_abb#_#fileTypeTable#`
						SET replacement_date = <cfqueryparam value="#fileVersionQuery.uploading_date#" cfsqltype="cf_sql_timestamp">, 
						file_size = <cfqueryparam value="#fileVersionQuery.file_size#" cfsqltype="cf_sql_integer">,
						file_type = <cfqueryparam value="#fileVersionQuery.file_type#" cfsqltype="cf_sql_varchar">,
						file_name = <cfqueryparam value="#fileVersionQuery.file_name#" cfsqltype="cf_sql_varchar">,
						physical_name = <cfqueryparam value="#fileVersionQuery.physical_name#" cfsqltype="cf_sql_varchar">,
						status = 'ok',
						status_replacement = 'uploaded'						
						WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

				</cftransaction>

				<!---<cfset new_physical_name = "#file_id#_#new_version_id#">--->

				<cfinclude template="includes/logRecord.cfm">

				<!--- getFile --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileReplacedQuery">
					<cfinvokeargument name="file_id" value="#arguments.file_id#">
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
					<cfinvokeargument name="with_lock" value="false">
					<cfinvokeargument name="parse_dates" value="true">		

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif fileReplacedQuery.recordCount IS 0><!---File does not exist--->
	
					<cfset error_code = 601>
				
					<cfthrow errorcode="#error_code#">

				</cfif>	

				<!--- New current version --->
				<cfinvoke component="AlertManager" method="newFile">
					<cfinvokeargument name="objectFile" value="#fileReplacedQuery#">
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfinvokeargument name="action" value="new_current_version">
				</cfinvoke>	

				<cfset response = {result=true, version_id=#version_id#}>
										
			</cfif>
		
			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>
		
	</cffunction>
	<!---  ----------------------------------------------------------------------------- --->



</cfcomponent>