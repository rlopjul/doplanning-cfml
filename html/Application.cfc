<!---Copyright Era7 Information Technologies 2007-2012

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 15-07-2009

--->

<cfcomponent displayname="Application CFC html restricted area" extends="../Application">


	<cffunction name="onRequestStart" output="false">

		<cfif getAuthUser() EQ "" OR NOT isDefined("SESSION.client_abb") OR (isDefined("URL.abb") AND URL.abb NEQ SESSION.client_abb)><!---No está logueado o el client_abb en el que está logueado no es el mismo del que se hace la petición--->

			<!---Para que pueda acceder al login hay que pasarle el client_abb--->
			<cfif isDefined("URL.abb")>
				<cfset destination_page = URLEncodedFormat(CGI.SCRIPT_NAME&"?"&CGI.QUERY_STRING)>
				<cflocation url="#APPLICATION.htmlPath#/login/?client_abb=#URL.abb#&dpage=#destination_page#" addtoken="no">
			<!---<cfelseif isDefined("APPLICATION.dpWebClientAbb") AND APPLICATION.dpWebClientAbb EQ "hcs">
				<cflocation url="#APPLICATION.htmlPath#/login/?client_abb=#APPLICATION.dpWebClientAbb#&dpage=#destination_page#" addtoken="no">--->
			<cfelseif isDefined("APPLICATION.dpWebClientAbb") AND ( APPLICATION.dpWebClientAbb NEQ "doplanning" AND APPLICATION.dpWebClientAbb NEQ "bioinformatics7" )>
				<cfset destination_page = URLEncodedFormat(CGI.SCRIPT_NAME&"?"&CGI.QUERY_STRING)>
				<cflocation url="#APPLICATION.htmlPath#/login/?client_abb=#APPLICATION.dpWebClientAbb#&dpage=#destination_page#" addtoken="no">
			<cfelse>
				<cflocation url="#APPLICATION.mainUrl#" addtoken="no">
			</cfif>

		</cfif>

	</cffunction>


</cfcomponent>
