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

	<!---<cfset timeZoneTo = "+1:00">--->
	<cfset timeZoneTo = "Europe/Madrid">

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
							<cfinvokeargument name="with_transaction" value="false">
							<cfinvokeargument name="moveToBin" value="false">
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
		<cfargument name="forceDeleteVirus" type="boolean" required="false" default="false">
		<cfargument name="with_transaction" type="boolean" required="false" default="true">
		<cfargument name="moveToBin" type="boolean" required="false" default="true">

		<cfset var method = "deleteFile">

		<cfset var response = structNew()>

		<cfset var fileQuery = "">
		<cfset var fileTypeId = "">
		<cfset var path = "">
		<cfset var filePath ="">
		<cfset var isApproved = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<!--- getFile --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="with_lock" value="false">
				<cfinvokeargument name="parse_dates" value="true">
				<cfinvokeargument name="ignore_status" value="true">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif fileQuery.recordCount IS 0><!---The file does not exist (is not found)--->

				<cfset error_code = 601>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfset fileTypeId = fileQuery.file_type_id>
			<!---<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">--->

			<cfif arguments.forceDeleteVirus IS false>

				<!---checkAccess--->
				<cfif fileQuery.file_type_id IS 2 OR fileQuery.file_type_id IS 3><!---Area file (ALL area users can delete the file)--->

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

			</cfif>

			<cfif fileQuery.locked IS true AND arguments.forceDeleteVirus IS false>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="No se puede eliminar un archivo bloqueado, debe desbloquearlo."}>

			<cfelse>

				<cfif fileQuery.file_type_id IS 3 AND arguments.forceDeleteVirus IS false><!--- Comprobar si el archivo está aprobado --->

					<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="isFileApproved" returnvariable="isApproved">
						<cfinvokeargument name="file_id" value="#arguments.file_id#">
						<cfinvokeargument name="fileTypeId" value="#fileQuery.file_type_id#">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<cfif isApproved IS true>

						<cfset response = {result=false, file_id=#arguments.file_id#, message="No se puede eliminar un archivo con una versión aprobada."}>

						<cfreturn response>

					</cfif>

				</cfif>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="deleteFile" returnvariable="response">
					<cfinvokeargument name="file_id" value="#file_id#">
					<cfinvokeargument name="forceDeleteVirus" value="#arguments.forceDeleteVirus#">
					<cfinvokeargument name="fileQuery" value="#fileQuery#">
					<cfinvokeargument name="user_id" value="#user_id#">
					<cfinvokeargument name="with_transaction" value="#arguments.with_transaction#">
					<cfinvokeargument name="moveToBin" value="#arguments.moveToBin#">
					<cfif isDefined("area_id")>
						<cfinvokeargument name="area_id" value="#area_id#">
					</cfif>


					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ----------------------- DELETE FILE VERSION -------------------------------- --->

	<cffunction name="deleteFileVersion" returntype="struct" output="false" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="version_id" type="numeric" required="true">

		<cfset var method = "deleteFileVersion">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var fileQuery = "">
		<cfset var fileVersionQuery = "">
		<cfset var fileTypeId = "">

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

			<cfset area_id = fileQuery.area_id>

			<!---checkAreaAccess--->
			<cfinclude template="includes/checkAreaAccess.cfm">

			<cfif fileQuery.locked IS true>

				<cfset response = {result=false, version_id=#arguments.version_id#, message="No se puede eliminar una versión de un archivo bloqueado, debe desbloquearlo para eliminarla."}>

			<cfelse>

				<cfset fileTypeId = fileQuery.file_type_id>

				<!--- getFileVersion --->
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

				<!--- getLasFileVersion --->
				<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="getLastFileVersion" returnvariable="getLastFileVersionResponse">
					<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
					<cfinvokeargument name="fileTypeId" value="#fileTypeId#"/>
				</cfinvoke>

				<cfset lastVersion = getLastFileVersionResponse.version>

				<cfif fileVersionQuery.approved IS true>

					<cfset response = {result=false, version_id=#arguments.version_id#, message="No se puede eliminar una versión aprobada."}>

				<cfelseif fileVersionQuery.revised IS true>

					<cfset response = {result=false, version_id=#arguments.version_id#, message="No se puede eliminar una versión revisada."}>

				<cfelseif fileVersionQuery.version_id EQ lastVersion.version_id>

					<cfset response = {result=false, version_id=#arguments.version_id#, message="No se puede eliminar la última versión del archivo."}>

				<cfelseif fileVersionQuery.user_in_charge NEQ SESSION.user_id>

					<cfset response = {result=false, version_id=#arguments.version_id#, message="Sólo el usuario propietario de la versión puede eliminarla."}>

				<cfelse>

					<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="deleteFileVersion" returnvariable="response">
						<cfinvokeargument name="file_id" value="#arguments.file_id#">
						<cfinvokeargument name="version_id" value="#arguments.version_id#">
						<cfinvokeargument name="fileQuery" value="#fileQuery#">
						<cfinvokeargument name="fileVersionQuery" value="#fileVersionQuery#">

						<cfinvokeargument name="forceDeleteVirus" value="false">
						<cfinvokeargument name="send_alert" value="true">
						<cfinvokeargument name="user_id" value="#SESSION.user_id#">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

				</cfif>

			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

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

		<cfargument name="publication_date" type="string" required="false">
		<cfargument name="publication_validated" type="boolean" required="false">

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

					<cfinvoke component="FileManager" method="associateFileToArea" returnvariable="associateFileResult">
						<cfinvokeargument name="objectFile" value="#objectFile#">
						<cfinvokeargument name="area_id" value="#cur_area_id#">
						<cfinvokeargument name="publication_date" value="#arguments.publication_date#">
						<cfinvokeargument name="publication_validated" value="#arguments.publication_validated#">
					</cfinvoke>

					<cfif associateFileResult.result IS true>
						<cfset successfulAreas = listAppend(successfulAreas, cur_area_id)>
					<cfelse>
						<cfset allAreas = false>

						<cfset response = {result=false, file_id=#arguments.file_id#, file_name=#objectFile.name#, areas_ids=#successfulAreas#, allAreas=#allAreas#, message=#associateFileResult.message#}>
						<cfreturn response>

					</cfif>

					<cfcatch>
						<cfif isDefined("cfcatch.errorcode") AND cfcatch.errorcode IS 607><!---The file exists in the area--->
							<cfset allAreas = false>
						<cfelse>
							<cfrethrow>
						</cfif>
					</cfcatch>
				</cftry>

			</cfloop>

			<cfinclude template="includes/functionEndNoLog.cfm">

			<cfset response = {result=true, file_id=#arguments.file_id#, file_name=#objectFile.name#, areas_ids=#successfulAreas#, allAreas=#allAreas#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ----------------------- ASSOCIATE FILE -------------------------------- --->

	<cffunction name="associateFile" returntype="struct" output="false" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">

		<cfargument name="publication_date" type="string" required="false">
		<cfargument name="publication_validated" type="boolean" required="false">

		<cfset var method = "associateFile">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="FileManager" method="getFile" returnvariable="objectFile">
				<cfinvokeargument name="get_file_id" value="#arguments.file_id#">

				<cfinvokeargument name="return_type" value="query">
			</cfinvoke>

			<cfinvoke component="FileManager" method="associateFileToArea" returnvariable="response">
				<cfinvokeargument name="objectFile" value="#objectFile#">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="publication_date" value="#arguments.publication_date#">
				<cfinvokeargument name="publication_validated" value="#arguments.publication_validated#">
			</cfinvoke>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ----------------------- ASSOCIATE FILE TO AREA -------------------------------- --->

	<cffunction name="associateFileToArea" returntype="struct" output="false" access="package">
		<cfargument name="objectFile" type="query" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">

		<cfargument name="publication_date" type="string" required="false">
		<cfargument name="publication_validated" type="boolean" required="false" default="false">

		<cfargument name="no_notify" type="boolean" required="false" default="false">

		<cfset var method = "associateFileToArea">

		<cfset var response = structNew()>

		<cfset var fileTypeId = objectFile.file_type_id>
		<cfset var isUserPublicationAreaResponsible = false>
		<cfset var areaType = "">

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<!--- checkAreaAccess --->
			<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="checkAreaAccess">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>

			<cfif objectFile.file_type_id IS 2>
				<!--- checkAreaAccess --->
				<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="checkAreaAccess">
					<cfinvokeargument name="area_id" value="#objectFile.area_id#">
				</cfinvoke>
			<cfelseif objectFile.user_in_charge NEQ user_id>

				<cfset response = {result=false, file_id=#objectFile.id#, area_id=#arguments.area_id#, message="No puede asociar a un área un archivo que no es de su propiedad"}>

				<cfreturn response>
			</cfif>

			<cfif objectFile.file_type_id IS 3><!--- Area file with versions and quality circuit --->

				<cfset response = {result=false, file_id=#objectFile.id#, area_id=#arguments.area_id#, message="No se puede asociar un archivo de área con circuito de calidad a otra área"}>

				<cfreturn response>

			</cfif>


			<!--- checkScope --->
			<cfif APPLICATION.publicationScope IS true AND isNumeric(objectFile.publication_scope_id)>

				<cfinvoke component="ScopeManager" method="isAreaInScope" returnvariable="isInScopeResult">
					<cfinvokeargument name="scope_id" value="#objectFile.publication_scope_id#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>

				<cfif isInScopeResult.result IS false>

					<cfset response = {result=false, file_id=#objectFile.id#, area_id=#arguments.area_id#, message="El ámbito de publicación de este archivo no permite publicarlo en esta área"}>

					<cfreturn response>

				</cfif>

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

			<cfif APPLICATION.publicationValidation IS true AND arguments.publication_validated IS true>

				<!--- isUserPublicationAreaResponsible --->
				<cfinvoke component="AreaManager" method="isUserAreaResponsible" returnvariable="isUserPublicationAreaResponsible">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>

			</cfif>

			<cftransaction>

				<cfquery name="associateFileQuery" datasource="#client_dsn#">
					INSERT INTO #client_abb#_areas_files
					SET area_id = <cfqueryparam value = "#arguments.area_id#" cfsqltype="cf_sql_integer">,
					file_id = <cfqueryparam value = "#objectFile.id#" cfsqltype="cf_sql_integer">,
					association_date = NOW()
					<cfif isDefined("arguments.publication_date") AND len(arguments.publication_date) GT 0>
						, publication_date = CONVERT_TZ(STR_TO_DATE(<cfqueryparam value="#arguments.publication_date#" cfsqltype="cf_sql_varchar">,'%d-%m-%Y %H:%i'), '#timeZoneTo#', 'SYSTEM')
					</cfif>
					<!--- publicationValidation --->
					<cfif APPLICATION.publicationValidation IS true>
						<cfif isUserPublicationAreaResponsible IS true AND arguments.publication_validated IS true>
							, publication_validated = <cfqueryparam value="true" cfsqltype="cf_sql_bit">
							, publication_validated_user = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
							, publication_validated_date = NOW()
						<cfelse>
							, publication_validated = <cfqueryparam value="false" cfsqltype="cf_sql_bit">
						</cfif>
					</cfif>;
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

			<!--- getFile --->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#objectFile.id#">
				<cfif APPLICATION.moduleAreaFilesLite IS true>
					<cfinvokeargument name="with_lock" value="true">
				</cfif>
				<cfinvokeargument name="parse_dates" value="true">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="published" value="false"/>

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif fileQuery.recordCount IS 0><!---File does not exist--->

				<cfset error_code = 601>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfif arguments.no_notify IS false>

				<!--- Alert --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newFile">
					<cfinvokeargument name="objectFile" value="#fileQuery#">
					<cfinvokeargument name="fileTypeId" value="#fileTypeId#"/>
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
					<cfinvokeargument name="user_id" value="#user_id#">
					<cfif objectFile.file_type_id IS 1 OR (objectFile.file_type_id IS 2 AND objectFile.area_id NEQ arguments.area_id)>
						<cfinvokeargument name="action" value="associate">
					<cfelse>
						<cfinvokeargument name="action" value="new">
					</cfif>

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cfif>

			<cfset response = {result=true, file_id=#objectFile.id#, area_id=#arguments.area_id#}>

		<cfreturn response>

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
				<cfinvoke component="FileManager" method="dissociateFileFromArea" returnvariable="response">
					<cfinvokeargument name="objectFile" value="#fileQuery#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>

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

	<cffunction name="dissociateFileFromArea" returntype="struct" output="false" access="package">
		<cfargument name="objectFile" type="query" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">

		<cfset var method = "dissociateFileFromArea">

		<cfset var response = structNew()>
		<cfset var response_message = "">

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
				<cfset response_message = "El archivo solo está asociado en esta área. Para quitarlo debe eliminarlo.">
				<cfset response = {result=false, message=#response_message#, file_id=#file_id#, area_id=#arguments.area_id#}>
				<cfreturn response>
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
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newFile">
				<cfinvokeargument name="objectFile" value="#arguments.objectFile#">
				<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="user_id" value="#user_id#">
				<cfinvokeargument name="action" value="dissociate">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, file_id=#file_id#, area_id=#arguments.area_id#}>

		<cfreturn response>

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
    <cfargument name="return_type" type="string" required="no" default="xml"><!---xml/object/query--->
    <cfargument name="with_owner_area" type="boolean" required="false">
    <cfargument name="status" type="string" required="false" default="ok"><!--- ok/deleted --->

		<cfset var method = "getFile">

		<cfset var file_id = "">
		<cfset var area_passed = false>

		<cfset response = "">

		<!---<cfinclude template="includes/initVars.cfm">--->

			<cfinclude template="includes/functionStartOnlySession.cfm">

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
				<cfinvokeargument name="published" value="false">
				<cfinvokeargument name="with_owner_area" value="#arguments.with_owner_area#">
				<cfinvokeargument name="status" value="#arguments.status#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif selectFileQuery.recordCount GT 0>


				<cfif isDefined("arguments.itemTypeId") AND arguments.itemTypeId IS 16 AND selectFileQuery.item_type_id EQ arguments.itemTypeId AND isNumeric(selectFileQuery.row_id)><!--- Users typologies attached file--->


						<cfinvoke component="UserManager" method="isInternalUser" returnvariable="internal_user">
							<cfinvokeargument name="get_user_id" value="#SESSION.user_id#">
						</cfinvoke>

						<cfif internal_user IS false>

							<cfquery name="getRowTypologyUser" datasource="#client_dsn#">
								SELECT id
								FROM `#arguments.client_abb#_users`
								WHERE typology_id = <cfqueryparam value="#selectFileQuery.table_id#" cfsqltype="cf_sql_integer">
								AND typology_row_id = <cfqueryparam value="#selectFileQuery.row_id#" cfsqltype="cf_sql_integer">;
							</cfquery>

							<cfif getRowTypologyUser.recordCount GT 0>

								<cfset typologyRowUserId = getRowTypologyUser.id>

								<cfif typologyRowUserId NEQ SESSION.user_id>

									<cfinvoke component="#APPLICATION.coreComponentsPath#/UserManager" method="getUserVisibleUsers" returnvariable="getUserVisibleUsers">
										<cfinvokeargument name="user_id" value="#SESSION.user_id#">

										<cfinvokeargument name="client_abb" value="#client_abb#">
										<cfinvokeargument name="client_dsn" value="#client_dsn#">
									</cfinvoke>

									<cfset usersList = getUserVisibleUsers.usersList>

									<cfif ListFind(list, typologyRowUserId) IS 0>

										<cfset error_code = 103>

										<cfthrow errorcode="#error_code#">

									</cfif>

								</cfif>

							<cfelse>

								<cfset error_code = 103>

								<cfthrow errorcode="#error_code#">

							</cfif>

						</cfif><!--- END internal_user IS false --->


				<cfelseif area_passed IS NOT true AND selectFileQuery.user_in_charge NEQ user_id><!---The area is not checked before and the file is not property of the user--->


					<cfif isDefined("arguments.itemTypeId")>

						<!---Aquí comprueba si el archivo está asociado a otro tipo de elemento (entradas, noticias, eventos, etc)--->
						<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

						<cfif listFind("11,12", arguments.itemTypeId) GT 0 AND arguments.itemTypeId EQ selectFileQuery.item_type_id AND isNumeric(selectFileQuery.row_id)><!--- Lists and Forms --->

							<cfinvoke component="#APPLICATION.coreComponentsPath#/TableQuery" method="getTablePublicationAreas" returnvariable="getFileAreasQuery">
								<cfinvokeargument name="table_id" value="#selectFileQuery.item_id#">
								<cfinvokeargument name="tableTypeTable" value="#itemTypeTable#">
								<cfinvokeargument name="field_id" value="#selectFileQuery.field_id#">

								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

						<cfelse>

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


					<cfelse>

						<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileAreas" returnvariable="getFileAreasQuery">
							<cfinvokeargument name="file_id" value="#file_id#">

							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

					</cfif>



					<cfif getFileAreasQuery.recordCount GT 0>

						<cfif getFileAreasQuery.recordCount IS 1>

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



				</cfif><!--- END area_passed IS NOT true AND selectFileQuery.user_in_charge NEQ user_id --->



				<cfif arguments.return_type EQ "query">

					<cfset response = selectFileQuery>

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

						<cfset response = objectFile>

					<cfelse>

						<cfinvoke component="FileManager" method="xmlFile" returnvariable="xmlResponseContent">
							<cfinvokeargument name="objectFile" value="#objectFile#">
						</cfinvoke>

						<cfset response = xmlResponseContent>

					</cfif>

				</cfif>


			<cfelse><!---File does not exist--->

				<cfset error_code = 601>

				<cfthrow errorcode="#error_code#">

			</cfif>


		<cfreturn response>

	</cffunction>


	<!--- ----------------------------------- checkAreaFileAccess ----------------------------------  --->

	<cffunction name="checkAreaFileAccess" output="false" access="public" returntype="struct">
		<cfargument name="file_id" type="numeric" required="true">

		<cfset var response = structNew()>

		<cfset var access_result = false>
		<cfset var area_id = "">

		<cfinclude template="includes/functionStartOnlySession.cfm">

		<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="selectFileQuery">
			<cfinvokeargument name="file_id" value="#arguments.file_id#">
			<!---<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>--->
			<cfinvokeargument name="parse_dates" value="false">
			<cfinvokeargument name="published" value="false">

			<cfinvokeargument name="client_abb" value="#client_abb#">
			<cfinvokeargument name="client_dsn" value="#client_dsn#">
		</cfinvoke>

		<cfif selectFileQuery.recordCount GT 0>

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileAreas" returnvariable="getFileAreasQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif getFileAreasQuery.recordCount GT 0>

				<cfif getFileAreasQuery.recordCount IS 1>

					<cfset area_id = getFileAreasQuery.area_id>

					<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="canUserAccessToArea" returnvariable="access_result">
						<cfinvokeargument name="area_id" value="#area_id#">
					</cfinvoke>

				<cfelse>

					<cfset fileAreasList = valueList(getFileAreasQuery.area_id)>

					<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="checkAreasAccess" returnvariable="checkAreasAccessResult">
						<cfinvokeargument name="areasList" value="#fileAreasList#">
						<cfinvokeargument name="throwError" value="false">
					</cfinvoke>

					<cfset access_result = checkAreasAccessResult.result>
					<cfset area_id = checkAreasAccessResult.area_id>

				</cfif>

			<cfelse>

				<cfset access_result = false>

			</cfif>

		<cfelse>

			<cfset access_result = false>

		</cfif>

		<cfset response = {result=access_result, area_id=area_id, file=selectFileQuery}>

		<cfreturn response>

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
			<cfset file.publication_scope_id = "">

			<cfset curDate = DateFormat(now(), APPLICATION.dateFormat)>
			<cfset file.publication_date = curDate&" "&timeFormat(now(), "HH:mm:ss")>
			<cfset file.publication_validated = true>

			<cfset file.public = false>
			<cfset file.url_id = "">

			<cfset response = {result=true, file=#file#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!---  -------------------------------------------------------------------------------- --->



	<!--- ----------------------------------- getFileAreas ----------------------------------  --->

	<cffunction name="getFileAreas" output="false" access="public" returntype="struct">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="with_names" type="numeric" required="false" default="true">
		<cfargument name="accessCheck" type="boolean" required="false" default="true">

		<cfset var response = structNew()>

		<cfset var access_result = false>

		<cftry>


			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileAreas" returnvariable="getFileAreasQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="with_names" value="#arguments.with_names#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfif getFileAreasQuery.recordCount GT 0 AND arguments.accessCheck IS true>

				<cfif getFileAreasQuery.recordCount IS 1>

					<cfset area_id = getFileAreasQuery.area_id>

					<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="canUserAccessToArea" returnvariable="access_result">
						<cfinvokeargument name="area_id" value="#area_id#">
					</cfinvoke>

				<cfelse>

					<cfset fileAreasList = valueList(getFileAreasQuery.area_id)>

					<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="checkAreasAccess" returnvariable="checkAreasAccessResult">
						<cfinvokeargument name="areasList" value="#fileAreasList#">
						<cfinvokeargument name="throwError" value="false">
					</cfinvoke>

					<cfset access_result = checkAreasAccessResult.result>
					<cfset area_id = checkAreasAccessResult.area_id>

				</cfif>

			</cfif>

			<cfif arguments.accessCheck IS true AND access_result IS false>
				<cfset error_code = 104>

				<cfthrow errorcode="#error_code#">
			</cfif>

			<cfset response = {result=true, fileAreas=getFileAreasQuery}>

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


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


	<!--- ------------------------------------- isFileApproved -------------------------------------  --->

	<cffunction name="isFileApproved" output="false" access="public" returntype="struct">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">

		<cfset var method = "isFileApproved">

		<cfset var response = structNew()>

		<cfset var isApproved = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="isFileApproved" returnvariable="isApproved">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfset response = {result=true, approved=isApproved}>

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
		<cfset var fileQuery = "">
		<cfset var destination = "">

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

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

				<cfif arguments.fileTypeId IS 1>

					<cfquery name="updateSpaceUsed" datasource="#client_dsn#">
						UPDATE #client_abb#_users
						SET space_used = space_used+<cfqueryparam value="#fileQuery.file_size#" cfsqltype="cf_sql_integer">
						WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

				</cfif>


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
								WHERE attached_image_id = <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">;
								</cfif>
							</cfquery>
							<cfset item_id = getAreaItem.id>

							<!--- getItem --->
							<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
								<cfinvokeargument name="item_id" value="#item_id#">
								<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
								<cfinvokeargument name="parse_dates" value="true">
								<cfinvokeargument name="published" value="false">

								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

							<cfif arguments.send_alert IS true>

								<!--- Alert --->
								<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newAreaItem">
									<cfinvokeargument name="objectItem" value="#itemQuery#">
									<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
									<cfinvokeargument name="action" value="#arguments.action#">

									<cfinvokeargument name="user_id" value="#SESSION.user_id#">
									<cfinvokeargument name="client_abb" value="#client_abb#">
									<cfinvokeargument name="client_dsn" value="#client_dsn#">
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

							<!--- MODULE ANTI VIRUS --->
							<cfif APPLICATION.moduleAntiVirus IS true>

								<!--- START THREAD --->
								<cfthread name="antiVirusCheckNewAttached#arguments.file_type#" action="run" priority="NORMAL" file_id="#file_id#" fileTypeId="1" user_id="#SESSION.user_id#" itemQuery="#itemQuery#" client_abb="#SESSION.client_abb#" client_dsn="#client_dsn#" item_id="#item_id#" file_type="#arguments.file_type#">

									<cftry>

										<!--- Wait for the execution of the antivirus check --->
										<cfscript>
											sleep(300);
										</cfscript>

										<cfinvoke component="#APPLICATION.coreComponentsPath#/AntiVirusManager" method="checkFile" returnvariable="checkFileResult">
											<cfinvokeargument name="file_id" value="#file_id#">
											<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
											<cfinvokeargument name="user_id" value="#user_id#">

											<cfinvokeargument name="client_abb" value="#client_abb#">
										</cfinvoke>

										<cfif checkFileResult.result IS false><!--- Delete infected file --->

											<!--- delete attached file / image --->

											<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="deleteItemAttachedFile">
												<cfinvokeargument name="item_id" value="#item_id#">
												<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
												<cfinvokeargument name="itemQuery" value="#itemQuery#"/>
												<cfinvokeargument name="forceDeleteVirus" value="true">
												<cfinvokeargument name="user_id" value="#user_id#">
												<cfinvokeargument name="area_id" value="#itemQuery.area_id#"/>
												<cfinvokeargument name="anti_virus_check_result" value="#checkFileResult.message#">
												<cfinvokeargument name="file_type" value="#file_type#">

												<cfinvokeargument name="client_abb" value="#client_abb#">
												<cfinvokeargument name="client_dsn" value="#client_dsn#">
											</cfinvoke>

										</cfif>

										<cfcatch>

											<cfinclude template="includes/errorHandlerStruct.cfm">

										</cfcatch>

									</cftry>

								</cfthread>
								<!--- END THREAD --->

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
		<cfargument name="name" type="string" required="false"/>
		<cfargument name="file_name" type="string" required="true"/>
		<cfargument name="file_size" type="numeric" required="true"/>
		<cfargument name="file_type" type="string" required="true"/>
		<cfargument name="description" type="string" required="false"/>
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="reviser_user" type="numeric" required="false">
		<cfargument name="approver_user" type="numeric" required="false">
		<cfargument name="publication_scope_id" type="numeric" required="false">
		<cfargument name="version_index" type="string" required="false">
		<cfargument name="public" type="boolean" required="false">
		<cfargument name="categories_ids" type="array" required="false">
		<cfargument name="url_id" type="string" required="false">


		<!---Este parametro se le pasa cuando se adjunta un archivo a un mensaje, que primero se crea el mensaje y luego se sube--->
		<cfargument name="status" type="string" required="no" default="">

		<!---Este metodo necesitaba recibir variables de sesión como argumentos porque en cuando se suben archivos en Flex desde Firefox no se puede acceder a las variables de sesion--->

		<cfset var method = "createFile">

		<cfset var response = structNew()>

		<cfset var file_id = "">
		<cfset var file_public_id = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfif arguments.fileTypeId IS NOT 1><!--- area_id required in fileTypeId 2 OR fileTypeId 3 --->

				<!---checkAreaAccess--->
				<cfinclude template="includes/checkAreaAccess.cfm">

			</cfif>

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

			<!--- checkScope --->
			<cfif APPLICATION.publicationScope IS true AND isDefined("arguments.publication_scope_id")><!---AND arguments.fileTypeId IS NOT 1--->

				<cfinvoke component="ScopeManager" method="isAreaInScope" returnvariable="isInScopeResult">
					<cfinvokeargument name="scope_id" value="#arguments.publication_scope_id#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>

				<cfif isInScopeResult.result IS false>

					<cfset response = {result=false, message="El ámbito seleccionado para este archivo no permite publicarlo en esta área"}>

					<cfreturn response>

				</cfif>

			</cfif>

			<cfif ( arguments.fileTypeId IS 1 OR arguments.fileTypeId IS 2 ) AND arguments.public IS true>

				<cfset file_public_id = lCase(hash(CreateUUID()))>

			</cfif>


			<cfif isDefined("arguments.url_id")>

				<!--- Check url_id length --->
				<cfif len(arguments.url_id) GT 255>

					<cfset response = {result=false, message="URL de la página demasiado larga, introduzca una URL con menos de 200 caracteres"}>
					<cfreturn response>

				</cfif>

				<!--- Check if url_id exist --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileByUrlQuery">
					<cfinvokeargument name="url_id" value="#arguments.url_id#">
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif fileByUrlQuery.recordCount GT 0>
					<cfset response = {result=false, message="La URL de la página ya existe, debe usar otra distinta"}>
					<cfreturn response>
				</cfif>

			</cfif>


			<cftransaction>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="createFileInDatabase" argumentcollection="#arguments#" returnvariable="file_id">
					<!---<cfinvokeargument name="name" value="#arguments.name#">
					<cfinvokeargument name="file_name" value="#arguments.file_name#">
					<cfinvokeargument name="file_type" value="#arguments.file_type#">
					<cfinvokeargument name="file_size" value="#arguments.file_size#">
					<cfinvokeargument name="description" value="#arguments.file_description#">
					<cfinvokeargument name="reviser_user" value="#arguments.reviser_user#">
					<cfinvokeargument name="approver_user" value="#arguments.approver_user#">
					<cfinvokeargument name="publication_scope_id" value="#arguments.publication_scope_id#">
					<cfinvokeargument name="fileTypeId" value="1">--->
					<cfinvokeargument name="user_id" value="#SESSION.user_id#">
					<cfinvokeargument name="status" value="pending">
					<cfif len(file_public_id) GT 0>
						<cfinvokeargument name="file_public_id" value="#file_public_id#">
					</cfif>

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<!---<cfquery name="createFileQuery" datasource="#client_dsn#" result="createFileResult">
					INSERT INTO `#client_abb#_#fileTypeTable#`
					SET
					file_name = <cfqueryparam value="#arguments.file_name#" cfsqltype="cf_sql_varchar">,
					file_size = <cfqueryparam value="#arguments.file_size#" cfsqltype="cf_sql_integer">,
					file_type = <cfqueryparam value="#arguments.file_type#" cfsqltype="cf_sql_varchar">,
					uploading_date = NOW(),
					status = <cfqueryparam value="pending" cfsqltype="cf_sql_varchar">
					<cfif arguments.fileTypeId IS NOT 4>
						, name = <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">
						, user_in_charge = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
						, description = <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
						, file_type_id = <cfqueryparam value="#arguments.fileTypeId#" cfsqltype="cf_sql_integer">
						<cfif arguments.fileTypeId IS NOT 1>
							, area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">
						</cfif>
					</cfif>
					<cfif arguments.fileTypeId IS 3>
						, reviser_user = <cfqueryparam value="#arguments.reviser_user#" cfsqltype="cf_sql_integer">
						, approver_user = <cfqueryparam value="#arguments.approver_user#" cfsqltype="cf_sql_integer">
					<cfelse>
						<cfif isDefined("arguments.publication_scope_id")>
						, publication_scope_id = <cfqueryparam value="#arguments.publication_scope_id#" cfsqltype="cf_sql_integer">
						</cfif>
						<cfif ( arguments.fileTypeId IS 1 OR arguments.fileTypeId IS 2 ) AND arguments.public IS true>
							, public = <cfqueryparam value="#arguments.public#" cfsqltype="cf_sql_bit">
							, file_public_id = <cfqueryparam value="#file_public_id#" cfsqltype="cf_sql_varchar">
						</cfif>
					</cfif>;
				</cfquery>--->

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
						version_index = <cfqueryparam value="#arguments.version_index#" cfsqltype="cf_sql_varchar">,
						user_in_charge = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
						file_size = <cfqueryparam value="#arguments.file_size#" cfsqltype="cf_sql_integer">,
						file_type = <cfqueryparam value="#arguments.file_type#" cfsqltype="cf_sql_varchar">,
						uploading_date = NOW(),
						status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">;
					</cfquery>

				</cfif>

				<cfif isDefined("arguments.categories_ids")>

					<!--- setItemCategories --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="setItemCategories">
						<cfinvokeargument name="item_id" value="#file_id#">
						<cfinvokeargument name="itemTypeId" value="#fileItemTypeId#">
						<cfinvokeargument name="categories_ids" value="#arguments.categories_ids#"/>

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

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

					<cfif type EQ "user_image">

						<!---Update User Space Used--->
						<cfquery name="updateUserSpaceUsed" datasource="#client_dsn#">
							UPDATE #client_abb#_users
							SET space_used = space_used-#fileQuery.file_size#
							WHERE id = #user_id#;
						</cfquery>

					</cfif>

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
		<cfargument name="categories_ids" type="array" required="false">

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
					<cfif isDefined("arguments.typology_id") AND arguments.typology_id EQ "null">
						<cfinvokeargument name="with_null_typology" value="true">
					</cfif>
					<cfif isDefined("arguments.limit")>
					<cfinvokeargument name="limit" value="#arguments.limit#">
					</cfif>

					<cfinvokeargument name="name" value="#arguments.name#">
					<cfinvokeargument name="file_name" value="#arguments.file_name#">
					<cfinvokeargument name="description" value="#arguments.description#">
					<cfinvokeargument name="categories_ids" value="#arguments.categories_ids#">
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
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="areas_ids" type="string" required="false">
		<cfargument name="Filedata" type="string" required="false"/>
		<cfargument name="files" type="array" required="false"/>
		<cfargument name="typology_id" type="string" required="false">
		<cfargument name="reviser_user" type="numeric" required="false">
		<cfargument name="approver_user" type="numeric" required="false">
		<cfargument name="publication_scope_id" type="numeric" required="false">
		<cfargument name="publication_date" type="string" required="false">
		<cfargument name="publication_hour" type="numeric" required="false">
		<cfargument name="publication_minute" type="numeric" required="false">
		<cfargument name="publication_validated" type="boolean" required="false" default="false">
		<cfargument name="version_index" type="string" required="false">
		<cfargument name="public" type="boolean" required="false">
		<cfargument name="categories_ids" type="array" required="false">
		<cfargument name="no_notify" type="boolean" required="false" default="false">
		<cfargument name="group_versions" type="boolean" required="false" default="false">

		<cfset var method = "uploadNewFile">

		<cfset var response = structNew()>

		<cfset var destination = "">

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

			<cfif isDefined("arguments.Filedata")><!--- Default --->
				<cffile action="upload" filefield="Filedata" destination="#destination#" nameconflict="overwrite" result="uploadedFile">
			<cfelse><!---jQuery fileupload--->
				<cffile action="upload" filefield="files[]" destination="#destination#" nameconflict="overwrite" result="uploadedFile">
			</cfif>

			<cfset temp_file="#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#">

			<cfif len(uploadedFile.clientFileExt) IS 0>

				<cffile action="delete" file="#destination##temp_file#">

				<cfthrow message="No se puede subir un archivo sin extensión">

			</cfif>

			<cfif arguments.fileTypeId IS 3 AND arguments.group_versions IS true>

				<cflock type="exclusive" timeout="30">

					<cfset versionValue = ListLast(uploadedFile.clientFileName, " ")>
					<cfset versionValue = REReplace(versionValue,"^0+","","ALL")>

					<cfif IsNumeric(versionValue)>

						<cfset fileNameToSearch = left(uploadedFile.clientFileName, len(uploadedFile.clientFileName)-len(versionValue))>
						<cfset fileNameToSearchRE = "^#fileNameToSearch# ?[0-9]*\.#uploadedFile.clientFileExt#$">

						<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getAreaFiles" returnvariable="getAreaFilesResult">
							<cfinvokeargument name="area_id" value="#arguments.area_id#">
							<cfinvokeargument name="parse_dates" value="false">

							<cfinvokeargument name="file_name_re" value="#fileNameToSearchRE#">

							<cfinvokeargument name="with_user" value="false"/>

							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

						<cfset filesWithSameName = getAreaFilesResult.query>

						<cfif filesWithSameName.recordCount GT 0>

							<cffile action="delete" file="#destination##temp_file#">

							<cfif filesWithSameName.locked IS false>

								<cfinvoke component="FileManager" method="changeAreaFileLock" returnvariable="changeLockResponse">
									<cfinvokeargument name="file_id" value="#filesWithSameName.id#"/>
									<cfinvokeargument name="fileTypeId" value="#filesWithSameName.file_type_id#"/>
									<cfinvokeargument name="lock" value="true"/>
									<cfinvokeargument name="no_notify" value="#arguments.no_notify#">
								</cfinvoke>

							</cfif>

							<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="replaceFile" argumentcollection="#arguments#" returnvariable="response">
								<cfinvokeargument name="file_id" value="#filesWithSameName.id#">
								<cfinvokeargument name="version_index" value="#versionValue#">
								<cfif filesWithSameName.locked IS false>
									<cfinvokeargument name="unlock" value="true">
								</cfif>
							</cfinvoke>

						<cfelse>

							<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="uploadNewFileProcess" argumentcollection="#arguments#" returnvariable="response">
								<cfinvokeargument name="destination" value="#destination#">
								<cfinvokeargument name="uploadedFile" value="#uploadedFile#">
								<cfinvokeargument name="temp_file" value="#temp_file#">
								<cfinvokeargument name="user_id" value="#user_id#">
								<cfinvokeargument name="version_index" value="#versionValue#">

								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

						</cfif><!---filesWithSameName.recordCount GT 0--->

					<cfelse>

						<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="uploadNewFileProcess" argumentcollection="#arguments#" returnvariable="response">
							<cfinvokeargument name="destination" value="#destination#">
							<cfinvokeargument name="uploadedFile" value="#uploadedFile#">
							<cfinvokeargument name="temp_file" value="#temp_file#">
							<cfinvokeargument name="user_id" value="#user_id#">

							<cfinvokeargument name="client_abb" value="#client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>

					</cfif><!--- IsNumeric(versionValue)>--->

				</cflock>

			<cfelse>

				<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="uploadNewFileProcess" argumentcollection="#arguments#" returnvariable="response">
					<cfinvokeargument name="destination" value="#destination#">
					<cfinvokeargument name="uploadedFile" value="#uploadedFile#">
					<cfinvokeargument name="temp_file" value="#temp_file#">
					<cfinvokeargument name="user_id" value="#user_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ----------------------------------- uploadNewFile -------------------------------------- --->

	<cffunction name="uploadNewFileProcess" output="false" returntype="struct" access="private">
		<cfargument name="fileTypeId" type="numeric" required="true"/>
		<cfargument name="name" type="string" required="true"/>
		<cfargument name="description" type="string" required="true"/>
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="areas_ids" type="string" required="false">
		<cfargument name="Filedata" type="string" required="false"/>
		<cfargument name="files" type="array" required="false"/>
		<cfargument name="typology_id" type="string" required="false">
		<cfargument name="reviser_user" type="numeric" required="false">
		<cfargument name="approver_user" type="numeric" required="false">
		<cfargument name="publication_scope_id" type="numeric" required="false">
		<cfargument name="publication_date" type="string" required="false">
		<cfargument name="publication_hour" type="numeric" required="false">
		<cfargument name="publication_minute" type="numeric" required="false">
		<cfargument name="publication_validated" type="boolean" required="false" default="false">
		<cfargument name="version_index" type="string" required="false">
		<cfargument name="public" type="boolean" required="false">
		<cfargument name="categories_ids" type="array" required="false">
		<cfargument name="no_notify" type="boolean" required="false" default="false">
		<cfargument name="url_id" type="string" required="false">
		<cfargument name="group_versions" type="boolean" required="false" default="false">

		<cfargument name="destination" type="string" required="true">
		<cfargument name="uploadedFile" type="struct" required="true">
		<cfargument name="temp_file" type="string" required="true">
		<cfargument name="user_id" type="numeric" required="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">

		<cfset var method = "uploadNewFile">

		<cfset var response = structNew()>

		<cfset var destinationFile = "">
		<cfset var upload_file_id = "">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfinvoke component="FileManager" method="createFile" returnvariable="createFileResult">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfinvokeargument name="name" value="#arguments.name#"/>
				<cfinvokeargument name="file_name" value="#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#"/>
				<cfinvokeargument name="file_type" value=".#uploadedFile.clientFileExt#"/>
				<cfinvokeargument name="file_size" value="#uploadedFile.fileSize#"/>
				<cfinvokeargument name="description" value="#arguments.description#"/>
				<cfinvokeargument name="reviser_user" value="#arguments.reviser_user#"/>
				<cfinvokeargument name="approver_user" value="#arguments.approver_user#"/>
				<cfinvokeargument name="publication_scope_id" value="#arguments.publication_scope_id#"/>
				<cfinvokeargument name="status" value="ok">
				<cfinvokeargument name="version_index" value="#arguments.version_index#"/>
				<cfinvokeargument name="public" value="#arguments.public#"/>
				<cfinvokeargument name="categories_ids" value="#arguments.categories_ids#"/>
				<cfinvokeargument name="url_id" value="#arguments.url_id#"/>

				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
			</cfinvoke>

			<cfif createFileResult.result IS false><!---File insert fail--->

				<cffile action="delete" file="#destination##temp_file#">

				<!--- <cfset error_code = 602> --->

				<cfthrow message="#createFileResult.message#">

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

				<cfif arguments.fileTypeId IS 1>

					<!--- ------------------ Update User Space Used --------------------- --->
					<cfquery name="updateSpaceUsed" datasource="#client_dsn#">
						UPDATE #client_abb#_users
						SET space_used = space_used+<cfqueryparam value="#uploadedFile.fileSize#" cfsqltype="cf_sql_integer">
						WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

				</cfif>

				<!--- associateFileToArea --->
				<cfinvoke component="FileManager" method="associateFileToArea" returnvariable="associateFileResult">
					<cfinvokeargument name="objectFile" value="#objectFile#"/>
					<cfinvokeargument name="area_id" value="#arguments.area_id#"/>

					<cfif isDefined("arguments.publication_date")>
						<cfinvokeargument name="publication_date" value="#arguments.publication_date# #arguments.publication_hour#:#arguments.publication_minute#">
					</cfif>
					<cfinvokeargument name="publication_validated" value="#arguments.publication_validated#">
					<cfinvokeargument name="no_notify" value="#arguments.no_notify#">
				</cfinvoke>

				<cfif associateFileResult.result IS false>

					<cfthrow message="#associateFileResult.message#">

				</cfif>

				<!--- associateFileToAreas --->
				<cfif isDefined("arguments.areas_ids") AND len(arguments.areas_ids) GT 0 AND (arguments.fileTypeId IS 1 OR arguments.fileTypeId IS 2)>

					<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="associateFileToAreas" returnvariable="associateToAreasResult">
						<cfinvokeargument name="file_id" value="#upload_file_id#"/>
						<cfinvokeargument name="areas_ids" value="#arguments.areas_ids#"/>

						<cfif isDefined("arguments.publication_date")>
							<cfinvokeargument name="publication_date" value="#arguments.publication_date# #arguments.publication_hour#:#arguments.publication_minute#">
						</cfif>
						<cfinvokeargument name="publication_validated" value="#arguments.publication_validated#">
					</cfinvoke>

					<cfif associateToAreasResult.result IS false>

						<cfthrow message="#associateToAreasResult.message#">

					</cfif>

				</cfif>

				<cfset destinationFile = "#destination##upload_file_id#">

				<cffile action="rename" source="#destination##temp_file#" destination="#destinationFile#">

				<!--- MODULE ANTI VIRUS --->
				<cfif APPLICATION.moduleAntiVirus IS true>

					<!--- START THREAD --->
					<cfthread name="antiVirusCheckNewFile" action="run" priority="NORMAL" file_id="#upload_file_id#" fileTypeId="#arguments.fileTypeId#" user_id="#SESSION.user_id#" client_abb="#SESSION.client_abb#" client_dsn="#client_dsn#">

						<cftry>

							<!--- Wait for the execution of the antivirus check --->
							<cfscript>
								sleep(300);
							</cfscript>

							<cfinvoke component="#APPLICATION.coreComponentsPath#/AntiVirusManager" method="checkFile" returnvariable="checkFileResult">
								<cfinvokeargument name="file_id" value="#file_id#">
								<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
								<cfinvokeargument name="user_id" value="#user_id#">

								<cfinvokeargument name="client_abb" value="#client_abb#">
							</cfinvoke>

							<cfif checkFileResult.result IS false><!--- Delete infected file --->

								<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="deleteFile" returnvariable="deleteFileResult">
									<cfinvokeargument name="file_id" value="#file_id#">
									<cfinvokeargument name="forceDeleteVirus" value="true">
									<cfinvokeargument name="user_id" value="#user_id#">

									<cfinvokeargument name="client_abb" value="#client_abb#">
									<cfinvokeargument name="client_dsn" value="#client_dsn#">
								</cfinvoke>

								<cfif deleteFileResult.result IS false>
									<cfthrow message="#checkFileResult.message#">
								</cfif>

							</cfif>

							<cfcatch>

								<cfinclude template="includes/errorHandlerStruct.cfm">

							</cfcatch>

						</cftry>

					</cfthread>

				</cfif>


				<!--- PENDIENTE DE TERMINAR
				<cfif uploadedFile.clientFileExt EQ "pdf">

					<cfif FileExists(destinationFile)>

						<cfset destinationThumbnail = "#APPLICATION.filesPath#/#client_abb#/#fileTypeDirectory#_thumbnails/">

						<cfif NOT directoryExists(destinationThumbnail)>
							<cfdirectory action="create" directory="#destinationThumbnail#">
						</cfif>

						<cfset thumbnailFormat = "jpg">

						<cfpdf action="thumbnail" source="#destinationFile#" pages="1" destination="#destinationThumbnail#" format="#thumbnailFormat#">

						<cfquery name="updateFileThumbnail" datasource="#client_dsn#">
							UPDATE #client_abb#_files
							SET thumbnail = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
							thumbnail_format = <cfqueryparam value=".#thumbnailFormat#" cfsqltype="cf_sql_varchar">
							WHERE id = <cfqueryparam value="#upload_file_id#" cfsqltype="cf_sql_integer">;
						</cfquery>

					<cfelse><!---The physical file does not exist--->

						<cfset error_code = 608>

						<cfthrow errorcode="#error_code#" detail="#source#">

					</cfif>

				</cfif>
				---->


				<cfcatch><!---The upload fail--->

					<cfif isDefined("upload_file_id")>
						<cfquery datasource="#client_dsn#" name="changeFileStatus">
							UPDATE #client_abb#_#fileTypeTable#
							SET status = <cfqueryparam value="failed" cfsqltype="cf_sql_varchar">
							WHERE id = <cfqueryparam value="#upload_file_id#" cfsqltype="cf_sql_integer">;
						</cfquery>
					</cfif>

					<cfif FileExists("#destination##temp_file#")>
						<cffile action="delete" file="#destination##temp_file#">
					</cfif>

					<!---<cfset error_code = 604>--->

					<cfrethrow/>

				</cfcatch>

			</cftry>

			<cfset response = {result=true, file_id=#upload_file_id#, file=objectFile}>

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
		<cfargument name="publication_scope_id" type="numeric" required="false">
		<cfargument name="unlock" type="boolean" required="false" default="false">
		<cfargument name="public" type="boolean" required="false" default="false">
		<cfargument name="url_id" type="string" required="false">
		<!--- La fecha de publicación no se puede modificar én este método porque esos atributos pertenecen al área donde esté publicada el archivo y no son atributos propios del archivo. --->

		<cfset var method = "updateFile">

		<cfset var response = structNew()>

		<cfset var fileQuery = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

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

			<!--- Scope --->
			<cfif APPLICATION.publicationScope IS true AND isDefined("arguments.publication_scope_id")>

				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileAreas" returnvariable="getFileAreasQuery">
					<cfinvokeargument name="file_id" value="#arguments.file_id#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfloop query="getFileAreasQuery">

					<cfinvoke component="ScopeManager" method="isAreaInScope" returnvariable="isInScopeResult">
						<cfinvokeargument name="scope_id" value="#arguments.publication_scope_id#">
						<cfinvokeargument name="area_id" value="#getFileAreasQuery.area_id#">
					</cfinvoke>

					<cfif isInScopeResult.result IS false>

						<cfset response = {result=false, file_id=#arguments.file_id#, message="El ámbito de publicación seleccionado no es compatible con las áreas en las que está publicado el archivo"}>

						<cfreturn response>

					</cfif>

				</cfloop>

			</cfif>

			<cfif isDefined("arguments.url_id")>

				<!--- Check url_id length --->
				<cfif len(arguments.url_id) GT 255>

					<cfset response = {result=false, message="URL de la página demasiado larga, introduzca una URL con menos de 200 caracteres"}>
					<cfreturn response>

				</cfif>

				<!--- Check if url_id exist --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileByUrlQuery">
					<cfinvokeargument name="url_id" value="#arguments.url_id#">
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif fileByUrlQuery.recordCount GT 1 OR (fileByUrlQuery.recordCount IS 1 AND fileByUrlQuery.id NEQ arguments.file_id)>
					<cfset response = {result=false, message="La URL de la página ya existe, debe usar otra distinta"}>
					<cfreturn response>
				</cfif>

			</cfif>

			<cfif arguments.fileTypeId IS 1 OR arguments.fileTypeId IS 2>

				<cfif fileQuery.public NEQ arguments.public>

					<cfif arguments.public IS true>

						<cfset file_public_id = lCase(hash(CreateUUID()))>

					</cfif>

				</cfif>

			</cfif>

			<cftransaction>

				<cfquery name="updateFileQuery" datasource="#client_dsn#">
					UPDATE `#client_abb#_#fileTypeTable#`
					SET name = <cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
					description = <cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_longvarchar">
					<cfif arguments.fileTypeId IS 3>
						, reviser_user = <cfqueryparam value="#arguments.reviser_user#" cfsqltype="cf_sql_integer">
						, approver_user = <cfqueryparam value="#arguments.approver_user#" cfsqltype="cf_sql_integer">
					<cfelse>
						<cfif isDefined("arguments.publication_scope_id")>
							, publication_scope_id = <cfqueryparam value="#arguments.publication_scope_id#" cfsqltype="cf_sql_integer">
						</cfif>

						<cfif arguments.fileTypeId IS 1 OR arguments.fileTypeId IS 2>

							<cfif fileQuery.public NEQ arguments.public>

								, public = <cfqueryparam value="#arguments.public#" cfsqltype="cf_sql_bit">

								<cfif arguments.public IS true>
									, file_public_id = <cfqueryparam value="#file_public_id#" cfsqltype="cf_sql_varchar">
								<cfelse>
									, file_public_id = <cfqueryparam cfsqltype="cf_sql_varchar" null="true">
								</cfif>

							</cfif>

						</cfif>
					</cfif>
					<cfif isDefined("arguments.url_id")>
						, url_id = <cfqueryparam value="#lCase(arguments.url_id)#" cfsqltype="cf_sql_varchar">
					</cfif>
					WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
				</cfquery>


				<!--- deleteItemCategories --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="deleteItemCategories">
					<cfinvokeargument name="item_id" value="#arguments.file_id#">
					<cfinvokeargument name="itemTypeId" value="#fileItemTypeId#">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
				</cfinvoke>

				<cfif isDefined("arguments.categories_ids")>

					<!--- setItemCategories --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemManager" method="setItemCategories">
						<cfinvokeargument name="item_id" value="#arguments.file_id#">
						<cfinvokeargument name="itemTypeId" value="#fileItemTypeId#">
						<cfinvokeargument name="categories_ids" value="#arguments.categories_ids#"/>

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

				</cfif>

			</cftransaction>

			<!--- No se puede usar aquí transacción porque dentro de setFileTypology hay transacciones--->
			<!--- setFileTypology --->
			<cfif isDefined("arguments.typology_id")>

				<cfif fileQuery.typology_id NEQ arguments.typology_id AND isNumeric(fileQuery.typology_row_id)><!---File typology was changed--->

					<!--- Delete old row --->
					<cfinvoke component="RowManager" method="deleteRow" returnvariable="deleteRowResponse">
						<cfinvokeargument name="row_id" value="#fileQuery.typology_row_id#"/>
						<cfinvokeargument name="table_id" value="#fileQuery.typology_id#"/>
						<cfinvokeargument name="tableTypeId" value="#typologyTableTypeId#"/>
					</cfinvoke>

					<cfif deleteRowResponse.result IS false>
						<cfthrow message="#deleteRowResponse.message#">
					</cfif>

				</cfif>

				<cfif isNumeric(arguments.typology_id)><!--- Typology selected --->

					<cfinvoke component="FileManager" method="setFileTypology" argumentcollection="#arguments#" returnvariable="setFileTypologyResponse">
					</cfinvoke>

					<cfif setFileTypologyResponse.result IS false>
						<cfthrow message="#setFileTypologyResponse.message#">
					</cfif>

				<cfelse><!--- Clear file typology --->

					<cfinvoke component="FileManager" method="clearFileTypology" argumentcollection="#arguments#" returnvariable="clearFileTypologyResponse">
					</cfinvoke>

					<cfif clearFileTypologyResponse.result IS false>
						<cfthrow message="#clearFileTypologyResponse.message#">
					</cfif>

				</cfif>

			</cfif>

			<!---</cftransaction>--->

			<cfinclude template="includes/logRecord.cfm">

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

		<cfif SESSION.client_administrator NEQ user_id><!--- checkAdminAccess --->

			<cfif fileQuery.file_type_id IS NOT 1><!--- Area file --->

				<cfset area_id = fileQuery.area_id>

				<!---checkAreaAccess--->
				<cfinclude template="includes/checkAreaAccess.cfm">

			<cfelseif fileQuery.user_in_charge NEQ user_id><!--- User file --->

				<cfset error_code = 103><!---Access denied--->

				<cfthrow errorcode="#error_code#">

			</cfif>

		</cfif>


		<cfif fileQuery.locked IS true AND fileQuery.lock_user_id NEQ user_id>

			<cfset response = {result=false, file_id=#fileQuery.file_id#, message="El archivo de área está bloqueado por otro usuario y no puede ser modificado."}>

		<cfelseif fileQuery.locked IS false AND fileQuery.file_type_id IS NOT 1>

			<cfset response = {result=false, file_id=#fileQuery.file_id#, message="Debe bloquear el archivo de área para poder modificarlo."}>

		<cfelseif fileQuery.in_approval IS true>

			<cfset response = {result=false, file_id=#fileQuery.file_id#, message="No se puede modificar un archivo de área en proceso de aprobación."}>

		<cfelse>

			<cfset response = {result=true}>

		</cfif>

		<cfreturn response>

	</cffunction>




	<!--- ----------------------------------- replaceFile -------------------------------------- --->

	<cffunction name="replaceFile" output="false" returntype="struct" access="public">
		<cfargument name="file_id" type="string" required="true"/>
		<cfargument name="fileTypeId" type="numeric" required="true" />
		<cfargument name="Filedata" type="string" required="false"/>
		<cfargument name="version_index" type="string" required="false">
		<cfargument name="unlock" type="boolean" required="false" default="false">
		<cfargument name="no_notify" type="boolean" required="false" default="false">
		<cfargument name="group_versions" type="boolean" required="false" default="false">

		<cfset var method = "replaceFile">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var destination = "">
		<cfset var temp_file = "">
		<cfset var new_physical_name = "">
		<cfset var fileQuery = "">
		<cfset var version_id = "">

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

			<cfif isDefined("arguments.Filedata")><!--- Default --->
				<cffile action="upload" filefield="Filedata" destination="#destination#" nameconflict="overwrite" result="uploadedFile">
			<cfelse><!---jQuery fileupload--->
				<cffile action="upload" filefield="files[]" destination="#destination#" nameconflict="overwrite" result="uploadedFile">
			</cfif>

			<cfset temp_file="#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#">

			<cftry>

				<cfset file_name = "#uploadedFile.clientFileName#.#uploadedFile.clientFileExt#">
				<cfset file_type = lCase(".#uploadedFile.clientFileExt#")>
				<cfset file_size_full = uploadedFile.fileSize>

				<cftransaction>

					<cfif arguments.fileTypeId IS 3><!--- Save new version --->

						<cfif arguments.group_versions IS true>

							<!--- getLastFileVersion --->
							<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFileVersions" returnvariable="getLastFileVersionQuery">
								<cfinvokeargument name="file_id" value="#arguments.file_id#">
								<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
								<cfinvokeargument name="limit" value="1">

								<cfinvokeargument name="client_abb" value="#client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

							<cfset lastVersionIndex = getLastFileVersionQuery.version_index>

							<cfif len(lastVersionIndex) GT 0 AND NOT isNumeric(lastVersionIndex)>
								<!---remove characters that are not numeric--->
								<cfset lastVersionIndex = reReplaceNoCase(lastVersionIndex, '[^[:digit:]]', '', 'ALL')>
							</cfif>

						</cfif>

						<cfquery name="insertFileVersionQuery" datasource="#client_dsn#">
							INSERT INTO `#client_abb#_#fileTypeTable#_versions`
							SET file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">,
							file_name = <cfqueryparam value="#file_name#" cfsqltype="cf_sql_varchar">,
							version_index = <cfqueryparam value="#arguments.version_index#" cfsqltype="cf_sql_varchar">,
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
						replacement_user = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
						status = 'ok',
						status_replacement = 'uploaded',
						<cfif APPLICATION.moduleAntiVirus IS true>
							anti_virus_check = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
						<cfelse>
							anti_virus_check = <cfqueryparam null="true" cfsqltype="cf_sql_bit">,
						</cfif>
						anti_virus_check_result = <cfqueryparam null="true" cfsqltype="cf_sql_varchar">
						<cfif arguments.group_versions IS false OR arguments.version_index GTE lastVersionIndex>
							, file_size = <cfqueryparam value="#file_size_full#" cfsqltype="cf_sql_integer">
							, file_type = <cfqueryparam value="#file_type#" cfsqltype="cf_sql_varchar">
							, file_name = <cfqueryparam value="#file_name#" cfsqltype="cf_sql_varchar">
							<cfif arguments.fileTypeId IS 3>
							, physical_name = <cfqueryparam value="#new_physical_name#" cfsqltype="cf_sql_varchar">
							</cfif>
						</cfif>
						WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<cfif arguments.fileTypeId IS 1>

						<!--- Esto se deshabilitará para todos los archivos ya que no es un valor fiable porque los archivos de área no pertenecen a un sólo usuario, pero por ahora se deja para los archivos de usuario --->

						<!--- ------------------ Update User Space Used --------------------- --->
						<cfquery name="updateSpaceUsedRemove" datasource="#client_dsn#">
							UPDATE #client_abb#_users
							SET space_used = space_used-#fileQuery.file_size#
							WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
						</cfquery>

						<cfquery name="updateSpaceUsedAdd" datasource="#client_dsn#">
							UPDATE #client_abb#_users
							SET space_used = space_used+<cfqueryparam value="#file_size_full#" cfsqltype="cf_sql_integer">
							WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
						</cfquery>

					</cfif>

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


				<!--- MODULE ANTI VIRUS --->
				<cfif APPLICATION.moduleAntiVirus IS true>

					<!--- START THREAD --->
					<cfthread name="antiVirusCheckReplaceFile" action="run" priority="NORMAL" file_id="#arguments.file_id#" fileTypeId="#arguments.fileTypeId#" version_id="#version_id#" user_id="#SESSION.user_id#" client_abb="#SESSION.client_abb#" client_dsn="#client_dsn#">

						<cftry>

							<!--- Wait for the execution of the anti virus check --->
							<cfscript>
								sleep(300);
							</cfscript>

							<cfinvoke component="#APPLICATION.coreComponentsPath#/AntiVirusManager" method="checkFile" returnvariable="checkFileResult">
								<cfinvokeargument name="file_id" value="#file_id#">
								<cfinvokeargument name="fileTypeId" value="#fileTypeId#">
								<cfinvokeargument name="user_id" value="#user_id#">

								<cfinvokeargument name="client_abb" value="#client_abb#">
							</cfinvoke>

							<cfif checkFileResult.result IS false>

								<cfif arguments.fileTypeId IS 3><!--- Delete infected file version --->

									<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="deleteFileVersion" returnvariable="deleteFileResult">
										<cfinvokeargument name="file_id" value="#file_id#"/>
										<cfinvokeargument name="version_id" value="#version_id#"/>
										<cfinvokeargument name="send_alert" value="true">
										<cfinvokeargument name="forceDeleteVirus" value="true">
										<cfinvokeargument name="user_id" value="#user_id#">

										<cfinvokeargument name="client_abb" value="#client_abb#">
										<cfinvokeargument name="client_dsn" value="#client_dsn#">
									</cfinvoke>

								<cfelse><!--- Delete infected file --->

									<cfinvoke component="#APPLICATION.coreComponentsPath#/FileManager" method="deleteFile" returnvariable="deleteFileResult">
										<cfinvokeargument name="file_id" value="#file_id#">
										<cfinvokeargument name="forceDeleteVirus" value="true">
										<cfinvokeargument name="user_id" value="#user_id#">

										<cfinvokeargument name="client_abb" value="#client_abb#">
										<cfinvokeargument name="client_dsn" value="#client_dsn#">
									</cfinvoke>

								</cfif>

								<cfif deleteFileResult.result IS false>
									<cfthrow message="#deleteFileResult.message#">
								</cfif>

							</cfif>

							<cfcatch>

								<cfinclude template="includes/errorHandlerStruct.cfm">

							</cfcatch>

						</cftry>

					</cfthread>

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

			<cfif arguments.no_notify IS false>

				<!--- Alert --->
				<cfif arguments.fileTypeId IS NOT 3><!--- User document --->

					<!--- Replace file --->
					<cfinvoke component="AlertManager" method="replaceFile">
						<cfinvokeargument name="objectFile" value="#fileReplacedQuery#">
					</cfinvoke>

				<cfelse><!--- Area document --->

					<cfset area_id = fileQuery.area_id>

					<!--- New version --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newFile">
						<cfinvokeargument name="objectFile" value="#fileReplacedQuery#">
						<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
						<cfinvokeargument name="area_id" value="#area_id#">
						<cfinvokeargument name="user_id" value="#user_id#">
						<cfinvokeargument name="action" value="new_version">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

				</cfif>

			</cfif>


			<!--- Unlock file --->
			<cfif arguments.fileTypeId IS NOT 1 AND arguments.unlock IS true>

				<cfinvoke component="FileManager" method="changeAreaFileLock" returnvariable="changeLockResponse">
					<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
					<cfinvokeargument name="lock" value="false"/>
					<cfinvokeargument name="no_notify" value="#arguments.no_notify#">
				</cfinvoke>

				<cfif changeLockResponse.result IS false>

					<cfreturn changeLockResponse>

				</cfif>

			</cfif>

			<cfset response = {result=true, file_id=#arguments.file_id#, file=#fileReplacedQuery#}>


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
		<cfargument name="table_id" type="numeric" required="true"><!---Este parámetro viene incluído junto con el resto de campos de la tabla en el método outputRowFormInputs en RowHtml--->
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



	<!--- ----------------------------------- clearFileTypology -------------------------------------- --->

	<cffunction name="clearFileTypology" output="false" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">

		<cfset var method = "clearFileTypology">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfquery datasource="#client_dsn#" name="clearFileTypology">
				UPDATE #client_abb#_#fileTypeTable#
				SET typology_id = <cfqueryparam null="true" cfsqltype="cf_sql_integer">,
				typology_row_id = <cfqueryparam null="true" cfsqltype="cf_sql_integer">
				WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfset response = {result=true, file_id=#arguments.file_id#}>

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
				<cfinvokeargument name="published" value="false">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>


			<cfif fileQuery.file_type_id IS NOT 1><!--- Area file --->

				<!--- Si el archivo es de usuario, se comprueba después si puede modificarlo o no --->

				<!---canUserModifyFile--->
				<cfinvoke component="FileManager" method="canUserModifyFile" returnvariable="canUserModifyFileResponse">
					<cfinvokeargument name="fileQuery" value="#fileQuery#">
				</cfinvoke>
				<cfif canUserModifyFileResponse.result IS false>

					<cfreturn canUserModifyFileResponse>

				</cfif>

			</cfif>

			<cfif fileQuery.user_in_charge NEQ user_id>

				<cfif isDefined("arguments.area_id")>
					<!---checkAreaResponsibleAccess--->
					<cfinvoke component="AreaManager" method="checkAreaResponsibleAccess">
						<cfinvokeargument name="area_id" value="#arguments.area_id#">
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



	<!--- ----------------------------------- changeFileOwnerToArea -------------------------------------- --->

	<cffunction name="changeFileOwnerToArea" output="false" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="new_area_id" type="numeric" required="true">

		<cfset var method = "changeFileOwnerToArea">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">

				<cfinvokeargument name="with_lock" value="true">
				<cfinvokeargument name="parse_dates" value="true">
				<cfinvokeargument name="published" value="false">

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

			<!---Chequea si existe el archivo en el área--->
			<cfquery datasource="#client_dsn#" name="isFileInAreaQuery">
				SELECT file_id
				FROM #client_abb#_areas_files
				WHERE area_id = <cfqueryparam value = "#arguments.new_area_id#" cfsqltype="cf_sql_integer"> AND
				file_id = <cfqueryparam value = "#arguments.file_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfif isFileInAreaQuery.recordCount IS 0><!---The file NOT exists in the area--->

				<!--- Esto es necesario para que se puedan comprobar las áreas donde se pueden asociar el archivo --->
				<cfset querySetCell(fileQuery, "file_type_id", 2)>
				<cfset querySetCell(fileQuery, "area_id", arguments.new_area_id)>

				<!--- associateFileToArea --->
				<cfinvoke component="FileManager" method="associateFileToArea" returnvariable="associateFileResult">
					<cfinvokeargument name="objectFile" value="#fileQuery#">
					<cfinvokeargument name="area_id" value="#arguments.new_area_id#">
				</cfinvoke>

				<cfif associateFileResult.result IS false>

					<cfset response = {result=false, file_id=#arguments.file_id#, message=#associateFileResult.message#}>

					<cfreturn response>

				</cfif>

			</cfif>

			<!--- Set file to area --->
			<cfquery datasource="#client_dsn#" name="setFileToArea">
				UPDATE #client_abb#_files
				SET file_type_id = <cfqueryparam value="2" cfsqltype="cf_sql_integer">,
				area_id = <cfqueryparam value="#arguments.new_area_id#" cfsqltype="cf_sql_integer">
				WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
			</cfquery>


			<!---Send Alert--->
			<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newFile">
				<cfinvokeargument name="objectFile" value="#fileQuery#">
				<cfinvokeargument name="fileTypeId" value="2"/>
				<cfinvokeargument name="area_id" value="#arguments.new_area_id#">
				<cfinvokeargument name="user_id" value="#user_id#">

				<cfinvokeargument name="action" value="change_owner_to_area">

				<cfinvokeargument name="client_abb" value="#client_abb#">
				<cfinvokeargument name="client_dsn" value="#client_dsn#">
			</cfinvoke>

			<cfinclude template="includes/logRecord.cfm">

			<cfset response = {result=true, file_id=#arguments.file_id#}>


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

				<!--- getArea --->
				<cfinvoke component="AreaManager" method="getArea" returnvariable="areaQuery">
					<cfinvokeargument name="get_area_id" value="#fileQuery.area_id#">
					<cfinvokeargument name="return_type" value="query">
				</cfinvoke>

				<cfif areaQuery.read_only IS true>

					<cfset message = "El área de origen es de solo lectura">
					<cfset response = {result=false, message=#message#, file_id=#arguments.file_id#}>

					<cfreturn response>

				</cfif>

				<!--- getArea --->
				<cfinvoke component="AreaManager" method="getArea" returnvariable="newAreaQuery">
					<cfinvokeargument name="get_area_id" value="#arguments.new_area_id#">
					<cfinvokeargument name="return_type" value="query">
				</cfinvoke>

				<cfif newAreaQuery.read_only IS true>

					<cfset message = "El área de destino es de solo lectura">
					<cfset response = {result=false, message=#message#, file_id=#arguments.file_id#}>

					<cfreturn response>

				<cfelseif newAreaQuery['item_type_#fileItemTypeId#_enabled'] IS false>

					<cfset message = "Tipo de elemento deshabilitado en el área de destino">
					<cfset response = {result=false, message=#message#, file_id=#arguments.file_id#}>

					<cfreturn response>

				</cfif>


				<!--- associateFileToArea --->
				<cfinvoke component="FileManager" method="associateFileToArea" returnvariable="associateFileResult">
					<cfinvokeargument name="objectFile" value="#fileQuery#">
					<cfinvokeargument name="area_id" value="#arguments.new_area_id#">
				</cfinvoke>

				<cfif associateFileResult.result IS false>

					<cfset response = {result=false, file_id=#arguments.file_id#, new_area_id=#arguments.new_area_id#, old_area_id=#fileQuery.area_id#, message=#associateFileResult.message#}>

					<cfreturn response>

				</cfif>

				<!--- dissociateFile --->
				<cfinvoke component="FileManager" method="dissociateFileFromArea" returnvariable="dissociateFileResult">
					<cfinvokeargument name="objectFile" value="#fileQuery#"/>
					<cfinvokeargument name="area_id" value="#fileQuery.area_id#"/>
				</cfinvoke>

				<cfif dissociateFileResult.result IS false>

					<cfset response = {result=false, file_id=#arguments.file_id#, new_area_id=#arguments.new_area_id#, old_area_id=#fileQuery.area_id#, message=#dissociateFileResult.message#}>

					<cfreturn response>

				</cfif>

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
		<cfargument name="no_notify" type="boolean" required="false" default="false">

		<cfset var method = "changeAreaFileLock">

		<cfset var response = structNew()>

		<cfset var area_id = "">
		<cfset var fileQuery = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cflock name="#client_abb#_file_#arguments.file_id#" type="exclusive" timeout="10">

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
						SET
						lock_id = <cfqueryparam value="#CreateUUID()#" cfsqltype="cf_sql_varchar">,
						file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">,
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


				<cfif arguments.no_notify IS false>

					<!--- Alert --->
					<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newFile">
						<cfinvokeargument name="objectFile" value="#fileQuery#">
						<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
						<cfinvokeargument name="area_id" value="#area_id#">
						<cfinvokeargument name="user_id" value="#user_id#">
						<cfif arguments.lock IS true>
							<cfinvokeargument name="action" value="lock">
						<cfelse>
							<cfinvokeargument name="action" value="unlock">
						</cfif>

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

				</cfif>

			</cflock>

			<cfset response = {result=true, file_id=#arguments.file_id#, lock=arguments.lock}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!---  ------------------------------------------------------------------------ --->



	<!---  ---------------------- changeFilePublicationValidation -------------------------------- --->

	<cffunction name="changeFilePublicationValidation" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="validate" type="boolean" required="true">

		<cfset var method = "changeFilePublicationValidation">

		<cfset var response = structNew()>

		<cfset var fileQuery = "">

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfquery name="getFile" datasource="#client_dsn#">
				SELECT publication_validated
				FROM #client_abb#_areas_files
				WHERE file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">
				AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
			</cfquery>

			<cfif getFile.recordCount GT 0>

				<!---checkAreaAccess--->
				<cfinvoke component="AreaManager" method="checkAreaAccess">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>

				<!--- isUserAreaResponsible --->
				<cfinvoke component="AreaManager" method="isUserAreaResponsible" returnvariable="isUserAreaResponsible">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>

				<cfif APPLICATION.publicationValidation IS true AND isUserAreaResponsible IS true>

					<cfquery name="changeFilePublication" datasource="#client_dsn#">
						UPDATE #client_abb#_areas_files
						SET	publication_validated = <cfqueryparam value="#arguments.validate#" cfsqltype="cf_sql_bit">
							<cfif arguments.validate IS true AND getFile.publication_validated IS false>
								, publication_validated_user = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">
								, publication_validated_date = NOW()
							</cfif>
						WHERE file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">
						AND area_id = <cfqueryparam value="#arguments.area_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<!---<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaFileQuery" method="getFile" returnvariable="itemQuery">
						<cfinvokeargument name="item_id" value="#arguments.item_id#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="parse_dates" value="true">
						<cfinvokeargument name="published" value="false">

						<cfinvokeargument name="client_abb" value="#client_abb#">
						<cfinvokeargument name="client_dsn" value="#client_dsn#">
					</cfinvoke>

					<!---Alert--->
					 <cfinvoke component="AlertManager" method="newAreaFile">
						<cfinvokeargument name="objectFile" value="#itemQuery#">
						<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
						<cfinvokeargument name="action" value="done">
					</cfinvoke> --->

					<cfinclude template="includes/logRecord.cfm">

					<cfset response = {result=true, area_id=arguments.area_id}>

				<cfelse>

					<cfset response = {result=false, message="Error, no tiene permiso para publicar en esta área"}>

				</cfif>

			<cfelse>

				<cfset response = {result=false, message="Error, no se ha encontrado el elemento"}>

			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>
	<!---  ------------------------------------------------------------------------- --->



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

			<!--- Cualquier usuario del área puede enviar a revisión un documento --->

			<!---checkAreaAccess--->
			<cfinvoke component="AreaManager" method="checkAreaAccess">
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



	<!---  -------------------------- cancelRevisionRequest -------------------------------- --->

	<cffunction name="cancelRevisionRequest" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">

		<cfset var method = "cancelRevisionRequest">

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

			<!--- Cualquier usuario del área puede cancelar la revisión un documento --->

			<!---checkAreaAccess--->
			<cfinvoke component="AreaManager" method="checkAreaAccess">
				<cfinvokeargument name="area_id" value="#area_id#">
			</cfinvoke>

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

			<cfelseif fileVersionQuery.revised IS true OR fileVersionQuery.revised>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="Este archivo ya ha sido revisado, no se puede cancelar."}>

			<cfelse>

				<cfset version_id = fileVersionQuery.version_id>

				<cftransaction>

					<!--- Set file in approval --->
					<cfquery datasource="#client_dsn#" name="changeFileApprovalState">
						UPDATE `#client_abb#_files`
						SET in_approval = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
						WHERE id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

					<!--- Save revision request --->
					<cfquery datasource="#client_dsn#" name="saveRequestApprovalQuery">
						UPDATE `#client_abb#_files_versions`
						SET revision_user = <cfqueryparam null="true" cfsqltype="cf_sql_integer">,
						approval_user = <cfqueryparam null="true" cfsqltype="cf_sql_integer">,
						revised = <cfqueryparam null="true" cfsqltype="cf_sql_bit">,
						revision_request_user = <cfqueryparam null="true" cfsqltype="cf_sql_integer">,
						revision_request_date = <cfqueryparam null="true" cfsqltype="cf_sql_timestamp">
						WHERE version_id = <cfqueryparam value="#version_id#" cfsqltype="cf_sql_integer">
						AND file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="cf_sql_integer">;
					</cfquery>

				</cftransaction>

				<!--- Alert --->
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newFile">
					<cfinvokeargument name="objectFile" value="#fileQuery#">
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfinvokeargument name="user_id" value="#user_id#">
					<cfinvokeargument name="action" value="cancel_revision">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
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




	<!---  -------------------------- validateFileVersion -------------------------------- --->

	<cffunction name="validateFileVersion" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="valid" type="boolean" required="true">
		<cfargument name="revision_result_reason" type="string" required="false">

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

			<cfelseif arguments.valid IS false AND NOT isDefined("arguments.revision_result_reason")>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="Motivo de rechazo requerido."}>

			<cfelse>

				<cfset version_id = fileVersionQuery.version_id>

				<cftransaction>

					<cfquery datasource="#client_dsn#" name="addFileRevision">
						UPDATE `#client_abb#_#fileTypeTable#_versions`
						SET
						revised = 1,
						revision_date = NOW(),
						revision_result = <cfqueryparam value="#arguments.valid#" cfsqltype="cf_sql_bit">
						<cfif arguments.valid IS false>
							, revision_result_reason = <cfqueryparam value="#arguments.revision_result_reason#" cfsqltype="cf_sql_longvarchar">
						</cfif>
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
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newFile">
					<cfinvokeargument name="objectFile" value="#fileQuery#">
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfinvokeargument name="user_id" value="#user_id#">
					<cfif arguments.valid IS true>
						<cfinvokeargument name="action" value="validate_version">
					<cfelse>
						<cfinvokeargument name="action" value="reject_version">
					</cfif>

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
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
		<cfargument name="approval_result_reason" type="string" required="false">

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

			<cfelseif arguments.approve IS false AND NOT isDefined("arguments.approval_result_reason")>

				<cfset response = {result=false, file_id=#arguments.file_id#, message="Motivo de rechazo requerido."}>

			<cfelse>

				<cfset version_id = fileVersionQuery.version_id>

				<cftransaction>

					<cfquery datasource="#client_dsn#" name="addFileApprove">
						UPDATE `#client_abb#_#fileTypeTable#_versions`
						SET
						approval_date = NOW(),
						approved = <cfqueryparam value="#arguments.approve#" cfsqltype="cf_sql_bit">
						<cfif arguments.approve IS false>
							, approval_result_reason = <cfqueryparam value="#arguments.approval_result_reason#" cfsqltype="cf_sql_longvarchar">
						</cfif>
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
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newFile">
					<cfinvokeargument name="objectFile" value="#fileQuery#">
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfinvokeargument name="user_id" value="#user_id#">
					<cfif arguments.approve IS true>
						<cfinvokeargument name="action" value="approve_version">
					<cfelse>
						<cfinvokeargument name="action" value="reject_version">
					</cfif>

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
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
		<cfargument name="publication_scope_id" type="numeric" required="false">
		<cfargument name="publication_date" type="string" required="false">
		<cfargument name="publication_hour" type="numeric" required="false">
		<cfargument name="publication_minute" type="numeric" required="false">
		<cfargument name="publication_validated" type="boolean" required="false" default="false">

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

			<!--- checkScope --->
			<cfif APPLICATION.publicationScope IS true>

				<cfinvoke component="ScopeManager" method="getScopes" returnvariable="getScopesResult">
				</cfinvoke>
				<cfset scopesQuery = getScopesResult.scopes>

				<cfif scopesQuery.recordCount GT 0>

					<cfinvoke component="ScopeManager" method="isAreaInScope" returnvariable="isInScopeResult">
						<cfinvokeargument name="scope_id" value="#arguments.publication_scope_id#">
						<cfinvokeargument name="area_id" value="#arguments.publication_area_id#">
					</cfinvoke>

					<cfif isInScopeResult.result IS false>

						<cfset response = {result=false, message="El ámbito seleccionado para este archivo no permite publicarlo en esta área"}>

						<cfreturn response>

					</cfif>

				</cfif>

			</cfif>

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

				<!--- createFile --->
				<cfinvoke component="FileManager" method="createFile" returnvariable="createFileResult">
					<cfinvokeargument name="fileTypeId" value="#publisedFileTypeId#"/>
					<cfinvokeargument name="name" value="#arguments.name#"/>
					<cfinvokeargument name="file_name" value="#fileVersionQuery.file_name#"/>
					<cfinvokeargument name="file_type" value="#fileVersionQuery.file_type#"/>
					<cfinvokeargument name="file_size" value="#fileVersionQuery.file_size#"/>
					<cfinvokeargument name="description" value="#arguments.description#"/>
					<cfinvokeargument name="area_id" value="#fileQuery.area_id#"/>
					<cfinvokeargument name="publication_scope_id" value="#arguments.publication_scope_id#"/>

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
					<cfinvoke component="FileManager" method="associateFileToArea" returnvariable="associateFileResult">
						<cfinvokeargument name="objectFile" value="#newObjectFile#"/>
						<cfinvokeargument name="area_id" value="#arguments.publication_area_id#"/>

						<cfif isDefined("arguments.publication_date")>
							<cfinvokeargument name="publication_date" value="#arguments.publication_date# #arguments.publication_hour#:#arguments.publication_minute#">
						</cfif>
						<cfinvokeargument name="publication_validated" value="#arguments.publication_validated#">
					</cfinvoke>

					<cfif associateFileResult.result IS false>

						<cfthrow message="#associateFileResult.message#">

					</cfif>

					<!---
						<cftransaction>

						Se deshabilita para los archivos que no son de usuario

						<cfquery name="updateSpaceUsed" datasource="#client_dsn#">
							UPDATE #client_abb#_users
							SET space_used = space_used+<cfqueryparam value="#fileQuery.file_size#" cfsqltype="cf_sql_integer">
							WHERE id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
						</cfquery>

						--->

						<cfquery name="updateFileVersion" datasource="#client_dsn#">
							UPDATE `#client_abb#_#fileTypeTable#_versions`
							SET
							publication_user = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">,
							publication_file_id = <cfqueryparam value="#new_file_id#" cfsqltype="cf_sql_integer">,
							publication_area_id = <cfqueryparam value="#arguments.publication_area_id#" cfsqltype="cf_sql_integer">,
							publication_date = NOW()
							WHERE version_id = <cfqueryparam value="#arguments.version_id#" cfsqltype="cf_sql_integer">
							AND file_id = <cfqueryparam value="#old_file_id#" cfsqltype="cf_sql_integer">;
						</cfquery>

					<!--- </cftransaction> --->

					<cfcatch>

						<cfquery datasource="#client_dsn#" name="changeFileStatus">
							UPDATE #client_abb#_files
							SET status = <cfqueryparam value="failed" cfsqltype="cf_sql_varchar">
							WHERE id = <cfqueryparam value="#new_file_id#" cfsqltype="cf_sql_integer">;
						</cfquery>

						<cfrethrow>

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
						version_index = <cfqueryparam value="#fileVersionQuery.version_index#" cfsqltype="cf_sql_varchar">,
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
				<cfinvoke component="#APPLICATION.coreComponentsPath#/AlertManager" method="newFile">
					<cfinvokeargument name="objectFile" value="#fileReplacedQuery#">
					<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
					<cfinvokeargument name="area_id" value="#area_id#">
					<cfinvokeargument name="user_id" value="#user_id#">
					<cfinvokeargument name="action" value="new_current_version">

					<cfinvokeargument name="client_abb" value="#client_abb#">
					<cfinvokeargument name="client_dsn" value="#client_dsn#">
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


	<!---getFilesDownloads--->

	<cffunction name="getFilesDownloads" output="false" returntype="struct" access="public">
		<cfargument name="parse_dates" type="boolean" required="false" default="false">
		<cfargument name="from_date" type="string" required="false">
		<cfargument name="end_date" type="string" required="false">
		<cfargument name="user_in_charge" type="numeric" required="false">
		<cfargument name="download_user_id" type="numeric" required="false">
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="include_subareas" type="boolean" required="false" default="false">
		<cfargument name="include_without_downloads" type="boolean" required="false" default="false">

		<cfset var method = "getFilesDownloads">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="includes/functionStartOnlySession.cfm">

			<cfinclude template="includes/checkAdminAccess.cfm">

			<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFilesDownloads" returnvariable="filesDownloadsQuery">
				<cfinvokeargument name="parse_dates" value="#arguments.parse_dates#">
				<cfif isDefined("arguments.from_date")>
					<cfinvokeargument name="from_date" value="#arguments.from_date#"/>
				</cfif>
				<cfif isDefined("arguments.end_date")>
					<cfinvokeargument name="end_date" value="#arguments.end_date#"/>
				</cfif>
				<cfinvokeargument name="user_in_charge" value="#arguments.user_in_charge#"/>
				<cfinvokeargument name="download_user_id" value="#arguments.download_user_id#"/>
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="include_subareas" value="#arguments.include_subareas#">
				<cfinvokeargument name="include_without_downloads" value="#arguments.include_without_downloads#">

				<cfinvokeargument name="client_abb" value="#client_abb#"/>
				<cfinvokeargument name="client_dsn" value="#client_dsn#"/>
			</cfinvoke>

			<cfset response = {result=true, query=#filesDownloadsQuery#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerStruct.cfm">

			</cfcatch>
		</cftry>

		<cfreturn response>

	</cffunction>



</cfcomponent>
