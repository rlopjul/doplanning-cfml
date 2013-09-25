<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

<cfif isDefined("URL.#tableTypeName#")>
	<cfset table_id = URL[#tableTypeName#]>
<cfelse>
	<cflocation url="area.cfm" addtoken="no">
</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getItem" returnvariable="objectItem">
	<cfinvokeargument name="item_id" value="#table_id#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
</cfinvoke>

<!---Table rows--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableRows" returnvariable="tableRowsResult">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>
<cfset tableRows = tableRowsResult.tableRows>

<!---Table fields--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>
<cfset fields = fieldsResult.tableFields>

<cfset area_id = objectItem.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>

<div class="div_message_page_title">#objectItem.title#</div>
<div class="div_separator"><!-- --></div>

<div class="div_head_subtitle_area">

	<a href="#tableTypeName#_row_new.cfm?#tableTypeName#=#table_id#" onclick="openUrl('#tableTypeName#_row_new.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)" class="btn btn-small" title="Nuevo registro" lang="es"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i> <span>Nuevo registro</span></a>

	<span class="divider">&nbsp;</span>

	<a href="#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#" class="btn" title="Campos" lang="es"><i class="icon-list"></i> <span lang="es">Campos<span></a>

	<span class="divider">&nbsp;</span>

	<cfif app_version NEQ "mobile">
		<a href="#APPLICATION.htmlPath#/#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#" class="btn btn-small" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
	</cfif>

	<a href="#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#" class="btn btn-small" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>

</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_items">

	<cfif tableRows.recordCount GT 0>

		<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

		<script type="text/javascript">
			$(document).ready(function() { 
				
				$("##dataTable").tablesorter({ 
					widgets: ['zebra','filter','select'],
					sortList: [[1,1]] ,
					headers: { 
						1: { 
							sorter: "datetime" 
						},
						2: { 
							sorter: "datetime" 
						}
					},

					widgetOptions : {
						filter_childRows : false,
						filter_columnFilters : true,
						filter_cssFilter : 'tablesorter-filter',
						filter_filteredRow   : 'filtered',
						filter_formatter : null,
						filter_functions : null,
						filter_hideFilters : false,
						filter_ignoreCase : true,
						filter_liveSearch : true,
						//filter_reset : 'button.reset',
						filter_searchDelay : 300,
						filter_serversideFiltering: false,
						filter_startsWith : false,
						filter_useParsedRow : false,
				    }
				});
				
			}); 
		</script>

		<cfset selectFirst = true>

		<cfif isDefined("URL.field")>
			<cfset selectFirst = false>
		</cfif>

		<table id="dataTable" class="table-hover" style="margin-top:5px;">
			<thead>
				<tr>
					<th style="width:25px;">##</th>
					<th>Fecha de inserción</th>
					<th>Fecha de última modificación</th>
					<cfloop query="#fields#">
						<cfif fields.field_type_id IS NOT 3><!--- IS NOT long text --->	
							<th>#fields.label#</th>
						</cfif>
					</cfloop>
					<!---<th class="filter-false">Acciones</th>--->
				</tr>
			</thead>
			<tbody>

			<cfset alreadySelected = false>

			<cfloop query="tableRows">

				<!---<cfif isDefined("arguments.return_page")>
					<cfset rpage = arguments.return_page>
				<cfelse>--->
					<cfset rpage = "#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#">
				<!---</cfif>--->
				<cfset row_page_url = "#tableTypeName#_row.cfm?#tableTypeName#=#table_id#&row=#tableRows.row_id#&return_page=#URLEncodedFormat(rpage)#">

				<!---Row selection--->
				<cfset dataSelected = false>
				
				<cfif alreadySelected IS false>

					<cfif ( isDefined("URL.data") AND (URL.data IS tableRows.row_id) ) OR ( selectFirst IS true AND tableRows.currentrow IS 1 AND app_version NEQ "mobile" ) >

						<!---Esta acción solo se completa si está en la versión HTML2--->
						<script type="text/javascript">
							openUrlHtml2('#row_page_url#','itemIframe');
						</script>

						<cfset dataSelected = true>
						<cfset alreadySelected = true>
																		
					</cfif>
					
				</cfif>

				<tr <cfif dataSelected IS true>class="selected"</cfif> onclick="openUrl('#row_page_url#','itemIframe',event)">
					<td>#tableRows.row_id#</td>
					<td>#DateFormat(tableRows.creation_date, "dd/mm/yyyy")# #TimeFormat(tableRows.creation_date, "HH:mm")#</td>
					<td><cfif len(tableRows.last_update_date) GT 0>#DateFormat(tableRows.last_update_date, "dd/mm/yyyy")# #TimeFormat(tableRows.last_update_date, "HH:mm")#<cfelse>-</cfif></td>
					<cfloop query="fields">
						<cfif fields.field_type_id IS NOT 3><!--- IS NOT long text --->	
							<cfset field_value = tableRows['field_#fields.field_id#']>
							<cfif fields.field_type_id IS 6 AND len(field_value) GT 0>
								<cfset field_value = DateFormat(dateConvert("local2Utc",field_value), "dd/mm/yyyy")>
							</cfif>
							<td>#field_value#</td>
						</cfif>
					</cfloop>
					<!---<td>
						<a href="#tableTypeName#_row_edit.cfm?#tableTypeName#=#table_id#data=#tableRows.row_id#" class="btn btn-info btn-small"><i class="icon-pencil"></i></a>
						<a href="#tableTypeName#_row_edit.cfm?#tableTypeName#=#table_id#data=#tableRows.row_id#" class="btn btn-danger btn-small"><i class="icon-remove"></i></a>
					</td>--->
				</tr>
			</cfloop>
			</tbody>
		</table>

	<cfelse>
	
		<script type="text/javascript">
			openUrlHtml2('empty.cfm','itemIframe');
		</script>				

		<cfoutput>
		<div class="div_text_result"><span lang="es">No hay datos introducidos.</span></div>
		</cfoutput>

	</cfif>

</cfoutput>