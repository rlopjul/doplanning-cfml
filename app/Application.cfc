<!---Copyright Era7 Information Technologies 2007-2008

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 17-09-2008
	
--->

<cfcomponent displayname="Application CFC app restricted area" extends="../Application">
	
	
	<cffunction name="onRequestStart" output="false">	
		
		<cfif getAuthUser() EQ "">
			<cfif #CGI.SCRIPT_NAME# NEQ "#APPLICATION.componentsPath#/LoginManager.cfc">			
				<cflocation url="#APPLICATION.signOutUrl#" addtoken="no">
			</cfif>
		</cfif>
		
	</cffunction>
	

</cfcomponent>