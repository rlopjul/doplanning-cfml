<!---Copyright Era7 Information Technologies 2007-2013--->
<cfcomponent output="true">
	
	<cfset component = "AreaHtml">


	<!--- ----------------------- outputSubAreasSelect -------------------------------- --->
	
	<cffunction name="outputSubAreasSelect" access="public" returntype="void" output="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="subAreas" type="query" required="false">
		<cfargument name="selected_areas_ids" type="string" required="false">
		<cfargument name="level" type="numeric" required="false" default="1">
		<cfargument name="recursive" type="boolean" required="false" default="false">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">	

		<cfset var spaces = "">
		<cfset var area_selected = false>

		<cfif NOT isDefined("arguments.subAreas")>

			<cfinvoke component="AreaQuery" method="getSubAreas" returnvariable="subAreas">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">				
				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

		</cfif>

		<cfloop from="2" to="#arguments.level#" step="1" index="index">
			<cfset spaces = spaces&"&nbsp;&nbsp;&nbsp;">				
		</cfloop>

		<cfoutput>
		<cfloop query="subAreas">
			<cfif isDefined("selected_areas_ids") AND listFind(arguments.selected_areas_ids, subAreas.id) GT 0>
				<cfset area_selected = true>
			<cfelse>
				<cfset area_selected = false>
			</cfif>
			<option value="#subAreas.id#" <cfif area_selected>selected</cfif>>#spaces##subAreas.name#</option>
			<cfif arguments.recursive IS true>
				<cfinvoke component="AreaHtml" method="outputSubAreasSelect">
					<cfinvokeargument name="area_id" value="#subAreas.id#"/>
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


	<!--- ----------------------- outputSubAreasInput -------------------------------- --->
	
	<cffunction name="outputSubAreasInput" access="public" returntype="void" output="true">
		<cfargument name="area_id" type="numeric" required="true">
		<cfargument name="subAreas" type="query" required="false">
		<cfargument name="selected_areas_ids" type="string" required="false">
		<cfargument name="level" type="numeric" required="false" default="1">
		<cfargument name="recursive" type="boolean" required="false" default="false">
		<cfargument name="field_name" type="string" required="true">
		<cfargument name="field_input_type" type="string" required="true">

		<cfargument name="client_abb" type="string" required="true">
		<cfargument name="client_dsn" type="string" required="true">	

		<cfset var spaces = "">
		<cfset var area_selected = false>

		<cfif NOT isDefined("arguments.subAreas")>
			
			<cfinvoke component="AreaQuery" method="getSubAreas" returnvariable="subAreas">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">				
				<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
				<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
			</cfinvoke>

		</cfif>

		<cfloop from="2" to="#arguments.level#" step="1" index="index">
			<cfset spaces = spaces&"&nbsp;&nbsp;&nbsp;">				
		</cfloop>

		<!---<div class="row">
			<div class="col-sm-offset-1 col-sm-10" style="margin-bottom:10px;">--->
			
			<cfoutput>
			<cfloop query="subAreas">
				<cfif isDefined("selected_areas_ids") AND listFind(arguments.selected_areas_ids, subAreas.id) GT 0>
					<cfset area_selected = true>
				<cfelse>
					<cfset area_selected = false>
				</cfif>

				<div class="radio">
				  <label>
				    #spaces#<input type="#arguments.field_input_type#" name="#arguments.field_name#[]" value="#subAreas.id#" <cfif area_selected>checked</cfif> />&nbsp;#subAreas.name#
				  </label>
				</div>
				<div class="clearfix"></div>

				<cfif arguments.recursive IS true>
					<cfinvoke component="AreaHtml" method="outputSubAreasInput">
						<cfinvokeargument name="area_id" value="#subAreas.id#"/>
						<cfif isDefined("arguments.selected_areas_ids")>
							<cfinvokeargument name="selected_areas_ids" value="#arguments.selected_areas_ids#">
						</cfif>
						<cfinvokeargument name="level" value="#arguments.level+1#">
						<cfinvokeargument name="recursive" value="true">
						<cfinvokeargument name="field_input_type" value="#arguments.field_input_type#">

						<cfinvokeargument name="client_abb" value="#arguments.client_abb#">
						<cfinvokeargument name="client_dsn" value="#arguments.client_dsn#">
					</cfinvoke>
				</cfif>				
			</cfloop>
			</cfoutput>
			
			<!---</div>
		</div>--->

	</cffunction>


</cfcomponent>