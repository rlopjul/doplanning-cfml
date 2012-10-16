<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 11-12-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 11-12-2008
	
--->
<cfcomponent output="false">

	<cfset component = "Email">
	<cfset request_component = "EmailManager">
	

    <cffunction name="sendNotification" returntype="void" access="remote">
		<cfargument name="recipients" type="string" required="true">
		<cfargument name="subject" type="string" required="true">
        <cfargument name="content" type="string" required="true">
		
		<cfset var method = "sendNotification">
		
		<cfset var request_parameters = "">
		
		<cfset var response_page = "notifications.cfm">
		
		<cftry>
			
			<cfset selected_enc = URLEncodedFormat(arguments.recipients)>
			<cfset content_enc = URLEncodedFormat(arguments.content)>
			<cfset subject_enc = URLEncodedFormat(arguments.subject)>
			
			<cfif len(arguments.content) IS 0 OR len(arguments.recipients) IS 0 OR len(arguments.subject) IS 0>
				
				<cfset message = "Complete todos los campos para enviar la notificación.">
				<cfset message = URLEncodedFormat(message)>
				<cflocation url="#APPLICATION.htmlPath#/#response_page#?message=#message#&sel=#selected_enc#&content=#content_enc#&subject=#subject_enc#" addtoken="no">
			
			</cfif>	
			
			
            <cfsavecontent variable="request_parameters">
				<cfoutput>
					<notification recipients="#arguments.recipients#">
						<subject><![CDATA[#arguments.subject#]]></subject>
						<html_text><![CDATA[#arguments.content#]]></html_text>
					</notification>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
				<cfinvokeargument name="request_parameters" value="#request_parameters#">
			</cfinvoke>

			<cfset message = "Notificación enviada.">
			<cfset message = URLEncodedFormat(message)>
            
            <cflocation url="#APPLICATION.htmlPath#/#response_page#?message=#message#" addtoken="no">
            
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
	</cffunction>
	
	
</cfcomponent>