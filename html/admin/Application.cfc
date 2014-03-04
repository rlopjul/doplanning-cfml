<!---Copyright Era7 Information Technologies 2007-2013

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 24-06-2013
	
--->

<cfcomponent displayname="Application CFC html restricted area" extends="../Application">
	
	
	<cffunction name="onRequestStart" output="false">	
		
		<cfif getAuthUser() EQ "" OR NOT isDefined("SESSION.client_abb")><!---No está logueado o el client_abb en el que está logueado no es el mismo del que se hace la petición--->
				
			<cflocation url="#APPLICATION.mainUrl#" addtoken="no">
			
		</cfif>
		
	</cffunction>
	

</cfcomponent>