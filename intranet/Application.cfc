<!---Copyright Era7 Information Technologies 2007-2012

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 28-05-2012
	
--->

<cfcomponent displayname="Application CFC intranet restricted area" extends="../Application">
	
	
	<cffunction name="onRequestStart" output="false">	
		
		<cfif getAuthUser() EQ "" OR NOT isDefined("SESSION.client_abb")>
				
			<cfset destination_page = URLEncodedFormat(CGI.SCRIPT_NAME&"?"&CGI.QUERY_STRING)>
			<cflocation url="#APPLICATION.path#/intranet/login/?dpage=#destination_page#" addtoken="no">
			
		</cfif>
		
	</cffunction>
	

</cfcomponent>