<!---Copyright Era7 Information Technologies 2007-2012

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
    Date of last file change: 30-05-2012
	
--->
<cfcomponent output="false">
	
	<cfset component = "UrlManager">
	
	
	
	<!--- ----------------------- getAreaUrl -------------------------------- --->
	<cffunction name="getAreaUrl" access="public" returntype="string">
		<cfargument name="area_id" type="numeric" required="yes">
		
		<cfset var itemUrl = "">
		
		<cfset itemUrl = "#APPLICATION.mainUrl##APPLICATION.path#/html/?area=#arguments.area_id#&abb=#SESSION.client_id#">
		
		<cfreturn itemUrl>
	</cffunction>
	
	
	<!--- ----------------------- getAreaItemUrl -------------------------------- --->
	<cffunction name="getAreaItemUrl" access="public" returntype="string">
		<cfargument name="item_id" type="numeric" required="yes">
		<cfargument name="itemTypeName" type="string" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">
		
		<cfset var itemUrl = "">
		
		<cfset itemUrl = "#APPLICATION.mainUrl##APPLICATION.path#/html/?area=#arguments.area_id#&#arguments.itemTypeName#=#arguments.item_id#&abb=#SESSION.client_id#">
		
		<cfreturn itemUrl>
	</cffunction>
	
	
	<!--- ----------------------- getAreaFileUrl -------------------------------- --->
	<cffunction name="getAreaFileUrl" access="public" returntype="string">
		<cfargument name="file_id" type="numeric" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">
		
		<cfset var fileUrl = "">
		
		<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/html/?area=#arguments.area_id#&file=#arguments.file_id#&abb=#SESSION.client_id#">
		
		<cfreturn fileUrl>
	</cffunction>
	
	
	<!--- ----------------------- getDownloadFileUrl -------------------------------- --->
	<cffunction name="getDownloadFileUrl" access="public" returntype="string">
		<cfargument name="file_id" type="numeric" required="yes">
		<cfargument name="item_id" type="numeric" required="no">
		<cfargument name="itemTypeName" type="string" required="no">
		
		<cfset var fileUrl = "">
		
		<cfif isDefined("arguments.item_id") AND isDefined("arguments.itemTypeName")>
			<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/html/?fileDownload=#arguments.file_id#&#itemTypeName#=#arguments.item_id#&abb=#SESSION.client_id#">
		<cfelse>
			<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/html/?fileDownload=#arguments.file_id#&abb=#SESSION.client_id#">		
		</cfif>
		
		<cfreturn fileUrl>
	</cffunction>
	
	
</cfcomponent>