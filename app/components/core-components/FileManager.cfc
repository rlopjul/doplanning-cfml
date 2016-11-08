<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent output="false">

	<cfset component = "FileManager">

	<cfset messageTypeId = 1>
	<cfset fileItemTypeId = 10>
	<cfset typologyTableTypeId = 3>

	<cfset filesConvertedDirectory = "files_converted">

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


	<!--- ----------------------- GET FILE PATH -------------------------------- --->

	<cffunction name="getFilePath" returntype="string" output="false" access="public">
		<cfargument name="physical_name" type="string" required="true">
		<cfargument name="files_directory" type="string" required="false" default="files"/>

		<cfargument name="client_abb" type="string" required="true">


		<cfreturn "#APPLICATION.filesPath#/#arguments.client_abb#/#arguments.files_directory#/#arguments.physical_name#">

	</cffunction>



	<!--- ----------------------- DELETE FILE -------------------------------- --->

	<cffunction name="deleteFile" returntype="struct" output="false" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="forceDeleteVirus" type="boolean" required="false" default="false">
		<cfargument name="fileQuery" type="query" required="false">
		<cfargument name="user_id" type="numeric" required="true">
		<cfargument name="with_transaction" type="boolean" required="false" default="true">

		<cfargument name="moveToBin" type="boolean" required="false" default="true">
		<cfargument name="area_id" type="numeric" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "deleteFile">

		<cfset var response = structNew()>

		<!---<cfset var area_id = "">--->
		<cfset var fileTypeId = "">
		<cfset var path = "">
		<cfset var filePath ="">
		<cfset var thumbnailFilePath = "">
		<cfset var isApproved = "">
		<cfset var itemCategories = "">



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


			<!--- getClient --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/ClientQuery" method="getClient" returnvariable="clientQuery">
				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			</cfinvoke>

			<!---getFileAreas--->
			<!--- get file areas before delete --->
			<cfquery datasource="#client_dsn#" name="getFileAreasQuery">
				SELECT area_id
				FROM #client_abb#_areas_files
				WHERE file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<!--- Get item categories before delete --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItemCategories" returnvariable="itemCategories">
				<cfinvokeargument name="item_id" value="#arguments.file_id#">
				<cfinvokeargument name="itemTypeId" value="#fileItemTypeId#">
				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

			<cfif arguments.forceDeleteVirus IS false AND clientQuery.bin_enabled IS true AND arguments.moveToBin IS true><!--- MOVE TO BIN --->


				<cfinvoke component="#APPLICATION.coreComponentsPath#/BinQuery" method="moveItemToBin">
					<cfinvokeargument name="item_id" value="#arguments.file_id#">
					<cfinvokeargument name="itemTypeId" value="#fileItemTypeId#">
					<cfinvokeargument name="delete_area_id" value="#arguments.area_id#">
					<cfinvokeargument name="delete_user_id" value="#arguments.user_id#">
					<cfinvokeargument name="with_transaction" value="false">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>


			<cfelse><!--- DELETE FILE --->

				<cfif arguments.with_transaction IS true>
					<!--- <cftransaction nested="true"> --->
					<cfquery datasource="#client_dsn#" name="startTransaction">
						START TRANSACTION;
					</cfquery>
				</cfif>

				<cftry>

					<!---Delete typology row--->
					<cfif isNumeric(fileQuery.typology_id) AND isNumeric(fileQuery.typology_row_id)>

						<cfinvoke component="#APPLICATION.coreComponentsPath#/RowQuery" method="deleteRow">
							<cfinvokeargument name="row_id" value="#fileQuery.typology_row_id#"/>
							<cfinvokeargument name="table_id" value="#fileQuery.typology_id#"/>
							<cfinvokeargument name="tableTypeId" value="#typologyTableTypeId#"/>
							<cfinvokeargument name="user_id" value="#arguments.user_id#"/>

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

					<!--- Delete file categories --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="deleteItemCategories">
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

					<cfif fileQuery.file_type_id IS NOT 3 AND APPLICATION.moduleConvertFiles IS true>

						<!--- Get converted files before delete file --->

						<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFilesConverted" returnvariable="filesConvertedQuery">
							<cfinvokeargument name="file_id" value="#fileQuery.file_id#">

							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

					</cfif>

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
						</cfif>

						<cfif APPLICATION.moduleConvertFiles IS true>

							<cfset convertedFilesPath = "#APPLICATION.filesPath#/#client_abb#/#filesConvertedDirectory#/#fileQuery.id#">

							<!--- Delete converted files ---->

							<cfloop query="#filesConvertedQuery#">

								<cfif filesConvertedQuery.file_type EQ ".html">

									<cfset convertedFilePath = ExpandPath("#APPLICATION.path#/#client_abb#/temp/files/#fileQuery.id#_html/")>

									<cfif DirectoryExists(convertedFilePath)>
										<cfset DirectoryDelete(convertedFilePath, true)>
									</cfif>

								<cfelse>

									<cfset convertedFilePath = convertedFilesPath&filesConvertedQuery.file_type>

									<cfif FileExists(convertedFilePath)>
										<cffile action="delete" file="#convertedFilePath#">
									</cfif>

								</cfif>

							</cfloop>

						</cfif>


						<!--- Delete thumbnail --->
						<cfif fileQuery.thumbnail IS true>
							<!--- The name of the thumbnail file is always the id of the file --->
							<cfset thumbnailFilePath = APPLICATION.filesPath&'/#client_abb#/#fileTypeDirectory#_thumbnails/#fileQuery.id#'>
							<cfif FileExists(thumbnailFilePath)>
								<cffile action="delete" file="#thumbnailFilePath#">
							</cfif>
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


					<cfif clientQuery.bin_enabled IS true><!---Bin enabled--->

						<cfinvoke component="#APPLICATION.coreComponentsPath#/BinQuery" method="updateBinItemDeleted">
							<cfinvokeargument name="item_id" value="#arguments.file_id#">
							<cfinvokeargument name="itemTypeId" value="#fileItemTypeId#">

							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

					</cfif>


					<cfcatch>

						<cfif arguments.with_transaction IS true>
							<cfquery datasource="#client_dsn#" name="rollbackTransaction">
								ROLLBACK;
							</cfquery>
						</cfif>

						<cfif clientQuery.bin_enabled IS true>

							<cfinvoke component="#APPLICATION.coreComponentsPath#/BinQuery" method="updateBinItemWithError">
								<cfinvokeargument name="item_id" value="#arguments.file_id#">
								<cfinvokeargument name="itemTypeId" value="#fileItemTypeId#">
								<cfinvokeargument name="error_message" value="#cfcatch.message#">
								<cfinvokeargument name="error_detail" value="#cfcatch.detail#">

								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

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


			</cfif><!--- END DELETE --->

			<cfif ( arguments.forceDeleteVirus IS false AND clientQuery.bin_enabled IS true AND fileQuery.status NEQ "deleted") OR clientQuery.bin_enabled IS false OR arguments.forceDeleteVirus IS true>

				<cfif getFileAreasQuery.recordCount GT 0>

					<cfloop query="getFileAreasQuery">

						<!--- Alert --->
						<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newFile">
							<cfinvokeargument name="objectFile" value="#fileQuery#">
							<cfinvokeargument name="fileTypeId" value="#fileTypeId#"/>
							<cfinvokeargument name="itemCategories" value="#itemCategories#"/>
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

			</cfif>


			<cfset response = {result=true, file_id=#arguments.file_id#, file_name=#fileQuery.name#}>


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


	<!--- ---------------------------- addFileDownload ------------------------------- --->

	<cffunction name="addFileDownload" access="public" returntype="void">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="user_id" type="numeric" required="false">
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="file_size" type="numeric" required="true">
		<!---<cfargument name="item_id" type="numeric" required="false">
		<cfargument name="item_type_id" type="numeric" required="false">--->

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "addFileDownload">

		<cfquery name="addFileDownload" datasource="#client_dsn#">
			INSERT INTO #client_abb#_files_downloads
			SET file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">,
			download_date = NOW(),
			<cfif isDefined("arguments.user_id")>
				user_id = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">,
			</cfif>
			<cfif isDefined("arguments.area_id")>
				area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">,
			</cfif>
			<!---<cfif isDefined("arguments.item_id")>
				item_id = <cfqueryparam value="#arguments.item_id#" cfsqltype="cf_sql_integer">,
				item_type_id = <cfqueryparam value="#arguments.item_type_id#" cfsqltype="cf_sql_integer">
			</cfif>--->
			file_size = <cfqueryparam value="#arguments.file_size#" cfsqltype="cf_sql_integer">;
		</cfquery>

	</cffunction>


	<!--- -------------------------- checkFileTypeConversion -------------------------------- --->
	<!---Comprueba si se puede convertir un tipo de archivo o otro seleccionado--->

	<cffunction name="checkFileTypeConversion" returntype="boolean" access="public">
		<cfargument name="file_type_from" type="string" required="yes">
		<cfargument name="file_type_to" type="string" required="yes">

		<cfset var method = "checkFileTypeConversion">

		<cfset var file_type_result = false>

			<cfquery datasource="#APPLICATION.dsn#" name="checkFileType">
				SELECT file_type_to
				FROM app_file_types_conversion
				WHERE app_file_types_conversion.file_type_from = <cfqueryparam value="#arguments.file_type_from#" cfsqltype="cf_sql_varchar">
				AND app_file_types_conversion.file_type_to = <cfqueryparam value="#arguments.file_type_to#" cfsqltype="cf_sql_varchar">
				AND app_file_types_conversion.enabled = <cfqueryparam value="1" cfsqltype="cf_sql_tinyint">;
			</cfquery>

			<cfif checkFileType.recordCount GT 0>
				<cfset file_type_result = true>
			<cfelse>
				<cfset file_type_result = false>
			</cfif>

		<cfreturn file_type_result>

	</cffunction>




	<!--- ----------------------- GENERATE THUMBNAIL -------------------------------- --->

	<cffunction name="generateThumbnail" returntype="boolean" output="false" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "generateThumbnail">
		<cfset var sourceFile = "">


			<!--- getFile --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
				<cfinvokeargument name="parse_dates" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfset sourceFile = "#APPLICATION.filesPath#/#arguments.client_abb#/">
			<cfset sourceFile = sourceFile&"#fileTypeDirectory#/#fileQuery.physical_name#">


			<!--- Generate thumbnails --->
			<cfif FileExists(sourceFile)>

				<cfif arguments.fileTypeId IS 1 OR arguments.fileTypeId IS 2 OR arguments.fileTypeId IS 3>
					<cfset destinationThumbnail = "#APPLICATION.filesPath#/#arguments.client_abb#/files_thumbnails/">
				<cfelse>
					<cfset destinationThumbnail = "#APPLICATION.filesPath#/#arguments.client_abb#/#fileTypeDirectory#_thumbnails/">
				</cfif>

				<!---<cfif NOT directoryExists(destinationThumbnail)>
						<cfdirectory action="create" directory="#destinationThumbnail#">
				</cfif>--->

				<cfif fileQuery.file_type EQ ".pdf">

					<!--- Generate PDF thumbnail --->

					<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="generateThumbnailFromPdf" returnvariable="generateThumbnailResult">
						<cfinvokeargument name="file_id" value="#arguments.file_id#">
						<cfinvokeargument name="physical_name" value="#fileQuery.physical_name#">
						<cfinvokeargument name="sourceFile" value="#sourceFile#">
						<cfinvokeargument name="destinationPath"	value="#destinationThumbnail#">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfreturn true>

				<cfelseif listFind(".jpg,.jpeg,.png,.gif",fileQuery.file_type) GT 0>

					<!--- Generate Image thumbnail --->

					<cfset thumbnailFormat = fileQuery.file_type>

					<cfset destinationThumbnail = destinationThumbnail&arguments.file_id>

					<cftry><!--- Try catch for image thumbnail generation errors --->

						<cfimage source="#sourceFile#" name="imageToScale">
						<cfset ImageScaleToFit(imageToScale, 150, "", "highQuality")>
						<cfimage action="write" source="#imageToScale#" destination="#destinationThumbnail#" quality="0.85" overwrite="yes">

						<cfif NOT IsImageFile(destinationThumbnail)>
							<cfthrow message="Error al generar la miniatura de la imagen, la imagen no es compatible">
						</cfif>

						<cfcatch>

							<cfif FileExists(destinationThumbnail)>
								<cfset FileDelete(destinationThumbnail)>
							</cfif>

							<cfquery name="updateFileThumbnail" datasource="#client_dsn#">
								UPDATE #client_abb#_files
								SET thumbnail = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								thumbnail_format = <cfqueryparam cfsqltype="cf_sql_varchar" null="true">
								WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
							</cfquery>

							<cfreturn false>

						</cfcatch>

					</cftry>

					<cfquery name="updateFileThumbnail" datasource="#client_dsn#">
						UPDATE #client_abb#_files
						SET thumbnail = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
						thumbnail_format = <cfqueryparam value="#thumbnailFormat#" cfsqltype="cf_sql_varchar">
						WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<cfreturn true>

				<cfelseif APPLICATION.moduleConvertFiles IS true>


					<!--- Can convert file to PDF --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="checkFileTypeConversion" returnvariable="isFileConvertedToPdf">
						<cfinvokeargument name="file_type_from" value="#fileQuery.file_type#">
						<cfinvokeargument name="file_type_to" value=".pdf">
					</cfinvoke>

					<cfif isFileConvertedToPdf IS true>

						<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="convertFile" returnvariable="convertFileResponse">
							<cfinvokeargument name="file_id" value="#arguments.file_id#">
							<cfinvokeargument name="file_type" value=".pdf">
							<cfinvokeargument name="fileQuery" value="#fileQuery#">

							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

						<cfif convertFileResponse.result IS true>

							<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="generateThumbnailFromPdf" returnvariable="generateThumbnailResult">
								<cfinvokeargument name="file_id" value="#arguments.file_id#">
								<cfinvokeargument name="physical_name" value="#fileQuery.physical_name#">
								<cfinvokeargument name="sourceFile" value="#convertFileResponse.file_converted_path#">
								<cfinvokeargument name="destinationPath"	value="#destinationThumbnail#">

								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

							<cfreturn generateThumbnailResult>

						</cfif>		

					</cfif>


				</cfif>

			<cfelse><!---The physical file does not exist--->

				<cfset error_code = 608>

				<cfthrow errorcode="#error_code#" detail="#sourceFile#">

			</cfif>

			<cfreturn false>


	</cffunction>


	<!--- ----------------------- GENERATE THUMBNAIL FROM PDF -------------------------------- --->

	<cffunction name="generateThumbnailFromPdf" returntype="boolean" output="false" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="physical_name" type="string" required="true">
		<cfargument name="sourceFile" type="string" required="true">
		<cfargument name="destinationPath" type="string" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset thumbnailFormat = "jpg">

		<cftry><!--- Try catch for pdf thumbnail generation errors --->

				<cfpdf action="thumbnail" source="#arguments.sourceFile#" pages="1" destination="#arguments.destinationPath#" format="#thumbnailFormat#" overwrite="true">

			<cfcatch>

				<cfif FileExists("#arguments.destinationPath##arguments.file_id#")>
					<cfset FileDelete("#arguments.destinationPath##arguments.file_id#")>
				</cfif>

				<cfquery name="updateFileThumbnail" datasource="#client_dsn#">
					UPDATE #client_abb#_files
					SET thumbnail = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
					thumbnail_format = <cfqueryparam cfsqltype="cf_sql_varchar" null="true">
					WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
				</cfquery>

				<cfreturn false>
			</cfcatch>

		</cftry>

		<cffile action="rename" source="#arguments.destinationPath##arguments.physical_name#_page_1.#thumbnailFormat#" destination="#arguments.destinationPath##arguments.file_id#" nameconflict="overwrite">

		<cfquery name="updateFileThumbnail" datasource="#client_dsn#">
			UPDATE #client_abb#_files
			SET thumbnail = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
			thumbnail_format = <cfqueryparam value=".#thumbnailFormat#" cfsqltype="cf_sql_varchar">
			WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
		</cfquery>

		<cfreturn true>

	</cffunction>



	<!--- ----------------------- CONVERT FILE -------------------------------- --->

	<cffunction name="convertFile" returntype="struct" output="false" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="file_type" type="string" required="true">
		<cfargument name="fileQuery" type="query" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "convertFile">

		<cfset var files_directory = "">
		<cfset var file_copy = "">
		<cfset var file_converted = "">

			<!---checkFileTypeConversion--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="checkFileTypeConversion" returnvariable="file_type_result">
				<cfinvokeargument name="file_type_from" value="#fileQuery.file_type#">
				<cfinvokeargument name="file_type_to" value="#file_type#">
			</cfinvoke>

			<cfif file_type_result IS true>

				<cfset fileTypeId = fileQuery.file_type_id>
				<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

				<cfset files_directory = fileTypeDirectory>

				<cfset source = '#APPLICATION.filesPath#/#client_abb#/#files_directory#/#fileQuery.physical_name#'>

				<cfif FileExists(source)>

					<cfset sourceFileInfo = GetFileInfo(source)>

					<cfif sourceFileInfo.size GT 10485760><!--- If file size is greater than 10 MB --->

						<cfreturn {result=false, file_id=#file_id#, message="No se pueden convertir archivos de más de de 10 MB"}>

					</cfif>

					<cflock name="#client_abb#_file_#arguments.file_id#_#arguments.file_type#" type="exclusive" timeout="600"><!--- Timeout: 10 minutes --->

						<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFilesConverted" returnvariable="getFilesConvertedQuery">
							<cfinvokeargument name="file_id" value="#fileQuery.file_id#">
							<cfinvokeargument name="file_type" value="#file_type#">

							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

						<cfif getFilesConvertedQuery.recordCount LT 1 OR getFilesConvertedQuery.uploading_date LT fileQuery.uploading_date OR getFilesConvertedQuery.uploading_date LT fileQuery.replacement_date>

							<cfsetting requesttimeout="#APPLICATION.filesTimeout#">

							<cfset file_copy = '#APPLICATION.filesPath#/#client_abb#/#filesConvertedDirectory#/temp_#fileQuery.physical_name#_#CreateUUID()##fileQuery.file_type#'>
							<cffile action="copy" source="#source#" destination="#file_copy#" nameconflict="overwrite">

							<cfif file_type NEQ ".html">

								<cfset file_converted = '#APPLICATION.filesPath#/#client_abb#/#filesConvertedDirectory#/#fileQuery.physical_name##file_type#'>

							<cfelse>

								<cfset file_converted = ExpandPath('#APPLICATION.path#/#client_abb#/temp/files/#fileQuery.physical_name#_html/#fileQuery.physical_name#.html')>

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
								<cfqueryparam value="#fileQuery.file_id#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#file_type#" cfsqltype="cf_sql_varchar">,
								<cfif isDate(fileQuery.replacement_date) AND fileQuery.replacement_date GT fileQuery.uploading_date>
									<cfqueryparam value="#fileQuery.replacement_date#" cfsqltype="cf_sql_timestamp">,
								<cfelse>
									<cfqueryparam value="#fileQuery.uploading_date#" cfsqltype="cf_sql_timestamp">,
								</cfif>
								NOW());
							</cfquery>

							<cfset file_convert_message = "Visualización generada correctamente.">

						<cfelse>

							<cfset file_convert_message = "Archivo ya disponible para visualización en este formato.">

						</cfif>

					</cflock>

					<cfset response = {result=true, file_id=#file_id#, message=#file_convert_message#, file_converted_path=#file_converted#}>

				<cfelse><!---The physical file does not exist--->

					<cfset error_code = 608>

					<cfthrow errorcode="#error_code#" detail="#source#">

				</cfif>

			<cfelse><!---The file can't be converted to the selected file type--->

				<cfset error_code = 612>

				<cfthrow errorcode="#error_code#" detail="#file_type#">

			</cfif>

		<cfreturn response>

	</cffunction>


</cfcomponent>
