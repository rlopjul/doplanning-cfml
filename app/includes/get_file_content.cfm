<!---
Required variables:
source
file_name
file_type
--->
<!---<cfset filename = replace(filename," ","_","ALL")>--->
<cfset filename = replaceList(file_name," ,á,é,í,ó,ú,ñ,Á,É,Í,Ó,Ú,Ñ", "_,a,e,i,o,u,n,A,E,I,O,U,N")><!---Necesita esto para que no falle en IE si el nombre tiene acentos--->
	
<cfswitch expression="#file_type#">
	<cfcase value=".pdf">
		<cfset filetype="application/pdf">
	</cfcase>
	<cfcase value=".doc">
		<cfset filetype="application/msword">
	</cfcase>
	<cfcase value=".txt">
		<cfset filetype="text/plain">
	</cfcase>
	<cfcase value=".xls">
		<cfset filetype="application/msexcel">
	</cfcase>
	<cfcase value=".jpg">
		<cfset filetype="image/jpeg">
	</cfcase>
	<cfcase value=".png">
		<cfset filetype="image/png">
	</cfcase>
	<cfcase value=".gif">
		<cfset filetype="image/gif">
	</cfcase>
	<cfdefaultcase>
		<cfset filetype="application/x-unknown; charset=UTF-8">
	</cfdefaultcase>
</cfswitch>


<cfset fileInfo = GetFileInfo(source)>
<!---
Esto no funciona en Railo con Tomcat
<cfset mimeType = getPageContext().getServletContext().getMimeType(source)>--->

<!---
Esto quitado porque por ahora no se puede usar gzip para esta aplicación
<cfif CGI.HTTP_ACCEPT_ENCODING CONTAINS "gzip"> 
	<cfheader name="Content-Encoding" value="gzip">
</cfif>--->

<!---<cfheader name="Expires" value="#GetHttpTimeString(DateAdd('m', 1, Now()))#">--->

<!---Para poder cargar un swf desde otra página o swf hay que quitar esto--->
<cfheader name="Content-Disposition" value="attachment; filename=""#filename#""" charset="UTF-8">

<!---<cfheader name="Accept-Ranges" value="bytes">--->
<cfheader name="Content-Length" value="#fileInfo.size#">

<cfcontent file="#source#" deletefile="no" type="#filetype#" /><!---if the file attribute is specified, ColdFusion attempts to get the content type from the file, but it fail with many extensions (like .pdf)--->