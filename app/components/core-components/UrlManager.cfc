<!---Copyright Era7 Information Technologies 2007-2013

    File created by: alucena
    ColdFusion version required: 8
    Last file change by: alucena
	
	17-01-2013 alucena: cambiada la url de los elementos, quitado /html/
	22-04-2013 alucena: cambiado client_id por client_abb en las URLs con abb=
	
--->
<cfcomponent output="false">
	
	<cfset component = "UrlManager">
	
	
	
	<!--- ----------------------- getAreaUrl -------------------------------- --->
	<cffunction name="getAreaUrl" access="public" returntype="string">
		<cfargument name="area_id" type="numeric" required="yes">
		
		<cfset var itemUrl = "">
		
		<!---<cfset itemUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?area=#arguments.area_id#&abb=#SESSION.client_abb#">--->
		<cfset itemUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#SESSION.client_abb#&area=#arguments.area_id#">
		
		<cfreturn itemUrl>
	</cffunction>
	
	
	<!--- ----------------------- getAreaItemUrl -------------------------------- --->
	<cffunction name="getAreaItemUrl" access="public" returntype="string">
		<cfargument name="item_id" type="numeric" required="yes">
		<cfargument name="itemTypeName" type="string" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">
		
		<cfset var itemUrl = "">
		
		<!---<cfset itemUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?area=#arguments.area_id#&#arguments.itemTypeName#=#arguments.item_id#&abb=#SESSION.client_abb#">--->
		<cfset itemUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#SESSION.client_abb#&area=#arguments.area_id#&#arguments.itemTypeName#=#arguments.item_id#">		
		
		<cfreturn itemUrl>
	</cffunction>
	
	
	<!--- ----------------------- getAreaFileUrl -------------------------------- --->
	<cffunction name="getAreaFileUrl" access="public" returntype="string">
		<cfargument name="file_id" type="numeric" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">
		
		<cfset var fileUrl = "">
		
		<!---<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?area=#arguments.area_id#&file=#arguments.file_id#&abb=#SESSION.client_abb#">--->
		<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#SESSION.client_abb#&area=#arguments.area_id#&file=#arguments.file_id#">
		
		<cfreturn fileUrl>
	</cffunction>
	
	
	<!--- ----------------------- getDownloadFileUrl -------------------------------- --->
	<cffunction name="getDownloadFileUrl" access="public" returntype="string">
		<cfargument name="file_id" type="numeric" required="yes">
		<cfargument name="item_id" type="numeric" required="no">
		<cfargument name="itemTypeName" type="string" required="no">
		
		<cfset var fileUrl = "">
		
		<cfif isDefined("arguments.item_id") AND isDefined("arguments.itemTypeName")>
			<!---<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?fileDownload=#arguments.file_id#&#itemTypeName#=#arguments.item_id#&abb=#SESSION.client_abb#">--->
			<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#SESSION.client_abb#&fileDownload=#arguments.file_id#&#itemTypeName#=#arguments.item_id#">
		<cfelse>
			<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#SESSION.client_abb#&fileDownload=#arguments.file_id#">		
		</cfif>
		
		<cfreturn fileUrl>
	</cffunction>
	
	
</cfcomponent>