<cfoutput>

<!--- 
<script src="#APPLICATION.htmlPath#/language/area_item_en.js" charset="utf-8" type="text/javascript"></script>
 --->

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

<script src="#APPLICATION.path#/jquery/jquery.highlight.js"></script>

</cfoutput>

<cfif isDefined("URL.field") AND isDefined("URL.itemTypeId")>

	<cfset itemTypeId = URL.itemTypeId>
	<cfinclude template="#APPLICATION.resourcesPath#/includes/areaItemTypeSwitch.cfm">

	<cfset curElement = itemTypeNameP>

	<cfoutput>

	<div class="div_head_subtitle">
		<span lang="es">Selección de #itemTypeNameEs#</span>
	</div>

	<script>
		$(document).ready(function() { 

			<!---$("##submit_select").click(function(){ 
								
				var itemId = null;
				var itemName = "";

				// Selección de item
				itemId = $("##listTable tr.selected").data("item-id");
				
				if(itemId != null) {
			
					itemName = $("##listTable tr.selected a:first").text();

					window.opener.setSelectedItem(itemId, itemName, '#URL.field#');
					
					window.close();	

				}else{
					alert(window.lang.translate("No se ha seleccionado ningún elemento"));
				}

			});--->

			<!---$('##listTable').bind('select.tablesorter.select', function(e, ts){--->

			$('##listTable tbody tr').on('click', function(e) {
			   	var itemId = null;
				var itemName = "";

				<!---itemId = $("##listTable tr.selected").data("item-id");--->

				var $row = $(this);
				var itemId = $row.data("item-id");
				
				if(itemId != null) {
			
					<!---itemName = $("##listTable tr.selected a.text_item").text();--->

					itemName = $row.find("a.text_item").text();

					window.opener.setSelectedItem(itemId, itemName, '#URL.field#');
					window.close();	

				}else{
					alert(window.lang.translate("Selección incorrecta"));
				}
			    
			});

		}); 
	</script>

	<div class="container">
		<cfinclude template="#APPLICATION.htmlPath#/includes/search_2_bar.cfm">
	</div>

	<cfif isDefined("URL.search")>

		<cfif itemTypeId IS 10><!--- Files --->
		
			
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/File" method="getAllAreasFiles" argumentcollection="#URL#" returnvariable="getAllAreasFilesResponse">
				<cfif len(search_text) GT 0>
					<cfinvokeargument name="search_text" value="#search_text#">	
				</cfif>
				<cfif isNumeric(user_in_charge)>
					<cfinvokeargument name="user_in_charge" value="#user_in_charge#">
				</cfif>
			</cfinvoke>

			<cfset files = getAllAreasFilesResponse.files>

			<cfset numItems = files.recordCount>
			
			<div class="div_search_results_text" style="margin-bottom:5px; margin-top:5px;"><span lang="es">Resultado:</span> #numItems# <span lang="es"><cfif numItems IS 1>Archivo<cfelse>Archivos</cfif></span></div>

			<cfset full_content = true>
			<cfinclude template="#APPLICATION.htmlPath#/includes/file_list_content.cfm">


		<cfelse><!--- Items --->



			<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getAllAreasItems" returnvariable="getAllAreasItemsResponse">
				<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
				<cfif len(search_text) GT 0>
				<cfinvokeargument name="search_text" value="#search_text#">	
				</cfif>
				<cfif isNumeric(user_in_charge)>
				<cfinvokeargument name="user_in_charge" value="#user_in_charge#">
				</cfif>
				<cfif itemTypeId IS 6><!---Tasks--->
					<cfif isNumeric(recipient_user)>
						<cfinvokeargument name="recipient_user" value="#recipient_user#">
					</cfif>
					<cfif isNumeric(is_done)>
						<cfinvokeargument name="done" value="#is_done#">
					</cfif>
				</cfif>
				<cfif itemTypeId IS 7><!---Consultations--->
					<cfif len(cur_state) GT 0>
						<cfinvokeargument name="state" value="#cur_state#">
					</cfif>
				</cfif>
				<cfif isNumeric(limit_to)>
					<cfinvokeargument name="limit" value="#limit_to#">
				</cfif>
				
				<cfif len(from_date) GT 0>
					<cfinvokeargument name="from_date" value="#from_date#">
				</cfif>		
				
				<cfif len(end_date) GT 0>
					<cfinvokeargument name="end_date" value="#end_date#">
				</cfif>		
				
			</cfinvoke>
			
			<cfset areaItemsQuery = getAllAreasItemsResponse.query>

			<cfset numItems = areaItemsQuery.recordCount>
			<cfif numItems GT 0>
				<div class="div_search_results_text" style="margin-bottom:5px; margin-top:5px;"><span lang="es">Resultado:</span> #numItems# <span lang="es"><cfif numItems GT 1>#itemTypeNameEsP#<cfelse>#itemTypeNameEs#</cfif></span>
				</div>
				<div class="div_items">
				
				<!---<cfif itemTypeId IS NOT 6>
					<cfset current_url = "#lCase(itemTypeNameP)#_search.cfm?from_user=#user_in_charge#&limit=#limit_to#">
				<cfelse>
					<cfset current_url = "#lCase(itemTypeNameP)#_search.cfm?from_user=#user_in_charge#&to_user=#recipient_user#&limit=#limit_to#">
				</cfif>--->
				
				<cfif itemTypeId IS 7><!---Consultations--->

					<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputConsultationsList">
						<cfinvokeargument name="itemsQuery" value="#areaItemsQuery#">
						<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
						<cfinvokeargument name="full_content" value="true">
						<cfinvokeargument name="app_version" value="html2">
						<cfinvokeargument name="openItemOnSelect" value="false">
					</cfinvoke>

				<cfelseif itemTypeId IS 11 OR itemTypeId IS 12><!--- List AND Forms --->

					<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="outputTablesList">
						<cfinvokeargument name="itemsQuery" value="#areaItemsQuery#">
						<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
						<cfinvokeargument name="full_content" value="true">
						<cfinvokeargument name="app_version" value="html2">
						<cfinvokeargument name="openItemOnSelect" value="false">
					</cfinvoke>
			
				<cfelse>
				
					<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="outputItemsList">
						<cfinvokeargument name="itemsQuery" value="#areaItemsQuery#">
						<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
						<cfinvokeargument name="full_content" value="true">
						<cfinvokeargument name="app_version" value="html2">
						<cfinvokeargument name="openItemOnSelect" value="false">
					</cfinvoke>
				
				</cfif>
				
				</div>

				<!---<cfoutput>
				<div style="height:2px; clear:both;"><!-- --></div>
				<button type="button" id="submit_select" class="btn btn-primary" style="margin-left:5px;" lang="es">Asignar #itemTypeName# seleccionado</button>
				</cfoutput>--->

			<cfelse>
				<div class="div_items">
					<div class="div_text_result"><span lang="es">No hay #lCase(itemTypeNameEsP)#.</span></div>
				</div>
			</cfif>

		</cfif>

	<cfelse>

		<div class="alert alert-info" style="margin:10px;"><i class="icon-info-sign"></i>&nbsp;<span lang="es">Rellene el formulario y haga click en BUSCAR</span></div>

	</cfif>

	</cfoutput>

</cfif>