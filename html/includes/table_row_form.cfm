<!---page_types
1 Create new row
2 Modify row
--->

<cfinclude template="#APPLICATION.htmlPath#/includes/table_row_form_query.cfm">

<cfset return_page = "#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#">

<cfset url_return_path = "&return_path="&URLEncodedFormat(return_path&return_page)>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>
<div class="div_head_subtitle">
	<span lang="es"><cfif page_type IS 1>Nuevo<cfelse>Modificar</cfif> Registro</span>
</div>

<div class="div_separator"><!-- --></div>

<div class="contenedor_fondo_blanco">
<cfif fields.recordCount IS 0>

	No hay campos definidos para rellenar.

<cfelse>
	<script src="#APPLICATION.htmlPath#/ckeditor/ckeditor.js" type="text/javascript"></script>
	<link href="#APPLICATION.bootstrapDatepickerCSSPath#" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="#APPLICATION.bootstrapDatepickerJSPath#"></script>
	<script type="text/javascript" src="#APPLICATION.htmlPath#/bootstrap/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js" charset="UTF-8"></script>

	<script type="text/javascript">

		function onSubmitForm(){

			// Update textareas content from ckeditor
			for (var i in CKEDITOR.instances) {

			    (function(i){
			        CKEDITOR.instances[i].updateElement();
			    })(i);

			}

			if(check_custom_form())	{
				document.getElementById("submitDiv1").innerHTML = 'Enviando...';
				document.getElementById("submitDiv2").innerHTML = 'Enviando...';

				return true;
			} else
				return false;
		}

	</script>

	<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js"></script>

	<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

	<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" name="row_form" class="form-horizontal" onsubmit="return onSubmitForm();">

		<script type="text/javascript">
			var railo_custom_form=new RailoForms('row_form');
		</script>

		<div id="submitDiv1" style="margin-bottom:10px;">
			<input type="submit" value="Guardar" class="btn btn-primary"/>

			<cfif page_type IS 2>
				<a href="#tableTypeName#_row.cfm?#tableTypeName#=#table_id#&row=#row_id#" class="btn btn-default" style="float:right">Cancelar</a>
			</cfif>
		</div>
		<input type="hidden" name="page" value="#CGI.SCRIPT_NAME#"/>
		<input type="hidden" name="area_id" value="#area_id#"/>

		<!--- outputRowFormInputs --->
		<cfinvoke component="#APPLICATION.htmlComponentsPath#/Row" method="outputRowFormInputs">
			<cfinvokeargument name="table_id" value="#table_id#">
			<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
			<cfinvokeargument name="row" value="#row#">
			<cfinvokeargument name="fields" value="#fields#">
		</cfinvoke>	
		
		<div id="submitDiv2" style="margin-top:20px;">
			<input type="submit" value="Guardar" class="btn btn-primary"/>
			<cfif page_type IS 2>
				<a href="#tableTypeName#_row.cfm?#tableTypeName#=#table_id#&row=#row_id#" class="btn btn-default" style="float:right">Cancelar</a>
			</cfif>
		</div>

		<div style="height:10px;"><!--- ---></div>
		<small lang="es">* Campos obligatorios.</small>
		
	</cfform>

</cfif>
</cfoutput>
</div>