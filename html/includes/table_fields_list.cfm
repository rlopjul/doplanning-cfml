
<cfif NOT isDefined("fields_selectable")>
	<cfset fields_selectable = false>
</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

<script type="text/javascript">
	$(document).ready(function() { 
		
		<cfif fields_selectable IS false>
			$("#dataTable").tablesorter({ 
				widgets: ['zebra','select'],
				sortList: [[4,0]]
			});
		<cfelse>
			$("#dataTable").tablesorter({ 
				widgets: ['zebra'],
				sortList: [[5,0]] ,
				headers: {
			      0: { sorter: false }
			    }
			});
		</cfif>

	}); 

	<!---<cfif fields_selectable IS true>

		function stopPropagation(e) {
			if (!e) var e = window.event;
			e.cancelBubble = true;
			if (e.stopPropagation) e.stopPropagation();		
		}

	</cfif>--->
</script>

<cfset selectFirst = true>

<cfif isDefined("URL.field")>
	<cfset selectFirst = false>
</cfif>

<cfoutput>
<table id="dataTable" class="table-hover" style="margin-top:5px;">
	<thead>
		<tr>
			<cfif fields_selectable IS true>
			<th style="width:25px;text-align:center;"><input type="checkbox" name="select_all" checked="checked" onclick="toggleCheckboxesChecked(this.checked);"/></th>
			</cfif>
			<!---<th style="width:25px;">##</th>--->
			<th style="width:35%">Nombre del campo</th>
			<th>Tipo de campo</th>
			<th>Obligatorio</th>
			<th style="width:25%">Valor por defecto</th>
			<th>##</th>
		</tr>
	</thead>
	<tbody>

	<cfset alreadySelected = false>

	<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

	<cfloop query="fields">

		<!---<cfif isDefined("arguments.return_page")>
			<cfset rpage = arguments.return_page>
		<cfelse>--->
			<cfset rpage = "#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#">
		<!---</cfif>--->
		<cfset field_page_url = "#tableTypeName#_field.cfm?field=#fields.field_id#&return_page=#URLEncodedFormat(rpage)#">

		<!---Row selection--->
		<cfset fieldSelected = false>
		
		<cfif fields_selectable IS false>
			
			<cfif alreadySelected IS false>

				<cfif ( isDefined("URL.field") AND URL.field IS fields.field_id ) OR ( selectFirst IS true AND fields.currentrow IS 1 AND app_version NEQ "mobile" ) >

					<!---Esta acción solo se completa si está en la versión HTML2--->
					<script type="text/javascript">
						openUrlHtml2('#field_page_url#','itemIframe');
					</script>

					<cfset fieldSelected = true>
					<cfset alreadySelected = true>
																	
				</cfif>
				
			</cfif>

		</cfif>

		<tr <cfif fieldSelected IS true>class="selected"</cfif> onclick="<cfif fields_selectable IS false>openUrl('#field_page_url#','itemIframe',event)<cfelse>toggleCheckboxChecked('##field_#fields.field_id#')</cfif>">
			<cfif fields_selectable IS true>
				<td style="text-align:center;"><input type="checkbox" name="fields_ids[]" id="field_#fields.field_id#" value="#fields.field_id#" checked="checked" onClick="stopPropagation(event);" /></td>
			</cfif>	
			<!---<td>#fields.currentRow#</td>--->		
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
				<cfset field_default_value = "">
				<cfif fields.field_type_id IS 9 OR fields.field_type_id IS 10><!--- IS LIST --->

					<cfif isNumeric(fields.default_value)>
						
						<!--- getArea --->
						<!---<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="listArea">
							<cfinvokeargument name="area_id" value="#fields.default_value#">
						</cfinvoke>
						<cfset field_default_value = listArea.name>--->

						<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaQuery" method="getArea" returnvariable="selectDefaultAreaQuery">
							<cfinvokeargument name="area_id" value="#fields.default_value#">
							<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>
						
						<cfif selectDefaultAreaQuery.recordCount GT 0>
							<cfset field_default_value = selectDefaultAreaQuery.name>
						</cfif>

					</cfif>
					
				<cfelse><!--- IS NOT LIST --->

					<cfset field_default_value = fields.default_value>
					<cfif len(field_default_value) GT 0>
						<cfif fields.field_type_id IS 7><!--- BOOLEAN --->
							<cfif field_default_value IS true>
								<cfset field_default_value = "Sí">
							<cfelse>
								<cfset field_default_value = "No">
							</cfif>
						</cfif>
					</cfif>

				</cfif>
				#field_default_value#
			</td>
			
			<td><div class="item_position">#fields.currentRow#</div><div class="change_position"><cfif fields.currentRow NEQ 1>
				<cfset up_field_id = fields.field_id[fields.currentRow-1]>
				<a onclick="openUrl('table_field_position_up.cfm?field=#fields.field_id#&ofield=#up_field_id#&tableTypeId=#tableTypeId#&table=#fields.table_id#','areaIframe',event)"><img src="#APPLICATION.htmlPath#/assets/icons/up.jpg" alt="Subir" title="Subir"/></a><cfelse><br></cfif><!--- <div class="div_position_down"><!-- --></div> ---><cfif fields.currentRow NEQ fields.recordCount>
					<cfset down_field = fields.field_id[fields.currentRow+1]>
					<a onclick="openUrl('table_field_position_down.cfm?field=#fields.field_id#&ofield=#down_field#&tableTypeId=#tableTypeId#&table=#fields.table_id#','areaIframe',event)"><img src="#APPLICATION.htmlPath#/assets/icons/down.jpg" alt="Bajar" title="Bajar"/></a>
				</cfif></div></td>
		</tr>
	</cfloop>
	</tbody>
</table>
</cfoutput>