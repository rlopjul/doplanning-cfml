<!---Copyright Era7 Information Technologies 2007-2013

	Date of file creation: 17-04-2012
	File created by: alucena
	ColdFusion version required: 8
	Last file change by: alucena
	Date of last file change: 13-02-2013
	
--->
<cfcomponent output="false">

	<cfset component = "AreaItemTree">
	<cfset request_component = "AreaManager">

	
	<cffunction name="outputItem" returntype="void" output="true" access="public">
		<cfargument name="itemXml" type="xml">
		<cfargument name="itemTypeId" type="numeric" required="yes">
		<cfargument name="area_id" type="numeric" required="yes">
		<cfargument name="selected_item_id" type="numeric" required="no">		
		
		<cfset var method = "outputItem">
		
		<cfset var numSubItems = "">
		<cfset var curItem = "">
		<cfset var hasChildren = false>
		
		<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">
		
		<cfset url_return_page = URLEncodedFormat("#lCase(itemTypeNameP)#.cfm?area=#arguments.area_id#&mode=tree")>
		
		<cfif isDefined("itemXml['#itemTypeName#']")>
			<cfset hasChildren = true>
		</cfif>
		
		<cfset item_page_url = "#itemTypeName#.cfm?#itemTypeName#=#itemXml.xmlAttributes.id#&return_page=#url_return_page#">
		
		<!---Item selection--->
		<!---<cfset itemSelected = false>
		
		<cfif isDefined("arguments.selected_item_id") AND arguments.selected_item_id IS itemXml.xmlAttributes.id>
			<!---Esta acción solo se completa si está en la versión HTML2--->
			<script type="text/javascript">
				openUrlHtml2('#item_page_url#','itemIframe');
			</script>
			<cfset itemSelected = true>
		</cfif>--->
		
		
		<cfoutput>
		<li id="#itemXml.xmlAttributes.id#" rel="#itemTypeName#"<!---<cfif hasChildren IS true>class="jstree-open"</cfif>--->>
			<!---DESHABILITADO TEMPORALMENTE porque el nuevo jsTree no permite mostrar imágenes dentro de un nodo
			<cfif isDefined("itemXml.xmlAttributes.user_image_type")>
				<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#itemXml.xmlAttributes.user_in_charge#&type=#itemXml.xmlAttributes.user_image_type#&small=" alt="#itemXml.xmlAttributes.user_full_name#" class="item_img" style="margin-right:2px;"/>
			<cfelse>
				<cfif APPLICATION.identifier NEQ "vpnet"><!---DP--->
					<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#itemXml.xmlAttributes.user_full_name#" class="item_img_default" style="margin-right:2px;"/>
				<cfelse>
					<img src="#APPLICATION.htmlPath#/assets/icons/message.png" alt="#itemTypeNameEs#" class="item_img" style="margin-right:2px;"/>
				</cfif>
			</cfif>--->
			<a href="#item_page_url#"><!--- class="jstree-node"--->
			<cfif itemTypeId IS 7><!---Consultations--->
				<font class="div_tree_message_data">#itemXml.xmlAttributes.user_full_name#&nbsp;&nbsp;#itemXml.xmlAttributes.creation_date#</font>
			</cfif>
			
			#itemXml.xmlAttributes.title#&nbsp;
			<cfif isDefined("itemXml.xmlAttributes.attached_file_id")><!---Attached file--->
				<span onclick="downloadFile('#APPLICATION.htmlPath#/file_download.cfm?id=#itemXml.xmlAttributes.attached_file_id#&#itemTypeName#=#itemXml.xmlAttributes.id#',event)" title="Descargar archivo adjunto" style="font-size:14px;color:##0088CC"><i class="icon-paper-clip"></i></span>
			</cfif>
			<cfif itemTypeId IS 7><!---Consultations--->
				<cfif isDefined("itemXml.xmlAttributes.attached_image_id")><!---Attached image--->
					<span onclick="downloadFile('#APPLICATION.htmlPath#/file_download.cfm?id=#itemXml.xmlAttributes.attached_image_id#&#itemTypeName#=#itemXml.xmlAttributes.id#',event)" title="Descargar imagen adjunta" style="font-size:14px;color:##0088CC"><i class="icon-camera"></i></span>	
				</cfif>
				&nbsp;
				<font class="div_tree_message_data" lang="es"><cfswitch expression="#itemXml.xmlAttributes.state#">
								<cfcase value="created"></cfcase>
								<cfcase value="read">Leída</cfcase>
								<cfcase value="answered">Respondida</cfcase>
								<cfcase value="closed">Cerrada</cfcase>
							</cfswitch></font>
			<cfelse><!---Messages--->
				<font class="div_tree_message_data">#itemXml.xmlAttributes.user_full_name#&nbsp;&nbsp;#left(itemXml.xmlAttributes.creation_date, findOneOf(" ",itemXml.xmlAttributes.creation_date))#</font>
			</cfif>
			</a>
		</cfoutput>
		
		<cfif hasChildren IS true>
			<ul>		
			<cfloop index="curItem" array="#itemXml['#itemTypeName#']#">
				
				<cfinvoke component="AreaItemTree" method="outputItem">
					<cfinvokeargument name="itemXml" value="#curItem#">
					<cfinvokeargument name="itemTypeId" value="#arguments.itemTypeId#">
					<cfinvokeargument name="area_id" value="#arguments.area_id#">
					<cfinvokeargument name="selected_item_id" value="#arguments.selected_item_id#">
				</cfinvoke>	
			
			</cfloop>
			</ul>
		</cfif>
		</li>

	</cffunction>
	
	
</cfcomponent>