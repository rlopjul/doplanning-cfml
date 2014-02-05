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
		
		<cfset var areaUrl = "">
		
		<!---<cfset areaUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?area=#arguments.area_id#&abb=#SESSION.client_abb#">--->
		<cfset areaUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#SESSION.client_abb#&area=#arguments.area_id#">
		
		<cfreturn areaUrl>
	</cffunction>
	
	
	<!--- ----------------------- getAreaFileUrl -------------------------------- --->
	<cffunction name="getAreaFileUrl" access="public" returntype="string">
		<cfargument name="file_id" type="numeric" required="yes">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="yes">
		
		<cfset var fileUrl = "">

		<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">
		
		<!---<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?area=#arguments.area_id#&file=#arguments.file_id#&abb=#SESSION.client_abb#">--->
		<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#SESSION.client_abb#&area=#arguments.area_id#&#fileTypeName#=#arguments.file_id#">
		
		<cfreturn fileUrl>
	</cffunction>
	
	
	<!--- ----------------------- getDownloadFileUrl -------------------------------- --->
	<cffunction name="getDownloadFileUrl" access="public" returntype="string">
		<cfargument name="file_id" type="numeric" required="yes">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="item_id" type="numeric" required="no">
		<cfargument name="itemTypeName" type="string" required="no">
		
		<cfset var fileUrl = "">

		<cfinclude template="#APPLICATION.corePath#/includes/fileTypeSwitch.cfm">
		
		<cfif isDefined("arguments.item_id") AND isDefined("arguments.itemTypeName")>
			<!---<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?fileDownload=#arguments.file_id#&#itemTypeName#=#arguments.item_id#&abb=#SESSION.client_abb#">--->
			<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#SESSION.client_abb#&fileDownload=#arguments.file_id#&fileTypeId=#arguments.fileTypeId#&#itemTypeName#=#arguments.item_id#">
		<cfelse>
			<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#SESSION.client_abb#&fileDownload=#arguments.file_id#&fileTypeId=#arguments.fileTypeId#">		
		</cfif>
		
		<cfreturn fileUrl>
	</cffunction>


	<!--- ----------------------- getAreaItemUrl -------------------------------- --->
	<cffunction name="getAreaItemUrl" access="public" returntype="string">
		<cfargument name="item_id" type="numeric" required="yes">
		<cfargument name="itemTypeName" type="string" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">

		<cfargument name="client_abb" type="string" required="true">
		
		<cfset var itemUrl = "">
		
		<!---<cfset itemUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?area=#arguments.area_id#&#arguments.itemTypeName#=#arguments.item_id#&abb=#SESSION.client_abb#">--->
		<cfset itemUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#arguments.client_abb#&area=#arguments.area_id#&#arguments.itemTypeName#=#arguments.item_id#">		
		
		<cfreturn itemUrl>
	</cffunction>
	
	
	<!--- ----------------------- getTableRowUrl -------------------------------- --->
	<cffunction name="getTableRowUrl" access="public" returntype="string">
		<cfargument name="table_id" type="numeric" required="yes">
		<cfargument name="tableTypeName" type="string" required="yes">
		<cfargument name="row_id" type="numeric" required="yes">

		<cfargument name="client_abb" type="string" required="true">
		
		<cfset var rowUrl = "">
		
		<cfset rowUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#arguments.client_abb#&area=#arguments.area_id#&#arguments.tableTypeName#=#arguments.table_id#&row=#arguments.row_id#">		
		
		<cfreturn rowUrl>
	</cffunction>


	<!--- ----------------------- getViewRowUrl -------------------------------- --->
	<cffunction name="getViewRowUrl" access="public" returntype="string">
		<cfargument name="view_id" type="numeric" required="yes">
		<cfargument name="itemTypeName" type="string" required="yes">
		<cfargument name="row_id" type="numeric" required="yes">

		<cfargument name="client_abb" type="string" required="true">
		
		<cfset var rowUrl = "">
		
		<cfset rowUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#arguments.client_abb#&area=#arguments.area_id#&#arguments.itemTypeName#=#arguments.view_id#&row=#arguments.row_id#">		
		
		<cfreturn rowUrl>
	</cffunction>


	<!--- ----------------------- getAreaWebPage -------------------------------- --->

	<!---Para poder URLs absolutas es necesario saber la URL donde está publicada la web.
	Esta URL podría estar definida en base de datos en el cliente correspondiente.
	También es necesario saber en qué idioma está---->

	<cffunction name="getAreaWebPage" access="public" returntype="string">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="remove_order" type="boolean" required="true">
		
		<cfset var areaWebUrl = "">
		<cfset var pageTitle = "">
		
		<cfif arguments.remove_order IS true>
			<cfset pageTitle = mid(arguments.name, findOneOf(".-", arguments.name)+3, len(arguments.name))>
		<cfelse>
			<cfset pageTitle = arguments.name>
		</cfif>

		<cfset pageTitle = pageTitleToUrl(pageTitle)>

		<cfset areaWebUrl = "page.cfm?id=#arguments.area_id#&title=#pageTitle#">
		
		<cfreturn areaWebUrl>
	</cffunction>


	<!--- ----------------------- getItemWebPage -------------------------------- --->

	<!---Para poder URLs absolutas es necesario saber la URL donde está publicada la web.
	Esta URL podría estar definida en base de datos en el cliente correspondiente.
	También es necesario saber en qué idioma está---->

	<cffunction name="getItemWebPage" access="public" returntype="string">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">

		<cfset var pageName = "">
		<cfset var itemWebUrl = "">
		<cfset var pageTitle = "">

		<cfif arguments.itemTypeId IS 4>
			<cfset pageName = "noticia.cfm">
		<cfelse>
			<cfset pageName = "evento.cfm">
		</cfif>

		<cfset pageTitle = pageTitleToUrl(arguments.title)>

		<cfset itemWebUrl = "#pageName#?id=#arguments.item_id#&title=#pageTitle#">
		
		<cfreturn itemWebUrl>
	</cffunction>



	<!--- ----------------------- pageTitleToUrl -------------------------------- --->
	<cffunction name="pageTitleToUrl" access="public" returntype="string">
		<cfargument name="title" type="string" required="true">

		<cfset var titleUrl = "">

		<cfset titleUrl = lCase(trim(arguments.title))>
	
		<cfset titleUrl = replaceList(titleUrl," ,á,é,í,ó,ú,ñ", "-,a,e,i,o,u,n")>
	
		<!---Reemplazar comillas dobles por comillas simples--->
		<cfset titleUrl = replaceList(titleUrl, Chr(34), "")>

		<cfreturn titleUrl>
	</cffunction>

	
</cfcomponent>