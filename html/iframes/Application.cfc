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
			
			<!---<cfif isDefined("URL.abb")>
				<cfset destination_page = URLEncodedFormat(CGI.SCRIPT_NAME&"?"&CGI.QUERY_STRING)>
				<cflocation url="#APPLICATION.htmlPath#/login/?client_abb=#URL.abb#&dpage=#destination_page#" addtoken="no">
			<cfelse>
				<cflocation url="#APPLICATION.mainUrl#" addtoken="no">
			</cfif>--->
			
		</cfif>
		
	</cffunction>
	

</cfcomponent>