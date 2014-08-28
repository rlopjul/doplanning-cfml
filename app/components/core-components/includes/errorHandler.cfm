<cftry>
	<!---Default Error Handler--->

	<cfif NOT isDefined("component")>
		<cfset component = "undefined">
	</cfif>
	<cfif NOT isDefined("method")>
		<cfset method = "undefined">
	</cfif>
	
	<cfset error_request = SerializeJSON(arguments)>

	<!--- Error Manager from core-components --->
	<cfinvoke component="#APPLICATION.coreComponentsPath#/ErrorManager" method="saveError">
		<cfinvokeargument name="error_component" value="#component#" >
		<cfinvokeargument name="error_method" value="#method#">
		<cfinvokeargument name="error_request" value="#error_request#">
		<cfif isDefined("cfcatch.Message")>
			<cfinvokeargument name="error_message" value="#cfcatch.Message#">
		</cfif>
		<cfif isDefined("cfcatch")>
			<cfinvokeargument name="error_cfcatch" value="#cfcatch#">
		</cfif>
		<cfif isDefined("arguments.client_abb")>
			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
		</cfif>
	</cfinvoke>
	
	<cfcatch>
			
		<cftry>
		
			<cfsavecontent variable="mail_content">
				<cfoutput>
				<html><body>
					Se ha producido un error en #APPLICATION.title#.<br />
					
					Mensaje: #cfcatch.Message#<br />
					Componente: #component#<br />
					Método: #method#<br />
					Datos: #SerializeJSON(arguments)#<br />
					
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
			
			<cffinally>
				
				<cfset status = "error">	
				<cfinclude template="#APPLICATION.componentsPath#/includes/generateResponse.cfm">
			
			</cffinally>
			
		</cftry>
		
	</cfcatch>

</cftry>