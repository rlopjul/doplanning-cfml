<!--- CUIDADO: este script REDIRIGE de página si hay un error. Usar errorHandlerNoRedirectStruct.cfm en su lugar si no se quiere que redirija para mostrar error--->

<cftry>
	<!---Default Error Handler--->

	<cfif NOT isDefined("component")>
		<cfset component = "undefined">
	</cfif>
	<cfif NOT isDefined("method")>
		<cfset method = "undefined">
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
		<cfinvokeargument name="error_content" value="">
		<cfif isDefined("error_code")>
			<cfinvokeargument name="error_code" value="#error_code#">
		</cfif>
		<cfinvokeargument name="error_message" value="#error_message#">
		<cfif isDefined("cfcatch")>
			<cfinvokeargument name="error_cfcatch" value="#cfcatch#">
		</cfif>
	</cfinvoke>


	<cfif NOT isDefined("error_code")>
		<cfset error_code = 10000><!--- Unexpected ---> 
	</cfif>	

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Error" method="showError">
		<cfinvokeargument name="error_code" value="#error_code#">
	</cfinvoke>
	
	<cfcatch>
		
		<cftry>
		
			<cfsavecontent variable="mail_content">
				<cfoutput>
				<html><body>
					Se ha producido un error en Doplanning.<br />
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

			<cfcatch>

			</cfcatch>
			
			<cffinally>

				<cfif isDefined("error_code")>
					<cfinvoke component="#APPLICATION.htmlComponentsPath#/Error" method="showError">
						<cfinvokeargument name="error_code" value="#error_code#">
					</cfinvoke>
				</cfif>	
			
			</cffinally>

		</cftry>
		
	</cfcatch>
	
</cftry>