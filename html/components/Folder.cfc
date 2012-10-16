<!---Copyright Era7 Information Technologies 2007-2012

	Date of file creation: 04-11-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 20-06-2012
	
--->
<cfcomponent output="false">

	<cfset component = "Folder">
	<cfset request_component = "FolderManager">
	
	
	<!--- ---------------------------- getUserRootFolderId ---------------------------------- --->
	
	<cffunction name="getUserRootFolderId" returntype="numeric" access="public">
	
		<cfset var method = "getUserRootFolderId">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
		
		<cfset var root_folder_id = "">
		
		<cftry>
			
						
			<cfinvoke component="#APPLICATION.componentsPath#/#request_component#" method="#method#" returnvariable="root_folder_id">				
			</cfinvoke>		
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn root_folder_id>
		
	</cffunction>
	
	
	
	<!--- ---------------------------- getFolderContent ---------------------------------- --->
	
	<cffunction name="getFolderContent" returntype="xml" access="public">
		<cfargument name="folder_id" type="numeric" required="true"> 
	
		<cfset var method = "getFolderContent">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
		
		<cftry>
			
			
			<cfinvoke component="#APPLICATION.componentsPath#/#request_component#" method="#method#" returnvariable="response">				
				<cfinvokeargument name="folder_id" value="#arguments.folder_id#">
				<cfinvokeargument name="withSubSubFolders" value="false">
				<cfinvokeargument name="withSubFoldersFiles" value="false">
			</cfinvoke>	
			
			<cfxml variable="xmlResponse">
				<cfoutput>
				#response#
				</cfoutput>
			</cfxml>			
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	
	<!--- ---------------------------- getFolder ---------------------------------- --->
	
	<cffunction name="getFolder" returntype="struct" access="public">
		<cfargument name="folder_id" type="numeric" required="true"> 
	
		<cfset var method = "getFolder">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/#request_component#" method="#method#" returnvariable="objectFolder">				
				<cfinvokeargument name="get_folder_id" value="#arguments.folder_id#">
				<cfinvokeargument name="return_type" value="object">
			</cfinvoke>			
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn objectFolder>
		
	</cffunction>
	
	
	
	<!--- ---------------------------- createFolder ---------------------------------- --->
	
	<cffunction name="createFolder" returntype="void" access="remote">
		<cfargument name="parent_id" type="numeric" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
	
		<cfset var method = "createFolder">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
		
		<cfset var response_page = "my_files.cfm">
		<cfset var fail_page = "folder_new.cfm">
		
		<cftry>
			
			<cfif len(arguments.name) IS 0>
			
				<cfset name_enc = URLEncodedFormat(arguments.name)>
				<cfset description_enc = URLEncodedFormat(arguments.description)>
				
				<cfset message = "Debe introducir un nombre para el directorio.">
				<cfset message = URLEncodedFormat(message)>
				<cflocation url="#APPLICATION.htmlPath#/#fail_page#?message=#message#&parent=#arguments.parent_id#&name=#name_enc#&description=#description_enc#" addtoken="no">
			
			</cfif>	
			
			<cfsavecontent variable="request_parameters">
				<cfoutput>
					<folder parent_id="#arguments.parent_id#">
						<name><![CDATA[#arguments.name#]]></name>	
						<description><![CDATA[#arguments.description#]]></description>	
					</folder>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>			
			
			<cfset message = 'Carpeta "#arguments.name#" creada.'>
			<cfset message = URLEncodedFormat(message)>
            
            <cflocation url="#APPLICATION.htmlPath#/#response_page#?folder=#arguments.parent_id#&message=#message#" addtoken="no">
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
	
	
	<!--- ---------------------------- createFolder ---------------------------------- --->
	
	<cffunction name="updateFolder" returntype="struct" access="public">
		<cfargument name="folder_id" type="numeric" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
	
		<cfset var method = "updateFolder">
		
		<cfset var response_message = "">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
		
		<!---<cfset var response_page = "my_files.cfm">
		<cfset var fail_page = "folder_new.cfm">--->
		
		<cftry>
			
			<cfif len(arguments.name) IS 0>
			
				<cfset response_message = "Debe introducir un nombre para el directorio.">
				
				<cfset response = {result="false", message=#response_message#}>
				<cfreturn response>
			
			</cfif>	
			
			<cfsavecontent variable="request_parameters">
				<cfoutput>
					<folder id="#arguments.folder_id#">
						<name><![CDATA[#arguments.name#]]></name>	
						<description><![CDATA[#arguments.description#]]></description>	
					</folder>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>			
			
			<cfset response_message = 'Carpeta "#arguments.name#" modificada.'>
            
            <cfset response = {result="true", message=#response_message#}>
			
			<cfcatch>
				<!---<cfinclude template="includes/errorHandler.cfm">--->
				
				<cfset response_message = "Ha ocurrido un error al modificar la carpeta: "&cfcatch.Message>
				
				<cfset response = {result="false", message=#response_message#}>
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>
	
	
</cfcomponent>