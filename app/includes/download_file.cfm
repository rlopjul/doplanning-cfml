<!---Copyright Era7 Information Technologies 2007-2008

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
	
--->
<cfset component = "downloadFile">
<cfset method = "downloadFile">

<cfinclude template="#APPLICATION.componentsPath#/includes/sessionVars.cfm">

<!---checkParameters--->
<cfif isDefined("URL.id")>
	<cfset file_id = URL.id>
<cfelseif isDefined("URL.fileDownload")>
	<cfset file_id = URL.fileDownload>
<cfelse><!---No value given for one or more required parameters--->
	<cfset error_code = 610>

	<cfthrow errorcode="#error_code#">
</cfif>

<cfif isDefined("URL.message") AND isNumeric(URL.message)>
	<cfset item_id = URL.message>
	<cfset itemTypeId = 1>
<cfelseif isDefined("URL.entry") AND isNumeric(URL.entry)>
	<cfset item_id = URL.entry>
	<cfset itemTypeId = 2>
<cfelseif isDefined("URL.link") AND isNumeric(URL.link)>
	<cfset item_id = URL.link>
	<cfset itemTypeId = 3>
<cfelseif isDefined("URL.news") AND isNumeric(URL.news)>
	<cfset item_id = URL.news>
	<cfset itemTypeId = 4>
<cfelseif isDefined("URL.event") AND isNumeric(URL.event)>
	<cfset item_id = URL.event>
	<cfset itemTypeId = 5>
<cfelseif isDefined("URL.task") AND isNumeric(URL.task)>
	<cfset item_id = URL.task>
	<cfset itemTypeId = 6>
<cfelseif isDefined("URL.consultation") AND isNumeric(URL.consultation)>
	<cfset item_id = URL.consultation>
	<cfset itemTypeId = 7>
</cfif>
	

<!---Al llamar a este método se comprueba si el usuario tiene acceso al documento--->
<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="getFile" returnvariable="objectFile">				
	<cfinvokeargument name="get_file_id" value="#file_id#">
	<cfif isDefined("item_id") AND isDefined("itemTypeId")>
		<cfinvokeargument name="item_id" value="#item_id#">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	</cfif>
	<cfif isDefined("URL.fileTypeId")>
		<cfinvokeargument name="fileTypeId" value="#URL.fileTypeId#"/>
	</cfif>
	<cfinvokeargument name="return_type" value="query">
</cfinvoke>		

<cfset fileTypeId = objectFile.file_type_id>
<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

<cfset files_directory = fileTypeNameP>


<cfinclude template="get_file.cfm">