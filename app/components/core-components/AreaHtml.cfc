<!---Copyright Era7 Information Technologies 2007-2013--->
<cfcomponent output="true">
	
	<cfset component = "AreaHtml">


	<!--- ----------------------- outputSubAreasSelect -------------------------------- --->
	
	<cffunction name="outputSubAreasSelect" access="public" returntype="void" output="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="selected_areas_ids" type="string" required="false">
		<cfargument name="level" type="numeric" required="false" default="1">
		<cfargument name="recursive" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">	

		<cfset var areas = "">
		<cfset var spaces = "">
		<cfset var area_selected = false>

		<cfinvoke component="AreaQuery" method="getSubAreas" returnvariable="areas">
			<cfinvokeargument name="area_id" value="#arguments.area_id#">				
			<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
			<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
		</cfinvoke>

		<cfloop from="2" to="#arguments.level#" step="1" index="index">
			<cfset spaces = spaces&"&nbsp;&nbsp;&nbsp;">				
		</cfloop>

		<cfoutput>
		<cfloop query="areas">
			<cfif isDefined("selected_areas_ids") AND listFind(arguments.selected_areas_ids, areas.id) GT 0>
				<cfset area_selected = true>
			<cfelse>
				<cfset area_selected = false>
			</cfif>
			<option value="#areas.id#" <cfif area_selected>selected</cfif>>#spaces##areas.name#</option>
			<cfif arguments.recursive IS true>
				<cfinvoke component="AreaHtml" method="outputSubAreasSelect">
					<cfinvokeargument name="area_id" value="#areas.id#"/>
					<cfif isDefined("arguments.selected_areas_ids")>
						<cfinvokeargument name="selected_areas_ids" value="#arguments.selected_areas_ids#">
					</cfif>
					<cfinvokeargument name="level" value="#arguments.level+1#">
					<cfinvokeargument name="recursive" value="true">

					<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
					<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
				</cfinvoke>
			</cfif>				
		</cfloop>
		</cfoutput>

	</cffunction>

</cfcomponent>