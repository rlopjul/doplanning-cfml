<!---
Required variables:
source
file_name
file_type
--->
<!---<cfset filename = replace(filename," ","_","ALL")>--->
<cfset filename = replaceList(file_name," ,á,é,í,ó,ú,ñ,Á,É,Í,Ó,Ú,Ñ", "_,a,e,i,o,u,n,A,E,I,O,U,N")><!---Necesita esto para que no falle en IE si el nombre tiene acentos--->

<cfset filetype = fileGetMimeType(filename,false)>

<cfset fileInfo = getFileInfo(source)>

<!---Para poder cargar un swf desde otra página o swf hay que quitar esto--->
<cfif ( NOT isDefined("URL.open") OR URL.open EQ 0 ) AND (NOT isDefined("thumb") OR thumb IS false)>
	<cfheader name="Content-Disposition" value="attachment; filename=""#filename#""" charset="UTF-8">
<cfelse>
	<cfheader name="Content-Disposition" value="filename=""#filename#""" charset="UTF-8">
</cfif>

<cfheader name="Content-Length" value="#fileInfo.size#">

<cfcontent file="#source#" deletefile="no" type="#filetype#" /><!---if the file attribute is specified, ColdFusion attempts to get the content type from the file, but it fail with many extensions (like .pdf)--->
