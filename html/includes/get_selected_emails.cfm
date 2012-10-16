<cfif isDefined("FORM.fieldnames") AND len(FORM.fieldnames) GT 0>
	<cfset fieldnames = FORM.fieldnames>
	<!---en unos navegadores FORM lleva notification.x e y de distintas formas, o no los lleva--->
	<!---<cfset fieldnames = ReplaceNoCase(fieldnames, "notification.x,notification.y,", "","ALL")>
	<cfset fieldnames = ReplaceNoCase(fieldnames, "notification.x,notification.y", "", "ALL")>
	<cfset fieldnames = ReplaceNoCase(fieldnames, "notification,", "", "ALL")>--->
	<cfset nx = listFind(fieldnames, "notification.x")>
	<cfif nx GT 0>
		<cfset fieldnames = listDeleteAt(fieldnames,nx)>
	</cfif>
	<cfset ny = listFind(fieldnames, "notification.y")>
	<cfif ny GT 0>
		<cfset fieldnames = listDeleteAt(fieldnames,ny)>
	</cfif>
	<cfset n = listFind(fieldnames, "notification")>
	<cfif n GT 0>
		<cfset fieldnames = listDeleteAt(fieldnames,n)>
	</cfif>
	<!---<cfset email_list = listAppend(email_list,lCase(listChangeDelims(fieldnames,";")),";")>--->
	<cfloop index="form_field" list="#fieldnames#">	
		<cfset form_value = FORM[form_field]>
		<cfif len(form_value) GT 5>
			<cfset email_value = replaceNoCase(listFirst(form_value,";"),"e=","")>
			<cfif len(email_value) GT 0>
				<cfset email_list = listAppend(email_list,email_value,";")>
			</cfif>
		</cfif>
	</cfloop>
</cfif>