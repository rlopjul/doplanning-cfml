<cfif (isDefined("URL.title") AND len(URL.title) GT 0) OR (isDefined("URL.description") AND len(URL.description) GT 0)>

	<cfif isDefined("URL.title")>
		<cfset title_value = URL.title>
	<cfelse>
		<cfset title_value = "">
	</cfif>
	<cfif isDefined("URL.description")>
		<cfset description_value = URL.description>
	<cfelse>
		<cfset description_value = "">
	</cfif>
	<cfif isDefined("URL.user_in_charge")>
		<cfset user_in_charge_value = URL.user_in_charge>
	<cfelse>
		<cfset user_in_charge_value = "">
	</cfif>
	
	<cfset title_encoded = URLEncodedFormat(title_value)>
	<cfset description_encoded = URLEncodedFormat(description_value)>
	<cfset current_url = "#CGI.SCRIPT_NAME#?title=#title_encoded#&description=#description_encoded#">
	
	<cfif isDefined("URL.page") AND isValid("integer",URL.page)>
		<cfset search_page = URL.page>
	<cfelse>
		<cfset search_page = 1>
	</cfif>
	
<cfelse>

	<cfset title_value = "">
	<cfset description_value = "">
	<cfset user_in_charge_value = "">
	
</cfif>
<cfoutput>
<div style="clear:both; padding-top:10px; padding-bottom:10px;">
	<form action="#CGI.SCRIPT_NAME#" method="get">
		<div class="div_search_label">Asunto:</div> <input type="text" name="title" value="#title_value#" /><br/>
		<div class="div_search_label">Contenido:</div> <input type="text" name="description" value="#description_value#" /><br/>
		<!---<div class="div_search_label">Desde:</div> <input type="text" name="date_from" value="" /><br/>
		<div class="div_search_label">Hasta:</div> <input type="text" name="date_to" value="" /><br/>
		<div class="div_search_label">Usuario:</div> <input type="text" name="user_in_charge" value="#user_in_charge_value#" /><br/>--->
		<input type="submit" name="search" value="Buscar" />
	</form>
</div>
</cfoutput>