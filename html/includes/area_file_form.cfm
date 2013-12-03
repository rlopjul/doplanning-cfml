<!---page_types
1 Create and upload new file
2 Modify file
--->

<cfif isDefined("URL.fileTypeId") AND isNumeric(URL.fileTypeId)>
	<cfset fileTypeId = URL.fileTypeId>
<cfelse>
	<cflocation url="empty.cfm" addtoken="no">
</cfif>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_file_form_query.cfm">

<cfoutput>
<script src="#APPLICATION.htmlPath#/language/file_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<div class="div_head_subtitle"><span lang="es"><cfif page_type IS 1>Nuevo Archivo
<cfelse>Modificar archivo</cfif><cfif fileTypeId IS 2> de área</cfif></span></div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<!---<cfset return_page = "area.cfm?area=#area_id#">--->

<cfoutput>

<script src="#APPLICATION.htmlPath#/ckeditor/ckeditor.js" type="text/javascript"></script>
<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
<script type="text/javascript" src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>


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

<script type="text/javascript">

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

		<cfif APPLICATION.modulefilesWithTables IS true><!--- Typologies --->
			<cfif page_type IS 1>

				<cfif isNumeric(file.typology_id)>
					loadTypology(#file.typology_id#, '');
				<cfelseif isNumeric(default_typology_id)>
					loadTypology(#default_typology_id#, '');
				</cfif>
				
			<cfelse>
				
				<cfif isNumeric(file.typology_id)>

					<cfif isNumeric(file.typology_row_id)>
						loadTypology(#file.typology_id#, #file.typology_row_id#);
					<cfelse>
						loadTypology(#file.typology_id#, '');
					</cfif>

				</cfif>

			</cfif>
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
			document.getElementById("submitDiv").innerHTML = window.lang.convert("Enviando archivo...");

			return true;
		}
		else
			return false;
	}

	function setFileTypeId(fileTypeId) {

		if(fileTypeId == 3){

			$("##documentUsersContainer").show();

		}else{

			$("##documentUsersContainer").hide();
		}

	}

	var selectUserType = "";

	function openUserSelector(){

		 return openPopUp('#APPLICATION.htmlPath#/iframes/area_users_select.cfm?area=#area_id#');
	}

	function openReviserUserSelector(){

		selectuserType = "reviser";
		openUserSelector();
	}

	function openApproverUserSelector(){

		selectuserType = "approver";
		openUserSelector();
	}

	function setSelectedUser(userId, userName) {

		document.getElementById(selectuserType+"_user").value = userId;
		document.getElementById(selectuserType+"_user_full_name").value = userName;

		selectuserType = "";				
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

<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js?v=2"></script>


<div class="contenedor_fondo_blanco">

<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" enctype="multipart/form-data" name="file_form" onsubmit="return onSubmitForm();">
	
	<script type="text/javascript">
		var railo_custom_form=new RailoForms('file_form');
	</script>
	
	<input type="hidden" name="page" value="#CGI.SCRIPT_NAME#" />
	<cfif page_type IS 2>
		<input type="hidden" name="file_id" value="#file_id#" />
	</cfif>
	<input type="hidden" name="area_id" value="#area_id#"/>

	<cfif fileTypeId IS 2 OR fileTypeId IS 3><!---Area files--->

		<cfif page_type IS 1>

			<div class="alert alert-info">
				<small>Este archivo pertenecerá a esta área y podrá ser modificado por cualquier usuario con acceso a la misma.</small>
			</div>

		</cfif>

		<cfif APPLICATION.moduleAreaFilesLite IS true AND page_type IS 1>

			<div class="form-group">
				<label for="fileTypeId">Tipo de documento de área</label>
				<select name="fileTypeId" id="fileTypeId" class="form-control" onchange="setFileTypeId($('##fileTypeId').val());">
					<option value="2">Sin circuito de calidad</option>
					<option value="3">Con circuito de calidad</option>
				</select>
				<span class="help-block">Esta opción no se puede cambiar una vez creado el documento</span>

			    <!---
				<cfif isDefined("FORM.phases_enabled") IS true>
					<cfset phases_enabled = true>
				<cfelse>
					<cfset phases_enabled = false>
				</cfif>
			    <div class="checkbox">
			       	<label>
			          <input type="checkbox" name="phases_enabled" value="true" <cfif phases_enabled IS true>checked="checked"
			          </cfif>/> Circuito de calidad
			        </label>
			    </div>--->
			</div>

		<cfelse>

			<input type="hidden" name="fileTypeId" value="3"/>
			
		</cfif>

		<div id="documentUsersContainer">
			<div class="form-group">
				<label class="control-label" for="reviser_user" lang="es">Usuario revisor</label>
				<input type="hidden" name="reviser_user" id="reviser_user" value="#file.reviser_user#" validate="integer" required="true" />
				<div class="container" style="width:100%">
					<div class="row">
						<div class="col-sm-6" style="padding:0;">
							<cfinput type="text" name="reviser_user_full_name" id="reviser_user_full_name" value="#file.reviser_user_full_name#" readonly="true" required="true" message="Debe seleccionar un usuario revisor" onclick="openReviserUserSelector()" /> 
						</div>
						<div class="col-sm-5"><button onclick="openReviserUserSelector()" type="button" class="btn btn-default" lang="es">Seleccionar usuario</button></div>
					</div>
				</div>
			</div>

			<div class="form-group">
				<label class="control-label" for="approver_user" lang="es">Usuario aprobador</label>
				
				<input type="hidden" name="approver_user" id="approver_user" value="#file.approver_user#" validate="integer" required="true"/>
				<cfinput type="text" name="approver_user_full_name" id="approver_user_full_name" value="#file.approver_user_full_name#" readonly="true" required="true" message="Debe seleccionar un usuario aprobador" onclick="openApproverUserSelector()" /> <button onclick="openApproverUserSelector()" type="button" class="btn btn-default" lang="es">Seleccionar usuario</button>
			</div>
		</div>

	<cfelse>

		<input type="hidden" name="fileTypeId" value="#fileTypeId#"/>

	</cfif>

	<!---<cfif APPLICATION.moduleAreaFiles IS true>
		<div class="form-group">
			<label for="fileTypeId">Tipo de archivo</label>
			<select name="fileTypeId" id="fileTypeId" class="col-md-3">
				<option value="1" <cfif file.fileTypeId IS 1>selected="selected"</cfif>>Documento de usuario</option>
				<option value="2" <cfif file.fileTypeId IS 2>selected="selected"</cfif>>Documento de área</option>
				<option value="3" <cfif file.fileTypeId IS 3>selected="selected"</cfif>>Documento de área con circuito de calidad</option>
			</select>
		</div>
	</cfif>--->

	<!--- Typologies --->
	<cfif APPLICATION.modulefilesWithTables IS true>

		<cfif isNumeric(file.typology_id)>
			<cfset selected_typology_id = file.typology_id>
		<cfelse>
			<cfset selected_typology_id = default_typology_id>
		</cfif>
		<div class="form-group">
			<label for="typology_id" class="control-label">Tipología *</label>
			<select name="typology_id" id="typology_id" onchange="loadTypology($('##typology_id').val(),'');">
				<option value="" <cfif NOT isNumeric(selected_typology_id)>selected="selected"</cfif>>Básica</option>
				<cfif areaTables.recordCount GT 0>
					<cfloop query="#areaTables#">
						<option value="#areaTables.id#" <cfif areaTables.id IS selected_typology_id>selected="selected"</cfif> <cfif default_typology_id IS areaTables.id>style="font-weight:bold"</cfif>>#areaTables.title#</option>
					</cfloop>
				</cfif>
			</select>
		</div>

	</cfif>
	
	<cfif page_type IS 1>
		<div class="form-group">
			<label for="formFile" lang="es">Archivo *</label>
			<input type="file" name="Filedata" value="" id="formFile" required="required" />

			<script type="text/javascript">
				addRailoRequiredTextInput("Filedata", "Debe seleccionar un archivo para subir");
			</script>
		</div>
	</cfif>
	
	<div class="form-group">
		<label for="formFileName" lang="es">Nombre *</label>
		<input type="text" name="name" value="#file.name#" id="formFileName" class="input-block-level" required="required" />

		<script type="text/javascript">
			addRailoRequiredTextInput("name", "Debe especificar un nombre para el archivo");
		</script>
	</div>

	<div class="form-group">
		<label for="description" lang="es">Descripción</label> 
		<textarea name="description" id="description" class="input-block-level">#file.description#</textarea>
	</div>

	<!--- Typology fields --->
	<div id="typologyContainer"></div>
	
	<div style="height:10px;"><!--- ---></div>

	<div id="submitDiv">
		<input type="submit" class="btn btn-primary" name="modify" value="Enviar" lang="es"/>

		<cfif page_type IS 2>
			<a href="file.cfm?file=#file_id#&area=#area#" class="btn btn-default" style="float:right">Cancelar</a>
		</cfif>
	</div>
	<br/>
	<small lang="es">Una vez pulsado el botón, la solicitud tardará dependiendo del tamaño del archivo.</small><br/>
	<small lang="es">* Campos obligatorios.</small>
</cfform>

</div>

</cfoutput>