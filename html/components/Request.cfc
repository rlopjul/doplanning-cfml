<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 29-09-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 17-12-2008
	
--->
<cfcomponent output="false">

	<cfset component = "Request">
	
	<!----CREATE_REQUEST--->
	<cffunction name="createRequest" access="public" returntype="string">
		<cfargument name="request_parameters" type="string" required="true">
		
		<cfset var method = "createRequest">
		
		<!---<cftry>--->
			
			<cfsavecontent variable="xmlResult">
				<cfoutput>
				<request>
					<parameters>
					#request_parameters#
					</parameters>
				</request>
				</cfoutput>
			</cfsavecontent>
			
			<cfreturn xmlResult>
			
			<!---<cfcatch>
				<cfset xmlResponseContent = requestContent>
				<cfinclude template="includes/errorHandler.cfm">
				<cfreturn "undefined">			
			</cfcatch>
		</cftry>--->
		
		
	</cffunction>
	
	<!---DO_REQUEST--->
	<cffunction name="doRequest" output="false" access="public" returntype="xml">
	
		<cfargument name="request_component" type="string" required="true">
		<cfargument name="request_method" type="string" required="true">
		<cfargument name="request_parameters" type="string" required="false">
		
		<cfset var method = "doRequest">
		
		<!---<cftry>--->
			
			<cfif isDefined("arguments.request_parameters")>
				<cfinvoke component="Request" method="createRequest" returnvariable="doRequestRequest">
					<cfinvokeargument name="request_parameters" value="#arguments.request_parameters#">
				</cfinvoke>
			</cfif>
			
			<cfinvoke component="#APPLICATION.componentsPath#/#arguments.request_component#" method="#arguments.request_method#" returnvariable="response">
				<cfif isDefined("arguments.request_parameters")>
					<cfinvokeargument name="request" value="#doRequestRequest#">
				</cfif>
			</cfinvoke>
			
			<cfxml variable="xmlResponse"><cfoutput>#response#</cfoutput></cfxml>
		
			<!---Si la respuesta es un error--->
			<cfif isDefined("xmlResponse.response.error.xmlAttributes.code") AND isValid("integer",xmlResponse.response.error.xmlAttributes.code)>
			
				<cfset error_code = xmlResponse.response.error.xmlAttributes.code>
			 
			 	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Error" method="showError">
					<cfinvokeargument name="error_code" value="#error_code#">
				</cfinvoke>
			
			</cfif>
		
			
			<!---<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
				<cfreturn "<undefined />">			
			</cfcatch>
		</cftry>--->
		
		<cfreturn xmlResponse>
		
	</cffunction>
		
</cfcomponent>