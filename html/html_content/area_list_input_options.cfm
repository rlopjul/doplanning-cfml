<cfif isDefined("URL.area") AND isNumeric(URL.area)>
	
	<cfset area_id = URL.area>

	<cfif isDefined("URL.selected") AND isNumeric(URL.selected)>
		<cfset selected_areas_ids = URL.selected>	
	</cfif>

	<option value=""></option>
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="outputSubAreasSelect">
		<cfinvokeargument name="area_id" value="#area_id#">
		<cfif isDefined("selected_areas_ids")>
			<cfinvokeargument name="selected_areas_ids" value="#selected_areas_ids#">
		</cfif>
		<cfinvokeargument name="recursive" value="false">
	</cfinvoke>	

</cfif>