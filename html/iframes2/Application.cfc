<!---Copyright Era7 Information Technologies 2007-2012

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 23-05-2012
	
--->

<cfcomponent displayname="Application CFC html restricted area" extends="../../Application">
	
	
	<cffunction name="onRequestStart" output="true">	
		
		<cfif getAuthUser() EQ "" OR NOT isDefined("SESSION.client_abb") OR (isDefined("URL.abb") AND URL.abb NEQ SESSION.client_abb)><!---No está logueado o el client_abb en el que está logueado no es el mismo del que se hace la petición--->
				
			<!---Como esta página es un iframe, se redirige a la página iframe_login_redirect donde hay un script que redirige a la página padre--->
			<!---No se puede pasar la página de destino al login porque la página de destino es un iframe--->	
			<cfoutput>
				<cfif isDefined("URL.abb")>
					<cflocation url="#APPLICATION.htmlPath#/login/iframe_login_redirect.cfm?abb=#URL.abb#" addtoken="no">
				<cfelse>
					<cflocation url="#APPLICATION.htmlPath#/login/iframe_login_redirect.cfm" addtoken="no">
				</cfif>
			</cfoutput>
			
		</cfif>
		
	</cffunction>
	
	
	<!--- Handle 404 errors --->
	<cffunction name="onMissingTemplate" returnType="boolean">
		<cfargument type="string" name="targetPage" required=true/>
	
		<cftry>
		   
			<!--- set response to 404 for Search Engine and statistical purposes --->
			<!---<cfheader statusCode="404" statusText="Page Not Found">--->
		   
			<!--- retrieve the error template from the application scope --->
			<!---<cflock timeout="5" scope="application">
				<cfset ErrorTemplate = This.ErrorTemplate>
			</cflock>--->
			
			<!--- include a template to show to the user --->   
			<!---<cfinclude template = "#ErrorTemplate#">--->
			
			<cfinclude template="not_found_page.cfm">
		   
			<!--- return true to prevent the default ColdFusion error handler from running --->
			<cfreturn true />
		   
			<cfcatch>
			<!--- If an error occurs within the error handler routine, allow ColdFusion's default error handler to run --->
				<cfreturn false />
			</cfcatch>
		</cftry>
	
	</cffunction>
	

</cfcomponent>