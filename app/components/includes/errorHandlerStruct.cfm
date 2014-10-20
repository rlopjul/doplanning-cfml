<cftry>
	<!---Struct Error Handler--->

	<cfif NOT isDefined("component")>
		<cfset component = "undefined">
	</cfif>
	<cfif NOT isDefined("method")>
		<cfset method = "undefined">
	</cfif>

	
	<cfif isDefined("cfcatch")>
		<cfset error_message = cfcatch.Message>
		<cfif NOT isDefined("error_code")>
			<cfif isDefined("cfcatch.errorcode") AND isValid("integer",cfcatch.errorcode)>
				<cfset error_code = cfcatch.errorcode>
			<cfelse>
				<cfset error_code = 10000>
			</cfif>
		</cfif>
	<cfelse>
		<cfset error_message = "undefined">
		<cfset error_code = 10000>
	</cfif>

	<cfset error_request = SerializeJSON(arguments)>
	
	<!--- Error Manager from Components --->
	<cfinvoke component="#APPLICATION.componentsPath#/ErrorManager" method="saveError" returnvariable="saveErrorResponse">
		<cfinvokeargument name="error_component" value="#component#" >
		<cfinvokeargument name="error_method" value="#method#">
		<cfinvokeargument name="error_content" value="">
		<!---<cfif isDefined("error_code")>--->
			<cfinvokeargument name="error_code" value="#error_code#">
		<!---</cfif>--->
		<cfinvokeargument name="error_message" value="#error_message#">
		<cfif isDefined("cfcatch")>
			<cfinvokeargument name="error_cfcatch" value="#cfcatch#">
		</cfif>
		<cfinvokeargument name="error_request" value="#error_request#">
		<!---<cfif isDefined("arguments.request")>
			<cfinvokeargument name="error_request" value="#arguments.request#">
		</cfif>--->
	</cfinvoke>

	<cfif error_code IS NOT 10000>
		<cfinvoke component="#APPLICATION.componentsPath#/ErrorManager" method="getError" returnvariable="objectError">
			<cfinvokeargument name="error_code" value="#error_code#">	
		</cfinvoke>

		<!--- response --->
		<cfset response = {result=false, message="#objectError.title#", error_code="#error_code#"}>

	<cfelse>

		<!--- response --->
		<cfset response = {result=false, message="#error_message#", error_code="#error_code#"}>

	</cfif>


	<cfcatch>
			
		<cftry>
		
			<cfsavecontent variable="mail_content">
				<cfoutput>
				<html><body>
					Se ha producido un error en #APPLICATION.title#.<br />
					
					Mensaje: #cfcatch.Message#<br />
					Componente: #component#<br />
					Método: #method#<br />
					
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

			<!--- response --->
			<cfset response = {result=false, message="#cfcatch.message#"}>

			<cfcatch>

				<cfset response = {result=false, message="#cfcatch.message#"}>

			</cfcatch>
		
		</cftry>
		
	</cfcatch>

</cftry>