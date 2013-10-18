<!---page_types
1 Create and upload new file
2 Modify file
--->

<cfinclude template="#APPLICATION.htmlPath#/includes/area_file_form_query.cfm">

<cfoutput>
<script src="#APPLICATION.htmlPath#/language/file_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<div class="div_head_subtitle"><span lang="es"><cfif page_type IS 1>Nuevo Archivo
<cfelse>Modificar archivo</cfif></span></div>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<!---<cfset return_page = "area.cfm?area=#area_id#">--->

<cfoutput>

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

		if(check_custom_form())	{
			document.getElementById("submitDiv").innerHTML = window.lang.convert("Enviando archivo...");

			return true;
		}
		else
			return false;
	}

	<cfif APPLICATION.modulefilesWithTables IS true><!--- Typologies --->

	function loadTypology(typologyId,rowId) {

		if(!isNaN(typologyId)){

			$("##areaLoading").show();

			var typologyPage = "#APPLICATION.htmlPath#/html_content/typology_row_form_inputs.cfm?typology="+typologyId;

			if(!isNaN(rowId)){
				typologyPage = typologyPage+"&row="+rowId;
			}

			$("##typologyContainer").load(typologyPage, function() {

				$("##areaLoading").hide();

			});

		} else {

			$("##typologyContainer").empty();
		}
	}

	function enableDatePicker(selector){

		$(selector).datepicker({
		  format: 'dd-mm-yyyy', 
		  autoclose: true,
		  weekStart: 1,
		  language: 'es',
		  todayBtn: 'linked'
		});
	}

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

	<!--- Typologies --->
	<cfif APPLICATION.modulefilesWithTables IS true>

		<cfif isNumeric(file.typology_id)>
			<cfset selected_typology_id = file.typology_id>
		<cfelse>
			<cfset selected_typology_id = default_typology_id>
		</cfif>

		<label for="typology_id">Tipología *</label>
		<select name="typology_id" id="typology_id" class="span3" onchange="loadTypology($('##typology_id').val(),'');">
			<option value="" <cfif NOT isNumeric(file.typology_id)>selected="selected"</cfif>>Básica</option>
			<cfloop query="#areaTables#">
				<option value="#areaTables.id#" <cfif areaTables.id IS selected_typology_id>selected="selected"</cfif> <cfif default_typology_id IS areaTables.id>style="font-weight:bold"</cfif>>#areaTables.title#</option>
			</cfloop>
		</select>

	</cfif>
	
	<cfif page_type IS 1>
		<label for="formFile" lang="es">Archivo *</label>
		<input type="file" name="Filedata" value="" id="formFile" required="required" />

		<script type="text/javascript">
			addRailoRequiredTextInput("Filedata", "Debe seleccionar un archivo para subir");
		</script>
	</cfif>
	
	<label for="formFileName" lang="es">Nombre *</label>
	<input type="text" name="name" value="#file.name#" id="formFileName" class="input-block-level" required="required" />

	<script type="text/javascript">
		addRailoRequiredTextInput("name", "Debe especificar un nombre para el archivo");
	</script>
	
	<label for="description" lang="es">Descripción</label> 
	<textarea name="description" id="description" class="input-block-level">#file.description#</textarea>

	<!--- Typology fields --->
	<div id="typologyContainer"></div>
	
	<div style="height:10px;"><!--- ---></div>

	<div id="submitDiv">
		<input type="submit" class="btn btn-primary" name="modify" value="Enviar" lang="es"/>

		<cfif page_type IS 2>
			<a href="file.cfm?file=#file_id#&area=#area#" class="btn" style="float:right">Cancelar</a>
		</cfif>
	</div>
	<small lang="es">Una vez pulsado el botón, la solicitud tardará dependiendo del tamaño del archivo.</small><br/>
	<small lang="es">* Campos obligatorios.</small>
</cfform>

</div>

</cfoutput>