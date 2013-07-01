<cfif response.result IS NOT true>
	
	<cfif isDefined("response.error_code")>
		<cfthrow message="#response.message#" errorcode="#response.error_code#"/>
	<cfelse>
		<cfthrow message="#response.message#" errorcode="10000"/>
	</cfif>
	
</cfif>