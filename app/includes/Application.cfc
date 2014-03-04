<!---Copyright Era7 Information Technologies 2007-2012

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 23-05-2012
	
--->

<cfcomponent displayname="Application CFC app includes" extends="../../Application">
	
	
	<cffunction name="onRequestStart" output="false">	
		
		<cflocation url="#APPLICATION.mainUrl#" addtoken="no">
		
	</cffunction>
	

</cfcomponent>