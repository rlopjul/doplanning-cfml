<!---page_types
1 Create new table
2 Modify table
--->

<cfinclude template="#APPLICATION.htmlPath#/includes/area_table_form_query.cfm">

<cfset return_page = "#tableTypeNameP#.cfm?area=#table.area_id#">

<cfset url_return_path = "&return_path="&URLEncodedFormat(return_path&return_page)>

<cfoutput>
<script src="#APPLICATION.htmlPath#/language/area_item_content_en.js" charset="utf-8" type="text/javascript"></script>

<script src="#APPLICATION.htmlPath#/ckeditor/ckeditor.js" type="text/javascript"></script>
</cfoutput>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<script type="text/javascript">

	function onSubmitForm(){

		<!---document.getElementById("submitDiv1").innerHTML = 'Enviando...';--->
		document.getElementById("submitDiv2").innerHTML = 'Enviando...';

		return true;
	}
</script>

<cfoutput>

<div class="div_head_subtitle">
	<span lang="es"><cfif page_type IS 1><cfif tableTypeGender EQ "male">Nuevo<cfelse>Nueva</cfif><cfelse>Modificar</cfif> #tableTypeNameEs#</span>
</div>

<!---<div class="div_message_page_title">#table.label#</div>--->
<div class="div_separator"><!-- --></div>

<div class="contenedor_fondo_blanco">

<cfinclude template="#APPLICATION.htmlPath#/includes/alert_message.cfm">

<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" onsubmit="return onSubmitForm();">

	<!---<div id="submitDiv1" style="margin-bottom:10px;">
		<input type="submit" value="Guardar" class="btn btn-primary"/>

		<cfif page_type IS 2>
			<a href="#tableTypeName#.cfm?#tableTypeName#=#table_id#" class="btn btn-default" style="float:right">Cancelar</a>
		</cfif>
	</div>--->
	<input type="hidden" name="page" value="#CGI.SCRIPT_NAME#"/>
	<input type="hidden" name="tableTypeId" value="#tableTypeId#"/>
	
	<input type="hidden" name="area_id" value="#table.area_id#"/>
	<cfif page_type IS 2>
		<input type="hidden" name="table_id" value="#table_id#"/>
	</cfif>

	<div class="form-group">
		<label for="label">Nombre</label>
		<cfinput type="text" name="title" id="label" value="#table.title#" maxlength="100" required="true" message="Nombre requerido" class="form-control"/>
	</div>

	<div class="form-group">
		<label for="description">Descripción</label>
		<textarea name="description" id="description" class="form-control" maxlength="1000">#table.description#</textarea>
	</div>

	<div class="form-group">
		<label for="structure_available" class="checkbox">
			<input type="checkbox" name="structure_available" id="structure_available" value="true" <cfif isDefined("table.structure_available") AND table.structure_available IS true>checked="checked"</cfif> /> Permitir copiar la estructura de campos de <cfif tableTypeGender EQ "male">este<cfelse>esta</cfif> #lCase(tableTypeNameEs)#<br/>
			<small class="help-block">Indica si la definición de campos de <cfif tableTypeGender EQ "male">este<cfelse>esta</cfif> #lCase(tableTypeNameEs)# está disponible para ser usada como plantilla por cualquier usuario de la organización.</small>
		</label>
	</div>
	
	<cfif tableTypeId IS 3 AND SESSION.client_administrator EQ SESSION.user_id>
		
		<div class="form-group">
			<label for="general" class="checkbox">
				<input type="checkbox" name="general" id="general" value="true" <cfif isDefined("table.general") AND table.general IS true>checked="checked"</cfif> /> Habilitar como #lCase(tableTypeNameEs)# general<br/>
				<small class="help-block">Se podrá utilizar esta tipología en cualquier área de la organización.</small>
			</label>
		</div>

	</cfif>

	<div id="submitDiv2" style="margin-top:20px;">
		<input type="submit" value="Guardar" class="btn btn-primary"/>
		<cfif page_type IS 2 AND isDefined("URL.area") AND isNumeric(URL.area)>
			<a href="#tableTypeName#.cfm?#tableTypeName#=#table_id#&area=#URL.area#" class="btn btn-default" style="float:right">Cancelar</a>
		</cfif>
	</div>
	
</cfform>
</cfoutput>
</div>

<cfinvoke component="#APPLICATION.htmlComponentsPath#/CKEditorManager" method="loadComponent">
	<cfinvokeargument name="name" value="description">
	<cfinvokeargument name="language" value="#SESSION.user_language#"/>
</cfinvoke>