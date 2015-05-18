<!--- Copyright Era7 Information Technologies 2007-2014 --->
<cfcomponent output="false">
	
	<cfset component = "UrlManager">
	
	
	<!--- ----------------------- getAreaUrl -------------------------------- --->
	<cffunction name="getAreaUrl" access="public" returntype="string">
		<cfargument name="area_id" type="numeric" required="yes">

		<cfargument name="client_abb" type="string" required="true">
		
		<cfset var areaUrl = "">
		
		<!---<cfset areaUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?area=#arguments.area_id#&abb=#SESSION.client_abb#">--->
		<cfset areaUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#arguments.client_abb#&area=#arguments.area_id#">
		
		<cfreturn areaUrl>
	</cffunction>
	
	
	<!--- ----------------------- getAreaFileUrl -------------------------------- --->
	<cffunction name="getAreaFileUrl" access="public" returntype="string">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="download" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		
		<cfset var fileUrl = "">
		
		<!---<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?area=#arguments.area_id#&file=#arguments.file_id#&abb=#arguments.client_abb#">--->

		<cfif arguments.download IS true>
			<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#arguments.client_abb#&area=#arguments.area_id#&file=#arguments.file_id#&download=1">
		<cfelse>
			<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#arguments.client_abb#&area=#arguments.area_id#&file=#arguments.file_id#">
		</cfif>
		
		
		<cfreturn fileUrl>
	</cffunction>
	
	
	<!--- ----------------------- getDownloadFileUrl -------------------------------- --->
	<cffunction name="getDownloadFileUrl" access="public" returntype="string">
		<cfargument name="file_id" type="numeric" required="yes">
		<cfargument name="fileTypeId" type="numeric" required="true">
		<cfargument name="item_id" type="numeric" required="no">
		<cfargument name="itemTypeName" type="string" required="no">

		<cfargument name="client_abb" type="string" required="true">
		
		<cfset var fileUrl = "">
		
		<!---<cfif isDefined("arguments.item_id") AND isDefined("arguments.itemTypeName")>
			<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#arguments.client_abb#&fileDownload=#arguments.file_id#&#arguments.itemTypeName#=#arguments.item_id#">
		<cfelse>
			<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#arguments.client_abb#&fileDownload=#arguments.file_id#">		
		</cfif>--->

		<cfif isDefined("arguments.item_id") AND isDefined("arguments.itemTypeName")>
			<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#arguments.client_abb#&file=#arguments.file_id#&download&#arguments.itemTypeName#=#arguments.item_id#">
		<cfelse>
			<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#arguments.client_abb#&file=#arguments.file_id#&download">		
		</cfif>
		
		<cfreturn fileUrl>
	</cffunction>


	<!--- ----------------------- getFilePublicUrl -------------------------------- --->
	<cffunction name="getFilePublicUrl" access="public" returntype="string">
		<cfargument name="file_public_id" type="string" required="yes">

		<cfargument name="client_abb" type="string" required="true">
		
		<cfset var fileUrl = "">
		
		<cfset fileUrl = "#APPLICATION.mainUrl##APPLICATION.path#/?abb=#arguments.client_abb#&file_public=#arguments.file_public_id#">
		
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

	<cffunction name="getAreaWebPage" access="public" returntype="string">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="remove_order" type="boolean" required="true">
		
		<cfargument name="preview" type="boolean" required="false" default="false">

		<cfset var areaWebUrl = "">
		<cfset var pageTitle = "">
		
		<cfif arguments.remove_order IS true>
			<cfif find(".- ", arguments.name) GT 0>
				<cfset pageTitle = mid(arguments.name, find(".- ", arguments.name)+3, len(arguments.name))>
			<cfelseif find(".-", arguments.name) GT 0>
				<cfset pageTitle = mid(arguments.name, find(".-", arguments.name)+2, len(arguments.name))>
			<cfelse>
				<cfset pageTitle = arguments.name>
			</cfif>
		<cfelse>
			<cfset pageTitle = arguments.name>
		</cfif>

		<cfset pageTitle = pageTitleToUrl(pageTitle)>

		<cfset areaWebUrl = "page.cfm?id=#arguments.area_id#&amp;title=#pageTitle#">

		<cfif arguments.preview IS true>
			<cfset areaWebUrl = areaWebUrl&"&amp;preview=1">
		</cfif>
		
		<cfreturn areaWebUrl>
	</cffunction>


	<!--- ----------------------- getAreaWebPageFullUrl -------------------------------- --->

	<!---Para definir URLs absolutas es necesario saber la URL donde está publicada la web--->

	<cffunction name="getAreaWebPageFullUrl" access="public" returntype="string">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="remove_order" type="boolean" required="true">
		<cfargument name="path_url" type="string" required="true">
		<cfargument name="path" type="string" required="true">

		<cfargument name="preview" type="boolean" required="false" default="false">
		
		<cfset var areaWebUrl = "">
		
		<cfinvoke component="UrlManager" method="getAreaWebPage" returnvariable="areaPage">
			<cfinvokeargument name="area_id" value="#arguments.area_id#">
			<cfinvokeargument name="name" value="#arguments.name#">
			<cfinvokeargument name="remove_order" value="#arguments.remove_order#">
		</cfinvoke>

		<cfset areaWebUrl = arguments.path_url&"/"&arguments.path&"/"&areaPage>
		
		<cfif arguments.preview IS true>
			<cfset areaWebUrl = areaWebUrl&"&amp;preview=1">
		</cfif>

		<cfreturn areaWebUrl>
	</cffunction>


	<!--- ----------------------- getItemWebPage -------------------------------- --->

	<cffunction name="getItemWebPage" access="public" returntype="string">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">

		<cfset var pageName = "">
		<cfset var itemWebUrl = "">
		<cfset var pageTitle = "">

		<cfset pageTitle = pageTitleToUrl(arguments.title)>

		<!---
		DPWebs antiguos con páginas para noticia y evento
		<cfif arguments.itemTypeId IS 4>
			<cfset pageName = "noticia.cfm">
		<cfelse>
			<cfset pageName = "evento.cfm">
		</cfif>
		<cfset itemWebUrl = "#pageName#?id=#arguments.item_id#&title=#pageTitle#">
		--->

		<cfif arguments.itemTypeId IS 4>
			<cfset itemType = "news">
		<cfelse>
			<cfset itemType = "event">
		</cfif>

		<cfset itemWebUrl = "page.cfm?#itemType#=#arguments.item_id#&amp;title=#pageTitle#">
		
		<cfreturn itemWebUrl>
	</cffunction>


	<!--- ----------------------- getItemWebPageFullUrl -------------------------------- --->

	<!---Para poder URLs absolutas es necesario saber la URL donde está publicada la web--->

	<cffunction name="getItemWebPageFullUrl" access="public" returntype="string">
		<cfargument name="item_id" type="numeric" required="true">
		<cfargument name="itemTypeId" type="numeric" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="path_url" type="string" required="true">
		<cfargument name="path" type="string" required="true">

		<cfset var itemWebUrl = "">
		
		<cfinvoke component="UrlManager" method="getItemWebPage" returnvariable="itemPage">
			<cfinvokeargument name="item_id" value="#arguments.item_id#">
			<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
			<cfinvokeargument name="title" value="#arguments.title#"/>
		</cfinvoke>

		<cfset itemWebUrl = arguments.path_url&"/"&arguments.path&"/"&itemPage>
		
		<cfreturn itemWebUrl>
	</cffunction>


	<!--- ----------------------- pageTitleToUrl -------------------------------- --->
	<cffunction name="pageTitleToUrl" access="public" returntype="string">
		<cfargument name="title" type="string" required="true">

		<cfset var titleUrl = "">

		<cfset titleUrl = lCase(trim(arguments.title))>
	
		<!---<cfset titleUrl = replaceList(titleUrl," ,á,é,í,ó,ú,ñ", "-,a,e,i,o,u,n")>--->
		<cfset titleUrl = replaceList(titleUrl," ,á,é,í,ó,ú,ñ,%", "-,a,e,i,o,u,n,%25")>
	
		<!---Reemplazar comillas dobles por comillas simples--->
		<cfset titleUrl = replaceList(titleUrl, Chr(34), "")>

		<!---<cfset titleUrl = URLEncodedFormat(titleUrl)>--->

		<cfreturn titleUrl>
	</cffunction>


	<!--- ----------------------- getFileWebPage -------------------------------- --->

	<cffunction name="getFileWebPage" access="public" returntype="string">
		<cfargument name="file_id" type="numeric" required="true">
		<cfargument name="area_id" type="numeric" required="false">

		<cfset var fileWebUrl = "">

		<cfset fileWebUrl = "download_file.cfm?file=#arguments.file_id#">

		<cfif isDefined("arguments.area_id")>
			
			<cfset fileWebUrl = fileWebUrl&"&area=#arguments.area_id#">

		</cfif>

		<cfset fileWebUrl = fileWebUrl&"&open">
		
		<cfreturn fileWebUrl>
	</cffunction>

	
</cfcomponent>