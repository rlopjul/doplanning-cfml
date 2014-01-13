<cfif isDefined("URL.msg")>
	
	<cfset msg = URLDecode(URL.msg)>
	<cfoutput>
		<cfif NOT isDefined("URL.res") OR URL.res IS 1>
			<div class="alert alert-success">
				<!---<button type="button" class="close" data-dismiss="alert">&times;</button>--->
				<span lang="es">#msg#</span>
			</div>
		<cfelse>
			<div class="alert alert-danger">
				<!---<button type="button" class="close" data-dismiss="alert">&times;</button>--->
				<i class="icon-warning-sign"></i> <span lang="es">#msg#</span>
			</div>
		</cfif>
	</cfoutput>

<cfelseif isDefined("URL.message") AND NOT isNumeric(URL.message)>

	<cfset alert_message_text = URLDecode(URL.message)>
	<cfoutput>
		<div class="alert alert-warning">
			<!---<button type="button" class="close" data-dismiss="alert">&times;</button>--->
			<span lang="es">#alert_message_text#</span>
		</div>
	</cfoutput>

</cfif>