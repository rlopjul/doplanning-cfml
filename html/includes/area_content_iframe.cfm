<cfif isDefined("URL.area")><!---Si se le pasa area_id por URL--->

	<cfset area_id = int(URL.area)>
	
	<!---area_allowed--->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="canUserAccessToArea" returnvariable="area_allowed">
		<cfinvokeargument name="area_id" value="#area_id#">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getAreaContent" returnvariable="xmlResponse">
		<cfinvokeargument name="area_id" value="#area_id#">
		<cfinvokeargument name="allowed" value="#area_allowed#">
	</cfinvoke>
	
	<cfxml variable="xmlAreas">
		<cfoutput>
		#xmlResponse.area#
		</cfoutput>
	</cfxml>
	
	<cfset parent_area_id = xmlAreas.area.xmlAttributes.parent_id>
	
	<cfif isValid("integer",parent_area_id)>
		<cfset return_page = "area.cfm?area=#parent_area_id#">
	<cfelse>
		<cfset return_page = "area.cfm">
	</cfif>
	
	<cfset area_name = xmlAreas.area.xmlAttributes.name>
	<cfset area_allowed = xmlAreas.area.xmlAttributes.allowed>
	<cfset area_type = xmlAreas.area.xmlAttributes.type>
	<cfset numAreas = ArrayLen(xmlAreas.area.XmlChildren)>

	<cfinclude template="area_menu.cfm">

</cfif>