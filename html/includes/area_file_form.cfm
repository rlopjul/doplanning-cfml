<!---page_types
1 Create and upload new file
2 Modify file
3 Publish area file (version)
--->

<cfinclude template="#APPLICATION.htmlPath#/includes/area_file_form_query.cfm">

<cfoutput>
<script src="#APPLICATION.htmlPath#/language/file_content_en.js" charset="utf-8" type="text/javascript"></script>

<script src="#APPLICATION.htmlPath#/ckeditor/ckeditor.js?v=4.4.4.4"></script>
<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
<script src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
<script src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>

<script src="#APPLICATION.htmlPath#/scripts/tablesFunctions.js"></script>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<div class="div_head_subtitle"><span lang="es"><cfif page_type IS 1>Nuevo Archivo<cfelseif page_type IS 2>Modificar Archivo<cfelseif page_type IS 3>Publicar versión de archivo</cfif><cfif fileTypeId IS 2> de área</cfif></span></div>

<!---<cfset return_page = "area.cfm?area=#area_id#">--->

<cfoutput>

<cfif APPLICATION.modulefilesWithTables IS true><!--- Typologies --->

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getAreaDefaultTable" returnvariable="getDefaultTableResponse">
		<cfinvokeargument name="area_id" value="#area_id#">
		<cfinvokeargument name="tableTypeId" value="3">
	</cfinvoke>
	<cfset default_typology_id = getDefaultTableResponse.table_id> 

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getAreaTables" returnvariable="getAreaTablesResponse">
		<cfinvokeargument name="area_id" value="#area_id#">
		<cfinvokeargument name="tableTypeId" value="3">
	</cfinvoke>
	<cfset areaTables = getAreaTablesResponse.areaTables>	

</cfif>

<script>

	$(document).ready(function() {

		$('##formFile').change(function(e){
			$inputFile=$(this);
		  	  
	     	var fileName = $inputFile.val();
			
		  	if(fileName.length > 0) {
			  fileName = fileName.substr(fileName.lastIndexOf('\\') + 1);
					  
			  if($('##formFileName').val().length == 0)
			  	$('##formFileName').val(fileName);
			}
			
		});

		<cfif len(area_type) GT 0><!--- WEB --->

			$('##publication_date').datepicker({
			  format: 'dd-mm-yyyy',
			  weekStart: 1,
			  language: 'es',
			  todayBtn: 'linked', 
			  autoclose: true
			});

		</cfif>

		<cfif APPLICATION.modulefilesWithTables IS true><!--- Typologies --->

			<cfif isNumeric(file.typology_id)>
				<cfset selected_typology_id = file.typology_id>
			<cfelseif page_type IS NOT 2><!---IS NOT modify file page--->
				<cfset selected_typology_id = default_typology_id>
			<cfelse>
				<cfset selected_typology_id = "">
			</cfif>

			<cfif isNumeric(selected_typology_id)>
				<cfif page_type IS 1>
					loadTypology(#selected_typology_id#, '');
				<cfelseif isDefined("file.typology_row_id") AND isNumeric(file.typology_row_id)>
					loadTypology(#selected_typology_id#, #file.typology_row_id#);
				<cfelse>
					loadTypology(#selected_typology_id#, '');
				</cfif>
			</cfif>
				
		</cfif>	

		<cfif page_type IS NOT 3>
			setFileTypeId("#fileTypeId#");
		</cfif>

		<cfif page_type IS 1 AND fileTypeId NEQ 1>
			$("##file-type-help").tooltip();
		</cfif>

	});

	function onSubmitForm() {

		// Update textareas content from ckeditor
		for (var i in CKEDITOR.instances) {

		    (function(i){
		        CKEDITOR.instances[i].updateElement();
		    })(i);

		}

		if(check_custom_form())	{
			document.getElementById("submitDiv").innerHTML = window.lang.translate("Enviando archivo...");

			return true;
		}
		else
			return false;
	}

	function setFileTypeId(fileTypeId) {

		if(fileTypeId == 3){

			$("##documentUsersContainer").show();
			$("##publicationScopeContainer").hide();


		}else{

			$("##documentUsersContainer").hide();
			$("##publicationScopeContainer").show();
		}

	}

	var selectUserType = "";

	function openUserSelector(){

		 return openPopUp('#APPLICATION.htmlPath#/iframes/area_users_select.cfm?area=#area_id#');
	}

	function openUserSelectorWithField(fieldName){

		selectUserType = fieldName;
		return openPopUp('#APPLICATION.htmlPath#/iframes/users_select.cfm?field='+fieldName);

	}

	function openReviserUserSelector(){

		selectUserType = "reviser";
		openUserSelector();

	}

	function openApproverUserSelector(){

		selectUserType = "approver";
		openUserSelector();

	}

	function setSelectedUser(userId, userName, fieldName) {

		if(selectUserType.length != 0) {

			if(selectUserType == "reviser" || selectUserType == "approver"){
				document.getElementById(selectUserType+"_user").value = userId;
				document.getElementById(selectUserType+"_user_full_name").value = userName;
			}else{
				document.getElementById(fieldName).value = userId;
				document.getElementById(fieldName+"_user_full_name").value = userName;
			}

			selectUserType = "";	

		} else {
			alert("Error al asignar el usuario");
		}

					
	}

	function clearFieldSelectedUser(fieldName) {

		document.getElementById(fieldName).value = "";
		document.getElementById(fieldName+"_user_full_name").value = "";
	}

	function openItemSelectorWithField(itemTypeId,fieldName){

		return openPopUp('#APPLICATION.htmlPath#/iframes/all_items_select.cfm?itemTypeId='+itemTypeId+'&field='+fieldName);

	}


	function openAreaSelector(){
		
		return openPopUp('#APPLICATION.htmlPath#/iframes/area_select.cfm');
		
	}

	function setSelectedArea(areaId, areaName) {

		<!---var curAreaId = "#file_area_id#";
				
				if(curAreaId != areaId) { --->
		
			$("##publication_area_id").val(areaId);
			$("##publication_area_name").val(areaName);

		<!---} else {
			alert("Debe seleccionar una área distinta a la actual");
		}--->
	}

	<cfif APPLICATION.modulefilesWithTables IS true><!--- Typologies --->

	function loadTypology(typologyId,rowId) {

		if(!isNaN(typologyId)){

			showLoadingPage(true);

			var typologyPage = "#APPLICATION.htmlPath#/html_content/typology_row_form_inputs.cfm?typology="+typologyId;

			if(!isNaN(rowId)){
				typologyPage = typologyPage+"&row="+rowId;
			}

			$("##typologyContainer").load(typologyPage, function() {

				showLoadingPage(false);

			});

		} else {

			$("##typologyContainer").empty();
		}
	}

	<!---function enableDatePicker(selector){

		$(selector).datepicker({
		  format: 'dd-mm-yyyy', 
		  autoclose: true,
		  weekStart: 1,
		  language: 'es',
		  todayBtn: 'linked'
		});
	}--->

	</cfif>
</script>

<script src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js?v=2"></script>


<div class="contenedor_fondo_blanco">

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" enctype="multipart/form-data" name="file_form" class="form-horizontal" onsubmit="return onSubmitForm();">
	
	<script>
		var railo_custom_form=new RailoForms('file_form');
	</script>
	
	<input type="hidden" name="page" value="#CGI.SCRIPT_NAME#" />
	<cfif page_type IS 1>
		<input type="hidden" name="area_id" value="#area_id#"/>
	<cfelse>
		<input type="hidden" name="file_id" value="#file_id#" />
	</cfif>
	
	<cfif page_type IS 3>
		<input type="hidden" name="version_id" value="#version_id#"/>
	</cfif>


	<cfif fileTypeId IS 2 OR fileTypeId IS 3><!---Area files--->

		<cfif page_type IS 1>

			<div class="alert alert-info">
				<small lang="es">Este archivo pertenecerá a esta <b>área</b> y podrá ser modificado por cualquier usuario con acceso a la misma.</small>
			</div>

		<cfelseif page_type IS 3>

			<!---<div class="alert alert-info">
				<small>Este archivo pertenecerá al área de la que procede.</small>
			</div>--->

			<div class="row">
				<div class="col-sm-12">
					<label for="publication_area_name" class="control-label" lang="es">Área de publicación</label>
					<div class="controls">
						<input type="hidden" name="publication_area_id" id="publication_area_id" value="#publicationArea.publication_area_id#" validate="integer" required="true"/>
						<cfinput type="text" name="publication_area_name" id="publication_area_name" value="#publicationArea.publication_area_name#" readonly="true" required="true" message="Debe seleccionar una área para publicar" onclick="openAreaSelector()" /> <button onclick="return openAreaSelector()" class="btn btn-default" lang="es">Seleccionar área</button>
					</div>
				</div>
			</div>

		</cfif>

		<cfif APPLICATION.moduleAreaFilesLite IS true AND page_type IS 1>

			<div class="row">
				<div class="col-sm-12">
					<label for="fileTypeId" class="control-label" lang="es">Tipo de documento de área <i id="file-type-help" class="icon-question-sign" data-toggle="tooltip" data-placement="bottom" data-html="true" title="<b>Sin circuito de calidad</b>: cada vez que se suba una versión del archivo se sobreescribirá la anterior (no se guardan las versiones previas del archivo)</p><br><b>Con circuito de calidad</b>: se guardan las distintas versiones del archivo y es requerido un proceso de revisión y aprobación de las versiones." lang="es" style="cursor:pointer"></i></label>
					<select name="fileTypeId" id="fileTypeId" class="form-control" onchange="setFileTypeId($('##fileTypeId').val());">
						<option value="2" <cfif fileTypeId IS 2>selected="selected"</cfif> lang="es">Sin circuito de calidad</option>
						<option value="3" <cfif fileTypeId IS 3>selected="selected"</cfif> lang="es">Con circuito de calidad</option>
					</select>
					<small class="help-block" lang="es">Esta opción no se puede cambiar una vez creado el documento</small>
				</div>
			</div>

		<cfelse>

			<cfif page_type IS 1>
				<cfif fileTypeId IS 2>
					<input type="hidden" name="fileTypeId" value="3"/>
				<cfelse>
					<input type="hidden" name="fileTypeId" value="#fileTypeId#"/>
				</cfif>
			<cfelse>
				<input type="hidden" name="fileTypeId" value="#fileTypeId#"/>
			</cfif>
			
		</cfif>		
			
		<div id="documentUsersContainer">
			<cfif page_type IS NOT 3 AND ( page_type IS NOT 2 OR ( (isDefined("file.file_type_id") AND file.file_type_id IS 3) OR (isDefined("fileTypeId") AND fileTypeId IS 3) ) )>
				<div class="row">
					<div class="col-sm-12">

						<label class="control-label" for="reviser_user" lang="es">Usuario revisor</label>

						<div class="row">
							<div class="col-sm-5" style="padding-right:0;">
								<input type="hidden" name="reviser_user" id="reviser_user" value="#file.reviser_user#" validate="integer" required="true" />
								<cfinput type="text" name="reviser_user_full_name" id="reviser_user_full_name" value="#file.reviser_user_full_name#" readonly="true" required="true" message="Debe seleccionar un usuario revisor" onclick="openReviserUserSelector()" /> 
							</div>
							<div class="col-sm-7">
								<button onclick="openReviserUserSelector()" type="button" class="btn btn-default" lang="es">Seleccionar usuario</button>
							</div>
						</div>

					</div>
				</div>

				<div class="row">
					<div class="col-sm-12">

						<label class="control-label" for="approver_user" lang="es">Usuario aprobador</label>
						
						<div class="row">
							<div class="col-sm-5" style="padding-right:0;">
								<input type="hidden" name="approver_user" id="approver_user" value="#file.approver_user#" validate="integer" required="true"/>
								<cfinput type="text" name="approver_user_full_name" id="approver_user_full_name" value="#file.approver_user_full_name#" readonly="true" required="true" message="Debe seleccionar un usuario aprobador" onclick="openApproverUserSelector()" />
							</div>
							<div class="col-sm-7">
								<button onclick="openApproverUserSelector()" type="button" class="btn btn-default" lang="es">Seleccionar usuario</button>
							</div>
						</div>
					</div>
				</div>
			</cfif>
		</div>

	<cfelse>

		<cfif page_type IS 1>

			<div class="alert alert-info">
				<small lang="es">Este archivo te pertenecerá a ti y sólo tú podrás modificarlo. Cada vez que subas una versión del archivo se sobreescribirá la anterior.</small>
			</div>

		</cfif>

		<input type="hidden" name="fileTypeId" value="#fileTypeId#"/>

	</cfif>

	<!--- Typologies --->
	<cfif APPLICATION.modulefilesWithTables IS true>

		<div class="row">
			<div class="col-sm-12">
				<label for="typology_id" class="control-label"><span lang="es">Tipología</span> *</label>
				<select name="typology_id" id="typology_id" onchange="loadTypology($('##typology_id').val(),'');" class="form-control">
					<option value="" <cfif NOT isNumeric(selected_typology_id)>selected="selected"</cfif> lang="es">Básica</option>
					<cfif areaTables.recordCount GT 0>
						<cfloop query="areaTables">
							<option value="#areaTables.id#" <cfif areaTables.id IS selected_typology_id>selected="selected"</cfif> <cfif default_typology_id IS areaTables.id>style="font-weight:bold"</cfif>>#areaTables.title#</option>
						</cfloop>
					</cfif>
				</select>
			</div>
		</div>

	</cfif>
	
	<cfif page_type IS 1>
		<div class="row">
			<div class="col-sm-12">
				<label for="formFile" class="control-label"><span lang="es">Archivo</span> *</label>
				<input type="file" name="Filedata" value="" id="formFile" required="required" />

				<script type="text/javascript">
					addRailoRequiredTextInput("Filedata", "Debe seleccionar un archivo para subir");
				</script>
			</div>
		</div>
	</cfif>
	
	<div class="row">
		<div class="col-sm-12">
			<label for="formFileName" class="control-label" lang="es"><span lang="es">Nombre</span> *</label>
			<input type="text" name="name" value="#file.name#" id="formFileName" required="required" class="form-control"/>

			<script type="text/javascript">
				addRailoRequiredTextInput("name", "Debe especificar un nombre para el archivo");
			</script>
		</div>
	</div>

	<div class="row">
		<div class="col-sm-12">
			<label for="description" class="control-label" lang="es">Descripción</label> 
			<textarea name="description" id="description" class="form-control">#file.description#</textarea>
		</div>
	</div>

	<cfif APPLICATION.publicationScope IS true AND (page_type IS 3 OR fileTypeId NEQ 3)><!--- A los archivos de área con circuito de calidad no se les define ambito de publicación porque no pueden ser publicados directamente en otras áreas --->

		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Scope" method="getScopes" returnvariable="getScopesResult">
		</cfinvoke>
		<cfset scopesQuery = getScopesResult.scopes>
		
		<cfif scopesQuery.recordCount GT 0>
			
			<div class="row" id="publicationScopeContainer">
				<div class="col-sm-12">
					<label for="publication_scope_id" class="control-label" lang="es">Ámbito de publicación</label>
					<select name="publication_scope_id" id="publication_scope_id" class="form-control">
						<cfloop query="scopesQuery">
							<option value="#scopesQuery.scope_id#" <cfif file.publication_scope_id IS scopesQuery.scope_id>selected="selected"</cfif>>#scopesQuery.name#</option>
						</cfloop>
					</select>
					<small class="help-block" lang="es">Define dónde se podrá publicar el documento</small>
				</div>
			</div>

		</cfif>
		
	</cfif>

	<cfif ( len(area_type) GT 0 OR page_type IS 3 ) AND page_type IS NOT 2><!--- WEB or Publish file version--->

		<div class="row">

			<cfif isDefined("file.publication_hour")><!--- After send FORM --->

				<cfset publication_hour = file.publication_hour>
				<cfset publication_minute = file.publication_minute>

			<cfelse>
				
				<cfset publication_hour = timeFormat(file.publication_date, "HH")>
				<cfset publication_minute = timeFormat(file.publication_date, "mm")>

				<cfif len(file.publication_date) GT 10>
					<cfset file.publication_date = left(file.publication_date, findOneOf(" ", file.publication_date))>
				</cfif>

			</cfif>

			<div class="col-xs-6 col-md-3">
				<label class="control-label" for="publication_date"><span lang="es">Fecha de publicación</span></label>
				<cfinput type="text" name="publication_date" id="publication_date" class="form-control" value="#file.publication_date#" required="false" message="Fecha de publicación válida requerida" validate="eurodate" mask="DD-MM-YYYY">
			</div>
						
			<div class="col-xs-6">
				 
				<!--- 
				<label class="control-label" for="publication_hour"><span lang="es">Hora de publicación</span></label>
				<div class="input-group" style="width:170px">
					<select name="publication_hour" id="publication_hour" class="form-control" style="width:70px;">
						<cfloop from="00:00" to="23:00" step="#CreateTimeSpan(0, 1, 0, 0)#" index="hour">
							<cfset curHour = TimeFormat(hour, 'HH')>
							<option value="#curHour#" <cfif curHour EQ publication_hour>selected="selected"</cfif>>#curHour#</option>
						</cfloop>
					</select><span class="input-group-addon">:</span><select name="publication_minute" class="form-control" style="width:70px;">
						<cfset minutesInOptions = false>
						<cfloop from="0" to="59" index="minutes" step="5">
							<cfif len(minutes) EQ 1>
								<cfset minutes = "0"&minutes>
							</cfif>
							<cfif minutes EQ publication_minute>
								<cfset minutesSelected = true>
								<cfset minutesInOptions = true>
							<cfelse>
								<cfset minutesSelected = false>
							</cfif>
							<option value="#minutes#" <cfif minutesSelected>selected="selected"</cfif>>#minutes#</option>
						</cfloop>
						<cfif minutesInOptions IS false AND len(publication_minute) GT 0>
							<option value="#publication_minute#" selected="selected">#publication_minute#</option>
						</cfif>
					</select>
				</div> --->
				
			</div>
			
			<input type="hidden" name="publication_hour" value="00"/>
			<input type="hidden" name="publication_minute" value="00"/>
			
		</div>

		<div class="row">
			<div class="col-sm-12">
				<small class="help-block" lang="es">Si está definida, el archivo se publicará en la fecha especificada (sólo para publicación en web e intranet).</small>
			</div>
		</div>

		<cfif APPLICATION.publicationValidation IS true>

			<!--- isUserAreaResponsible --->
			<cfif is_user_area_responsible IS true>
				
				<div class="row">
					<div class="col-xs-12 col-sm-8">
						<div class="checkbox">
							<label>
								<input type="checkbox" name="publication_validated" id="publication_validated" value="true" class="checkbox_locked" <cfif isDefined("file.publication_validated") AND file.publication_validated IS true>checked="checked"</cfif> /> Aprobar publicación
							</label>
							<small class="help-block" lang="es">Valida el archivo para que pueda ser publicado (sólo para publicación en web e intranet).</small>
						</div>
					</div>
				</div>

			</cfif>

		</cfif>

	</cfif>


	<!--- Typology fields --->
	<div id="typologyContainer"></div>

	<cfif fileTypeId IS NOT 1 AND page_type IS 2>
		
		<div class="checkbox">
		    <label>
		    	<input type="checkbox" name="unlock" value="true" checked> Desbloquear archivo tras guardar modificación
		    </label>
	  	</div>

	</cfif>
	
	<div style="height:10px;"><!--- ---></div>

	<div id="submitDiv">
		<input type="submit" class="btn btn-primary" name="modify" value="Enviar" lang="es"/>

		<cfif page_type IS 2>
			<a href="file.cfm?file=#file_id#&area=#area#" class="btn btn-default" style="float:right" lang="es">Cancelar</a>
		</cfif>
	</div>
	<br/>
	<small lang="es">Una vez pulsado el botón, la solicitud tardará dependiendo del tamaño del archivo.</small><br/>
	<small lang="es">* Campos obligatorios.</small>
</cfform>

</div>

</cfoutput>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/CKEditorManager" method="loadComponent">
	<cfinvokeargument name="name" value="description">
	<cfinvokeargument name="language" value="#SESSION.user_language#"/>
	<cfinvokeargument name="toolbarStartupExpanded" value="false"/>
	<cfinvokeargument name="toolbarCanCollapse" value="true"/>
	<cfinvokeargument name="height" value="180"/>
</cfinvoke>