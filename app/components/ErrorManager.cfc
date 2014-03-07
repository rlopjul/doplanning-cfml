<!---Copyright Era7 Information Technologies 2007-2009

	Date of file creation: 20-08-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 27-09-2012
	
	27-09-2012 alucena: modificado envío por email de error para que aparezcan los detalles del error en Mandrill
	
--->
<cfcomponent displayname="ErrorManager" output="false">

	<cfset component = "ErrorManager">
	
	<cfset ERROR_UNEXPECTED = 10000>

	<!----SAVE_ERROR--->
	<cffunction name="saveError" output="false" access="public" returntype="void">
		<cfargument name="error_component" type="string" required="yes">
		<cfargument name="error_method" type="string" required="yes">
		<cfargument name="error_content" type="string" required="false">
		<cfargument name="error_code" type="numeric" required="no">
		<cfargument name="error_message" type="string" required="no">
		<cfargument name="error_cfcatch" type="string" required="no">
		<cfargument name="error_request" type="string" required="no">
		
		<cfset var method = "saveError">
		
		<cfinvoke component="#APPLICATION.coreComponentsPath#/ErrorManager" method="saveError">
			<cfinvokeargument name="error_component" value="#arguments.error_component#">
			<cfinvokeargument name="error_method" value="#arguments.error_method#">
			<cfinvokeargument name="error_content" value="#arguments.error_content#">
			<cfinvokeargument name="error_code" value="#arguments.error_code#">
			<cfinvokeargument name="error_message" value="#arguments.error_message#">
			<cfinvokeargument name="error_cfcatch" value="#arguments.error_cfcatch#">
			<cfinvokeargument name="error_request" value="#arguments.error_request#">

			<cfif isDefined("SESSION.user_id")>
				<cfinvokeargument name="user_id" value="#SESSION.user_id#">
			</cfif>
			<cfif isDefined("SESSION.user_language")>
				<cfinvokeargument name="user_language" value="#SESSION.user_language#">
			</cfif>
			<cfif isDefined("SESSION.client_abb")>
				<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
			</cfif>
		</cfinvoke>
		
	</cffunction>
	
	<!---GET_ERROR--->
	<cffunction name="getError" output="false" returntype="struct" access="public">
		<cfargument name="error_code" type="numeric" required="yes">
		
		<cfset var method = "getError">
				
			<cfinvoke component="#APPLICATION.coreComponentsPath#/ErrorManager" method="getError" returnvariable="error">
				<cfinvokeargument name="error_code" value="#arguments.error_code#">

				<cfif isDefined("SESSION.user_id")>
					<cfinvokeargument name="user_id" value="#SESSION.user_id#">
				</cfif>
				<cfif isDefined("SESSION.user_language")>
					<cfinvokeargument name="user_language" value="#SESSION.user_language#">
				</cfif>
				<cfif isDefined("SESSION.client_abb")>
					<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
				</cfif>
			</cfinvoke>
			
			<cfreturn error>
		
	</cffunction>
</cfcomponent>