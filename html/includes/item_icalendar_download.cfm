<cfif isDefined("URL.item") AND isNumeric(URL.item) AND isDefined("URL.itemTypeId") AND isNumeric(itemTypeId)>

	<cfset item_id = URL.item>
	<cfset itemTypeId = URL.itemTypeId>

	<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="exportICalendarItem" returnvariable="exportICalendarItemResponse">
		<cfinvokeargument name="item_id" value="#item_id#">
		<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	</cfinvoke>

	<cfcontent type="text/calendar" reset="Yes">
   	<cfheader name="Content-Disposition" value="inline; filename=calendar_#itemTypeName#_#item_id#.ics">

	<cfoutput>
	#exportICalendarItemResponse.icalendar#
	</cfoutput>

</cfif>