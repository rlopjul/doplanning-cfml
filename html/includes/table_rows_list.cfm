<!---<cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">


<!--- getFieldMaskTypes --->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Field" method="getFieldMaskTypes" returnvariable="getFieldMaskTypesResponse">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>

<cfset maskTypesStruct = getFieldMaskTypesResponse.maskTypesStruct>

<script type="text/javascript">
	$(document).ready(function() { 
		
		$("##dataTable").tablesorter({ 

			<!---widgets: ['zebra','filter','select','stickyHeaders'],--->
			widgets: ['zebra','filter','select','stickyHeaders','math'],

			headers: { 
				
				<cfset sortArray = arrayNew(1)>
				<cfset fieldsWithDate = false>

				<cfloop query="fields">

					<cfif fields.field_id IS "creation_date" OR fields.field_id IS "last_update_date" OR fields.field_type_id IS 6><!--- DATE --->
						<cfif fieldsWithDate IS true>,</cfif>#fields.currentRow#: { 
							sorter: "datetime" 
						}
						<cfset fieldsWithDate = true>
					</cfif>

					<cfif len(fields.sort_by_this) GT 0>
						<cfif fields.sort_by_this IS "asc">
							<cfset sortOrder = 0>
						<cfelse>
							<cfset sortOrder = 1>
						</cfif>
						<cfset arrayAppend(sortArray, {row=fields.currentRow, order=sortOrder})>
					</cfif>

				</cfloop>
			},
			// default "emptyTo"
   			emptyTo: 'zero',
			<!---textExtraction: 'basic',--->
			textAttribute: "data-text",
			textExtraction: "basic",
			usNumberFormat: true, <!--- false Requerido para que la suma de los valores de las comlumnas con decimales separados por , sea correcta (esto hace que los decimales separados por . no se sumen correctamente, pero para eso se usan otras opciones)  ---->
			<cfset sortArrayLen = arrayLen(sortArray)>
			<cfif sortArrayLen GT 0>
							
				sortList: [
				<cfloop from="1" to="#sortArrayLen#" index="curSort">
					[#sortArray[curSort].row#, #sortArray[curSort].order#]
					<cfif curSort NEQ sortArrayLen>
						,
					</cfif>
				</cfloop> ],

			<cfelse>
				sortList: [[0,1]] ,
			</cfif>

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
				filter_searchDelay : 500,
				filter_serversideFiltering: false,
				filter_startsWith : false,
				filter_useParsedRow : false

				<!--- Suma de valores de las columnas --->
					, math_data     : 'math' // data-math attribute
				    , math_ignore   : [0
				    <cfloop query="fields"> 
				    	<cfif fields.field_type_id NEQ 4 AND fields.field_type_id NEQ 5>
				    		, #fields.currentRow#
				    	</cfif>
				    </cfloop>]
				    <!---, math_mask     : '##.000,00'--->
				    <!---, math_complete : function($cell, wo, result, value, arry) {
				        var txt = '<span class="align-decimal"> ' + result + '</span>';
				        if ($cell.attr('data-math') === 'all-sum') {
				          // when the "all-sum" is processed, add a count to the end
				          return txt + ' (Sum of ' + arry.length + ' cells)';
				        }
				        return txt;
				    }--->
				<!--- Fin suma de los valores de las columnas --->
		    }
		});


		<!---<cfif arguments.openItemOnSelect IS true>--->
		<!--- https://code.google.com/p/tablesorter-extras/wiki/TablesorterSelect --->
		$('##dataTable').bind('select.tablesorter.select', function(event, ts){
		    var itemUrl= $(ts.elem).data("item-url");
		    openUrlLite(itemUrl,'itemIframe');
		    <!---onclick="openUrl('#row_page_url#','itemIframe',event)"--->

		});
		<!---</cfif>--->	
		
	}); 
</script>

<cfset selectFirst = true>
<cfset listFields = false>

<cfif isDefined("URL.row")>
	<cfset selectFirst = false>
</cfif>

<table id="dataTable" class="table-hover" style="margin-top:5px;">
	<thead>
		<tr>
			<th style="width:25px;">##</th>
			<!---<th>Fecha última modificación</th>--->
			<cfloop query="fields">
				<th>#fields.label#</th>
				<cfif fields.field_type_id EQ 9 OR fields.field_type_id IS 10><!--- LISTS --->
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

	<cfset client_dsn = APPLICATION.identifier&"_"&SESSION.client_abb>

	<cfset alreadySelected = false>

	<cfloop query="tableRows">

		<cfif isDefined("view_id")>
			<cfset rpage = "#itemTypeName#_rows.cfm?#itemTypeName#=#view_id#">
			<cfset row_page_url = "#itemTypeName#_row.cfm?#itemTypeName#=#view_id#&row=#tableRows.row_id#&return_page=#URLEncodedFormat(rpage)#">
		<cfelse>
			<cfset rpage = "#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#">
			<cfset row_page_url = "#tableTypeName#_row.cfm?#tableTypeName#=#table_id#&row=#tableRows.row_id#&return_page=#URLEncodedFormat(rpage)#">
		</cfif>
		

		<!---Row selection--->
		<cfset dataSelected = false>
		
		<cfif alreadySelected IS false>

			<cfif ( isDefined("URL.row") AND URL.row IS tableRows.row_id ) OR ( selectFirst IS true AND tableRows.currentRow IS 1 AND app_version NEQ "mobile" ) ><!--- tableRows.recordCount --->

				<!--- ESTO PUESTO AQUÍ HACE QUE FALLE EL TABLESORTER PARA LAS SUMAS --->
				<!---<script>
					openUrlHtml2('#row_page_url#','itemIframe');
				</script>--->
				<cfset onpenUrlHtml2 = row_page_url>

				<cfset dataSelected = true>
				<cfset alreadySelected = true>
																
			</cfif>
			
		</cfif>

		<tr <cfif dataSelected IS true>class="selected"</cfif> data-item-url="#row_page_url#">

			<td>#tableRows.row_id#</td>
			
			<cfset row_id = tableRows.row_id>
			<cfloop query="fields">

				<cfif fields.field_id IS "creation_date"><!--- CREATION DATE --->

					<td>#DateFormat(tableRows.creation_date, APPLICATION.dateFormat)# #TimeFormat(tableRows.creation_date, "HH:mm")#</td>

				<cfelseif fields.field_id IS "last_update_date"><!--- LAST UPDATE DATE --->
					
					<td><cfif len(tableRows.last_update_date) GT 0>#DateFormat(tableRows.last_update_date, APPLICATION.dateFormat)# #TimeFormat(tableRows.last_update_date, "HH:mm")#<cfelse>-</cfif></td>

				<cfelseif fields.field_id IS "insert_user"><!--- INSERT USER --->

					<td>#insert_user_full_name#</td>

				<cfelseif fields.field_id IS "update_user"><!--- UPDATE USER --->

					<td>#update_user_full_name#</td>

				<cfelse><!--- TABLE FIELDS --->

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

							<cfif fields.field_type_id IS 5><!--- DECIMAL --->

								<cfif isNumeric(fields.mask_type_id)>

									<cfset field_mask_type_id = fields.mask_type_id>

									<cfset cf_data_mask = maskTypesStruct[field_mask_type_id].cf_data_mask>
									<cfset cf_prefix = maskTypesStruct[field_mask_type_id].cf_prefix>
									<cfset cf_sufix = maskTypesStruct[field_mask_type_id].cf_sufix>
									<cfset cf_locale = maskTypesStruct[field_mask_type_id].cf_locale>
									<cfset field_value = cf_prefix&LSnumberFormat(field_value, cf_data_mask, cf_locale)&cf_sufix>

									<!---<cfset field_value = LSnumberFormat(field_value, ",.__", getLocale())>--->

								<cfelse>
									<!---<cfset field_value = LSnumberFormat(field_value, ".__", "en_US")>--->

									<cfinvoke component="#APPLICATION.coreComponentsPath#/Utils" method="trimDecimal" returnvariable="field_value">
										<cfinvokeargument name="value" value="#field_value#">
									</cfinvoke>
									
								</cfif>
								
								
							<cfelseif fields.field_type_id IS 6><!--- DATE --->
								<cfset field_value = DateFormat(dateConvert("local2Utc",field_value), APPLICATION.dateFormat)>
							<cfelseif fields.field_type_id IS 7><!--- BOOLEAN --->
								<cfif field_value IS true>
									<cfset field_value = "Sí">
								<cfelseif field_value IS false>
									<cfset field_value = "No">
								</cfif>
								<cfset field_value = '<span lang="es">#field_value#</span>'>

							<cfelseif fields.field_type_id IS 12><!--- USER --->

								<cfif isNumeric(field_value)>
						
									<cfinvoke component="#APPLICATION.coreComponentsPath#/UserQuery" method="getUser" returnvariable="userQuery">
										<cfinvokeargument name="user_id" value="#field_value#">

										<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
										<cfinvokeargument name="client_dsn" value="#client_dsn#">
									</cfinvoke>
									<cfif userQuery.recordCount GT 0>
										<cfif len(userQuery.user_full_name) GT 0 AND userQuery.user_full_name NEQ " ">
											<cfset field_value = userQuery.user_full_name>
										<cfelse>
											<cfset field_value = "<i>USUARIO SIN NOMBRE</i>">
										</cfif>
									<cfelse>
										<cfset field_value = '<i lang="es">USUARIO NO ENCONTRADO</i>'>
									</cfif>
									
								</cfif>


							<cfelseif fields.field_type_id IS 13><!--- ITEM --->


								<cfif isNumeric(field_value)>

									<cfif fields.item_type_id IS 10><!--- FILE --->

										<cfinvoke component="#APPLICATION.coreComponentsPath#/FileQuery" method="getFile" returnvariable="fileQuery">
											<cfinvokeargument name="file_id" value="#field_value#">
											<cfinvokeargument name="parse_dates" value="false"/>
											<cfinvokeargument name="published" value="false"/>

											<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
											<cfinvokeargument name="client_dsn" value="#client_dsn#">
										</cfinvoke>

										<cfif fileQuery.recordCount GT 0>
											<cfif len(fileQuery.name) GT 0>
												<cfset field_value = fileQuery.name>
											<cfelse>
												<cfset field_value = "<i>ARCHIVO SIN TÍTULO</i>">
											</cfif>
										<cfelse>
											<cfset field_value = "<i>ARCHIVO NO DISPONIBLE</i>">
										</cfif>
										
									<cfelse><!--- ITEM --->

										<cfinvoke component="#APPLICATION.coreComponentsPath#/AreaItemQuery" method="getItem" returnvariable="itemQuery">
											<cfinvokeargument name="item_id" value="#field_value#">
											<cfinvokeargument name="itemTypeId" value="#fields.item_type_id#">
											<cfinvokeargument name="parse_dates" value="false"/>
											<cfinvokeargument name="published" value="false"/>

											<cfinvokeargument name="client_abb" value="#SESSION.client_abb#">
											<cfinvokeargument name="client_dsn" value="#client_dsn#">
										</cfinvoke>

										<cfif itemQuery.recordCount GT 0>
											<cfif len(itemQuery.title) GT 0>
												<cfset field_value = itemQuery.title>
											<cfelse>
												<cfset field_value = "<i>ELEMENTO SIN TÍTULO</i>">
											</cfif>
										<cfelse>
											<cfset field_value = "<i>ELEMENTO NO DISPONIBLE</i>">
										</cfif>

									</cfif>

								</cfif>


							<cfelse>

								<cfif fields.field_type_id IS 2 OR fields.field_type_id IS 3 OR fields.field_type_id IS 11><!--- TEXTAREAS --->
									
									<cfif len(field_value) GT 60><!---200--->

										<cfif fields.field_type_id IS 2>
											
											<cfset field_value = HTMLEditFormat(field_value)>

										<cfelse>

											<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="removeHTML" returnvariable="field_value">
												<cfinvokeargument name="string" value="#field_value#">
											</cfinvoke>
						
										</cfif>

										<!---<cfset field_value = left(field_value, 180)&"...">ANTES ESTABA ASÍ--->
										<cfset summary_value = left(field_value, 55)&"...">

										<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="insertBR" returnvariable="summary_value">
											<cfinvokeargument name="string" value="#summary_value#">
										</cfinvoke>

										<cfif fields.field_type_id IS NOT 11><!--- IS NOT Very long text --->
											<cfset field_value = '#summary_value#<span class="hidden">#field_value#</span>'>
										<cfelse>
											<cfset field_value = summary_value>
										</cfif>											

									<cfelseif fields.field_type_id IS 2>

										<cfset field_value = HTMLEditFormat(field_value)>

										<cfinvoke component="#APPLICATION.htmlComponentsPath#/Interface" method="insertBR" returnvariable="field_value">
											<cfinvokeargument name="string" value="#field_value#">
										</cfinvoke>

									</cfif>

								</cfif>
								
							</cfif>
						</cfif>

					</cfif>
					
					<cfif fields.field_type_id IS 5 AND isDefined("cf_locale") AND cf_locale EQ "es_ES"><!---Esto es neceario para que se sume correctamente, el valor que se suma es el de data-text--->
						
						<td data-text="#tableRows['field_#fields.field_id#']#">#field_value#</td>

					<cfelse>

						<td>#field_value#</td>

					</cfif>

				</cfif>

			</cfloop>
		</tr>
	</cfloop>
	</tbody>

	<tfoot>
	   <tr>
			<th></th>
			<cfloop query="fields">
				<cfif fields.field_type_id EQ 4><!--- INTEGER --->
					<th data-math="col-sum" data-math-mask="##"></th><!---data-math-mask="##000"--->
				<cfelseif fields.field_type_id IS 5><!--- DECIMAL --->

					<cfif isNumeric(fields.mask_type_id)>
						<cfset field_mask_type_id = fields.mask_type_id>
						<th data-math="col-sum" data-math-mask="#maskTypesStruct[field_mask_type_id].tablesorterd_data_mask#"></th>
					<cfelse>
						<th data-math="col-sum" data-math-mask="####.00"></th>
					</cfif>

					<!---<th data-math="col-sum" data-math-mask="##.00"></th>--->
					
				<cfelse>
					<th></th>
				</cfif>
			</cfloop>
		</tr>
	</tfoot>

</table>

<cfif isDefined("onpenUrlHtml2")>
	
	<!---Esta acción sólo se completa si está en la versión HTML2--->
	<script>
		openUrlHtml2('#onpenUrlHtml2#','itemIframe');
	</script>

</cfif>


</cfoutput>--->