<!--- Copyright Era7 Information Technologies 2007-2014 --->

<cfcomponent output="false">

	<cfset component = "FileManager">

	<cfset messageTypeId = 1>
	<cfset fileItemTypeId = 10>
	<cfset typologyTableTypeId = 3>

	<!--- ----------------------- trasnformFileSize -------------------------------- --->
	
	<cffunction name="trasnformFileSize" returntype="string" output="false" access="public">	
		<cfargument name="file_size_full" type="numeric" required="true"><!---file_size_full is the file_size from database without parse to kilobytes--->

		<cfset var file_size = "">
		<cfset var file_size_kb = "">	
			
			<cfif arguments.file_size_full LT (1024*1024)><!---File size is LT a mega byte--->
			
				<!---Get the file size in KB--->
				<cfset file_size_kb = arguments.file_size_full/1024>
				<cfset file_size_kb = round(file_size_kb*10)/10>
				<cfif file_size_kb IS 0>
					<cfset file_size_kb = 1>
				</cfif>
				<cfset file_size_kb = file_size_kb&" KB">

				<cfset file_size = file_size_kb>
				
			<cfelse>
				
				<!---Get the file size in MB--->
				<cfset file_size = arguments.file_size_full/(1024*1024)>
				<cfset file_size = round(file_size*100)/100>
				
				<cfset file_size = file_size&" MB">
				
			</cfif>

		<cfreturn file_size>

	</cffunction>



	<!--- ----------------------- DELETE FILE -------------------------------- --->
	
	<cffunction name="deleteFile" returntype="struct" output="false" access="public">		
		<cfargument name="file_id" type="numeric" required="true">
		<!---<cfargument name="area_id" type="numeric" required="false">--->
		<cfargument name="forceDeleteVirus" type="boolean" required="false" default="false">
		<cfargument name="fileQuery" type="query" required="false">
		<cfargument name="user_id" type="numeric" required="true">
		<cfargument name="with_transaction" type="boolean" required="false" default="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">	
		
		<cfset var method = "deleteFile">
		
		<cfset var response = structNew()>

		<!---<cfset var area_id = "">--->
		<cfset var fileTypeId = "">
		<cfset var path = "">
		<cfset var filePath ="">
		<cfset var isApproved = "">

			
			<cfif NOT isDefined("arguments.fileQuery")>
							
				<!--- getFile --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
					<cfinvokeargument name="file_id" value="#arguments.file_id#">
					<cfinvokeargument name="with_lock" value="false">
					<cfinvokeargument name="parse_dates" value="true">
					<cfinvokeargument name="ignore_status" value="true">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>

				<cfif fileQuery.recordCount IS 0><!---The file does not exist (is not found)--->
					
					<cfset error_code = 601>
					
					<cfthrow errorcode="#error_code#">
								
				</cfif>	

			</cfif>	

			<cfset fileTypeId = fileQuery.file_type_id>
			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">
		
			<!---getFileAreas--->
			<cfquery datasource="#client_dsn#" name="getFileAreasQuery">
				SELECT area_id
				FROM #client_abb#_areas_files
				WHERE file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfif arguments.with_transaction IS true>
				<!--- <cftransaction nested="true"> --->
				<cfquery datasource="#client_dsn#" name="startTransaction">
					START TRANSACTION;
				</cfquery>
			</cfif>

			<cftry>
							
				<!---Delete typology--->
				<cfif isNumeric(fileQuery.typology_id) AND isNumeric(fileQuery.typology_row_id)>
					
					<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="deleteRow">
						<cfinvokeargument name="row_id" value="#fileQuery.typology_row_id#"/>
						<cfinvokeargument name="table_id" value="#fileQuery.typology_id#"/>
						<cfinvokeargument name="tableTypeId" value="#typologyTableTypeId#"/>

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

				</cfif>

				<!--- Delete file versions --->
				<cfif fileQuery.file_type_id IS 3><!--- Area file with versions --->
				
					<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersions" returnvariable="fileVersionsQuery">
						<cfinvokeargument name="file_id" value="#arguments.file_id#">
						<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
						
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>

					<cfloop query="fileVersionsQuery">
						
						<!--- deleteFileVersion --->
						<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="deleteFileVersion" returnvariable="deleteFileVersionResponse">
							<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
							<cfinvokeargument name="version_id" value="#fileVersionsQuery.version_id#"/>
							<cfinvokeargument name="fileQuery" value="#fileQuery#"/>
							<cfinvokeargument name="send_alert" value="false"/>
							<cfinvokeargument name="forceDeleteVirus" value="#arguments.forceDeleteVirus#"/>
							<cfinvokeargument name="user_id" value="#arguments.user_id#"/>

							<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
							<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
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
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="deleteItemPosition">
					<cfinvokeargument name="item_id" value="#arguments.file_id#">
					<cfinvokeargument name="itemTypeId" value="#fileItemTypeId#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
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
					<cfif fileQuery.status EQ "ok" AND fileQuery.file_type_id IS 1>
						<cfquery name="updateUserSpaceUsed" datasource="#client_dsn#">
							UPDATE #client_abb#_users
							SET space_used = space_used-#fileQuery.file_size#
							WHERE id = <cfqueryparam value="#fileQuery.user_in_charge#" cfsqltype="cf_sql_integer">;
						</cfquery>
					</cfif>

				</cfif>


				<cfcatch>

					<cfif arguments.with_transaction IS true>
						<cfquery datasource="#client_dsn#" name="rollbackTransaction">
							ROLLBACK;
						</cfquery>
					</cfif>

					<cfrethrow/>

				</cfcatch>

			</cftry>
			
			<cfif arguments.with_transaction IS true>
				<!--- </cftransaction> --->
				<cfquery datasource="#client_dsn#" name="endTransaction">
					COMMIT;
				</cfquery>
			</cfif>

			<!--- saveLog --->
			<cfinclude template="includes/logRecord.cfm">

			<cfif getFileAreasQuery.recordCount GT 0>
				
				<cfloop query="getFileAreasQuery">

					<!--- Alert --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newFile">
						<cfinvokeargument name="objectFile" value="#fileQuery#">
						<cfinvokeargument name="fileTypeId" value="#fileTypeId#"/>
						<cfinvokeargument name="area_id" value="#getFileAreasQuery.area_id#">
						<cfinvokeargument name="user_id" value="#arguments.user_id#">
						<cfif arguments.forceDeleteVirus IS true>
							<cfinvokeargument name="action" value="delete_virus">
						<cfelse>
							<cfinvokeargument name="action" value="delete">
						</cfif>
						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>
					
				</cfloop>

			</cfif>

			<cfset response = {result=true, file_id=#arguments.file_id#}>


		<cfreturn response>	
		
	</cffunction>



	<!--- ----------------------- DELETE FILE VERSION -------------------------------- --->
	
	<cffunction name="deleteFileVersion" returntype="struct" output="false" access="private">
		<cfargument name="file_id" type="numeric" required="true">		
		<cfargument name="version_id" type="numeric" required="true">
		<cfargument name="fileQuery" type="query" required="false">
		<cfargument name="fileVersionQuery" type="query" required="false">
		<cfargument name="send_alert" type="boolean" required="true">
		<cfargument name="forceDeleteVirus" type="boolean" required="false" default="false">
		<cfargument name="user_id" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">	
		
		<cfset var method = "deleteFileVersion">
		
		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var fileTypeId = "">
		<cfset var path = "">
		<cfset var filePath ="">

		<!--- Las consultas de este método no se pueden meter dentro de otra transacción porque este método se llama desde deleteFile --->											

			<cfif NOT isDefined("arguments.fileQuery")>
							
				<!--- getFile --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
					<cfinvokeargument name="file_id" value="#arguments.file_id#">
					<cfinvokeargument name="with_lock" value="false">
					<cfinvokeargument name="parse_dates" value="true">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>

				<cfif fileQuery.recordCount IS 0><!---The file does not exist (is not found)--->
					
					<cfset error_code = 601>
					
					<cfthrow errorcode="#error_code#">
								
				</cfif>	

			</cfif>	

			<cfset fileTypeId = fileQuery.file_type_id>
			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfif NOT isDefined("arguments.fileVersionQuery")>

				<!--- getFileVersion --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersion" returnvariable="fileVersionQuery">
					<cfinvokeargument name="version_id" value="#arguments.version_id#">
					<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
					
					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>

				<cfif fileVersionQuery.recordCount IS 0>
					
					<cfset error_code = 601>
				
					<cfthrow errorcode="#error_code#">

				</cfif>

			</cfif>

			<!--- getLastFileVersion --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersions" returnvariable="lastFileVersionQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
				<cfinvokeargument name="limit" value="1">
				<cfinvokeargument name="parse_dates" value="false">
				
				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

				<!--- Removing the row representing the file version --->
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
				
				<!--- 

					Se deshabilita para los archivos que no son de usuario

				<!---Update User Space Used--->
				<cfif fileQuery.status EQ "ok">
					<cfquery name="updateUserSpaceUsed" datasource="#client_dsn#">
						UPDATE #client_abb#_users
						SET space_used = space_used-#fileVersionQuery.file_size#
						WHERE id = <cfqueryparam value="#fileVersionQuery.user_in_charge#" cfsqltype="cf_sql_integer">;
					</cfquery>
				</cfif>

				--->

				<cfif lastFileVersionQuery.version_id EQ arguments.version_id>
					
					<!--- Get new last version --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersions" returnvariable="newLastFileVersionQuery">
						<cfinvokeargument name="file_id" value="#arguments.file_id#">
						<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
						<cfinvokeargument name="limit" value="1">
						<cfinvokeargument name="parse_dates" value="false">
						
						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfif newLastFileVersionQuery.recordCount GT 0>
						<!---Update file with new last version--->
						<cfquery name="updateFile" datasource="#client_dsn#">
							UPDATE #client_abb#_#fileTypeTable#
							SET replacement_date = #newLastFileVersionQuery.uploading_date#, 
							replacement_user = <cfqueryparam value="#newLastFileVersionQuery.user_in_charge#" cfsqltype="cf_sql_integer">,
							file_size = <cfqueryparam value="#newLastFileVersionQuery.file_size#" cfsqltype="cf_sql_integer">,
							file_type = <cfqueryparam value="#newLastFileVersionQuery.file_type#" cfsqltype="cf_sql_varchar">,
							file_name = <cfqueryparam value="#newLastFileVersionQuery.file_name#" cfsqltype="cf_sql_varchar">,
							physical_name = <cfqueryparam value="#newLastFileVersionQuery.physical_name#" cfsqltype="cf_sql_varchar">
							WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
						</cfquery>
					</cfif>

				</cfif>
			
			<!--- saveLog --->
			<cfinclude template="includes/logRecord.cfm">

			<cfif arguments.send_alert IS true>

				<!--- Alert --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newFile">
					<cfinvokeargument name="objectFile" value="#fileQuery#">
					<cfinvokeargument name="fileTypeId" value="#fileQuery.file_type_id#">
					<cfinvokeargument name="area_id" value="#fileQuery.area_id#">
					<cfif arguments.forceDeleteVirus IS true>
						<cfinvokeargument name="action" value="delete_version_virus">
					<cfelse>
						<cfinvokeargument name="action" value="delete_version">
					</cfif>
					<cfinvokeargument name="user_id" value="#arguments.user_id#">
					<cfinvokeargument name="fileVersionQuery" value="#fileVersionQuery#">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">						
				</cfinvoke>
				
			</cfif>

			<cfset response = {result=true, version_id=#arguments.version_id#}>

		<cfreturn response>	
		
	</cffunction>


</cfcomponent>