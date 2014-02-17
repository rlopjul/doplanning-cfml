<cfinclude template="#APPLICATION.htmlPath#/includes/file_change_area_query.cfm">

<cfoutput>
<script src="#APPLICATION.htmlPath#/language/file_content_en.js" charset="utf-8" type="text/javascript"></script>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<div class="div_head_subtitle"><span lang="es">Mover archivo a otra área</span></div>

<cfoutput>

<script>

	function onSubmitForm() {

		if(check_custom_form())	{
			document.getElementById("submitDiv").innerHTML = window.lang.convert("Enviando...");

			return true;
		}
		else
			return false;
	}

	function openAreaSelector(){
		
		return openPopUp('#APPLICATION.htmlPath#/iframes/area_select.cfm');
		
	}

	function setSelectedArea(areaId, areaName) {

		var curAreaId = "#file_area_id#";
		
		if(curAreaId != areaId) {
			$("##new_area_id").val(areaId);
			$("##new_area_name").val(areaName);

		} else {
			alert("Debe seleccionar una área distinta a la actual");
		}
	}

</script>

<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js"></script>

<div class="contenedor_fondo_blanco">

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" enctype="multipart/form-data" name="file_form" class="form-horizontal" onsubmit="return onSubmitForm();">
	
	<script type="text/javascript">
		var railo_custom_form=new RailoForms('file_form');
	</script>
	
	<input type="hidden" name="page" value="#CGI.SCRIPT_NAME#" />
	<input type="hidden" name="file_id" value="#file_id#"/>
	<input type="hidden" name="area_id" value="#area_id#"/>

	<div class="row">
		<div class="col-sm-12">
			<span lang="es">Nombre del archivo:</span>
			<strong>#file.name#</strong>
		</div>
	</div>

	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Area" method="getArea" returnvariable="fileArea">
		<cfinvokeargument name="area_id" value="#file_area_id#">
	</cfinvoke>
	
	<div class="row">
		<div class="col-sm-12">
			<span>Área actual:</span>
			<strong>#fileArea.name#</strong>
		</div>
	</div>
	
	<div class="row">
		<div class="col-xs-12 col-sm-8">
			<label class="control-label" for="new_area_name" lang="es">Nueva área</label>
			<input type="hidden" name="new_area_id" id="new_area_id" value="#newArea.new_area_id#" validate="integer" required="true"/>
			<cfinput type="text" name="new_area_name" id="new_area_name" value="#newArea.new_area_name#" readonly="true" required="true" message="Debe seleccionar una nueva área" onclick="openAreaSelector()" class="form-control" /> <button onclick="return openAreaSelector()" class="btn btn-default" lang="es">Seleccionar área</button>
		</div>
	</div>
	
	<div style="height:10px;"><!--- ---></div>

	<div id="submitDiv">
		<input type="submit" class="btn btn-primary" name="modify" value="Cambiar área" lang="es"/>

		<a href="file.cfm?file=#file_id#&area=#area#" class="btn btn-default" style="float:right" lang="es">Cancelar</a>
	</div>

	<br/>
	<small class="help-block" lang="es">Se enviará notificación por email del del cambio de área del archivo.</small>
</cfform>

</div>

</cfoutput>