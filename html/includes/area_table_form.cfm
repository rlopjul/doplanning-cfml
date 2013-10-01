<!---page_types
1 Create new table
2 Modify table
--->

<cfinclude template="#APPLICATION.htmlPath#/includes/area_table_form_query.cfm">

<cfset return_page = "#tableTypeNameP#.cfm?area=#area_id#">

<cfset url_return_path = "&return_path="&URLEncodedFormat(return_path&return_page)>

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<script type="text/javascript">

	function confirmDeleteField() {
	
		var message_delete = "Si ELIMINA, se borrarán definitivamente todos los contenidos que almacena. ¿Seguro que desea eliminar todos sus registros?";
		return confirm(message_delete);
	}

	function onSubmitForm(){

		document.getElementById("submitDiv1").innerHTML = 'Enviando...';
		document.getElementById("submitDiv2").innerHTML = 'Enviando...';

		return true;
	}
</script>

<div class="contenedor_fondo_blanco">
<cfoutput>
<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" onsubmit="return onSubmitForm();">

	<div id="submitDiv1" style="margin-bottom:10px;">
		<input type="submit" value="Guardar" class="btn btn-primary"/>

		<cfif page_type IS 2>
			<a href="#tableTypeName#_modify.cfm?#tableTypeName#=#table_id#" class="btn" style="float:right">Cancelar</a>
		</cfif>
	</div>
	<input type="hidden" name="page" value="#CGI.SCRIPT_NAME#"/>
	<input type="hidden" name="tableTypeId" value="#tableTypeId#"/>
		
	<cfif page_type IS 1>
		<input type="hidden" name="area_id" value="#area_id#"/>
	</cfif>

	<label for="label">Nombre</label>
	<cfinput type="text" name="label" id="label" value="#table.label#" maxlength="100" required="true" message="Nombre requerido" class="input-block-level"/>

	<label for="description">Descripción</label>
	<textarea name="description" id="description" class="input-block-level" maxlength="1000">#table.description#</textarea>

	<div id="submitDiv2" style="margin-top:20px;">
		<input type="submit" value="Guardar" class="btn btn-primary"/>
		<cfif page_type IS 2>
			<a href="#tableTypeName#_modify.cfm?#tableTypeName#=#table_id#" class="btn" style="float:right">Cancelar</a>
		</cfif>
	</div>
	
</cfform>
</cfoutput>
</div>