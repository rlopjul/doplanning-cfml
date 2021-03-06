<!---Copyright Era7 Information Technologies 2007-2013

	Date of file creation: 02-10-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena

--->
<cfcomponent output="false">

	<cfset component = "File">
	<cfset request_component = "FileManager">


	<!--- ---------------------------------- selectFile -------------------------------------- --->

	<cffunction name="selectFile" returntype="xml" access="public">
		<cfargument name="file_id" type="numeric" required="true">

		<cfset var method = "selectFile">

		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">

		<cftry>

			<cfsavecontent variable="request_parameters">
				<cfoutput>
					<file id="#arguments.file_id#"/>
				</cfoutput>
			</cfsavecontent>

			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

		<cfreturn xmlResponse>

	</cffunction>


	<!--- ---------------------------------- getFile -------------------------------------- --->

	<cffunction name="getFile" returntype="query" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="false">
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="item_id" type="numeric" required="false">
		<cfargument name="itemTypeId" type="numeric" required="false">
		<cfargument name="with_owner_area" type="boolean" required="false">
		<cfargument name="status" type="string" required="false">

		<cfset var method = "getFile">

		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">

		<cfset var objectFile = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="getFile" returnvariable="objectFile">
				<cfinvokeargument name="get_file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#">
				<cfif isDefined("arguments.area_id")>
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfif>
				<cfif isDefined("arguments.item_id")>
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
				</cfif>
				<cfif isDefined("arguments.itemTypeId")>
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				</cfif>
				<cfinvokeargument name="return_type" value="query">
				<cfinvokeargument name="with_owner_area" value="#arguments.with_owner_area#">
				<cfinvokeargument name="status" value="#arguments.status#">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

		<cfreturn objectFile>

	</cffunction>


	<!--- ---------------------------------- checkAreaFileAccess -------------------------------------- --->

	<cffunction name="checkAreaFileAccess" output="false" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">

		<cfset var method = "checkAreaFileAccess">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="checkAreaFileAccess" returnvariable="checkAreaFileAccessResponse">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
			</cfinvoke>

			<cfif checkAreaFileAccessResponse.result IS false>

				<cfset error_code = 104>

				<cfthrow errorcode="#error_code#">

			</cfif>

			<cfset response = checkAreaFileAccessResponse>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ---------------------------------- canUserDeleteFile -------------------------------------- --->

	<cffunction name="canUserDeleteFile" output="false" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileQuery" type="query" required="true">
		<cfargument name="area_id" type="numeric" required="false">

		<cfset var method = "canUserDeleteFile">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="canUserDeleteFile" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="fileQuery" value="#arguments.fileQuery#">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>




	<!--- ----------------------------------- getEmptyFile -------------------------------------- --->

	<cffunction name="getEmptyFile" output="false" returntype="struct" access="public">

		<cfset var method = "getEmptyFile">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="getEmptyFile" returnvariable="response">
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response.file>

	</cffunction>


	<!--- ----------------------------------- getFileAreas------------------------------------- --->

	<cffunction name="getFileAreas" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="accessCheck" type="boolean" required="false" default="true">

		<cfset var method = "getFileAreas">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="getFileAreas" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="accessCheck" value="#arguments.accessCheck#"/>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ----------------------------------- getFileVersion ------------------------------------- --->

	<cffunction name="getFileVersion" returntype="query" access="public">
		<cfargument name="version_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">

		<cfset var method = "getFileVersion">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="getFileVersion" returnvariable="response">
				<cfinvokeargument name="version_id" value="#arguments.version_id#"/>
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response.version>

	</cffunction>


	<!--- ----------------------------------- getLastFileVersion ------------------------------------- --->

	<cffunction name="getLastFileVersion" returntype="query" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">

		<cfset var method = "getLastFileVersion">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="getLastFileVersion" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response.version>

	</cffunction>


	<!--- ----------------------------------- getFileVersions ------------------------------------- --->

	<cffunction name="getFileVersions" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">

		<cfset var method = "getFileVersions">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="getFileVersions" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ----------------------------------- isFileApproved ------------------------------------- --->

	<cffunction name="isFileApproved" returntype="boolean" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">

		<cfset var method = "isFileApproved">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="isFileApproved" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response.approved>

	</cffunction>


	<!--- ---------------------------------- convertFile -------------------------------------- --->

	<cffunction name="convertFile" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="file_type" type="string" required="true">
		<cfargument name="itemTypeId" type="numeric" required="false">
		<cfargument name="item_id" type="numeric" required="false">

		<cfset var method = "convertFile">

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="convertFile" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="file_type" value="#arguments.file_type#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
			</cfinvoke>

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ---------------------------------- convertFileRemote -------------------------------------- --->

	<cffunction name="convertFileRemote" output="false" returntype="struct" access="remote" returnformat="json">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="file_type" type="string" required="true">
		<cfargument name="itemTypeId" type="numeric" required="false">
		<cfargument name="item_id" type="numeric" required="false">

		<cfset var method = "convertFileRemote">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="convertFile" returnvariable="convertFileResponse">
				<cfinvokeargument name="file_id" value="#arguments.file_id#">
				<cfinvokeargument name="file_type" value="#arguments.file_type#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
				<cfinvokeargument name="item_id" value="#arguments.item_id#">
			</cfinvoke>

			<cfset message = convertFileResponse.message>

			<cfset open_file = "">

			<cfif arguments.file_type EQ ".pdf">
				<cfset open_file = "&open=1">
			</cfif>

			<cfset download_url = "#APPLICATION.htmlPath#/file_converted_download.cfm?file=#arguments.file_id#&file_type=#arguments.file_type##open_file#">

			<cfif isDefined("arguments.itemTypeId") AND isDefined("arguments.item_id")>
				<cfset download_url = download_url&"&itemTypeId=#arguments.itemTypeId#&item_id=#arguments.item_id#">
			</cfif>

			<cfoutput>
			<cfsavecontent variable="responseContent">

				<cfif convertFileResponse.result IS true>

					<div class="hidden">#message#</div>

					<div style="padding-top:10px; margin-bottom:20px;">

						<a href="#download_url#" target="_blank" class="btn btn-primary"><i class="fa fa-eye" aria-hidden="true"></i> <span lang="es">Ver archivo</span></a>

					</div>

					<p style="margin-bottom:18px;" lang="es">
						IMPORTANTE: el archivo generado puede no reproducir exactamente el contenido del original. Para una visualización detallada se recomienda ver el archivo original.
					</p>

				<cfelse>

					<div class="alert alert-danger">#message#</div>

				</cfif>

			</cfsavecontent>
			</cfoutput>

			<cfset response = {result=true, message=responseContent}>

			<cfcatch>
				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ---------------------------------- outputConvertFileMenu -------------------------------------- --->

	<cffunction name="outputConvertFileMenu" returntype="void" access="public" output="true">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="file_type" type="string" required="true">
		<cfargument name="itemTypeId" type="numeric" required="false">
		<cfargument name="item_id" type="numeric" required="false">

		<cfset var method = "outputConvertFileMenu">

		<cfset var convert_page = "#APPLICATION.htmlComponentsPath#/File.cfc?method=convertFileRemote&file_id=#arguments.file_id#">

			<cfinvoke component="#APPLICATION.htmlComponentsPath#/FileType" method="getFileTypesConversion" returnvariable="fileTypeConversion">
			  <cfinvokeargument name="file_type" value="#arguments.file_type#"/>
			</cfinvoke>
			<cfset fileTypeConversionQuery = fileTypeConversion.query>

			<cfif isDefined("arguments.itemTypeId") AND isDefined("arguments.item_id")>
				<cfset convert_page = convert_page&"&itemTypeId=#arguments.itemTypeId#&item_id=#arguments.item_id#">
			</cfif>

			<script>

			  $(function() {

			    $( ".convert_file" ).click(function(event) {

			      event.preventDefault();

			      var bootboxLoading = bootbox.dialog({
			          message: '<div class="progress progress-striped active" style="height:23px"><div class="progress-bar" style="width:100%;"><span lang="es">Generando vista de archivo</span></div></div><p lang="es">Este proceso tardará dependiendo del tamaño del archivo</p>',
			          title: window.lang.translate('Generando vista de archivo'),
			          closeButton: false
			      });

			      $.ajax({

			        type: 'GET',
			        url: $(this).attr('href'),
			        dataType: "json",
			        success: function(data, status) {

			          bootboxLoading.modal('hide');

			          bootbox.dialog({
			              message: data.message,
			              title: window.lang.translate('Vista de archivo'),
			              onEscape: function() {}
			          }).on('click', function (event) {
			              $(this).modal('hide');
			          });

			        }

			      });


			    });


			  });

			</script>

			<cfif fileTypeConversionQuery.recordCount GT 0>

			  <div class="btn-group">

			    <cfif fileTypeConversionQuery.recordCount IS 1>

			      <cfset convert_url = convert_page&"&file_type=#fileTypeConversionQuery.file_type#">

			      <a href="#convert_url#" class="btn btn-default btn-sm convert_file"><i class="fa fa-eye" aria-hidden="true"></i> <span lang="es">Ver como</span> #fileTypeConversionQuery.name_es#</a>


			    <cfelse>

			      <a href="##" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown" title="Convertir el archivo en" lang="es">
			      <i class="fa fa-eye" aria-hidden="true"></i> <span lang="es">Ver como</span> <span class="caret"></span></a>

			      <ul class="dropdown-menu">

			        <cfloop query="fileTypeConversionQuery">

			          <cfset convert_url = convert_page&"&file_type=#fileTypeConversionQuery.file_type#">

			          <li><a href="#convert_url#" class="convert_file">#fileTypeConversionQuery.name_es#</a></li>

			        </cfloop>

			      </ul>

			    </cfif>

			  </div>

			</cfif>



	</cffunction>







	<!--- ---------------------------------- associateFile -------------------------------------- --->

	<cffunction name="associateFile" returntype="void" access="remote">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">

		<cfargument name="publication_date" type="string" required="false">
		<cfargument name="publication_hour" type="numeric" required="false">
		<cfargument name="publication_minute" type="numeric" required="false">
		<cfargument name="publication_validated" type="boolean" required="false">

		<cfargument name="return_path" type="string" required="yes">

		<cfset var method = "associateFile">

		<cfset var response = structNew()>

		<cftry>

			<!---<cfsavecontent variable="request_parameters">
				<cfoutput>
					<file id="#arguments.file_id#"/>
					<area id="#arguments.area_id#"/>
				</cfoutput>
			</cfsavecontent>

			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>

			<cfset msg = "Archivo asociado al área.">
			<cfset msg = URLEncodedFormat(msg)>

			<!---<cflocation url="#arguments.return_path#files.cfm?area=#arguments.area_id#&msg=#msg#&res=1" addtoken="no">--->
			<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&msg=#msg#&res=1" addtoken="no">--->

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="associateFile" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>

				<cfif isDefined("arguments.publication_date")>
					<cfinvokeargument name="publication_date" value="#arguments.publication_date# #arguments.publication_hour#:#arguments.publication_minute#">
				</cfif>
				<cfinvokeargument name="publication_validated" value="#arguments.publication_validated#">
			</cfinvoke>

			<cfif response.result IS true>
				<cfset msg = "Archivo asociado al área.">
				<cfset msg = URLEncodedFormat(msg)>
				<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&file=#arguments.file_id#&msg=#msg#&res=1" addtoken="no">
			<cfelse>
				<cfset msg = response.message>
				<cfset msg = URLEncodedFormat(msg)>
				<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&file=#arguments.file_id#&msg=#msg#&res=0" addtoken="no">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

	</cffunction>


	<!--- ---------------------------------- associateFilesToAreas -------------------------------------- --->

	<cffunction name="associateFilesToAreas" access="public" returntype="struct">
		<cfargument name="files_ids" type="string" required="true">
		<cfargument name="areas_ids" type="array" required="true">

		<cfargument name="publication_date" type="string" required="false">
		<cfargument name="publication_hour" type="numeric" required="false">
		<cfargument name="publication_minute" type="numeric" required="false">
		<cfargument name="publication_validated" type="boolean" required="false">

		<cfset var method = "associateFilesToAreas">

		<cfset var response = structNew()>

		<cfset var response_message = "">
		<cfset var response_messages = "">

		<cftry>

			<cfloop list="#files_ids#" index="file_id">

				<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="associateFileToAreas" returnvariable="associateResponse">
					<cfinvokeargument name="file_id" value="#file_id#"/>
					<cfinvokeargument name="areas_ids" value="#arrayToList(arguments.areas_ids)#"/>

					<cfif isDefined("arguments.publication_date")>
						<cfinvokeargument name="publication_date" value="#arguments.publication_date# #arguments.publication_hour#:#arguments.publication_minute#">
					</cfif>
					<cfinvokeargument name="publication_validated" value="#arguments.publication_validated#">
				</cfinvoke>

				<cfif associateResponse.result IS true>

					<cfif associateResponse.allAreas IS true>

						<cfif arrayLen(areas_ids) IS 1 AND listLen(files_ids) IS 1>
							<cfset response_message = "Archivo asociado al área.">
						<cfelse>
							<cfset response_message = "Archivo asociado a las áreas.">
						</cfif>

					<cfelse>

						<cfif arrayLen(areas_ids) IS 1 AND listLen(files_ids) IS 1>
							<cfset response_message = "El archivo ya estaba asociado al área.">

							<cfset response = {result=false, message=#response_message#}>
							<cfreturn response>
						<cfelse>
							<cfset response_message = "Archivo asociado a las áreas. En una o varias de las areas seleccionadas ya estaba asociado.">
						</cfif>

					</cfif>

				<cfelse>

					<cfset response_message = associateResponse.message>

					<cfif listLen(files_ids) IS 1>
						<cfset response = {result=false, message=response_message}>
						<cfreturn response>
					</cfif>

				</cfif>

				<cfif listLen(files_ids) GT 1>
					<cfif isDefined("associateResponse.file_name")>
						<cfset response_messages = response_messages&"<b>#associateResponse.file_name#</b>: #response_message#<br>">
					<cfelse>
						<cfset response_messages = response_messages&response_message&"<br>">
					</cfif>
				<cfelse>
					<cfset response_messages = response_message>
				</cfif>

			</cfloop>

			<cfset response = {result=true, message=#response_messages#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">

			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ---------------------------------- deleteFiles -------------------------------------- --->

	<cffunction name="deleteFiles" access="public" returntype="struct">
		<cfargument name="files_ids" type="string" required="true">
		<cfargument name="area_id" type="numeric" required="true">

		<cfset var method = "deleteFiles">

		<cfset var response = structNew()>

		<cfset var response_message = "">
		<cfset var response_messages = "">

		<cftry>

			<!--- getClient --->
			<cfinvoke component="#APPLICATION.htmlPath#/components/Client" method="getClient" returnvariable="clientQuery">
				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			</cfinvoke>

			<cfloop list="#arguments.files_ids#" index="file_id">

				<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="deleteFile" returnvariable="deleteFileResponse">
					<cfinvokeargument name="file_id" value="#file_id#"/>
					<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
					<cfinvokeargument name="moveToBin" value="#clientQuery.bin_enabled#"/>
				</cfinvoke>

				<cfif deleteFileResponse.result IS true>

					<cfset response_message = "Archivo eliminado.">

				<cfelse>

					<cfset response_message = deleteFileResponse.message>

				</cfif>

				<cfif listLen(files_ids) GT 1>

					<cfif isDefined("deleteFileResponse.file_name")>
						<cfset response_messages = response_messages&"<b>#deleteFileResponse.file_name#</b>: #response_message#<br>">
					<cfelse>
						<cfset response_messages = response_messages&response_message&"<br>">
					</cfif>

				<cfelse>
					<cfset response = {result=deleteFileResponse.result, message=#response_message#}>
					<cfreturn response>
				</cfif>

			</cfloop>

			<cfset response = {result=true, message=#response_messages#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">

			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ---------------------------------- dissociateFile -------------------------------------- --->

	<cffunction name="dissociateFile" returntype="void" access="remote">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="return_path" type="string" required="true">

		<cfset var method = "dissociateFile">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="dissociateFile" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
			</cfinvoke>

			<cfif response.result IS true>
				<cfset msg = "Archivo quitado del área.">
				<cfset msg = URLEncodedFormat(msg)>
				<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&msg=#msg#&res=1" addtoken="no">
			<cfelse>
				<cfset msg = response.message>
				<cfset msg = URLEncodedFormat(msg)>
				<cflocation url="#arguments.return_path#file.cfm?area=#arguments.area_id#&file=#arguments.file_id#&msg=#msg#&res=0" addtoken="no">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

	</cffunction>


	<!--- uploadFileRemote --->

	<cffunction name="uploadFileRemote" output="false" returntype="string" returnformat="plain" access="remote">
		<cfargument name="files" type="array" required="false">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="reviser_user" type="numeric" required="false">
		<cfargument name="approver_user" type="numeric" required="false">
		<cfargument name="version_index" type="string" required="false">
		<cfargument name="publication_scope_id" type="numeric" required="false">
		<cfargument name="public" type="boolean" required="false">
		<cfargument name="categories_ids" type="array" required="false">
		<cfargument name="no_notify" type="boolean" required="false" default="false">
		<cfargument name="group_versions" type="boolean" required="false" default="false">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="uploadNewFile" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>

			<cfif response.result IS true>
				<!---<cfset file_id = 1>--->

				<cfset file = response.file>

				<cfset response = { result=true,
				  files:
				    [
				      {
				        url: "",
				        thumbnail_url: "",
				        name: "#file.name#",
				        <!---type: "text/plain",--->
				        type: #fileGetMimeType(file.name, false)#,
				        size: #file.file_size#,
				        file_id = #response.file_id#,
				        fileTypeId = #file.file_type_id#
				        <!---delete_url: "#APPLICATION.htmlComponentsPath#/File.cfc?method=deleteFileRemote&file_id=#file_id#&area_id=#arguments.area_id#&return_path=#return_path#",
				        delete_type: "DELETE"--->
				      }
				    ]
				}>

			<cfelse><!--- Error --->

				<cfset response.files = [
				      {
				        name: "#arguments.name#",
				        error: "#response.message#",
				      }
				    ]>

			</cfif>


			<cfcatch>

				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">

				<cfset response = { result=false,
				  files:
				    [
				      {
				        name: "#arguments.name#",
				        error: "#cfcatch.message#",
				      }
				    ]
				}>

			</cfcatch>

		</cftry>

		<cfreturn serializeJSON(response)>

	</cffunction>


	<!--- ---------------------------------- createFile -------------------------------------- --->

	<cffunction name="createFile" access="public" returntype="struct">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="Filedata" type="string" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="areas_ids" type="string" required="false">
		<cfargument name="typology_id" type="string" required="false">
		<cfargument name="reviser_user" type="numeric" required="false">
		<cfargument name="approver_user" type="numeric" required="false">
		<cfargument name="publication_scope_id" type="numeric" required="false">
		<cfargument name="publication_date" type="string" required="false">
		<cfargument name="publication_hour" type="numeric" required="false">
		<cfargument name="publication_minute" type="numeric" required="false">
		<cfargument name="publication_validated" type="boolean" required="false">
		<cfargument name="version_index" type="string" required="false">
		<cfargument name="public" type="boolean" required="false">
		<cfargument name="categories_ids" type="array" required="false">
		<cfargument name="no_notify" type="boolean" required="false" default="false">

		<cfset var method = "createFile">

		<cfset var response = structNew()>

		<cfset var file_id = "">

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="uploadNewFile" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>

			<cfif response.result IS true>
				<cfset response.message = "Archivo añadido al área.">
			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">

			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ---------------------------------- updateFile -------------------------------------- --->

	<cffunction name="updateFile" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<!--- <cfargument name="area_id" type="numeric" required="true"> --->
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="typology_id" type="string" required="false">
		<cfargument name="reviser_user" type="numeric" required="false">
		<cfargument name="approver_user" type="numeric" required="false">
		<cfargument name="publication_scope_id" type="numeric" required="false">
		<cfargument name="categories_ids" type="array" required="false">
		<cfargument name="url_id" type="string" required="false">
		<cfargument name="no_notify" type="boolean" required="false" default="false">

		<cfset var method = "updateFile">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="updateFile" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>

			<cfif response.result IS true>
				<cfset response.message = "Datos modificados">
			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">

			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ---------------------------------- publishFileVersion -------------------------------------- --->

	<cffunction name="publishFileVersion" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="publication_area_id" type="numeric" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="typology_id" type="string" required="false">
		<cfargument name="publication_scope_id" type="numeric" required="false">
		<cfargument name="publication_date" type="string" required="false">
		<cfargument name="publication_hour" type="numeric" required="false">
		<cfargument name="publication_minute" type="numeric" required="false">
		<cfargument name="publication_validated" type="boolean" required="false">

		<cfset var method = "publishFileVersion">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="publishFileVersion" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>

			<cfif response.result IS true>
				<cfset response.message = "Archivo publicado">
			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">

			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ---------------------------------- updateFile -------------------------------------- --->

	<cffunction name="replaceFile" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="Filedata" type="string" required="true">
		<cfargument name="version_index" type="string" required="false">
		<cfargument name="unlock" type="boolean" required="false">
		<cfargument name="no_notify" type="boolean" required="false" default="false">

		<cfset var method = "replaceFile">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="replaceFile" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>

			<cfif response.result IS true>
				<cfif fileTypeId IS NOT 3>
					<cfset response.message = "Archivo reemplazado.">
				<cfelse>
					<cfset response.message = "Nueva versión guardada.">
				</cfif>
			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">

			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ---------------------------------- changeFilesUser -------------------------------------- --->

	<cffunction name="changeFilesUser" returntype="struct" access="public">
		<cfargument name="files_ids" type="string" required="true">
		<cfargument name="new_user_in_charge" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">

		<cfset var method = "changeFilesUser">

		<cfset var response = structNew()>

		<cfset var response_message = "">
		<cfset var response_messages = "">

		<cftry>

			<cfloop list="#arguments.files_ids#" index="file_id">

				<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="changeFileUser" returnvariable="changeFileUserResponse">
					<cfinvokeargument name="file_id" value="#file_id#">
					<cfinvokeargument name="new_user_in_charge" value="#arguments.new_user_in_charge#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>

				<cfif changeFileUserResponse.result IS true>

					<cfset response_message = "Propietario modificado.">

				<cfelse>

					<cfset response_message = changeFileUserResponse.message>

				</cfif>

				<cfif listLen(files_ids) GT 1>

					<cfif isDefined("changeFileUserResponse.file_name")>
						<cfset response_messages = response_messages&"<b>#changeFileUserResponse.file_name#</b>: #response_message#<br>">
					<cfelse>
						<cfset response_messages = response_messages&response_message&"<br>">
					</cfif>

				<cfelse>
					<cfset response = {result=changeFileUserResponse.result, message=#response_message#}>
					<cfreturn response>
				</cfif>

			</cfloop>

			<cfset response = {result=true, message=#response_messages#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">

			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ---------------------------------- changeFilesOwnerToArea -------------------------------------- --->

	<cffunction name="changeFilesOwnerToArea" returntype="struct" access="public">
		<cfargument name="files_ids" type="string" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="new_area_id" type="numeric" required="true">

		<cfset var method = "changeFilesOwnerToArea">

		<cfset var response = structNew()>

		<cfset var response_message = "">
		<cfset var response_messages = "">

		<cftry>

			<cfloop list="#arguments.files_ids#" index="file_id">

				<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="changeFileOwnerToArea" returnvariable="changeFileOwnerToAreaResponse">
					<cfinvokeargument name="file_id" value="#file_id#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
					<cfinvokeargument name="new_area_id" value="#arguments.new_area_id#">
				</cfinvoke>

				<cfif changeFileOwnerToAreaResponse.result IS true>

					<cfset response_message = "Convertido en archivo de área.">

				<cfelse>

					<cfset response_message = changeFileOwnerToAreaResponse.message>

				</cfif>

				<cfif listLen(files_ids) GT 1>

					<cfif isDefined("changeFileOwnerToAreaResponse.file_name")>
						<cfset response_messages = response_messages&"<b>#changeFileOwnerToAreaResponse.file_name#</b>: #response_message#<br>">
					<cfelse>
						<cfset response_messages = response_messages&response_message&"<br>">
					</cfif>

				<cfelse>
					<cfset response = {result=changeFileOwnerToAreaResponse.result, message=#response_message#}>
					<cfreturn response>
				</cfif>

			</cfloop>

			<cfset response = {result=true, message=#response_messages#}>

			<cfcatch>

				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">

			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ---------------------------------- changeFileArea -------------------------------------- --->

	<cffunction name="changeFileArea" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="new_area_id" type="numeric" required="true">

		<cfset var method = "changeFileArea">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="changeFileArea" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>

			<cfif response.result IS true>
				<cfset response.message = "Archivo cambiado de área.">
			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">

			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>



	<!--- ------------------------------ changeFilePublicationValidation ----------------------------------- --->

    <cffunction name="changeFilePublicationValidation" returntype="void" access="remote">
    	<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="validate" type="boolean" required="true">

		<cfargument name="return_path" type="string" required="yes">

		<cfset var method = "changeFilePublicationValidation">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="changeFilePublicationValidation" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="area_id" value="#arguments.area_id#"/>
				<cfinvokeargument name="validate" value="#arguments.validate#"/>
			</cfinvoke>

			<cfif response.result IS true>
				<cfif arguments.validate IS true>
					<cfset response.message = "Publicación aprobada">
				<cfelse>
					<cfset response.message = "Publicación invalidada">
				</cfif>
			</cfif>

			<cfset msg = URLEncodedFormat(response.message)>

			<cflocation url="#arguments.return_path#&res=#response.result#&msg=#msg#" addtoken="no">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

	</cffunction>



	<!--- ---------------------------------- requestRevision -------------------------------------- --->

	<cffunction name="requestRevision" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">

		<cfset var method = "requestRevision">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="requestRevision" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>

			<cfif response.result IS true>
				<cfset response.message = "Proceso de aprobación iniciado.">
			</cfif>

			<cfcatch>

				<cfinclude template="includes/errorHandlerNoRedirectStruct.cfm">

			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- lockFile --->

	<cffunction name="lockFile" returntype="void" access="remote">
		<cfargument name="file_id" type="string" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="lock" type="boolean" required="true">
		<cfargument name="return_path" type="string" required="true">

		<cfset var method = "lockFile">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="changeAreaFileLock" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfinvokeargument name="lock" value="#arguments.lock#"/>
			</cfinvoke>

			<cfif response.result IS true>
				<cfif arguments.lock IS true>
					<cfset msg = "Archivo bloqueado.">
				<cfelse>
					<cfset msg = "Archivo desbloqueado.">
				</cfif>
			<cfelse>
				<cfset msg = response.message>
			</cfif>

			<cfset msg = URLEncodedFormat(msg)>
			<!---<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">--->
			<cflocation url="#arguments.return_path##fileTypeName#.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

	</cffunction>


	<!--- cancelRevisionRequest --->

	<cffunction name="cancelRevisionRequest" returntype="void" access="remote">
		<cfargument name="file_id" type="string" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="return_path" type="string" required="true">

		<cfset var method = "cancelRevisionRequest">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="cancelRevisionRequest" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
			</cfinvoke>

			<cfif response.result IS true>
				<cfset msg = "Revisión cancelada.">
			<cfelse>
				<cfset msg = response.message>
			</cfif>

			<cfset msg = URLEncodedFormat(msg)>
			<!---<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">--->
			<cflocation url="#arguments.return_path##fileTypeName#.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

	</cffunction>



	<!--- validateFileVersion --->

	<cffunction name="validateFileVersion" returntype="void" access="remote">
		<cfargument name="file_id" type="string" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<!---<cfargument name="valid" type="boolean" required="true">--->
		<cfargument name="return_path" type="string" required="true">

		<cfset var method = "validateFileVersion">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="validateFileVersion" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfinvokeargument name="valid" value="true"/>
			</cfinvoke>

			<cfif response.result IS true>
				<!--- <cfif arguments.valid IS true> --->
					<cfset msg = "Versión validada.">
				<!---<cfelse>
					<cfset msg = "Versión rechazada.">
				</cfif>--->
			<cfelse>
				<cfset msg = response.message>
			</cfif>

			<cfset msg = URLEncodedFormat(msg)>
			<!---<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">--->
			<cflocation url="#arguments.return_path##fileTypeName#.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

	</cffunction>


	<!--- rejectRevisionFileVersion --->

	<cffunction name="rejectRevisionFileVersion" returntype="void" access="remote">
		<cfargument name="file_id" type="string" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="revision_result_reason" type="string" required="true">
		<cfargument name="return_path" type="string" required="true">

		<cfset var method = "rejectRevisionFileVersion">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="validateFileVersion" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfinvokeargument name="valid" value="false"/>
				<cfinvokeargument name="revision_result_reason" value="#arguments.revision_result_reason#"/>
			</cfinvoke>

			<cfif response.result IS true>
				<!--- <cfif arguments.valid IS true>
					<cfset msg = "Versión validada.">
				<cfelse>--->
					<cfset msg = "Versión rechazada.">
				<!---</cfif>--->
			<cfelse>
				<cfset msg = response.message>
			</cfif>

			<cfset msg = URLEncodedFormat(msg)>
			<!---<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">--->
			<cflocation url="#arguments.return_path##fileTypeName#.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

	</cffunction>



	<!--- approveFileVersion --->

	<cffunction name="approveFileVersion" returntype="void" access="remote">
		<cfargument name="file_id" type="string" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="approve" type="boolean" required="true">
		<cfargument name="return_path" type="string" required="true">

		<cfset var method = "approveFileVersion">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="approveFileVersion" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfinvokeargument name="approve" value="#arguments.approve#"/>
			</cfinvoke>

			<cfif response.result IS true>
				<cfif arguments.approve IS true>
					<cfset msg = "Versión aprobada.">
				<cfelse>
					<cfset msg = "Versión rechazada.">
				</cfif>
			<cfelse>
				<cfset msg = response.message>
			</cfif>

			<cfset msg = URLEncodedFormat(msg)>
			<!---<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">--->
			<cflocation url="#arguments.return_path##fileTypeName#.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

	</cffunction>


	<!--- rejectApproveFileVersion --->

	<cffunction name="rejectApproveFileVersion" returntype="void" access="remote">
		<cfargument name="file_id" type="string" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="approval_result_reason" type="string" required="true">
		<cfargument name="return_path" type="string" required="true">

		<cfset var method = "rejectApproveFileVersion">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="approveFileVersion" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfinvokeargument name="approve" value="false"/>
				<cfinvokeargument name="approval_result_reason" value="#arguments.approval_result_reason#"/>
			</cfinvoke>

			<cfif response.result IS true>
				<cfset msg = "Versión rechazada.">
			<cfelse>
				<cfset msg = response.message>
			</cfif>

			<cfset msg = URLEncodedFormat(msg)>
			<!---<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">--->
			<cflocation url="#arguments.return_path##fileTypeName#.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

	</cffunction>



	<!--- duplicateFileVersion --->

	<cffunction name="duplicateFileVersion" returntype="void" access="remote">
		<cfargument name="file_id" type="string" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="version_id" type="numeric" required="true">
		<cfargument name="return_path" type="string" required="true">

		<cfset var method = "duplicateFileVersion">

		<cfset var response = structNew()>

		<cftry>

			<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="duplicateFileVersion" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="fileTypeId" value="#arguments.fileTypeId#"/>
				<cfinvokeargument name="version_id" value="#arguments.version_id#"/>
			</cfinvoke>

			<cfif response.result IS true>
				<cfset msg = "Versión definida como versión vigente.">
			<cfelse>
				<cfset msg = response.message>
			</cfif>

			<cfset msg = URLEncodedFormat(msg)>
			<cflocation url="#arguments.return_path#file_versions.cfm?#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

	</cffunction>



	<!--- ---------------------------------- updateFile -------------------------------------- --->
	<!---Este método solo se usa desde Mis documentos y debe dejar de usarse en futuras versiones--->
	<!---<cffunction name="updateFile" returntype="void" access="remote">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="folder_id" type="numeric" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">

		<cfset var method = "updateFile">

		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">

		<cftry>

			<cfset response_page = "my_files_file.cfm?folder=#arguments.folder_id#&file=#arguments.file_id#">

			<cfsavecontent variable="request_parameters">
				<cfoutput>
					<file id="#arguments.file_id#">
						<name><![CDATA[#arguments.name#]]></name>
						<description><![CDATA[#arguments.description#]]></description>
					</file>
				</cfoutput>
			</cfsavecontent>

			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>

			<cfset message = "Archivo modificado.">
			<cfset message = URLEncodedFormat(message)>

            <cflocation url="#APPLICATION.htmlPath#/#response_page#&msg=#message#&res=1" addtoken="no">

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>

		</cftry>

		<cfreturn xmlResponse>

	</cffunction>--->



	<!--- ---------------------------------- deleteFile -------------------------------------- --->

	<!---Este método solo se usa desde Mis documentos y debe dejar de usarse en futuras versiones--->

	<cffunction name="deleteFile" returntype="void" access="remote">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="folder_id" type="numeric" required="true">

		<cfset var method = "deleteFile">

		<cfset var response = structNew()>

		<cftry>

			<cfset response_page = "my_files.cfm?folder=#arguments.folder_id#">

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="deleteFile" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
			</cfinvoke>

			<cfif response.result IS true>
				<cfset msg = "Archivo eliminado.">
			<cfelse>
				<cfset msg = response.message>
			</cfif>

			<cfset msg = URLEncodedFormat(msg)>
      <cflocation url="#APPLICATION.htmlPath#/#response_page#&msg=#msg#&res=#response.result#" addtoken="no">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

	</cffunction>



	<!--- ---------------------------------- deleteFileRemote -------------------------------------- --->

	<cffunction name="deleteFileRemote" returntype="void" access="remote">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="return_path" type="string" required="true">

		<cfset var method = "deleteFileRemote">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="deleteFile" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
			</cfinvoke>

			<cfif response.result IS true>
				<cfset msg = "Archivo eliminado.">
			<cfelse>
				<cfset msg = response.message>
			</cfif>

			<cfset msg = URLEncodedFormat(msg)>
			<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&file=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

	</cffunction>


	<!--- ---------------------------------- deleteFileVersionRemote -------------------------------------- --->

	<cffunction name="deleteFileVersionRemote" returntype="void" access="remote">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="version_id" type="numeric" required="true">
		<cfargument name="return_path" type="string" required="true">

		<cfset var method = "deleteFileVersionRemote">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="deleteFileVersion" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="version_id" value="#arguments.version_id#"/>
			</cfinvoke>

			<cfif response.result IS true>
				<cfset msg = "Versión de archivo eliminada.">
			<cfelse>
				<cfset msg = response.message>
			</cfif>

			<cfset msg = URLEncodedFormat(msg)>
			<cflocation url="#arguments.return_path#file_versions.cfm?file=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

	</cffunction>



	<!--- ----------------------- GET ALL AREAS FILES -------------------------------- --->

	<cffunction name="getAllAreasFiles" returntype="struct" output="false" access="public">
		<cfargument name="search_text" type="string" required="no">
		<cfargument name="user_in_charge" type="numeric" required="no">
		<cfargument name="categories_ids" type="array" required="false">
		<cfargument name="limit" type="numeric" required="no">
		<cfargument name="from_date" type="string" required="no">
		<cfargument name="end_date" type="string" required="no">

		<cfset var method = "getAllAreasFiles">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="getAllAreasFiles" argumentcollection="#arguments#" returnvariable="response">
				<cfinvokeargument name="with_area" value="true">
				<!---<cfif isDefined("arguments.search_text")>
				<cfinvokeargument name="search_text" value="#arguments.search_text#">
				</cfif>
				<cfif isDefined("arguments.user_in_charge")>
				<cfinvokeargument name="user_in_charge" value="#arguments.user_in_charge#">
				</cfif>
				<cfif isDefined("arguments.limit")>
				<cfinvokeargument name="limit" value="#arguments.limit#">
				</cfif>
				<cfif isDefined("arguments.from_date")>
				<cfinvokeargument name="from_date" value="#arguments.from_date#">
				</cfif>
				<cfif isDefined("arguments.end_date")>
				<cfinvokeargument name="end_date" value="#arguments.end_date#">
				</cfif>--->
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


	<!--- ----------------------- outputFileSmall -------------------------------- --->

	<cffunction name="outputFileSmall" returntype="void" output="true" access="public">
		<cfargument name="fileQuery" type="query" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="alertMessage" type="string" required="false">
		<cfargument name="alertClass" type="string" required="false" default="alert alert-warning">

		<cfset var method = "outputFileSmall">

		<div class="well well-sm">

			<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getFileIcon" returnvariable="file_icon">
				<cfinvokeargument name="file_name" value="#fileQuery.file_name#"/>
			</cfinvoke>

			<div>

					<a href="#APPLICATION.htmlPath#/file_download.cfm?id=#fileQuery.id#&area=#arguments.area_id#" target="_blank" onclick="return downloadFileLinked(this,event)" title="Descargar">
						<i class="#file_icon#" style="font-size:24px"></i>
					</a>

					<strong>#fileQuery.name#</strong><br>

					<div>
						<span lang="es">Propietario</span>:
						<strong>#fileQuery.user_full_name#</strong>
					</div>

					<cfif APPLICATION.publicationScope IS true AND isNumeric(fileQuery.publication_scope_id)>
						<div>
							<span lang="es">Ámbito de publicación definido para el archivo:</span> <strong>#fileQuery.publication_scope_name#</strong>
						</div>
					</cfif>

					<cfif isDefined("arguments.alertMessage") AND len(arguments.alertMessage)>
						<div class="#arguments.alertClass#" role="alert" style="margin-bottom:0" lang="es">
							#arguments.alertMessage#
						</div>
					</cfif>

			</div>

		</div>

	</cffunction>


	<!--- ----------------------- outputFileVersionStatus -------------------------------- --->

	<cffunction name="outputFileVersionStatus" returntype="void" output="true" access="public">
		<cfargument name="version" type="query" required="true">

		<cfset var method = "outputFileVersionStatus">

		<cfif version.revised IS true>

			<div>
			<cfif version.revision_result IS true>

				<cfif version.approved IS true>

					<div class="label label-success">Versión de archivo aprobada</div>

					<cfif isNumeric(version.publication_file_id)>
						<div class="label label-info">Versión de archivo publicada</div>
					</cfif>

				<cfelseif version.approved IS false>

					<div class="label label-warning">Versión de archivo rechazada en la aprobación</div>

					<br><span class="text-warning" lang="es">Motivo de rechazo en aprobación:</span><br/>
					<i class="text_file_page">#version.approval_result_reason#</i>

				<cfelse>

					<div class="label label-warning">Versión de archivo revisada pendiente de aprobación</div>

				</cfif>

			<cfelse>

				<div class="label label-warning">Versión de archivo rechazada en la revisión</div>

				<br><span class="text-warning" lang="es">Motivo de rechazo en revisión:</span><br/>
				<i class="text_file_page">#version.revision_result_reason#</i>

			</cfif>

			</div>

		</cfif>

	</cffunction>



	<!--- ----------------------- getFileIconsTypes -------------------------------- --->

	<cffunction name="getFileIconsTypes" returntype="string" output="false" access="public">

		<cfreturn "pdf,rtf,txt,doc,docx,png,jpg,jpeg,gif,rar,zip,xls,xlsm,xlsx,ppt,pptx,pps,ppsx,odt">

	</cffunction>



	<!--- ----------------------- getFileIcon -------------------------------- --->

	<cffunction name="getFileIcon" returntype="string" output="false" access="public">
		<cfargument name="file_name" type="string" required="true">

		<cfset var icon = "file">
		<!---<cfset var color = "#82D0CA">--->

		<cfset var fileType = lCase(listLast(arguments.file_name, "."))>

		<cfscript>

			switch(fileType){

				case "xls":
				case "xlsx":
				case "xlsm":
				case "csv":
					icon = "file-excel-o";
					<!---color = "#33975B";--->
				break;

				case "pdf":
					icon = "file-pdf-o";
					<!--- color = "#E4514B"; --->
				break;

				case "mp3":
				case "waw":
					icon = "file-sound-o";
					<!--- color = "#254E65"; --->
				break;

				case "doc":
				case "docx":
				case "odt":
					icon = "file-word-o";
					<!--- color = "#019ED3"; --->
				break;

				case "zip":
				case "rar":
					icon = "file-archive-o";
					<!--- color = "#777777"; --->
				break;

				case "mp4":
				case "flv":
					icon = "file-movie-o";
					<!--- color = "#254E65"; --->
				break;

				case "js":
				case "cfm":
				case "css":
				case "html":
				case "xml":
					icon = "file-code-o";
					<!--- color = "#222222"; --->
				break;

				case "ppt":
				case "pptx":
				case "pps":
				case "ppsx":
					icon = "file-powerpoint-o";
					<!--- color = "#D24625"; --->
				break;

				case "jpg":
				case "jpeg":
				case "png":
				case "gif":
				case "bmp":
					icon = "file-image-o";
					<!--- color = "#E6C81E"; --->
				break;

				case "txt":
					icon = "file-text-o";
				break;

				case "tsv":
				case "fasta":
					icon = "file-text";
				break;

			}

		</cfscript>

		<cfreturn "fa fa-"&icon>

	</cffunction>



	<!--- ----------------------- GET FILES DOWNLOADS -------------------------------- --->

	<cffunction name="getFilesDownloads" returntype="struct" access="public">
		<cfargument name="parse_dates" type="boolean" required="false" default="false">
		<cfargument name="from_date" type="string" required="false">
		<cfargument name="end_date" type="string" required="false">
		<cfargument name="user_in_charge" type="numeric" required="false">
		<cfargument name="download_user_id" type="numeric" required="false">
		<cfargument name="area_id" type="numeric" required="false">
		<cfargument name="include_subareas" type="boolean" required="false">
		<cfargument name="include_without_downloads" type="boolean" required="false">

		<cfset var method = "getFilesDownloads">

		<cfset var response = structNew()>

		<cftry>

			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="getFilesDownloads" returnvariable="response">
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
			</cfinvoke>

			<cfinclude template="includes/responseHandlerStruct.cfm">

			<cfcatch>
				<cfinclude template="includes/errorHandlerStruct.cfm">
			</cfcatch>

		</cftry>

		<cfreturn response>

	</cffunction>


</cfcomponent>
