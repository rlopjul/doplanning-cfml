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
<cfset tableRows = tableRowsResult.rows>

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

	<!---checkListPermissions--->
	<cfset table_edit_permission = true>

	<cfif is_user_area_responsible IS false>
		
		<cfif tableTypeId IS 1 AND APPLICATION.moduleListsWithPermissions IS true><!---IS List and list permissions is enabled--->

			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="isUserInTable" returnvariable="isUserInTable">
				<cfinvokeargument name="table_id" value="#table_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
			</cfinvoke>	

			<cfif isUserInTable IS false>
				<cfset table_edit_permission = false>
			</cfif>

		</cfif>

	</cfif>
	

	<cfif is_user_area_responsible OR table_edit_permission IS true>
		<a href="#tableTypeName#_row_new.cfm?#tableTypeName#=#table_id#" onclick="openUrl('#tableTypeName#_row_new.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)" class="btn btn-small" title="Nuevo registro" lang="es"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i> <span>Nuevo registro</span></a>

		<span class="divider">&nbsp;</span>
	</cfif>	

	<cfif is_user_area_responsible>
		<a href="#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#" class="btn btn-small" title="Campos" lang="es"><i class="icon-list"></i> <span lang="es">Campos</span></a>

		<cfif APPLICATION.moduleListsWithPermissions IS true AND itemTypeId IS 11><!---List with permissions--->
			<a href="#itemTypeName#_users.cfm?#itemTypeName#=#table_id#" class="btn btn-small" title="Editores" lang="es"><i class="icon-group"></i> <span lang="es">Editores</span></a>
		</cfif>

		<span class="divider">&nbsp;</span>
	</cfif>

	<a href="#itemTypeNameP#.cfm?area=#area_id#" class="btn btn-small" title="#itemTypeNameEsP# del área" lang="es"> <span lang="es">#itemTypeNameEsP# del área</span></a>

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
					sortList: [[0,1]] ,
					headers: { 
						1: { 
							sorter: "datetime" 
						},
						<!---2: { 
							sorter: "datetime" 
						}--->
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
		<cfset listFields = false>

		<cfif isDefined("URL.field")>
			<cfset selectFirst = false>
		</cfif>

		<table id="dataTable" class="table-hover" style="margin-top:5px;">
			<thead>
				<tr>
					<th style="width:25px;">##</th>
					<!--- <th>Fecha inserción</th> --->
					<th>Fecha última modificación</th>
					<cfloop query="fields">
						<th>#fields.label#</th>
						<cfif fields.field_type_id EQ 9 OR fields.field_type_id IS 10>
							<cfset listFields = true>
						</cfif>
					</cfloop>
				</tr>
			</thead>
			<tbody>

			<cfif listFields IS true>
				
				<!--- Get selected areas --->
				<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="getRowSelectedAreas" returnvariable="getRowSelectedAreasResponse">
					<cfinvokeargument name="table_id" value="#table_id#">
					<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				</cfinvoke>

				<cfset selectedAreas = getRowSelectedAreasResponse.areas>

			</cfif>

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

					<cfif ( isDefined("URL.data") AND (URL.data IS tableRows.row_id) ) OR ( selectFirst IS true AND tableRows.currentrow IS tableRows.recordCount AND app_version NEQ "mobile" ) >

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
					<!---<td>#DateFormat(tableRows.creation_date, APPLICATION.dateFormat)# #TimeFormat(tableRows.creation_date, "HH:mm")#</td>--->
					<td><cfif len(tableRows.last_update_date) GT 0>#DateFormat(tableRows.last_update_date, APPLICATION.dateFormat)# #TimeFormat(tableRows.last_update_date, "HH:mm")#<cfelse>-</cfif></td>
					<cfset row_id = tableRows.row_id>
					<cfloop query="fields">

						<cfset field_value = "">

						<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- IS LIST --->

							<cfif selectedAreas.recordCount GT 0>

								<cfquery dbtype="query" name="rowSelectedAreas">
									SELECT name
									FROM selectedAreas
									WHERE field_id = <cfqueryparam value="#fields.field_id#" cfsqltype="cf_sql_integer">
									AND row_id = <cfqueryparam value="#row_id#" cfsqltype="cf_sql_integer">;
								</cfquery>

								<cfif rowSelectedAreas.recordCount GT 0>
									<cfset field_value = valueList(rowSelectedAreas.name, "<br/>")>
								</cfif>

							</cfif>
							
						<cfelse><!--- IS NOT LIST --->

							<cfset field_value = tableRows['field_#fields.field_id#']>

							<cfif len(field_value) GT 0>
								<cfif fields.field_type_id IS 6><!--- DATE --->
									<cfset field_value = DateFormat(dateConvert("local2Utc",field_value), APPLICATION.dateFormat)>
								<cfelseif fields.field_type_id IS 7><!--- BOOLEAN --->
									<cfif field_value IS true>
										<cfset field_value = "Sí">
									<cfelseif field_value IS false>
										<cfset field_value = "No">
									</cfif>
								<cfelse>

									<cfif fields.field_type_id IS 2 OR fields.field_type_id IS 3 OR fields.field_type_id IS 11><!--- TEXTAREA --->
										
										<cfif len(field_value) GT 200>

											<cfif fields.field_type_id IS NOT 2>

												<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="replaceP" returnvariable="field_value">
													<cfinvokeargument name="string" value="#field_value#">
												</cfinvoke>--->

												<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="removeHTML" returnvariable="field_value">
													<cfinvokeargument name="string" value="#field_value#">
												</cfinvoke>
							
											</cfif>

											<cfset field_value = left(field_value, 180)&"...">

											<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="insertBR" returnvariable="field_value">
												<cfinvokeargument name="string" value="#field_value#">
											</cfinvoke>

										<cfelseif fields.field_type_id IS 2>

											<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="insertBR" returnvariable="field_value">
												<cfinvokeargument name="string" value="#field_value#">
											</cfinvoke>

										</cfif>

									</cfif>
									
								</cfif>
							</cfif>

						</cfif>

						<td>#field_value#</td>

					</cfloop>
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