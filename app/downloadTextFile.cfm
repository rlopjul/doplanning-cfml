<!---Genera un archivo de texto para descargar a partir del contenido que se le pasa--->
<cfif isDefined("FORM.text") AND isDefined("FORM.name")>

	<cfset fileContent = FORM.text>
	
	<cfset fileName = FORM.name>

	<cfheader name="content-disposition" value="attachment; filename=#fileName#" charset="UTF-8">
		
	<cfcontent variable="#ToBinary(ToBase64(fileContent))#" type="application/unknown" />

</cfif>