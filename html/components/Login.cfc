<!---Copyright Era7 Information Technologies 2007-2013

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 02-07-2013

--->
<cfcomponent output="false">

	<cfset component = "Login">
	<cfset request_component = "LoginManager">


	<!--- LOGIN USER --->
	
	<!--- <cffunction name="loginUser" returntype="struct" output="false" access="public">
		<cfargument name="encoded" type="string" required="no" default="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="ldap_id" type="string" required="false">
		<cfargument name="client_abb" type="string" required="true">
		
		<cfset var method = "loginUser">
		
		<cfset var response = structNew()>

		<cfset var response_message = "">
		
		<cftry>
			
			<cfif APPLICATION.moduleLdapUsers IS false OR arguments.ldap_id EQ "doplanning">
				<cfif arguments.encoded NEQ true>
					<cfset arguments.password = lCase(hash(arguments.password))>
				</cfif>
			</cfif>
			
			<cfinvoke component="#APPLICATION.componentsPath#/LoginManager" method="loginUser" returnvariable="response">
				<cfinvokeargument name="login" value="#arguments.email#"/>
				<cfinvokeargument name="password" value="#arguments.password#"/>
				<cfinvokeargument name="client_abb" value="#arguments.client_abb#"/>
				<cfif isDefined("arguments.ldap_id")>
					<cfinvokeargument name="ldap_id" value="#arguments.ldap_id#"/>
				</cfif>
			</cfinvoke>
			
			<cfcatch>
				
				<cfinclude template="#APPLICATION.htmlComponentsPath#/includes/errorHandlerNoRedirectStruct.cfm">

				<cfset response_message = "Ha ocurrido un error al realizar el login">
				<cfset response = {result="false", message=#response_message#}>	
				
			</cfcatch>
				
		</cftry>
		
		<cfreturn response>
		
	</cffunction> --->
	
	
	<!--- LOGOUT USER --->
	
	<!--- 
	<cffunction name="logOutUser" returntype="struct" output="false" access="public">
			
		<cfset var method = "logoutUser">

		<cfset var response = structNew()>
		
		<cftry>			
			
			<cfinvoke component="#APPLICATION.componentsPath#/LoginManager" method="logOutUser" returnvariable="response">
			</cfinvoke>
			
			<cfcatch>
				<cfinclude template="#APPLICATION.htmlComponentsPath#/includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction> --->
	

	
	<!--- GET USER LOGGED --->
	
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
	
	<!--- <cffunction name="generateNewPassword" returntype="struct" output="false" access="public">
		<cfargument name="email" type="string" required="true"/>
		<cfargument name="client_abb" type="string" required="true"/>
		<cfargument name="language" type="string" required="true"/>
		
		<cfset var method = "generateNewPassword">

		<cfset var response = structNew()>	

		<cftry>
			
			<cfinvoke component="#APPLICATION.componentsPath#/LoginManager" method="generateNewPassword" returnvariable="response">
				<cfinvokeargument name="email_login" value="#arguments.email#">
				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="language" value="#arguments.language#"/>
			</cfinvoke>
		
			<cfcatch>
				<cfinclude template="#APPLICATION.htmlComponentsPath#/includes/errorHandlerNoRedirectStruct.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn response>
		
	</cffunction> --->
	
	
	
</cfcomponent>