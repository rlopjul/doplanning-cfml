<!---Copyright Era7 Information Technologies 2007-2008

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 28-10-2008
	
--->

<cfcomponent displayname="Application CFC html restricted area" extends="../Application">
	
	
	<cffunction name="onRequestStart" output="true">	
		
		<cfif getAuthUser() EQ "">
			<!---Para que se fuera realmente al login hay que pasarle el client_abb--->
			<cflocation url="#APPLICATION.htmlPath#/login" addtoken="no">
		</cfif>
		
	</cffunction>
	

</cfcomponent>