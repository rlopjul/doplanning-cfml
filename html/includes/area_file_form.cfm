<!---page_types
1 Create and upload new file
2 Modify file
--->

<cfinclude template="#APPLICATION.htmlPath#/includes/area_file_form_query.cfm">

<cfoutput>
<script src="#APPLICATION.htmlPath#/language/file_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<div class="div_head_subtitle"><span lang="es"><cfif page_type IS 1>Nuevo Archivo
<cfelse>Modificar archivo</cfif></span></div>

<!---<cfset return_page = "area.cfm?area=#area_id#">--->

<cfoutput>

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

	<cfif page_type IS 2>
		
		<cfif isNumeric(file.typology_id) AND isNumeric(file.typology_row_id)>
			
			loadTypology(#file.typology_id#, #file.typology_row_id#);

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
</script>

<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js"></script>

<cfif APPLICATION.modulefilesWithTables IS true>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getAreaTables" returnvariable="getAreaTablesResponse">
		<cfinvokeargument name="area_id" value="#area_id#">
		<cfinvokeargument name="tableTypeId" value="3">
	</cfinvoke>
	<cfset areaTables = getAreaTablesResponse.areaTables>	

</cfif>


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

		<label for="typology_id">Tipología *</label>
		<select name="typology_id" id="typology_id" class="span3" onchange="loadTypology($('##typology_id').val(),'');">
			<option value="" <cfif NOT isNumeric(file.typology_id)>selected="selected"</cfif>>Básica</option>
			<cfloop query="#areaTables#">
				<option value="#areaTables.id#" <cfif file.typology_id IS areaTables.id>selected="selected"</cfif>>#areaTables.title#</option>	
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

	<div id="submitDiv"><input type="submit" class="btn btn-primary" name="modify" value="Enviar" lang="es"/></div>
	<small lang="es">Una vez pulsado el botón, la solicitud tardará dependiendo del tamaño del archivo.</small><br/>
	<small lang="es">* Campos requeridos.</small>
</cfform>

</div>

</cfoutput>