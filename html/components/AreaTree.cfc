<!---Copyright Era7 Information Technologies 2007-2012

	Date of file creation: 17-04-2012
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 28-06-2012
	
--->
<cfcomponent output="false">

	<cfset component = "AreaTree">
	<cfset request_component = "AreaManager">
	
	<!---outputMainTree--->
	<cffunction name="outputMainTree" returntype="void" output="true" access="public">
		<cfargument name="with_input_type" type="string" required="no" default="">
		<cfargument name="disable_input_web" type="boolean" required="no" default="false"><!---Esto es para que no se puedan copiar mensajes a las áreas WEB--->
		<cfargument name="disable_input_area" type="boolean" required="no" default="false"><!---Esto es para que no se puedan copiar elementos WEB a las áreas no WEB--->
		
		<cfset var method = "outputMainTree">
		
		<cfset var curArea = "">
		
		<cftry>
			
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getMainTree" returnvariable="xmlGetMainTreeResponse">
			</cfinvoke>

			<cfxml variable="xmlAreas">
				<cfoutput>
				#xmlGetMainTreeResponse.response.result.areas[1]#
				</cfoutput>
			</cfxml>
			
			<!---<cfset numAreas = ArrayLen(xmlAreas.areas.XmlChildren)>--->
			
			<!---<cfoutput>
			<textarea style="width:100%">#xmlAreas#</textarea>
			</cfoutput>--->
			
			<ul>
			<cfloop index="curArea" array="#xmlAreas.areas.area#">
			
				<cfinvoke component="AreaTree" method="outputArea">
					<cfinvokeargument name="areaXml" value="#curArea#">
					<cfinvokeargument name="root_node" value="true">
					<cfinvokeargument name="with_input_type" value="#arguments.with_input_type#">
					<cfinvokeargument name="disable_input_web" value="#arguments.disable_input_web#">
					<cfinvokeargument name="disable_input_area" value="#arguments.disable_input_area#">
				</cfinvoke>
				
			</cfloop>
			</ul>

			
			<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>
	</cffunction>
	
	
	<!---outputArea--->
	<cffunction name="outputArea" returntype="void" output="true" access="public">
		<cfargument name="areaXml" type="xml">
		<cfargument name="root_node" type="boolean" default="false">
		<cfargument name="with_input_type" type="string" required="no" default="">
		<cfargument name="disable_input_web" type="boolean" required="no" default="false">
		<cfargument name="disable_input_area" type="boolean" required="no" default="false">
		
		<cfset var method = "outputTree">
		
		<cfset var numSubAreas = "">
		<cfset var curArea = "">
		<cfset var areaAllowed = "">
		<cfset var areaId = "">
		<cfset var input_name = "">
		
		<cfif arguments.with_input_type IS "checkbox">
			<cfset input_name = "areas_ids[]">
		<cfelse>
			<cfset input_name = "area_id">
		</cfif>		
		
		<cfset areaAllowed = areaXml.xmlAttributes.allowed>
		
		<cfif areaAllowed IS true><!---Área con acceso--->
			<cfif NOT isDefined("areaXml.xmlAttributes.type") OR areaXml.xmlAttributes.type EQ "">
				<cfset li_rel = "allowed">
				<cfset a_href = "messages.cfm?area=#areaXml.xmlAttributes.id#">
			<cfelse>
				<cfset li_rel = "allowed-web">
				<cfset a_href = "entries.cfm?area=#areaXml.xmlAttributes.id#">
			</cfif>			 
		<cfelse><!---Área sin acceso--->
			<cfif NOT isDefined("areaXml.xmlAttributes.type") OR areaXml.xmlAttributes.type EQ "">
				<cfset li_rel = "not-allowed">
			<cfelse>
				<cfset li_rel = "not-allowed-web">
			</cfif>	
			<cfset a_href = "area.cfm?area=#areaXml.xmlAttributes.id#">
		</cfif>
		
		<cfset areaId = areaXml.xmlAttributes.id>
		<cfset area_with_link = areaXml.xmlAttributes.with_link>
		
		<cfoutput>
		<li rel="#li_rel#" id="#areaId#" with_link="#area_with_link#" <cfif arguments.root_node IS true>class="jstree-open"</cfif>>
		<cfif len(arguments.with_input_type) GT 0><input type="#arguments.with_input_type#" name="#input_name#" value="#areaId#" id="area#areaId#" <cfif areaAllowed IS NOT true OR (arguments.disable_input_area IS true AND li_rel EQ "allowed") OR (arguments.disable_input_web IS true AND li_rel EQ "allowed-web")>disabled="disabled"</cfif>/><!---onClick="stopPropagation(event);"---></cfif>
		<a href="#a_href#" class="jstree-node">#areaXml.xmlAttributes.name#</a>
		</cfoutput>
		
		<cfif isDefined("areaXml.area")>
			<ul>		
			<cfloop index="curArea" array="#areaXml.area#">
				
				<cfinvoke component="AreaTree" method="outputArea">
					<cfinvokeargument name="areaXml" value="#curArea#">
					<cfinvokeargument name="with_input_type" value="#arguments.with_input_type#">
					<cfinvokeargument name="disable_input_web" value="#arguments.disable_input_web#">
					<cfinvokeargument name="disable_input_area" value="#arguments.disable_input_area#">
				</cfinvoke>	
			
			</cfloop>
			</ul>
		</cfif>
		</li>

	</cffunction>
	
	
</cfcomponent>