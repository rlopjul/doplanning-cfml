<!---Copyright Era7 Information Technologies 2007-2012

	Date of file creation: 17-04-2012
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 02-05-2012
	
--->
<cfcomponent output="false">

	<cfset component = "AreaItemTree">
	<cfset request_component = "AreaManager">
	
	
	<cffunction name="outputAreaItemsTree" returntype="void" output="true" access="public">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		
		<cfset var method = "outputAreaItemsTree">
		
		<cfset var curItem = "">
		
		<!---<cftry>--->
			
			<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
			
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAreaItemsTree" returnvariable="xmlTreeResponse">
				<cfinvokeargument name="area_id" value="#arguments.area_id#">
				<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
			</cfinvoke>
			
			<cfxml variable="xmlItems">
				<cfoutput>
				#xmlTreeResponse.response.result['#itemTypeNameP#'][1]#
				</cfoutput>
			</cfxml>
			
			<!---<cfoutput>
			<textarea style="width:100%">#xmlItems#</textarea>
			</cfoutput>--->
			
			<cfif isDefined("xmlItems.#itemTypeNameP#.#itemTypeName#")>
			<ul>
			<cfloop index="curItem" array="#xmlItems['#itemTypeNameP#']['#itemTypeName#']#">
			
				<cfinvoke component="AreaItemTree" method="outputItem">
					<cfinvokeargument name="itemXml" value="#curItem#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>
				
			</cfloop>
			</ul>
			<cfelse>
				<script type="text/javascript">
					loadTree = false;
				</script>
				<cfoutput>
				<div class="div_messages">
				<div class="div_text_result">No hay #lCase(itemTypeNameEsP)# en esta área.</div>
				</div>
				</cfoutput>
			</cfif>

			
			<!---<cfcatch>
				<cfinclude template="includes/errorHandler.cfm">
			</cfcatch>										
			
		</cftry>--->
	</cffunction>
	
	
	<cffunction name="outputItem" returntype="void" output="true" access="public">
		<cfargument name="itemXml" type="xml">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">
		<!---<cfargument name="root_node" type="boolean" default="false">--->
		
		
		<cfset var method = "outputItem">
		
		<cfset var numSubItems = "">
		<cfset var curItem = "">
		
		<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
		
		<cfset url_return_page = URLEncodedFormat("#itemTypeNameP#.cfm?area=#arguments.area_id#&mode=tree")>
		
		<cfoutput>
		<li rel="#itemTypeName#">
			<a href="#itemTypeName#.cfm?#itemTypeName#=#itemXml.xmlAttributes.id#&return_page=#url_return_page#" class="jstree-node">#itemXml.xmlAttributes.title#&nbsp;&nbsp;&nbsp;<font class="div_tree_message_data">#itemXml.xmlAttributes.user_full_name#&nbsp;#itemXml.xmlAttributes.creation_date#</font></a>
		</cfoutput>
		
		<cfif isDefined("itemXml['#itemTypeName#']")>
			<ul>		
			<cfloop index="curItem" array="#itemXml['#itemTypeName#']#">
				
				<cfinvoke component="AreaItemTree" method="outputItem">
					<cfinvokeargument name="itemXml" value="#curItem#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
				</cfinvoke>	
			
			</cfloop>
			</ul>
		</cfif>
		</li>

	</cffunction>
	
	
</cfcomponent>