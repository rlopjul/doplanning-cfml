<cfif isDefined("URL.lan")>
	<cfif URL.lan EQ "es">
		<cfset user_language = "es">
	<cfelse>
		<cfset user_language = "en">
	</cfif>
	
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="updateUserLanguage" returnvariable="updateLanguageResult">
		<cfinvokeargument name="user_id" value="#SESSION.user_id#"/>
		<cfinvokeargument name="language" value="#user_language#"/>
	</cfinvoke>

</cfif>
<cfif isDefined("URL.rpage")>
	<cflocation url="#URL.rpage#" addtoken="no">
<cfelse>
	<cflocation url="main.cfm" addtoken="no">
</cfif>