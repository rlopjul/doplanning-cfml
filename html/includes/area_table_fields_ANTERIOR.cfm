<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/item_type_switch.cfm">

<cfif isDefined("URL.#itemTypeName#")>
	<cfset item_id = URL[#itemTypeName#]>
<cfelse>
	<cflocation url="area.cfm" addtoken="no">
</cfif>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/AreaItem" method="getItem" returnvariable="objectItem">
	<cfinvokeargument name="item_id" value="#item_id#">
	<cfinvokeargument name="itemTypeId" value="#itemTypeId#">
</cfinvoke>

<!---Table fields--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
	<cfinvokeargument name="table_id" value="#item_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>
<cfset fieldsList = fieldsResult.tableFields>

<!---<cfloop condition="fieldsList.recordCount LT currentForm.fields_number">
	<cfset queryAddRow(fieldsList)>
</cfloop>--->

<cfif fieldsList.recordCount IS 0>
	<cfset queryAddRow(fieldsList)>
</cfif>

<!---Table fields types--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getFieldTypes" returnvariable="typesResult">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>
<cfset typesList = typesResult.fieldTypes>

<cfset area_id = objectItem.area_id>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>
<div class="div_message_page_title">#objectItem.title#</div>
<div class="div_separator"><!-- --></div>

<div class="div_elements_menu">

	<a href="#itemTypeName#_field_new.cfm?#itemTypeName#=#item_id#" onclick="openUrl('#itemTypeName#_field_new.cfm?#itemTypeName#=#item_id#', 'itemIframe', event)" class="btn btn-small"><i class="icon-plus icon-white" style="color:##5BB75B;font-size:15px;line-height:20px;"></i> <span>Añadir campo</span></a>

	<!---<span class="divider">&nbsp;</span>

	<cfif app_version NEQ "mobile">
		<a href="#APPLICATION.htmlPath#/#itemTypeName#_data.cfm?#itemTypeName#=#item_id#" class="btn btn-small" title="Abrir en nueva ventana" lang="es" target="_blank"><i class="icon-external-link" style="font-size:14px; line-height:23px;"></i></a>
	</cfif>

	<a href="#itemTypeName#_data.cfm?#itemTypeName#=#item_id#" class="btn btn-small" title="Actualizar" lang="es"><i class="icon-refresh" style="font-size:14px; line-height:23px;"></i></a>--->

</div>

<cfset read_only = false>

<cfform action="#CGI.SCRIPT_NAME#" method="post">
	<cfinput type="hidden" name="page" value="#CGI.SCRIPT_NAME#">
	<cfinput type="hidden" name="table_id" value="#item_id#">
	<table class="table" style="width:100%;margin-bottom:0px;">
		<thead>
			<tr>
				<th style="width:25px;">##</th>
				<th style="width:35%">Nombre del campo</th>
				<th>Tipo de campo</th>
				<th>Obligatorio</th>
				<th style="width:25%">Valor por defecto</th>
				<!---<th>Exportar**</th>--->
				<th style="width:12%"></th>
			</tr>
		</thead>
		<tbody>
		<cfloop query="fieldsList">
		
			<cfset index = fieldsList.currentRow>
					
			<cfif index mod 2 IS 0><!---Comprueba si la fila es par o impar--->
				<cfset trclass = "even">
			<cfelse>
				<cfset trclass = "odd">
			</cfif> 
				
			<tr>	
				<td>#index#</td>		
				<td>
					<cfif isDefined("fieldsList.field_id") AND isNumeric(fieldsList.field_id)>
					<input type="hidden" name="field_id_#index#" value="#fieldsList.field_id#" />
					</cfif>
					<input type="text" name="label_#index#" value="#fieldsList.label#" maxlength="100" class="input-block-level" <cfif read_only>readonly="true"</cfif>/>
				</td>
				<td>
					<select name="field_type_id_#index#" <cfif read_only>disabled="disabled"</cfif>>
						<cfloop query="typesList">
							<option value="#typesList.field_type_id#" <cfif fieldsList.field_type_id IS typesList.field_type_id>selected="selected"</cfif>>#typesList.name#</option>
						</cfloop>
					</select>
				</td>
				<td>
					<input type="checkbox" name="required_#index#" <cfif fieldsList.required IS true>checked="checked"</cfif> />
				</td>
				<td>
					<input type="text" name="default_value_#index#" class="input-block-level" value="#fieldsList.default_value#" maxlength="1000" <cfif read_only>readonly="true"</cfif>/>
				</td>
				<!---<td><input type="checkbox" name="export_default_#index#" <cfif fieldsList.export_default IS true>checked="checked"</cfif> /></td>--->
				<td><cfif isDefined("fieldsList.field_id") AND isNumeric(fieldsList.field_id)>
					<a onclick="return confirmActionLink('Campo #index#', 'eliminar', 'table_field_delete.cfm?ffid=#fieldsList.field_id#&fid=#fieldsList.table_id#')" class="btn btn-danger btn-small" title="Eliminar"><i class="icon-remove"></i></a>
					</cfif>
				</td>
			</tr>

		</cfloop>
		</tbody>
	</table>
	
		
	<div style="margin-top:20px; margin-bottom:0;">
		<input type="submit" value="Guardar" class="btn btn-primary"/>
		<a href="area_items.cfm?area=#area_id#" class="btn">Cancelar</a>
	</div>
	
</cfform>

	<!---<div style="margin-top:1pc; margin-bottom:20px;"></div>--->

	<small>Una vez publicado el formulario, no se puede cambiar el nombre ni el tipo de los campos.</small><br/>

</cfoutput>
