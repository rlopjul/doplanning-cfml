<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 17-12-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 17-12-2008
	
--->
<cfcomponent output="false">

	<cfset component = "SMS">
	<cfset request_component = "SMSManager">
	

    <cffunction name="sendSMS" returntype="void" access="remote">
		<cfargument name="recipients" type="string" required="true">
        <cfargument name="content" type="string" required="true">
		
		<cfset var method = "sendSMS">
		
		<cfset var request_parameters = "">
		
		<cfset var response_page = "sms.cfm">
		
		<cftry>
		
			<cfset selected_enc = URLEncodedFormat(arguments.recipients)>
			<cfset content_enc = URLEncodedFormat(arguments.content)>
			
			<cfif len(arguments.content) IS 0 OR len(arguments.recipients) IS 0>
				
				<cfset message = "No puede enviar un SMS sin contenido o sin destinatarios.">
				<cfset message = URLEncodedFormat(message)>
				<cflocation url="#APPLICATION.htmlPath#/#response_page#?message=#message#&sel=#selected_enc#&content=#content_enc#" addtoken="no">
			
			<cfelseif len(arguments.content) GT 160>
				
				<cfset message = "Ha escrito "&len(arguments.content)&" caracteres. El contenido del SMS no puede pasar de 160 caracteres.">
				<cfset message = URLEncodedFormat(message)>
				<cflocation url="#APPLICATION.htmlPath#/#response_page#?message=#message#&sel=#selected_enc#&content=#content_enc#" addtoken="no">
				
			</cfif>			
			
            <cfsavecontent variable="request_parameters">
				<cfoutput>
					<sms recipients="#arguments.recipients#">
						<text><![CDATA[#arguments.content#]]></text>
					</sms>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>
			
			<cfset message = "SMS enviado.">
			<cfset message = URLEncodedFormat(message)>
            
            <cflocation url="#APPLICATION.htmlPath#/#response_page#?message=#message#" addtoken="no">
            
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
</cfcomponent>