<!---Copyright Era7 Information Technologies 2007-2012

	Date of file creation: 15-05-2012
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 21-05-2012
	
--->
<cfcomponent output="false">

	<cfset component = "AreaItemFile">
	
	
	<cffunction name="uploadItemFile" access="public" returntype="void">
		<cfargument name="item_id" type="numeric" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="itemTypeName" type="string" required="yes">
		<cfargument name="file_type" type="string" required="yes">
		<cfargument name="file_id" type="numeric" required="yes">
		<cfargument name="file_physical_name" type="string" required="yes">
		<cfargument name="Filedata" type="string" required="yes">		
						
		<!---<cfset FORM.user_id = SESSION.user_id>
		<cfset FORM.client_abb = SESSION.client_abb>
		<cfset FORM.language = SESSION.user_language>
		<cfset FORM.session_id = SESSION.SessionID>
		<cfset FORM.type = arguments.file_type>
		<cfset FORM.file = '<file id="#arguments.file_id#" physical_name="#arguments.file_physical_name#"/>'>
		<cfset FORM.itemTypeId = arguments.itemTypeId>
		<cfset FORM["#arguments.itemTypeName#"] = '<#arguments.itemTypeName# id="#arguments.item_id#"/>'>
		<cfinclude template='#APPLICATION.resourcesPath#/uploadFiles/uploadFile.cfm'>--->
		
		<!---<cfxml variable="xmlFile">
			<cfoutput>
			<file id="#arguments.file_id#" physical_name="#arguments.file_physical_name#"/>
			</cfoutput>
		</cfxml>--->	
		
		<cfxml variable="xmlItem">
			<cfoutput>
			<#arguments.itemTypeName# id="#arguments.item_id#"/>
			</cfoutput>
		</cfxml>
		
		<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemFile" method="uploadItemFile" returnvariable="objectFile">
			<cfinvokeargument name="type" value="#arguments.file_type#">
			<cfinvokeargument name="user_id" value="#SESSION.user_id#">
			<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			<cfinvokeargument name="user_language" value="#SESSION.user_language#">
			<!---<cfinvokeargument name="xmlFile" value="#xmlFile#">--->
			<cfinvokeargument name="file_id" value="#arguments.file_id#">
			<cfinvokeargument name="file_physical_name" value="#arguments.file_physical_name#">
			<cfinvokeargument name="Filedata" value="#arguments.Filedata#">
			<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
			<cfinvokeargument name="xmlItem" value="#xmlItem#">
		</cfinvoke>		
		
		<!---<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="xmlFile" returnvariable="xmlResponseContent">
				<cfinvokeargument name="objectFile" value="#objectFile#">
		</cfinvoke>--->
		
		
		<!---<cfinvoke component="Request" method="doRequest" returnvariable="xmlGetFileResponse">
			<cfinvokeargument name="request_component" value="#itemTypeNameU#Manager">
			<cfinvokeargument name="request_method" value="get#itemTypeNameU#FileStatus">
			<cfinvokeargument name="request_parameters" value='#FORM.file#'>
		</cfinvoke>
		
		<cfreturn xmlGetFileResponse>--->
		
	</cffunction>
	
</cfcomponent>