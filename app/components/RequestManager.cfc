<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 13-08-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 29-10-2008

--->
<cfcomponent output="false">

	<cfset component = "RequestManager">

	<!----PARSE REQUEST--->
	<cffunction name="xmlRequest" access="public" returntype="xml">
		<cfargument name="request" type="string" required="yes">

		<cfset var method = "xmlRequest">

		<cftry>

			<!---PROVISIONAL Para ver las peticiones que recibe--->
			<!---<cfmail subject="Request" server="#APPLICATION.emailServer#" username="#APPLICATION.emailServerUserName#" password="#APPLICATION.emailServerPassword#" from="#APPLICATION.emailFrom#" failto="#APPLICATION.emailFail#" to="#APPLICATION.emailErrors#">
				<cfoutput>
				SESSION_SESSION_ID: <cfif isDefined("SESSION.sessionid")>#SESSION.sessionid#<cfelse>undefined</cfif>
				SESSION_CFID: <cfif isDefined("SESSION.CFIDE")>#SESSION.CFID#<cfelse>undefined</cfif>
				SESSION_CFTOKEN: <cfif isDefined("SESSION.CFToken")>#SESSION.CFToken#<cfelse>undefined</cfif>
				SESSION_USER_ID: <cfif isDefined("SESSION.user_id")>#SESSION.user_id#<cfelse>undefined</cfif>

				#arguments.request#
				</cfoutput>
			</cfmail>--->

			<cfxml variable="xml">
				<cfoutput>
				#arguments.request#
				</cfoutput>
			</cfxml>

			<cfreturn xml>

			<cfcatch>
				<cfset xmlResponseContent = arguments.request>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>
		</cftry>


	</cffunction>

	<!----CREATE_REQUEST--->
	<cffunction name="createRequest" access="public" returntype="string">
		<cfargument name="request_parameters" type="string" required="yes">

		<cfset var method = "createRequest">

		<cftry>

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

			<cfcatch>
				<cfset xmlResponseContent = requestContent>
				<cfinclude template="includes/errorHandler.cfm">
				<cfreturn "undefined">
			</cfcatch>
		</cftry>


	</cffunction>
</cfcomponent>
