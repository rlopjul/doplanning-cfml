<cfif isDefined("URL.user")>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="deleteUser" returnvariable="deleteResponse">
		<cfinvokeargument name="user_id" value="#URL.user#">
	</cfinvoke>

	<cflocation url="user.cfm?user=#deleteResponse.user_id#" addtoken="false"/>

</cfif>