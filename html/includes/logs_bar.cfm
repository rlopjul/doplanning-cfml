<cfif (isDefined("URL.date_from") AND len(URL.date_from) GT 0) OR (isDefined("URL.date_to") AND len(URL.date_to) GT 0)>

	<cfif isDefined("URL.date_from")>
		<cfset date_from_value = URLDecode(URL.date_from)>
	<cfelse>
		<cfset date_from_value = "">
	</cfif>
	<cfif isDefined("URL.date_to")>
		<cfset date_to_value = URLDecode(URL.date_to)>
	<cfelse>
		<cfset date_to_value = "">
	</cfif>
	
	<cfset date_from_encoded = URLEncodedFormat(date_from_value)>
	<cfset date_to_encoded = URLEncodedFormat(date_to_value)>
	<cfset current_url = "#CGI.SCRIPT_NAME#?date_from=#date_from_encoded#&date_to=#date_to_encoded#">
	
	<cfif isDefined("URL.page") AND isValid("integer",URL.page)>
		<cfset search_page = URL.page>
	<cfelse>
		<cfset search_page = 1>
	</cfif>
	
<cfelse>

	<cfset date_from_value = dateFormat(now(),"DD-MM-YYYY")>
	<cfset date_to_value = dateFormat(now(),"DD-MM-YYYY")>
	
</cfif>
<cfoutput>
<div style="clear:both; padding-top:10px; padding-bottom:10px;">
	<cfform action="#CGI.SCRIPT_NAME#" method="get">
		<div class="div_search_label">Fecha desde:</div><cfinput type="text" validate="eurodate" required="yes" message="Fecha desde correcta requerida" name="date_from" value="#date_from_value#" />&nbsp;<span>Formato DD-MM-AAAA. Ejemplo: 21-12-2009</span><br/>
		<div class="div_search_label">Fecha hasta:</div><cfinput type="text" validate="eurodate" required="yes" message="Fecha hasta correcta requerida" name="date_to" value="#date_to_value#" /><br/>
		
		<input type="submit" class="btn btn-primary" name="search" value="Consultar" />
	</cfform>
</div>
</cfoutput>