<cfif isDefined("URL.area") AND isNumeric(URL.area)>
	
	<cfset area_id = URL.area>

	<cfinvoke component="#APPLICATION.componentsPath#/AreaManager" method="exportAreasStructure" returnvariable="exportAreasResponse">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>

	<cfif exportAreasResponse.result IS true>
		
		<cfset contentDisposition = "attachment; filename=area_#area_id#.xml;">
		<cfset contentType = "application/xml; charset=utf-8">

		<cfheader name="Content-Disposition" value="#contentDisposition#" charset="utf-8">
		<cfcontent type="#contentType#"><cfoutput>#exportAreasResponse.fileContent#</cfoutput></cfcontent>

	<cfelse>
		<cfoutput>#exportAreasResponse.message#</cfoutput>
	</cfif>

</cfif>
