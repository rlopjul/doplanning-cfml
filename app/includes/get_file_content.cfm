<!---
Required variables:
source
file_name
file_type
--->
<!---<cfset filename = replace(filename," ","_","ALL")>--->
<cfset filename = replaceList(file_name," ,á,é,í,ó,ú,ñ,Á,É,Í,Ó,Ú,Ñ", "_,a,e,i,o,u,n,A,E,I,O,U,N")><!---Necesita esto para que no falle en IE si el nombre tiene acentos--->

<cfset filetype = fileGetMimeType(filename,false)>

<cfif isDefined("URL.thumb") AND URL.thumb IS true AND file_type EQ ".jpg"><!--- AND fileTypeId IS 1--->

	<!--- PROVISIONAL PENDIENTE DE TERMINAR Y PROBAR BIEN: falta que funcione con archivos de área, con documentos PDF y que se borren los archivos al eliminarlos--->

	<cfif NOT isDefined("client_abb")>
		<cfset client_abb = clientAbb>
	</cfif>

	<cfif isDefined("objectFile.physical_name")>
		<cfset physical_name = objectFile.physical_name>
	<cfelse>
		<cfset physical_name = fileQuery.physical_name>
	</cfif>

	<cfset thumb_source = '#APPLICATION.filesPath#/#client_abb#/#files_directory#_thumbnails/#physical_name#'>
	<cfif NOT FileExists(thumb_source)>

		<cfimage source="#source#" name="imageToScale">
		<cfset ImageScaleToFit(imageToScale, 150, "", "highQuality")>
		<cfimage action="write" source="#imageToScale#" destination="#thumb_source#" quality="0.85" overwrite="yes">

	</cfif>

	<cfset source = thumb_source>

</cfif>

<cfset fileInfo = getFileInfo(source)>

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
<cfif NOT isDefined("URL.open") OR URL.open EQ 0>
	<cfheader name="Content-Disposition" value="attachment; filename=""#filename#""" charset="UTF-8">
<cfelse>
	<cfheader name="Content-Disposition" value="filename=""#filename#""" charset="UTF-8">
</cfif>

<!---<cfheader name="Accept-Ranges" value="bytes">--->
<cfheader name="Content-Length" value="#fileInfo.size#">

<cfcontent file="#source#" deletefile="no" type="#filetype#" /><!---if the file attribute is specified, ColdFusion attempts to get the content type from the file, but it fail with many extensions (like .pdf)--->
