<!---Required var: 
	page_type
	return_path (solo para Asociar archivo a un área)
	
	
	page_types:
		1 Mis documentos
		2 Asociar archivo a un área
	
--->

<cfset current_page = CGI.SCRIPT_NAME>

<cfswitch expression="#page_type#">
	<cfcase value="1">
		<cfset current_page = current_page&"?my_files=">
	</cfcase>
	<cfcase value="2">
		<cfset current_page = current_page&"?area=#area_id#">
	</cfcase>
</cfswitch>
	
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Folder" method="getFolderContent" returnvariable="xmlResponse">
	<cfinvokeargument name="folder_id" value="#folder_id#">
</cfinvoke>

<!---<cfoutput>
<textarea style="width:100%; height:100px;">
#xmlResponse#
</textarea>
</cfoutput>--->
<cfxml variable="xmlFolder">
	<cfoutput>
	#xmlResponse.folder#
	</cfoutput>
</cfxml>

<cfset parent_id = xmlFolder.folder.xmlAttributes.parent_id>
<cfset return_page = "#current_page#&folder=#parent_id#"><!---Aquí obtiene el folder padre--->

<cfset numElements = ArrayLen(xmlFolder.folder.XmlChildren)>

<!---<cfset folder_name = xmlAreas.area.xmlAttributes.name>
<cfset area_allowed = xmlAreas.area.xmlAttributes.allowed>
<cfset numAreas = ArrayLen(xmlAreas.area.XmlChildren)>--->

<cfoutput>
<div class="div_element_folder"><div style="float:left;"><img src="#APPLICATION.htmlPath#/assets/icons/folder.png" /></div><span class="text_file_name">#xmlFolder.folder.xmlAttributes.name#</span></div>
<div style="padding-left:25px; background-color:##f8f8f8; padding-top:10px;" >
<cfloop index="xmlIndex" from="1" to="#numElements#" step="1">
	
	<cfxml variable="xmlElement">
		#xmlFolder.folder.xmlChildren[xmlIndex]#
	</cfxml>

	<cfif isDefined("xmlElement.folder")>
	<div class="div_element_folder"><div style="float:left; width:32px;"><a class="text_file_name" href="#current_page#&folder=#xmlElement.folder.xmlAttributes.id#"><img src="#APPLICATION.htmlPath#/assets/icons/folder.png" /></a></div><a class="text_file_name" href="#current_page#&folder=#xmlElement.folder.xmlAttributes.id#">#xmlElement.folder.xmlAttributes.name#</a></div>
	<cfelseif isDefined("xmlElement.file")>
		
		<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="objectFile" returnvariable="objectFile">
				<cfinvokeargument name="xml" value="#xmlElement.file#">
				<cfinvokeargument name="tree_mode" value="true">
				<cfinvokeargument name="return_type" value="object">
		</cfinvoke>
		
		<cfinclude template="#APPLICATION.htmlPath#/includes/element_file.cfm">
		<div class="div_separator"><!-- --></div>
	</cfif>

</cfloop>
</div>
</cfoutput>

<cfif NOT isDefined("URL.folder") OR NOT isValid("integer",parent_id)>
	<cfif page_type IS 1>
		<cfset return_page = "index.cfm">
	<cfelse>
		<cfset return_page = "files.cfm?area=#area_id#">
	</cfif>
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="returnElement">
		<cfinvokeargument name="return_page" value="#return_page#">
	</cfinvoke>
<cfelse>
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="goUpElement">
		<cfinvokeargument name="return_page" value="#return_page#">
	</cfinvoke>
</cfif>