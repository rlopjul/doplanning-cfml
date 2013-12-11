<!--- Copyright Era7 Information Technologies 2007-2013 --->

<cfset component = "downloadFile">
<cfset method = "downloadFileVersion">

<cfinclude template="#APPLICATION.componentsPath#/includes/sessionVars.cfm">

<!---checkParameters--->
<cfif isDefined("URL.id")>
	<cfset version_id = URL.id>
<!---<cfelseif isDefined("URL.fileDownload")>
	<cfset version_id = URL.fileDownload>--->
<cfelse><!---No value given for one or more required parameters--->
	<cfset error_code = 610>

	<cfthrow errorcode="#error_code#">
</cfif>

<cfset fileTypeId = 3>

<!---Al llamar a este método se comprueba si el usuario tiene acceso al documento--->
<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="getFileVersion" returnvariable="fileVersionResult">
	<cfinvokeargument name="version_id" value="#version_id#">
	<cfinvokeargument name="fileTypeId" value="#fileTypeId#"/>
</cfinvoke>		

<cfset objectFile = fileVersionResult.version>

<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">

<cfset files_directory = fileTypeDirectory>


<cfinclude template="get_file.cfm">