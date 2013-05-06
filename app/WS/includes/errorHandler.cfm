<cftry>
	<!---Default Error Handler--->

	<cfif NOT isDefined("component")>
		<cfset component = "undefined">
	</cfif>
	<cfif NOT isDefined("method")>
		<cfset method = "undefined">
	</cfif>
	<cfif NOT isDefined("xmlResponseContent")>
		<cfset xmlResponseContent = "undefined">
	</cfif>

	
	<cfif NOT isDefined("error_message")>
		<cfif isDefined("cfcatch")>
			<cfset error_message = "#cfcatch.Message#">
			<cfif NOT isDefined("error_code") AND isDefined("cfcatch.errorcode") AND isValid("integer",cfcatch.errorcode)>
				<cfset error_code = cfcatch.errorcode>
			</cfif>
		<cfelse>
			<cfset error_message = "undefined">
		</cfif>
	</cfif>
	
	<cfinvoke component="#APPLICATION.componentsPath#/ErrorManager" method="saveError">
		<cfinvokeargument name="error_component" value="#component#" >
		<cfinvokeargument name="error_method" value="#method#">
		<cfinvokeargument name="error_content" value="#xmlResponseContent#">
		<cfif isDefined("error_code")>
			<cfinvokeargument name="error_code" value="#error_code#">
		</cfif>
		<cfinvokeargument name="error_message" value="#error_message#">
		<cfif isDefined("cfcatch")>
			<cfinvokeargument name="error_cfcatch" value="#cfcatch#">
		</cfif>
		<cfif isDefined("arguments.request")>
			<cfinvokeargument name="error_request" value="#arguments.request#">
		</cfif>
	</cfinvoke>
	
	<cfset status = "error">	
	<cfinclude template="#APPLICATION.componentsPath#/includes/generateResponse.cfm">
	
	<cfcatch>
	
		<cfsavecontent variable="mail_content">
			<cfoutput>
			<html><body>
				<p>Se ha producido un error en #APPLICATION.title#.<br />
				
				Mensaje: #cfcatch.Message#<br />
				Componente: #component#<br />
				Método: #method#<br />
				Datos: #xmlResponseContent#<br />
				
				<cfdump var="#cfcatch#">
				<br />
			</body></html>
			</cfoutput>
		</cfsavecontent>
		
		<cfinvoke component="#APPLICATION.componentsPath#/EmailManager" method="sendEmail">
			<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
			<cfinvokeargument name="to" value="#APPLICATION.emailErrors#">
			<cfinvokeargument name="bcc" value="">
			<cfinvokeargument name="subject" value="Error en #APPLICATION.title#">
			<cfinvokeargument name="content" value="#mail_content#">
			<cfinvokeargument name="foot_content" value="">
		</cfinvoke>
		
	</cfcatch>

</cftry>