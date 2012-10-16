<cfif NOT isDefined("component")>
	<cfset component = "undefined">
</cfif>
<cfif NOT isDefined("method")>
	<cfset method = "undefined">
</cfif>
<cfif NOT isDefined("xmlResponseContent")>
	<cfset xmlResponseContent = "">
</cfif>

<cfinvoke component="#APPLICATION.componentsPath#/ResponseManager" method="generateResponse" returnvariable="xmlResponse">
	<cfinvokeargument name="response_status" value="#status#">
	<cfinvokeargument name="response_component" value="#component#">
	<cfinvokeargument name="response_method" value="#method#">
	<cfinvokeargument name="response_xmlContent" value="#xmlResponseContent#">
	<cfif isDefined("error_code")>
		<cfinvokeargument name="error_code" value="#error_code#">
	</cfif>
</cfinvoke>
<!---<cfset xmlResponse = '<response component="LoginManager" method="loginUser" status="ok"><result><login valid="true"/></result></response>'>--->
<!---PROVISIONAL Para ver las respuestas que envía--->
<!---<cfif component EQ "LoginManager">
	<cfmail subject="Response" server="#APPLICATION.emailServer#" username="#APPLICATION.emailServerUserName#" password="#APPLICATION.emailServerPassword#" from="#APPLICATION.emailFrom#" replyto="#APPLICATION.emailReply#" failto="#APPLICATION.emailFail#" to="#APPLICATION.emailErrors#">
		<cfoutput>
		SESSION: #SESSION.user_id#
		#xmlResponse#
		</cfoutput>
	</cfmail>
</cfif>--->
<!---<cfreturn xmlResponse>--->