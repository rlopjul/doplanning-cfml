<cfif (isDefined("URL.name") AND len(URL.name) GT 0) OR (isDefined("URL.file_name") AND len(URL.file_name) GT 0) OR (isDefined("URL.file_type") AND len(URL.file_type) GT 0)>

	<cfif isDefined("URL.name")>
		<cfset name_value = URLDecode(URL.name)>
	<cfelse>
		<cfset name_value = "">
	</cfif>
	<cfif isDefined("URL.file_name")>
		<cfset file_name_value = URLDecode(URL.file_name)>
	<cfelse>
		<cfset file_name_value = "">
	</cfif>
	<cfif isDefined("URL.file_type")>
		<cfset file_type_value = URLDecode(URL.file_type)>
	<cfelse>
		<cfset file_type_value = "">
	</cfif>
	
	<cfset name_encoded = URLEncodedFormat(name_value)>
	<cfset file_name_encoded = URLEncodedFormat(file_name_value)>
	<cfset file_type_encoded = URLEncodedFormat(file_type_value)>
	<cfset current_url = "#CGI.SCRIPT_NAME#?name=#name_encoded#&file_name=#file_name_encoded#&file_type=#file_type_encoded#">
	
	<cfif isDefined("URL.page") AND isValid("integer",URL.page)>
		<cfset search_page = URL.page>
	<cfelse>
		<cfset search_page = 1>
	</cfif>
	
<cfelse>

	<cfset name_value = "">
	<cfset file_name_value = "">
	<cfset file_type_value = "">
	
</cfif>
<cfoutput>
<div style="clear:both; padding-top:10px; padding-bottom:10px;">
	<form action="#CGI.SCRIPT_NAME#" method="get">
		<div class="div_search_label">Nombre:</div><input type="text" name="name" value="#name_value#" /><br/>
		<div class="div_search_label">Nombre de archivo:</div><input type="text" name="file_name" value="#file_name_value#" /><br/>
		<div class="div_search_label">Extensión:</div><input type="text" name="file_type" value="#file_type_value#" /><br/>
		
		<input type="submit" name="search" value="Buscar" />
	</form>
</div>
</cfoutput>