<!---page_types
1 Create new row
2 Modify row
--->

<cfinclude template="#APPLICATION.htmlPath#/includes/table_row_form_query.cfm">

<cfset return_page = "#tableTypeName#_rows.cfm?#tableTypeName#=#table_id#">

<cfset url_return_path = "&return_path="&URLEncodedFormat(return_path&return_page)>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<!---Table fields--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTableFields" returnvariable="fieldsResult">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
	<cfinvokeargument name="with_types" value="true"/>
</cfinvoke>
<cfset fields = fieldsResult.tableFields>

<cfoutput>
<div class="div_head_subtitle">
	<span lang="es"><cfif page_type IS 1>Nuevo<cfelse>Modificar</cfif> Registro</span>
</div>

<div class="div_separator"><!-- --></div>

<div class="contenedor_fondo_blanco">
<cfif fields.recordCount IS 0>

	No hay campos definidos para rellenar.

<cfelse>

	<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

	<script type="text/javascript">
		function confirmDeleteField() {
		
			var message_delete = "Si ELIMINA el campo, se borrarán definitivamente todos los contenidos que almacena. ¿Seguro que desea eliminar el campo?";
			return confirm(message_delete);
		}

		function onSubmitForm(){

			if(check_custom_form())	{
				document.getElementById("submitDiv1").innerHTML = 'Enviando...';
				document.getElementById("submitDiv2").innerHTML = 'Enviando...';

				return true;
			} else
				return false;
		}
	</script>

	<script type="text/javascript" src="#APPLICATION.htmlPath#/scripts/checkRailoForm.js"></script>

	<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" name="row_form" onsubmit="return onSubmitForm();">

		<script type="text/javascript">
			var railo_custom_form=new RailoForms('row_form');
		</script>

		<div id="submitDiv1" style="margin-bottom:10px;">
			<input type="submit" value="Guardar" class="btn btn-primary"/>

			<cfif page_type IS 2>
				<a href="#tableTypeName#_row.cfm?#tableTypeName#=#table_id#&row=#row_id#" class="btn" style="float:right">Cancelar</a>
			</cfif>
		</div>
		<input type="hidden" name="page" value="#CGI.SCRIPT_NAME#"/>
		<input type="hidden" name="area_id" value="#area_id#"/>

		<cfinclude template="#APPLICATION.htmlPath#/includes/table_row_form_inputs.cfm">
		
		<div id="submitDiv2" style="margin-top:20px;">
			<input type="submit" value="Guardar" class="btn btn-primary"/>
			<cfif page_type IS 2>
				<a href="#tableTypeName#_row.cfm?#tableTypeName#=#table_id#&row=#row_id#" class="btn" style="float:right">Cancelar</a>
			</cfif>
		</div>
		
	</cfform>

</cfif>
</cfoutput>
</div>