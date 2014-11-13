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
	
	
	<!--- ---------------------------------- associateFileToAreas -------------------------------------- --->
	
	<cffunction name="associateFileToAreas" access="public" returntype="struct">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="areas_ids" type="array" required="true">

		<cfargument name="publication_date" type="string" required="false">
		<cfargument name="publication_hour" type="numeric" required="false">
		<cfargument name="publication_minute" type="numeric" required="false">
		<cfargument name="publication_validated" type="boolean" required="false">
		
		<cfset var method = "associateFileToAreas">
		
		<cfset var response = structNew()>

		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="associateFileToAreas" returnvariable="response">
				<cfinvokeargument name="file_id" value="#arguments.file_id#"/>
				<cfinvokeargument name="areas_ids" value="#arrayToList(arguments.areas_ids)#"/>

				<cfif isDefined("arguments.publication_date")>
					<cfinvokeargument name="publication_date" value="#arguments.publication_date# #arguments.publication_hour#:#arguments.publication_minute#">
				</cfif>
				<cfinvokeargument name="publication_validated" value="#arguments.publication_validated#">
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
		<cfargument name="reviser_user" type="numeric" required="false">
		<cfargument name="approver_user" type="numeric" required="false">
		<cfargument name="publication_scope_id" type="numeric" required="false">
		<cfargument name="publication_date" type="string" required="false">
		<cfargument name="publication_hour" type="numeric" required="false">
		<cfargument name="publication_minute" type="numeric" required="false">
		<cfargument name="publication_validated" type="boolean" required="false">
		
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


	<!--- ---------------------------------- changeFileOwnerToArea -------------------------------------- --->
	
	<cffunction name="changeFileOwnerToArea" returntype="struct" access="public">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="new_area_id" type="numeric" required="true">
		
		<cfset var method = "changeFileOwnerToArea">
		
		<cfset var response = structNew()>
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="changeFileOwnerToArea" argumentcollection="#arguments#" returnvariable="response">
			</cfinvoke>
			
			<cfif response.result IS true>
				<cfset response.message = "Propiedad del archivo cambiada">
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
			<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">

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
			<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">

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
			<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">

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
			<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">

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
			<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">

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
			<cflocation url="#arguments.return_path#area_items.cfm?area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#&res=#response.result#&msg=#msg#" addtoken="no">

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
	
	
</cfcomponent>