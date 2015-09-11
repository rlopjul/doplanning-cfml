<cfif isDefined("URL.fileDownload") OR ( isDefined("URL.file") AND isDefined("URL.download") )>
	<cflocation url="#APPLICATION.htmlPath#/file_download.cfm?#CGI.QUERY_STRING#" addtoken="no">
<cfelse>

	<cfif isDefined("URL.abb")>
		<cfset client_abb = URL.abb>
	<cfelseif isDefined("SESSION.client_abb")>
		<cfset client_abb = SESSION.client_abb>
	<cfelse>
		<cflocation url="#APPLICATION.mainUrl#" addtoken="no">
	</cfif>

	<!---
	<cfset olderBrowser = false>
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="isMobileBrowser" returnvariable="isMobileBrowser">
	</cfinvoke>

	<cfif isMobileBrowser IS false>
		<cfif client_abb NEQ "agsna" AND ( FindNoCase('MSIE 6',CGI.HTTP_USER_AGENT) GT 0 OR FindNoCase('MSIE 7',CGI.HTTP_USER_AGENT) GT 0 OR ( FindNoCase('MSIE 8',CGI.HTTP_USER_AGENT) GT 0 AND client_abb EQ "hcs" ) ) AND FindNoCase('Opera',CGI.HTTP_USER_AGENT) LT 1><!--- Opción deshabilitada para el AGSNA para que siempre muestre la versión estándar. La última versión con pestaña Home no funciona en IE8 en el HCS por el tamaño del árbol --->
			<cfset olderBrowser = true>
		</cfif>
	</cfif>
	--->

	<!---<cfif isMobileBrowser IS true OR olderBrowser IS true>---><!---Mobile version--->

		<cfif isDefined("URL.area")>
			<cfinclude template="#APPLICATION.htmlPath#/includes/url_redirect.cfm">
			<cflocation url="#redirect_page#" addtoken="no">
		<cfelse>

			<cfinvoke component="#APPLICATION.htmlComponentsPath#/User" method="getUser" returnvariable="loggedUser">
				<cfinvokeargument name="user_id" value="#SESSION.user_id#">
			</cfinvoke>

			<cfif len(loggedUser.start_page) GT 0>
					<cflocation url="#APPLICATION.path#/html/#loggedUser.start_page#" addtoken="no">
			<cfelse>
					<cflocation url="#APPLICATION.path#/html/last_items.cfm?abb=#client_abb#" addtoken="no">
			</cfif>
			<!---<cflocation url="mobile.cfm?abb=#client_abb#" addtoken="no">--->

		</cfif>

	<!---<cfelse>

		<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->

			<cfif isDefined("URL.area")>
				<cflocation url="#APPLICATION.htmlPath#/main.cfm?#CGI.QUERY_STRING#" addtoken="no">
			<cfelse>
				<cflocation url="#APPLICATION.htmlPath#/main.cfm?abb=#client_abb#" addtoken="no">
			</cfif>

		<cfelse><!---VPNET--->

			<cfif isDefined("URL.area")>
				<cflocation url="#APPLICATION.htmlPath#/organization.cfm?#CGI.QUERY_STRING#" addtoken="no">
			<cfelse>
				<cflocation url="#APPLICATION.htmlPath#/organization.cfm?abb=#client_abb#" addtoken="no">
			</cfif>

		</cfif>

	</cfif>--->


</cfif>
