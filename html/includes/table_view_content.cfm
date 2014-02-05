<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_content_en.js" charset="utf-8"></script>
</cfoutput>

<cfinclude template="#APPLICATION.corePath#/includes/areaItemTypeSwitch.cfm">

<cfif isDefined("URL.#itemTypeName#") AND isNumeric(URL[itemTypeName])>
	<cfset view_id = URL[itemTypeName]>
<cfelse>
	<cflocation url="empty.cfm" addtoken="false">
</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/View" method="getView" returnvariable="objectItem">
	<cfinvokeargument name="view_id" value="#view_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>

<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="objectItem">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>--->

<cfset area_id = objectItem.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<script type="text/javascript">
	<!---Esto es para evitar que se abran enlaces en el iframe--->
	$(document).ready( function(){
		$('.dropdown-toggle').dropdown();
		$(".div_message_page_description a").attr('target','_blank');
	}); 
</script>

<cfif app_version NEQ "html2">
	<div class="div_head_subtitle">
	<cfoutput>
	<span lang="es">#itemTypeNameEs#</span>
	</cfoutput>
	</div>
</cfif>

<cfoutput>

<div class="div_message_page_title">#objectItem.title#</div>
<div class="div_separator"><!-- --></div>

<div class="div_elements_menu"><!---div_elements_menu--->
	
	<cfif isDefined("URL.return_page") AND len(URL.return_page) GT 0>
		<cfset url_return_page = "&return_page="&URLEncodedFormat("#return_path##URL.return_page#")>
	<cfelse>
		<cfset url_return_page = "&return_page="&URLEncodedFormat("#return_path##itemTypeNameP#.cfm?area=#area_id#")>
	</cfif>
	
	<!---is_user_table_area_responsible--->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="isUserAreaResponsible" returnvariable="is_user_table_area_responsible">				
		<cfinvokeargument name="area_id" value="#objectItem.table_area_id#">
	</cfinvoke>

	<cfif is_user_table_area_responsible><!--- Table Area Responsible --->

		
	</cfif>

	<cfif is_user_area_responsible><!--- Area Responsible --->
		
		

	</cfif>
		
	<!---<cfif app_version NEQ "mobile">
	<a href="#APPLICATION.htmlPath#/#itemTypeName#.cfm?#itemTypeName#=#view_id#" title="Abrir en nueva ventana" target="_blank" class="btn btn-default btn-sm" lang="es"><i class="icon-external-link"></i> <span lang="es">Ampliar</span></a>
	</cfif>--->

	<a href="#itemTypeName#_rows.cfm?#itemTypeName#=#view_id#&area=#objectItem.area_id#" class="btn btn-default btn-sm" title="Registros" lang="es"><i class="icon-list"></i> <span lang="es">Registros</span></a>
	
	
</div><!---END div_elements_menu--->

<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItem">
	<cfinvokeargument name="objectItem" value="#objectItem#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
	<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
	<cfinvokeargument name="area_type" value="#area_type#">
</cfinvoke>--->

<div class="div_message_page_message">

	<div class="div_message_page_label"><!---De:---> 
					
		<a href="area_user.cfm?area=#objectItem.area_id#&user=#objectItem.user_in_charge#"><cfif len(objectItem.user_image_type) GT 0>
			<img src="#APPLICATION.htmlPath#/download_user_image.cfm?id=#objectItem.user_in_charge#&type=#objectItem.user_image_type#&small=" alt="#objectItem.user_full_name#" class="item_img" style="margin-right:2px;"/>									
		<cfelse>							
			<img src="#APPLICATION.htmlPath#/assets/icons/user_default.png" alt="#objectItem.user_full_name#" class="item_img_default" style="margin-right:2px;"/>
		</cfif></a>
		
		<!---<span class="text_message_page">#objectItem.user_full_name#</span>--->
		<a href="area_user.cfm?area=#objectItem.area_id#&user=#objectItem.user_in_charge#">#objectItem.user_full_name#</a>
	</div>

	<div class="div_message_page_label">
		<span lang="es">#itemTypeNameEs#:</span>
		
		<a onclick="openUrl('area_items.cfm?area=#objectItem.table_area_id#&#tableTypeName#=#objectItem.table_id#','areaIframe',event)" style="cursor:pointer">#objectItem.table_title#</a>
	</div>

	<div class="div_message_page_label">
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="tableArea">
			<cfinvokeargument name="area_id" value="#objectItem.table_area_id#">
		</cfinvoke>

		<b><span lang="es">Propiedad del área:</span></b>
		
		<a onclick="openUrl('area_items.cfm?area=#objectItem.table_area_id#&#tableTypeName#=#objectItem.table_id#','areaIframe',event)" style="cursor:pointer">#tableArea.name#</a>
	</div>



	<!---itemUrl--->
	<cfinvoke component="#APPLICATION.coreComponentsPath#/UrlManager" method="getAreaItemUrl" returnvariable="areaItemUrl">
		<cfinvokeargument name="item_id" value="#objectItem.id#">
		<cfinvokeargument name="itemTypeName" value="#itemTypeName#">
		<cfinvokeargument name="area_id" value="#objectItem.area_id#">

		<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
	</cfinvoke>

	<div class="div_message_page_label"><span lang="es">URL en DoPlanning:</span></div>
	<input type="text" value="#areaItemUrl#" onClick="this.select();" class="form-control" readonly="readonly" style="cursor:text"/>
</div>
</cfoutput>