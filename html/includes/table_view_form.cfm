<!---page_types
1 Create new view
2 Modify view
--->

<cfinclude template="#APPLICATION.htmlPath#/includes/table_view_form_query.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/tablesorter_scripts.cfm">

<cfset return_page = "#tableTypeName#_views.cfm?#tableTypeName#=#table_id#">

<cfset url_return_path = "&return_path="&URLEncodedFormat(return_path&return_page)>

<cfoutput>

<script>

	function confirmDeleteView() {
	
		var message_delete = "Si ELIMINA la vista, dejará de estar disponible en el área correspondiente. ¿Seguro que desea eliminar la vista?";
		return confirm(message_delete);
	}

	function onSubmitForm(){

		if($("##dataTable tbody input:checkbox:checked").length > 0) {

			document.getElementById("submitDiv1").innerHTML = 'Enviando...';
			document.getElementById("submitDiv2").innerHTML = 'Enviando...';

			return true;

		} else {

			alert("Debe seleccionar al menos un campo para la vista");

			return false;
		}
	}

	function openAreaSelector(){
		
		<cfif APPLICATION.publicationScope IS true AND isNumeric(table.publication_scope_id)>
		return openPopUp('#APPLICATION.htmlPath#/iframes/area_select.cfm?scope=#table.publication_scope_id#');
		<cfelse>
		return openPopUp('#APPLICATION.htmlPath#/iframes/area_select.cfm');
		</cfif>
		
	}

	function setSelectedArea(areaId, areaName) {

		var curAreaId = "#area_id#";
		
		if(curAreaId != areaId) {
			$("##area_id").val(areaId);
			$("##area_name").val(areaName);

		} else {
			alert("Debe seleccionar una área distinta a la actual de la que proceden los datos");
		}
	}


	$(document).ready(function(){

		$("##dataTable").tablesorter({ 
			widgets: ['zebra'],
			headers: {
			      0: { sorter: false },
			      1: { sorter: false },
			      2: { sorter: false },
			      3: { sorter: false }
			   }
		});

	    $(".up,.down").click(function(event){

	    	event.stopPropagation();

	        var row = $(this).parents("tr:first");

	        var otherRow;

	        if ($(this).is(".up")) {

	        	otherRow = row.prev();
	        	//var prePos = parseInt($(preRow).find(".item_position").text());

	            row.insertBefore(otherRow);

	        } else {

	        	otherRow = row.next();

	            row.insertAfter(otherRow);

	        }

	       	var curPos = parseInt($(row).find(".item_position").text());
	       	var otherPos = parseInt($(otherRow).find(".item_position").text());

	        $(row).find(".field_position").val(otherPos);
	        $(row).find(".item_position").text(otherPos);

	        $(otherRow).find(".field_position").val(curPos);
	        $(otherRow).find(".item_position").text(curPos);

	        $(".up,.down").show();
	        $("tbody tr:first .up, tbody tr:last .down").hide();
	    });


	    $("tbody tr:first .up, tbody tr:last .down").hide();

	});


</script>
</cfoutput>

<div class="contenedor_fondo_blanco">

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfoutput>
<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" class="form-horizontal" onsubmit="return onSubmitForm();">

	<div id="submitDiv1" style="margin-bottom:10px;">
		<input type="submit" value="Guardar" class="btn btn-primary"/>

		<cfif page_type IS 2>
			<span class="divider">&nbsp;&nbsp;</span>

			<a href="#APPLICATION.htmlComponentsPath#/View.cfc?method=deleteViewRemote&view_id=#view_id#&itemTypeId=#itemTypeId##url_return_path#" onclick="return confirmDeleteView();" title="Eliminar campo" class="btn btn-danger btn-sm"><i class="icon-remove"></i> <span lang="es">Eliminar</span></a>
		</cfif>
	</div>
	<input type="hidden" name="page" value="#CGI.SCRIPT_NAME#"/>
	<input type="hidden" name="table_id" value="#table_id#"/>
	<input type="hidden" name="itemTypeId" value="#itemTypeId#"/>

	<cfif page_type IS 2>
		<input type="hidden" name="view_id" value="#view.view_id#"/>
	</cfif>

	<cfif isNumeric(view.area_id)>
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="viewArea">
			<cfinvokeargument name="area_id" value="#view.area_id#">
		</cfinvoke>
		<cfset areaName = viewArea.name>
	<cfelse>
		<cfset areaName = "">
	</cfif>
	

	<div class="row">
		<div class="col-xs-12 col-sm-8">
			<label class="control-label" for="area_name" lang="es">Área de publicación *</label>
			<input type="hidden" name="area_id" id="area_id" value="#view.area_id#" validate="integer" required="true"/>
			<cfinput type="text" name="area_name" id="area_name" value="#areaName#" readonly="true" required="true" message="Debe seleccionar una nueva área" onclick="openAreaSelector()" class="form-control" /> <button onclick="return openAreaSelector()" class="btn btn-default" lang="es">Seleccionar área</button>
			<cfif APPLICATION.publicationScope IS true AND isNumeric(table.publication_scope_id)>
				<span class="help-block">Ámbito de publicación definido: #table.publication_scope_name#</span>
			</cfif>
		</div>
	</div>

	<div class="row">
		<div class="col-xs-12 col-sm-8">
			<label for="title" class="control-label">Nombre *</label>
			<cfinput type="text" name="title" id="title" value="#view.title#" maxlength="100" required="true" message="Nombre requerido" class="form-control"/>
		</div>
	</div>

	<div class="row">
		<div class="col-xs-12 col-sm-8">
			<label for="description" class="control-label">Descripción</label>
			<textarea name="description" id="description" class="form-control" maxlength="1000">#view.description#</textarea>
		</div>
	</div>

	<div class="row">
		<div class="col-sm-12">
			<label class="control-label">Campos *</label>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-12">

			<!---Table fields--->
			<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
				<cfinvokeargument name="table_id" value="#table_id#">
				<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
				<cfinvokeargument name="with_types" value="true">
				<cfif page_type IS 2>
					<cfinvokeargument name="view_id" value="#view_id#">
					<cfinvokeargument name="only_view_fields" value="false">
				</cfif>
			</cfinvoke>
			<cfset fields = fieldsResult.tableFields>

			<cfif fields.recordCount GT 0>

				<!---<cfset fields_selectable = true>
				<cfinclude template="#APPLICATION.htmlPath#/includes/table_fields_list.cfm">--->

				<table id="dataTable" class="table-hover" style="margin-top:5px;">
					<thead>
						<tr>
							<th style="width:25px;text-align:center;"><input type="checkbox" name="select_all" onclick="toggleCheckboxesChecked(this.checked);"/></th>
							<th style="width:35%">Nombre del campo</th>
							<th>Tipo de campo</th>
							<th style="width:45px;">##</th>
						</tr>
					</thead>
					<tbody>

					<cfset queryRecordCount = fields.recordCount>

					<!--- 
						creation_date
						last_update_date
						insert_user
						update_user 
						--->
					
					<cfif page_type IS 2>

						<!--- <cfset maxPosition = 1> --->
						<cfset arrayPositions = arrayNew(1)>

						<cfloop query="fields">
							<cfset arrayAppend(arrayPositions, fields.view_position)>
							<!--- 
							<cfif fields.view_position GT maxPosition>
								<cfset maxPosition = fields.view_position>							
							</cfif> --->
							
						</cfloop>

						<cfset queryAddColumn(fields, "new_position", "integer", arrayPositions)>

					</cfif>

					<!--- creation_date --->
					<cfset queryAddRow(fields, 1)>
					<cfset querySetCell(fields, "field_id", "creation_date")>
					<cfset querySetCell(fields, "label", "Fecha de creación")>
					<cfset querySetCell(fields, "name", "Fecha")>
					<cfif page_type IS 2 AND isDefined("view.include_creation_date")>
						<cfif view.include_creation_date IS true>
							<cfset querySetCell(fields, "new_position", view.creation_date_position)>
							<cfset querySetCell(fields, "view_id", view_id)>
						</cfif>
					</cfif>

					<!--- last_update_date --->
					<cfset queryAddRow(fields, 1)>
					<cfset querySetCell(fields, "field_id", "last_update_date")>
					<cfset querySetCell(fields, "label", "Fecha de última modificación")>
					<cfset querySetCell(fields, "name", "Fecha")>
					<cfif page_type IS 2 AND isDefined("view.include_last_update_date")>
						<cfif view.include_last_update_date IS true>
							<cfset querySetCell(fields, "new_position", view.last_update_date_position)>
							<cfset querySetCell(fields, "view_id", view_id)>
						</cfif>
					</cfif>

					<!--- insert_user --->
					<cfset queryAddRow(fields, 1)>
					<cfset querySetCell(fields, "field_id", "insert_user")>
					<cfset querySetCell(fields, "label", "Usuario creación")>
					<cfset querySetCell(fields, "name", "Usuario")>
					<cfif page_type IS 2 AND isDefined("view.include_insert_user")>
						<cfif view.include_insert_user IS true>
							<cfset querySetCell(fields, "new_position", view.insert_user_position)>
							<cfset querySetCell(fields, "view_id", view_id)>
						</cfif>
					</cfif>

					<!--- update_user --->
					<cfset queryAddRow(fields, 1)>
					<cfset querySetCell(fields, "field_id", "update_user")>
					<cfset querySetCell(fields, "label", "Usuario última modificación")>
					<cfset querySetCell(fields, "name", "Usuario")>
					<cfif page_type IS 2 AND isDefined("view.include_update_user")>
						<cfif view.include_update_user IS true>
							<cfset querySetCell(fields, "new_position", view.update_user_position)>
							<cfset querySetCell(fields, "view_id", view_id)>
						</cfif>

						<cfquery dbtype="query" name="fieldsOrdered">
							SELECT * 
							FROM fields
							ORDER BY view_id DESC, new_position ASC; 
						</cfquery>

					<cfelse>

						<cfset fieldsOrdered = fields>

					</cfif>
	

					<cfloop query="fieldsOrdered">

						<!---<cfset rpage = "#tableTypeName#_fieldsOrdered.cfm?#tableTypeName#=#table_id#">
						<cfset field_page_url = "#tableTypeName#_field.cfm?field=#fieldsOrdered.field_id#&return_page=#URLEncodedFormat(rpage)#">--->

						<cfset fieldSelected = false>
						<cfif page_type IS 2 AND isNumeric(fieldsOrdered.view_id)>
							<cfset fieldSelected = true>
						</cfif>

						<tr onclick="toggleCheckboxChecked('##field_#fieldsOrdered.field_id#')">
							<td style="text-align:center;">

								<cfif isNumeric(fieldsOrdered.field_id)>
									<input type="checkbox" name="fields_ids[]" id="field_#fieldsOrdered.field_id#" value="#fieldsOrdered.field_id#" <cfif fieldSelected IS true>checked="checked"</cfif> onClick="stopPropagation(event);" />
								<cfelse>
									<input type="checkbox" name="include_#fieldsOrdered.field_id#" id="field_#fieldsOrdered.field_id#" value="true" <cfif fieldSelected IS true>checked="checked"</cfif> onClick="stopPropagation(event);" />
								</cfif>
								
							</td>
							<td>
								<span class="field_label">#fieldsOrdered.label#</span>
							</td>
							<td>
								#fieldsOrdered.name#
							</td>
							<td><!--- <cfif page_type IS 2>#fieldsOrdered.new_position#</cfif> --->

								<cfif isNumeric(fieldsOrdered.field_id)>
									<input type="hidden" name="field_#fieldsOrdered.field_id#_position" value="#fieldsOrdered.currentRow#" class="field_position"/>
								<cfelse>
									<input type="hidden" name="#fieldsOrdered.field_id#_position" value="#fieldsOrdered.currentRow#" class="field_position"/>
								</cfif>

								<div class="item_position">#fieldsOrdered.currentRow#</div><div class="change_position"><!---<cfif fieldsOrdered.currentRow NEQ 1>--->
								<cfset up_field_id = fieldsOrdered.field_id[fieldsOrdered.currentRow-1]>
								<a class="up"><img src="#APPLICATION.htmlPath#/assets/icons/up.jpg" alt="Subir" title="Subir"/></a><!---<cfelse><br></cfif>--->
								<!---<cfif fieldsOrdered.currentRow NEQ fieldsOrdered.recordCount>--->
									<cfset down_field = fieldsOrdered.field_id[fieldsOrdered.currentRow+1]>
									<a class="down"><img src="#APPLICATION.htmlPath#/assets/icons/down.jpg" alt="Bajar" title="Bajar"/></a>
								<!---</cfif>---></div></td>
						</tr>
					</cfloop>
					</tbody>
				</table>



			<cfelse>

				<span>No hay campos para seleccionar</span>

			</cfif>

		</div>
	</div>

	<div id="submitDiv2" style="margin-top:20px;">
		<input type="submit" value="Guardar" class="btn btn-primary"/>
		<!---<a href="area_items.cfm?area=#area_id#" class="btn btn-default">Cancelar</a>--->
	</div>
	
</cfform>
</cfoutput>
</div>