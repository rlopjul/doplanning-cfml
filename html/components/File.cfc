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
			</cfinvoke>
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn objectFile>
		
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
	
	
	<!--- ---------------------------------- convertFile -------------------------------------- --->
	
	<cffunction name="convertFile" returntype="xml" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="file_type" type="string" required="true">
		
		<cfset var method = "convertFile">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
		
		<cftry>
			
			<cfsavecontent variable="request_parameters">
				<cfoutput>
					<file id="#arguments.file_id#" file_type="#arguments.file_type#"/>
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
	
	
	<!--- ---------------------------------- associateFile -------------------------------------- --->
	
	<cffunction name="associateFile" returntype="void" access="remote">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
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
	
	
	<!--- ---------------------------------- associateFileToAreas -------------------------------------- --->
	
	<cffunction name="associateFileToAreas" access="public" returntype="struct">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="areas_ids" type="array" required="true">
		
		<cfset var method = "associateFileToAreas">
		
		<cfset var response = structNew()>

		<cftry>
			
			<!---<cfsavecontent variable="request_parameters">
				<cfoutput>
					<file id="#arguments.file_id#"/>
					<areas>
					<cfloop array="#arguments.areas_ids#" index="area_id">
						<area id="#area_id#"/>
					</cfloop>
					</areas>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>
			
			<cfxml variable="xmlAreas">
				<cfoutput>
					#xmlResponse.response.result.areas#
				</cfoutput>
			</cfxml>--->
			
			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="associateFileToAreas" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="areas_ids" value="#arrayToList(arguments.areas_ids)#"/>
			</cfinvoke>

			<cfif response.result IS true>

				<cfif response.allAreas IS true>
					
					<cfif arrayLen(areas_ids) IS 1>
						<cfset response_message = "Archivo asociado al área.">
					<cfelse>
						<cfset response_message = "Archivo asociado a las áreas.">
					</cfif>

				<cfelse>

					<cfif arrayLen(areas_ids) IS 1>
						<cfset response_message = "El archivo ya estaba asociado al área.">

						<cfset response = {result=false, message=#response_message#}>	
						<cfreturn response>
					<cfelse>
						<cfset response_message = "Archivo asociado a las áreas. En una o varias de las areas seleccionadas ya estaba asociado.">
					</cfif>

				</cfif>

				<cfset response = {result=true, message=#response_message#}>	

			</cfif>			
			
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
				<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&file=#arguments.file_id#&msg=#msg#&res=0" addtoken="no">
			</cfif>

			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>


	<!--- ---------------------------------- createFile -------------------------------------- --->
	
	<cffunction name="createFile" access="public" returntype="struct">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="Filedata" type="string" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="typology_id" type="string" required="false">
		
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
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="typology_id" type="string" required="false">
		<cfargument name="reviser_user" type="numeric" required="false">
		<cfargument name="approver_user" type="numeric" required="false">
		
		<cfset var method = "updateFile">
		
		<cfset var response = structNew()>
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="updateFile" argumentcollection="#arguments#" returnvariable="response">
				<!---<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="name" value="#arguments.name#"/>
				<cfinvokeargument name="description" value="#arguments.description#"/>--->
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


	<!--- ---------------------------------- updateFile -------------------------------------- --->
	
	<cffunction name="replaceFile" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="Filedata" type="string" required="true">
		<cfargument name="unlock" type="boolean" required="false">
		
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


	<!--- ---------------------------------- changeFileUser -------------------------------------- --->
	
	<cffunction name="changeFileUser" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="new_user_in_charge" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		
		<cfset var method = "changeFileUser">
		
		<cfset var response = structNew()>
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="changeFileUser" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Propietario modificado">
			</cfif>

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
				<cfset response.message = "Archivo cambiado de área">
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
		
		<cfset var method = "deleteItem">

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
			<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">

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
	
	
	
	<!--- ----------------------- GET ALL AREAS FILES -------------------------------- --->
	
	<cffunction name="getAllAreasFiles" returntype="struct" output="false" access="public">
		<cfargument name="search_text" type="string" required="no">
		<cfargument name="user_in_charge" type="numeric" required="no">
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
	
	
</cfcomponent>