
<cfif NOT isDefined("fields_selectable")>
	<cfset fields_selectable = false>
</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

<script>
	$(document).ready(function() {

		<cfif fields_selectable IS false>
			$("#dataTable").tablesorter({
				widgets: ['zebra','uitheme','select'],
				theme : "bootstrap",
				headerTemplate : '{content} {icon}',
				<cfif tableTypeId EQ 4>
				sortList: [[6,0]] ,
				<cfelseif tableTypeId NEQ 3>
				sortList: [[5,0]] ,
				<cfelse>
				sortList: [[4,0]] ,
				</cfif>
			});
		<cfelse>
			$("#dataTable").tablesorter({
				widgets: ['zebra','uitheme'],
				theme : "bootstrap",
				headerTemplate : '{content} {icon}',
				<cfif tableTypeId EQ 4>
				sortList: [[7,0]] ,
				<cfelseif tableTypeId NEQ 3>
				sortList: [[6,0]] ,
				<cfelse>
				sortList: [[5,0]] ,
				</cfif>
				headers: {
			      0: { sorter: false }
			    }
			});
		</cfif>


		$('#dataTable tbody tr').on('click', function(e) {

	       	var row = $(this);

	       	<cfif fields_selectable IS false>

	       		<!---openUrl('#field_page_url#','itemIframe',event)--->
		       	var itemUrl= row.data("item-url");
		       	openUrlLite(itemUrl,'_self');

	       	<cfelse>

	       		var fieldId = row.data("field-id");
	       		toggleCheckboxChecked('#field_'+fieldId)

	       	</cfif>

	    });


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
<table id="dataTable" class="data-table table-hover" style="margin-top:5px;">
	<thead>
		<tr>
			<cfif fields_selectable IS true>
			<th style="width:25px;text-align:center;"><input type="checkbox" name="select_all" checked="checked" onclick="toggleCheckboxesChecked(this.checked);"/></th>
			</cfif>
			<!---<th style="width:25px;">##</th>--->
			<th style="width:35%"><span lang="es">Nombre del campo</span></th>
			<th><span lang="es">Tipo de campo</span></th>
			<th><span lang="es">Obligatorio</span></th>
			<cfif tableTypeId NEQ 3>
			<th><span lang="es">En listado</span></th>
			</cfif>
			<cfif tableTypeId EQ 4>
				<th><span lang="es">Editable por todos</span></th>
			</cfif>
			<th>
				<span lang="es">Valor por defecto</span></th>
			<th>##</th>
		</tr>
	</thead>
	<tbody>

	<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

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

		<tr <cfif fieldSelected IS true>class="selected"</cfif> data-item-url="#field_page_url#" data-field-id="#fields.field_id#"><!---onclick="<cfif fields_selectable IS false>openUrl('#field_page_url#','itemIframe',event)<cfelse>toggleCheckboxChecked('##field_#fields.field_id#')</cfif>"--->
			<cfif fields_selectable IS true>
				<td style="text-align:center;"><input type="checkbox" name="fields_ids[]" id="field_#fields.field_id#" value="#fields.field_id#" checked="checked" onClick="stopPropagation(event);" /></td>
			</cfif>
			<!---<td>#fields.currentRow#</td>--->
			<td>
				<span class="field_label">#fields.label#</span>
			</td>
			<td>
				<span lang="es">#fields.name#</span>
			</td>
			<td>
				<span lang="es"><cfif fields.field_type_id NEQ 20><cfif fields.required IS true>Sí<cfelse>No</cfif></cfif></span>
			</td>
			<cfif tableTypeId NEQ 3>
			<td>
				<span lang="es"><cfif fields.field_type_id NEQ 20><cfif fields.include_in_list IS true>Sí<cfelse></b>No</b></cfif></cfif></span>
			</td>
			</cfif>
			<cfif tableTypeId EQ 4>
			<td>
				<span lang="es"><cfif fields.field_type_id NEQ 20><cfif fields.include_in_all_users IS true>Sí<cfelse><b>No</b></cfif></cfif></span>
			</td>
			</cfif>
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

				<cfelseif fields.field_type_id IS 12><!--- USER --->

					<cfif isNumeric(fields.default_value)>

						<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUser" returnvariable="userQuery">
							<cfinvokeargument name="user_id" value="#fields.default_value#">

							<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
							<cfinvokeargument name="client_dsn" value="#client_dsn#">
						</cfinvoke>
						<cfif userQuery.recordCount GT 0>
							<cfif len(userQuery.user_full_name) GT 0 AND userQuery.user_full_name NEQ " ">
								<cfset field_default_value = userQuery.user_full_name>
							<cfelse>
								<cfset field_default_value = '<i lang="es">USUARIO SIN NOMBRE</i>'>
							</cfif>
						<cfelse>
							<cfset field_default_value = '<i lang="es">USUARIO NO ENCONTRADO</i>'>
						</cfif>

					</cfif>

				<cfelseif fields.field_type_id IS 13><!--- ITEM --->

					<cfif isNumeric(fields.default_value)>

						<cfif fields.item_type_id IS 10><!--- FILE --->

							<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
								<cfinvokeargument name="file_id" value="#fields.default_value#">
								<cfinvokeargument name="parse_dates" value="false"/>
								<cfinvokeargument name="published" value="false"/>

								<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

							<cfif fileQuery.recordCount GT 0>
								<cfif len(fileQuery.name) GT 0>
									<cfset field_default_value = fileQuery.name>
								<cfelse>
									<cfset field_default_value = '<span lang="es"><i>ARCHIVO SIN TÍTULO</i></span>'>
								</cfif>
							<cfelse>
								<cfset field_default_value = '<span lang="es"><i>ARCHIVO NO DISPONIBLE</i></span>'>
							</cfif>

						<cfelse><!--- ITEM --->

							<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
								<cfinvokeargument name="item_id" value="#fields.default_value#">
								<cfinvokeargument name="itemTypeId" value="#fields.item_type_id#">
								<cfinvokeargument name="parse_dates" value="false"/>
								<cfinvokeargument name="published" value="false"/>

								<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
								<cfinvokeargument name="client_dsn" value="#client_dsn#">
							</cfinvoke>

							<cfif itemQuery.recordCount GT 0>
								<cfif len(itemQuery.title) GT 0>
									<cfset field_default_value = itemQuery.title>
								<cfelse>
									<cfset field_default_value = '<span lang="es"><i>ELEMENTO SIN TÍTULO</i></span>'>
								</cfif>
							<cfelse>
								<cfset field_default_value = '<span lang="es"><i>ELEMENTO NO DISPONIBLE</i></span>'>
							</cfif>

						</cfif>

					</cfif>

				<cfelse><!--- IS NOT LIST --->

					<cfset field_default_value = fields.default_value>
					<cfif len(field_default_value) GT 0>
						<cfif fields.field_type_id IS 7><!--- BOOLEAN --->
							<cfif field_default_value IS true>
								<cfset field_default_value = '<span lang="es">Sí</span>'>
							<cfelse>
								<cfset field_default_value = '<span lang="es">No</span>'>
							</cfif>
						</cfif>
					</cfif>

				</cfif>
				#field_default_value#
			</td>

			<td><div class="item_position">#fields.currentRow#</div><div class="change_position"><cfif fields.currentRow NEQ 1>
				<cfset up_field_id = fields.field_id[fields.currentRow-1]>
				<!---onclick="openUrl('table_field_position_up.cfm?field=#fields.field_id#&ofield=#up_field_id#&tableTypeId=#tableTypeId#&table=#fields.table_id#','areaIframe',event)"--->
				<a href="table_field_position_up.cfm?field=#fields.field_id#&ofield=#up_field_id#&tableTypeId=#tableTypeId#&table=#fields.table_id#"><img src="#APPLICATION.htmlPath#/assets/v3/icons/up.jpg" alt="Subir" title="Subir"/></a><cfelse><br></cfif><!--- <div class="div_position_down"><!-- --></div> ---><cfif fields.currentRow NEQ fields.recordCount>
					<cfset down_field = fields.field_id[fields.currentRow+1]>
					<!---onclick="openUrl('table_field_position_down.cfm?field=#fields.field_id#&ofield=#down_field#&tableTypeId=#tableTypeId#&table=#fields.table_id#','areaIframe',event)"--->
					<a href="table_field_position_down.cfm?field=#fields.field_id#&ofield=#down_field#&tableTypeId=#tableTypeId#&table=#fields.table_id#"><img src="#APPLICATION.htmlPath#/assets/v3/icons/down.jpg" alt="Bajar" title="Bajar"/></a>
				</cfif></div></td>
		</tr>
	</cfloop>
	</tbody>
</table>
</cfoutput>
