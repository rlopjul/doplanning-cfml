<cfif isDefined("URL.abb")>
	<cfset client_abb = URL.abb>
<cfelseif isDefined("SESSION.client_abb")>
	<cfset client_abb = SESSION.client_abb>
<cfelse>
	<cflocation url="#APPLICATION.mainUrl#" addtoken="no">
</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interfaz" method="isMobileBrowser" returnvariable="isMobileBrowser">
</cfinvoke>

<cfif isMobileBrowser IS true OR ( (FindNoCase('MSIE 6',CGI.HTTP_USER_AGENT) GT 0 OR FindNoCase('MSIE 7',CGI.HTTP_USER_AGENT) GT 0 ) AND FindNoCase('Opera',CGI.HTTP_USER_AGENT) LT 1)><!---Mobile version--->

	<cfif NOT isDefined("URL.area") AND NOT isDefined("URL.fileDownload")>
		<cflocation url="mobile.cfm?abb=#client_abb#" addtoken="no">
	<cfelseif isDefined("URL.fileDownload")>
		<cflocation url="mobile.cfm?#CGI.QUERY_STRING#" addtoken="no">
	<cfelse>
		<cfinclude template="#APPLICATION.htmlPath#/includes/url_redirect.cfm">
		<cflocation url="#redirect_page#" addtoken="no">
	</cfif>
	
<cfelse>
	
	<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->
	
		<cfif NOT isDefined("URL.area") AND NOT isDefined("URL.fileDownload")>
			<cflocation url="main.cfm?abb=#client_abb#" addtoken="no">
		<cfelse>
			<cflocation url="main.cfm?#CGI.QUERY_STRING#" addtoken="no">
		</cfif>
		
	<cfelse><!---VPNET--->
	
		<cfif NOT isDefined("URL.area") AND NOT isDefined("URL.fileDownload")>
			<cflocation url="organization.cfm?abb=#client_abb#" addtoken="no">
		<cfelse>
			<cflocation url="organization.cfm?#CGI.QUERY_STRING#" addtoken="no">
		</cfif>
	
	</cfif>
	
</cfif>