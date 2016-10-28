<!---Copyright Era7 Information Technologies 2007-2016

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena

--->
<cfset component = "downloadFileConverted">
<cfset method = "downloadFileConverted">

<cfinclude template="#APPLICATION.componentsPath#/includes/sessionVars.cfm">

<!---checkParameters--->
<cfif NOT isDefined("URL.file") OR NOT isDefined("URL.file_type")><!---No value given for one or more required parameters--->
	<cfset error_code = 610>

	<cfthrow errorcode="#error_code#">
</cfif>

<cfinvoke component="#APPLICATION.componentsPath#/FileManager" method="getFile" returnvariable="objectFile">
	<cfinvokeargument name="get_file_id" value="#URL.file#">

	<cfinvokeargument name="return_type" value="query">
</cfinvoke>

<cfif URL.file_type NEQ ".html">

	<cfset objectFile.file_type = URL.file_type>
	<cfset objectFile.file_name = objectFile.file_name&URL.file_type>
	<cfset objectFile.physical_name = objectFile.physical_name&URL.file_type>

	<cfset fileTypeId = objectFile.file_type_id>

	<cfset files_directory = "files_converted">

	<cfinclude template="get_file.cfm">

<cfelse>

	<cfset source = '#APPLICATION.path#/#client_abb#/temp/files/#objectFile.physical_name#_html/#objectFile.physical_name#.cfm'>

	<cflocation url="#source#" addtoken="no">
</cfif>
