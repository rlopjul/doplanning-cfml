<!---Copyright Era7 Information Technologies 2007-2013

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
	
--->

<cfcomponent displayname="Application CFC app restricted area" extends="../../Application">
	
	
	<cffunction name="onRequestStart" output="false">	
		
		<cfif getAuthUser() EQ "" OR SESSION.client_administrator NEQ SESSION.user_id>
			<cflocation url="#APPLICATION.signOutUrl#" addtoken="no">
		</cfif>
		
	</cffunction>
	

</cfcomponent>