<cfcomponent displayname="Application CFC restricted area" extends="/.Application">
	
	<cffunction name="onRequestStart" output="true" returntype="void">

		<cflocation url="#APPLICATION.mainUrl#" addtoken="no">
		
	</cffunction>
	
</cfcomponent>