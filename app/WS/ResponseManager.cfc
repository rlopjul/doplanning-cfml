<!---Copyright Era7 Information Technologies 2007-2012

	Date of file creation: 12-08-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 24-11-2008
	
--->
<cfcomponent output="false">

	<cfset component = "ResponseManager">

	<!--------------------------------------- GENERATE_RESPONSE ------------------------------------>
	<cffunction name="generateResponse" output="false" access="public" returntype="string">
		<cfargument name="response_status" type="string" required="yes">
		<cfargument name="response_component" type="string" required="yes">
		<cfargument name="response_method" type="string" required="yes">
		<cfargument name="response_xmlContent" type="string" required="yes">
		<cfargument name="error_code" type="numeric" required="no">
		<cfargument name="error_message" type="string" required="no">
		
		
		<cfset method = "generateResponse">
		
		<!---<cfinclude template="includes/functionStart.cfm">--->
		
		<!---<cfif IsXmlDoc(response_xmlContent)>
		</cfif>--->
	
		<cfif response_status EQ "error">
			<cfif NOT isDefined("error_code")>
				<cfset error_code = 10000>
			</cfif>	
			<cfinvoke component="ErrorManager" method="getError" returnvariable="errorDetails">
				<cfinvokeargument name="error_code" value="#error_code#">
			</cfinvoke>	
		</cfif>
		
		<cfset arguments.response_xmlContent = trim(arguments.response_xmlContent)>

		<cfif response_status EQ "ok">
			<!---<cfprocessingdirective suppresswhitespace="true"><cfsavecontent variable="xmlResponse"><cfoutput><response status="#response_status#" component="#response_component#" method="#response_method#"><result>#arguments.response_xmlContent#</result></response></cfoutput></cfsavecontent>
			</cfprocessingdirective>--->
			<cfset xmlResponse = '<response status="#response_status#" component="#response_component#" method="#response_method#"><result>#arguments.response_xmlContent#</result></response>'>
		<cfelse>
			<cfprocessingdirective suppresswhitespace="true"><cfsavecontent variable="xmlResponse"><cfoutput><response status="#response_status#" component="#response_component#" method="#response_method#"><error code="#errorDetails.error_code#" show_in_client="#errorDetails.show_in_client#" restart_app="#errorDetails.restart_client_app#" handled="#errorDetails.handled#"><title><![CDATA[#errorDetails.title#]]></title><description><![CDATA[#errorDetails.description#]]></description><source>#arguments.response_xmlContent#</source></error></response></cfoutput></cfsavecontent>
			</cfprocessingdirective>
		</cfif>
		<!---<cfprocessingdirective suppresswhitespace="true"><cfsavecontent variable="xmlResponse"><cfoutput><response status="#response_status#" component="#response_component#" method="#response_method#"><cfif response_status EQ "ok"><result>#arguments.response_xmlContent#</result><cfelseif response_status EQ "error"><error code="#errorDetails.error_code#" show_in_client="#errorDetails.show_in_client#" restart_app="#errorDetails.restart_client_app#" handled="#errorDetails.handled#"><title><![CDATA[#errorDetails.title#]]></title><description><![CDATA[#errorDetails.description#]]></description><source>#arguments.response_xmlContent#</source></error></cfif></response></cfoutput></cfsavecontent>
		</cfprocessingdirective>--->
		
		<!---<cfif NOT IsXmlDoc(arguments.response_xmlContent)>
			<cfset arguments.response_xmlContent = XMLParse(arguments.response_xmlContent)>
		</cfif>
		
		<cfif response_status EQ "ok">
		
			<cfset XmlAppend(xmlResponse.response.result.xmlChildren, arguments.response_xmlContent) />
			<!---<cfset xmlResponse.response.result.xmlChildren = arguments.response_xmlContent>--->
			
		<cfelseif response_status EQ "error">
		
			<cfset xmlResponse.response.error.source.xmlChildren = arguments.response_xmlContent>
			
		</cfif>--->
		
		
		<cfreturn xmlResponse>
			
	</cffunction>
	
	
</cfcomponent>