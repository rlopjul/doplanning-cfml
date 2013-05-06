<!---Copyright Era7 Information Technologies 2007-2012

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 10-05-2012
	
--->
<cfcomponent output="false">

	<cfset component = "Login">
	<cfset request_component = "LoginManager">


	<!--- LOGIN USER --->
	
	<cffunction name="loginUser" returntype="struct" output="false" access="public">
		<cfargument name="encoded" type="string" required="no" default="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="ldap_id" type="string" required="false">
		<cfargument name="client_abb" type="string" required="true">
		<!---<cfargument name="destination_page" type="string" required="no" default="">--->
		
		<cfset var method = "loginUser">
		
		<cfset var response_message = "">
		
		<cftry>
			
			<cfif arguments.encoded NEQ true>
				<cfset arguments.password = lCase(hash(arguments.password))>
			</cfif>
			
			<cfsavecontent variable="xmlRequest">
				<cfoutput>
				<request>
					<parameters>
					<user email="#arguments.email#" password="#arguments.password#"/>
    				<client_abb><![CDATA[#arguments.client_abb#]]></client_abb>
					<cfif isDefined("arguments.ldap_id")>
					<ldap id="#arguments.ldap_id#"/>
					</cfif>
					</parameters>
				</request>
				</cfoutput>
			</cfsavecontent>
			
			<cfinvoke component="#APPLICATION.componentsPath#/LoginManager" method="loginUser" returnvariable="response">
				<cfinvokeargument name="request" value="#xmlRequest#">
			</cfinvoke>
			
			<cfxml variable="xmlResponse">
				<cfoutput>
				#response#
				</cfoutput>			
			</cfxml>
			
			<cfif xmlResponse.response.result.login.xmlAttributes.valid EQ "true">
				
				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Request" method="doRequest" returnvariable="sendClientAppVersionResponse">
					<cfinvokeargument name="request_component" value="LoginManager">
					<cfinvokeargument name="request_method" value="sendClientAppVersion">
					<cfinvokeargument name="request_parameters" value="<app_client_version><![CDATA[#APPLICATION.clientVersion#]]></app_client_version>">
				</cfinvoke>
				
				<!---<cfif len(arguments.destination_page) IS 0>
					<cflocation url="#APPLICATION.path#/html/" addtoken="no">
				<cfelse>
					<cflocation url="#arguments.destination_page#" addtoken="no">
				</cfif>--->
				<cfset response = {result="true", message=""}>	
				
			<cfelse>
				<!---<cfset message =  URLEncodedFormat(xmlResponse.response.result.login.message.xmlText)>
				<cfif len(arguments.destination_page) IS 0>
					<cflocation url="index.cfm?client_abb=#client_abb#&message=#message#" addtoken="no">
				<cfelse>
					<cflocation url="index.cfm?client_abb=#client_abb#&dpage=#arguments.destination_page#&message=#message#" addtoken="no">
				</cfif>--->
				<cfset response_message = xmlResponse.response.result.login.message.xmlText>
				<cfset response = {result="false", message=#response_message#}>	
			</cfif>
			
			<cfcatch>
				<!---<cfinclude template="../components/includes/errorHandler.cfm">--->
				<cfset response_message = "Ha ocurrido un error al realizar el login">
				<cfset response = {result="false", message=#response_message#}>	
				
				<!---<cflocation url="../error.cfm">No se puede dirigir a esta página porque no se está logeado--->
			</cfcatch>
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction>
	
	
	<!--- LOGOUT USER --->
	
	<cffunction name="logOutUser" returntype="void" output="false" access="public">
		
		<cfset var method = "logoutUser">
		
		<cftry>			
			
			<!---<cfif isDefined("SESSION.client_id")>
				<cfset client_id = SESSION.client_id>
			</cfif>--->
			
			<cfinvoke component="#APPLICATION.componentsPath#/LoginManager" method="logOutUser" returnvariable="response">
			</cfinvoke>
			
			<!---<cfxml variable="xmlResponse">
				<cfoutput>
				#response#
				</cfoutput>			
			</cfxml>			
			<cfif xmlResponse.response.result.login.xmlAttributes.valid EQ "true">
			<cfelse>
			</cfif>--->
			
			<!---<cfif isDefined("client_id")>
				<cflocation url="#APPLICATION.path#/#client_id#/html/" addtoken="no">
			<cfelse>
				<cflocation url="#APPLICATION.mainUrl#" addtoken="no">
			</cfif>--->
						
			<cfcatch>
				<cfinclude template="../components/includes/errorHandler.cfm">
			</cfcatch>
			
		</cftry>
		
	</cffunction>
	
	
	<cffunction name="getUserLoggedIn" returntype="xml" output="false" access="public">
		
		<cfset var method = "getUserLoggedIn">
		
		<cfset var request_parameters = "">
		<cfset var xmlResponse = "">
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Request" method="doRequest" returnvariable="xmlResponse">
				<cfinvokeargument name="request_component" value="#request_component#">
				<cfinvokeargument name="request_method" value="#method#">
			</cfinvoke>
			
			<cfcatch>
				<cfinclude template="#APPLICATION.htmlComponentsPath#/includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
	<!--- GENERATE NEW PASSWORD --->	
	
	<cffunction name="generateNewPassword" returntype="struct" output="false" access="public">
		<cfargument name="email" type="string" required="true">
		<cfargument name="client_abb" type="string" required="true">
		
		<cfset var method = "generateNewPassword">
		
		<cfset var response_message = "">
		
			
		<cfinvoke component="#APPLICATION.componentsPath#/LoginManager" method="generateNewPassword" returnvariable="response">
			<cfinvokeargument name="email_login" value="#arguments.email#">
			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
		</cfinvoke>
		
		<cfreturn response>
		
	</cffunction>
	
	
	
</cfcomponent>