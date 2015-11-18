<!--- Copyright Era7 Information Technologies 2007-2014 --->

<cfcomponent displayname="Application CFC html restricted area" extends="../../Application">


	<cffunction name="onRequestStart" output="true">

		<cfif getAuthUser() EQ "" OR NOT isDefined("SESSION.client_abb") OR (isDefined("URL.abb") AND URL.abb NEQ SESSION.client_abb)><!---No está logueado o el client_abb en el que está logueado no es el mismo del que se hace la petición--->

			<!---Como esta página es un iframe, se redirige a la página iframe_login_redirect donde hay un script que redirige a la página padre--->
			<!---No se puede pasar la página de destino al login porque la página de destino es un iframe--->
			<cfif isDefined("URL.abb")>
				<cflocation url="#APPLICATION.htmlPath#/login/iframe_login_redirect.cfm?abb=#URL.abb#" addtoken="no">
			<cfelse>
				<cflocation url="#APPLICATION.htmlPath#/login/iframe_login_redirect.cfm" addtoken="no">
			</cfif>

		</cfif>

	</cffunction>


</cfcomponent>
