<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

<cfif isDefined("URL.#itemTypeName#") AND isNumeric(URL[itemTypeName])>
	<cfset table_id = URL[#itemTypeName#]>
<cfelse>
	<cflocation url="area.cfm" addtoken="no">
</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getItem" returnvariable="objectItem">
	<cfinvokeargument name="item_id" value="#table_id#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
</cfinvoke>

<!---Table fields--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
	<cfinvokeargument name="with_types" value="true">
</cfinvoke>
<cfset fields = fieldsResult.tableFields>

<!---<cfif fields.recordCount IS 0>
	<cfset queryAddRow(fields)>
</cfif>--->

<!---Table fields types--->
<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getFieldTypes" returnvariable="typesResult">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>
<cfset fieldTypes = typesResult.fieldTypes>--->

<cfset area_id = objectItem.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>
<div class="div_message_page_title">#objectItem.title#</div>
<div class="div_separator"><!-- --></div>

<div class="div_head_subtitle_area">

	<a href="#tableTypeName#_field_new.cfm?#tableTypeName#=#table_id#" onclick="openUrl('#tableTypeName#_field_new.cfm?#tableTypeName#=#table_id#', 'itemIframe', event)" class="btn btn-small"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i> <span>Añadir campo</span></a>

	<span class="divider">&nbsp;</span>

	<a href="#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#" class="btn" title="Registros" lang="es"><i class="icon-list"></i> <span lang="es">Registros<span></a>

	<span class="divider">&nbsp;</span>

	<cfif app_version NEQ "mobile">
		<a href="#APPLICATION.htmlPath#/#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#" class="btn btn-small" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
	</cfif>

	<!---<a href="#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#" class="btn btn-small" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>--->

</div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_items">

	<cfif fields.recordCount GT 0>

		<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

		<script type="text/javascript">
			$(document).ready(function() { 
				
				$("##dataTable").tablesorter({ 
					widgets: ['zebra','select'],
					sortList: [[0,0]] ,
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
					<th style="width:35%">Nombre del campo</th>
					<th>Tipo de campo</th>
					<th>Obligatorio</th>
					<th style="width:25%">Valor por defecto</th>
				</tr>
			</thead>
			<tbody>

			<cfset alreadySelected = false>

			<cfloop query="fields">

				<!---<cfif isDefined("arguments.return_page")>
					<cfset rpage = arguments.return_page>
				<cfelse>--->
					<cfset rpage = "#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#">
				<!---</cfif>--->
				<cfset field_page_url = "#tableTypeName#_field.cfm?field=#fields.field_id#&return_page=#URLEncodedFormat(rpage)#">

				<!---Row selection--->
				<cfset fieldSelected = false>
				
				<cfif alreadySelected IS false>

					<cfif ( isDefined("URL.field") AND (URL.field IS fields.field_id) ) OR ( selectFirst IS true AND fields.currentrow IS 1 AND app_version NEQ "mobile" ) >

						<!---Esta acción solo se completa si está en la versión HTML2--->
						<script type="text/javascript">
							openUrlHtml2('#field_page_url#','itemIframe');
						</script>

						<cfset fieldSelected = true>
						<cfset alreadySelected = true>
																		
					</cfif>
					
				</cfif>

				<tr <cfif fieldSelected IS true>class="selected"</cfif> onclick="openUrl('#field_page_url#','itemIframe',event)">	
					<td>#fields.currentRow#</td>		
					<td>
						<span class="field_label">#fields.label#</span>
					</td>
					<td>
						#fields.name#
					</td>
					<td>
						<cfif fields.required IS true>Sí<cfelse>No</cfif>
					</td>
					<td>
						#fields.default_value#
					</td>
					<!---<td><cfif isDefined("fields.field_id") AND isNumeric(fields.field_id)>
						<a onclick="return confirmActionLink('Campo #index#', 'eliminar', 'table_field_delete.cfm?ffid=#fields.field_id#&fid=#fields.table_id#')" class="btn btn-danger btn-small" title="Eliminar"><i class="icon-remove"></i></a>
						</cfif>
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
		<div class="div_text_result"><span lang="es">No hay campos definidos. Haga clic en Añadir campo parar crear un nuevo campo</span></div>
		</cfoutput>

	</cfif>

</div>

</cfoutput>
