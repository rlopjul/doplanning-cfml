<cfif isDefined("URL.text") AND len(URL.text) GT 0>

	<cfset search_text = URL.text>
	<cfset text_value = URL.text>
	<cfset search_text_encoded = URLEncodedFormat(search_text)>
	<cfset current_url = "#CGI.SCRIPT_NAME#?text=#search_text_encoded#">
	
	<cfif isDefined("URL.page") AND isValid("integer",URL.page)>
		<cfset search_page = URL.page>
	<cfelse>
		<cfset search_page = 1>
	</cfif>
	
<cfelse>

	<cfset text_value = "">
	
</cfif>
<cfoutput>
<div style="clear:both; padding-top:10px; padding-bottom:10px;">
	<form action="#CGI.SCRIPT_NAME#" method="get">
		<input type="text" name="text" value="#text_value#" />
		<input type="submit" name="search" value="Buscar" />
	</form>
</div>
</cfoutput>