<!---Required var: 
	phone_list--->
<cfif isDefined("FORM.fieldnames") AND len(FORM.fieldnames) GT 0>
	<cfset fieldnames = FORM.fieldnames>
	<!---<cfset fieldnames = ReplaceNoCase(fieldnames, "sms.x,sms.y,", "")>
	<cfset fieldnames = ReplaceNoCase(fieldnames, "sms.x,sms.y", "")>--->
	<cfset sx = listFind(fieldnames, "sms.x")>
	<cfif sx GT 0>
		<cfset fieldnames = listDeleteAt(fieldnames,sx)>
	</cfif>
	<cfset sy = listFind(fieldnames, "sms.y")>
	<cfif sy GT 0>
		<cfset fieldnames = listDeleteAt(fieldnames,sy)>
	</cfif>
	<cfset s = listFind(fieldnames, "sms")>
	<cfif s GT 0>
		<cfset fieldnames = listDeleteAt(fieldnames,s)>
	</cfif>
	
	<cfloop index="form_field" list="#fieldnames#">	
		<cfset form_value = FORM[form_field]>
		<cfif len(form_value) GT 5>
			<cfset phone_value = replaceNoCase(listLast(form_value,";"),"n=","")>
			<cfif len(phone_value) GT 0>
				<cfset phone_list = listAppend(phone_list,phone_value,";")>
			</cfif>
		</cfif>
	</cfloop>
</cfif>