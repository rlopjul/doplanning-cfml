
<cfif NOT isDefined("actions_selectable")>
	<cfset actions_selectable = false>
</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

<script>
	$(document).ready(function() { 
		
		<!---<cfif actions_selectable IS false>--->
			$("#dataTable").tablesorter({ 
				widgets: ['zebra','uitheme','select'],
				theme : "bootstrap",
				headerTemplate : '{content} {icon}',
				sortList: [[0,1]],
				headers: {
			      4: { sorter: "shortDate" },
			      5: { sorter: "shortDate" }
			    }
			});
		<!---<cfelse>
			$("#dataTable").tablesorter({ 
				widgets: ['zebra','uitheme'],
				theme : "bootstrap",
				headerTemplate : '{content} {icon}',
				sortList: [[5,0]] ,
				headers: {
			      0: { sorter: false }
			    }
			});
		</cfif>--->

	}); 
</script>

<cfset selectFirst = true>

<cfif isDefined("URL.action")>
	<cfset selectFirst = false>
</cfif>

<!---Table actions types--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Action" method="getActionTypes" returnvariable="typesResult">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>
<cfset actionTypesStruct = typesResult.actionTypes>

<cfoutput>
<table id="dataTable" class="data-table table-hover" style="margin-top:5px;">
	<thead>
		<tr>
			<cfif actions_selectable IS true>
			<th style="width:25px;text-align:center;"><input type="checkbox" name="select_all" checked="checked" onclick="toggleCheckboxesChecked(this.checked);"/></th>
			</cfif>
			<th style="width:25px;">##</th>
			<th style="width:35%"><span lang="es">Nombre de la acción</span></th>
			<th><span lang="es">Tipo de acción</span></th>
			<th><span lang="es">Evento</span></th>
			<th><span lang="es">Fecha de creación</span></th>
			<th><span lang="es">Fecha de última modificación</span></th>
			<th><span lang="es">Usuario creación</span></th>
			<th><span lang="es">Usuario última modificación</span></th>
		</tr>
	</thead>
	<tbody>

	<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>
	
	<cfset alreadySelected = false>

	<cfloop query="actions">

		
		<cfset rpage = "#tableTypeName#_actions.cfm?#tableTypeName#=#table_id#">

		<cfset action_page_url = "#tableTypeName#_action.cfm?action=#actions.action_id#&return_page=#URLEncodedFormat(rpage)#">

		<!---Row selection--->
		<cfset actionSelected = false>
		
		<!---<cfif actions_selectable IS false>
			
			<cfif alreadySelected IS false>

				<cfif ( isDefined("URL.action") AND URL.action IS actions.action_id ) OR ( selectFirst IS true AND actions.currentrow IS 1 AND app_version NEQ "mobile" ) >

					<!---Esta acción solo se completa si está en la versión HTML2--->
					<script type="text/javascript">
						openUrlHtml2('#action_page_url#','itemIframe');
					</script>

					<cfset actionSelected = true>
					<cfset alreadySelected = true>
																	
				</cfif>
				
			</cfif>

		</cfif>--->

		<tr <cfif actionSelected IS true>class="selected"</cfif> onclick="<cfif actions_selectable IS false>openUrl('#action_page_url#','itemIframe',event)<cfelse>toggleCheckboxChecked('##action_#actions.action_id#')</cfif>">
			<cfif actions_selectable IS true>
				<td style="text-align:center;"><input type="checkbox" name="actions_ids[]" id="action_#actions.action_id#" value="#actions.action_id#" checked="checked" onClick="stopPropagation(event);" /></td>
			</cfif>	
			<td><div class="item_position">#actions.currentRow#</div></td>
			<td>
				#actions.title#
			</td>
			<td>
				<span lang="es">#actionTypesStruct[actions.action_type_id].label#</span>
			</td>
			<td>
				<span lang="es"><cfif actions.action_event_type_id IS 1>
						Nuevo registro rellenado en #tableTypeNameEs#
					<cfelseif  actions.action_event_type_id IS 2>
						Registro modificado en #tableTypeNameEs#
					<cfelseif actions.action_event_type_id IS 3>
						Registro eliminado en #tableTypeNameEs#
					</cfif></span>
			</td>
			<td>#DateFormat(actions.creation_date, APPLICATION.dateFormat)# #TimeFormat(actions.creation_date, "HH:mm")#</td>
			<td><cfif len(actions.last_update_date) GT 0>#DateFormat(actions.last_update_date, APPLICATION.dateFormat)# #TimeFormat(actions.last_update_date, "HH:mm")#<cfelse>-</cfif></td>	
			<td>#actions.insert_user_full_name#</td>
			<td>#actions.update_user_full_name#</td>
		</tr>
	</cfloop>
	</tbody>
</table>
</cfoutput>