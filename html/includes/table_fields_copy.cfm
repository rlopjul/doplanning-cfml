<cfinclude template="#APPLICATION.corePath#/includes/tableTypeSwitch.cfm">

<cfif isDefined("FORM.table_id")>
	
	<!---Copy fields--->
	<cfinvoke component="#APPLICATION.htmlComponentsPath#/Field" method="copyTableFields" argumentcollection="#FORM#" returnvariable="actionResponse">
	</cfinvoke>

	<cfset return_page = "#tableTypeName#_fields.cfm?#tableTypeName#=#FORM.table_id#">	

	<cfset msg = urlEncodedFormat(actionResponse.message)>

	<cflocation url="#return_page#&res=#actionResponse.result#&msg=#msg#" addtoken="no">

</cfif>


<cfif isDefined("URL.#tableTypeName#") AND isNumeric(URL[tableTypeName])>
	<cfset table_id = URL[tableTypeName]>
<cfelse>
	<cflocation url="area.cfm" addtoken="false">
</cfif>

<cfset return_page = "#tableTypeName#_fields.cfm?#tableTypeName#=#table_id#">	

<!---Table--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTable" returnvariable="table">
	<cfinvokeargument name="table_id" value="#table_id#">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>

<cfset area_id = table.area_id>

<!---getTablesWithStructureAvailable--->
<cfinvoke component="#APPLICATION.htmlComponentsPath#/Table" method="getTablesWithStructureAvailable" returnvariable="getAreaTablesResponse">
	<cfinvokeargument name="tableTypeId" value="#tableTypeId#">
</cfinvoke>
<cfset tables = getAreaTablesResponse.tables>

<cfinclude template="#APPLICATION.htmlPath#/includes/area_head.cfm">

<cfoutput>
<script type="text/javascript">

$(document).ready(function() {

	<cfif tables.recordCount GT 0>
	loadTableFields(#tables.id#);
	</cfif>

	openUrlHtml2('empty.cfm','itemIframe');

});

function onSubmitForm() {

	if($("##copy_fields_form input:checkbox:checked").length > 0) {
	
		document.getElementById("submitDiv1").innerHTML = window.lang.convert('Copiando...');
		document.getElementById("submitDiv2").innerHTML = window.lang.convert('Copiando...');

		return true;
	
	} else {

		alert("Debe seleccionar al menos un campo para copiar");

		return false;
	}
		
}

function loadTableFields(tableId) {

	if(!isNaN(tableId)){

		$("##areaLoading").show();

		var tablePage = "#APPLICATION.htmlPath#/html_content/#tableTypeName#_fields.cfm?#tableTypeName#="+tableId;

		$("##fieldsContainer").load(tablePage, function() {

			$("##areaLoading").hide();

		});

	} else {

		$("##fieldsContainer").empty();
	}
}
</script>

<div class="div_message_page_title">#table.title#</div>
<div class="div_separator"><!-- --></div>

<cfform action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" enctype="multipart/form-data" name="copy_fields_form" id="copy_fields_form" onsubmit="return onSubmitForm();">
	
	<input name="table_id" type="hidden" value="#table_id#"/>
	<input name="tableTypeId" type="hidden" value="#tableTypeId#"/>

	<div style="padding-left:2px; margin-top:5px;">
	<cfif tables.recordCount GT 0>

		<label for="copy_from_table_id">#tableTypeNameEs# de la que copiar los campos:</label>
		<select name="copy_from_table_id" id="copy_from_table_id" class="span5" onchange="loadTableFields($('##copy_from_table_id').val());">
			<cfloop query="#tables#">
				<option value="#tables.id#">#tables.title#</option>
			</cfloop>
		</select>

	<cfelse>
		No hay #tableTypeNameEs# disponible para copiar campos.
	</cfif>
	</div>

	<div id="fieldsContainer"></div>

	<div style="margin-top:2px;padding-left:2px;"><a href="#return_page#" class="btn" lang="es">Cancelar</a></div>

</cfform>

</cfoutput>