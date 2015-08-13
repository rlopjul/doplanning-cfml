<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfset component = "downloadFile">
<cfset method = "downloadFile">

<cfinclude template="#APPLICATION.componentsPath#/includes/sessionVars.cfm">

<!---checkParameters--->
<cfif isDefined("URL.id")>
	<cfset file_id = URL.id>
<cfelseif isDefined("URL.file")>
	<cfset file_id = URL.file>
<cfelseif isDefined("URL.fileDownload")><!--- Esta opcion ya no se usa pero se mantiene para retrocompatibilidad --->
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
<cfelseif isDefined("URL.pubmed") AND isNumeric(URL.pubmed)>
	<cfset item_id = URL.pubmed>
	<cfset itemTypeId = 8>
<cfelseif isDefined("URL.image") AND isNumeric(URL.image)>
	<cfset item_id = URL.image>
	<cfset itemTypeId = 9>
</cfif>

<cfif isDefined("URL.area") AND isNumeric(URL.area)>
	<cfset area_id = URL.area>	
</cfif>
	

<!---Al llamar a este método se comprueba si el usuario tiene acceso al documento--->
<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="getFile" returnvariable="objectFile">				
	<cfinvokeargument name="get_file_id" value="#file_id#">
	<cfif isDefined("area_id")>
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfif>
	<cfif isDefined("item_id") AND isDefined("itemTypeId")>
		<cfinvokeargument name="item_id" value="#item_id#">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	</cfif>
	<cfif isDefined("URL.fileTypeId")>
		<cfinvokeargument name="fileTypeId" value="#URL.fileTypeId#"/>
	</cfif>
	<cfif isDefined("URL.bin") AND URL.bin IS true>
		<cfinvokeargument name="status" value="deleted"/>
	</cfif>
	<cfinvokeargument name="return_type" value="query">
</cfinvoke>		

<cfif isDefined("APPLICATION.moduleAntiVirus") AND APPLICATION.moduleAntiVirus IS true AND objectFile.anti_virus_check IS 0>

	<b>Archivo pendiente de analizar por el sistema Anti Virus, intente descargarlo de nuevo pasados unos minutos.</b>

<cfelseif isDefined("URL.bin") AND URL.bin IS true AND objectFile.user_in_charge NEQ user_id AND user_id NEQ SESSION.client_administrator>

	<b>Sin permiso de acceso.</b>

<cfelse>

	<cfset fileTypeId = objectFile.file_type_id>
	<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

	<cfset files_directory = fileTypeDirectory>


	<cfinclude template="get_file.cfm">
	
</cfif>

