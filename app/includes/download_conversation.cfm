<!---Copyright Era7 Information Technologies 2007-2008

    File created by: alucena
	Date of file creation: 23-01-2009
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 23-01-2009
	
--->
<cfset component = "downloadConversation">
<cfset method = "downloadConversation">

<cfinclude template="#APPLICATION.componentsPath#/includes/sessionVars.cfm">

<!---checkParameters--->
<cfif NOT isDefined("URL.id")><!---No value given for one or more required parameters--->
	<cfset error_code = 610>

	<cfthrow errorcode="#error_code#">
</cfif>


<cfquery name="getFileData" datasource="#client_dsn#">
	SELECT *
	FROM #client_abb#_msg_saved_conversations
	WHERE id=<cfqueryparam value="#URL.id#" cfsqltype="cf_sql_integer">
	AND user_id = <cfqueryparam value="#user_id#" cfsqltype="cf_sql_integer">;
</cfquery>		

<cfif getFileData.recordCount GT 0>

	<cfset file_physical = ExpandPath("#APPLICATION.resourcesPath#/temp/conversation_#URL.id#")>
	
	<cffile action="write" file="#file_physical#" output="#getFileData.content#" charset="iso-8859-1">
	
	<cfset file_name = replaceList(getFileData.name&".html"," ,á,é,í,ó,ú,ñ,Á,É,Í,Ó,Ú,Ñ", "_,a,e,i,o,u,n,A,E,I,O,U,N")><!---Necesita esto para que no falle en IE si el nombre tiene acentos--->
	
	<cfheader name="content-disposition" value="attachment; filename=#file_name#" charset="UTF-8">
	
	<cfcontent file="#file_physical#" deletefile="yes" type="text/html" /><!---if the file attribute is specified, ColdFusion attempts to get the content type from the file, but it fail with many extensions (like .pdf)--->

<cfelse><!---File does not exist--->
			
	<cfset error_code = 601>
	
	<cfthrow errorcode="#error_code#">

</cfif>	