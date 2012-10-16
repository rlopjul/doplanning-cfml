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
	<cffunction name="saveError" access="public" returntype="void">
		<cfargument name="error_component" type="string" required="yes">
		<cfargument name="error_method" type="string" required="yes">
		<cfargument name="error_content" type="string" required="yes">
		<cfargument name="error_code" type="numeric" required="no">
		<cfargument name="error_message" type="string" required="no">
		<cfargument name="error_cfcatch" type="string" required="no">
		<cfargument name="error_request" type="string" required="no">
		
		<cfset var method = "saveError">
		
		<cfif NOT isDefined("arguments.error_code")>
			<cfset error_code = ERROR_UNEXPECTED>
		</cfif>
		
		<cfif error_code IS NOT 102 AND error_code IS NOT 607>
			<cfif APPLICATION.errorReport EQ "email">
			
				<cfsavecontent variable="mail_content">
				<cfoutput>
				<html><body>
						Error en #APPLICATION.title#.<br />
						<table>
						<cfif isDefined("SESSION.user_id")>
						<tr><td>user_id:</td> <td>#SESSION.user_id#<br /></td></tr>
						</cfif>
						<cfif isDefined("SESSION.client_abb")>
						<tr><td>client_abb:</td> <td>#SESSION.client_abb#<br /></td></tr>			
						</cfif>
						<tr><td>error_code:</td> <td>#error_code#<br /></td></tr>
						<cfif isDefined("arguments.error_message")>
						<tr><td>Mensaje:</td> <td>#error_message#<br /></td></tr>
						</cfif>
						<tr><td>Componente:</td> <td>#error_component#<br /></td></tr>
						<tr><td>Método:</td> <td>#error_method#<br /></td></tr>
						<tr><td>Datos:</td> <td>#error_content#<br /></td></tr>
						<cfif isDefined("arguments.error_request")>
						<tr><td>REQUEST:</td> <td>#arguments.error_request#<br/></td></tr>
						</cfif>
						<cfif isDefined("arguments.error_cfcatch")>
						<tr><td valign="top">Error:</td>	
							<td><cfdump var="#error_cfcatch#" format="text"></td>
						</tr>
						</cfif>
						<br />
						</table>
				</body></html>
				</cfoutput>
				</cfsavecontent>
				
				<cfinvoke component="EmailManager" method="sendEmail">
					<cfinvokeargument name="from" value="#APPLICATION.emailFrom#">
					<!---<cfinvokeargument name="from" value="#SESSION.client_email_from#">--->
					<cfinvokeargument name="to" value="#APPLICATION.emailErrors#">
					<cfinvokeargument name="bcc" value="">
					<cfinvokeargument name="subject" value="[#APPLICATION.title#] Error registrado">
					<cfinvokeargument name="content" value="#mail_content#">
					<cfinvokeargument name="foot_content" value="">
				</cfinvoke>
				
			<cfelse>
			
				<cfdocument format="pdf" overwrite="no" filename="ERROR_#error_component#_#error_method#.pdf">
					<html><body>
						<cfoutput>
						Error en #APPLICATION.title#.<br />
						
						<cfif isDefined("SESSION.user_id")>
						user_id: #SESSION.user_id#<br />
						</cfif>
						<cfif isDefined("SESSION.client_abb")>
						client_abb: #SESSION.client_abb#<br />			
						</cfif>
						error_code: #error_code#<br />
						<cfif isDefined("error_message")>
						Mensaje: #error_message#<br />
						</cfif>
						Componente: #error_component#<br />
						Método: #error_method#<br />
						Datos: #error_content#<br />
						</cfoutput>
						<cfif isDefined("error_cfcatch")>
						Error:<br />	
							<cfdump var="#error_cfcatch#">
						</cfif>
						<br />
					</body></html>
				</cfdocument>
				
			</cfif>
		</cfif>
		
		<!---saveError in DataBase--->
		<cfif isDefined("SESSION.user_id") AND isDefined("SESSION.client_abb") AND isDefined("SESSION.user_language")>
			<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>
			<cfquery datasource="#client_dsn#" name="saveErrorQuery">
				INSERT INTO #SESSION.client_abb#_errors_log (code, user_id, content, method, component)
				VALUES (#error_code#, '#SESSION.user_id#', '#error_content#', '#error_method#', '#error_component#')
			</cfquery>
		<cfelse>			
			<cfquery datasource="#APPLICATION.dsn#" name="saveErrorQuery">
				INSERT INTO APP_errors_log (code, content, method, component)
				VALUES (#error_code#, '#error_content#', '#error_method#', '#error_component#')
			</cfquery>
		</cfif>
				
		
	</cffunction>
	
	<!---GET_ERROR--->
	<cffunction name="getError" returntype="struct" access="public">
		<cfargument name="error_code" type="numeric" required="yes">
		
		<cfset var method = "getError">
		
		<!---<cftry>--->
		
			<!---<cfinclude template="includes/functionStart.cfm">--->
			<cfif isDefined("SESSION.user_language") AND len(SESSION.user_language) GT 0 AND SESSION.user_language NEQ "NULL">
				<cfset user_language = SESSION.user_language>
			<cfelse>
				<cfset user_language = APPLICATION.defaultLanguage>
			</cfif>
						
			<cfquery datasource="#APPLICATION.dsn#" name="getError">
				SELECT title_#user_language# AS title, description_#user_language# AS description, show_in_client, restart_client_app, handled
				FROM APP_errors
				WHERE code = #error_code#;
			</cfquery>
			
			<cfif getError.recordCount GT 0>
				<cfset error = {error_code=error_code, title="#getError.title#", description="#getError.description#", show_in_client="#getError.show_in_client#", restart_client_app="#getError.restart_client_app#", handled="#getError.handled#"}>
			<cfelse>
				<cfinvoke component="ErrorManager" method="getError" returnvariable="error">
					<cfinvokeargument name="error_code" value="#ERROR_UNEXPECTED#">
				</cfinvoke>
			</cfif>
			
			
			<cfreturn error>
		
			<!---<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>
		</cftry>--->
		
	</cffunction>
</cfcomponent>