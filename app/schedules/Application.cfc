<!--- Copyright Era7 Information Technologies 2007-2015 --->

<cfcomponent extends="../../Application">

	<cffunction name="onRequestStart" output="false">

		<cfif CGI.REMOTE_ADDR NEQ "127.0.0.1" AND CGI.REMOTE_ADDR NEQ APPLICATION.serverIp>

			<cflocation url="#APPLICATION.signOutUrl#" addtoken="no">

		</cfif>

	</cffunction>

</cfcomponent>
