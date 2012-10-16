<!---Copyright Era7 Information Technologies 2007-2008

	Date of file creation: 02-10-2008
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 02-10-2008
	
--->
<cfcomponent output="false">

	<cfset component = "Error">
	<cfset request_component = "ErrorManager">
	
	
	<cffunction name="showError" returntype="xml" access="public">
		<cfargument name="error_code" type="numeric" required="true">
		
		<cfset var method = "showError">
		
		<cftry>
						
			<cflocation url="#APPLICATION.htmlPath#/error.cfm?error_code=#error_code#" addtoken="no">
				
			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
		
		<cfreturn xmlResponse>
		
	</cffunction>
	
	
</cfcomponent>