<cfif response.result IS NOT true>

	<cfif isDefined("response.error_code")>
		<cfthrow message="#response.message#" errorcode="#response.error_code#"/>
	<cfelse>
		<cfthrow message="#response.message#" errorcode="10000"/>
	</cfif>

</cfif>


<!--- <cfif responseResult.status_code NEQ "200" AND responseContent.status EQ "OK">
	
<cfelse>
	
	<cfoutput>
	ERROR: <br/>
	STATUS CODE: #responseResult.status_code#<br/>
	STATUS TEXT: #responseResult.status_text#<br/>
	DETAIL: #responseResult.errordetail#<br/>
	</cfoutput>
	
</cfif> --->

