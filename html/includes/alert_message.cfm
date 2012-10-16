<cfif isDefined("URL.message")>

	<cfset message = URLDecode(URL.message)>
	<cfoutput>
		<div class="div_alert_message">
		#message#
		</div>
	</cfoutput>

<cfelseif isDefined("URL.msg")>
	
	<cfset msg = URLDecode(URL.msg)>
	<cfoutput>
		<cfif NOT isDefined("URL.res") OR URL.res IS true>
			<div class="div_alert_message">
			#msg#
			</div>
		<cfelse>
			<div class="div_alert_message_red">
			#msg#
			</div>
		</cfif>
	</cfoutput>
	
</cfif>